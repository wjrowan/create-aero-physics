# Phase 4 — Worldgen

**Create Aeronautics Physics Server**
Status: **PROPOSED — awaiting gate**
Date: 19 August 2026
Preceding tag: `phase-3-pass`

---

## 1. Summary

Phase 4 opened as a decision phase and ran long, because the direction chosen on
reasoning failed on inspection and had to be reversed.

**Final direction: vanilla overworld terrain, amplified Nether, bounded world,
compressed biome scale, denser structures.**

Five mods and one library. **Zero blocks and zero items registered between
them.** No ARR world-defining jar, nothing added to `manual/`, no preset file to
freeze, no `level-type` to carry as container state.

---

## 2. Decision record

### 2.1 Directions considered

| Direction | Outcome |
|---|---|
| A — Enhanced vanilla (Tectonic) | Not tested. Rejected by preference during the sky-island reversal |
| B — Sky islands over void (Aero Islands) | Rejected at decision time: void deaths, exploration-gated ore, navigation at low render distance |
| C — Extended vertical world | Deferred, then closed. Overworld stays vanilla −64/320 |
| D1 — Normal terrain + floating-island content mod | Rejected on philosophy: Ember's Floating Islands ships dungeon and hostile-encounter content |
| **D2 — Archipelago over ocean (Sky Archipelago)** | **Chosen, built, tested, REVERSED** |
| **Vanilla terrain** | **ADOPTED** |

### 2.2 Sky Archipelago — tested and rejected

Chosen on reasoning: ocean instead of void kept the airship-as-transport-layer
gameplay while removing the void-death failure mode; zero registry cost; a large
config surface; and it gave Create: High Seas a job.

Generated on file ID `8481456`, CurseForge project `1528077`.

**Result recorded verbatim:**

> "the world gen looks really bad, the ocean is to small the islands dont have
> that kind of reversed cone shape you come to expect from sky islands they are
> like bad round blobs... they are way to small and way to close to eachother
> not flat enough tops i want it to feel like your not on and island on the
> island just on the edge"

> "i think its all pretty terrible i am airing towardsd just vanilla terrain"

Tuning was proposed and **not exhausted** — satellite islands were never
disabled, sizing was never weighted to large, and the Bowl/Crater and Crescent
archetypes were never turned off. The reversal is a judgement on the look and on
buildability, not a demonstration that the mod cannot be tuned. **Recorded as
such so the decision is honest if it is ever revisited.**

### 2.3 Why the reversal was correct anyway

Independent of the visual result, the direction conflicted with a locked Phase 0
constraint: **this is a builder's pack.** Sky islands impose a build-site
constraint by construction — finite footprint, cannot dig down, cannot expand
sideways, and every base bounded by a generator's shape function. That was
under-weighted at recommendation time.

**Adopting vanilla removed, at no cost:**

- The pack's only world-defining ARR jar — one where a delisting means the world
  never opens again
- The highest-stakes `manual/` archive row
- A preset file requiring freeze before Phase 11, committed or permanently lost
- `level-type=` as required container state at Phase 9
- The compromise on the Phase 0 line *"structure density: guaranteed, not
  sparse — old-style generation feel"*, which vanilla plus a structure-density
  datapack honours exactly as written

Phase 4 went from the riskiest phase in the build to one of the safest.

### 2.4 The Nether carries the contraption case

The reversal did not weaken the pack's premise, because the argument for
contraption travel had already moved to the Nether:

- **1:1 coordinate scale** — portal travel confers no distance advantage.
  Nether highways as fast travel are eliminated. Travel is contraptions, not
  warping
- **Amplified terrain** — dense, vertical, hostile to walking
- **Portals as local access points** — reaching a distant Nether region means
  travelling the overworld and building a second portal there, so the overworld
  remains the travel layer

The overworld can therefore afford to be the place you build.

### 2.5 Locked decisions

