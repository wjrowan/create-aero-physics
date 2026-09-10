# Phase 3 — Create Breadth

**Pack:** Create Aeronautics Physics Server
**Status:** COMPLETE — decisions closed, **gate passed 16 Aug 2026**
**Entering state:** 22 entries (4 Phase 1 + 18 Phase 2)
**Final batch:** **6 mods, all Modrinth, none ARR, none manual** — plus Simurail as a `manual/` spike
**Exit state if the gate passes:** 28 entries

---

## 0. Housekeeping before you add anything

Three carried items from the Phase 2 gate block this phase. Do them first so the
gate result is attributable.

```bash
cd ~/Source/create-aero-physics/pack

# 1. Throwaway mod must not enter a phase commit
packwiz remove create-waterparked
packwiz refresh
git status

# 2. Physics Compat side fix
sed -i 's/^side = "server"/side = "both"/' mods/*physics-compat*.pw.toml
grep -H '^side' mods/*physics-compat*.pw.toml

# 3. Capture Phase 2 versions before adding more
for f in mods/*.pw.toml; do echo "== $f"; grep -E "^name|filename" "$f"; done
```

**New scratch world for this phase.** Not negotiable after what the carried
world did to the Phase 2 gate.

### Check `manual/` is actually ignored — it was set up at Phase 0.5, verify it held

```bash
cd ~/Source/create-aero-physics
git check-ignore -v manual/simurail-1.21.1-0.0.0-a+0b3230f.jar   # should print the rule
git ls-files manual/                                             # should print NOTHING
```

If the second command prints anything, that file is already tracked and
`.gitignore` will not retroactively remove it:

```bash
git rm --cached manual/<file>
```

**Prefer this pattern over a bare `manual/` line**, because a bare entry ignores
the directory itself — so a fresh clone has no `manual/` at all, and you cannot
keep a README in it explaining what belongs there:

```gitignore
# No jars anywhere in this repo, ever
*.jar

# Manual folder: contents ignored, folder and its note kept
manual/*
!manual/README.md
```

The `*.jar` line is belt-and-braces for the distribution principle — it catches a
jar dropped anywhere in the repo, not just in `manual/`. Given that
`packwiz refresh` will happily index a stray jar into `index.toml`, that is worth
having.

`manual/README.md` should be one paragraph: what this folder is, that its
contents are deliberately untracked, and that `docs/exceptions-register.md` is
the authoritative record of what should be in it. That is what makes the folder
reconstructible from the repo, which is the whole point of the register.

---

## 0.5 Source policy — Modrinth first, CurseForge only as fallback

**Rule for this pack: always try `packwiz mr add` first. Only reach for
`packwiz cf add` when the mod genuinely does not exist on Modrinth, or when the
Modrinth build is so far behind that taking it would mean shipping a known-worse
version.**

This is not cosmetic. Modrinth entries resolve by slug reliably (the CurseForge
search API unreliability that bit you earlier is a CF-side problem), the metadata
carries proper `side` values more often, and the `.mrpack` export path at Phase 12
is cleaner when the manifest is Modrinth-native.

### Source table

| Mod | Modrinth slug | Falls back to CF? |
|---|---|---|
| Create: Copycats+ | `copycats` | No |
| Copycats+ Aeronautics Weight | `copycats+-aeronautics-weight` | No |
| Create Crafts & Additions | `createaddition` | **Check version parity** |
| Create: Connected | `create-connected` | **Check version parity** |
| Create: Linear Bearing | `linear-bearing` | No — Modrinth looks ahead of CF here |
| **Any CF project with third-party sharing disabled** | — | **`cf add` will fail outright — see below** |
| ~~Throwable Rope Connector~~ | — | **CUT** |
| ~~Create: Simulated Thrusters~~ | — | **CUT** |
| ~~Create Propulsion: Simulated~~ | — | **CUT — content mod, not a propulsion mod** |
| Climbable Ropes | `create-aeronautics-climbable-rope` (**singular**) | No — correction, it is on Modrinth |
| ~~Create: Power Loader~~ | — | **Dropped — FTB Chunks at Phase 7** |
| ~~Steam 'n' Rails~~ | — | **Deferred to Phase 4** |
| ~~Jet Engines / Aero Propulsion~~ | — | **CUT — duplicate of Thrusters** |
| ~~Sablewaves~~ | — | **Dropped** |

### Three version-parity cases — **RESOLVED: take the newer build**

Modrinth-first occasionally means Modrinth-older. Your ruling, 16 Aug 2026:
**where CurseForge carries a newer 1.21.1 NeoForge build than Modrinth, take the
CurseForge build.** Newest wins; Modrinth-first is a tie-breaker, not a version
ceiling.

| Mod | Modrinth | CurseForge | Take |
|---|---|---|---|
| Create: Simulated Thrusters | `1.0.1` (21 May 2026) | `1.1.1` (9 Jun 2026) | **CF `1.1.1`** — CF project **1546743** |
| Create Crafts & Additions | unconfirmed, ≤ `1.5.x` seen | `1.6.0` (2 Jun 2026) | **Verify Modrinth first.** If it resolves `1.6.0`, use Modrinth. If not, CF project **439890** |
| Create: Connected | unconfirmed | `1.3.2-mc1.21.1` (22 Jun 2026) | **Verify Modrinth first.** If it resolves `1.3.2`, use Modrinth. If not, CF project **947914** |

**Only Thrusters is a confirmed miss.** For the other two I could not read
Modrinth's version list directly — the page renders it client-side — so the
comparison is genuinely unknown rather than known-bad. Run `packwiz mr add`,
look at what it pinned, and switch to CF only if the number is lower than the
CF number above. Do not pre-emptively route them to CurseForge on my say-so.

**One caveat on "newest wins," and it is the only reason I would not apply this
rule blindly.** These are young mods on your accepted-alpha list, and newest also
means least-tested. `1.1.1` of Thrusters has had roughly ten weeks in the wild;
`1.0.1` has had twelve. That difference is small enough that newest is clearly
right here. It would not be right for a build published last week — if the CF
build is under a fortnight old at add time, prefer the older one and say so in
the lockfile. The Jet Engines mod is the live example: `1.3.0` is three weeks
old, which is inside my comfort range but only just.

### Revised commands

```bash
cd ~/Source/create-aero-physics/pack

# --- Modrinth (default path) ---
packwiz mr add copycats
packwiz mr add copycats+-aeronautics-weight
packwiz mr add linear-bearing                       # want 1.3, minimum 1.2.5
packwiz mr add create-aeronautics-climbable-rope     # NOTE: "rope", singular

# --- Modrinth first, check the pinned version against the table above ---
packwiz mr add createaddition        # want 1.6.0
packwiz mr add create-connected      # want 1.3.2-mc1.21.1

# --- CurseForge: none. Every remaining mod resolves from Modrinth. ---

packwiz refresh
git status
```

**Corrections to my earlier list, both in your favour:**

- **Climbable Ropes IS on Modrinth.** I searched the plural slug and missed it.
  The project is `create-aeronautics-climbable-rope` — **singular "rope"**. That
  removes a CurseForge fallback, and §0.5's "none found" was wrong.
- **Latest Climbable Ropes is `[2.0.1]` (28 May 2026)**, not the `1.9.0` carried
  on the wishlist. Newest-wins applies. See the subsystem flag in §3.4 — 2.0.0
  changed what this mod touches.

**Simulated Thrusters `1.1.1` — resolved, ID `8220627`.** The only CurseForge
entry left in the phase. You supplied it as a
download URL; CurseForge's `/download/<n>` route takes the file ID directly, so
the trailing number **is** the ID:

```
https://www.curseforge.com/minecraft/mc-mods/create-simulated-thrusters/download/8220627
                                                                                 ^^^^^^^ file ID
```

**Sanity check passes.** CurseForge file IDs increase monotonically with upload
time, and this one lands exactly where a 9 Jun 2026 file should:

| File | Uploaded | ID |
|---|---|---|
| Linear Bearing `1.1.1` | 28 May 2026 | 8160300 |
| **Simulated Thrusters `1.1.1`** | **9 Jun 2026** | **8220627** |
| Propulsion `1.1.5` *(now cut)* | 23 Jul 2026 | 8496246 |

**Worth keeping for the rest of the build:** both `/files/<n>` and `/download/<n>`
carry the file ID in the URL, so you never need to open the page and read the
**File ID** field. Right-click any download button, copy the link, take the last
number.

**Try Modrinth first anyway.** My "Modrinth is stuck at 1.0.1" reading came from
a page snapshot, not a version list I could read directly. If
`packwiz mr add create-simulated-thrusters` resolves `1.1.1`, take it and skip
CurseForge entirely.

**One CurseForge hazard to know about.** Several projects in this ecosystem have
**third-party sharing disabled** — the Climbable Ropes file page carries the
telltale *"Curse Maven does not yet support mods that have disabled 3rd party
sharing"* line. When that flag is set, CurseForge serves no download URL to
third-party tools and **`packwiz cf add` cannot resolve the file at all.** If a
`cf add` fails with a distribution or permission error, that is why, and the
answer is Modrinth or the manual folder — not a retry. It is another argument for
the Modrinth-first rule you set.

For every mod, whatever gets pinned goes straight into `docs/lockfile.md` with
the platform it came from, so Phase 12 knows which entries have a second source
and which do not.

### Verifying what actually got pinned

```bash
for f in mods/*.pw.toml; do
  printf '%-46s' "$(basename "$f")"
  grep -m1 -E '^\[(update\.)?(modrinth|curseforge)\]' "$f" | tr -d '[]'
done
```

Anything showing `curseforge` beyond the entries named above is a mistake — pull
it and re-add from Modrinth.

---

## 0.6 Configs are not in the pack yet — how they get there

You are right that nothing is tracked. Prism keeps configs in the instance
(`<instance>/minecraft/config/`), the game writes them there, and packwiz has
never seen them. That is expected at this stage — Phase 0.5 planned for configs
to start mattering around Phase 5 — but the Connected issue arrives early, so
here is the mechanism.

### How packwiz handles configs

`packwiz refresh` indexes **everything** under the pack directory, not just mods.
A file at `pack/config/foo.toml` gets a hash in `index.toml` and is distributed
to every client and to the server exactly like a mod is. No `.pw.toml` needed —
local files are indexed directly.

```bash
# instance → repo (only files you deliberately changed)
INST=~/.local/share/PrismLauncher/instances/physics-dev/minecraft
cp "$INST/config/create_connected-common.toml" ~/Source/create-aero-physics/pack/config/

cd ~/Source/create-aero-physics/pack
packwiz refresh
git add config/ index.toml
git status
```

### Two things that will bite you if nobody says them out loud

**1. Once a config is in the pack, the instance copy stops being yours.**
packwiz-installer overwrites tracked files whose hash does not match. Edit in the
repo and rebuild; edit in the instance and your next launch silently reverts it.
That is the behaviour you want — it is how your friends all get the same config —
but it inverts the workflow you have been using so far.

