# Deferred Wishlist — Things William Wants, Held For Later Phases

**Pack:** Create Aeronautics Physics Server
**Created:** 15 August 2026
**Purpose:** You said "remember please that I do want that (I will forget)."
This is that memory. Nothing here is lost; each item has an owning phase.

> **Read this at the start of Phases 3, 4, 5, 6, 7, 8 and 9.** Every item below
> is parked against a specific phase and should be raised when that phase opens,
> not left to be remembered.

---

## 1. Explicitly requested by you — do not drop these

| Item | Owning phase | Note |
|---|---|---|
| **Toolbelt / tool-carrying mod** | **Phase 7** (UI, QoL & inventory) | You flagged this yourself as "probably a later mod." Phase 7 is right. **Watch the philosophy conflict:** your inventory rule is *extend, don't nest* — a toolbelt that opens a second menu is exactly the backpack pattern you dislike. A toolbelt that swaps tools via radial or hotbar-in-place is fine. Judge candidates on that. |
| **Grappling Hook Mod: Skybound** | **Phase 6** (safety nets) — not Phase 7 | **This is the replacement for the swinging plunger that never shipped — see §2.** Grapples onto Create contraptions and Sable airships with rope tracking. Also brings Long Fall Boots, which serve fall safety directly. Verify it actually swings before committing. |
| **Climbable Ropes for Create Aeronautics** | **Phase 3** | MIT, `1.9.0` (16 May 2026). Climb vertical ropes by hand; **explicitly supports Plunger Launcher ropes**, plus ziplining along horizontal plunger ropes. Directly complements the Plunger Launcher you already have. **Keybind-heavy** — W/S climb, Ctrl+S slide, Space mantle, Shift release. Predates Aeronautics 1.3.0, so verify it still hooks the current rope system. |

---

## 2. The Plunger Launcher — two different things, and you were right

**Corrected 15 Aug after your clarification.** My first read was wrong.

There are two distinct tools being conflated:

| | What it does | Status |
|---|---|---|
| **What shipped** — Plunger Launcher, in Create Aeronautics `1.3.0` | Fires plungers that **connect two fixed points with a rope** — a tether/zipline | **You already have it.** Pinned in Phase 1. |
| **What was demoed on Discord and never shipped** | A **single** plunger — fire, attach, and **swing from it, Spider-Man style** | **Cut. Does not exist in the released mod.** |

So the swinging traversal you actually want is genuinely missing, and no
Aeronautics build provides it. The replacement has to come from a grapple mod.

### Best candidate — needs one thing verified

**Grappling Hook Mod: Skybound** — `v1.1+1.21.1-neoforge` (3 May 2026),
**GPL-3.0** (cleanest licence of anything on this list), Modrinth.

Why it's the right shape: it solves the *hard* part, which is grappling onto
things that move. Its own description says you can "grapple onto a flying Create
Aeronautics airship, a Sable sublevel, or an assembled Create contraption — the
rope tracks position, rotation, and sublevel splits." That's purpose-built for
this pack, not a generic grapple that happens to coexist. It also ships
upgrades (motors, rockets, ender teleport, magnets, dual hooks, forcefields) and
**Long Fall Boots**, which independently serve the Phase 6 fall-safety goal.

**The unverified bit:** I could **not** confirm from its documentation that it
does *pendulum swinging* rather than just pulling you to a point. The classic
Grappling Hook Mod that this descends from is known for rope-swing physics, so
it very likely does — but "very likely" isn't confirmation, and swinging is the
entire reason you want it. **Verify before committing.**

**Also flag:** 3 May 2026 predates Sable 2.0.0 (13 June). Given the verified
Auto Sable Physics failure, treat this as a version-gap risk and test it in
isolation, exactly like the ASP spike.

**Owning phase: 6** (safety nets), or bring it forward if you want it sooner —
it's a traversal toy as much as a safety net, and there's a fair argument it
belongs with the physics theme rather than the comfort layer.

### Phase 8 flag

iris-flw-compat issue #247 reports the **Plunger Launcher rope rendering
invisible under Iris shaders**. Joins the existing shader-artifact list
(cogs/shafts, hot air balloons). Not a blocker.

---

## 3. CurseForge finds, parked by phase

The CurseForge sweep surfaced ~20 Aeronautics addons absent from Modrinth.
These are the ones worth revisiting, with the phase that owns them.

### Phase 3 — Create breadth

| Mod | What it does | Notes |
|---|---|---|
| **Create: Simulated Jet Engines / Aero Propulsion** | Jet engines in several sizes for aircraft | Thematically strong for an airship pack. Unverified — check version and licence at Phase 3. |
| **Create Aeronautics: Throwable Rope Connector** | Makes docking with rope possible | QoL for airship docking |
| **Create Aeronautics: Kinetic Grip** | Adds a handle block | Minor; evaluate only if grabbing/handholds are a real gap |
| **Climbable Ropes** | See §1 | Pairs with Plunger Launcher |

### Phase 4 — Worldgen

| Mod | What it does | Notes |
|---|---|---|
| **Aero Islands (for Create Aeronautics)** | Sky island worldgen, from Isabel's Aeroscapes | A live option if Phase 4 goes sky-islands. Note alongside Awakened Islands and Sky Archipelago. |