| Decision | Value |
|---|---|
| Overworld generation | **Vanilla** |
| Overworld height | **Vanilla, −64 to 320.** §2C closed |
| Nether generation | **Amplified Nether** — terrain generates to 256 |
| Nether height | **Amplified Nether Height.** Build height 384, logical height 256 |
| Nether coordinate scale | **1:1**, via datapack |
| World border | **5120 × 5120**, all three dimensions, spawn-centred |
| Biome scale | **4× smaller (1/4 size)**, overworld only. Confirmed by inspection |
| Structure density | **Increased**, via datapack |
| Steam 'n' Rails | **Dropped.** Registry bloat. Definitive |
| Simulated Thrusters | **Stays cut.** Parking condition ("punishing gaps") never arose |
| Simurail | **Kept.** Base track, bridges, complements Coasters. Remains `manual/` |

**Border rationale:** 5120 × 5120 matches the Legacy Console Edition large world.
±2560 comfortably contains the vanilla stronghold ring, so End access needs no
expansion. Expanding a border later is free and non-destructive; shrinking is
not. This is the only Phase 4 setting that is not a one-way door.

**Phase 0 grant closed:** *"Phase 2/3 mods touching worldgen or dimensions enter
as PROVISIONAL, re-confirmed at Phase 4."* Nothing in Phases 2 or 3 was flagged
on those grounds. Nothing to re-confirm.

---

## 3. Mods

### 3.1 Amplified Nether

| Field | Value |
|---|---|
| Name | Amplified Nether (Stardust Labs / Starmute) |
| Source | Modrinth `amplified-nether` (`wXiGiyGX`) / CurseForge |
| Version | `v1.2.11 ~ Mod 1.21.x` — newest confirmed 1.21.x build. **Check for newer still listing 1.21.1 before pinning** |
| Tier | A |
| Licence | Stardust Labs License (custom). **Read before committing** |
| Side | Server-side / singleplayer. Take the **mod** build, not the datapack zip. Set `side = "both"` |
| Size | **Zero.** No biomes, items, mobs or structures — terrain only |
| Role | Amplified, vertically dramatic Nether terrain with 3D biomes |
| Risk tier | **LOAD-BEARING — world-defining** |
| Cut order | **None.** Never removable |
| Known conflicts | Not compatible with Incendium (not in pack). Author: do not add to an existing Nether |

**Why never removable:** once the Nether is generated, removing it makes new
chunks generate vanilla, producing seams, and reverts any height change made to
the dimension type.

### 3.2 Amplified Nether Height

| Field | Value |
|---|---|
| Name | Amplified Nether Height (fliplus) |
| Source | Modrinth / CurseForge, `amplified-nether-height` |
| Version | `amplified-nether-height-1.2+datapack.jar` — 1.18.2–1.21.10, 21 Apr 2025. Newer releases target 26.x only |
| Tier | A |
| Licence | **MIT** |
| Side | Server-side / singleplayer. Set `side = "both"` |
| Size | **Zero** |
| Role | Build height 384, logical height 256. Touches no generation |
| Risk tier | OPTIONAL — see note |
| Cut order | **27** |
| Known conflicts | Writes `data/minecraft/dimension_type/the_nether.json`, the same file `aerophys-defaults` forks |

**Reinstated after being dropped mid-phase.** The reason for keeping it is
`logical_height: 256` — vanilla's 128 prevents portals linking above that, and
the Nether now generates to 256.

**It is not the mechanism, and this matters for debugging.** Both this mod and
`aerophys-defaults` write the same `the_nether.json`, and the datapack loads
later, so **the datapack's values are the ones that apply.** The mod is
belt-and-braces: it documents intent and covers the case where the datapack is
dropped, but it cannot fix a datapack carrying the wrong numbers.

**Consequence:** it is *not* in the never-removable bucket, because removing it
changes nothing while the datapack is present. The datapack's `the_nether.json`
is the never-removable artefact.

