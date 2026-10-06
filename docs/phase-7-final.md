# Phase 7 — UI, QoL & Information — **FINAL**

**Create Aeronautics Physics Server**
Preceding tag: `phase-6-pass` · Entering: **47 entries** · Exiting: **72 entries, 25 mods added**
Tier C: none · `manual/` jobs: none · Branches: none

---

## 1. Process changes adopted this phase

Two standing rules changed. Both apply from here on.

### 1.1 The spike system is retired

The charter says validation is a crash check, phases should be big, and mods should
not be rationed across small rounds. A branch-per-mod with hand-written pass criteria
contradicts all three: it turns one gate into several, and the ambiguity it guards
against is already handled by testing one phase at a time in a fresh world.

> **Rule:** mods go on main and are tested at the phase gate. Branches are for
> credible **save-corruption** risk only — which QUARANTINE already excludes. In
> practice: no branches.

Pass criteria still exist; they became gate checklist lines. A mod that fails one gets
cut on the spot, which is what happened to Storage Drawers and Ragdoll Revive anyway.

**Consequence for Phase 10:** eight open spike branches (Simurail, Dimensional Sable,
Custom Nether Portals, Sablewaves, Sappy, Grappling Hook: Skybound, Vista, Ragdoll
Revive) need a disposition, not a spike. Not reopened here.

### 1.2 `options.txt` is owned by Minecraft, not by packwiz

Learned the hard way this phase.

> **Rule:** packwiz must never ship a file at a path Minecraft itself rewrites.
> `options.txt` ships **only** as `configureddefaults/options.txt` and is never
> tracked at its real path.

Three separate things make the root path unusable, and any one of them is fatal:

1. **Format.** `options.txt` has no comment syntax. A `#` line, a blank line, or a
   trailing annotation after a value makes the game discard the line and rewrite the
   file from defaults. This is what caused the "it keeps resetting" failure, and the
   malformed file was mine.
2. **Rewrite-on-exit.** Minecraft rewrites the whole file on every clean exit, so the
   on-disk hash immediately diverges from the index.
3. **Installer cache.** packwiz-installer compares the index hash against its own
   record of what it last installed, not against disk. Once installed, it reports
   already-up-to-date and returns without touching the file — so a Minecraft-rewritten
   `options.txt` is never restored. Confirmed in `DownloadTask.kt`.

The net effect at the root path would have been: settings survive until *you* next
edit the pack's copy, at which point every keybind your friends personally set is
wiped. That is the exact failure the charter names.

### 1.3 The packwiz / Configured Defaults split

They compose rather than overlap, because their write semantics are opposite.

| Tool | Writes | Use for |
|---|---|---|
| packwiz | Overwrites tracked files every launch | Config you are **enforcing** |
| Configured Defaults | Copies only when destination is **absent** | Defaults you are **seeding** |

`configureddefaults/` sits inside `.minecraft`, so packwiz tracks it as ordinary pack
content and keeps the seed authoritative and current. The mod then places it once.
packwiz owns the source of truth; the mod owns placement.

> **Rule:** no file appears in both systems. If one ever does, the mod wins on first
> launch and packwiz wins forever after — the worst of both.

packwiz's `preserve` flag (verified present in `indexfiles.go`, honoured in
`DownloadTask.kt`) would give write-once semantics without the mod, but goes unused
here: an inspectable directory beats a flag buried in `index.toml`, and preserve would
leave friends' seeds silently stale. **Decision: keep Configured Defaults, don't use
`preserve`.**

---

## 2. Corrections to the record

Recorded explicitly rather than quietly updated.

| Claim | Status |
|---|---|
| Controlify `3.0.1+lts` is a 1.21.1 NeoForge build | **Wrong.** Fabric 1.21.10. The 1.21.1 line tops out at `2.5.x` |
| Controlify's unnamed dependency `1eAoo2KR` | Identified: **YetAnotherConfigLib** |
| Controlify is client-and-server | **Wrong.** Issue #774 — crashes a dedicated 1.21.1 NeoForge server. **Client only** |
| Configured Defaults merges missing entries into an existing `options.txt` | **Wrong.** It never overrides an existing file. That behaviour belongs to Default Options |
| FTB Chunks should be dropped in favour of vanilla `/forceload` | **Withdrawn.** Visibility of what is force-loaded is the requirement, and a coordinate dump doesn't provide it |
| Tool Belt should be cut for colliding with Hysk on `R` | **Withdrawn, then partly reinstated.** The collision is real at mod defaults; resolved by moving Hysk to `Z` |
| `packwiz mr add --version` | No such flag. `--version-id` / `--version-filename`, or a version URL |
| `--file-id` accepts a filename | **Wrong.** Numeric only (`uint32`) |
| Aeronautics needs `contr_aero_compat` to fly with a controller | **Overstated.** No evidence it is load-bearing for basic flight |
| Prism overwriting `options.txt` was the reset cause | **Wrong, and asserted with unwarranted confidence.** The cause was §1.2.1 — my own malformed file |

