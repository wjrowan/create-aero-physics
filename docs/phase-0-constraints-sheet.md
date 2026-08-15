# Phase 0 — Locked Constraints Sheet

**Pack:** Create Aeronautics Physics Server
**Platform:** MC 1.21.1 / NeoForge / Create 6.x
**Status:** LOCKED
**Date locked:** 11 August 2026

> Every later phase is checked against this sheet. Changing anything here is a
> deliberate act that gets recorded in the change log at the bottom, not a quiet
> edit.

---

## 1. Platform

| Item | Value |
|---|---|
| Minecraft | 1.21.1 |
| Loader | NeoForge |
| Create | 6.x |
| Rationale | Create: Aeronautics and Create: Coasters Simulated exist only here |

Immovable. Nothing in this pack justifies a version change.

---

## 2. Hosting

### Two environments — do not confuse them

| | Build environment | Production environment |
|---|---|---|
| **What** | Desktop, openSUSE Tumbleweed dual-boot | Dedicated household machine |
| **Purpose** | Phases 0.5–8 dev instance and validation gates | The real server |
| **Lifespan** | Disposable, rebuilt freely | Permanent, holds the one world |
| **Built at** | Phase 0.5 | Phase 9 |

The dual-boot install is a **build environment only**. 24/7 uptime is a
requirement of the production host, not of this machine.

### Production host

| Item | Value |
|---|---|
| Architecture | x86_64 |
| OS | Windows (probable) |
| Runtime | Docker Desktop (WSL2 backend) |
| Candidates | Friend's gaming laptop, or one of several idle household PCs |
| Uptime target | 24/7 |
| Upload bandwidth | ~150 Mbps — not a constraint at this player count |

### Windows + Docker Desktop consequences (carried to Phase 9)

These are design constraints, not problems. They get built into the compose
file and the runbook.

1. **The world lives in a Docker named volume.** Never a bind mount to the
   Windows filesystem. Named volumes sit inside the WSL2 VM's ext4 filesystem;
   bind mounts cross the Windows/Linux boundary and incur a severe random-I/O
   penalty. A world saving physics contraptions continuously is the exact
   workload that punishes this.
2. **Backups cross the boundary deliberately, not accidentally.** Backup output
   is large sequential writes, which tolerate a bind mount fine. So: world on a
   named volume, backup target on a bind mount to somewhere on Windows you can
   see and copy off-machine.
3. **WSL2 memory is capped in `.wslconfig`.** Without it WSL2 reserves far more
   host RAM than the container's own limit implies.
4. **24/7 is a Windows configuration task, not a Docker one:**
   - Sleep and hibernate disabled on the host
   - Docker Desktop set to start on login
   - Container restart policy `unless-stopped`
   - Windows Update active hours configured — an unattended forced reboot is the
     single most likely cause of unexplained downtime

**Standing recommendation:** native Linux on one of the idle household machines
is simpler, faster and removes items 1–4 entirely. Worth revisiting at migration
time. Not a blocker.

---

## 3. Memory

| Item | Value |
|---|---|
| Build machine total | 32 GB |
| Client heap | 8 GB |
| Server heap | 12 GB |
| Adjustability | Both are environment variables, not rebuilds (Phase 9) |

**Idle heap footprint is a tuning requirement, not an accepted cost.** A server
that sits at 12 GB resident while nobody is online is misconfigured, not busy.
Low `-Xms`, collector chosen deliberately at Phase 9.

---

## 4. Players and load

| Item | Value |
|---|---|
| Typical concurrent | 2–3 (you, one friend, brother occasionally) |
| Occasional | A few more, inconsistently |
| Design driver? | **No.** Player count is not a constraint on mod selection. |

### Building pattern — clustered, not spread

Explicitly stated preference. This is a genuine performance win and the pack is
allowed to spend it: clustered building keeps loaded-chunk count low and makes
the Phase 9.5 budgets far easier to hold than a spread-out world would.

### Force-loading

- Force-load capability required.
- **Per-player chunk cap**, raisable by you later.
- **This cap is the lever that reconciles two stated goals:** "farms run
  overnight" and "don't burn CPU while idle." Idle cost is bounded by this
  number, not by mod choice. Set at Phase 9.5 against the tick budget below.

---

## 5. World

*(New constraint added during Phase 0. Full treatment at Phase 4.)*