### Phase 5 — Resource economy & automation

| Mod | What it does | Notes |
|---|---|---|
| **Create Aeronautics: Automated Logistics** | Station networks, automated docking, repeatable airship logistics routes | Genuinely interesting — airships as an *automation layer*, which fits "the answer to a grind is a machine." Evaluate seriously at Phase 5. |
| **Create Aeronautics: Simplified Logistics** | Autonomous ship navigation on a generated flight path | Simpler alternative to the above. **Pick one, not both.** |

### Phase 6 — World quiet & safety

| Mod | What it does | Notes |
|---|---|---|
| **Grappling Hook Mod: Skybound** | See §1 | Fall prevention |
| **Sable: Ragdoll Corpse** | Physical ragdoll corpse on death, natively Sable-aware | **Strong death-handling candidate.** Attacks your hardest failure case — dying on a moving sub-level. Modrinth, 26 Jun 2026. |
| **Sable Pathfinder** | Improves mob pathfinding across sub-levels | Only matters once mob policy is set. Pre-2.0 (6 Jun) — verify. |
| **Gravestone and Sable Compatibility Patch** | Fixes gravestone placement when dying on a sub-level | Only relevant if you pick a gravestone-style mod over a corpse-style one |

### Phase 7 — UI, QoL & inventory

| Mod | What it does | Notes |
|---|---|---|
| **Toolbelt (mod TBD)** | See §1 | Subject to extend-don't-nest |
| **Create Aeronautics x Curios API Compat** | Full Curios support for Aeronautics | Only if Curios enters via the inventory decision. Curios is an equipment-slot system — arguably *extends* rather than nests, so it may suit your inventory rule well. |
| **Jade Sable Compat** | Jade tooltips work on sub-levels | Pair with Jade when Jade is chosen |

### Phase 8 — Performance & rendering

| Mod | What it does | Notes |
|---|---|---|
| **Iris Veil Compat** | Bridges Veil (in Sable) through Iris shaderpacks | **Effectively required** if shaders are on. Tested with Aeronautics + Sable. |
| **Sound Physics: Aeronautics** | Extends Sound Physics so sub-levels aren't ignored | Needs Sound Physics Remastered. Only if that's taken. |
| **Sable Dynamic Lights** | Dynamic lighting on contraptions and sub-levels | Rendering decision |
| **SSRD / Sable: Far and Wide** | Physics objects render/simulate beyond view distance | SSRD hard-requires Sodium |
| **Sable: New Sodium Compat** | Sable ↔ newer Sodium | Version-dependent |

### Phase 9 — Server ops

| Mod | What it does | Notes |
|---|---|---|
| **Sable CleanUp** | Find/teleport/freeze/schematic/disassemble/delete every sub-level; bulk ops | Deferred here from Phase 2 by your call. MIT, `0.3.0`. |
| **Shtreimel – Sable Utility** | Server-side admin tools for Sable and Aeronautics | **Alternative to Sable CleanUp** — compare the two at Phase 9, take one. |
| **FTB Chunks: Sable Aerospace** | Protects Sable structures inside claimed chunks | Only if FTB Chunks is chosen for claiming |

---

## 4. Considered and parked — water & ships

Full analysis in the Phase 2 document §10. Summary: **Create: Better High
Seas**, **Waterworks – Sable**, **Create Deep Seas** and **Sable: Water
Pressure** all deliver hull/flooding/buoyancy behaviour, all are CurseForge-only
and All Rights Reserved, and **all bundle sinking and danger mechanics you've
said you don't want**.

**Revisit at Phase 3**, after the water probe in the Phase 2 gate tells us
whether Sable already occludes water inside sub-levels. If it does, this whole
category is unnecessary.

---

## 5. Ruled out permanently — don't re-propose

| Mod | Why |
|---|---|
| **CC: Sable, Create: Avionics** | ComputerCraft. Locked OUT at Phase 0. |
| **VS / Sable Hose Connectors** | Bridges Valkyrien Skies — a second physics engine. |
| **Create Aeronautics: Aeroshields** | Shield generator — combat content. |
| **Rising Toxicity, Space War – Aeronautics** | Adventure/combat content. |
| **Powered by Pollution** | Joke mod. |
| **Auto Sable Physics** | Verified critical load failure against Sable 2.0.3 (spike, 15 Aug 2026). |
| **Farm & Charm** | Documented startup crash with Sable + Aeronautics. |
| **Voxy** | Ruled out at Phase 0 — ARR, no official 1.21.1 build. |

---

## 6. Change log

| Date | Change |
|---|---|
| 15 Aug 2026 | Created. Toolbelt, grappling hook and climbable ropes recorded at your request; CurseForge sweep results parked by phase. |
| 15 Aug 2026 | **Plunger Launcher entry corrected.** My first read said "already shipped, nothing to do." Wrong — the shipped tool is a two-point rope tether; the **single-plunger swinging** version demoed on Discord was cut and does not exist. Grappling Hook Mod: Skybound is the candidate replacement. |