**Required values in `aerophys-defaults/data/minecraft/dimension_type/the_nether.json`:**

```
"min_y":            0
"height":           384      (must be a multiple of 16)
"logical_height":   256
"coordinate_scale": 1.0
```

If Step 2 of the datapack build forked vanilla rather than a mod copy, this file
will read `logical_height: 128` and `height: 256`. Reinstalling the mod does not
correct that — set the values directly.

### 3.3 Biome Sizes

| Field | Value |
|---|---|
| Name | Biome Sizes (someaddon) |
| Source | CurseForge `biomesize`. **Try `packwiz mr add biomesize` first** — Modrinth listing unconfirmed |
| Version | `biomesize-1.21.1-1.6.jar`, NeoForge, 11.0 KB, 28 Jan 2026 |
| Tier | A |
| Licence | **Unverified** |
| Side | Server-side generation. Set `side = "both"` |
| Size | **Zero blocks, zero items** |
| Role | Compresses overworld biome scale so a 5120 world holds the variety of a much larger one |
| Risk tier | **LOAD-BEARING — world-defining** |
| Cut order | **None.** Never removable |
| Known conflicts | Author states none known; should work with any mod respecting worldgen datapack settings |

**Configuration: overworld only, 4× smaller (1/4 size). Leave the Nether at
default** — Amplified Nether leans on 3D biomes and compressing those
horizontally produces a mess rather than variety.

**Set by inspection, not by recommendation.** 2× was proposed on the reasoning
that anything tighter would produce patchwork. 4× was generated, looked at, and
preferred. The tested value wins — and 4× is arguably the more faithful answer
to the Phase 0 line about old-style generation feel, since pre-1.18 biome scale
was closer to this than to modern vanilla.

**Two consequences to watch rather than pre-empt:**

- Biome-locked resources and mob spawns get patchier. A biome may be too small
  to site a biome-dependent farm in — a Phase 5 concern, not a Phase 4 one
- 4× biomes stacked on halved structure spacing (§4.6) may read as crowded
  rather than dense. **Generate with the biome setting first and look at it
  before applying the structure pass**, so the two are attributable separately

**Honest limit:** smaller biomes makes rare biomes *likelier*, not guaranteed.
Badlands, jungles, mushroom fields and deep dark are rare because of their
position in the multi-noise climate space, not because biomes are large.

**No-mod alternative, if the mod is ever dropped:** edit `xz_scale` in
`data/minecraft/worldgen/density_function/overworld/{base_erosion,temperature,vegetation}.json`.
Higher values give smaller biomes; 0.5 is 4× smaller. Change only `xz_scale`.

### 3.4 NetherPortalFix

| Field | Value |
|---|---|
| Name | NetherPortalFix (BlayTheNinth) |
| Source | Modrinth `netherportalfix` / CurseForge project 241160 |
| Version | `21.1.1+neoforge-1.21.1`, 13 Aug 2024, covers 1.21–1.21.1 |
| Tier | A |
| Licence | **All Rights Reserved** → Phase 12 ARR list. 132M+ CurseForge downloads; delisting risk minimal. `manual/` archival optional |
| Side | Server-side only, works in singleplayer. Costs clients nothing |
| Size | Zero |
| Role | You exit the portal you entered |
| Risk tier | OPTIONAL |
| Cut order | **24** |
| Dependency | **Requires Balm.** Single unit |

**Scope flag:** outside the Create and physics core. Justification: at 1:1 with
portals as local access points, a wrong-portal return drops you somewhere you
did not build, potentially far from your ship. Load-bearing for the design, not
QoL.

### 3.5 Balm

| Field | Value |
|---|---|
| Name | Balm (BlayTheNinth) |
| Source | Modrinth `balm` |
| Version | Resolves at add-time via packwiz dependency prompt. **Record the exact build in the lockfile** |
| Role | Library. NetherPortalFix dependency |
| Risk tier | LOAD-BEARING (for NetherPortalFix only) |
| Cut order | **25** — leaves with NetherPortalFix |