| Item | Value |
|---|---|
| Border | Hard border, approximately 10,000 × 10,000 |
| Structure density | Guaranteed, not sparse — old-style generation feel |
| Resets | **None. One world, generated once, at the Phase 11 gate.** |

**Open questions carried to Phase 4:**
- Border centring — ±5000 from spawn, or offset?
- Does the border apply to the Nether and End, or overworld only?

**Note:** a bounded world would normally raise resource-exhaustion concerns. It
does not here — the pack's abundance comes from machines, not from ground area.

---

## 6. Client hardware

| Item | Value |
|---|---|
| Your GPU | RTX 5070 Ti |
| Friends | Generally good hardware |
| **Floor** | **Steam Deck class** |
| Floor's compromises | Reduced render distance, Distant Horizons off, shaders off |

### Standing caveat

**Physics sub-level cost does not scale down with render distance.** Simulating
and rendering a moving contraption is work the client does regardless of how far
it can see. The Deck-class machine may therefore struggle specifically near
large moving contraptions, and settings will not fully fix that.

Partially answerable by the Phase 2 shader/rendering spike. Recorded now so it
is not a surprise at Phase 8.

---

## 7. Tick budget

Set during Phase 0. Every Phase 9.5 cap is tuned against these numbers.

| Condition | Target | Treatment |
|---|---|---|
| At rest | **20 TPS** | Anything idle costing measurable tick time is a defect |
| Under load | **≥15 TPS** | Acceptable during contraption assembly, chunkgen, large flights |
| Sustained | **<10 TPS** | **Bug.** Investigated, not absorbed as normal load. |

---

## 8. Distribution

| Item | Value |
|---|---|
| Source of truth | **packwiz** (text-based, git-native, hashes and pins versions) |
| Export format | **`.mrpack`** |
| Client launcher | **Prism Launcher** — all players |
| Install difficulty target | Comprehensible to someone who has never used mods |

### Why `.mrpack` suits this pack

- Each file entry requires **SHA1 and SHA512 hashes** — satisfies the
  reproducibility half of the lockfile requirement natively.
- Each file carries an **`env` block** (`required` / `optional` / `unsupported`,
  per side) plus layered `overrides`, `client-overrides` and `server-overrides`
  folders. This delivers the Phase 12 requirement for a real client/server split
  by format rather than by hand.

### Open: Tier B (GitHub) viability — VERIFY AT PHASE 12

The `.mrpack` spec defines a download-domain whitelist, but **it is enforced on
upload to Modrinth**, and the spec only says other implementations *should*
define their own. Since this pack is distributed privately and never uploaded,
what matters is what **Prism enforces on import** — unconfirmed.

**Fallback if Prism restricts it:** `packwiz-installer` as a Prism pre-launch
step. Bypasses the format constraint entirely and auto-syncs every client to the
same version, which independently solves the "version mismatch breaks small
servers" problem. Cost is a slightly heavier one-time setup per friend.

Decision deferred to Phase 12. Phase 2 and 3 will almost certainly want at least
one GitHub-only mod, so this must be resolved before the mod list is final.

---

## 9. Rendering and shaders

| Item | Value |
|---|---|
| Shader support | **First-class.** Supported and preconfigured. |
| Supported pack | **Complementary Reimagined + Euphoria Patches** |
| Other shaders | **Unsupported.** Stated plainly in the install guide. |
| Settings | Your tuned settings ship with the pack |
| Distant Horizons | **IN** |
| Voxy | **OUT** |
| Bundling | Shader packs are never bundled — referenced with instructions |

### Why your shader settings can ship

Iris stores per-pack settings as a small text file. A settings file you authored
is **pack-authored content** under the distribution principle's carve-out, not
redistribution. Friends download Complementary themselves; your settings land on
top of it.

### Why Voxy is ruled out

Verified 11 Aug 2026:

- The original author has stated they will **not backport to 1.21.1**. No
  official NeoForge build exists.
- Only **unofficial community forks** are available.
- The original mod is **All Rights Reserved**, with ports described as for
  personal use — incompatible with the distribution principle.
- **Shader support in the ports is explicitly incomplete**, with port
  documentation advising testing with shaders disabled first.

Alpha unofficial fork + ARR licence + unresolved shader support, in a pack where
shaders are a design goal. Fails QUARANTINE and the distribution principle
simultaneously.

### Distant Horizons + Complementary — version-sensitive

