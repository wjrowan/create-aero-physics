# Phase 5 — Resource Economy & Anti-Grind — **FINAL**

**Create Aeronautics Physics Server**
Status: **FINAL — run the gate**
Date: 20 August 2026
Preceding tag: `phase-4-pass`
Entering state: 33 entries
Exit state: **41 entries**, 8 mods added

---

## 1. Final mod list

| # | Mod | Version | Licence | Cut | Role |
|---|---|---|---|---|---|
| 1 | Almost Unified | `1.4.2` | ARR (A-tier only) | 28 | Tag unification, rung 3 |
| 2 | Create: Mob Spawners | `1.1.0` | GPL-3.0 | 29 | Mob drops as a built farm |
| 3 | Create: Enchantment Industry | `2.5.2` | LGPL-3.0 | 31 | XP as a fluid |
| 4 | Create: Dragons Plus | `1.11.7b` | LGPL-3.0 | 32 | Fan processing + CEI dependency |
| 5 | Create Aeronautics: Automated Logistics | `0.6.2` | MIT | 33 | Airships as an automation layer |
| 6 | Create: Break Levitite | `1.1.0` | MIT | 34 | Levitite recovery with Silk Touch |
| 7 | SubBorder | `1.0-SNAPSHOT` | MIT | 35 | Stops sub-levels crossing the border |
| 8 | No Durability | *record exact file* | MIT | 36 | Removes item durability |

**Cut order 30 is vacant** — Ore Excavation's former slot. Left as a gap rather than renumbered; Phase 10 rebases everything.

**Nothing Tier C. Nothing added to `manual/`. One ARR addition** (Almost Unified, already recorded at Phase 0).

**Automated Logistics cut-order inversion:** its number is 33, but if the symptom is ship-related, pull it first regardless. Same rule as SSRD and Sodium for rendering.

---

## 2. Corrections recorded during this phase

Recorded verbatim rather than softened, per process.

| Correction | Detail |
|---|---|
| **Create: Peaceful withdrawn** | Proposed and argued hard in Rev 1. Rejected as cheap and unintentional — a recipe standing in for a machine. The objection was correct on the pack's own terms |
| **Dragons Plus brewing claim retracted** | Rev 2 said it automates brewing and called that "rung 0, solved by design." False. It adds automated-brewing *recipes* for Dragon's Breath fluid, not a brewing machine. Brewing is a vanilla brewing-stand array fed by Create |
| **Ore Excavation config advice retracted** | Rev 1 §4.2 said to raise vein spawn chance in config. Veins are datapack recipes, not a config slider. That instruction was wrong and is why the setting couldn't be found |
| **Mob Spawners mechanic corrected** | Latest version requires **Liquid Regeneration** piped into the spawner, not just rotation. Rev 2's description (rotation only, weakness only) is out of date |
| **World border does not constrain Sable sub-levels** | Confirmed by test. Ships pass straight through **and the player is ejected at altitude while the ship continues**. Phase 4 assumed the border was solid. Closed via SubBorder |
| **World border invisible under shaders** | Confirmed by isolation test — renders with shaders off, not on. No known fix. Added to the Phase 2 shader-artifact list |
| **Ore category closed with no mod** | See §3 |
| **Durability removed entirely** | Accepted. With near-infinite resources it is friction, not economy |

---

## 3. The ore decision — closed, do not reopen at Phase 10

Four candidates tested and rejected:

| Candidate | Verdict |
|---|---|
| Create Ore Excavation | **Rejected after testing.** Veins confusing and far apart, mechanism illegible (drill works anywhere in a chunk), not configurable without datapack work |
| Create ReAutomated + Traces | **Rejected after testing.** No nodes found in the entire world, no config, awkward extraction procedure |
| Create: Quarry | **Rejected on design.** A block that eats a rectangle is the same handout shape as Create: Peaceful |
| Ore Growth | **Rejected.** No confirmable NeoForge 1.21.1 build |

**Resolution: ore stays vanilla mining plus Create's native ~2.4× crushing and washing.** The answer to bulk ore in this pack is a **mining vehicle** — Aeronautics airframe, Create drills, Simulated Thrusters for push, Automated Logistics to fly the ore home. That is Phase 2's *"contraptions cutting through terrain at speed"* charter line with a purpose attached.

This is a deliberate outcome, not a gap to fill later. Two failures shared one root cause — a hidden-discovery step — and the third failed on being too cheap. The category was wrong for this pack.

---

## 4. Configs to set before the gate