### 3.6 Global Packs

| Field | Value |
|---|---|
| Name | Global Packs (JTK222) |
| Source | Modrinth `globalpacks` / CurseForge |
| Version | `v21.0.6 - NeoForge - 1.21-1.21.1`, 9 Jun 2025. Verify nothing newer targets 1.21.1 |
| Tier | A |
| Licence | **Unverified** |
| Side | Both |
| Size | Zero |
| Role | Loads datapacks from `<instance>/datapacks/` into every world automatically |
| Risk tier | OPTIONAL |
| Cut order | **26** — pulled last, since it carries `aerophys-defaults` |
| Known conflicts | None documented |

**Chosen over Paxi** on install base (39.7M vs 4.6M) and Modrinth availability.
NeoForge documentation confirms there is no built-in way to apply datapacks to
every world, so a mod is required for this.

**Scope flag:** outside the core. Justification: it is the delivery mechanism
for pack-authored config, which the distribution principle already carves out.
Without it, every scratch world needs a manual copy.

**Load-bearing by content, not by code:** pull it and borders, Nether scale and
structure density all stop applying.

---

## 4. The `aerophys-defaults` datapack

First pack-authored datapack in the build. Lives in the repo — the one category
the distribution principle permits as files.

```
pack/datapacks/aerophys-defaults/
├── pack.mcmeta
└── data/
    ├── aerophys/function/load.mcfunction
    ├── aerophys/function/init.mcfunction
    ├── minecraft/tags/function/load.json
    ├── minecraft/dimension_type/the_nether.json
    └── minecraft/worldgen/structure_set/*.json
```

### 4.1 pack.mcmeta

```json
{ "pack": { "pack_format": 48, "description": "Create Aeronautics Physics Server - world defaults" } }
```

**`pack_format` 48 is unverified for 1.21.1.** A wrong value makes the pack fail
silently. `/datapack list` at the gate is the check.

### 4.2 Function tag — `data/minecraft/tags/function/load.json`

```json
{ "values": ["aerophys:load"] }
```

Folder is `function`, **singular**, since 1.20.5. The usual reason a datapack
does nothing.

### 4.3 `load.mcfunction` — runs every load, acts once

```mcfunction
scoreboard objectives add aerophys.init dummy
execute unless score #init aerophys.init matches 1 run function aerophys:init
```

### 4.4 `init.mcfunction` — runs once per world, ever

```mcfunction
worldborder center 0 0
worldborder set 5120
worldborder damage amount 0
worldborder warning distance 32

execute in minecraft:the_nether run worldborder center 0 0
execute in minecraft:the_nether run worldborder set 5120

execute in minecraft:the_end run worldborder center 0 0
execute in minecraft:the_end run worldborder set 5120

scoreboard players set #init aerophys.init 1
```

**The once-only guard is load-bearing.** Without it, every reload stamps the
border back to 5120 and silently undoes any later expansion.

`worldborder damage amount 0` is deliberate — in a flying pack, drifting into
the border should not kill anyone. Same family as void protection.

**At 1:1 the Nether border must be ≥ the overworld border.** Portals map
coordinates directly, so a portal built at the overworld edge lands at the same
Nether coordinate. A smaller Nether border would strand it. Equal is correct.

**Unverified:** whether `execute in <dimension> run worldborder` sets a
per-dimension border, or whether all dimensions share one. See §6.

### 4.5 `the_nether.json` — the 1:1 override

`coordinate_scale` lives in the dimension type. A dimension type must be
**complete** — a partial file is invalid — so this is a fork-and-edit, never a
hand-write.

```bash
INST=~/.local/share/PrismLauncher/instances/physics-dev/minecraft
unzip -l "$INST"/mods/*mplified*ether*.jar | grep -E 'dimension_type|noise_settings'
```