Also cut permanently, so no future session re-proposes them: **Xaero's Minimap,
Xaero's World Map, XaeroPlus** (Xaero's World Border is Forge 1.20.x only and does not
exist for this pack).

---

## 3. The mods

All Tier A. Licences marked ⚑ go on the Phase 12 restrictive-licence list.

### 3.1 Recipe viewer — EMI in front of JEI

Not two viewers. EMI has no native Create plugin and reads Create's recipes only
through JEI's plugins, which requires JEI installed; JEI's UI then hides itself. That
is EMI's documented Create configuration, not a workaround.

| Mod | Version | Side | Licence |
|---|---|---|---|
| JEI | `19.27.0.336` | both | MIT |
| EMI | `1.1.24+1.21.1+neoforge` | client | MIT |

Do **not** add *EMI for Create* — it disables itself when JEI is present.
**TooManyRecipeViewers** is the fallback only if world-load time proves to be the
problem; it replaces JEI's API wholesale, which is a real cost.

Known: Create #7804 — Stock Keeper search hijacks the viewer's search bar.

### 3.2 Probe — single unit

| Mod | Version | Side | Licence |
|---|---|---|---|
| Jade | `15.10.5+neoforge` | both | CC-BY-NC-SA ⚑ |
| Jade Sable Compat | `1.2.0` | client | MIT |

The compat corrects Jade's block selection on Sable sublevels via a Sable-aware client
retrace. Jade alone is actively wrong on this pack. **Jade VS** is a separate,
server-side range fix — add only if the gate shows correct targeting up close but
nothing at range on a ship.

### 3.3 Map, claims and force-loading

| Mod | Version | Side | Licence |
|---|---|---|---|
| FTB Chunks | `2101.1.21` (CF file **8520252**) | both | ARR ⚑ |
| FTB Teams | `2101.1.10` | both | ARR ⚑ |
| FTB Library | `2101.1.35` — **`2101.1.34+` required by Chunks** | both | ARR ⚑ |

In for one reason: force-load state renders on the same map surface as the claim, so
you can see at a glance which chunks are live. Claims themselves are surplus.

**Chunk protection is to be disabled** — see §7.

**Border display is unresolved.** No evidence FTB Chunks draws the vanilla world
border; treat as absent until the gate says otherwise. Escalation, stop at the first
that works:

1. Read every option under the map's gear icon.
2. **Claim a one-chunk ring along the border.** Claims render on both the full map and
   the minimap, costs no mod, and with protection disabled it is pure map paint rather
   than a 640-chunk no-build wall. This is the recommended fallback.
3. Waypoints at the corners and edge midpoints, shipped via Configured Defaults.
   Phase 12 caveat: waypoint files are per server address.

No fourth option. No new mod for this.

### 3.4 Player and entity rendering — the crowded subsystem

| Mod | Version | Side | Licence |
|---|---|---|---|
| Watut | `1.21.0-1.2.7` | both | ARR ⚑ |
| CoroUtil | resolve at add-time | both | — |
| Not Enough Animations | `1.12.3-1.21.1` (CF file **8063412**) | client | tr7zw Protective ⚑ |
| Cosmetic Armour Reworked | `1.21.1-v1-neoforge` (CF file **5610814**) | both | Custom ⚑ |

**This pack now has seven mods patching player and entity rendering** — the four above
plus Sable: Ragdolls, Ragdoll Reactions, Ragdoll Corpse, with Curios adjacent. It is
the most-patched subsystem in the build, in a pack whose headline feature takes over
the player model. Cut orders 44–47 are a deliberate cluster: if player rendering
misbehaves, pull them in that order.

