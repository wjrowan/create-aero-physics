# Phase 1 — Core Physics Stack

**Pack:** Create Aeronautics Physics Server
**Status:** Proposed — awaiting critique
**Date:** 13 August 2026
**Adds mod files:** Yes — the first four. This phase has a validation gate.

> Everything below was confirmed by search on 13 August 2026 (mostly against the
> Modrinth API directly, since Modrinth's rendered pages load their version
> lists client-side and don't show up in a plain fetch). Nothing here is
> asserted from memory.

---

## 1. The good news: no separate glue layer

The spec assumed Phase 1 would need "the mandatory compat and glue layer" on
top of the four named mods. I went looking for it and couldn't find one that's
actually needed:

- **Flywheel** used to be a separate required mod. As of Create 0.5.1 it's
  bundled inside Create's own jar — the Modrinth dependency list for every
  Create 6.x release on 1.21.1 is empty. Nothing to add.
- **Veil** (a rendering/engine library) is *embedded* inside Sable's jar
  (Modrinth marks it `embedded`, not `required`) — again, nothing to add
  separately.
- Sable also lists **ImGuiMC** as an *optional* dependency (a debug-overlay
  library for developers). Not needed for play.
- Create: Aeronautics and Create: Coasters Simulated each declare exactly two
  **required** dependencies on Modrinth: Create and Sable. No third compat mod
  is listed by either author.

So Phase 1 is genuinely four mods, not four-plus-glue. If that changes — if
either addon starts silently failing without something else installed — it'll
show up at the validation gate, not get discovered later.

One thing worth flagging rather than quietly accepting: Modrinth's own metadata
lists Create's `client_side` as **"optional"** (server: "required"), which
looks wrong for a mod whose whole point is client-rendered content. I'm
treating this as a metadata quirk upstream, not a hint that Create can be
skipped on clients — install it both sides. But it matters for the Phase 12
`.mrpack` `env` block, so it's noted there rather than assumed away.

---

## 2. The four mods

| Field | Value |
|---|---|
| **Name** | Create |
| **Source** | Tier A — [modrinth.com/mod/create](https://modrinth.com/mod/create) |
| **Version** | `6.0.10+mc1.21.1` (published 21 Apr 2026) |
| **Side** | Both (Modrinth lists client as "optional" — treat as required anyway, see §1) |
| **Size** | Large systems-based content mod (kinetic blocks, contraption blocks, schematics). Not block-spam in the philosophy's sense — few base blocks with many *states*, not variant explosion. Could not find an authoritative exact registry count; if you want the real number, `/create list` in-game after the gate will give it. |
| **Role** | The foundation. Everything else in this pack sits on top of Create's kinetic/contraption systems. |
| **Risk tier** | **LOCKED** |
| **Cut order** | 4 (last — nothing else runs without it) |
| **Known conflicts** | None yet (nothing else is installed). Carried forward: Create's own 6.0.10 changelog fixed "older Flywheel being loaded when a mod like Vanillin is installed" — a Flywheel-version collision class of bug. Relevant again in Phase 3 when other Create-ecosystem addons enter; flagging now so it's not a surprise then. |
| **License** | `LicenseRef-Create-Mod-License` — standard Create-ecosystem license, permits modpack distribution. Not a Phase 12 ARR flag. |

---

| Field | Value |
|---|---|
| **Name** | Sable |
| **Source** | Tier A — [modrinth.com/mod/sable](https://modrinth.com/mod/sable) |
| **Version** | `2.0.3+mc1.21.1` (published 17 Jun 2026) |
| **Side** | Both, required |
| **Size** | Zero content. Its own description: "Sable does not add any content to the survival game, or any manner of constructing sub-levels in survival." It's a library other mods build on. |
| **Role** | The physics engine (Rapier-based) and the sub-level system underneath everything Aeronautics and Coasters do. This *is* the pack's spine, per the project description. |
| **Risk tier** | **LOCKED** |
| **Cut order** | 3 |
| **Known conflicts** | Sable's own README states it plainly: **"Sable is an incredibly intrusive mod. It makes extensive use of mixins, and is prone to extensive compatibility issues with other mods."** That sentence should be the standing lens for every mod proposed from Phase 2 onward — treat any mod that touches rendering, chunk loading, or entity ticking as a Sable collision risk until proven otherwise. Version 2.0.3 specifically fixed a crash with sub-level splitting and a bug where sub-level bounds could get corrupted to `[0,0,0,0,0,0]` and fail to load back in — both are exactly the failure class that would eat a grave sitting on a sub-level, so it's good this is already patched going in, not something we're inheriting. |
| **License** | `LicenseRef-PolyForm-Shield-License-1.0.0` — a source-available "fair source" license, not OSI-standard, not ARR. Doesn't restrict private non-commercial modpack use, but it's not MIT/permissive either. Flag for the Phase 12 licensing pass alongside Almost Unified. |

---

| Field | Value |
|---|---|
| **Name** | Create: Aeronautics |
| **Source** | Tier A — [modrinth.com/mod/create-aeronautics](https://modrinth.com/mod/create-aeronautics) |
| **Version** | `1.3.0+mc1.21.1` (published 13 Jun 2026) |
| **Side** | Both, required |
| **Size** | Moderate — vehicle-mechanic blocks and items (bearings, sensors, propellers, docking connectors, throttle levers, steering wheels, etc.), not a block-spam mod. Exact registry count unconfirmed; not published on the mod page. |
| **Role** | One of the two headline addons — flying/driving physics contraptions (the "Aeronautics" content section) plus assembly/redstone tooling (the "Simulated" section) and land vehicles (the "Offroad" section), all in one mod, not three separate downloads. |
| **Risk tier** | **LOCKED** |
| **Cut order** | 1 (first to isolate if something in this stack is misbehaving — see below) |
| **Known conflicts** | Confirmed already in Phase 0: **visual issues with Iris Shaders**, stated by the mod's own author. That's the Phase 2 shader spike's job to characterize, not this phase's. The 1.3.0 changelog also fixed a "ServiceLoader crash in large modpacks" — worth remembering as this pack's mod count grows through Phase 2/3, since it suggests Aeronautics has been sensitive to classloading pressure from a big mod list before. Its own changelog says it was "updated to Sable 2.0.0" internally, while we're pinning Sable 2.0.3 — almost certainly fine (same 2.0.x line, patch-only fixes since), but it's the one cross-mod version pairing in this phase that hasn't been used together by anyone I could find evidence of, so it's the first thing to test at the gate, not assume. |
| **License** | `LicenseRef-Simulated-Project-License` — custom license, terms not fully readable from the project page (links out to a GitHub license file rather than stating terms inline). Flag for Phase 12 alongside Sable's PolyForm license — I couldn't fully confirm its modpack-redistribution terms and didn't want to assert them. |

---

| Field | Value |
|---|---|
| **Name** | Create: Coasters Simulated |
| **Source** | Tier A — [modrinth.com/project/W1ZUfWdr](https://modrinth.com/project/W1ZUfWdr) |
| **Version** | `0.1.4` (published 6 Aug 2026) |
| **Side** | Both, required |
| **Size** | Moderate — track blocks, anchorpoint blocks, carts, chain lift components. Exact count unconfirmed. |
| **Role** | The other headline addon — roller-coaster physics: loops, inversions, chain lifts, cart linking. |
| **Risk tier** | **LOCKED** |
| **Cut order** | 2 (prunable independently of Aeronautics — they don't depend on each other, only on Create + Sable) |
| **Known conflicts** | None specific to other mods yet. This is the youngest mod in the pack by a wide margin — Modrinth's own listing carries an "Early Bird Warning" from the authors: the mod "has reached a fairly stable state suitable for release" but expect bugs in the first weeks. That matches the project's alpha-acceptance policy, so it stays, but it's the most likely of the four to need a version bump under the freeze policy's crash-fix exception. Confirms the spec's own note that "Coasters shipped two releases in two days" — 0.1.3 (5 Aug) and 0.1.4 (6 Aug) were exactly that, and 0.1.4's fix (a crash destroying a rivet holding only weightless blocks) is a real stability fix, not a feature bump, which is why I'm pinning 0.1.4 rather than 0.1.2. |
| **License** | MIT. Clean, no Phase 12 flag needed. |

---

## 3. Cut order, explained

Ranked 1 (pull first) → 4 (pull last):

1. **Create: Aeronautics** — highest surface area of the four addons/libraries in
   this phase (three content sections, known Iris issue, known classloading
   sensitivity). If a Phase 1 crash looks unrelated to coasters specifically,
   suspect this first.
2. **Create: Coasters Simulated** — independent of Aeronautics (both sit on
   Create+Sable, not on each other), so it can come out on its own without
   losing flight. Youngest mod in the phase, most likely to need a freeze
   exception later.
3. **Sable** — pulling this breaks both addons simultaneously, since both
   require it directly. Only pull this if the crash signature points at the
   physics/sub-level layer itself rather than either addon's own logic.
4. **Create** — never pulled in practice. If Create is the problem, there is no
   pack; the fix is a different Create build, not removal.

This is the ranked list the spec's Phase 10 integration pass will eventually
merge with every later phase's cut order into one master list. Recording it now
means Phase 10 has source material instead of a blank page.

---

## 4. Keybinds — flagged, not fully resolved

I could not get a reliable, non-fabricated list of every keybind these four
mods register — Modrinth pages don't publish that, and search results for
Create's keybinds were too generic to trust. What I *can* say with confidence,
from multiple independent sources describing how Aeronautics vehicles are
actually flown: **vehicle control (throttle, steering, altitude) is done via
in-world blocks and items — levers, joysticks, steering wheels — not via
keyboard keybinds.** That's a genuinely good sign for the "curated, not
accumulated" keybind philosophy; Aeronautics doesn't appear to be fighting you
for key real estate.

The one confirmed keybind-relevant line: Create 6.0.10's own changelog says it
added **"keybinds for ctrl, shift and alt modifiers."** I don't know exactly
what that does or whether it's a new bindable key or an existing one gaining
modifier support, and I'm not going to guess.

**Recommendation:** at the Phase 1 validation gate, open the vanilla Controls
screen, filter by "Create" and "Create: Aeronautics," and copy what's actually
registered into `docs/keymap.md` verbatim. That's ground truth; nothing else
is. Coasters Simulated is new enough that I'd expect it to register little or
nothing, but check it the same way. This keeps the keybind file honest from
the first phase instead of starting it from a guess.

---

## 5. Grind flag

Nothing in this phase is a grind concern — these are physics/building
mechanics, not resource gates. Nothing to automate away yet. Resource economy
is Phase 5's job.

## 6. Scope creep flag

None. All four are named explicitly in the spec's Phase 1 charter.

---

## 7. What to actually run

Your `pack.toml` should already exist from Phase 0.5. Before adding anything,
confirm the one thing that phase flagged as a live risk:

```bash
cd create-aero-physics/pack
cat pack.toml   # confirm neoforge = "21.1.x", NOT "21.10.x" or "21.11.x"
```

Worth double-checking now specifically because NeoForge has since shipped a
2026-era "26.1" release line and MC 1.21.11 tooling is circulating in search
results — more surface area for the exact bug Phase 0.5 warned about than
there was when that doc was written. If `pack.toml` shows anything other than
`21.1.x`, stop and fix that before adding mods.

Then, per the Phase 0.5 per-phase loop:

```bash
git checkout -b phase-1

# Dependency order matters less than you'd think — packwiz will offer to pull
# in required deps automatically if you add Aeronautics or Coasters first.
# Doing it in this order just means no prompts to answer.
packwiz mr add create                        # → resolves to 6.0.10+mc1.21.1
packwiz mr add sable                         # → resolves to 2.0.3+mc1.21.1
packwiz mr add create-aeronautics             # → resolves to 1.3.0+mc1.21.1
packwiz mr add create-coasters-simulated      # → resolves to 0.1.4

packwiz refresh
packwiz serve
```

Then install into `physics-dev` via the pre-launch bootstrap command from
Phase 0.5, launch, and run the validation gate.

### Validation gate — Phase 1

- [ ] `check.sh` (the four `grep` patterns from Phase 0.5 §7) returns nothing
- [ ] `latest.log` shows all four mods loaded, no missing-registry or
      duplicate-mod lines
- [ ] Mod count near the top of `latest.log` matches expectations (4 mods +
      NeoForge + any auto-pulled deps — should be none per §1)
- [ ] A scratch creative world generates and loads
- [ ] Place and power a basic Create kinetic contraption (windmill or similar)
      — confirms Create's own systems work before layering physics on top
- [ ] Assemble something with Create's contraption system and confirm it moves
      cleanly — this is the Sable sub-level boundary in action even before
      Aeronautics/Coasters add their own content
- [ ] Place an Aeronautics component (e.g. a bearing or the steering wheel) and
      confirm it renders and responds — headline-feature smoke test
- [ ] Place a length of Coasters track and a cart, confirm it moves under
      gravity — headline-feature smoke test
- [ ] Open Controls, filter "Create" / "Create: Aeronautics" / "Create:
      Coasters Simulated", copy whatever's registered into `docs/keymap.md`
- [ ] `docs/lockfile.md` updated with these four rows (see below)

On pass:

```bash
git add -A
git commit -m "Phase 1: Create, Sable, Create Aeronautics, Create Coasters Simulated"
git tag phase-1-pass
```

**Load and confirm before we continue.**

### Lockfile rows to add

| Mod | Tier | Source | Version | Side | Phase | Risk | Cut order |
|---|---|---|---|---|---|---|---|
| Create | A | Modrinth (`create`) | 6.0.10+mc1.21.1 | both | 1 | LOCKED | 4 |
| Sable | A | Modrinth (`sable`) | 2.0.3+mc1.21.1 | both | 1 | LOCKED | 3 |
| Create: Aeronautics | A | Modrinth (`create-aeronautics`) | 1.3.0+mc1.21.1 | both | 1 | LOCKED | 1 |
| Create: Coasters Simulated | A | Modrinth (`create-coasters-simulated`) | 0.1.4 | both | 1 | LOCKED | 2 |

---

## 8. Open items carried forward

| Item | Owning phase |
|---|---|
| Confirm exact keybind list for these four mods from the Controls screen | This gate, recorded into `docs/keymap.md` |
| Create's Modrinth `client_side: optional` metadata quirk — verify it doesn't affect `.mrpack` client/server split | Phase 12 |
| Sable's PolyForm Shield license and Aeronautics' Simulated Project License — both flagged, neither ARR | Phase 12 |
| Iris/Aeronautics visual issues — characterize severity | Phase 2 (shader spike, as already scheduled) |
| Sable's "extensive mixins, prone to compatibility issues" warning — standing lens for every subsequent mod | Ongoing from Phase 2 |

---

## 9. Change log

| Date | Change | Reason |
|---|---|---|
| 13 Aug 2026 | Phase 1 drafted | Four core mods verified via Modrinth API; no separate compat/glue layer found to be necessary |
