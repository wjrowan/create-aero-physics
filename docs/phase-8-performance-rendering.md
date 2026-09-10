# Phase 8 — Performance & Rendering

**Create Aeronautics Physics Server**
Preceding tag: `phase-7-pass` · Entering: **72 entries** · Exiting: **76 entries, 4 added**
Tier C: none · `manual/` jobs: none · Branches: one, deleted · New keybinds: **zero**

---

## 1. What this phase turned out to be

Phase 8 was written assuming it owned the whole rendering stack. It didn't, twice over.

**First**, Phase 2 absorbed it. Pulling Sodium and SSRD forward dragged Iris, both compat
bridges, Colorwheel and Distant Horizons in with them, and the shader spike resolved all
of it at the Phase 2 gate — by observation rather than by reasoning, which is the better
outcome.

**Second**, the optimizer list that remained was mostly rejected, correctly, by William:
*"I am kind of happy with the state of optimisation at the moment, Steam Deck runs fine,
everything works. I feel like adding any of these mods adds massive risk of weird things
happening."*

That is the correct reading of this project's own charter. There is no prune-after-play,
one world, no resets — so every mod must justify itself against a problem that actually
exists, and "my Deck runs fine" means most of these didn't have one. They were proposed
against a hypothetical future load, which is the enthusiasm-not-need category Phase 10
is supposed to catch. Catching it at Phase 8 is better.

The reframe that made deferral cheap: **nothing in this phase writes world data or
becomes load-bearing.** No contraption depends on FerriteCore; no build breaks if
ImmediatelyFast leaves. So the rejected entries are not cuts — they are a **shelf**,
addable post-launch in a changelog line and a relaunch, for the specific moment someone
says "it's chugging."

What shipped instead was four entries, three of which have nothing to do with
performance, and a config rule that is worth more than any of them.

---

## 2. The shader spike — final report

Charter asked for this at Phase 8 with a final recommendation. Here it is.

### 2.1 Verdict

**Shaders work, and they cost nothing on the Create side. Ship them.**

The Phase 2 answer was "viable but two problems, neither solved." Both are now solved,
one of them by a mod nobody proposed at the time.