Specific flags:
- Watut and NEA both animate arms. Watut ships `watut-item-arm-adjustments.json` for
  exactly this, but it is a config someone must fill in.
- Watut ships its own GLSL (a past release fixed deprecated `texture2D` crashing Intel
  integrated GPUs) — relevant with Iris and Complementary.
- Watut has prior art with corpse mods; you have one.
- NEA vs Sable: Ragdolls is undefined territory — a ragdoll replaces the player model.
- Cosmetic Armour's 1.21.1 build is **Aug 2024**, long pre-dating the 13 June 2026
  Sable fault line. A community fork (`0.0.4`, Feb 2026) exists and is the swap if it
  misbehaves.

**ETF, EMF and 3D Skin Layers deliberately excluded.** EMF loads OptiFine CEM models
from resource packs and requires ETF; the pack ships no resource packs, so both would
be rendering patches doing nothing. 3D Skin Layers is the strongest of the three and
belongs at Phase 8 with the rest of the rendering stack, if at all. Note ETF's own
changelog carries a fix for a crash in the inventory screen with 3D Skin Layers — two
of the three have a history of crashing each other, in the screen Cosmetic Armour also
occupies.

### 3.5 Audio

| Mod | Version | Side | Licence |
|---|---|---|---|
| Sound Physics Remastered | `neoforge-1.21.1-1.5.1` (**Alpha channel**) | client | — |

By henkelmax, the Simple Voice Chat author, and explicitly optimised for SVC 2.x. On a
large airship interior this is the difference between "someone is talking" and
"someone is two decks down." Raycasts for occlusion — a Steam Deck cost and an obvious
sub-level question.

**Presence Footsteps not taken.** For the record, since it was close: a purpose-built
*Presence Footsteps x Sable (Aeronautics Compat)* exists (jDynamo, 27 May 2026). If it
is ever revisited, note there are **two** competing unofficial NeoForge ports and the
compat targets one mod ID — confirm which before pinning either.

### 3.6 Carrying and inventory

| Mod | Version | Side | Licence |
|---|---|---|---|
| Tool Belt | `1.21.1-2.2.10` | both | confirm |
| Hysk-LongHotbar | **pending filename** | client | confirm |
| Inventory Profiles Next | `neoforge-1.21.1-2.1.8` (CF file **6508839**) | client | AGPLv3 |
| libIPN | resolve at add-time | client | — |
| Kotlin for Forge | resolve at add-time | client | — |

No inventory-*expansion* mod. The pack's answer to carrying capacity is Create 6's
Stock Keeper and Redstone Requester — a base you built, which is what the charter
prefers. Tool Belt is a radial swap, not a second screen, so it passes extend-don't-nest.

**Grind flag on Tool Belt:** stock 2 slots, upgraded to 9 by anvil-combining pouches.
Ladder rung 2 — check whether capacity is configurable; if not, rung 4, a one-line
datapack recipe. Do not script it.

**Known conflict:** JEI issue #3915 — IPN hover tooltips render beneath the JEI
sidebar on NeoForge 1.21.1 (Fabric unaffected). With EMI installed the sidebar in
question is EMI's, so it may or may not reproduce. Three mods now inject into
container screens: JEI, EMI, IPN.

**Hysk-LongHotbar is unverified.** Its Modrinth page describes a Fabric 1.21.11 mod;
you are running it on NeoForge 1.21.1. Send the filename before pinning.

### 3.7 Social, control and shipping

| Mod | Version | Side | Licence |
|---|---|---|---|
| Ping Wheel | `1.12.2` | both | MIT |
| Chat Heads | `0.15.7` — confirm | client | MPL-2.0 |
| Controlling | `19.0.5` | client | MIT |
| Searchables | resolve at add-time | client | confirm |
| Controlify | `2.5.0+1.21.1-neoforge` | **client — see #774** | LGPL-3.0 |
| YetAnotherConfigLib | `3.8.2+1.21.1-neoforge` | client | confirm |
| Configured Defaults | `v21.1.0-1.21.1-NeoForge` | both | MPL-2.0 |
| Yeetus Experimentus | **pending filename** | confirm | confirm |

**Controlify must never reach the server file list.** Issue #774: it mixins into a
client screen class and kills a dedicated 1.21.1 NeoForge server during mod loading.

