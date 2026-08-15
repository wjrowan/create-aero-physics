# Phase 2 — COMPLETE: Physics Breadth + Rendering Stack

**Pack:** Create Aeronautics Physics Server
**Status:** **PASSED** — gate run 15 August 2026
**Supersedes:** the Phase 2 proposal, the §10 water revision, and the Phase 2b
rendering proposal. Where they disagree with this document, this one is right.

> This is the as-built record. The proposals described what we intended to
> install; this describes what actually survived contact with the game. Six
> proposed mods were cut at the gate on observed behaviour, not on reasoning.

---

## 1. What's actually installed

**22 entries. 4 from Phase 1, 18 added in Phase 2.**

### Phase 1 — core (unchanged)

| Mod | Version | Side |
|---|---|---|
| Create | `6.0.10+mc1.21.1` | both |
| Sable | `2.0.3+mc1.21.1` | both |
| Create: Aeronautics | `1.3.0+mc1.21.1` | both |
| Create: Coasters Simulated | `0.1.4` | both |

### Phase 2 — physics breadth

| Mod | Notes |
|---|---|
| Absolute Kinematics | Hinge + Ball Joint. MIT. |
| Create: Aeroworks | Vehicle control blocks. |
| Create: High Seas | **Deprecated upstream — kept deliberately, see §3.** |
| Drive-By-Sable | Cable-based vehicle control (the fork, not the original). |
| PAPA | Handheld physics assembler. MIT. |
| Ragdoll Reactions | Automatic ragdoll on falls and heavy hits. **Unvetted, see §4.** |
| Sable AABB Fix | Crash/spam fix for abnormal AABBs. |
| Sable Beyond | Alpha feature/QoL layer. |
| Sable Explosions Fix | Explosions above Y=320. |
| Sable: Physics Compat | Tag-based physics properties. |
| Sable: Ragdolls | Manual ragdoll, `H`. |
| Sappy Tree Physics | Trees topple as physics objects. **Different project from the "Tree Physics" originally researched — see §4.** |
| The Porkchop Express | The deliberate joy exception. ARR. |

### Phase 2 — rendering

| Mod | Version | Side |
|---|---|---|
| Sodium | `mc1.21.1-0.8.12-neoforge` | client |
| Iris Shaders | `1.8.14-beta.1+1.21.1-neoforge` | client |
| Distant Horizons | `3.2.0-b-1.21.1` | both (client-only for now) |
| Euphoria Patches | `1.9.3-r5.8.1-neoforge` | client |
| Complementary Reimagined | `r5.8.1` | client (`shaderpacks/`) |

**Version capture still outstanding.** Several rows above have no pinned version
recorded. Before committing:

```bash
cd ~/Source/create-aero-physics/pack
for f in mods/*.pw.toml; do echo "== $f"; grep -E "^name|filename" "$f"; done
```

Paste that into `docs/lockfile.md`. The freeze policy is only real if the
versions are written down.

---

## 2. Cut at the gate — six mods, on observed behaviour

This is the section that matters most for Phase 10. None of these were cut on
reasoning; all six were installed, tested, and failed.

| Mod | Why it's out |
|---|---|
| **SSRD** | Slider appeared in Sodium's menu and did nothing. Sub-levels vanished at normal render distance regardless of slider value or DH LOD distance. The Sodium options injection worked while the Sable rewrite apparently didn't. |
| **Sand Physics** | **Cut on a design defect, not a bug.** Landed blocks stay sub-levels rather than reverting to ordinary blocks, so every gravel fall permanently adds a physics sub-level. Unbounded accumulation against a fixed tick budget. |
| **Dimensional Sable** | Did not work. |
| **Create Aeronautics: PhysicsKnife** | Janky in use. The thin-install-base concern flagged at proposal time turned out to be the right instinct. |
| **Waterworks – Sable** | **Failed its own probe, twice over.** No water occlusion — the one feature it was chosen for. And anything touching water launches uncontrollably skyward. Actively destructive, not merely unhelpful. |
| **iris-flw-compat + iris-veil-compat** | Mutually incompatible in practice. See §5. |

### Consequences for the spec — two charter bullets **closed as not achievable**

