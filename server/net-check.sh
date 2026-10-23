#!/bin/bash
# Verifies the aerophys server is actually reachable, one rung at a time.
# You are in the `docker` group, so this needs no sudo:
#
#   ~/Source/create-aero-physics/server/net-check.sh
#
# The FIRST failing rung is the bug. Fixing a later rung while an earlier one
# is red is how an afternoon disappears. Nothing here changes any state.
#
# Rung 6 (WAN) is opt-in because it tells a third-party service your public
# address and port:  net-check.sh --wan
set -uo pipefail
cd "$(dirname "$0")"

GAME_PORT=25565
VOICE_PORT=24454
IFACE=$(ip route show default | awk '{print $5; exit}')
LAN_IP=$(ip -4 -brief addr show "$IFACE" | awk '{print $3}' | cut -d/ -f1)
GATEWAY=$(ip route show default | awk '{print $3; exit}')

pass() { printf '  \033[32mOK\033[0m   %s\n' "$1"; }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$1"; FAILED=1; }
warn() { printf '  \033[33mWARN\033[0m %s\n' "$1"; }
rung() { printf '\n\033[1m%s\033[0m\n' "$1"; }
FAILED=0

rung "1. Docker daemon"
if systemctl is-active --quiet docker; then
  pass "docker is running"
else
  fail "docker is inactive — nothing is listening. Run: sudo systemctl enable --now docker"
  echo; echo "Stopping here: every rung below depends on this one."; exit 1
fi

rung "2. Container"
if [ "$(docker inspect -f '{{.State.Running}}' aerophys-mc 2>/dev/null)" = "true" ]; then
  pass "aerophys-mc is up ($(docker inspect -f '{{.State.Health.Status}}' aerophys-mc 2>/dev/null || echo 'no healthcheck'))"
  docker port aerophys-mc | sed 's/^/       /'
else
  fail "aerophys-mc is not running. Run: ./start.sh"
  echo; echo "Stopping here."; exit 1
fi

rung "3. Host listeners"
# 0.0.0.0 (or [::]) matters: a listener bound to 127.0.0.1 is unreachable from
# the LAN no matter how the router is configured.
for spec in "tcp:$GAME_PORT:game" "udp:$VOICE_PORT:voice chat"; do
  IFS=: read -r proto port label <<<"$spec"
  flag=$([ "$proto" = tcp ] && echo -t || echo -u)
  line=$(ss "$flag"lnH "sport = :$port" 2>/dev/null | head -1)
  if [ -z "$line" ]; then
    fail "nothing listening on $port/$proto ($label)"
  elif grep -qE '0\.0\.0\.0|\[::\]|\*:' <<<"$line"; then
    pass "$port/$proto ($label) listening on all interfaces"
  else
    fail "$port/$proto ($label) is bound to a single address, not 0.0.0.0: $line"
  fi
done

rung "4. Loopback handshake"
if timeout 3 bash -c "</dev/tcp/127.0.0.1/$GAME_PORT" 2>/dev/null; then
  pass "TCP $GAME_PORT accepts connections locally"
else
  fail "TCP $GAME_PORT refused locally — the server itself is the problem, not the network"
fi

rung "5. LAN"
echo "       interface $IFACE   address $LAN_IP   gateway $GATEWAY"
if timeout 3 bash -c "</dev/tcp/$LAN_IP/$GAME_PORT" 2>/dev/null; then
  pass "TCP $GAME_PORT reachable on the LAN address — this is the router's forward target"
else
  fail "TCP $GAME_PORT refused on $LAN_IP — host firewall, not the router"
fi
CONN=$(nmcli -t -g NAME,DEVICE c show --active 2>/dev/null | grep ":$IFACE\$" | cut -d: -f1)
if [ -n "$CONN" ] && [ "$(nmcli -g ipv4.method c show "$CONN" 2>/dev/null)" = "auto" ]; then
  warn "$LAN_IP is a DHCP lease, not a reservation. The router's forward will"
  warn "break silently when this address moves. Pin it to MAC $(cat /sys/class/net/"$IFACE"/address)"
fi

rung "6. WAN"
if [ "${1:-}" != "--wan" ]; then
  echo "       skipped (pass --wan to run; it discloses your IP and port to a"
  echo "       third-party probe). The definitive test is a friend connecting."
else
  PUBIP=$(timeout 10 curl -s https://ifconfig.me)
  echo "       public address: $PUBIP"
  case "$PUBIP" in
    100.6[4-9].*|100.[7-9][0-9].*|100.1[01][0-9].*|100.12[0-7].*)
      fail "that is a carrier-NAT address (100.64.0.0/10). Port forwarding CANNOT"
      fail "work from here — the forward has to happen on hardware you do not own." ;;
    *) pass "a real public address, not carrier NAT — forwarding is possible" ;;
  esac
  echo "       Now check the router's WAN address matches $PUBIP. If the router"
  echo "       shows 10.x / 192.168.x / 100.64-127.x, there is a second NAT above"
  echo "       you and no forward will ever work."
fi

echo
[ "$FAILED" = 0 ] && echo "All checked rungs green." || echo "Fix the FIRST red rung above, then re-run."
exit "$FAILED"