**2. Do not ship the whole `config/` folder.** Copying everything means hundreds
of default files, enormous diffs, and no way to see which values you actually
chose. **Ship only files you deliberately changed**, and note the change in the
phase document. Your own Phase 12 concern was that configs silently drift and
cannot be reconstructed later — a curated set of changed files solves that; a
dump of defaults makes it worse.

### So: now or later?

**The test is now. The config is only now if the test fails.**

| Step | When |
|---|---|
| Read Connected's `1.2.x`/`1.3.x` changelogs for a redstone-link fix | **Before you add anything** |
| Gate test: two links talking on one sub-level, Linked Controller on a sub-level | **This phase — it decides whether Connected ships at all** |
| If broken → disable link features in the *instance* config, retest | This phase |
| If that fixes it → copy that one file into `pack/config/`, refresh, commit | **This phase's commit** |
| If it does not fix it → cut Connected, no config needed | This phase |
| Bounds and limits (contraption caps, tick budgets, entity caps) | **Phase 9.5, as planned** |

The distinction worth holding onto: **this is a correctness config, not a
hardening config.** Phase 9.5 is for bounding things that work. Making a mod work
at all belongs to the phase that added it, or the mod does not get added.

---

## 1. What Phase 3 actually is, given Create 6

Your charter for this phase names trains, logistics, energy, economy, copycats
and mechanics-expanding addons. One of those is already answered:

**Logistics is off the table because Create 6 ate it.** Factory gauges, package
logistics, stock links and the request system ship in `6.0.10`. Every logistics
addon on 1.21.1 is either pre-6 scaffolding or a duplicate. Nothing proposed.

**Economy is off the table on your own philosophy.** A currency system on a
three-player private server where the design goal is abundance-through-machines
is a solution to a problem you have deliberately engineered away. Numismatics is
a fine mod and it is not for this pack.

That leaves four real jobs, and one of them is not on your list:

| Job | Answer |
|---|---|
| Palette without block spam | Copycats+ (and its Aeronautics mass patch) |
| Compact power for things that fly | Crafts & Additions — argued, not assumed |
| Trains | Steam 'n' Rails, alpha, unofficial port |
| **Propulsion and rope work for Aeronautics** | **The Deferred Wishlist items — this is the real value in Phase 3** |

The fourth row is the one that matters. Phase 2 closed two charter bullets as
unachievable and the theme layer came out thinner than intended. The Aeronautics
propulsion and traversal addons are where Phase 3 puts weight back on the theme,
and they are the reason this phase is worth running at all. The mainstream Create
addons are the supporting cast.

---

## 2. The Sable 2.0 fault line — applied to this list

The pre-13-June rule from Phase 2 still governs. Applied here:

| Mod | Release date | Side of the line | Note |
|---|---|---|---|
| Jet Engines / Aero Propulsion `1.3.0` | 25 Jul 2026 | **After** | Clean |
| Sablewaves `2.8.2` | 5 Aug 2026 | **After** | Clean on dates, dirty on everything else — §5 |
| Throwable Rope Connector `0.4.2` | date unconfirmed, 0.3.0 was 20 May | Probably before | Low risk — it calls Simulated's rope API, not Sable's |
| Climbable Ropes `1.9.0` | 16 May 2026 | **Before** | Hooks Simulated's `ZiplineClientManager` with **no mixins and no overrides** per its own README — the lowest-risk way to be on the wrong side of the line |
| Simulated Thrusters `1.1.1` | 9 Jun 2026 | **Before, by four days** | Depends on Aeronautics, not Sable directly |
| Copycats+ Aeronautics Weight `1.0.0` | 22 Apr 2026 | **Before** | **Declares a direct Sable dependency.** Highest fault-line exposure in this phase |
| Copycats+, Crafts & Additions, Connected, Power Loader, Steam 'n' Rails | n/a | n/a | No Sable dependency at all |

Four items sit on the wrong side of the line. None of them is Auto Sable Physics
— none rewrites Sable internals — but the Phase 2 lesson was that dates predict
breakage better than descriptions do. If the gate fails, these four are where you
look first, in the order given.

---

## 3. Aeronautics propulsion and traversal — **all cut but one**

### 3.0 Create Propulsion: Simulated — **CUT, 16 Aug 2026**

**Your call, and the reasoning holds up better than my own did.** You said these
are basically duplicate mods and Thrusters looks better. Agreed on both, and
there is a stronger argument for it than "duplicate" that I should have made when
I proposed this:

**Create Propulsion: Simulated is not a propulsion mod — it is a content mod with
propulsion in it.** Read its changelogs together and the registry is: multiblock
thrusters at 2×2×2 and 3×3×3, a Stirling engine, solid and liquid burners,
oxidizer calculations, wings and tempered wings, tilt adapters, a platinum fluid
vessel, cable relays, a coral generator, and a netherite diving suit that stops
coral damaging you. That is a tech tree wearing a thruster costume, and it lands
in a pack whose block-spam rule says registry count is a cost and whose
"no second tech tree" rule you only just bent by a very deliberate inch.

**Simulated Thrusters is two blocks and a config file**, powered by stress units,
throttled by redstone. It is a Create machine. Your own stated preference —
addons that integrate with Create's systems over ones that sit alongside it —
picks it unambiguously.

So: **Propulsion: Simulated is out. Simulated Thrusters is the propulsion layer.**

#### What you give up, recorded so Phase 10 does not rediscover it

| Lost | Does it matter? |
|---|---|
| **Copycat Wings** — aerodynamic surfaces with copycat texturing | **No.** Aeronautics ships Symmetric Sails natively; this was a nicer-looking version of something you already have |
| **Ion Thruster, powered by FE** | **Mildly.** This was my cleanest example of an FE consumer inside the §4.2 grant. Crafts & Additions still justifies itself on the electric motor, but the argument is narrower now — noted honestly rather than buried |
| **Force-at-point thrust** | **Unknown.** Whether Simulated Thrusters applies thrust at the block position or at centre of mass is not documented. **Gate check: mount one thruster off-centre and see whether the craft yaws or just accelerates.** If it thrusts through the centre of mass, off-axis engine layouts will not behave, and that is worth knowing before anyone designs a plane around it |
| **A declared "Sable 2.0.3+" requirement** | **Yes, and this is the real cost.** Propulsion stated exact compatibility with your pinned Sable. Simulated Thrusters is 9 Jun 2026 — four days the wrong side of the §2 fault line — and it is now the *only* propulsion mod, so that risk is concentrated rather than hedged |

#### One consequence to accept deliberately

The propulsion layer is now **a single All Rights Reserved mod, from a small
author, published just before the Sable 2.0 fault line.** That is a thinner
position than I would normally recommend, and it earns two things:

- **Archive the jar in `manual/`** with a register row, same availability hedge
  as Create: High Seas. One file, one row.
- **If it fails the gate, propulsion has no fallback in this phase.** Aeronautics'
  own propellers and sails still fly things, so this is a downgrade rather than a
  hole — but know it going in rather than scrambling.

<details>
<summary>Original proposal record, retained</summary>

| Field | Value |
|---|---|
| **Source** | CurseForge project **1522736**. **No Modrinth listing found — verify, then fall back to CF** |
| **Version** | `1.1.5` (23 Jul 2026) — **CF file ID `8496246`** |
| **Tier** | A |
| **Licence** | **MIT** |
| **Side** | Both |
| **Size** | Moderate — several thruster tiers, Copycat Wings, Ion Thruster |
| **Role** | Port of Create: Propulsion to NeoForge 1.21.1 with first-class Sable and Aeronautics support. **Integrates with Sable and Aeronautics contraption physics directly, including force-at-point behaviour** so torque and multi-thruster arrangements resolve properly on an assembled craft. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 14 |
| **Known conflicts** | Thruster fuels are sourced from a list of mods including **Create: Crafts & Additions**, which you just accepted. **Two things to check at the gate** — see below. |

**Why this is the one to take:**

- **1.5M downloads, MIT, has a wiki and public source.** By your own
  "prefer the boring option among equals" rule, this wins on every axis over a
  three-week-old ARR project with 90K downloads.
- **Force-at-point on Sable bodies.** It is not bolting thrust onto a centre of
  mass; it applies force where the thruster physically is, which is the
  difference between a plane that flies and a plane that spins.
- **Copycat Wings** — same properties as Aeronautics' Symmetric Sails, with
  adjustable thickness and copycat texturing. That is a direct three-way synergy
  with Copycats+ and the Aeronautics weight patch, all landing in this same phase.
- **The Ion Thruster runs on FE**, which gives the Crafts & Additions decision a
  consumer that is unambiguously *propulsion* rather than a parallel tech ladder.
  It lands exactly inside the scope you granted in §4.2 and nowhere outside it.

**Two findings from the `1.1.5` changelog, one great and one to verify:**

- **"Updated Sable requirement to 2.0.3+".** That is an exact match for your
  pinned Sable, and the most precise 2.x compatibility statement of anything in
  this phase. It puts this mod firmly on the right side of the §2 fault line.
- **"Updated bundled Simulated, Aeronautics, and Offroad dependencies."** The
  word *bundled* is the one to watch. If it ships Aeronautics or Simulated via
  jarJar, that duplicates mods you already have pinned. **Check the log for
  duplicate-mod or version-conflict errors on first launch**, and if it does
  bundle them, decide deliberately which copy wins rather than discovering it at
  Phase 10.

Also adds CC:Tweaked peripheral support — inert, since CC is locked out at
Phase 0. No action.

</details>

**Final state of the propulsion group:**

| Mod | Verdict |
|---|---|
| **Create: Simulated Thrusters** (§3.2) | **IN — the propulsion layer** |
| **Create Propulsion: Simulated** | **OUT** — content mod, not a propulsion mod |
| **Create: Simulated Jet Engines** (§3.1) | **OUT** — duplicate of Thrusters by the same logic, and ARR with a three-week-old project behind it |

**One mod covers propulsion.** If you want a second for breadth, jet engines are
the candidate — but the duplicate argument that removed Propulsion removes them
too, so I am recording both as out unless you say otherwise.

---

### 3.1 Create: Simulated Jet Engines | Aero Propulsion — **CUT, 16 Aug 2026**

| Field | Value |
|---|---|
| **Source** | CurseForge project **1603705** (`create-simulated-jet-engines-aero-propulsion`) |
| **Version** | `morepropulsion-1.3.0.jar` (25 Jul 2026) |
| **Tier** | A (CurseForge) |
| **Licence** | **All Rights Reserved** → Phase 12 flag, `manual/` hedge recommended |
| **Side** | Both |
| **Size** | Small — engine components and engine mounts, multiblock-assembled |
| **Role** | Multiblock jet engines in several sizes. Turbojet and turbofan. The headline "make it actually fly fast" mod for Aeronautics. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 14 |
| **Known conflicts** | None documented. Overlaps Simulated Thrusters in role — see §3.2. |

**Source: CurseForge fallback.** I searched for a Modrinth listing and found
none — every reference to this project points at CurseForge. Try Modrinth first
anyway in case it has been mirrored since:

```bash
packwiz mr add morepropulsion          # expected to fail — no Modrinth listing found
packwiz cf add --addon-id 1603705 --file-id <FILE_ID_FOR morepropulsion-1.3.0.jar>
```

