# aerophys server — operator runbook

Read this before you touch the server at 1am. Full reasoning lives in
`docs/phase-9-server-ops.md`; this is the condensed version for incidents.

**Deviation from the phase 9 brief, recorded so it isn't rediscovered as a
bug:** `PACKWIZ_URL` points at the `main` branch, not a dedicated `release`
branch. Clients already pull the pack from `main` (see `pack/` on GitHub), so
the server matches what's actually in use rather than the brief's original
recommendation. Practical consequence: **every push to `main` changes what
the container installs on its next restart.** There is no separate freeze
point — the freeze discipline (never bump a pinned version, never add an
unlisted mod) has to hold on `main` itself.

---

## Start / stop / logs

```bash
docker compose up -d
docker compose logs -f mc
docker compose attach mc        # console; Ctrl-P Ctrl-Q to detach
docker compose stop mc          # allow up to 5 minutes — do not SIGKILL
```

---

## Restoring from backup (§8.3)

This is also the migration procedure below — every restore test doubles as a
migration rehearsal.

**The brief's original procedure (`restore-backup`, empty just the world
volume) does not work with this image version — verified by actually running
it, not assumed.** Three real gotchas, found during the Phase 9 gate:

1. The restore binary is `restore-tar-backup` (matches `BACKUP_METHOD=tar`),
   not the generic `restore-backup` the brief names.
2. `restore-tar-backup`'s "already restored, nothing to do" check is
   `ls "$SRC_DIR" | wc -l == 0`, and `SRC_DIR` defaults to `/data` — the
   *whole* thing, not just `/data/world`. Because `mc-world` is nested inside
   `mc-data` (deliberately, so it shadows by path depth — see
   `docker-compose.yml`), `ls /data` always shows a `world` entry even when
   that subtree is empty. So the check can **never** see `/data` as empty
   through the normal flow, and the script always says "No restore needed."
3. The `backup` service's volumes are mounted `:ro` (correct for taking
   backups) — but that means `docker compose run --entrypoint
   restore-tar-backup backup` can't write anything even if step 2 didn't
   block it first.

**What actually works**, matching what `mc-data` is supposed to be
(disposable, rebuilt from `PACKWIZ_URL` every start) rather than fighting the
backup tool:

```bash
# 1. Stop the server. Do not skip this.
docker compose stop mc

# 2. Wipe BOTH volumes. mc-data is disposable — packwiz + the NeoForge
#    installer rebuild it on next start. This is the irreversible step for
#    mc-world — be sure you have a good backup first.
docker run --rm -v aerophys_mc-data:/data -v aerophys_mc-world:/data/world \
  alpine sh -c 'rm -rf /data/* /data/.[!.]*'
docker run --rm -v aerophys_mc-world:/world \
  alpine sh -c 'rm -rf /world/* /world/.[!.]*'

# 3. Restore ONLY world/ from the tarball straight into the mc-world volume.
#    (EXCLUDES already drops mods/libraries/cache from backups — they were
#    never going to be usable to restore anyway, since NeoForge's own
#    installed jars are excluded too. Let step 4 rebuild all of that.)
docker run --rm -v aerophys_mc-world:/target -v /srv/mcbackups:/backups:ro \
  --entrypoint sh itzg/mc-backup:2026.8.2 \
  -c 'tar xf /backups/latest.tar.zst -C /target --strip-components=2 ./world'

# 4. Start. This does a full packwiz + NeoForge reinstall (mc-data is empty),
#    then loads the restored world. First boot after a restore is as slow as
#    a first-ever boot.
docker compose up -d mc
docker compose logs -f mc
```

**Verification is not "the container started."** Join, fly to a known
contraption, and confirm it's there and behaves. A world that loads with
every Sable body missing has technically restored.

Manual backup before any deliberate change:

```bash
docker compose exec backup backup now
```

---

## Migrating to different hardware (§9.1)

The migration procedure and the disaster-recovery procedure are the same
procedure.