**Controlify alone** — the Controllable + `contr_aero_compat` pairing from Phase 3 is
not carried forward. If a friend on a Deck reports they cannot fly, that is a Phase 13
report with evidence and the swap is documented here.

**Yeetus Experimentus** suppresses the experimental-features confirmation, which the
`aerophys-defaults` datapack triggers via its custom Nether dimension type. Gate
items: whether it is needed server-side too, and whether suppressing the warning also
suppresses a legitimate error — break the datapack once and check you are still told.

**No guidebook.** Ponder is the guidebook: Create ships it, it covers the machinery
this pack is about, and it is reachable from the viewer. Patchouli is not proposed.

---

## 4. Manifest

```bash
cd ~/Source/create-aero-physics/pack

# Modrinth — version pinned via URL (no --version flag exists)
packwiz mr add "https://modrinth.com/mod/jei/version/19.27.0.336"
packwiz mr add "https://modrinth.com/mod/emi/version/1.1.24+1.21.1+neoforge"
packwiz mr add "https://modrinth.com/mod/jade/version/15.10.5+neoforge"
packwiz mr add "https://modrinth.com/mod/jade-sable-compat/version/1.2.0"
packwiz mr add "https://modrinth.com/mod/controlling/version/19.0.5"
packwiz mr add "https://modrinth.com/mod/configured-defaults/version/v21.1.0-1.21.1-NeoForge"
packwiz mr add "https://modrinth.com/mod/ping-wheel/version/1.12.2"
packwiz mr add "https://modrinth.com/mod/controlify/version/2.5.0+1.21.1-neoforge"
packwiz mr add "https://modrinth.com/mod/yacl/version/3.8.2+1.21.1-neoforge"
packwiz mr add "https://modrinth.com/mod/what-are-they-up-to/version/1.21.0-1.2.7"
packwiz mr add "https://modrinth.com/mod/sound-physics-remastered/version/neoforge-1.21.1-1.5.1"

# Modrinth — latest compatible, record what resolves
packwiz mr add searchables
packwiz mr add chat-heads
packwiz mr add coroutil
packwiz mr add libipn
packwiz mr add kotlin-for-forge

# CurseForge — numeric file IDs only
packwiz cf add --addon-id 433760 --file-id 8063412   # Not Enough Animations
packwiz cf add --addon-id 314906 --file-id 8520252   # FTB Chunks
packwiz cf add --addon-id 237307 --file-id 5610814   # Cosmetic Armour Reworked
packwiz cf add --addon-id 495267 --file-id 6508839   # Inventory Profiles Next

# CurseForge — latest compatible
packwiz cf add --addon-id 404468                     # FTB Teams
packwiz cf add --addon-id 404465                     # FTB Library  (verify >= 2101.1.34)
packwiz cf add --addon-id 260262                     # Tool Belt

# Pending filenames
# packwiz ... <hysk-longhotbar>
# packwiz ... <yeetus-experimentus>

packwiz refresh
```

**Side flags, set by hand:**

| Side | Entries |
|---|---|
| **client** | Controlify · YACL · EMI · Jade Sable Compat · Controlling · Searchables · Chat Heads · NEA · Sound Physics · IPN · libIPN · Kotlin for Forge · Hysk |
| **both** | JEI · Jade · FTB ×3 · Ping Wheel · Tool Belt · Cosmetic Armour · Configured Defaults · Watut · CoroUtil |

Watut will not work one-sided. Controlify must be excluded from the Phase 9 server list.

---

## 5. Keymap

Full audit done against a real blank-instance `options.txt`, not from mod pages. **Nine
genuine collisions existed at mod defaults**, all resolved.

| What was wrong | Fix |
|---|---|
| Iris held `R`, `K`, `O` — `R` already Tool Belt, Hysk and JEI | All four Iris keys unbound; shaders via video settings |
| Tree Physics also on `O` | Unbound — rare function |
| SVC held `M` (map), `H` (ragdoll), `V` (belt), `G` (Curios), and PTT was unbound so voice did not work | `V` talk, `B` mute, everything else unbound |
| Coasters rotate mode on `Tab` — vanilla playerlist | Moved to `G` |
| Jade `show_details` and Aeroworks free camera both on `Left Shift` — your sprint | `show_details` unbound; free camera to `Mouse4` |
| Climbable Ropes on `Left Alt` — Create's cluster | Moved to `K` |
| Hysk toggle on `=` — minimap zoom | Unbound |
| Jade on six numpad keys — **the Steam Deck has no numpad** | One key, `J`, for overlay |
| Tool Belt and Hysk both on `R` | Tool Belt keeps `R`, Hysk to `Z` |