Slug-based `cf add` stays banned per your own lesson, so you need the file ID for
`morepropulsion-1.3.0.jar`. I confirmed the project ID and the filename but
**not** the file ID for that build — I have IDs only for `1.0.1` (8404724) and
`1.2.0` (8422512). Pull the 1.3.0 file ID off the CF files page before adding.

**Age flag:** the project is roughly a month old with three releases in three
weeks. That is the Coasters release cadence all over again. Pin it and freeze it.

**ARR flag:** archive the jar in `manual/` and add a register row, same treatment
as Create: High Seas. Availability, not integrity, is the risk.

---

### 3.2 Create: Simulated Thrusters — **CUT, 16 Aug 2026**

**Cut on your call, after testing.** The reasoning, recorded so Phase 10 does not
reopen it:

**Aeronautics is a lift-and-propeller flight model.** Levitite, balloons,
symmetric sails, propellers. Thrusters are a *thrust-based* flight model — a
second flight paradigm bolted onto a pack that already has a working one, for a
kind of flying this pack is not about. That is the same shape as "no second tech
tree," applied to movement instead of power.

It also solved no problem you had. Your airships already fly; nothing in Create,
Coasters or Aeronautics was waiting on more thrust.

**What the cut removes from the pack's debt, in one move:**

- The last All Rights Reserved addition in the phase
- The last pre-fault-line mod added in the phase (9 Jun, four days early)
- One `manual/` archive job and one exceptions-register row
- **The Phase 9.5 non-optional thruster config item** — deleted, not deferred
- The only remaining CurseForge entry in Phase 3

**The one part genuinely worth regretting:** the *redstone* thruster was a real
Create machine — stress-driven, RPM-curved, redstone-throttled — and would have
had a defensible role in precise vectoring or station-keeping on a large airship.
But you cannot ship half a mod, and on a shared server "just don't use the blaze
one" is a hope rather than a rule.

**Not closed, parked.** If Phase 4 lands on sky islands with genuinely punishing
gaps, thrust-based travel becomes arguable again. Airships remain the better
answer even then, so this goes to the Deferred Wishlist against Phase 4 rather
than being written off.

<details>
<summary>Original proposal record, retained — including the observed test</summary>

| Field | Value |
|---|---|
| **Source** | Modrinth `create-simulated-thrusters` / CurseForge project **1546743**, file `8220627` |
| **Version** | **`1.1.1` (9 Jun 2026), from CurseForge project 1546743.** Modrinth stops at `1.0.1` (21 May); newest-wins ruling of 16 Aug applies |
| **Tier** | A |
| **Licence** | All Rights Reserved → Phase 12 flag |
| **Side** | Both (CF metadata says "Not Set", which is a CF metadata bug, not a real answer — set `side = "both"` yourself, exactly like the Physics Compat fix) |
| **Size** | Two thruster blocks plus config |
| **Role** | Lift and propulsion with no moving parts. Redstone thruster runs on **stress units** and scales with signal strength; blaze thruster burns fuel with three grades. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 14 |
| **Known conflicts** | Requires Aeronautics. Role overlap with Jet Engines. |

**The overlap, stated honestly.** These two mods both answer "how does my
aircraft go forward." Your spec says prefer the boring option among equals and
prefer addons that integrate with Create's systems. Those two rules point in
opposite directions here:

- **Thrusters integrate better.** Stress units, redstone control, RPM curves — a
  thruster is a Create machine and it draws from your kinetic network. It is
  fully configurable through `config/create_simulated_thrusters-common.toml`.
- **Jet engines are the better toy.** Multiblock assembly, several sizes, and
  they are what people actually build planes with.

I am proposing **both**, because Phase 3 is explicitly the breadth phase and this
is precisely the kind of overlap Phase 10 exists to resolve. **But if you want
one, take Thrusters** — kinetic integration is worth more to this pack than
spectacle, and it has a real config file where the other does not.

**Grind flag:** blaze thrusters burn fuel, with blaze cake as the top grade.
That is a supply chain, which is the good kind of grind by your rules — the
answer is a blaze burner farm, which is a machine. No config change needed.

---

#### OBSERVED, 16 Aug 2026 — defaults are wildly overpowered

**Recorded verbatim, not softened:** four blaze thrusters, one blaze cake each,
launched the craft roughly **3,000 blocks in one second.**

**This is not a balance note. It is a stability finding.** 3,000 blocks per
second is about **190 chunks per second**, which no chunk loader, no save
pipeline and no physics tick budget is built to survive. The specific hazards:

- The sub-level outruns chunk loading and travels through ungenerated or
  unloaded terrain.
- You dropped Power Loader and put chunk loading on FTB Chunks at Phase 7 —
  neither answers a body moving faster than the loader can keep ahead of.
- A craft that far out in one tick is exactly how a sub-level ends up stranded,
  orphaned, or wedged somewhere the server cannot resolve. **That is the
  Shtreimel/Sable CleanUp problem arriving before Phase 9 has the tools for it.**
- On a world border, or on Phase 4 sky islands, one blaze cake means leaving the
  playable world entirely.

**Bumped from "Phase 9.5, worth bounding" to Phase 9.5 NON-OPTIONAL.** This now
sits alongside the Sappy Tree Physics sub-level cap as a config item the pack
cannot ship without.

**Capture the baseline now, while it is in front of you** — Phase 9.5 needs to
know what it is reducing *from*:

```bash
cat config/create_simulated_thrusters-common.toml
```

Paste the current values into the Phase 9.5 notes. The knobs are documented:

| Key | Governs |
|---|---|
| `blazeThrusterBlueThrust` | **Superheated fuel — blaze cake. This is the one you hit.** |
| `blazeThrusterHighThrust` | Standard fuel (coal, logs) |
| `blazeThrusterLowThrust` | Low-grade fuel (sticks) |
| `redstoneThrusterThrust` | Kinetic thruster peak thrust |
| `redstoneThrusterAirflow` | Kinetic thruster airflow |
| `redstoneThrusterMaxThrustRpm` | RPM at which the kinetic thruster reaches full thrust |

**Suggested method rather than a number**, since the defaults are unknown until
you paste them: pick a target top speed for a fully-fuelled multi-thruster craft
and tune to it. **20–40 blocks per second** is a sane band — brisk, comparable to
a good airship, and slow enough that chunk loading and the physics tick stay
ahead. That is roughly a **two orders of magnitude** cut from what you just saw,
so expect to divide rather than trim.

Tune `blazeThrusterBlueThrust` first, since blaze cake is both the top tier and
the easiest to automate — under your abundance philosophy, the top fuel grade is
the *normal* case, not the rare one.

**Also worth noting what this does not tell us:** four thrusters presumably
mounted symmetrically, so the craft went straight. The off-centre thrust question
was never resolved, and no longer needs to be.

</details>

**This test is the reason the mod is cut, so it stays in the record.** It is also
the phase's one piece of evidence gathered by playing rather than reading, which
makes it worth more than anything else in this document.

---

### 3.3 Create Aeronautics: Throwable Rope Connector — **CUT, 16 Aug 2026**

| Field | Value |
|---|---|
| **Source** | Modrinth `create-aeronautics-throwable-rope-connector` / CurseForge project **1529882** |
| **Version** | `0.4.2` (latest 1.21.1 NeoForge; `0.3.0` was 20 May 2026 — exact 0.4.2 date unconfirmed) |
| **Tier** | A |
| **Licence** | **MIT** |
| **Side** | Both |
| **Size** | Three items — Throwable Rope Connector, Rope Connector Launcher, Mounted Rope Launcher |
| **Role** | Place rope connectors at range instead of walking to every docking point. Throw, hand launcher, or mounted launcher. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 16 |
| **Known conflicts** | Range is clamped to Create: Simulated's `max_rope_range` — it cannot exceed it, so no config fight. |

**Cut on your call.** Recorded so it is not re-proposed.

The case I made for it was anti-grind: docking an airship means walking to each
connector, and this let you place them at range. The counter-case is that the
walk is a few seconds on a vehicle you just spent an hour building, which makes
it flavour rather than friction — and three items for that is a poor trade under
a philosophy that treats registry count as a cost.

**One consequence to accept knowingly:** docking stays a walk-to-each-point job.
If that turns out to be genuinely irritating once there are real airships in the
world, this is a clean one-mod addition at any later point — MIT, Tier A,
Modrinth, no dependencies beyond Simulated. Parked to the Deferred Wishlist
rather than closed.

<details>
<summary>Original proposal record, retained</summary>

Successful throws place an ordinary Simulated rope connector and hand you an
ordinary coupling, already linked — no new system, and range is clamped to
Simulated's `max_rope_range` so there is no config fight.

Changelog notes a duplication bug with the Mounted Rope Launcher fixed in 0.4.2
(breaking a loaded launcher could drop the ammo more than once). Pin 0.4.2 or
later, not 0.4.1.

</details>

---

### 3.4 Climbable Ropes for Create Aeronautics

| Field | Value |
|---|---|
| **Source** | **Modrinth `create-aeronautics-climbable-rope`** (singular — my earlier "CF only" was wrong) / CurseForge project **1528764**; source `github.com/matejhozlar/Create-Aeronautics-Climbable-Ropes` |
| **Version** | **`2.0.1` (28 May 2026)** — not the `1.9.0` on the wishlist. Newest-wins applies |
| **Tier** | A |
| **Licence** | MIT |
| **Side** | Both (movement is server-authoritative; the hanging animation syncs to other clients) |
| **Size** | No blocks, no items |
| **Role** | Climb vertical ropes bare-handed. Fills a real gap: Simulated lets you *hang* rope but not climb it, and the same is true of Plunger Launcher ropes. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 17 |
| **Known conflicts** | None. Its README is explicit that Simulated's existing wrench zipline system is left untouched — no mixins, no overrides — and the new behaviour runs as a parallel client-tick controller. |

**Keybind flag — and it is the good kind.** This mod registers **no new
keybinds**. Climbing is contextual and reuses movement keys: right-click bare-
handed to grab, W/S to climb, Sprint+S to slide, Space to mantle off, Sneak to
release. Zero keymap cost, but it **does** need a line in `keymap.md` under
"contextual controls" and a line in the Phase 12 guidebook, because an undocumented
contextual control is an invisible feature — exactly the case your keybind policy
calls out.

**Fault-line flag:** 28 May, still pre-2.0. The no-mixin architecture makes it
the safest of the pre-line mods, but it is still pre-line.

**NEW subsystem flag — this is why the version matters.** Version `2.0.0` added
player climb animations driven by **KosmX's Player Animator**, bundled via
jar-in-jar so it installs itself. That puts this mod into **player rendering and
animation** — the exact subsystem where **Sable: Ragdolls** and **Ragdoll
Reactions** already live, and the accumulation Phase 2 flagged. Three mods now
pose the player model.

Not a veto, and the jar-in-jar means no separate dependency to manage. But if
ragdolls start behaving oddly after this phase, this is the cause, and it did not
exist in the `1.9.0` build the wishlist recorded. Worth a specific gate check:
**ragdoll while hanging on a rope.**