Complementary Reimagined appears on the maintained list of DH-compatible
shaders. However, there is known history: a cloud-rendering-through-terrain
issue under DH, resolved in newer builds requiring the **Iris + DH compatibility
v2** system. So "Complementary works with DH" is true only for specific version
combinations.

**Pinned at Phase 8, not before.**

### Unverified — VERIFY AT PHASE 8

**Euphoria Patches on 1.21.1**: current status and distribution method not
confirmed. If it is applied *to* Complementary rather than being standalone,
that is a manual step for every friend on every shader update, and it needs a
line in the install guide.

---

## 10. Recipe unification

| Field | Value |
|---|---|
| Mod | **Almost Unified** (AlmostReliable) |
| Source | Modrinth `almost-unified` / CurseForge project 633823 |
| Tier | **A only** |
| Latest 1.21.1 NeoForge | 1.4.2 (22 May 2026); prior 1.4.1 (4 Apr 2026) |
| Enters at | **Phase 5** |
| Ladder rung | 3 — tag unification, above datapacks and KubeJS |

**Tier A only, deliberately.** The licence is All Rights Reserved but explicitly
permits modpack use *provided files come from CurseForge or Modrinth*, with
GitHub releases intended as a private fallback. Do not reference the GitHub
release even though Tier B is otherwise acceptable in this pack.

**Why Phase 5, not Phase 1:** it does nothing until duplicate materials exist,
and it mutates recipes. Adding it early would muddy crash attribution in Phases
1–3 for zero benefit.

**Honest expectation:** duplicate-material pain scales with kitchen-sink
breadth. A Create-centric pack under a strict "default to NO" policy will
generate much less of it than a typical 200-mod pack. Worth taking — one config
file, removes a category of future recipe debt — but it will not do heavy
lifting here.

**Flag for Phase 12:** goes on the All Rights Reserved list.

---

## 11. Programmability

**ComputerCraft-class programmability is OUT.** Locked.

Your reasoning, which I agree with: it converts playing Minecraft into doing
development work. Secondary reasons — it is a second scripting surface in a pack
that treats scripting as a last resort, it brings its own keybinds and
peripheral UI, it has a strong addon-chain pull, and physics-mod peripheral
bridges on 1.21.1 are unlikely to be mature.

---

## 12. Standing grants and accepted risks

| Grant | Status |
|---|---|
| Phase 2/3 mods touching worldgen or dimensions enter as **PROVISIONAL**, re-confirmed at Phase 4 | **Granted** |
| Some flexibility on locked lists permitted; changes still raised as flags, never made silently | **Granted** |
| Friends function as the QA department; stated openly in the Phase 12 install guide and changelog | **Accepted** |

---

## 13. Open items carried forward

| Item | Owning phase |
|---|---|
| Border centring; whether border applies to Nether and End | Phase 4 |
| Prism's enforcement of `.mrpack` download domains (Tier B viability) | Phase 12 |
| Euphoria Patches 1.21.1 status and distribution method | Phase 8 |
| Exact DH + Iris + Complementary version combination | Phase 8 |
| Per-player force-load cap value | Phase 9.5 |
| Final production host machine and OS | Phase 9 |

---

## 14. Verification log

Everything below was confirmed by search on 11 August 2026, not asserted from
memory.

| Claim | Source |
|---|---|
| Almost Unified has 1.21.1 NeoForge builds; latest 1.4.2 (22 May 2026) | Modrinth / CurseForge project 633823 |
| Almost Unified is ARR but permits modpack use from CF/Modrinth only | AlmostReliable GitHub repository |
| `.mrpack` requires SHA1 + SHA512 per file | Modrinth format documentation |
| `.mrpack` supports `env` and client/server override layers | Modrinth format documentation |
| `.mrpack` domain whitelist is enforced on upload to Modrinth | Modrinth format documentation |
| Voxy has no official 1.21.1 NeoForge build; author declined backport | Community port repositories |
| Voxy is ARR; ports are personal-use | Community port repositories |
| Voxy port shader support incomplete | Port documentation |
| Complementary Reimagined listed as DH-compatible | Maintained DH shader compatibility list |
| Complementary/DH cloud issue fixed only in newer builds with Iris+DH compat v2 | Maintained DH shader compatibility list |

---

## 15. Change log

| Date | Change | Reason |
|---|---|---|
| 11 Aug 2026 | Sheet locked | Phase 0 complete |