Phase 2's charter named six things to hunt for. **Two cannot be delivered on
this platform, and are closed rather than deferred:**

- **"Detached blocks becoming physics contraptions."** Auto Sable Physics is the
  only mod that ever did this properly, and it is Sable 1.2.2-only — verified by
  isolation spike, a critical load failure against 2.0.3. Sand Physics was the
  partial substitute and it failed on its own design (landed blocks never revert
  from sub-levels). Nothing else on 1.21.1 does it.
- **"Cross-dimensional physics objects."** Dimensional Sable was the only mod
  doing it. It does not work.

**Accepted by William, 15 Aug 2026.** These are not open items and should not be
re-proposed in later phases. If a working mod appears in a future sweep, these
are the gaps it would fill — but the search is closed, not paused.

**Emergent physics in this pack is trees, and that's sufficient.** Felling a
tree and watching it topple as a real physics object is the behaviour that
carries the theme in normal play; the other two were always the rarer cases. The
theme layer is thinner than the charter imagined, not thinner than the pack
needs.

---

## 3. Create: High Seas — a knowing exception

The §10 research deprecated this mod and chose Waterworks instead. Waterworks
then failed at the gate. High Seas is deprecated but works and does the job, so
it stays.

**I think that's the right call**, and the version-freeze argument is genuinely
strong: a mod that never updates cannot break on an update, and the pack is
frozen anyway. Deprecation is a maintenance risk, and this pack doesn't consume
maintenance.

**But the real risk isn't updates — it's delisting.** It's All Rights Reserved
and abandoned. If the author pulls or hides the CurseForge project, packwiz can
no longer resolve it and **nobody can install the pack**, including you on a
rebuild. The pinned hash guarantees integrity, not availability.

**Mitigation, and it's cheap:** keep an archived copy of the exact jar in
`manual/` and log it in `docs/exceptions-register.md` — not as a Tier C
exception, but as an availability hedge. That folder is already gitignored and
the register already has the right columns. It costs one file and one row, and
it's the difference between "the pack still builds" and "the pack is dead" if
that project disappears.

---

## 4. Two mods that entered without vetting

Both arrived during the gate rather than through a proposal, so neither has the
version / licence / conflict record every other mod in this pack has.

**Sappy Tree Physics** is *not* the mod researched at proposal time. That was
`tree-physics` (`neoforge-2.3`, ARR). This is a different project. Everything
recorded about the original — its ARR licence, its Phase 12 flag, its cut order
— **does not transfer.** Needs its own row.

**Ragdoll Reactions** triggers ragdoll automatically on falls and heavy hits.
Wanted, and it complements rather than duplicates Sable: Ragdolls (which is
manual, on `H`). But note what's accumulating:

> You now have **two** ragdoll mods, and Sable: Ragdoll Corpse at Phase 6 would
> make **three**. All three patch player rendering and entity ticking — the
> subsystem Sable is most intrusive in.

That's not a veto. It's the shape your spec warns about, and the point to notice
it is now rather than at Phase 10.

**For both mods, capture at minimum:** exact version, licence, and whether they
register keybinds.

---

## 5. The rendering stack — what happened

**Verdict: shaders work. The Create/Aeronautics shader bridges do not coexist.**

### The bridges are mutually incompatible

Both `iris-flw-compat` and `iris-veil-compat` `@Overwrite` the same two methods
on the same Iris class. From the log, verbatim:

```
Method overwrite conflict for getShaderProperties in irisveil.mixins.iris.json:MixinProgramSource
from mod irisveil, previously written by top.leonx.irisflw.mixin.iris.MixinProgramSource. Skipping method.
Method overwrite conflict for getBlendModeOverride ... Skipping method.
```

Whichever loads second loses. `getBlendModeOverride` governs translucent
blending, which is exactly the observed symptom set:

- **iris-flw-compat present** → Sable machines and coaster rails render
  translucent
- **iris-veil-compat present** → levitite flickers when static and **inverts its
  rendered faces when moving**