| Mod | Setting |
|---|---|
| **Almost Unified** | Create-first mod priority; add `sable`, `create_aeronautics`, `copycats` to ignored mods |
| **Create: Mob Spawners** | **Boss capture OFF.** Set a max-health cap regardless |
| **Automated Logistics** | Do not tune. **Record** default chunk-loading and active-vehicle-limit values for Phase 9.5 |
| **Vanilla ore density** | **Unchanged.** Deliberate |
| **World border warning** | `/worldborder warning distance 200` — test whether the vignette survives shaders. If it does, add to `aerophys-defaults` |

```bash
INST=~/.local/share/PrismLauncher/instances/physics-dev/minecraft
ls "$INST/config" | grep -Ei 'almostunified|spawner|logistic|aal|create-common'
# after editing:
cp -r "$INST/config/almostunified" ~/Source/create-aero-physics/pack/config/
cp "$INST/config/"*spawner* ~/Source/create-aero-physics/pack/config/
cd ~/Source/create-aero-physics/pack && packwiz refresh
```

---

## 5. GATE

**Fresh scratch world.** The world used during mod-swapping has seen too many manifest changes to attribute anything.

### Startup

```
[ ] check.sh clean (Veil-filtered grep)
[ ] Mod count in latest.log = 41
[ ] No missing registry / duplicate mod / dependency / mixin lines
[ ] Create: Mob Spawners loads against Create 6.0.10 (its 1.21.1 branch
    Create floor is UNVERIFIED — this is a real check)
[ ] No Durability and SubBorder both present and not side-mismatched
```

### Durability

```
[ ] No durability bars on tools, armour, weapons
[ ] Deployer with a pickaxe runs indefinitely
[ ] Sand Paper not consumed
[ ] Elytra has no durability — RECORD IT, decide at Phase 6
```

### Border and safety

```
[ ] Ride a ship into the border — DO YOU STAY ON IT?
[ ] Ship stops rather than continuing without you
[ ] No fall, no ejection, no physics blowup, ship still controllable
[ ] Save/quit/reload with a ship parked against the border
[ ] Warning vignette visible at distance WITH shaders on
[ ] Unmanned Automated Logistics route into the border — halts, not lost
```

### Enchantment Industry

```
[ ] Blaze Enchanter, Blaze Forger, Mechanical Grindstone, Printer in creative
[ ] Liquid Experience exists and fills a Fluid Tank
[ ] Blaze Upgrade Smithing Template duplicatable by crafting
[ ]    if NOT → rung-4 datapack override, not KubeJS
[ ] Apotheosis-gated content absent silently
[ ] Deployer / Crushing Wheel kills drop Experience Nuggets
[ ] Experience Lantern on a SABLE sub-level — record behaviour
[ ] Search "brewing" in JEI — confirm Dragons Plus adds recipes only
```

### Dragons Plus

```
[ ] Bulk Sanding polishes a block through an Encased Fan
[ ] Bulk Colouring works
[ ] Dragon's Breath fluid exists
[ ] Fluid Hatch does not dupe against a Create tank (fill, empty, reload)
```

### Mob Spawners — the economy's keystone

```
[ ] Soul Catcher captures a weakened mob
[ ] Identify the regen fluid: create:potion, or a custom mod fluid?
[ ] Item Drain converts bottled Regeneration into that fluid
[ ] Spawner accepts it PIPED from a tank, not just placed by hand
[ ] CONSUMPTION RATE — how much fluid per mob spawned?
[ ] Work back: how many ghast tears per hour does a farm need?
[ ] Does Regeneration II change fluid value?
[ ] Mechanical Harvester works on nether wart
[ ] Spout fills glass bottles with water
[ ] Crushing Wheels kill spawned mobs and drop loot
[ ] Boss capture confirmed DISABLED
[ ] Run a small farm 5 minutes, watch entity count
```

**The consumption rate is the line that decides whether the mob economy is elegant or a treadmill.** If a tear's worth of regen spawns hundreds, it holds. If it spawns three, the ghast farm becomes the grind and we talk about a config.

### Automated Logistics — all six, none optional

```
[ ] 1. Record a route between two stations; it completes
[ ] 2. Run with destination chunks UNLOADED; ship arrives intact
[ ] 3. Save/quit/reload MID-ROUTE; recovers, no ghost blocks, no dupes
[ ] 4. Cargo transfer moves items; no duplication across a reload
[ ] 5. Delete a live station; faults into hold, doesn't corrupt
[ ] 6. REMOVE THE MOD, reload world; world opens, ships are still ships
[ ] Record default chunk-loading and vehicle-limit values
[ ] Controls screen — does it register a keybind?
```