---

## 4. The batch — Create proper

### 4.1 Create: Copycats+ **and** Copycats+ Aeronautics Weight — one unit

These ship together or not at all. Copycats+ alone in an Aeronautics pack means
copycat blocks with unconsidered mass values, and mass is not cosmetic here — it
is the input to whether your airship flies.

| Field | Copycats+ | Copycats+ Aeronautics Weight |
|---|---|---|
| **Source** | Modrinth `copycats` / CF **968398** | Modrinth `copycats+-aeronautics-weight` |
| **Version** | `copycats-3.0.4+mc.1.21.1-neoforge` (23 Nov 2025) | `1.0.0` (22 Apr 2026) |
| **Tier** | A | A |
| **Licence** | ARR, but **explicitly modpack-permissive provided files come from Modrinth or CurseForge** — same shape as Almost Unified. Referencing is compliant; bundling is not. | Unconfirmed — check at add time |
| **Side** | Both | Both |
| **Size** | **Estimate ~25–40 registered copycat block types.** Not verified precisely. | Zero blocks, zero items — data only |
| **Role** | The palette layer. Panels, boards, bytes, slabs, steps, doors, fences — each wearing any texture in the game. | Assigns sensible kg mass values to copycat blocks so Aeronautics physics treats them correctly. |
| **Risk tier** | OPTIONAL at add time → **becomes LOAD-BEARING the moment anyone builds with it** | OPTIONAL |
| **Cut order** | 22 | 21 |
| **Known conflicts** | None known with Sable. | Declares a direct Sable dependency at "any compatible version" — the fault-line item flagged in §2. |

**This is the single best philosophy fit in the phase.** Your rule is prefer
systems over variants, and a mod that adds one block with many states beats a mod
that adds four hundred blocks. Copycats+ is the canonical example of the rule: a
few dozen registrations that between them can wear every texture in the pack.
It replaces the entire decoration category by itself, which is why no decoration
mod appears anywhere in this document.

**Post-launch removal warning, recorded now for Phase 13:** Copycats+ is the most
dangerous mod in this phase to remove later. Every copycat block placed in the
world becomes a hole if the mod leaves. File it under load-bearing-by-use, not
load-bearing-by-dependency.

---

### 4.2 Create Crafts & Additions — **rule bend granted, scoped**

| Field | Value |
|---|---|
| **Source** | Modrinth `createaddition` / CurseForge **439890** |
| **Version** | `createaddition-neoforge-1.21.1-1.6.0` (2 Jun 2026) |
| **Tier** | A |
| **Licence** | **MIT** |
| **Side** | Both |
| **Size** | **Estimate ~40–60 blocks and items** — motors, alternator, rolling mill, generators, wires, batteries, connectors |
| **Role** | Bridges Forge Energy and Create's kinetic system. Electric Motor makes rotation from FE; Alternator does the reverse at 75%. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 20 |
| **Known conflicts** | Provides a ComputerCraft peripheral on the Electric Motor — soft integration, inert with CC absent (and CC is locked out at Phase 0). |

**This is the one proposal in the phase that fails a stated rule.** Your
philosophy says no second tech tree. Forge Energy is a second energy system, and
nothing else in this 22-mod pack consumes FE. Taken literally, this is a NO.

**The argument for it anyway is specific to a flying pack.** Powering kinetics on
an airship is a genuinely awkward problem. A steam engine needs a boiler, a water
tank and fuel — all of it mass you have to lift. A windmill on a moving vehicle
is worse. An electric motor plus a battery is the only compact, low-mass,
instantly-controllable rotation source available on 1.21.1, and "how do I power
the machines on my flying base" is a question this pack will actually ask.

It is also the boring option by a mile: 107 million downloads, MIT, five years
old, current on Create 6.

**My recommendation: take it, and take it for the motor, not the tech tree.**

**DECIDED — 16 Aug 2026: IN.** William's call, with the reasoning that the mod is
strong on its own merits and that it gives the pack a way to *move power around*
rather than only to generate it. That second point is the better argument than
mine: wires and connectors mean a flying base can have one power source and many
consumers without running shafts and gearboxes through every bulkhead, which is a
real structural problem on a vehicle.

### The bend is scoped — record this now, it will be tested in Phase 5

The rule that bent is "no second tech tree." What was granted is **FE as a power
*transport and conversion* layer for Create.** What was not granted is FE as a
progression ladder.

The practical consequence, and it will come up: **Phase 5 will surface FE-native
machines** — ore multipliers, quarries, mob farms — and every one of them will
now have a plausible-sounding argument, because the energy system it needs is
already installed. That argument is invalid. The test for any later FE mod stays
exactly what it was before this decision:

> Does this do a job Create cannot do, or does it do a Create job with a
> different-coloured cable?

Crafts & Additions passes because Create has no compact rotation source and no
power-over-distance. A machine that grinds ore into more ore fails, because
Create already grinds ore into more ore.

**If a later phase proposes an FE consumer, I will flag it against this line
rather than treating the door as open.**

**Grind flag:** the Rolling Mill gates rods and wires. Fully automatable through
ordinary Create, so no config change needed.

---

### 4.3 Steam 'n' Rails Neoforge — **what it actually adds, and my answer**

You asked what this really gives you. Here it is, and it is less than the
reputation suggests.

**What Steam 'n' Rails adds, roughly in order of how much you would notice it:**

| Feature | What it is | Does this pack care? |
|---|---|---|
| **Train couplers** | Link separate trains into one consist, split them again | Mildly — it is the one genuinely mechanical feature |
| **Bogey variants** | Single-axle, double-axle, narrow-gauge, invisible bogeys | Cosmetic and gauge variety |
| **Track variants and ties** | Different rail styles, monorail-ish options | Cosmetic |
| **Semaphores and signalling props** | Visual signalling alongside Create's own signals | Cosmetic — Create 6 already does the actual signalling logic |
| **Conductor whistle, train whistles, smokestack particles** | Flavour | Flavour |
| **Train hats, decorative fittings** | Flavour | Flavour |

**The honest summary: it is mostly depth-of-flavour on a rail system Create
already implements.** Create 6 ships trains, tracks, stations, signals, schedules
and the whole logistics layer. Steam 'n' Rails makes that world *feel* more like a
railway. It does not add a mechanic you cannot already build.

Set against that: it is an unofficial alpha fork whose own page tells you to back
up your world, it carries the only real variant-block registry cost in the phase,
and none of it is physics.

**My answer: drop it from Phase 3.** You ranked it second behind the Sable
contraption question, and once §5 is answered the honest comparison is "a mod
that makes Create contraptions editable on Sable" versus "nicer bogeys." Those
are not close.

**DECIDED — 16 Aug 2026: deferred to Phase 4.** Your reasoning, recorded
verbatim in substance: *it adds so many unnecessary blocks that it starts to feel
like bloat.* That is your block-spam disqualifier applied correctly — it is the
only entry in this phase with a real variant registry, and the table above is why.

**Not cut, deferred.** Two things get tested there rather than assumed:

1. Whether the worldgen decision leaves a railway meaning anything at all.
2. **Whether Simurail (§5.3) makes it a companion rather than an alternative** —
   Simurail declares Steam 'n' Rails integration, so the two may not be competing
   for the same slot.

<details>
<summary>Original proposal record, retained</summary>

| Field | Value |
|---|---|
| **Source** | Modrinth `create-steam-n-rails-1.21.1`; source `github.com/PoppyBlossom/Railway-1.21.1` |
| **Version** | `0.3.0-alpha.2+neoforge-mc1.21.1` (16 Jun 2026) or newer |
| **Tier** | A |
| **Licence** | LGPL-3.0-or-later |
| **Side** | Both |
| **Risk tier** | OPTIONAL — alpha, unofficial port |
| **Known conflicts** | `0.3.0-alpha.2` changelog: "fixed startup crash with newest version of create 6.0.10" — matches your pinned Create. Documented incompatibility with Blocks & Bogies; not in this pack. |

Does not meet QUARANTINE — the alpha warning is generic boilerplate rather than a
documented corruption report, and 1.8M downloads over seven months would have
surfaced a save-eater.

</details>

---

### 4.4 Create: Connected

| Field | Value |
|---|---|
| **Source** | Modrinth `create-connected` / CurseForge **947914** |
| **Version** | `create_connected 1.3.2-mc1.21.1` (22 Jun 2026) |
| **Tier** | A |
| **Licence** | AGPL-3.0-or-later |
| **Side** | Both |
| **Size** | **Estimate ~50–80 registrations** — clutches, gearboxes, redstone diodes and transmitters, rotated vaults and tanks, inventory bridges, kinetic batteries |
| **Role** | The QoL blocks Create forgot. Every one of them is a mechanism, not a decoration. |
| **Risk tier** | OPTIONAL |
| **Cut order** | 19 |
| **Known conflicts** | **Wildcard feature breaks redstone links on physics objects — `create_connected` #223, Simulated-Project #336 and #1065. Fixed by disabling the feature; confirmed working in testing. Mandatory config, see below.** **Documented incompatible with Create: Extended Cogwheels** — Extended Cogwheels treats Connected's components as cogwheels and produces confusing visual glitches. Not in the pack; recorded so Phase 10 does not rediscover it. Optional JEI integration, inert until Phase 7. |

**Registry cost is the argument against, and the config is the answer.** It is
"highly configurable — disable what you don't need" by its own description, which
means the block count is a number you set rather than a number you accept. If the
Phase 10 registry audit says the pack is bloated, this is the first mod to trim
rather than the first mod to cut.

**Subsystem flag:** Kinetic Batteries store stress and release it to keep a
network running. On a Sable sub-level that is a kinetic network being simulated
inside a moving reference frame. No documented problem, but this is the one
Connected feature I would poke specifically at the gate.

---

#### REQUIRED CONFIG — Redstone Links. **And it is worse than wildcards.**

You are right that this is documented upstream, not a one-off — my "observed by
you" attribution was wrong. Correcting it turned up **three** issues, and the
first one is a bigger problem than the one you raised:

| Issue | Reported | What it says |
|---|---|---|
| **`hlysine/create_connected` #223** | 19 Apr 2026 | **All redstone links stop working on physics objects when Create: Connected is installed.** Minimal repro: Create, Aeronautics, Sable, Connected — nothing else. Remove Connected and links work normally on physics objects again |
| **`Creators-of-Aeronautics/Simulated-Project` #336** | 19 Apr 2026 | Links on a simulated contraption do not talk to each other with Connected installed. A Linked Controller on a contraption triggers only *world* links and ignores links on its own contraption. Modulating and directional receivers still work |
| **`Creators-of-Aeronautics/Simulated-Project` #1065** | 15 May 2026 | The Wildcard item specifically fails in the frequency slots of Aeronautics' Modulating and Directional Redstone Links |

**RESOLVED — 16 Aug 2026. You have tested this and disabling the wildcard
feature fixes it.** That is the authoritative data point and it overrides my
reading of the issue tracker, so Connected stays and the escalation I was
building toward is dropped.