**Final scheme:** `H` ragdoll · `G` rotate mode · `K` rope camera · `Mouse4` free
camera · `R` tool belt · `Z` hotbar swap · `V` talk · `B` mute · `Mouse5` ping ·
`J` probe · `M` map · `N` waypoint · `]` minimap · `=`/`−` zoom.

**Vanilla untouched, including inverted sneak/sprint** (sneak `Left Ctrl`, sprint
`Left Shift`).

**Deliberate non-conflicts — do not "fix" these.** `R` is also the viewer's
show-recipes and `W` is also Ponder; both fire only inside a GUI. Controlling will flag
them as clashes. They are not.

**Unbound on purpose, and published as such** — an unbound feature is an invisible one:
SVC's eight remaining binds · Cosmetic Armour (inventory-screen button instead) ·
Curios (inventory-screen button) · Hysk toggle · all Iris · Jade's other five · Tool
Belt cycle and slot · Tree Physics · Drive-By-Sable · FTB claim and waypoint managers.

**Zero keybinds registered:** Chat Heads, Controlling, Searchables, Configured
Defaults, CoroUtil, Watut, NEA, Controlify (keyboard layer), Ragdoll Reactions, Ragdoll
Corpse, Amendments, Forgiving Void, No Durability, Almost Unified.

**Contextual, no key exists:** Climbable Ropes climbing/mantling/sliding — document it
or it is invisible.

### Outstanding before the keymap is final

- **IPN registers keybinds** — sort, throw-all, move-matching. The current
  `options.txt` is stale until they are placed. Free keys are thin.
- **EMI stores keybinds in its own config**, not `options.txt` — that path must be
  mirrored under `configureddefaults/` or the viewer is the one part of the keymap
  that does not ship.
- Sound Physics expected to register none; unconfirmed.

---

## 6. Cut order

| # | Entry |
|---|---|
| 44 | Watut + CoroUtil |
| 45 | Not Enough Animations |
| 46 | Sound Physics Remastered |
| 47 | Cosmetic Armour Reworked |
| 48 | Controlify + YACL |
| 49 | Jade Sable Compat |
| 50 | Jade |
| 51 | Inventory Profiles Next |
| 52 | libIPN |
| 53 | Kotlin for Forge |
| 54 | Tool Belt |
| 55 | Hysk-LongHotbar |
| 56 | FTB Chunks |
| 57 | FTB Teams |
| 58 | FTB Library |
| 59 | Ping Wheel |
| 60 | Chat Heads |
| 61 | Controlling + Searchables |
| 62 | Configured Defaults |
| 63 | EMI |
| 64 | JEI |
| 65 | Yeetus Experimentus |

Sound Physics sits early despite being wanted: Alpha channel, and it raycasts every
sound against world geometry, making it a prime suspect for both FPS complaints and
audio weirdness. Dependency clusters pull dependents first (IPN before libIPN before
Kotlin; FTB Chunks before Teams before Library; EMI before JEI). Yeetus is last because
pulling it breaks nothing — it only restores a confirmation screen.

---

## 7. Chunk protection — must land before Phase 11

**Requirement:** force-loading retained, protection off. Walking into an area a friend
claimed and being unable to build on it is unacceptable on this server.

**This is time-sensitive, not just config.** FTB Chunks takes new teams' properties
from a defaults block in the server config. A team created under the old defaults keeps
them; changing defaults later does not retro-fix existing teams, and you never reset
this world. **Set before your friends first join.**

**Do not blanket-disable.** The property list likely includes spawning-related toggles
alongside build/interact ones, and Phase 5's mob farms need hostile spawning to work
inside force-loaded claimed chunks. The requirement is precisely: build, interact and
entity-interact open to everyone; spawning untouched; force-loading retained. Exact
property names unverified — a Phase 9.5 verification item, not a config block to write
blind.

After this change, claims are a map-colouring tool and a force-load quota mechanism.
That is a coherent thing to keep.

---

## 8. Gate — fresh scratch world, creative, single-player