**Criterion 6 decides whether this mod is ever removable.** If it fails, that is a recorded permanence written into the Phase 13 safe-removal list before the real world exists — not a Phase 5 failure.

### Levitite and mining vehicle

```
[ ] Silk Touch pickaxe drops a Levitite block instead of destroying it
[ ] Create drills break blocks when mounted on a SABLE sub-level
[ ]    (different system from a Create contraption — genuinely unknown)
[ ] Ore collection from a moving sub-level into onboard storage
```

### Stability and records

```
[ ] Save, quit, reload, save again
[ ] Controls screen — record any new binds (expect none except possibly AAL)
[ ] Fresh second world picks up aerophys-defaults with no manual action
[ ] COUNT REGISTRIES: creative-tab counts for CEI, Dragons Plus,
    Mob Spawners. Phase 10 wants a pack total
```

**Load and confirm before we continue.**

---

## 6. Records to update on pass

**`docs/lockfile.md`** — eight rows. Exact filenames from
`grep -E "^name|filename" mods/*.pw.toml`. **No Durability's file ID must be recorded** — it was added by `--file-id` and the ID isn't in this document.

**`docs/exceptions-register.md`** — no new rows.

**Phase 12 ARR list** — Almost Unified only. Create: Peaceful's row removed (withdrawn). Automated Logistics resolved to MIT.

**`docs/keymap.md`** — Ore Vein Finder line **deleted** (mod removed). Add: Soul Catcher is an item action; Automated Logistics admin commands under commands.

**Phase 4 corrections list** — two entries:
- *"World border does not constrain Sable sub-levels; players are ejected and ships continue. Confirmed by test at Phase 5. Closed via SubBorder."*
- *"World border wall does not render under Complementary/Iris. Map-based border display is now a Phase 7 requirement."*

**World-defining bucket** — **Automated Logistics alone**, pending criterion 6.

**Phase 9.5 hardening sheet** — four new rows:

| Row | Why |
|---|---|
| Mob Spawner entity caps, **set per-site not globally** | The design is several distributed farms, not one giant one |
| Automated Logistics active vehicle limit | Stops one friend queueing fifty ships |
| Automated Logistics station chunk-loading budget | Must reconcile with the Phase 7 FTB Chunks decision |
| Create bottomless-fluid threshold | Key name and default still unrecorded |

---

## 7. Handed to Phase 6

- **Do NOT use Peaceful difficulty.** Hostile mobs are a resource again
- **Suppress ambient spawning only.** Any mob-quiet mod that also suppresses *spawners* is disqualified — check per candidate
- **Elytra now has infinite durability.** Decide deliberately whether that competes with contraptions as the transport layer
- Death handling, void protection and the five-mod comfort allowlist arrive unchanged
- Simple Voice Chat and sound occlusion: settle whether they count against the cap

## Handed to Phase 7

- **Border must be drawn on the map.** Now a safety requirement, not a preference — the wall is invisible and the border is a hard stop for airships
- **Chunk loading is a three-way decision**: FTB Chunks vs Automated Logistics stations, with remote spawner farms as the case to design against
- Storage on a moving ship is a constraint on the inventory decision
- Durability safety-net mods: **moot**, durability is gone

## Still outstanding from earlier phases

- Version/licence records for Sappy Tree Physics and Ragdoll Reactions — **four phases outstanding now**
- Spikes: Simurail, Dimensional Sable, Custom Nether Portals, Sablewaves, Sappy

---

## 8. Close

```bash
cd ~/Source/create-aero-physics
git add -A
git commit -m "Phase 5: Resource economy & anti-grind — 8 mods, no Tier C

Added: Almost Unified, Create: Mob Spawners, Create: Enchantment Industry,
Create: Dragons Plus, Create Aeronautics: Automated Logistics,
Create: Break Levitite, SubBorder, No Durability.

Withdrawn during the phase: Create: Peaceful (a recipe standing in for a
machine). Create Ore Excavation and Create ReAutomated both cut after
testing; Create: Quarry rejected on design. Bulk ore closed with no mod —
the answer is a mining vehicle.

Durability removed entirely. SubBorder closes a Phase 4 gap: the world
border does not constrain Sable sub-levels and ejects the rider.

Automated Logistics entered by decision against the spike recommendation,
with six gate criteria and a hard version pin."
git tag phase-5-pass
```