**Your original framing was more precise than my escalation.** I read #223's "all
redstone links stop working on physics objects" as a separate, larger bug. Your
result says otherwise: all three reports share one root cause. That is coherent —
Connected's wildcard feature has to patch how link frequencies are compared, and
a global patch to frequency resolution would break link matching on sub-levels
whether or not a wildcard item is involved. Disable the feature, remove the
patch, and every symptom goes with it. #223 and #336 are users hitting the
consequence without knowing the cause.

**So this is a config, not a cut.** Turn the feature off and Connected behaves.

```bash
grep -in "wildcard" config/create_connected-*.toml
```

**Record the exact key here once you have it** — that line is what Phase 9.5 and
the Phase 12 guidebook both reference, and "the wildcard one" will not be
sufficient in six months.

**This becomes the pack's first tracked config file.** Per §0.6, copy that one
file — not the folder — into `pack/config/`, refresh, and commit it with the
phase. It is a good first entry precisely because it is a single deliberate
change with a written reason.

**Why this still deserves the space it takes up.** Redstone links are how you
control anything on a moving vehicle without running wire through it, and the
failure is silent — it works perfectly on the ground and in every test not
conducted on an airship. A friend who re-enables wildcards because they look
useful would break every control system on every ship in the world, and would
have no way to connect the two facts. That is why it needs a guidebook line, not
just a config value.

**Follow-ups:**

| Where | What |
|---|---|
| **This phase's commit** | Config is repo-tracked and ships with the pack — goes in the Phase 3 commit |
| **Phase 9.5** | Config-hardening sheet: default, set value, failure prevented. The template case — a documented failure, not a speculative bound |
| **Phase 12 guidebook** | One line: wildcards are off deliberately, re-enabling them breaks redstone links on ships, see `create_connected` #223 |
| **Phase 13** | If upstream fixes it, that is a legitimate freeze exception: a fix for a bug you are actually hitting |

**Which vindicates the original argument for Connected twice over.** I proposed
it partly because "disable what you don't need" made registry cost a number you
set. It turns out the same switch is what keeps the mod compatible with the
pack's core premise. A mod that breaks something important *and* gives you the
toggle is in a completely different category from one that just breaks it.

---

### 4.5 Create: Power Loader — **DROPPED, 16 Aug 2026**

Your call: chunk loading goes to **FTB Chunks at Phase 7** instead. Agreed, and
there is a second reason to be comfortable with it that I should have raised the
first time.

**Sable ships its own force-loading.** The Sable 2.0.0 changelog includes
`/sable forceload <add|remove>` for sub-levels, plus a
`sub_levels_with_players_cannot_unload` config. So the specific failure I was
worried about — an airship flying out of loaded chunks — has a first-party answer
in a mod you already have pinned, and it does not need a third-party chunk loader
riding the vehicle.

**Two follow-ups this creates:**

| Item | Phase |
|---|---|
| FTB Chunks as the claiming and loading answer — and **FTB Chunks: Sable Aerospace**, already on the wishlist, protects Sable structures inside claimed chunks | **7** |
| `/sable forceload` and `sub_levels_with_players_cannot_unload` — set deliberately, and bound so a parked fleet cannot pin half the world | **9.5** |

Removed from the batch, the source table and the cut order.

---

## 5. The Create: Interactive-shaped gap — what actually exists on Sable

You asked for the Sable equivalent of Create: Interactive: contraptions you can
still build on, break, and stand inside, instead of a baked assembly you can only
look at. **Priority above Steam 'n' Rails, per your instruction.**

### First, the good news, and it reframes the question

**Sable already is that.** Its own one-line description is "a library mod for
interactive moving block structures." A sub-level *is* real blocks in a real
moving reference frame — you can place and break in it, block entities tick in
it, and Sable 2.0's changelog is full of entries like mechanical arms working on
sub-levels and Create Blueprints working on sub-levels. The editable-contraption
problem is already solved for everything that assembles through Sable.

**So the gap is narrower than "Create: Interactive but Sable."** It is
specifically this: **Create's own contraption blocks** — Mechanical Bearing,
Mechanical Piston, Rope Pulley, Gantry Carriage, Cart Assembler — still bake
their structures into Create contraption entities, because they are Create code
and know nothing about Sable.

### And the bad news, stated plainly

**No mod rewrites Create's contraption blocks onto Sable.** Create: Interactive
does exactly that job, and it does it on VS2 — its own description calls itself
"a rewrite of Create's contraptions using VS2." There is no equivalent rewrite
targeting Sable, and I would be surprised if one appeared: it is a large,
invasive piece of work and the Aeronautics ecosystem has taken a different route.

**That route is replacement, not rewrite.** Rather than one mod converting every
Create contraption block, the ecosystem ships Sable-native equivalents of
individual Create mechanisms. You already own one of them — Aeronautics' **Swivel
Bearing** is the Sable answer to the Mechanical Bearing, and it produces an
editable sub-level rather than a baked contraption.

**The missing half is linear motion**, and there is a mod for it.

---

### 5.1 Create: Linear Bearing — the Sable answer to the Mechanical Piston

| Field | Value |
|---|---|
| **Source** | Modrinth `linear-bearing` (project `ZTwCjE7O`) / CurseForge **1556708** |
| **Version** | **`1.3`** appears to be the newest on Modrinth (adds Gyroscopic Gearbox). CF shows `linearbearing-1.2.6.jar` (1 Jun 2026). Newest-wins applies — take `1.3` from Modrinth if it resolves |
| **Tier** | A |
| **Licence** | **Unconfirmed — now a priority, see the archived note below** |
| **Side** | Both (declared client-and-server) |
| **Size** | Small — Linear Bearing, Linear Casing, Magnetic Port, Torsion Anchor, Redstone Converter, Gyroscopic Gearbox, Andesite Lamp, plus a slippery and a sticky block |
| **Role** | **Glued structure → sliding Sable sub-level.** Build a rail out of Linear Casings, place the bearing, build anything on top, glue it, right-click bare-handed. It scans the structure, computes centre of mass, and converts it into a true Sable sub-level on a linear joint. |
| **Risk tier** | OPTIONAL — **archived upstream; `manual/` hedge required** |
| **Cut order** | 14 |
| **Known conflicts** | Declares Sable, Create and Create: Aeronautics dependencies at "any compatible version". `1.2.5` changelog reads "fixed a compatibility bug with CopyCats" — directly relevant, since Copycats+ is entering in the same phase. **Pin ≥ 1.2.5.** |

**This is the closest thing that exists to what you described**, and two of its
other blocks are quietly more valuable than the headline feature:

- **Gyroscopic Gearbox** — rotates in opposition to the sub-level it sits on, so
  mechanisms mounted on a pitching airship stay aligned. That is a real problem
  for anyone running Create machinery on a moving vehicle.
- **Magnetic Port** — transmits rotation across a distance, and across
  independent Sable sub-levels. Rotation between separate physics bodies without
  a physical shaft. In a pack where the whole point is machines on moving things,
  that is a genuinely enabling primitive.

**ACCEPTED — 16 Aug 2026.** Tested in game and confirmed solid; the features earn
their place. Your assessment, recorded as the decision.

#### The project is now archived — what that changes

**Archived upstream means no more releases, ever.** Three consequences, and the
first one is good news:

**1. The maturity flag is void.** I flagged this as the churniest thing in the
phase — `1.1.0` → `1.3` in a week, one changelog reading in full *"ahahha lol
67676767."* An archived project cannot churn. Under your freeze policy a
finished mod costs nothing to maintain, and the Phase 2 lesson applies directly:
*deprecated packs in a frozen modpack don't consume maintenance.*

**2. Availability becomes the real risk, exactly as it did for Create: High
Seas.** Archived repositories stay up; Modrinth and CurseForge projects can be
delisted by their author at any time. **Archive the jar in `manual/` with a
register row** — same hedge, same reasoning. This is the one action item.

**3. The unconfirmed licence now matters more than it did.** If it is ARR, the
`manual/` copy is your only fallback and it cannot be redistributed to your
friends — which would make an upstream delisting genuinely painful. **Confirm the
licence when you fill in §13**, and if it is ARR, note it in the Phase 12 ARR
list alongside High Seas and Porkchop.

**What does not change:** it works against Sable `2.0.3` today and your Sable pin
is frozen, so "no upstream fix is coming" only bites if you ever update Sable.
That is precisely the assessment your version-freeze policy exists to make, and
it comes out in this mod's favour.

**For Phase 13:** load-bearing-by-use, same category as Copycats+. Once sliding
sub-levels exist in the world, removal breaks builds — and unlike Copycats+,
there is nobody left to report a bug to.

---

### 5.2 The honest summary of the gap

| Create mechanism | Sable-native equivalent | Status |
|---|---|---|
| Mechanical Bearing (rotation) | Aeronautics **Swivel Bearing** | **Already in the pack** |
| Mechanical Piston (linear) | **Create: Linear Bearing** | Proposed above |
| Rotation across bodies | Linear Bearing's **Magnetic Port** | Included with the above |
| Gantry Carriage | — | **No Sable equivalent found** |
| Cart Assembler / minecart contraptions | — | **No Sable equivalent found** |
| Full rewrite of all Create contraptions | — | **Does not exist on Sable, and Create: Interactive is VS2 only** |

Two rows have no answer. I am not going to invent one; if a gantry-on-Sable mod
exists I did not find it. Everything else is either already yours or is §5.1.

**This is not a repeat of the two closed charter bullets.** Those were closed
because nothing works. This is a case where most of it works, one mod covers the
main missing piece, and two narrow mechanisms remain unsolved. Worth recording as
a partial rather than a closure.

### 5.3 Create: Simurail — the spike you actually want

**Confirmed to exist.** `github.com/Crystaelix/Create-Simurail`, described by its
own repository as *"an experimental train mod using Create and Sable."* NeoForge
1.21.1. Declared dependencies: **Sable, Create, and Create: Aeronautics** — so it
is built for exactly this stack, not adapted to it.

**What it does that Steam 'n' Rails does not:** trains become **real Sable
sub-levels**. That is the same answer §5.1 gives for linear motion, applied to
rail. It is the rail-shaped version of the thing you asked for, and it is why
deferring Steam 'n' Rails and spiking this instead is the right order.

Evidence it works in practice rather than only compiling: published community
schematics use it, including a locomotive whose author notes Simurail is what
makes the whole train a proper sub-level so the onboard powertrain runs. Blocks
seen in the wild include `simurail:automatic_coupler`.

**It also integrates with Steam 'n' Rails and Create: Electro Energetics**, which
reframes your Phase 4 test: Steam 'n' Rails may turn out to be a companion to
this rather than an alternative to it. Worth knowing when you evaluate it there.

---

#### DECIDED — 16 Aug 2026: `manual/` folder, hand-supplied, migrate on release

**Your call, and I'm withdrawing my objection entirely.** Two things:

**First, my "hand-delivered forever, on every update" framing was wrong.** Under
your own freeze policy there *are* no updates. Build once, pin it, never touch it
until upstream releases. That is one delivery to two friends, not a recurring
tax, and it is exactly the lifecycle the exceptions register exists to track.