Fresh world per phase is canon. Verify the count with
`grep -c name mods/*.pw.toml` rather than trusting arithmetic.

### Startup
```
[ ] check.sh clean (Veil-filtered)
[ ] No missing registry / duplicate mod / dependency / mixin failures
[ ] Searchables resolves for Controlling; YACL for Controlify
[ ] libIPN and Kotlin for Forge resolve for IPN
[ ] FTB Library resolves at >= 2101.1.34   <-- hard requirement of Chunks 2101.1.21
[ ] Every new .pw.toml has the side from §4
```

### Named criteria
```
[ ] *** 1: JADE ON A MOVING SUB-LEVEL ***
    Blocks on a flying ship name the RIGHT block.
    Standing gate rule (Storage Drawers). Fails -> cut both Jade entries

[ ] *** 2: WORLD BORDER ON THE MAP ***
    Read EVERY option under the map gear icon.
    Fails -> §3.3 escalation, options 2 then 3

[ ] *** 3: FORCE-LOAD VISIBILITY — the reason FTB Chunks is in ***
    Claim, shift-click to force-load. Force-loaded state VISUALLY DISTINCT
    from a plain claim, at a glance, no submenu.
    Fails -> the mod is not doing the job it was admitted for

[ ] *** 4: MAP vs SABLE ***
    Fly 500 blocks. No garbage tiles, no runaway cache, no crash on
    sub-level load/unload. Does the minimap draw the SHIP or the ground?

[ ] *** 5: CONFIGURED DEFAULTS ORDERING ***
    Fresh instance. options.txt lands with the pack keymap.
    Then edit a key, relaunch, confirm it is NOT reverted.
    Fails -> keymap ships as a paste-in step in the install guide

[ ] *** 6: THE VIEWER SEES THE PACK ***
    EMI visible, JEI HIDDEN. No doubled categories.
    Every Create category: pressing, spouting, mixing, sequenced
    assembly, mechanical crafting. Plus a Phase 3 addon.
    Porkchop Express recipes readable (open since Phase 2).
    Ponder shortcut present. Recipe tree resolves on a deep chain

[ ] *** 7: WORLD LOAD TIME ***
    JEMI loads JEI's whole registry then re-imports it.
    Compare against the phase-6-pass baseline.
    Materially worse -> TMRV, or cut EMI
```

### Everything else
```
[ ] Sound Physics: sound occludes against a ship hull on a sub-level
[ ] Sound Physics: Simple Voice Chat actually picks up the occlusion
[ ] Sound Physics: FPS cost acceptable at the Steam Deck floor
[ ] IPN: tooltips vs the EMI sidebar (JEI #3915 — may not reproduce under EMI)
[ ] IPN: sorts a Create Stock Keeper / vault, not just a vanilla chest
[ ] IPN: auto-refill vs Tool Belt — both want to fill your hand
[ ] IPN: record every keybind it registers
[ ] Tool Belt: radial on R, swaps into hand, no second screen
[ ] Tool Belt: works on a MOVING sub-level
[ ] Tool Belt: Curios belt slot, or clean fallback
[ ] Tool Belt: is capacity configurable?  -> answers the grind flag
[ ] Watut: player animations on a moving sub-level
[ ] Watut: does a Ragdoll Corpse animate or twitch?
[ ] Watut + NEA: arm animations — fill watut-item-arm-adjustments.json
[ ] NEA vs Sable: Ragdolls — animate a ragdolled player
[ ] NEA vs elytra animations
[ ] Cosmetic Armour: two sets equip; WHICH set does a corpse show?
[ ] Cosmetic Armour: no fight with the other rendering mods
[ ] Ping Wheel: ping on a moving ship — tracks or stays? RECORD
[ ] Chat Heads: heads render, no inventory-screen crash
[ ] Controlling: opens, searches, flags the R and W clashes (expected)
[ ] FTB Chunks: death point auto-created, and it finds the corpse
[ ] FTB Chunks: die ON A SHIP — where does the death point land?
[ ] FTB Chunks: minimap disableable client-side
[ ] Yeetus: experimental warning gone; break the datapack, confirm you
    are still told
[ ] Create Stock Keeper search does NOT hijack the viewer search (#7804)
[ ] Save, quit, reload, save again
```

**Load and confirm before we continue.**

---

## 9. Records to update on pass