```bash
# On the old host
docker compose exec backup backup now          # fresh, coordinated backup
docker compose down

# Copy to the new host: the repo (git clone) and the newest tarball
# from ${BACKUP_DIR}. That is everything. There are no jars to move.

# On the new host
git clone <repo> && cd create-aero-physics/server
cp ../.env.example .env && $EDITOR .env        # adjust HEAP / MEM_LIMIT / BACKUP_DIR
mkdir -p "${BACKUP_DIR}" && cp /path/to/backup.tgz "${BACKUP_DIR}/"
printf '%s' '<rcon password>' > rcon_password

docker compose up -d mc && docker compose stop mc   # creates empty volumes
docker run --rm -v aerophys_mc-world:/target -v "${BACKUP_DIR}:/backups:ro" \
  --entrypoint sh itzg/mc-backup:2026.8.2 \
  -c 'tar xf /backups/latest.tar.zst -C /target --strip-components=2 ./world'
docker compose up -d mc
```

See "Restoring from backup" above for why this skips `restore-tar-backup`
and extracts `world/` directly.

The whole server is the repo plus one tarball. Mods, configs and the loader
come back from `PACKWIZ_URL`; the world comes back from the backup;
`server.properties` regenerates from `.env`.

**If moving Windows → Linux**, the repo's `.gitattributes` `* -text` line is
what stops git rewriting line endings and breaking packwiz hashes. Don't
remove it because "the server is Linux now" — it may still be cloned on
Windows.

---

## Simple Voice Chat (§9.2)

- `24454:24454/udp` must be mapped — TCP will not do. A missing UDP mapping
  is the most common cause of "voice silently doesn't work," and it presents
  as a not-connected icon while the game itself is fine.
- Router and firewall need UDP 24454 forwarded too, to the same public
  address as the game port.
- `voice_host` in the mod's server config may need setting to the public
  address if clients connect but voice doesn't. Try without it first.
- UDP forwarding through Docker on WSL2/Docker Desktop is a known friction
  point — test it before move day, not on it.
- The two-machine test needs a second human on a second machine; it's not
  something to run solo.

---

## Diagnosing a problem, in order (§9.4)

1. `docker compose logs --tail=200 mc` — the last thing before it went wrong
2. `/shtreimel rank` or `physics-stats` — **which contraption**
3. `/shtreimel freeze <uuid>` — stop the bleeding without `/stop`
4. `/spark profiler start`, 60 seconds under the load, `/spark profiler stop`
   — **which code**
5. `/shtreimel history <uuid>` — if something vanished, what happened to it
6. `/shtreimel audit since 1h` — if something was removed, who removed it
7. Crash reports: `/data/crash-reports/` inside `mc-data`, and the
   `-- Shtreimel snapshot --` block is at the bottom. `/shtreimel debug
   crash-header` previews it without crashing anything

Logs live at `/data/logs/latest.log` and `/data/crash-reports/` in the
`mc-data` volume: `docker compose exec mc ls /data/logs`.

---

## Permissions (§9.3)

Friends are **not** ops. Shtreimel's destructive commands sit at op 3 and
`--confirm` bypass at op 4 — non-op friends can build freely but can't
`delete` a contraption or run `/sable remove`. Whitelist is on. Edit
`WHITELIST` / `OPS` in `docker-compose.yml` before anyone joins.

---

## Distant Horizons

DH generates its own `config/DistantHorizons.toml` on the server at first
boot — it is **not** shipped from the repo (standing rule: never commit a
config a mod rewrites at runtime). Edit it in place inside the running
container, then restart. See `docs/phase-9-server-ops.md` §4 and §10 for the
full reasoning; the short version: distant generation stays **on** on both
sides, `Distance Generator Mode = Full` so pregen writes real chunks as well
as LODs, nether/end stay ignored.

Pregen from the server console:

```
/dh pregen start overworld 0 0 <radius>
```

Radius 160 matches the world border (§13 of the ops doc) — that's the full
production run. Use a small radius first (e.g. 16) to sanity-check timing
and disk cost before committing to 160.