**Second, "making a fork with a release feels wrong" is a good instinct, not a
squeamish one.** MIT permits it, so this was never a legal question — but
republishing someone else's mod under your own release name is a real community
norm in Minecraft modding, licence or not. It creates a second download source
people can find, it collects issue reports the author never sees, and it looks
like a fork of the project rather than a private convenience. Declining to do
that for a two-person server is the right proportion.

So: **`manual/`, supplied to your friends alongside the pack, migrated into the
manifest the day upstream cuts a release.**

#### Two things to do anyway, because they're cheap

**1. Archive the source, not just the jar.** The repo is one person with 19
commits. If it is deleted or force-pushed, your jar survives but the source does
not — and without source there is no future rebuild against a newer Sable. This
does not require a public fork:

```bash
cd ~/Source/Create-Simurail
git bundle create ~/archive/create-simurail-$(git rev-parse --short HEAD).bundle --all
```

One file, clones back cleanly, nobody sees it. Note it in the register row.

**2. Ship the `LICENSE` file with the jar.** MIT's one obligation is that the
licence travels with the copy. Since you are handing this to friends, drop
`LICENSE` into `manual/` next to the jar. Costs nothing, and it is the whole
requirement.

#### What this costs at Phase 12 — record it now

| Consequence | Detail |
|---|---|
| Install guide | One manual step: "drop these two files into `mods/`." Your guide is meant to stay one page — this is the first entry using that budget |
| Container | `manual/` must be mounted as a volume; the server cannot fetch this |
| `.mrpack` export | Cannot carry it. If Phase 12 lands on `.mrpack`, this file is separate no matter what |
| ARR list | Not applicable — it is MIT. Note that explicitly so Phase 12 does not lump it in with High Seas and Porkchop |

#### The exit condition, and a reminder to actually check

Your own rule is that the manual folder shrinks over time. This entry's exit is
**an upstream release** — so it needs someone to notice one appearing. The repo
has 40 stars and an open PR; watch it, or check at each phase gate. If it is
still release-less by Phase 12, that is the point to decide whether it ships at
all rather than discovering the problem while writing the install guide.

#### What stays risky

These do not go away just because the distribution problem does:

- **No release means no compatibility statement.** Nobody has said "works with
  Sable 2.0.3." You are the QA department, which you already accepted, but here
  there is no upstream claim to fall back on at all.
- **`main` is a moving target.** The commit SHA is the version identity. Record
  it or the build is unreproducible, including by you in six months.
- **No upstream to get a fix from.** There is an issue tracker with one open
  issue, so someone is home — but a pre-release project owes you nothing.
- **Load-bearing-by-use.** Once real trains exist as Simurail sub-levels, removal
  breaks builds — same category as Copycats+, and recorded for Phase 13.

None of those is a veto. They are the price, and it is a fair one for the only
mod anyone has found that makes trains real Sable sub-levels.

**One hard line, though:** none of this reaches the real world until it has
survived the spike below *and* the Phase 11 gate. A mod with no release, creating
persistent sub-levels, in a world you never reset, is the exact shape of the risk
your spec was written to avoid.

#### Build procedure

**Easiest path: take the jar from the Actions run rather than building it.**
Open the run page while signed in to GitHub, download the artifact, and note the
commit SHA the run built from — that SHA is the version identity.

```bash
cd ~/Downloads
unzip <artifact>.zip
sha256sum simurail-*.jar             # record this
```

**Or build it yourself**, if you would rather not depend on the run staying up:

```bash
cd ~/Source
git clone https://github.com/Crystaelix/Create-Simurail
cd Create-Simurail
git rev-parse HEAD                   # full SHA — this is the version identity
cat changelog.md                     # there is one; read it
./gradlew build                      # NeoForge 1.21.1 needs JDK 21
ls -la build/libs/
sha256sum build/libs/*.jar
```

Put the jar in `manual/` and confirm git does not see it:

```bash
cd ~/Source/create-aero-physics
cp <downloaded>/simurail-1.21.1-0.0.0-a+0b3230f.jar manual/
git status                           # manual/ is gitignored — expect nothing
```

**No spike branch needed for this one.** Branches are for changes to the
manifest; this file never enters the manifest, so there is nothing to revert.
Removing it is deleting one jar from the instance.

**If the spike passes, it stays in `manual/`** — jar plus `LICENSE`, a register
row, a source bundle archived, and a note in the Phase 12 install guide. It does
not enter `pack/mods/` or the manifest until upstream releases.

#### Installing it — `manual/` is an archive, not a load path

**No — do not add it to the packwiz pack.** `packwiz refresh` indexes every file
under the pack directory, so dropping the jar into `pack/mods/` would put a jar
in `index.toml` and, worse, in git. That breaks the no-jars rule directly.

`manual/` is where the *record* of the file lives. The jar has to be copied into
the instance by hand — that is exactly the manual step you are accepting, and it
is the same step your friends will perform at Phase 12.

```bash
# Prism instances live in one of these — check which you have
ls -d ~/.local/share/PrismLauncher/instances/physics-dev/{minecraft,.minecraft} 2>/dev/null

INST=~/.local/share/PrismLauncher/instances/physics-dev/minecraft   # adjust if .minecraft
cp ~/Source/create-aero-physics/manual/simurail-1.21.1-0.0.0-a+0b3230f.jar "$INST/mods/"
ls -la "$INST/mods/" | grep simurail
```

**It should survive `packwiz-installer` runs.** The installer tracks what it
installed and only removes files from that list, so a hand-dropped jar is left
alone. Verify that on the first launch rather than trusting it — if it vanishes,
the copy step moves to *after* the pre-launch command instead of before.

**It will not survive an instance rebuild.** If you ever wipe and rebuild
`physics-dev`, the copy above is a step you have to remember. Worth a line in
whatever notes drive your per-phase loop.

#### Your register row, ready to paste

The filename does most of the work — `0b3230f` is the commit, which is the real
version identity:

| Column | Value |
|---|---|
| Name | Create: Simurail |
| Source | `github.com/Crystaelix/Create-Simurail` — **MIT**, CI artifact, no upstream release |
| Version | `0.0.0-a+0b3230f` — **commit `0b3230f`**; the `0.0.0-a` part is a placeholder and carries no ordering meaning |
| File | `simurail-1.21.1-0.0.0-a+0b3230f.jar` |
| Hash | `sha256sum manual/simurail-*.jar` → record output |
| Reason | Trains as Sable sub-levels; no equivalent on any platform |
| Archived at | `manual/` (jar + `LICENSE`), plus a `git bundle` of the source |
| Date added | 16 Aug 2026 |
| **Exit condition** | **Upstream cuts a release** — then migrate to the manifest and delete this row |

**Note the version string is `0.0.0-a`.** That is the author's placeholder, which
means version comparison against any future release is meaningless — a real
`1.0.0` will not "upgrade" this in any tooling sense. The commit hash is the only
thing that identifies this build, which is why it belongs in the register rather
than being inferred from the jar later.

Your own rule is that the manual folder shrinks over time. This row is the first
entry in it that is not an availability hedge — it is a live dependency on a
project that has not shipped yet. Check for a release at each phase gate.

#### Spike criteria

The pack's one hard line is not losing the world, and this is a mod that creates
persistent sub-levels — the same category as Sappy Tree Physics and Sable Beyond,
both already named as save-hang suspects. So:

1. **Its own scratch world.** Never the Phase 3 gate world, never anything you
   want to keep.
2. Game loads; check the log with the usual filtered `grep`.
3. A train assembles as a sub-level and you can place and break blocks on it
   while it moves.
4. `simurail:automatic_coupler` couples and decouples without orphaning a
   sub-level.
5. **Save, quit, reload, and save again.** A save hang is the failure signature
   that cost you the Phase 2 gate. Test it deliberately rather than hoping.
6. Check what Sable version it builds against — if it targets pre-2.0 APIs, the
   fault line in §2 applies and it may not even load against `2.0.3`.
7. Remove it and confirm the world still opens. A mod with no release is a mod
   you may have to abandon.

If it survives all seven, it is a strong candidate — held out of the pack pending
a release, and re-raised at Phase 4 alongside the Steam 'n' Rails decision.

---

### 5.4 Parked, not proposed — two Sable tools worth a look later

Both surfaced during this search and neither belongs in Phase 3:

- **Sable Photomancy** — a blueprint system that saves and restores Swivel
  Bearing connections, Rope Winch links, Drive-By-Wire connections and Super Glue
  alongside the blocks, so complex Sable builds survive copy-paste with their
  runtime links intact. Also recovers lost sub-levels. **Registers a `Tab`
  keybind** — a Phase 7 keymap item. Owning phase: **7 or 9**.
- **Sable Tool** — adds force tracking to the Contraption Diagram and sub-level
  boundary/centre-of-mass visualisation on a held Breeze Rod. A debugging aid.
  Owning phase: **9**, alongside Sable CleanUp and Shtreimel.

Added to the Deferred Wishlist rather than proposed here.

---

## 6. Considered and rejected — with reasons

| Mod | Why not |
|---|---|
| **Create: Interactive** | It is a **Valkyrien Skies** project. VS is permanently ruled out as a second physics engine. This one deserves naming because it looks perfect on the tin — "Create with physics contraptions" — and is exactly the mod that would smuggle a second physics engine into a Sable pack. **Do not re-propose.** |
| **Create: Numismatics** | Economy. Three players, abundance philosophy. Solves nothing you have. |
| **Create: Design n' Decor, Create: Interiors, Create Deco, Create: Dreams & Desires** | Decoration by variant. Copycats+ makes the entire category redundant, and the block registry cost is the exact thing you called a disqualifier. |
| **Create Big Cannons** | Combat content, PvP-oriented by its own description. Out of scope. |
| **Create: Extended Cogwheels** | Documented visual-glitch incompatibility with Create: Connected, and Connected does more. Pick one; Connected wins. |
| **Create Stuff & Additions** | Ships backpacks. Violates the inventory rule directly. |
| **Create: New Age** | Duplicate energy system alongside Crafts & Additions. If Crafts & Additions is in, this is out; if it is out, this does not get a second bite. |
| **Logistics addons generally** | Create 6 native. |
| **Create Aeronautics: Kinetic Grip** | A handle block. Real gap not demonstrated. Left on the wishlist. |

**Not verified this session, still on the wishlist:** Aeronautics Wind Tunnel
(a testing tool, unexamined — I did not confirm version, licence or maintenance
state and will not propose it on a name), and an unnamed CurseForge mod described
as giving aerodynamics to Sable structures scaling with speed so symmetric sails
are unnecessary. Both stay parked rather than being asserted.

---

## 6.5 Parked for later — audio. Recorded so it is not forgotten

Neither is proposed now. Both are noted at your request, with the flags they will
need when their phase arrives. **I have not verified 1.21.1 NeoForge builds for
either** — that check happens at proposal time, not here.

### Sound Physics Remastered → **Phase 8**

Reverb, occlusion and material-based sound propagation. Belongs with the
rendering and client-experience stack rather than here.