**`docs/lockfile.md`** — 25 rows from `grep -E "^name|filename" mods/*.pw.toml`.

**`docs/exceptions-register.md`** — no new rows. Nothing Tier C, nothing in `manual/`.

**Phase 12 restrictive-licence list** — Jade · FTB Chunks · FTB Library · FTB Teams ·
Cosmetic Armour · Watut · Not Enough Animations.

**`docs/keymap.md`** — regenerate after IPN's binds are placed. §5 plus the unbound
list plus the contextual-controls note. One page, no longer.

**`docs/standing-rules.md`** — add §1.1, §1.2 and §1.3.

**Cut register** — permanent, alongside Vista and Storage Drawers: Xaero's Minimap,
Xaero's World Map, XaeroPlus. Not deferred, not standby.

**Deferred Wishlist** — strike Controlify's entry and its two errors; strike the
toolbelt row; strike Xaero's World Border before anyone rediscovers it.

**Phase 9 server file list** — Controlify and YACL **excluded**. FTB ×3, Watut and
CoroUtil **required**.

**Phase 9.5** — per-player claim and force-load cap (open since Phase 0) · chunk
protection defaults, before first join · spawning properties left alone · Automated
Logistics vs FTB Chunks vs `/sable forceload` reconciliation · claim quota if the
border ring is used.

**Phase 12** — Prism or MultiMC is now near-required: `packwiz-installer-bootstrap` as
a pre-launch command gives friends rolling auto-update, and the CurseForge and Modrinth
apps have no pre-launch hook, so choosing either means manual reinstall per update ·
waypoint files are per server address · Prism's controller guide for the Deck section.

**Phase 13 safe-removal** — Tool Belt becomes load-bearing the moment a belt with items
exists in the world.

**Closed from earlier phases** — Porkchop Express recipe readability (Phase 2) · Jade
Sable Compat pairing (Phase 2) · corpse findability, via FTB death points (Phase 6) ·
controller support (Phase 3). **Border-on-map remains open**, subject to criterion 2.

---

## 10. Verification log

Confirmed by search or source read, not asserted from memory.

| Claim | Source |
|---|---|
| packwiz `mr add` flags are `--project-id` / `--version-id` / `--version-filename`; URL parser accepts `/version/<x>` | `modrinth/install.go`, `modrinth/modrinth.go` |
| packwiz `cf add` takes numeric `--addon-id` / `--file-id`; URL parser accepts `/files/<n>` | `curseforge/install.go`, `curseforge/curseforge.go` |
| packwiz `preserve` flag exists and is honoured by the installer | `core/indexfiles.go`, `DownloadTask.kt` |
| packwiz-installer skips on cached-hash match, not disk state | `DownloadTask.kt` |
| packwiz-installer has no special handling for `options.txt` | `UpdateManager.kt` |
| Controlify crashes a dedicated 1.21.1 NeoForge server | isXander/Controlify #774 |
| Controlify 1.21.1 line tops at `2.5.x`; dependency is YACL | Modrinth version pages |
| IPN tooltips render under the JEI sidebar on NeoForge 1.21.1 | mezz/JustEnoughItems #3915 |
| EMI's Create configuration is EMI + JEI, JEI hidden | EMI and *EMI for Create* descriptions |
| Create #7804 — Stock Keeper hijacks viewer search | Creators-of-Create/Create |
| FTB Chunks `2101.1.21` requires FTB Library `2101.1.34+` | CF 314906 changelog |
| FTB Chunks force-loads via shift-click on the claim map | CF 314906 description |
| Xaero's World Border is Forge 1.20.1–1.20.6 only | Modrinth `vfOkGQEG` |
| Presence Footsteps x Sable compat exists (jDynamo, 27 May 2026) | CF search |
| Sound Physics Remastered optimised for Simple Voice Chat 2.x | CF 1.5.1 listing |
| Jade Sable Compat corrects block selection on Sable sublevels | Modrinth `jCrJ4iGH` |
| No evidence FTB Chunks renders the vanilla world border | Negative result |

**Unverified, resolve at add-time:** Hysk-LongHotbar filename and loader · Yeetus
Experimentus version and side · Searchables · libIPN · Kotlin for Forge · CoroUtil ·
Chat Heads exact build · Tool Belt and YACL licences · exact FTB claim property names.