Iris also compatibility-patched three missing declarations in the levitite
shader — `_veil_depth`, `_veil_ghostNoiseMagnitude`, `_veil_ghostLayerFullness`.
A patched-in `_veil_depth` means undefined depth values, which is precisely what
face inversion under motion looks like. Levitite is the one block that is
translucent, Veil-rendered, *and* moves — so it collects both failures at once.

Both mods are by the same author. This is almost certainly untested overlap
rather than a design decision.

### Resolution: both removed

Tested and rejected: `useDithering` on/off (governs schematic ghost previews,
not machines), iris-flw-compat 2.3.1 instead of 2.4.0 (the conflict exists in
both), and every Flywheel backend.

**Flywheel backend findings:**

| Backend | Result |
|---|---|
| `flywheel:instancing` | Unavailable with shaders — expected, this is why the bridge exists |
| `irisflw:iris_instancing` | Chains render as beams of light |
| `flywheel:indirect` | Lighting correct, **chain lifts vanish — and they vanish with shaders OFF too** |
| `flywheel:off` | Chains render, no instancing |

**The `indirect` finding is a genuine bug and nothing to do with shaders.**
Coasters Simulated chain lifts do not render under Flywheel's indirect backend
with shaders disabled. Clean, reproducible, three commands — worth reporting to
the Coasters authors.

### What this costs

**Flywheel disables its own optimisations whenever a shaderpack is active** —
that's the mod's entire purpose. Without the bridge, **shaders on = no GPU
instancing on Create kinetics.** On an RTX 5070 Ti, irrelevant. It becomes a
Phase 12 install-guide line: shaders on means worse Create performance,
independent of your GPU.

Aeronautics' Veil visuals (wings, contrails, glass) render unshaded rather than
through the shaderpack. Cosmetic.

### Upstream report

One issue on `leon-o/iris-veil-compat`, quoting both `Method overwrite conflict`
lines and describing both symptoms. Same author owns both mods. This is a
fixable bug with a clean reproduction, and if it lands you get both bridges back
in a future update — which is the one change worth breaking the freeze for.

---

## 6. Version stack — the beta chain, and why it stays

| Mod | Channel | Why |
|---|---|---|
| Sodium `0.8.12` | release | Was required by SSRD |
| Iris `1.8.14-beta.1` | **beta** | Only 1.21.1 build targeting Sodium 0.8 |
| Distant Horizons `3.2.0-b` | beta | DH ships beta-channel by policy |

**SSRD is gone, so the justification for Sodium 0.8 is gone with it.** Dropping
to Sodium 0.6.x would allow Iris `1.8.12` release and remove a beta from the
stack.

**Decision: not changing it.** It works, the churn risk of re-resolving the
rendering stack exceeds the benefit of a channel label, and re-pinning invites
exactly the kind of version confusion that produced the corrupted world. Noted
so Phase 8 doesn't rediscover it as an anomaly.

---

## 7. Gate results

| Check | Result |
|---|---|
| Game reaches main menu | **PASS** |
| No mixin apply failures / injection errors | **PASS** — only the two overwrite conflicts in §5 |
| Scratch world generates and loads | **PASS** |
| Sable contraption assembles and moves | **PASS** |
| Tree felling → physics object | **PASS** |
| Ragdoll | **PASS** |
| Coaster track + cart | **PASS** (after the world rebuild) |
| Shaders load, world renders | **PASS** |
| Complementary lands in `shaderpacks/` | **PASS** |
| Euphoria patches Complementary | **PASS** |
| Create kinetics under shaders | **PASS** once both bridges removed |
| Levitite under shaders | **PASS** once veil-compat removed |
| Sub-levels beyond render distance | **FAIL** → SSRD cut |
| Water occlusion probe | **FAIL** → Waterworks cut |
| Cross-dimensional contraption | **FAIL** → Dimensional Sable cut |
| Keybinds recorded in `docs/keymap.md` | **NOT DONE** — see §9 |
| `config/iris.properties` + Iris settings committed | **NOT DONE** |

### Known log noise — add to `check.sh`

Hundreds of benign `[Veil] ... could not find uniform named flw_*` WARN lines,
plus recurring `[Veil] ERROR: Unsupported Uniform Type: bool`. Both are the
Flywheel/Veil/Iris seam reporting uniforms the compiler stripped. Harmless, but
they will bury a real error:

```bash
grep -iE "mixin apply failed|mixin.*error" latest.log \
  | grep -viE "could not find uniform named|Unsupported Uniform Type"
```

---

## 8. The corrupted world — carried to Phase 11 as a watch item

One scratch world was carried from Phase 1 through Phase 2, across many mod
additions and removals. It began **hanging on save**, requiring the process to
be killed, and produced a cascade of confusing symptoms — disconnected coaster
track, translucent geometry, changes that appeared not to take — that were
initially misattributed to the shader stack. A fresh world resolved all of it.

**The probable cause is the churn, not any one mod**, and none of it has
recurred. But the spec's one hard line is not losing the world, and a save hang
is that failure's signature.

**So:** not a QUARANTINE trigger, but a named watch item.

- Never carry a scratch world across mod changes again. New world per phase.
- If a save hang recurs on a world that has *not* been churned, that is a
  QUARANTINE event and the pack stops until it's attributed.
- Two mods remain plausible contributors if it does recur, both for the same
  reason — they create sub-levels that persist: **Sappy Tree Physics** and
  **Sable Beyond**.

---

## 9. Carried forward

| Item | Owning phase |
|---|---|
| **Capture exact versions + licences into `docs/lockfile.md`** | **Now** |
| **Keybinds → `docs/keymap.md`** (Iris, Sable: Ragdolls `H`, Ragdoll Reactions, Drive-By-Sable) | **Now** |
| Commit `config/iris.properties` + Iris per-pack settings | **Now** |
| Archive the High Seas jar in `manual/` + register row | **Now** |
| File the `iris-veil-compat` mixin conflict issue | Now, then revisit at Phase 8 |
| Report Coasters chain lifts vs `flywheel:indirect` | Now |
| **Sappy Tree Physics sub-level despawn/cap** — the same defect that cut Sand Physics | **Phase 9.5, non-optional** |
| Sable: Ragdoll Corpse as death-handling candidate — **already recorded in the Deferred Wishlist §3, Phase 6.** Would be the third ragdoll mod; check overlap with Ragdoll Reactions before accepting | Phase 6 |
| Sablewaves | Phase 3 |
| Whether DH runs server-side; LOD database in the volume layout | Phase 9 |
| DH LOD pre-generation | Phase 11 |
| Steam Deck: shaders off, DH off. Shaders on = no Create instancing | Phase 12 |
| ARR mods with no fallback: The Porkchop Express, **Create: High Seas (also deprecated)** | Phase 12 |
| Two charter bullets **closed as not achievable** (§2) — do not re-propose | Closed |

---

## 10. Change log

| Date | Change | Reason |
|---|---|---|
| 15 Aug 2026 | Phase 2 **PASSED**, 18 mods added, 22 in pack | Gate run in dev instance |
| 15 Aug 2026 | **SSRD cut** | Slider present, no effect at any value |
| 15 Aug 2026 | **Sand Physics cut** | Landed blocks remain sub-levels — unbounded accumulation |
| 15 Aug 2026 | **Dimensional Sable cut** | Did not work |
| 15 Aug 2026 | **PhysicsKnife cut** | Janky |
| 15 Aug 2026 | **Waterworks cut** | No occlusion, and water contact launches objects skyward |
| 15 Aug 2026 | **Create: High Seas kept despite deprecation** | Works, does the job, pack is frozen. Availability hedge required. |
| 15 Aug 2026 | **Both Iris bridges cut** | Mutual mixin overwrite conflict on `getBlendModeOverride` |
| 15 Aug 2026 | **Sappy Tree Physics, Ragdoll Reactions added** | Entered at the gate; both need vetting records |
| 15 Aug 2026 | Iris beta chain retained despite SSRD removal | Working stack; churn risk exceeds benefit |
| 15 Aug 2026 | **Charter bullets "detached blocks" and "cross-dimensional physics" closed as not achievable** | No working mod exists on 1.21.1. Accepted; not to be re-proposed. Tree physics accepted as sufficient for the theme. |
| 15 Aug 2026 | Committed and pushed | Phase 2 tagged |