- **Scope flag:** outside the Create and physics core. Justification is that a
  pack about standing inside enormous moving machines is a pack where machine
  noise is most of the atmosphere — sound is closer to load-bearing here than in
  a normal pack.
- **Client-only**, so it costs the server nothing and mismatched friends still
  connect. That makes it genuinely low-risk.
- **Per-client CPU cost** for occlusion tracing — matters against the Steam Deck
  hardware floor. Phase 8 should check it with the rendering budget, not in
  isolation.
- **Open question for Phase 8:** how it behaves with sounds emitted from blocks
  on a **Sable sub-level**. Occlusion is computed against world geometry, and a
  sub-level is not ordinary world geometry. Nobody has tested that combination as
  far as I know, so treat it as an unknown rather than assuming either way.

### Simple Voice Chat → **Phase 9**, with a Phase 7 tail

Proximity voice. Lands in server ops because the hard parts are infrastructure,
not gameplay.

- **Requires a UDP port** — 24454 by default — separate from the game's TCP port.
  That is a `docker-compose.yml` port mapping and a firewall rule, and it must
  survive the Phase 9 migration procedure. **Flag for your production target:**
  UDP forwarding through Docker Desktop on WSL2 is a known friction point. Worth
  testing early rather than discovering it on move day.
- **Both sides, and every client needs it.** A friend on the wrong version cannot
  connect at all. That is exactly the version-mismatch failure your Phase 12
  update workflow exists to prevent, so it strengthens the case for a single
  pinned pack version rather than weakening it.
- **Registers several keybinds** — push-to-talk, mute, toggle icons, voice menu,
  group menu. That is the largest keybind footprint of any mod discussed so far,
  and push-to-talk is the one binding your friends will absolutely notice if it
  clashes. **Phase 7 keymap item, not an afterthought.**
- **Does it count against the five-mod comfort cap?** My read is no — the cap was
  written for content mods with addon ecosystems (Alex's Mobs, Supplementaries,
  furniture), and neither of these has one or adds content. But that is your rule
  and your call, so it is flagged rather than assumed. **Decide it at Phase 6
  when the allowlist closes**, not later by drift.

---

## 7. Deferred to owning phases

| Item | Phase |
|---|---|
| Create Enchantment Industry — XP automation | 5 |
| Create Ore Excavation — quarrying | 5 |
| **FE-consumer test (§4.2) applied to every Phase 5 candidate** | **5** |
| **Steam 'n' Rails — revisit with the worldgen answer, and against Simurail** | **4** |
| **Create: Simurail — re-raise at Phase 4 if the spike passes** | **4** |
| **Simurail: spike it, then register row + `manual/` + source bundle if it passes** | **Now** |
| **Simurail install-guide step and container volume mount; check for an upstream release before the guide is written** | **12** |
| **Simurail as load-bearing-by-use** (same category as Copycats+) | **13** |
| Create Aeronautics: Automated Logistics has a **Simurail compatibility layer** (Simurail Stations) — relevant if Simurail survives | 5 |
| Create: Electro Energetics — surfaced via Simurail integration, unexamined | 5 |
| **Create: Connected wildcard toggle → hardening sheet** (default, set value, failure prevented) | **9.5** |
| Upstream fix for `create_connected` #223 → would let wildcards be re-enabled; a legitimate freeze exception if wanted | 13 |
| **FTB Chunks + FTB Chunks: Sable Aerospace** — the chunk-loading answer | **7** |
| **Sable Photomancy** (blueprints, sub-level recovery, `Tab` keybind) | 7 or 9 |
| **Sable Tool** (contraption force tracking, sub-level visualisation) | 9 |
| `/sable forceload` and `sub_levels_with_players_cannot_unload` bounds | 9.5 |
| **Linear Bearing sub-level despawn/cap** — same class as the Sappy Tree item | **9.5** |
| Aeronautics **Automated Logistics** vs **Simplified Logistics** — pick one, never both | 5 |

| ARR list additions: Copycats+ only (permissive ARR) — **Phase 3 adds no new ARR risk** | 12 |
| Copycats+ as load-bearing-by-use for safe-removal purposes | 13 |

---

## 8. Keybind ledger for this phase

| Mod | Keybinds registered | Decision |
|---|---|---|
| Climbable Ropes | **None** — contextual, reuses W/S/Sprint/Space/Sneak | Nothing to bind. **Document in `keymap.md` under contextual controls** and in the guidebook. |
| All five others | None expected | **Confirm at the gate.** Open Controls, screenshot anything new, record it. |

Phase 3 should cost you zero keys. If it costs you any, that is a finding, and
Phase 7 will thank you for catching it here rather than reconstructing it later.

---

## 9. Registry cost — honest accounting

| Mod | Estimated registrations | Variants or system? |
|---|---|---|
| Copycats+ | ~25–40 | **System** — the whole point |
| Create: Connected | ~50–80 | System, and configurable downward |
| Crafts & Additions | ~40–60 | System |
| Linear Bearing | ~8 | System |
| Climbable Ropes, Copycats+ Weight patch | 0 / 0 | Neither registers a block or item |

**Cut from the phase, and worth noting what they would have added:** Steam 'n'
Rails (the only real variant registry), Create Propulsion: Simulated (multiblock
thrusters, Stirling engine, burners, wings, tilt adapters, fluid vessels, cable
relays, coral generator, diving suit — comfortably the largest registry
proposed), Simulated Thrusters and the Throwable Rope Connector.

**Six mods were proposed and cut in this phase. Every one of those cuts was
yours.** The document I opened with had ten mods in the batch and one spike; it
now has six, all Modrinth, none ARR, none in `manual/`, and none adding a
non-optional config job downstream.

**These are estimates, not verified counts.** I could not confirm exact registry
sizes from the mod pages, and I would rather say so than give you a number that
looks precise and is not. The Phase 10 audit should count them properly from a
running instance rather than trusting this table.

Nothing remaining is a block-spam mod. Phase 3 adds six mods and no meaningful
variant registry at all.

---

## 10. Cut order for this phase

Phase 2 numbering is not touched. Phase 3 occupies **14–18**:

| Order | Mod |
|---|---|
| 14 | **Create: Linear Bearing** — youngest and churniest, first real suspect |
| 15 | Climbable Ropes |
| 16 | Create: Connected |
| 17 | Crafts & Additions |
| 18 | Copycats+ Aeronautics Weight, then Copycats+ |

Dropped from the phase and therefore from the cut order: Power Loader, Steam 'n'
Rails, Sablewaves, Propulsion: Simulated, Jet Engines, Simulated Thrusters,
Throwable Rope Connector.

**Debugging heuristic for this phase specifically:** after The Porkchop Express
(0), pull the **entire Phase 3 block** before touching anything from Phase 2.
Nothing added here is load-bearing for anything that already works. If the gate
fails and you want one guess before bisecting, guess **Linear Bearing** — it is
the newest, the fastest-moving, and the only entry that creates sub-levels.

---

## 11. Validation gate

Add the batch, refresh, build into `physics-dev`, and run:

```bash
# after launching and closing
grep -iE "mixin apply failed|mixin.*error" latest.log \
  | grep -viE "could not find uniform named|Unsupported Uniform Type"
```

**Checklist:**

- [ ] Game reaches main menu
- [ ] No mixin apply failures beyond the two known Veil/Iris overwrite lines
- [ ] **Fresh** scratch world generates and loads
- [ ] Sable contraption still assembles and moves (Phase 1–2 regression)
- [ ] Coaster track and cart still work (Phase 2 regression)
- [ ] **Linear Bearing: glued structure on Linear Casings converts to a sliding sub-level, and you can place and break blocks on it while it moves**
- [ ] **Linear Bearing: a Copycats+ block on that structure behaves — this is the documented 1.2.5 compat fix, test it deliberately**
- [ ] **Magnetic Port transmits rotation between two separate sub-levels**
- [ ] **Gyroscopic Gearbox holds alignment on a pitching craft**
- [ ] A vertical rope can be climbed bare-handed
- [ ] A copycat block applied to an airship reports a sensible mass, and the ship flies as expected
- [ ] An electric motor drives a kinetic network from a battery
- [ ] A Kinetic Battery behaves on a Sable sub-level
- [ ] **Connected wildcard feature disabled; exact config key recorded in this document**
- [ ] Regression confirm: two plain Create redstone links on the same sub-level talk to each other
- [ ] Regression confirm: a Linked Controller on a sub-level triggers a link on that same sub-level
- [ ] **`pack/config/create_connected-*.toml` copied in, `packwiz refresh` run, committed with the phase** — the pack's first tracked config
- [ ] `/sable forceload add` works on a sub-level (confirms the Power Loader decision was safe)
- [ ] Controls screen checked for new keybinds; findings written to `keymap.md`
- [ ] Versions and licences written to `docs/lockfile.md` **as you add, not after**
- [ ] **Linear Bearing licence determined** and recorded
- [ ] **No new `manual/` or ARR entries this phase** — confirm nothing crept in

**Load and confirm before we continue.**

---

## 12. Decisions made this phase

1. ~~**Crafts & Additions** — bend the no-second-tech-tree rule?~~
   **ANSWERED: yes, IN.** Scoped to power transport and conversion — see §4.2.
2. ~~**Steam 'n' Rails** — now or later?~~ **ANSWERED: deferred to Phase 4**, with
   the "what does it actually add" audit in §4.3.
3. ~~**Power Loader**~~ **ANSWERED: dropped.** FTB Chunks at Phase 7.
4. ~~**Sablewaves**~~ **ANSWERED: dropped.**
5. ~~**Jet Engines**~~ **ANSWERED: cut**, along with Propulsion: Simulated and
   Simulated Thrusters. The phase adds no propulsion at all.
6. ~~**Linear Bearing**~~ **ANSWERED: IN.** Tested and solid in game. Now
   archived upstream, which under the freeze policy is a non-issue for
   maintenance and an availability item for `manual/` — see §5.1.

---

## 13. Blanks to fill before you tag

The document is finalised; these are values only you can supply, and each has a
place waiting for it. **None blocks the gate — all block the commit.**

| Blank | Where it goes | Why it matters |
|---|---|---|
| **Connected wildcard config key** | §4.4, Phase 9.5 sheet, Phase 12 guidebook | "The wildcard one" will not be enough in six months |
| **Linear Bearing licence** | §5.1, lockfile, Phase 12 ARR list | **Priority — the project is archived.** If ARR, the `manual/` copy cannot be shared with your friends, which makes a delisting painful |
| **Copycats+ Aeronautics Weight licence** | §4.1, lockfile | Same |
| **Resolved versions for all six mods** | `docs/lockfile.md` | Especially `createaddition` and `create-connected` — §0.5 flagged both for version-parity checks against CurseForge |
| **Simurail sha256 + commit `0b3230f`** | Exceptions register | Only if the spike passes |
| **Linear Bearing jar in `manual/` + register row** | `manual/`, exceptions register | Availability hedge against delisting, same as Create: High Seas |

---

## 14. Gate result — PASSED, 16 Aug 2026

**Reported by you: everything in this phase that was not pruned has been tested
in game and works.** Recorded as the gate outcome.