- **Ships `the_nether.json`** → fork that copy. Its height values are
  load-bearing for the terrain it generates
- **Ships only `noise_settings`** → fork the vanilla `the_nether.json`

Getting this backwards produces amplified terrain generating into a
vanilla-sized box.

```bash
DT=~/Source/create-aero-physics/pack/datapacks/aerophys-defaults/data/minecraft/dimension_type
mkdir -p "$DT"
cp <the file you found> "$DT/the_nether.json"
sed -i 's/"coordinate_scale": *8\(\.0\)\?/"coordinate_scale": 1.0/' "$DT/the_nether.json"
grep -E 'coordinate_scale|logical_height|"height"|min_y' "$DT/the_nether.json"
```

`coordinate_scale` must read `1.0`. Height fields must match the source, not
vanilla.

**Load order:** ensure `aerophys-defaults` outranks mod-supplied data in the
Global Packs config. Set it explicitly rather than relying on alphabetical order.

**Note:** if `logical_height` remains 128 while terrain generates higher,
portals will not link above 128. Not a problem — worth knowing rather than
discovering.

### 4.6 Structure density

Each type has a `structure_set` with `spacing` and `separation`, in chunks.
Lower spacing = more structures. Separation must always be less than spacing.

**Copy the real vanilla files and edit one field.** The `structures` list and
`salt` must stay untouched, or you change which structures generate and re-roll
every placement. 1.21.1 may not ship worldgen JSON in the client jar — pull from
the published vanilla worldgen export if not.

**Rule rather than absolute values:** halve the `spacing` found, set
`separation` to roughly a third of the new spacing, minimum 4.

**First pass — the "old-style generation feel" core:**

```
minecraft:villages
minecraft:pillager_outposts
minecraft:ruined_portals
minecraft:desert_pyramids
minecraft:igloos
minecraft:jungle_temples
minecraft:swamp_huts
minecraft:woodland_mansions      ← worth halving twice
minecraft:nether_complexes       ← fortresses and bastions; matters more at 1:1
```

**Leave `minecraft:strongholds` alone.** Different placement type — concentric
rings, not a spread grid. At ±2560 the vanilla ring already falls inside the
border.

**Do not halve everything blindly.** Ocean monuments and ancient cities at
double density become oppressive, and this is a quiet-world pack.

**Reversibility — unusually good.** Structure placement only affects chunks
generated after the change, so this can be tuned post-launch for unexplored
ground. Unlike biome scale, it does not join the never-removable bucket.

---

## 5. Procedure

### 5.1 Pre-flight

```bash
cd ~/Source/create-aero-physics
git status                    # clean, phase-3-pass tagged
ls manual/                    # simurail jar present
```

**New scratch world for this phase.** Standing rule.

### 5.2 Add mods

```bash
cd ~/Source/create-aero-physics/pack

packwiz mr add amplified-nether
packwiz mr add amplified-nether-height
packwiz mr add netherportalfix        # accept the Balm dependency
packwiz mr add globalpacks
packwiz mr add biomesize              # falls back to CurseForge if absent

packwiz refresh
```

Confirm Amplified Nether resolved to the **mod jar**, not a datapack zip:

```bash
grep -H filename mods/*amplified-nether*.pw.toml
```

If wrong, remove and re-add by pasting the exact Modrinth **version page URL**.

**Standing `side` fix** — the Physics Compat / Simulated Thrusters bug class.
Nothing in this pack should be `side = "server"`; the dev instance is
singleplayer, where the client is the server.

```bash
grep -l '^side = "server"' mods/*.pw.toml                                  # look first
sed -i 's/^side = "server"/side = "both"/' $(grep -l '^side = "server"' mods/*.pw.toml)
grep -l '^side = "server"' mods/*.pw.toml || echo "clean"
packwiz refresh
```