| Pipeline | Bridge | State |
|---|---|---|
| **Flywheel** (Create's instancing) | **Colorwheel** `1.2.9` + Patcher `1.0.5` | **Solved.** Chains render, contraptions solid, instancing restored under shaders |
| **Veil** (Sable/Aeronautics effects) | **iris-veil-compat** `1.21.1+0.1.0-alpha` | **Working, pinned old deliberately.** Levitite inversion is a post-0.1.0 regression |

The most important consequence, restated because it reverses a warning that sat in the
Phase 12 notes for a day: **"shaders on = no Create instancing" is no longer true.**
Colorwheel restores Flywheel instancing under a shaderpack. Your friends do not pay a
Create performance tax for turning shaders on.

Residual cost is cosmetic and narrow: Aeronautics' Veil-driven visuals (wings,
contrails, balloon effects) render unshaded, plus two upstream artifacts already on
record — filled balloons causing shadow/depth artifacts (Aeronautics #1228, Iris #3152)
and the Plunger Launcher rope rendering invisible under Iris (iris-flw-compat #247).

**Phase 8 adds a third data point in shaders' favour**, from the ETF gate: emissive skin
textures render correctly under Complementary + Euphoria Patches. This was expected to
be a fight — the shaderpack does its own emissive handling and could plausibly have
overridden or doubled ETF's. It didn't. See §5.1.

### 2.2 Final supported configuration

Ship exactly this. Anything else is unsupported, and the install guide says so.

```
Sodium             mc1.21.1-0.8.12-neoforge      (release)
Iris               1.8.14-beta.1+1.21.1-neoforge (beta — see Phase 2 §6)
Colorwheel         1.2.9+mc1.21.1
Colorwheel Patcher 1.0.5+mc1.21.1
iris-veil-compat   1.21.1+0.1.0-alpha            (PINNED OLD — do not "update")
Distant Horizons   3.2.0-b-1.21.1                (beta by upstream policy)
Euphoria Patches   1.9.3-r5.8.1-neoforge
Complementary Reimagined r5.8.1                  (shaderpacks/, referenced)
```

Three of eight are non-release channel and one is deliberately stale. That looks
alarming written down. It is the configuration that passed a gate; the freeze policy
exists precisely so a later tidy-up doesn't turn it into something that doesn't.

**Sodium cannot be downgraded.** Sable's `neoforge.mods.toml` declares Sodium below its
floor as an outright incompatibility. Phase 2 §6 considered dropping to 0.6.x to obtain
an Iris release build and decided against it on churn grounds — that would have
hard-broken Sable. Right decision, better reason than the one recorded at the time.

### 2.3 Euphoria Patches — Phase 0's open question, closed

Phase 0 flagged: *"If it is applied to Complementary rather than being standalone, that
is a manual step for every friend on every shader update."*

**It is applied to Complementary, and it is not a manual step.** Euphoria Patches ships
as a mod jar (EuphoriaPatcher) in `mods/`, auto-detects the Complementary archive in
`shaderpacks/`, verifies it by byte size, applies a binary patch at runtime and writes
out the patched shaderpack. It carries a filesystem watcher that patches newly added
shaderpacks automatically.

The reason it works this way is licensing: Complementary's licence does not permit
republishing a derived pack, so the author ships the patcher instead of the product.
Convenient for us — the patcher is a referenceable Tier A mod jar, and Complementary
is referenced separately as a Modrinth shaderpack project. **No manual step, no
`manual/` entry, no extra install-guide line** beyond "it patches itself on first
launch." Phase 2 observed this working.

### 2.4 One flag against a locked decision — not reopened

Phase 2 excluded **iris-flw-compat permanently**: Colorwheel provides `mc_Entity` for
terrain-like geometries, the author states the two conflict via mixins and will not fix
it. Unchanged and correct.

The record should show it has moved since. `1.21.1+2.3.1-release` (3 May 2026) states it
fixed Sable's embedded Flywheel rendering, fixed compatibility with Sable and Create
Aeronautics, and fixed Veil's `Unsupported Uniform Type: unsigned int` error — adjacent
to the benign `bool` spam `check.sh` now filters.

**Recommendation stands: do not reopen.** Colorwheel was tested on this exact stack and
works; iris-flw-compat was tested on this exact stack and produced translucent machines.
Observed beats described. They are mutually exclusive by mixin, so this is a
rip-and-replace of the one part of the pack that visibly works.

Phase 13 watch item only: if iris-veil-compat's levitite regression is ever fixed
upstream, iris-flw-compat 2.3.x now claims Veil coverage of its own.

---

## 3. Distant Horizons — Phase 0's version question, closed

Phase 0 said DH + Complementary compatibility was version-sensitive and would be pinned
at Phase 8, citing a cloud-through-terrain issue needing the Iris + DH compatibility v2
system.

Pinned, empirically: `3.2.0-b-1.21.1` rendered correctly with Iris `1.8.14-beta.1` and
Complementary `r5.8.1` at the Phase 2 gate and through the DH tuning work. The cloud
issue is neutralised by `overrideVanillaGraphicsSettings = true`, which disables vanilla
clouds so DH's own layers render alone.

**No DH version change proposed.** It's in the pack, it works, the freeze holds.

One setting belongs to the shader stack rather than the tick budget:

```
disableShadowPassFrustumCulling = false
```

DH's own escape hatch for shaderpacks whose shadow pass renders wrong. If Complementary's
shadows misbehave at distance — and a pack about looking down at terrain from altitude
is the worst case — this is the first value to flip. A look-for at the gate, not a change.

**Open item carried to Phase 9.5.** The Phase 8 log shows DH creating and closing
`DHLevel` and `DhClientServerLevel` for `minecraft:the_nether` and `minecraft:the_end`,
despite `ignoredDimensionCsv = "minecraft:the_nether,minecraft:the_end"`. Either the
ignore list suppresses rendering but not level bookkeeping, or the config did not apply
to that world. That setting exists to stop three simultaneous generation queues starving
the physics pipeline on the 270K hybrid, so it needs confirming before pregen at
Phase 11.

---

## 4. The mods — 4 entries

All Tier A, all Modrinth.

### 4.1 [ETF] Entity Texture Features

| Field | Value |
|---|---|
| **Source** | `modrinth.com/mod/entitytexturefeatures` — version ID `vVFfQs14` |
| **Version** | `6.2.8` (`entity_texture_features_neoforge_1.21.1-6.2.8.jar`, Nov 2024) |
| **Side** | client |
| **Size** | No content — rendering only |
| **Role** | Renders emissive regions and true transparency in player skins. **William's and both friends' skins are authored for these features**; without it, glowing armour renders flat and transparent regions render black |
| **Licence** | LGPL-3.0 |
| **Risk tier** | OPTIONAL |
| **Cut order** | 66 |
| **Known conflicts** | Patches 3D Skin Layers directly — see §4.2. Essential's `feature.skin_overwrites` would fight it, but Essential is not in the pack |
| **Keybinds** | None |
| **Grind** | None |

**EMF deliberately excluded.** Entity Model Features loads OptiFine CEM models from
resource packs; the pack ships none, so EMF and ETF-as-its-dependency would be two
rendering patches with nothing to render. Worse, VS #957 documents CEM block models
rendering invisible on ships with EMF + ETF — the same block-entity geometry failure as
the culling family. Dropping EMF closes that door. Fresh Animations was assessed as too
much risk for the pack and is the mod that would have dragged EMF back in.

**Correction to the record.** Phase 8's first draft argued against ETF by lumping it
with EMF. That was wrong. EMF needs external content; ETF's player-skin features read
data from the skin PNG itself. The content already exists and is already William's —
ETF is the only thing that renders it. Argument withdrawn on the merits.

### 4.2 3D Skin Layers

| Field | Value |
|---|---|
| **Source** | `modrinth.com/mod/3dskinlayers` — version ID `lWa5oHuK` |
| **Version** | `1.11.1` (`skinlayers3d-neoforge-1.11.1-mc1.21.1.jar`, 1 Apr 2026) |
| **Side** | client |
| **Size** | No content — rendering only |
| **Role** | Renders the player's second skin layer as extruded geometry rather than flat quads. Pairs with ETF; the combination is the actual want |
| **Licence** | tr7zw custom — ⚑ confirm and record for Phase 12 |
| **Risk tier** | OPTIONAL |
| **Cut order** | 67 |
| **Known conflicts** | **Version-paired with ETF, load-bearing** — see below |
| **Keybinds** | None |
| **Grind** | None |

**The pair is load-bearing and must be frozen together.** ETF does not merely coexist
with 3DSL — it applies a compatibility patch to it, with a config toggle whose only
purpose is disabling that patch when it conflicts. The history matches: 3DSL `1.6.0`
broke ETF and its own release notes told users to stay back until ETF caught up; ETF
later shipped a fix for 3DSL `v1.7`.

**And the gate's most useful single result: the patch holds across a seventeen-month
gap.** ETF `6.2.8` is November 2024, 3DSL `1.11.1` is April 2026, and they work together
with shaders on. This kills the contingency plan of pinning 3DSL back to `1.7.1` for
contemporaneity, and it means the pair freezes as-is.

**Never update one without the other.** Second entry after iris-veil-compat where the
freeze policy is doing real work rather than being a discipline.

### 4.3 Clumps

| Field | Value |
|---|---|
| **Source** | `modrinth.com/mod/clumps` (CF project 256717) |
| **Version** | `NeoForge-1.21.1-19.0.0.1` — ⚑ `19.0.0.1` also exists for Fabric; pin by version ID, not number |
| **Side** | **server** (1.17+ requires server side only) |
| **Size** | No content |
| **Role** | Merges XP orbs into single entities and makes pickup instant |
| **Licence** | MIT |
| **Risk tier** | OPTIONAL |
| **Cut order** | 68 |
| **Known conflicts** | None known. Replaces an entity type, so it wants one line on a moving sub-level |
| **Keybinds** | None |
| **Grind** | **Removes some.** Instant pickup ends the stand-in-the-orb-cloud wait |

Mis-filed in a performance phase. This is anti-grind infrastructure: Phase 5 built mob
and XP automation on the principle that drops come without fighting for them, and the
failure mode of that design is a farm running overnight producing an orb cloud on the
server thread. Not visible yet because the farms haven't run.

### 4.4 FerriteCore

| Field | Value |
|---|---|
| **Source** | `modrinth.com/mod/ferrite-core` |
| **Version** | `7.0.3-neoforge` — newest 1.21.1 build; 8.x and 9.x are 1.21.9+ |
| **Side** | both |
| **Size** | No content |
| **Role** | Deduplicates blockstates, model data and component patches to cut heap use |
| **Licence** | MIT |
| **Risk tier** | OPTIONAL |
| **Cut order** | 69 |
| **Known conflicts** | Touches no rendering, ticking or chunk code — the reason it's last in the cut order. `7.0.3`'s changelog specifically fixes a loading slowdown with ModernFix dynamic resources, which is moot with ModernFix shelved |
| **Keybinds** | None |
| **Grind** | None |

Honest case: it buys heap headroom for the world in six months, not the world today.
Phase 0 set idle heap footprint as a tuning requirement rather than an accepted cost.
Near-zero risk surface, accepted on that basis.

---

## 5. Gate results

Fresh scratch world, creative, single-player, per the standing rule.

### 5.1 ETF + 3D Skin Layers — **PASS**, with two accepted quirks

Tested **with shaders on**, which was not the expected order and made the result
stronger.

| Check | Result |
|---|---|
| Emissive skin regions render | **PASS** |
| Emissive under Complementary + Euphoria Patches | **PASS** — the surprise |
| Skin transparency renders as transparent, not black | **PASS** |
| ETF 6.2.8 ↔ 3DSL 1.11.1 compat patch holds | **PASS** across 17 months |
| Inventory-screen crash (the Phase 7 objection) | **Not reproduced** — fixed in ETF 6.2.8 |
| 3D layers on the vanilla player model | **PASS** |
| 3D layers on ragdolled players and corpses | **2D, accepted** |
| Emissive on ragdolled players and corpses | **PASS** |

**Accepted quirk 1 — ragdolls and corpses render 2D second layers.**

The mechanism, which is cleaner than either of the hypotheses that preceded it: all
three ragdoll mods hand the player to **Sable as a physics object**, and Sable draws it.
One code path, not three. So the rule is:

> **Vanilla player renderer → 3D layers. Sable-rendered player → 2D layers. Emissive
> survives both, because ETF works at the texture layer and Sable's renderer inherits it
> for free.**

That predicts every future case rather than describing three observed ones. William's
assessment: barely noticeable, still a clear improvement on non-ragdolled players,
accepted as a minor inconsistency.

**Accepted quirk 2 — translucent second-layer texels see through the body.**

Transparent texels on the 3D second layer still rasterize and still write depth, so the
base layer behind them is depth-rejected and you see through the player to the world.
Not ETF misreading alpha — translucent geometry doing an opaque mod's depth write, the
same class as the levitite inversion one layer up.

Only affects skins with deliberately transparent regions, and the alternative was those
regions rendering black. Accepted.

**Open, thirty seconds:** does quirk 2 reproduce with shaders off? Both → 3DSL's own
depth handling, permanent, no config fix. Shaders only → Complementary's translucent
pass ordering, possibly a shader setting. Record the answer either way.

### 5.2 Clumps and FerriteCore — outstanding

Not yet reported. Trivial expected:

```
[ ] Clean start, no missing registry / duplicate mod / dependency / mixin failures
[ ] check.sh clean (Veil-filtered)
[ ] grep -i "overwrite conflict" latest.log
[ ] Clumps side = server in its .pw.toml
[ ] Clumps: orbs merge on a farm; die on a moving sub-level and confirm orbs behave
[ ] World load time vs the phase-7-pass baseline
```

### 5.3 `configureddefaults` seeding — outstanding, and it matters most

The mechanism the entire keymap and render-stack config plan rests on. Phase 7 proved it
for `options.txt` only.

```
[ ] Fresh instance. Seeded files land at their real paths
[ ] Change one setting in each, relaunch, confirm NOT reverted
```

Cannot be tested in the existing dev instance — Configured Defaults only copies when the
destination is absent, and they all exist there.

### 5.4 Flywheel first-placement stall — outstanding, oldest open question

```
[ ] /flywheel backend off, place a contraption. Stall still present?
    -> yes: not Flywheel instancing setup; cause is upstream of rendering
[ ] Default backend, place a contraption, watch the world clock —
    mobs moving, water flowing, a Create shaft still spinning
    -> world keeps ticking: client render thread, one-time compile, cosmetic
    -> everything freezes: server main thread, and Phase 10's large builds worsen it
```

Five minutes, and it decides whether this is a first-use hitch or a scaling problem.

---

## 6. Cut and shelved

### 6.1 Cut this phase, after testing

**Sable: Far and Wide** `1.0.0` — **CUT.**

Proposed to fill the hole SSRD left: stock Sable loads a sub-level only when *all* its
chunks are loaded and unloads when *any* isn't; Far and Wide changes that to centre-chunk
load and all-chunks-out unload, so large ships stop vanishing at chunk boundaries.

Isolation-tested on `spike/far-and-wide` against the `phase-7-pass` baseline. **Result:
reliable crash on world load** —

```
ConcurrentModificationException
  HashMap$Values.forEach
  ftbchunks MapManager.saveAllRegions(MapManager.java:174)
  ftbchunks FTBChunksClient.renderHud(FTBChunksClient.java:525)
```

FTB Chunks' minimap saves map regions during HUD render, iterating a HashMap while
another thread inserts into it. Far and Wide appears nowhere in the trace — it changes
chunk load timing, which widens an existing race until it fires every time on world load.
**Removing Far and Wide fixed it.**

FTB Chunks is Phase 7 infrastructure: claiming, force-loading, and the border claim-ring
that is now the world-border solution. It isn't going anywhere. Far and Wide loses.

What makes it an easy call: **the benefit was never measured.** It crashed before the
load-distance test could run, so there is no evidence it changes Sable 2.0.3's behaviour
at all. A definite cost against an unmeasured benefit.

**Closed as a final cut. No measurement pending.** The follow-up test was declined, on
the grounds that the benefit was never clear enough to be worth chasing — which is a
reasonable call given the requirement it served has non-mod answers (§12, Phase 9.5).
Do not re-propose without new evidence that ships are actually vanishing in play.

For the record, what it was for: stock Sable unloads a sub-level the moment **any** of
its chunks falls outside the loaded region. A ship longer than the distance between the
player and the chunk boundary can therefore unload while you are standing on it. Far and
Wide changed that rule to unload only when **all** chunks are outside. Whether that
failure is reachable at this pack's simulation distance was never established.

**Aeronautics Camera Sync** `1.3.1` — **CUT. Did not do the job it appeared to do.**

Tested. The tilt is **visual only** — it rotates the view, but the player is still
oriented to world space. Standing on a banking deck, the world leans; you do not. The
mod's name and description read as though the player becomes local to the sub-level, and
it doesn't.

The wanted feature is **player orientation local to the sub-level** — walking a tilted
deck as though it were level, with movement input, gravity and collision all resolved in
the sub-level's frame rather than the world's. That is an engine-level capability, not a
camera mixin, and no mod evaluated in this project provides it.

> **Lead worth following before concluding it doesn't exist.** The Phase 8 crash log
> shows Sable registering `sable.mixins.json:camera.camera_rotation.*` and
> `camera.new_camera_types.*` — **Sable ships its own camera rotation.** So part of what
> Camera Sync provided may already be present and configurable, and the deeper
> local-orientation behaviour may be a Sable setting or a known Sable limitation rather
> than a missing mod. Worth ten minutes in Sable's config and its issue tracker at
> Phase 9.5, where sub-level bounding is already on the list.

Not a rendering problem, so it does not return to Phase 8. Recorded as a **want**, not a
cut with a replacement.

**Lithium** `mc1.21.1-0.15.3-neoforge` — **WITHHELD to Phase 9.** See §6.3.

### 6.2 The shelf — rejected, not cut

None of these write world data or become load-bearing. Each is addable post-launch in a
changelog line and a relaunch, if a specific complaint appears.

| Entry | Add it when |
|---|---|
| **ImmediatelyFast** `1.6.10+1.21.1-neoforge` | A Deck user reports GUI-heavy stutter. Batches immediate-mode rendering — HUD, GUIs, item models in EMI. Carries an open Aeronautics bug (#229: Creative Staff of Physics renders stretched) and would be the **fifth** mod batching container screens |
| **ModernFix** `5.27.12+mc1.21.1` | Startup time becomes a real complaint. **If ever added: disable the watchdog** — Sable #308 is a server killed by it during a physics stall. Leave `dynamic_resources` off |
| **Sodium Dynamic Lights** + **Create Sable Dynamic Lights** | You want lit airships casting light on terrain below. The bridge (`2.3.1-sodium-sable`, Apr 2026) is built for this stack; its required dependency's newest 1.21.1 build is **Jan 2025**, predating Sodium 0.8 and hooking the options screen 0.8 rewrote. Client-side, cheap bet, ~50/50 |

### 6.3 Lithium — the reversal, in full

Phase 8's first draft recommended Lithium with a "named caveat" about collision-subsystem
overlap with Sable. That was reasoning without checking, and the tracker says worse.

| Issue | Date | State | What |
|---|---|---|---|
| ryanhcode/sable #21 | 18 Apr 2026 | closed | Mod-loading error, Lithium `0.15.3` + Sable `1.0.4` — the exact build proposed |
| #24 | 18 Apr 2026 | closed | Sable **declared Lithium incompatible in metadata**; NeoForge refused to start |
| **#242** | 20 Apr 2026 | **open** | Propeller bearing placed → server crashed instantly, then crashed on every reconnect. Removing Lithium fixed it |
| **#308** | 21 Apr 2026 | **open** | Server killed by a watchdog timeout; reporter's read is Lithium postponing player collisions and Sable choking |
| #922 | 17 May 2026 | closed | Both installed → tick lag and freeze after physics entities spawn |

#308 names the exact mechanism the draft predicted — which is not reassuring, because it
means the prediction was right and the outcome is a dead server.

**Mitigating:** all five predate Sable 2.0 (13 June 2026), and Sable's current
`neoforge.mods.toml` on `main` no longer declares Lithium incompatible, so the hard block
was deliberately removed. **Against:** `main` is Sable `2.0.5` and the pack pins `2.0.3`,
there are no release tags to diff, and #242 and #308 are still open. No Lithium report
exists against Sable 2.x either way — which could mean fixed, or could mean nobody runs
both any more.

**Deferred to Phase 9**, where a dedicated server exists and "the server freezes when
someone places a propeller bearing" is testable properly. First check costs thirty
seconds: if 2.0.3 still carries the incompatibility declaration, the game won't launch.

If it is ever adopted: **disable Lithium's collision and entity-movement group in
`lithium.properties` before pulling the mod or suspecting Sable.** Every Lithium patch is
individually disableable, which is the mitigation the subsystem overlap deserves.

---

## 7. Unsafe with Sable sub-levels — the exclusion list

Charter asked to be specific rather than listing the usual suspects by reflex.

### 7.1 The culling family — excluded, and the evidence is overwhelming

**Entity Culling, More Culling, Brute Force Rendering Culling, Sodium Extras entity
culling — all out.**

The mechanism is geometry: culling mods decide what to draw by comparing a block entity's
*block position* to the camera. A block entity on a moving sub-level has a block position
in the sub-level and a render position in the world. They disagree.

The failure is **functional, not cosmetic**, which is worse than the first draft claimed:

- **Aeronautics #1347** (30 Jul 2026, open) and **Sable #1414** (30 Jul 2026, open):
  Entity Culling breaks contraptions using block entities — analog lever, shaft,
  windmill — making them **unusable**
- **Sable #1107** (4 Jun 2026, open): entity on a moving sub-level leaves view, its
  position **stops updating**, becomes invisible client-side. Desync, not rendering
- **Sable #752** (4 May 2026, closed): straight crash; disabling Entity Culling fixed it;
  reporter asked for it to be added to the incompatible list
- **Aeronautics #1223** (13 Jun 2026, closed): crash on world join after updating
  Sodium + Reese's + Sodium Extras + MoreCulling together — three exclusions in one report
- **Aeronautics #836** (30 Apr 2026, open): propeller bearing contraptions don't render
  with Flywheel off and Sodium Extras entity culling on
- **EntityCulling's own docs** instruct whitelisting block entities that render beyond
  their bounds, naming **Create pulleys**
- **VS wiki's** first-line fix for invisible ship blocks is disabling max block-entity
  culling distance

Not worth the frames. Overruling means hand-maintaining a whitelist of every Create block
entity that renders outside its own block — a grind that never ends.

**The free win** — §8.2 — costs no mod at all.

### 7.2 Everything else, with reasons

| Excluded | Why |
|---|---|
| **Sable: New Sodium Compat** | **Permanently cut.** The project is **archived**, and its function is backporting Sodium support **to Sable 1.2.2**. The pack runs 2.0.3, where it's native. Installing it would be a 1.2.2 patch against a 2.0.3 mod. Deferred here at Phase 2; resolved as a cut. Do not re-propose |
| **ScalableLux** | **Sable declares it incompatible in its own metadata.** Not a judgement call |
| **Nvidium** | NVIDIA-only, so it optimizes one machine and nothing at the Deck floor. No shader support, and shaders are a design goal. Named on the VS wiki as a cause of invisible ship blocks |
| **Embeddium** | A Sodium fork; cannot coexist with Sodium, which Sable hard-requires |
| **C2ME** | Rewrites the chunk system. DH's own config warns about thread starvation with C2ME present, and DH thread contention is already a known issue here. More decisively: the world is **pregenerated at Phase 11 inside a 5120×5120 border**, so chunk generation is a one-time cost already accounted for. C2ME optimizes a problem this pack designed away |
| **Noisium** | Worldgen internals, in a world generated once and never reset |
| **ThreadTweak (Reforged)** | The original is Fabric/Quilt. The NeoForge fork's CF file page reports **third-party sharing disabled** — packwiz cannot fetch it, so it would become a `manual/` entry. Tier C cost for a thread-priority slider. DH contention is already handled by `numberOfThreads = 4` and `threadRunTimeRatio = 0.5` |
| **Memory Leak Fix** | No NeoForge 1.21.1 build |
| **Sodium Extra / Reese's Sodium Options** | Both hook the Sodium options screen that 0.8 rewrote. Implicated in Aeronautics #1223 |
| **Exordium** | Would be a fifth mod batching container screens, and trades HUD responsiveness for frames — wrong trade where the HUD is Jade, EMI and a minimap |
| **[EMF] Entity Model Features** | Needs a CEM resource pack the pack doesn't ship. VS #957: CEM blocks render invisible on ships |
| **Fresh Animations** | Assessed as too much risk; it is the reason EMF would return |
| **Particle Core** | Could not confirm a 1.21.1 NeoForge build. Deferred Wishlist, not proposed |
| **Voxy** | Already cut at Phase 0 |
| **iris-flw-compat** | Already cut permanently at Phase 2. See §2.4 |

---

## 8. Config — the part of this phase worth more than the mods

### 8.1 Extend the Phase 7 rule: seven more files Minecraft rewrites

Phase 7 §1.2 established that packwiz must never ship a file at a path Minecraft itself
rewrites, and applied it to `options.txt`. **The rendering and cosmetics stack is full of
these**, and every one has the same failure mode: packwiz overwrites a friend's settings
on every launch, or the installer's hash cache means their file never comes back.

| File | Written by | Ship as |
|---|---|---|
| `config/sodium-options.json` | Sodium, on every Apply in video settings | `configureddefaults/config/` |
| `config/iris.properties` | Iris, on shader selection or settings change | `configureddefaults/config/` |
| `config/DistantHorizons.toml` | DH, from its in-game options screen | `configureddefaults/config/` |
| `shaderpacks/<patched-pack>.txt` | Iris, on shader-pack settings change | `configureddefaults/shaderpacks/` |
| ETF config | Its own config screen | `configureddefaults/config/` |
| 3D Skin Layers config | Its own config screen | `configureddefaults/config/` |
| EMI config (Phase 7 carry-over) | EMI stores keybinds separately | `configureddefaults/config/` |

**Closes** the Phase 2 open item (`config/iris.properties` committed — NOT DONE) **and
settles** the Phase 12 question about `DistantHorizons.toml`: it is not a client-override,
it is a Configured Defaults seed. Same mechanism as the keymap, same reasoning, one rule.

**Seed, don't enforce.** All client taste; a friend on a Deck must be able to change them
without the pack fighting back. ETF and 3DSL configs ship with the features **on**, since
their defaults are off and the features are the entire reason those mods are in.

**Not seeded, deliberately:** `flywheel-client.toml`. Ship nothing — the default backend
is the one that works, and any file shipped can only pin us to a worse answer.

> **Rule for `docs/standing-rules.md`:** any config a mod rewrites from its own in-game
> settings screen ships via `configureddefaults/`, never at its real path. When adding a
> mod, the question is not "does it have a config" but "does it have an options screen."

**Discovery procedure**, because guessing paths is how the `options.txt` failure happened:

```bash
cd <instance>/.minecraft
ls -1 config shaderpacks > /tmp/before.txt
# launch, touch every settings screen, quit cleanly
ls -1 config shaderpacks > /tmp/after.txt
diff /tmp/before.txt /tmp/after.txt
find config shaderpacks -newermt '-2 hours' -type f
```

Then a second pass — change one setting per screen, quit, re-run `find` — identifies
which files are rewritten on exit, which is the actual test for belonging in
`configureddefaults/`.

**Safety check after `packwiz refresh`:**

```bash
grep -nE "sodium-options|iris.properties|DistantHorizons|entity_texture|skinlayers" index.toml
```

Every hit must sit under `configureddefaults/`. A bare `config/…` path is the
`options.txt` failure waiting to recur.

### 8.2 Two Sodium settings — the free win the culling mods weren't worth

- **Block-entity culling distance: off / maximum.** Sodium's own built-in block-entity
  culling is the same geometry bug as §7.1, and the VS wiki's first-line fix for
  invisible ship blocks is disabling it. Free, in a mod already shipped.
- **Block face culling: verify on a sub-level before deciding.** Same family, less
  certain. Check at the gate rather than setting blind.

**Seeding cannot protect this one.** Block-entity culling distance is a *correctness*
setting, not taste — a friend who turns it back on hunting frames gets invisible machines
on their airship and will report it as a Sable bug. It can't be enforced without wiping
their video settings, so: seed it, document it, and make "have you touched block entity
culling" the first question when someone says their ship looks broken.

### 8.3 The shaderpack settings filename is fragile

Iris stores per-pack settings as `shaderpacks/<packname>.txt`, and Euphoria Patches
*generates* the patched pack — so the filename encodes both the Complementary version and
the Euphoria version. Update either and the seeded file silently matches nothing.

The shader tuning survives exactly as long as those two versions are frozen. Comment it
in the repo next to the file, and put it in the Phase 12 update workflow.

### 8.4 Flywheel backend — ship nothing, document the trap

Phase 2 tested all four:

| Backend | Result |
|---|---|
| `flywheel:instancing` | Default. Unavailable with shaders standalone — **Colorwheel restores it** |
| `irisflw:iris_instancing` | Chains render as beams of light. Dead with iris-flw-compat cut |
| `flywheel:indirect` | **Coasters chain lifts vanish — with shaders OFF as well.** A real bug, nothing to do with shaders |
| `flywheel:off` | Renders correctly, no instancing |

`flywheel:indirect` is the setting a friend will find while hunting frames, and it
silently breaks Coasters. Install guide, "things that go wrong." Phase 2 established a
clean three-command reproduction — still worth reporting to the Coasters authors.

### 8.5 The shipped DH profile is tuned for a 5070 Ti

```
maxHorizontalResolution      = "BLOCK"     # the fanciest setting available
verticalQuality              = "MEDIUM"
enableTexturedLods           = true
enableSsao                   = true
lodChunkRenderDistanceRadius = 128
numberOfThreads              = 4
threadRunTimeRatio           = "0.5"
```

`BLOCK` renders 256 LODs per chunk. With textured LODs and SSAO at a 128-chunk radius,
that is a high-end profile seeded to a group whose floor is a Steam Deck, on four threads
a Deck doesn't have spare.

Not a problem — Configured Defaults seeds rather than enforces, and Phase 0 accepted that
the floor turns DH off. But it should be *documented* rather than accidental. **Decision:
ship as-is and document the three values to change** — the pack should look its best by
default on the hardware most of the group has.

Two values already right, encoding decisions from other phases, to be commented as
deliberate so a future session doesn't "fix" them: `enableDistantGeneration = false`
(Phase 11 pregenerates) and `generationMaxChunkRadius = 160` — 160 chunks is 2560 blocks,
exactly the 5120×5120 border's half-width.

---

## 9. The two live technical issues

### 9.1 World border invisible under shaders — reframed, and filed upstream

The vanilla world border does not render when Sable + Iris + Sodium are all active, under
both Complementary and Photon. Narrowed to that combination; root cause unknown.

**Filed by William as Sable #1502 (23 Aug 2026), open** — on Sable's tracker rather than
Iris's, which is the right place given it reproduces with any one of the three removed.

No verified fix, and none will be invented here. The requirement has been re-solved by
other means, and the shader bug should stop being treated as a blocker. It splits in two:

**As a safety requirement** — sub-levels pass straight through the border, ejecting the
player while the ship continues. A rendered wall of blue lines was never going to prevent
that. This is a **Phase 9.5 bounding problem**: does Sable expose a border-aware clamp,
does Aeronautics, or failing both, a datapack that detects a player outside the border.
Not a rendering problem, and Phase 8 hands it over cleanly.

**As a navigation requirement** — Phase 7 §3.3 already defined the escalation, and the
fallback was a **one-chunk claimed ring along the border**, rendered on both the full map
and the minimap with protection disabled. That answer is *better* than the vanilla border
here: **it is map paint, not world geometry, so it is immune to the shader bug entirely**,
and it renders on the minimap, which the vanilla border never did.

Recommendation: stop chasing the shader bug, ship the claim ring, move the safety half to
Phase 9.5. Keep #1502 on record for Phase 13 — a future Iris or Sodium build fixing it is
free.

### 9.2 Flywheel first-placement stall (~3 s) — still open

The oldest open question in the pack. Test defined in §5.4; five minutes.

---

## 10. The Steam Deck floor profile

Phase 0 set the floor and named its compromises. Phase 8 owes the values, for the install
guide. Paste-in list, not advice.

```
Video settings
  Render distance        8
  Simulation distance    6   (server-side setting; client value is a cap)
  Graphics               Fast
  Shaders                OFF  (Options > Video > Shader Packs > "(internal)")

Distant Horizons  (Options > the button next to FOV)
  Enable Rendering       false          <-- single biggest win
  If keeping it on:
    lodChunkRenderDistanceRadius   32
    maxHorizontalResolution        "FOUR_BLOCKS"
    numberOfThreads                1
    enableSsao                     false
    enableTexturedLods             false

Sodium
  Block-entity culling distance: LEAVE AT OFF/MAX. Not a performance setting —
  turning it on makes machines on airships invisible

Sound Physics Remastered
  Disable, or reduce ray count. It raycasts every sound against world geometry

FTB Chunks
  Minimap off if frames are marginal
  (also the workaround for the MapManager CME — see §6.1)

3D Skin Layers
  Turn off if frames are marginal. ETF's skin features are unaffected
```

**Standing caveat for the install guide, verbatim, so nobody files it as a bug:** none of
this helps near a large moving contraption. Physics sub-level cost does not scale down
with render distance — simulating and rendering a moving ship is work the client does
regardless of how far it can see. A Deck will struggle specifically next to big airships,
and settings will not fully fix that.

---

## 11. Cut order

| # | Entry |
|---|---|
| 66 | [ETF] Entity Texture Features |
| 67 | 3D Skin Layers |
| 68 | Clumps |
| 69 | FerriteCore |

ETF and 3DSL first because they are a patched pair in the pack's most-crowded subsystem —
ten mods now touch player and entity rendering. Clumps and FerriteCore last because
neither patches rendering, ticking or chunk code.

**Note for Phase 10, which owns the consolidated list.** This block should move to the
**top** of the final cut order, above everything from Phases 1–7. Nothing here provides
gameplay beyond cosmetics; pulling all four costs some heap headroom and some skin shine
and removes no feature. The append-by-phase convention gets that backwards and Phase 10
should fix it once, globally.

---

## 12. Records to update on pass

**`docs/lockfile.md`** — 4 rows from `grep -E "^name|filename" mods/*.pw.toml`.

**`docs/exceptions-register.md`** — no new rows. Nothing Tier C, nothing in `manual/`.

**Phase 12 restrictive-licence list** — 3D Skin Layers ships tr7zw's custom licence;
confirm and record. ETF is LGPL-3.0, Clumps and FerriteCore MIT.

**`docs/standing-rules.md`** — three additions:
- §8.1: configs with an in-game options screen ship via `configureddefaults/`
- §4.2: ETF and 3D Skin Layers are a version-locked pair; never update one alone
- §6.3: if Lithium is ever adopted, disable its collision group before pulling it or
  suspecting Sable

**`docs/keymap.md`** — **no change.** All four entries register zero keybinds.

**Install guide** — new sections: the §10 Deck profile; the `flywheel:indirect` trap; one
line that Euphoria Patches needs no manual step; and the block-entity-culling warning.

**Cut register** — permanent, alongside Xaero's, Vista and Storage Drawers:
**Sable: Far and Wide** (FTB Chunks CME on world load; benefit unmeasured, closed) ·
**Aeronautics Camera Sync** (tilt visual only, player stays world-oriented) ·
**Sable: New Sodium Compat** (archived, targets
Sable 1.2.2) · **Entity Culling / More Culling / Brute Force Rendering Culling** ·
**ScalableLux** (Sable declares incompatible) · **Nvidium** · **Embeddium** · **C2ME** ·
**Noisium** · **ThreadTweak Reforged** · **Memory Leak Fix** · **Sodium Extra /
Reese's** · **Exordium** · **EMF** · **Fresh Animations**.

**Deferred Wishlist** — the §6.2 shelf (ImmediatelyFast, ModernFix, the dynamic lights
pair), plus **Particle Core** (unverified on 1.21.1 NeoForge) and
**Halew3/Sound-Physics-Aeronautics** (Tier B GitHub, lets Sable sub-levels contribute
moving geometry to acoustic occlusion — the place to look if Phase 7's Sound Physics
sub-level criterion ever fails).

**Closed from earlier phases** — Euphoria Patches distribution method (Phase 0) ·
DH + Complementary version pin (Phase 0) · `config/iris.properties` committed (Phase 2) ·
SSRD / simulation-distance replacement (Phase 2, resolved as *no mod*) · Sable Dynamic
Lights and Sable: New Sodium Compat (Phase 2) · 3D Skin Layers (Phase 7) ·
`DistantHorizons.toml` placement (was Phase 12).

**Phase 9** — Lithium compatibility test against Sable 2.0.3 on a real server.

**Phase 9.5** — four new items: **local-space player orientation on sub-levels** —
check Sable's own `camera.camera_rotation` / `camera.new_camera_types` settings and its
issue tracker before concluding no solution exists (§6.1); **world-border bounding for
sub-levels** (§9.1);
**DH `ignoredDimensionCsv` not suppressing Nether/End level creation** (§3); and the
**ships-vanishing requirement**, now unmet by any mod. Two non-mod levers: raise server
simulation distance so the boundary sits beyond ordinary flying, and use FTB Chunks
force-loading on bases and common routes.

**Phase 13** — if iris-veil-compat's levitite regression is fixed upstream, re-examine
whether iris-flw-compat 2.3.x plus a Veil fix beats Colorwheel. Watch item only.

---

## 13. Corrections to the record

Three, stated plainly because a phase document that only records successes is not useful
six months from now.

**1. Lithium was recommended without checking the tracker.** The draft flagged the
collision-subsystem overlap by reasoning and stopped there. Sable's tracker had five
reports, two open, one describing a server that crashed on every reconnect after a
propeller bearing was placed. The reasoning was right; the research order was wrong.
Reversed in §6.3.

**2. ETF was argued against by association with EMF.** They do different jobs. EMF needs
an external CEM resource pack; ETF's player-skin features read the skin PNG. The argument
was withdrawn on the merits and ETF passed its gate cleanly.

**3. Sable #1502 was described as "reported by someone else."** It is William's own bug
report, filed the day he found it.

**And one thing the heuristics got wrong, worth recording so the wrong lesson isn't
learned.** The **Sable 2.0 fault line did not fire on Far and Wide.** It predates 13 June
2026 and was flagged on that basis, but it loaded fine against Sable 2.0.3 — the failure
came from an unrelated third-party mod's HUD threading. The heuristic is good and stays;
this is evidence it doesn't catch everything, and it would have been easy to file this as
"fault line confirmed again."

**What worked:** the isolation-test discipline, exactly as designed. One mod, one scratch
branch, crash on load, one command to attribute it. Had Far and Wide gone in with the
other five, the result would have been a twelve-mixin HUD stack trace with no way to know
which addition caused it.

---

## 14. Verification log

Confirmed by search or source read, not asserted from memory.

| Claim | Source |
|---|---|
| ETF `6.2.8` is a 1.21.1 NeoForge build; its changelog fixes an inventory-screen crash with 3D Skin Layers when player skin features are active | Modrinth version `vVFfQs14` |
| 3D Skin Layers `1.11.1` supports 1.21.1 NeoForge, published 1 Apr 2026 | Modrinth version `lWa5oHuK` |
| ETF applies a compatibility patch to 3D Skin Layers, with a config toggle to disable it | ETF `4.4.3` changelog |
| 3DSL `1.6.0` broke ETF; its notes told users to stay on the older version | 3DSL `1.6.1-1.20.4` version page |
| Clumps `NeoForge-1.21.1-19.0.0.1`, MIT, server-side only on 1.17+ | Modrinth version page; CF description |
| FerriteCore's newest 1.21.1 NeoForge build is `7.0.3-neoforge`; 8.x/9.x are 1.21.9+ | Modrinth version list; CF file list |
| **Sable declares `scalablelux` incompatible, and Sodium below a floor incompatible; Lithium is no longer declared incompatible on `main` (Sable 2.0.5)** | `ryanhcode/sable` `neoforge/src/main/resources/META-INF/neoforge.mods.toml`, read directly |
| Five Sable issues report Lithium incompatibility: #21, #24, #242, #308, #922 | GitHub search, `repo:ryanhcode/sable` |
| Entity Culling breaks Aeronautics and Sable contraptions functionally | Aeronautics #1347; Sable #1414, #1107, #752; Aeronautics #836, #1223 |
| EntityCulling's docs instruct whitelisting block entities that render beyond their bounds, naming Create pulleys | Modrinth/CF project description |
| VS wiki's first-line fix for invisible ship blocks is disabling max block-entity culling distance; Nvidium named as another cause | Valkyrien Skies wiki, Common Issues |
| **Sable: New Sodium Compat is archived and backports Sodium support to Sable 1.2.2** | Modrinth project page and version `1.0.0` |
| Sable: Far and Wide `1.0.0`, 23 May 2026, changes sub-level load from all-chunks to centre-chunk | Modrinth project description |
| Aeronautics Camera Sync `1.3.1`, CC-BY-ND-4.0, 1.21.1 NeoForge; `1.3.0` fixed a `GameRendererPickMixin` crash; docs warn modded thrown items cause wrong arcs or crashes and provide an item blacklist | Modrinth version pages `1.3.0`, `1.3.1`, project description |
| Euphoria Patches is a mod jar that auto-detects and binary-patches Complementary in `shaderpacks/`; Complementary's licence forbids republishing a derived pack | EuphoriaPatcher GitHub README; Euphoria Patches FAQ |
| iris-flw-compat `2.3.1-release` claims fixes for Sable's embedded Flywheel and Veil's unsigned-int uniform error | Modrinth version page |
| Colorwheel provides `mc_Entity` for terrain-like geometries, making iris-flw-compat incompatible | Colorwheel `1.2.3` changelog |
| ThreadTweak is Fabric/Quilt only; the NeoForge fork's CF file page reports third-party sharing disabled | Modrinth project page; CF file 6584552 |
| Memory Leak Fix has no NeoForge build | Modrinth optimization collection listing |
| ModernFix `5.27.12+mc1.21.1` on Modrinth; CF carries `5.27.20+mc1.21.1` | Modrinth and CF version pages |
| ImmediatelyFast `1.6.10+1.21.1-neoforge`; open Aeronautics bug #229 (Creative Staff of Physics renders stretched) | Modrinth version page; Aeronautics #229 |
| Sodium Dynamic Lights' newest 1.21.1 build is `neoforge-1.21.1-1.0.10`, 2 Jan 2025; Create Sable Dynamic Lights `2.3.1-sodium-sable`, 30 Apr 2026 | Modrinth version pages |
| EMF requires ETF and loads OptiFine CEM models from resource packs | Modrinth/CF project description |

**Unverified, resolve when relevant:** 3D Skin Layers licence text · whether a 1.21.1
NeoForge ETF newer than `6.2.8` exists · whether Modrinth carries ModernFix `5.27.20` ·
whether ImmediatelyFast `1.6.12` exists for 1.21.1 · whether Sodium Dynamic Lights
`1.0.10` still requires Sodium Options API · Particle Core on 1.21.1 NeoForge · which
Sable build removed the Lithium incompatibility declaration (no release tags exist).

---

## 15. Change log

| Date | Change | Reason |
|---|---|---|
| 24 Aug 2026 | Phase 8 drafted at 8 entries | Phase 2 absorbed the rendering stack |
| 24 Aug 2026 | Shader spike closed: **ship shaders**, Colorwheel + iris-veil-compat alpha | Both bridges resolved at the Phase 2 gate by observation |
| 24 Aug 2026 | Euphoria Patches distribution question closed — **no manual step** | Self-applying patcher jar, not a shaderpack |
| 24 Aug 2026 | DH version pin closed at `3.2.0-b`, empirically | Passed the Phase 2 gate with Iris 1.8.14-beta.1 + Complementary r5.8.1 |
| 24 Aug 2026 | Culling mods excluded as a class | Documented across five Sable/Aeronautics issues; failure is functional, not cosmetic |
| 24 Aug 2026 | Sable: New Sodium Compat cut permanently | Archived; targets Sable 1.2.2 against a 2.0.3 pack |
| 24 Aug 2026 | `configureddefaults/` rule extended to seven configs | Same failure mode as `options.txt` |
| 25 Aug 2026 | **Lithium reversed** — withheld to Phase 9 | Five Sable issues; #242 server crash on propeller bearing placement, #308 collision timeout |
| 25 Aug 2026 | ModernFix, ImmediatelyFast, dynamic lights **shelved** | *"I am kind of happy with the state of optimisation."* No prune-after-play; nothing here is irreversible |
| 25 Aug 2026 | **ETF argument withdrawn**, EMF stays cut | ETF's skin features need no resource pack; EMF's CEM models do |
| 26 Aug 2026 | **Sable: Far and Wide CUT** after isolation test | FTB Chunks `MapManager.saveAllRegions` CME on world load; removing it fixed it. Benefit never measured |
| 26 Aug 2026 | **Aeronautics Camera Sync CUT** | Tilt is visual only; player stays world-oriented. Did not deliver local-space player orientation |
| 26 Aug 2026 | **Far and Wide closed as a final cut**, follow-up measurement declined | Benefit never clear enough to chase; the requirement has non-mod answers |
| 26 Aug 2026 | ETF + 3D Skin Layers **PASS with shaders on** | Emissive and transparency both render; ETF↔3DSL patch holds across 17 months |
| 26 Aug 2026 | Two cosmetic quirks accepted | Sable-rendered players get 2D layers; translucent texels see through the body |
| 26 Aug 2026 | World border reframed as two requirements | Navigation → Phase 7's claim ring; safety → Phase 9.5. Filed as Sable #1502 |
| 26 Aug 2026 | Phase closes at **76 entries** | 4 added: ETF, 3D Skin Layers, Clumps, FerriteCore |