For the record, the phase was validated across an unusually long working session
rather than a single pass at the end — the thruster launch test, the Connected
redstone-link fix, and Linear Bearing's behaviour were all confirmed by play, not
by reading mod pages. **Three of this phase's cuts came out of that testing**,
which is the opposite of how the two previous phases went.

**Two items are not covered by that result and remain outstanding:**

| Item | Status |
|---|---|
| **Create: Simurail spike** — the seven criteria in §5.3, on its own throwaway world | **Not run.** Separate from this gate by design; it is not in the manifest |
| **Fresh-world save/reload cycle** — save, quit, reload, save again | Confirm if you have not. It is the cheap check for the failure that ate the Phase 2 gate, and Linear Bearing creates persistent sub-levels |

---

## 15. Closing the phase

```bash
cd ~/Source/create-aero-physics

# 1. Confirm the throwaway is gone and side= fix is in (§0)
grep -r "waterparked" pack/ || echo "clean"
grep -H '^side' pack/mods/*physics-compat*.pw.toml

# 2. Gate passed — proceed
git add -A
git commit -m "Phase 3: Create breadth — 6 mods, Modrinth-only

Added: Copycats+, Copycats+ Aeronautics Weight, Create Crafts & Additions,
Create: Connected, Create: Linear Bearing, Climbable Ropes.

Config: Create: Connected wildcard feature disabled (create_connected #223 —
breaks redstone links on physics objects). First tracked config in the pack.

Cut during the phase: Steam 'n' Rails (deferred to Phase 4), Power Loader,
Sablewaves, Create Propulsion: Simulated, Simulated Jet Engines, Simulated
Thrusters, Throwable Rope Connector.

Not in the manifest: Create: Simurail (manual/, no upstream release)."
git tag phase-3-pass
```

**Phase 4 is a decision phase, not a mod list.** Worldgen options first, your
pick, then the mod proposal. Three things from this phase land on its desk:
Steam 'n' Rails, Simurail, and the parked thruster question — all three become
answerable once the world is decided.

---

## 16. Change log

| Date | Change | Reason |
|---|---|---|
| 16 Aug 2026 | Phase 3 drafted | Initial proposal |
| 16 Aug 2026 | Logistics and economy dropped from the phase charter | Create 6 ships logistics natively; economy contradicts the abundance philosophy |
| 16 Aug 2026 | Create: Interactive recorded as permanently rejected | Valkyrien Skies project — falls under the existing VS exclusion |
| 16 Aug 2026 | **Modrinth-first source policy added (§0.5)** at your instruction | CurseForge is fallback only |
| 16 Aug 2026 | **Create Crafts & Additions ACCEPTED — "no second tech tree" bent, deliberately** | Your call. Justified on power transport across a vehicle. **Bend is scoped: FE is a transport and conversion layer, not a progression ladder** |
| 16 Aug 2026 | Phase 5 watch item recorded | FE-native ore/quarry/mob machines will now argue from an installed energy system |
| 16 Aug 2026 | **Newest-wins ruling on version parity** | Modrinth-first is a tie-breaker, not a version ceiling |
| 16 Aug 2026 | **Sablewaves DROPPED, not spiked** | Your call. Same failure class as the cut Waterworks; not worth the spike time |
| 16 Aug 2026 | **Create: Power Loader DROPPED** | Your call — FTB Chunks at Phase 7. Reinforced by `/sable forceload` existing in Sable 2.0.0 |
| 16 Aug 2026 | **Steam 'n' Rails DEFERRED to Phase 4** | Feature audit (§4.3) shows it is mostly flavour on a rail system Create 6 already implements. Value is contingent on worldgen |
| 16 Aug 2026 | **Create: Linear Bearing ADDED as the phase's priority item** | Your ask for a Sable equivalent of Create: Interactive. Converts glued structures into sliding Sable sub-levels; also brings Magnetic Port and Gyroscopic Gearbox |
| 16 Aug 2026 | **Create: Interactive gap recorded as PARTIAL, not closed** | Sable already provides editable moving structures; the real gap is Create's own contraption blocks. Swivel Bearing covers rotation, Linear Bearing covers linear. Gantry and cart assembler have no Sable equivalent found |
| 16 Aug 2026 | Create Propulsion: Simulated proposed, Jet Engines recommended out | *Superseded the same day — see below* |
| 16 Aug 2026 | Sable Photomancy and Sable Tool parked to the Deferred Wishlist | Phases 7 / 9 |
| 16 Aug 2026 | **Create: Simulated Thrusters CUT** | Your call. Second flight paradigm in a lift-and-propeller pack, solving no problem you had. Removes the phase's last ARR entry, last pre-fault-line mod, last `manual/` job and the non-optional 9.5 config item |
| 16 Aug 2026 | **Throwable Rope Connector CUT** | Your call. Three items to save a short walk — flavour rather than friction. Parked, not closed |
| 16 Aug 2026 | **Config-tracking mechanism documented (§0.6)** | Nothing is tracked yet — configs live in the Prism instance. `packwiz refresh` indexes `pack/config/` like mods. Ship only deliberately changed files; tracked files are overwritten in the instance on rebuild |
| 16 Aug 2026 | Create: Connected redstone-link breakage documented upstream — `create_connected` #223, Simulated-Project #336 and #1065 | Correcting my earlier "observed by you" attribution |
| 16 Aug 2026 | **RESOLVED: disabling the wildcard feature fixes it. Connected KEPT.** | Confirmed by your own testing, which overrides my reading of the tracker. All three reported symptoms share one root cause — the wildcard feature's patch to link frequency resolution. Config, not a cut |
| 16 Aug 2026 | Connected's wildcard toggle becomes **the pack's first tracked config file** | Single deliberate change with a written reason — a good first entry for `pack/config/` |
| 16 Aug 2026 | **Phase 3 is now Modrinth-only** | With both cuts, every remaining mod resolves from Modrinth. No CurseForge entries, no new ARR entries, no new `manual/` items |
| 16 Aug 2026 | **Sound Physics Remastered and Simple Voice Chat parked (§6.5)** | Your request. Phase 8 and Phase 9 respectively; SVC carries a UDP port requirement and the largest keybind footprint yet, plus an open question on whether the comfort cap applies |
| 16 Aug 2026 | **Steam 'n' Rails deferral CONFIRMED** | Your call, on block bloat. Feature audit in §4.3 supports it — it is the only real variant registry in the phase |
| 16 Aug 2026 | **Create: Simurail found and recorded (§5.3)** — trains as Sable sub-levels | Your find. Confirmed to exist: `Crystaelix/Create-Simurail`, NeoForge 1.21.1, depends on Sable + Create + Aeronautics |
| 16 Aug 2026 | **Simurail licence confirmed MIT** | Read the repo rather than assuming. `LICENSE` is MIT and `jitpack.yml` is present, so redistribution was never the blocker — the decision below is a norms choice, not a legal one |
| 16 Aug 2026 | **My "hand-delivered forever" objection withdrawn** | Your point stands: under the freeze policy there are no updates, so the delivery cost is one-time, not recurring |
| 16 Aug 2026 | **Route C (link the Actions artifact) rejected** | Requires auth, resolves to a signed expiring URL, expires at 90 days, and arrives zip-wrapped. Same disqualification the spec already applies to Discord CDN links. The artifact itself is fine — download it and put the jar in `manual/` |
| 16 Aug 2026 | **Simurail DECIDED: `manual/` folder, hand-supplied to friends, migrate on upstream release** | Your call. Fork-and-release declined on community norms rather than licensing — a reasonable line, and the freeze policy makes the one-time delivery cost trivial |
| 16 Aug 2026 | Source `git bundle` + `LICENSE` alongside the jar added to the register row | Covers the repo-disappears risk without a public fork, and satisfies MIT's one obligation when handing jars to friends |
| 16 Aug 2026 | Simurail explicitly **not** on the ARR list | It is MIT. Recorded so Phase 12 does not group it with High Seas and Porkchop |
| 16 Aug 2026 | `.gitignore` hardened: `*.jar` globally, `manual/*` with `!manual/README.md` | Bare `manual/` would drop the folder and its note from a fresh clone. Global `*.jar` guards the distribution principle against a stray file `packwiz refresh` would index |
| 16 Aug 2026 | **Create Propulsion: Simulated CUT; Simulated Thrusters is the propulsion layer** | Your call — duplicates, and Thrusters is the better fit. Supported: Propulsion's registry is a tech tree (Stirling engine, burners, coral generator, diving suit, cable relays) rather than a propulsion mod |
| 16 Aug 2026 | **Jet Engines CUT** | Same duplicate logic. Propulsion is now one mod |
| 16 Aug 2026 | Costs of the cut recorded | Copycat Wings (redundant with Symmetric Sails), FE Ion Thruster (narrows the §4.2 FE argument), and a declared Sable 2.0.3+ compat statement. Thrusters is pre-fault-line and ARR, so the propulsion layer is now a single point of failure — `manual/` hedge required |
| 16 Aug 2026 | **Simulated Thrusters defaults observed as dangerously overpowered** | Four blaze-cake thrusters → ~3,000 blocks in one second, i.e. ~190 chunks/second. Recorded as a **stability** finding, not a balance one: outruns chunk loading and risks stranded sub-levels |
| 16 Aug 2026 | Thruster config bumped to **Phase 9.5 NON-OPTIONAL** | Joins the Sappy Tree Physics sub-level cap as a config item the pack cannot ship without. Target band suggested: 20–40 blocks/second top speed |
| 16 Aug 2026 | Simulated Thrusters `1.1.1` file ID confirmed **`8220627`** | Supplied by you as a `/download/<n>` URL. Consistent with the monotonic ID timeline. All three CurseForge add commands are now complete |
| 16 Aug 2026 | **Correction: Climbable Ropes IS on Modrinth** — slug `create-aeronautics-climbable-rope`, singular | My earlier "CF only" was a bad search, not a missing project. Removes a CurseForge fallback |
| 16 Aug 2026 | **Climbable Ropes version corrected to `2.0.1`** (28 May 2026) from the wishlist's `1.9.0` | Newest-wins. `2.0.0` added Player Animator animations via jar-in-jar — a third mod in the player-rendering subsystem alongside both ragdoll mods |
| 16 Aug 2026 | Propulsion: Simulated CF file ID confirmed `8496246`; `1.1.5` declares **Sable 2.0.3+** | Exact match for the pinned Sable. Also mentions *bundled* Simulated/Aeronautics/Offroad — check for duplicate mods at the gate |
| 16 Aug 2026 | CurseForge "third-party sharing disabled" hazard recorded | Affected projects serve no download URL to `packwiz cf add`. Another argument for Modrinth-first |
| 16 Aug 2026 | Simurail build received: `simurail-1.21.1-0.0.0-a+0b3230f.jar`, commit `0b3230f` | Register row filled. `0.0.0-a` is a placeholder version and carries no ordering meaning — the commit hash is the identity |
| 16 Aug 2026 | Create: Electro Energetics and the Automated Logistics Simurail layer noted | Surfaced via Simurail; parked to Phase 5 |