### 5.3 First launch — pull jars

```bash
packwiz serve
```

Launch `physics-dev`, **quit at the main menu.** Then:

```bash
INST=~/.local/share/PrismLauncher/instances/physics-dev/minecraft
ls "$INST/mods/" | grep -Ei 'amplified|netherportal|globalpacks|balm|biomesize'
```

### 5.4 Build the datapack

Per §4. Dimension type first (needs the jar from 5.3), then the rest.

```bash
cd ~/Source/create-aero-physics/pack
packwiz refresh
```

### 5.5 Global Packs config

Launch once more so the config generates, quit, then:

```bash
find "$INST/config" -iname 'global_packs*'
```

Add `datapacks/aerophys-defaults`, ordered to win over mod data. Copy the config
into the repo so it ships:

```bash
cp "$INST/config/global_packs.toml" ~/Source/create-aero-physics/pack/config/
cd ~/Source/create-aero-physics/pack && packwiz refresh
```

### 5.6 Biome Sizes config

Set overworld scale to **4× smaller (1/4 size)**, Nether default. Copy the
config into `pack/config/`.

Generate and look at this **before** the structure-density pass in §4.6, so the
two changes stay attributable.

---

## 6. Gate — load and confirm before continuing

```
DATAPACK
[ ] /datapack list → aerophys-defaults present and enabled
[ ] pack_format 48 accepted (if not, the pack is silently absent above)

BORDER
[ ] Overworld /worldborder get → 5120
[ ] Nether    /worldborder get → 5120
[ ] End       /worldborder get → 5120
[ ] If the Nether reports something other than 5120, borders are shared
    rather than per-dimension — record it, no action needed since all
    three are equal

NETHER SCALE — two-portal test
[ ] Portal at overworld 0,0. Step through
[ ] Walk 200 blocks in the Nether. Second portal. Step through
[ ] Overworld coords ≈ 200  → 1:1 live
[ ]                  ≈ 1600 → override lost; check Global Packs load order

NETHER SHAPE
[ ] Terrain is amplified
[ ] the_nether.json reads height 384, logical_height 256, coordinate_scale 1.0
[ ] Buildable to 384; portals link above 128
[ ] Record: roof present? at what Y? how much air above?
[ ] Record: highest terrain Y
[ ] /locate structure minecraft:fortress → inside the border

OVERWORLD
[ ] Vanilla terrain, unmodified
[ ] Biome scale set to 4× smaller, overworld only
[ ] Nether biome scale untouched — check for horizontal banding
[ ] At least one biome large enough to site a farm in
[ ] /locate structure minecraft:village → noticeably closer than vanilla
[ ] /locate structure minecraft:stronghold → inside 5120

PORTALS
[ ] Enter a portal, return — exit where you entered

STABILITY
[ ] check.sh clean (Veil-filtered grep)
[ ] Save, quit, reload, save again
[ ] Fresh second world picks up borders with no manual action
[ ] Controls screen — record any new binds (expect none)
```

---

## 7. Records to update

**`docs/lockfile.md`** — six rows: Amplified Nether, Amplified Nether Height,
Biome Sizes, NetherPortalFix, Balm, Global Packs. Exact filenames from
`grep -E "^name|filename" mods/*.pw.toml`.

**`docs/exceptions-register.md`** — no new rows. Nothing Tier C this phase.

**Phase 12 ARR list** — NetherPortalFix. Amplified Nether's Stardust Labs
License gets its own line with the reading of it.

**`docs/keymap.md`** — `/worldborder` and `/datapack` under non-bound functions.
No new keybinds expected from any mod this phase.

**Cut order** — **24** NetherPortalFix, **25** Balm, **26** Global Packs,
**27** Amplified Nether Height.
*Correction: numbers 19–22 were used in conversation during this phase. Phase 3
occupies 14–23; Phase 4 begins at 24.*

