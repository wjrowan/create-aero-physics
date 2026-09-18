# Phase 6 — World Quiet, Death Handling & Comfort — **Rev 3 (FINAL)**

**Create Aeronautics Physics Server**
Status: **Final.** Supersedes Rev 1 and Rev 2. Build and gate against this.
Date: 20 August 2026
Preceding tag: `phase-5-pass`
Entering state: 41 entries
**Exit state: 48 entries on main, 7 mods added. Vista and Ragdoll Revive on branches.**

---

## 1. What changed from Rev 2, and why

Rev 1 and Rev 2 were both substantially rewritten by William's critique. Recording
the reversals rather than quietly shipping the final list.

| Change | Reason |
|---|---|
| **Torchmaster — CUT** | William: regular Minecraft spawning is fine |
| **In Control! — CUT** | Same. Only irreversible half of the decision; see §2 |
| **All gamerule changes — CUT** | `mobGriefing` and `doMobSpawning` stay at vanilla defaults |
| **Patchouli — CUT** | No guidebook of any kind. No FTB Quests either |
| **GraveStone + Sable patch — DEMOTED to fallback** | Superseded by Ragdoll Corpse; kept documented, not installed |
| **Sable: Ragdoll Corpse — ADDED** | Claude rejected it in Rev 1. William overruled. See §4 |
| **Storage Drawers — ADDED** | Claude argued against it twice and was wrong both times. See §5 |
| **Curios API — ADDED** | Goggles under a helmet. Claude was wrong about Create's native support. See §6 |
| **Ragdoll Revive — ADDED to a branch** | Turns the death penalty from material into social. See §7 |
| **Farmer's Delight, Alex's Mobs, furniture pair — CUT** | Recorded in Rev 2, still cut |
| **Comfort allowlist closes at THREE** | Simple Voice Chat, Amendments, Vista |

---

## 2. Job one ships empty — deliberately

Phase 6's first stated job was *turn the threat down*. **It ships with no
mechanism.** No gamerule changes, no spawn suppression, no mob-quiet mod.

This is a deliberate decision, recorded so a future session doesn't read it as an
omission and try to fix it.

**Why it's low-risk:** gamerules are runtime. `/gamerule mobGriefing false` and
`/gamerule doInsomnia false` work in the live world on any day, cost nothing, and
need no pack update. If creepers holing an airship or phantoms interrupting a
build become annoying, the fix is one command, not a freeze exception.

**The one irreversible half:** In Control! is a mod, so adding it post-launch
needs a freeze exception. Accepted price.

**Two runtime flips to keep in the back pocket** — write them in the server
runbook, not the pack:

```
/gamerule mobGriefing false     # creepers stop cratering builds and airships
/gamerule doInsomnia false      # no phantoms during long builds
```

**Known cost if `mobGriefing` is ever set false:** sheep stop eating grass and
never regrow wool. Already covered — vanilla crafts 4 string → 1 wool, and Phase
5's Create: Mob Spawners farms spiders.

**Do not set `doMobSpawning false`.** It would strand the Phase 5 mob economy at
bootstrap: Soul Catchers need a live mob to capture, and an empty Nether means no
ghast tears for the regeneration fluid.

---

## 3. Job two ships empty — also deliberately

**No guidebook. No Patchouli, no FTB Quests, nothing.**

**Consequence Phase 7 must absorb:** the charter requires the keymap in the
install guide *and* the in-game guidebook. There is now no in-game guidebook, so
the keymap lives only in the install guide and README — a file people read once.
In-game discovery falls entirely to Controlling's search and to EMI or JEI as the
de facto map of the pack. Phase 7 is carrying the whole load.

---

## 4. Death handling — Sable: Ragdoll Corpse

### The record

Rev 1 rejected this mod. **William overruled, and the objection is recorded rather
than dropped**, because if it bites, this is where to look.

GitHub `Leo-T22/Sable-Ragdoll-corpse`, checked 20 Aug 2026:

| Issue | Opened | State |
|---|---|---|
| **#6 — despawning a corpse with items inside causes the items to be lost** | 20 Jun 2026 | **Open** |
| #3 — crash when opening a corpse; corpses won't expire | 19 Jun 2026 | Open |
| #10 — empty corpses won't despawn | 29 Jun 2026 | Open |
| #1 — picking up an empty corpse leaves you stuck in holding mode | 16 Jun 2026 | Open |

Eight open, zero closed. Alpha 0.1.0, six commits, ARR, two stars.

**The path through it comes from the bug list itself.** Issues #3 and #10 both say
corpses *fail* to despawn. If despawn can be configured to never, **#6 becomes
unreachable** — nothing despawns, so nothing deletes. That turns the blocker into
a config check, which is criterion 1 below.

### The mod

| Field | Value |
|---|---|
| Name | Sable: Ragdoll Corpse (leonardoinc22 / Leo-T22) |
| Source | Modrinth `sable-ragdoll-corpse` — **Tier A** |
| Version | Alpha `0.1.0`, 15 Jun 2026 — **confirm current version at add-time** |
| Licence | **ARR** → Phase 12 list |
| Side | Both |
| Parent | Sable: Ragdolls (already in pack under Ragdoll Reactions — **confirm it's a discrete ledger entry**) |
| Risk tier | **LOAD-BEARING** |
| Cut order | **37** — pulled first in this phase |

**Curios compatibility is built in** (confirmed by William). The mod's own
description says the corpse displays armour *and accessories* worn by the player.

### Five criteria — decide keep-or-swap at the gate

1. **Despawn can be disabled entirely** via config. **No such option → swap to the
   fallback.**
2. A corpse with a full inventory **survives a stop/start and a chunk
   unload/reload**.
3. It behaves correctly **on a moving sub-level** — the thing it exists for.
4. **Some recovery path exists** for a lost corpse. The charter calls a recovery
   command *required, not nice-to-have*. This is the criterion most likely to fail.
5. **Curios slot contents are captured and returned intact.**

### The documented fallback

If 1 or 4 fail, drop in **GraveStone Mod** (`neoforge-1.21.1-1.0.35`, henkelmax,
ARR, 91M downloads) **plus the Gravestone and Sable Compatibility Patch**
(dactyl, `1.0.0`, MIT) — a single unit, never separated.

That patch fixes a real bug worth knowing about regardless: without it, dying
mid-flight places the grave *and a dirt support block* in the parent world at the
player's visible position, where they clip into the airship's collision shape and
**stall its physics**. An ordinary grave mod in this pack doesn't just misplace
items — it can stop a ship.

GraveStone also brings `/restore <player> <death_id> <replace|add>`, death IDs
written to the server log, and an obituary item with coordinates. It is a strictly
better answer on every requirement except that it isn't a ragdoll.

### Failure cases to check either way

- **On a moving sub-level** — does it stay with the ship?
- **On disassembly or unload** of a ship carrying a corpse?
- **Over lava, deep ocean, the void.**
- **Above build limit** — can an Aeronautics ship exceed world height? If yes,
  Phase 9.5 needs an altitude cap.
- **Interaction with Sable: Ragdolls** — you'll ragdoll *and* leave a corpse.

---

## 5. Storage Drawers — Claude was wrong twice

Argued against on the grounds that Create 6.0.10 absorbed logistics natively.
**That was comparing the wrong two things.** The Stock Keeper is a *network query*
over opaque vaults. A drawer is a *labelled single-item endpoint you can see from
across the room* — a belt terminates in it, contents visible, no menu. Create
doesn't do that job.

It also uses framed drawers — one block with many states — which is better on the
block-count rule than Claude implied.

| Field | Value |
|---|---|
| Source | Modrinth `storagedrawers` / CurseForge — **Tier A** |
| Version | `Storage Drawers-1.21.1-neoforge-13.11.4`, 14 Sep 2025 |
| Licence | **MIT** |
| Side | Both |
| Author | Texelsaur — 236M downloads |
| Risk tier | OPTIONAL |
| Cut order | **40** |

**Costs comfort slot… no.** It has an addon ecosystem, so under the boundary rule
it would cost a slot — but William ruled it in as machine-line infrastructure
rather than comfort. Recorded as a deliberate exception. **No Storage Drawers
addons, ever.**

---

## 6. Curios API — Claude was wrong again

Claude asserted Create doesn't support goggles in a Curios slot, based on a 2021
ticket about someone's manual setup. **Wrong.** Create's own issue tracker (#4403)
documents the Engineer's Goggles working in a Curios head slot; the reported bug
is that with *multiple* head slots, only the topmost works, because Create's code
reads the first head slot specifically.

**So no bridge mod is needed.** Curios plus one head slot, and Create does the rest.

On alternatives: **Baubles is 1.12.2-era and dead, Trinkets is Fabric-only.** On
NeoForge 1.21.1 the answer is Curios.

| Field | Value |
|---|---|
| Source | Modrinth `curios` / CurseForge 309927 — **Tier A** |
| Version | `curios-neoforge-9.5.1+1.21.1`, 14 May 2025. **Pin 9.5.1 exactly** — its changelog fixes a world-load crash when upgrading from 9.4.2 or below |
| Licence | **LGPL-3.0** |
| Side | Both |
| Size | Zero content — no slots, two example items |
| Risk tier | OPTIONAL |
| Cut order | **41** |
| Keybind | **`G`** — Curios GUI. Vanilla-free, Phase 7 places it |

### The one config rule that matters

**Register exactly one head slot.** From Create #4403: with two head slots, the
goggles silently stop working in whichever isn't topmost. That's a failure nobody
would ever diagnose. Comment it next to the slot definition.

### Slot registration

Curios ships no slots by default. The head slot is defined in the pack's own
datapack — repo-authored content under the explicit exception, **rung 4 of the
scripting ladder, no scripting runtime.**

**Confirm the schema path against Curios 9.5.1's own docs before writing the file**
— the slot datapack format changed across the 1.20.x line and this document does
not assert a path it hasn't verified.

**Immediate runtime test that needs no datapack at all:**

```
/curios add head @p
```
then equip Engineer's Goggles in the new slot and look at a kinetic machine. If
the stress overlay appears, the whole approach is confirmed and the datapack is
just making it permanent.

### Gateway flag

Curios is the doorway to every trinket mod in existence. The boundary rule handles
it — a trinket mod costs a comfort slot, and two remain — but naming it once so
it's a decision later rather than a drift.

---

## 7. Ragdoll Revive — branch

**A downed-state mod, not a resurrection mod.** Lethal damage puts you into a
critical state; a friend can revive you, items extend how long you last, and if
nobody comes you die normally.

**Why it fits:** it doesn't weaken the death design — it changes what the penalty
*is*. Solo, nothing changes. With a friend nearby, the cost becomes **social**:
someone stops what they're doing and comes to get you. A real cost that isn't
tedium, on a server of two or three people usually working within sight. It can't
become a shortcut, because being revived doesn't move you anywhere.

| Field | Value |
|---|---|
| Name | Ragdoll Revive (Neim_Ressu) |
| Source | Modrinth `ragdoll-revive` / CurseForge — **Tier A** |
| Version | 1.21.1 NeoForge, ~27 Jul 2026 |
| Licence | **AGPL-3.0** |
| Side | **Server-side** |
| Size | ~1.3K Modrinth downloads — smallest install base of anything considered |

**Chain depth: four.** Sable → Sable: Ragdolls → Ragdoll Corpse → Ragdoll Revive,
with a different author at the last link. Flagged rather than hidden. Mitigating
point: these are physics-core mods, not comfort mods, so the no-addons rule doesn't
bite — but the chain is real.

**Same branch as Ragdoll Corpse. Tested together or not at all** — both hook player
death, by different authors, and that's the top compatibility risk.

### Criteria

1. **Parent mod confirmed as Sable: Ragdolls**, not Sarocesch's *Saro's Player
   Ragdoll*. The description says "Sable Player Ragdoll", which is ambiguous, and
   Saro's has its own competing built-in revive. **Wrong parent → it's out**, since
   using it would mean adding a second ragdoll mod.
2. **No soft-lock.** Downed state always resolves — revived, or times out into a
   real death. Getting stuck downed with no exit is the failure that would actually
   hurt.
3. **Corpse still spawns** when a downed player times out, items intact.
4. **Death-penalty datapack fires** on downed-then-died, and correctly does *not*
   fire on a successful revive.
5. **Downed on a moving airship** — do you stay on the deck or slide off at 200
   blocks up? Check this one first. A friend flying back to catch your downed body
   is either the best thing in this pack or a soft-lock inside a physics simulation.

---

## 8. Safety net — Forgiving Void

| Field | Value |
|---|---|
| Source | Modrinth `forgiving-void` / CurseForge 271009 — **Tier A** |
| Version | `21.1.4+neoforge-1.21.1`, 19 May 2025. **Confirm at add-time whether a NeoForge 21.1.5/21.1.6 exists for 1.21.1** — those numbers exist for Fabric |
| Licence | **ARR** → Phase 12 list |
| Side | **Server-side only** |
| Author | BlayTheNinth — same author as NetherPortalFix, 54M downloads |
| Dependency | **Balm — already in the pack** (Phase 4, cut order 25). Zero new dependencies |
| Risk tier | OPTIONAL |
| Cut order | **43** — pulled last |

Set **`damageOnFallMode = RELATIVE_MAX`** so a percentage of max health is taken,
making the rescue survivable regardless of starting health.

**It saves you, not your ship.** A Sable sub-level is not a vanilla entity, so the
`entityAllowList` won't help — there's no entity to list. William's ruling: the
End isn't the pack's focus and losing a ship there is on you. **Accepted.** The
Phase 9.5 row stays because it's free, and one non-End case remains worth
recording: an Automated Logistics freighter glitching below Y=-64 on a route isn't
quite "on you."

**Second confirmed case of Sable sub-levels ignoring a world boundary that applies
to players.** Phase 5 found the same with the world border.

---

## 9. Comfort allowlist — CLOSED at three of five

| Slot | Mod | Reason |
|---|---|---|
| 1 | **Simple Voice Chat** | Co-op building is the pack's core activity and it's dramatically better with voice |
| 2 | **Amendments** | Changes vanilla block *behaviour* rather than adding blocks |
| 3 | **Vista** | Cameras and monitors are instruments on an airship, not furniture. **Branch, pending Phase 8** |
| 4 | *permanently unspent* | |
| 5 | *permanently unspent* | |

William at close: *"I'm almost feeling like I'm stretching to get five mods."* That
instinct is recorded here so a future session doesn't treat the empty slots as an
invitation. **The cap is a ceiling, not a budget.**

### The boundary rule — written down so it stops drifting

> **A mod costs a comfort slot if it has an addon ecosystem you'd be tempted to
> follow. If it has none, it's a utility and it's free.**

Free under this test: Curios API, Cosmetic Armour Reworked, Tool Belt, Jade, Ping
Wheel, and the client cosmetic cluster.

#### Simple Voice Chat

| Field | Value |
|---|---|
| Source | Modrinth `simple-voice-chat` / CurseForge 416089 — **Tier A** |
| Version | `neoforge-1.21.1-2.6.6`, 17 Oct 2025. Later builds target 1.21.11 and 26.x |
| Licence | **ARR** → Phase 12 list |
| Side | Both. **Every client must match the version exactly** |
| Cut order | **42** |

Phase 9's problem, but test early: UDP **24454** separate from the game port, a
compose mapping, a firewall rule, and the known friction of UDP forwarding through
Docker Desktop on WSL2.

#### Amendments + Moonlight Lib

| Field | Value |
|---|---|
| Author | MehVahdJukaar |
| Version | **BLOCKED — unverified** |
| Licence | **BLOCKED — unverified** |
| Cut order | Amendments **38**, Moonlight Lib **39** (pulled after Amendments, never before) |

Claude rejected Supplementaries on block count *and* dependency chain, then
conceded Amendments because only the second objection applies. The design argument
is William's: a mod that adds behaviour beats one that adds variants.

#### Vista — branch, four criteria

`vista-1.21.1-5.4.4-neoforge`, 18 Aug 2026, Supplementaries Team License 1.5,
Moonlight required, **possibly WaterMedia** (recent versions claim native local-file
support — confirm).

Its changelog says *"improved veil compat with even more hacks."* Veil is embedded
in Sable. Criteria, all at Phase 8 with the full rendering stack:

1. Live feed renders correctly with Complementary running.
2. A camera pointed at a Sable sub-level doesn't corrupt or crash the feed.
3. A monitor **on a moving ship** renders and doesn't stall physics.
4. Frame cost acceptable on Deck-class hardware with a feed active.

Fail any → doesn't merge, slot 3 returns to unspent.

---

## 10. The death-penalty datapack

Rung 4 — plain datapack, no scripting runtime. Lives in `aerophys-defaults`.

```mcfunction
# aerophys-defaults: death penalty
# Problem: vanilla respawn is a free hunger reset and a free trip home.
# Fix: brief debuff + clawed-back hunger. Never touches items.
# Delete this file to remove the penalty entirely.
execute as @a[scores={aerophys.deaths=1..}] run effect give @s minecraft:hunger 8 2 true
execute as @a[scores={aerophys.deaths=1..}] run effect give @s minecraft:slowness 45 0 true
execute as @a[scores={aerophys.deaths=1..}] run effect give @s minecraft:mining_fatigue 45 0 true
scoreboard players reset @a[scores={aerophys.deaths=1..}] aerophys.deaths
```

Requires the objective to exist:

```
/scoreboard objectives add aerophys.deaths deathCount
```

- **Hunger III for 8s** claws back the free meal — closes the stated failure.
- **Slowness I + Mining Fatigue I for 45s** taxes the die-to-get-home shortcut by
  making the arrival worthless.

Starting values, one line each to change.

**Interaction with Ragdoll Revive:** a successful revive should not increment
`deathCount` and so should not fire the penalty. That's criterion 4 on the branch.

---

## 11. BLOCKED — must close before the manifest

| Item | What's needed |
|---|---|
| **Amendments** | Version, licence, Modrinth slug, Moonlight requirement |
| **Moonlight Lib** | Version, Modrinth slug |
| **Sable: Ragdoll Corpse** | Current version number and whether despawn is configurable |
| **Sable: Ragdolls** | Is it a discrete ledger entry, or only present under Ragdoll Reactions? Outstanding since Phase 2 — **close it this phase** |
| **Ragdoll Revive** | Parent mod identity (branch criterion 1) |
| **Forgiving Void** | Whether a NeoForge `21.1.5`/`21.1.6` exists for 1.21.1 |

---

## 12. COMMANDS

### 12.1 Start clean

```bash
cd ~/Source/create-aero-physics
git checkout main
git status                 # must be clean
git log --oneline -1       # should be phase-5-pass
```

### 12.2 Add mods — Modrinth first, Tier A

Modrinth avoids the CurseForge third-party-sharing flag entirely. Only fall to
`packwiz cf add --addon-id X --file-id Y` if a project isn't on Modrinth — **never
slug-based `cf add`.**

```bash
packwiz mr add curios
packwiz mr add storagedrawers
packwiz mr add sable-ragdoll-corpse
packwiz mr add forgiving-void
packwiz mr add simple-voice-chat

# BLOCKED until §11 closes — do NOT guess these slugs:
# packwiz mr add <amendments-slug>
# packwiz mr add <moonlight-slug>

packwiz refresh
```

### 12.3 Verify the pins — freeze policy

`packwiz mr add` takes the latest compatible build, which is **not** necessarily
the version this document pins. Check every one:

```bash
grep -H -E '^(name|filename|side)' mods/*.pw.toml | grep -Ei 'curios|storage|ragdoll|forgiving|voicechat|amendments|moonlight'
```

Expected:

| Mod | Filename must contain | Side |
|---|---|---|
| Curios | `curios-neoforge-9.5.1+1.21.1` | both |
| Storage Drawers | `1.21.1-neoforge-13.11.4` | both |
| Forgiving Void | `forgivingvoid-neoforge-1.21.1-21.1.4` | **server** |
| Simple Voice Chat | `1.21.1-2.6.6` | both |
| Sable: Ragdoll Corpse | confirm against Modrinth | both |

**Any mismatch → pin it explicitly rather than accepting the newer build.** And
re-check the `side = "server"` bug class: Forgiving Void is genuinely server-side;
everything else must read `both`.

### 12.4 Datapack work in `aerophys-defaults`

```bash
# death penalty
$EDITOR <aerophys-defaults>/data/aerophys/function/tick.mcfunction
# curios head slot — CONFIRM SCHEMA PATH against Curios 9.5.1 docs first
```

### 12.5 Build into the dev instance

```bash
packwiz refresh
packwiz serve &            # note the port
# in the physics-dev instance:
#   java -jar packwiz-installer-bootstrap.jar http://localhost:<port>/pack.toml
```

Launch `physics-dev` from Prism in **a fresh scratch world, creative**.

### 12.6 Diagnostics

```bash
tail -n 200 ~/.local/share/PrismLauncher/instances/physics-dev/.minecraft/logs/latest.log
./check.sh                 # Veil-filtered grep
grep -ciE '^\[.*\] \[main/INFO\].*Found mod file' latest.log   # sanity on count
```

### 12.7 Branches — only after main passes its gate

```bash
git checkout -b spike/ragdoll-revive
# packwiz mr add ragdoll-revive ; refresh ; build ; run §13.5 criteria

git checkout main
git checkout -b spike/vista
# packwiz mr add vista_tv ; refresh ; build ; defer criteria to Phase 8
```

### 12.8 Close the gate

```bash
cd ~/Source/create-aero-physics
git checkout main
git add -A
git commit -m "Phase 6: Death handling, safety nets & comfort — 7 mods, no Tier C

Added: Curios API, Storage Drawers, Sable: Ragdoll Corpse, Forgiving
Void, Simple Voice Chat, Amendments, Moonlight Lib.

Job 1 (mob quiet) ships EMPTY by decision — no gamerule changes, no
Torchmaster, no In Control. Gamerules are runtime, so this is fully
reversible in the live world. Job 2 (guidance) ships EMPTY — no
guidebook at all.

Death handled by Sable: Ragdoll Corpse, accepted over Claude's
rejection. Five gate criteria decide keep-or-swap; GraveStone + the
Sable compat patch are the documented fallback. Non-item death penalty
as a plain datapack (rung 4), not KubeJS.

Curios added for goggles-under-helmet — Create supports this natively
(Create #4403). Exactly ONE head slot must be registered or the
goggles silently stop working.

Comfort allowlist opened and CLOSED at three of five. Two slots
permanently unspent. Alex's Mobs cut on design incoherence. Farmer's
Delight cut — proposed by Claude, never requested. Quark, MrCrayfish's
Refurbished, Handcrafted, Supplementaries, Every Compat rejected with
reasons. Pick Your Poison is 1.20.1 Fabric-only; Sinytra Connector
rejected as a class.

Storage Drawers admitted as machine-line infrastructure after Claude
argued against it twice and was wrong both times.

Branches: spike/vista (4 rendering criteria, Phase 8),
spike/ragdoll-revive (5 criteria).

New standing rule: no mod may add wood types."
git tag phase-6-pass
```

---

## 13. GATE — fresh scratch world, creative, single-player

### 13.1 Startup

```
[ ] check.sh clean (Veil-filtered)
[ ] Mod count in latest.log = 48
[ ] No missing registry / duplicate mod / dependency / mixin lines
[ ] Balm resolves for BOTH NetherPortalFix and Forgiving Void — no version split
[ ] Moonlight resolves for Amendments
[ ] Sable: Ragdoll Corpse finds its parent (Sable: Ragdolls)
[ ] Every new .pw.toml has the correct side (see §12.3)
```

### 13.2 Death — core

```
[ ] Die on flat ground. Corpse spawns with all items
[ ] Retrieve corpse — items returned intact
[ ] *** CRITERION 1: config option exists to DISABLE CORPSE DESPAWN ***
[ ]     no such option -> SWAP TO GRAVESTONE + SABLE PATCH
[ ] *** CRITERION 2: corpse with full inventory survives quit/reload ***
[ ] *** CRITERION 2b: survives a chunk unload/reload (travel 200+ blocks) ***
[ ] *** CRITERION 4: a recovery path exists for a LOST corpse ***
[ ]     no recovery path -> SWAP. Charter calls this REQUIRED
[ ] *** CRITERION 5: Curios slot contents captured and returned ***
```

### 13.3 Death — pack-specific

```
[ ] CRITERION 3: die ON A MOVING SABLE SHIP. Corpse stays with the ship.
    SHIP PHYSICS DO NOT STALL
[ ] Fly 500 blocks. Corpse still aboard, items intact
[ ] DISASSEMBLE a ship with a corpse on it. What happens? RECORD
[ ] Save/quit/reload with a corpse on a parked ship
[ ] Die over LAVA — corpse survives
[ ] Die over DEEP OCEAN — corpse retrievable
[ ] Die in the VOID with Forgiving Void temporarily disabled — where does it go?
[ ] *** CAN AN AERONAUTICS SHIP EXCEED BUILD HEIGHT? ***
    If yes, die up there and record. Phase 9.5 altitude row
[ ] Ragdoll and corpse coexist without clipping
```

### 13.4 Curios and goggles

```
[ ] /curios add head @p succeeds
[ ] Engineer's Goggles equip in the head slot
[ ] *** STRESS OVERLAY ACTUALLY APPEARS when looking at a kinetic machine ***
[ ] Goggles work while ALSO wearing a helmet — the whole point
[ ] Only ONE head slot is registered (/curios list or equivalent)
[ ] Curios GUI opens on G
```

### 13.5 Void protection

```
[ ] Walk into the void — fall back from sky, survive
[ ] Set damageOnFallMode = RELATIVE_MAX; survive a rescue at half health
[ ] Fly a ship below Y=-64. Expect it does NOT return. RECORD — Phase 9.5 row
```

### 13.6 Death penalty datapack

```
[ ] Objective aerophys.deaths exists
[ ] Die. Hunger III applies. Food bar does NOT sit at full
[ ] Slowness + Mining Fatigue ~45s, then clear
[ ] Effects do NOT re-apply on reload or relog
[ ] Second death behaves identically
[ ] Deleting the .mcfunction removes the penalty with no residue
```

### 13.7 Comfort and utility

```
[ ] Storage Drawers: drawer accepts a belt output, contents visible externally
[ ] Framing table works
[ ] Amendments: vanilla block behaviour changes visible, no block spam
[ ] Simple Voice Chat: two clients connect and hear each other
    (the only Phase 6 item needing a second machine)
[ ] COUNT REGISTRIES for Storage Drawers and Amendments — Phase 10 wants a total
```

### 13.8 Stability

```
[ ] Save, quit, reload, save again
[ ] Controls screen — record every new bind (expect G from Curios,
    ~5 from Simple Voice Chat, 0 elsewhere)
```

**Load and confirm before we continue.**

---

## 14. Keybind ledger

| Mod | Keybinds | Decision |
|---|---|---|
| **Simple Voice Chat** | Several — push-to-talk, mute, toggle icons, voice menu, group menu | **PTT and mute KEEP, rest UNBIND.** Defaults `V` and `M`, neither vanilla-bound. Phase 7 places them |
| **Curios API** | **1** — GUI on `G` | **KEEP.** Vanilla-free |
| Storage Drawers | None expected | Confirm at gate |
| Amendments | Unknown | Confirm at gate |
| Forgiving Void | None (server-side) | — |
| Sable: Ragdoll Corpse | Unknown | Confirm at gate |

**Logged for Phase 7:** if a client-side armour hider is ever added, Armor
Visibility's default toggle is `V` — colliding with Simple Voice Chat's
push-to-talk.

Phase 6 should cost **three keys**. More is a finding.

---

## 15. Records to update on pass

**`docs/lockfile.md`** — seven rows, exact filenames from §12.3.

**`docs/exceptions-register.md`** — no new rows. **Nothing Tier C. Nothing into
`manual/`.**

**Phase 12 ARR list** — three additions: Sable: Ragdoll Corpse, Forgiving Void,
Simple Voice Chat.

**`docs/keymap.md`** — `G` for Curios; Simple Voice Chat's five binds, two kept
and three unbound; the `V` collision note.

**Standing rules** — add both:
> No mod may add new wood types. Vanilla's eleven are the palette; Create's
> copycats supply texture beyond that.

> A mod costs a comfort slot if it has an addon ecosystem you'd be tempted to
> follow. If it has none, it's a utility and it's free.

**Server runbook** — the two runtime gamerule flips from §2.

**Phase 9.5 hardening sheet** — two new rows:

| Row | Why |
|---|---|
| Aeronautics max altitude vs build height | Corpse/grave behaviour above build limit |
| Sable minimum altitude / below-floor behaviour | Ships aren't covered by void protection |

**Phase 13 safe-removal list** — Sable: Ragdoll Corpse becomes **load-bearing by
use** the moment a corpse exists in the world.

**Close the Phase 2 outstanding record** — Sable: Ragdolls' version and licence.

---

## 16. Handed forward

**Phase 7:** border on the map (safety requirement, from Phase 5); chunk-loading
reconciliation between FTB Chunks and Automated Logistics; Cosmetic Armour
Reworked; Tool Belt (**still faces extend-don't-nest — decide on the mechanism,
not the slot**); Jade + Jade Sable Compat; Ping Wheel; Chat Heads; Controlling;
the keymap now carries the whole discovery load with no guidebook behind it.

**Phase 8:** Sound Physics Remastered; A Good Place; ETF; EMF (requires ETF —
single unit); 3D Skin Layers — **tested as one set, not individually.** ETF's
changelog carries a fix for an inventory-screen crash with 3D Skin Layers active.
"More Animations" is still unidentified. Vista's four criteria.

**Spike branches:** Simurail, Dimensional Sable, Custom Nether Portals, Sablewaves,
Sappy, Grappling Hook: Skybound, Vista, Ragdoll Revive.

**Rejected, recorded:** Quark + Zeta, MrCrayfish's Refurbished, Handcrafted,
Supplementaries, Every Compat, Farmer's Delight, Alex's Mobs, Another Furniture +
createfurnitureseats, Torchmaster, In Control!, Patchouli, FTB Quests, Pick Your
Poison, Sinytra Connector, Sable Pathfinder, Create: Goggle Placement.

**Not a mod:** Complementary Reimagined + Euphoria Patches — locked at Phase 0,
referenced in the install guide, never in the manifest.

---

## 17. Verification log

Confirmed by search on 20 August 2026, not asserted from memory.

| Claim | Source |
|---|---|
| Ragdoll Corpse item-loss bug open | GitHub `Leo-T22/Sable-Ragdoll-corpse` issues |
| Create supports goggles in a Curios head slot; only topmost works | Create issue #4403 |
| Curios `9.5.1+1.21.1`, LGPL-3.0, fixes world-load crash from 9.4.2 | Modrinth + CurseForge |
| Curios adds no slots by default | Curios project description |
| Curios GUI keybind is `G` | Curios GitHub README |
| Storage Drawers `1.21.1-neoforge-13.11.4`, MIT | Modrinth + CurseForge |
| Forgiving Void `21.1.4+neoforge-1.21.1`, Balm required | Modrinth |
| Simple Voice Chat `1.21.1-2.6.6` newest for 1.21.1 | CurseForge |
| GraveStone `neoforge-1.21.1-1.0.35`; void and build-limit cases | Modrinth |
| Gravestone+Sable patch `1.0.0`, MIT; fixes physics stall | Modrinth |
| Ragdoll Revive: 1.21.1 NeoForge, server-side, AGPL-3.0 | Modrinth |
| Saro's Player Ragdoll has its own competing revive | CurseForge |
| Vista `1.21.1-5.4.4-neoforge`; "veil compat with even more hacks" | CurseForge + Modrinth |
| Quark `4.1-482` / Zeta `1.1-40` | Violet Moon forums |
| Pick Your Poison: 1.20.1/1.19.2, Fabric/Quilt only | Modrinth |
| `doMobSpawning` doesn't affect monster spawners | Minecraft Wiki |

**Still unverified — see §11.**