**World-defining bucket** (no cut order, never removable, third category for
Phase 13's safe-removal analysis):

- Amplified Nether
- Biome Sizes
- `aerophys-defaults` → `the_nether.json` only. Border and structure files are
  freely removable

---

## 8. Deferred and carried forward

| Item | Where |
|---|---|
| **Dimensional Sable + Custom Nether Portals** | Isolated spike branch. Reopened from the Phase 2 closure at William's request. Must survive: crossing, **returning**, block-level inventory on arrival, save/reload, chunk unload/return, and mod removal without breaking the world. Author's changelogs show Aeronautics balloons required a dedicated patch to survive a warp — treat state loss as the expected failure |
| **Simurail spike** | Never enters the manifest; copy from `manual/`. Seven Phase 3 criteria plus an eighth: derail a train off a bridge over deep water |
| **Sablewaves spike** | Phase 3 carry-over, four pass criteria, own branch |
| **Sappy Tree Physics spike** | Phase 2 carry-over — in pack, unvetted |
| **Version/licence records** | Sappy Tree Physics, Ragdoll Reactions — entered unvetted at the Phase 2 gate |

---

## 9. Notes for Phase 5

**The Nether is the resource backbone.** 1:1 scale, amplified terrain, reached
only by local portals. Phase 5 should be written against it rather than around
it: quarrying, lava, and bulk materials all point down there, and getting to a
distant Nether region means an overworld flight plus a second portal.

**Vanilla overworld means vanilla ore economy.** No sky-island rewrite. Phase 5
proceeds as originally scoped — bulk processing, multiplication, generators,
farms, mob and XP automation, scaling storage.

**Structure density is now a lever Phase 5 shares.** Ore density and recipe
detox sit on the same escalation ladder rung — configs and datapacks before any
scripting.

---

## 10. Reversals and corrections made during this phase

1. **"Ocean over void" recommendation — reversed.** The whole D2 direction was
   abandoned after inspection.
2. **"Island density: high" — wrong.** For the requested look, density needed to
   go down, not up.
3. **"Nether border 2000 against overworld 4000" — wrong.** At 1:1 the Nether
   border must be ≥ the overworld's or edge portals strand.
4. **"Don't take Amplified Nether Height" — objection withdrawn**, then the mod
   dropped anyway once it became clear it changes only the dimension type, which
   `aerophys-defaults` already forks.
5. **"Phases 0, 0.5 and 4 skip the gate"** — spec line edited. Phase 4 adds
   files and gets a gate.
6. **Cut order numbering** — 19–22 quoted in conversation; correct range is 24+.
7. **`side` fix loop** — the original `for` loop was buggy (glob collision on
   `amplified-nether*`). Replaced with the `grep -l` form in §5.2.
8. **"Do not push past ~2× on biome scale" — wrong.** 4× was generated and
   preferred. The 2× ceiling was reasoning, not testing; the same pattern as the
   density advice in item 2.
9. **Amplified Nether Height — dropped, then reinstated.** Dropped on the
   grounds that `aerophys-defaults` already forks the file it writes. Reinstated
   for `logical_height: 256`, which vanilla caps at 128. Both remain true: the
   datapack is still the mechanism, the mod is documentation and insurance.
10. **Water spike — resolved in the pack's favour.** Base Sable handles water
   correctly; Waterworks was the sole cause of the Phase 2 water failure. This
   retires the void-based fallback path permanently.

---

## 11. Unverified at time of writing

- `pack_format` 48 for 1.21.1
- Whether `execute in <dimension> run worldborder` sets per-dimension borders
- Amplified Nether: licence text, newest 1.21.1-compatible build, whether it
  ships a `dimension_type`, roof presence and height
- Biome Sizes: licence, Modrinth availability, project ID
- Global Packs: licence
- Whether 1.21.1 ships worldgen JSON in the client jar or requires the published
  vanilla worldgen export
