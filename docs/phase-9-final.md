# Phase 9 — Server Ops, Containerisation & Backups — **FINAL**

**Create Aeronautics Physics Server**
Preceding tag: `phase-8-pass` (not yet tagged — see §7) · Entering: **85 entries**
· Exiting: **82 entries, 0 added, 3 removed** · Tier C: **one added** (Create:
High Seas, moved from a broken CurseForge-managed entry) · `manual/` jobs:
one archive + one register row · Branches: none · New keybinds: **zero**

Decisions taken during this phase: **`PACKWIZ_URL` tracks `main`, not a
dedicated `release` branch** · **three mods cut for hard-crashing a dedicated
server, root-caused rather than guessed** · **restore procedure rewritten
after the brief's version didn't work against the real image**

---

## 1. What this phase actually was

The brief (`phase-9-build-brief.md` + `phase-9-server-ops.md`, both supplied
externally, not committed to `docs/`) described two halves: add spark and
Shtreimel to the manifest, then stand up the container. By the time this
session started, **the manifest half was already done** — a prior session had
added both mods, run the side audit, and flipped Distant Horizons to
`side = "both"` (commit `756e769 Phase 9 Complete`, 28 Aug 2026). What
remained, and what this phase's real content turned out to be, was entirely
infrastructure: install Docker on the dev machine, stand up
`server/docker-compose.yml`, and — the part the brief didn't anticipate —
**find out why the container wouldn't actually boot.**

Three separate mods hard-crash a dedicated server. None of the three were
Phase 9 additions; all three had been sitting in the manifest since earlier
phases and had simply never been exercised server-side, because this is the
first phase that boots one for real. That is the same shape as the side-audit
finding in the original Phase 9 plan — untested assumptions surviving until
something actually runs them — just one level deeper.

---

## 2. Three server-crashing mods, found by actually booting the thing

### 2.1 Create: High Seas — CurseForge distribution block

`create-high-seas.pw.toml` used `mode = "metadata:curseforge"`. CurseForge
excludes this specific file from third-party API distribution, so
packwiz-installer can't resolve it — not just server-side; a fresh client
install would hit the same wall. Interactively (Prism) packwiz-installer can
pause and let a human place the file by hand; headless on the server there's
no TTY to prompt, so it just aborts.

This was flagged three phases ago and never actioned: `docs/phase-2-complete.md`
§3 already said *"archive the High Seas jar in `manual/` and log it in
`docs/exceptions-register.md` — not as a Tier C exception, but as an
availability hedge... Now."* It just never became load-bearing until this
phase's headless install exercised it.

**Fix:** removed the packwiz-managed entry, archived the jar at
`manual/highseas-0.1.3.jar`, created `docs/exceptions-register.md` (which
didn't exist) with the row. Both client and server installs now need it
placed by hand — true today regardless of this phase.

### 2.2 Create: Linear Bearing — genuine mod bug, cut

`linearbearing-1.3.5` (the current, newest Modrinth release) references
`net.minecraft.client.resources.model.BakedModel` — a client-only class —
unconditionally in its mod constructor. NeoForge's `RuntimeDistCleaner`
blocks the class reference on `DEDICATED_SERVER`, so the container
crash-looped on every boot attempt. No newer build exists to take instead;
this is the current release, broken as shipped.

**Fix, per William's call:** removed rather than parked as `side = "client"`,
since it's an unmaintained project and the bug makes it unusable in any
multiplayer context regardless of side flag.

### 2.3 The Porkchop Express — root-caused, not guessed

The deepest one. After fixing the two above and three mis-set side flags
(§2.4), the server booted fully — world generated, DH initialised, RCON came
up, `Done! For help` — then crashed on the very next entity movement (a wild
rabbit's AI step). The crash: `Attempted to load class
net/minecraft/client/player/AbstractClientPlayer for invalid dist
DEDICATED_SERVER`, thrown from inside a mixin whose method name contained
`$sable$collideRedirect` — which read, at first, like a Sable bug serious
enough to threaten the entire pack (Sable is the mod this pack is about).

Decompiled `sable.jar` with CFR: no reference to `AbstractClientPlayer`
anywhere in it. The method in question, `sable$collideRedirect`, calls
`SubLevelEntityCollision.collide()` — also clean. Bisected the crash instead
of continuing to guess: built a known-good minimal baseline (Sable + Create
only, verified stable under 60+ seconds of RCON-forced entity spawns), then
binary-searched the other ~80 mods back in. Isolated it to **The Porkchop
Express** alone.

Decompiled that jar too. `porkchop_express.mixins.json` registers
`hold.HoldSubLevelEntityCollisionMixin` in its **common** (`"mixins"`) list —
not the `"client"` list — but that class injects into
`SubLevelEntityCollision.collide()` (the exact method Sable calls on every
collision) and hard-casts to `AbstractClientPlayer` inside it. NeoForge
blocks the class reference at bytecode-verification time regardless of
whether the branch is reachable, so it throws on every collision check,
server-side, unconditionally. A genuine authoring bug in Porkchop Express —
a mixin that should have been client-scoped wasn't. Not a Sable bug, and not
specific to this pack's mod combination beyond "runs this one addon." Explains
cleanly why other Sable servers are unaffected: they're just not running it.

0.1.2 (pinned) is already the newest Modrinth release — no fix available to
take instead. Per its own description ("funny pigs and birds... as a Sable
addon"), flavor content rather than core pack function.

**Fix:** removed, same treatment as Linear Bearing.

### 2.4 Side-flag corrections: EMI, YACL, Controlify

All three were `side = "both"`; all three are client-only (recipe viewer,
config-screen library, controller support). The original Phase 9 side audit
(§6 of the ops doc) only checked that a `side` line *existed*, not that its
*value* was correct — these three had a value present but wrong, so
`grep -L '^side'` reported zero missing and the bug slipped through until the
server tried to construct their mod classes and hit the same
`RuntimeDistCleaner` wall as above.

**Fix:** `side = "client"` on all three.

---

## 3. Infrastructure decisions and corrections

### 3.1 `PACKWIZ_URL` tracks `main`, not a `release` branch

The brief's own recommendation was a dedicated `release` branch, fast-forwarded
deliberately, specifically to avoid every push becoming a live update. William's
call: clients already pull from `main`, so the server should match what's
actually in use rather than what the brief assumed. Consequence, recorded in
`server/README.md` so it isn't rediscovered as a bug: **every push to `main`
changes what the container installs on its next restart.** There is no
separate freeze point; freeze discipline (never bump a pinned version, never
add an unlisted mod) has to hold on `main` itself now.

Practical corollary hit repeatedly this phase: `raw.githubusercontent.com`
caches for ~300 seconds behind Fastly. Push, then wait, then restart — an
immediate restart after a push can silently deploy the previous version.

### 3.2 Volume permissions — `mc-world` needs a one-time `chown`

First real boot failed with `AccessDeniedException: ./world/session.lock`.
The `mc-world` named volume is created by Docker with `root:root` ownership;
the itzg image's own UID-fixup applies to `/data` but does not propagate into
a separately-mounted nested volume (`mc-world:/data/world`). One-time fix:
`docker run --rm -v aerophys_mc-world:/world alpine chown 1000:1000 /world`.
Not needed again after the volume exists with correct ownership.

### 3.3 Restore procedure — the brief's version doesn't work against this image

Written up in full in `server/README.md`; summary here because it's a
significant finding. Three problems, found by actually running the documented
procedure rather than assuming it:

1. The restore binary is `restore-tar-backup`, not the generic
   `restore-backup` the brief names.
2. `restore-tar-backup`'s "already restored" check is
   `ls "$SRC_DIR" | wc -l == 0`, and `SRC_DIR` defaults to `/data` — the whole
   thing, not `/data/world`. Because `mc-world` is nested inside `mc-data` by
   design (shadowing by path depth), `ls /data` always shows a `world` entry
   even when that subtree is empty. The check can never pass through the
   documented flow.
3. The `backup` service's volumes are mounted `:ro`, correct for taking
   backups but incompatible with restore's write requirement.

**What actually works, verified end-to-end:** wipe both `mc-data` and
`mc-world` (mc-data is disposable by design — packwiz + the NeoForge
installer rebuild it from scratch), extract only `world/` from the backup
tarball directly into the `mc-world` volume, then start `mc` and let it do a
full reinstall. Confirmed for real: placed a marker entity, backed up, wiped
both volumes, restored, booted, and confirmed via RCON (`data get entity
@e[name=restore-test-marker]`) that it survived — then William independently
confirmed by joining and playing on the restored world.

### 3.4 Distant Horizons — GUI label doesn't match the config key

The brief's "Distance Generator Mode = Full" doesn't appear as a literal
option anywhere in the generated `DistantHorizons.toml`. The four enum values
are `PRE_EXISTING_ONLY`, `SURFACE`, `FEATURES`, `INTERNAL_SERVER`. Read the
description rather than guessing: `INTERNAL_SERVER` — *"the most compatible
and will generate structures correctly... unlike other modes this option DOES
save generated chunks to Minecraft's region files"* — is unambiguously what
"Full" means in the brief's language. Set via `/dh config generation.mode
INTERNAL_SERVER`-equivalent edit to the generated config file (never shipped
from the repo — standing rule 5). Confirmed live via `/dh config
generation.mode` → `INTERNAL_SERVER`, `/dh config generation.enable` →
`true`.

LOD database path, recorded for the backup `EXCLUDES` list (already correct
in `docker-compose.yml`): `world/data/DistantHorizons.sqlite` (plus
per-dimension copies under `DIM-1`/`DIM1` for nether/end, which stay ignored
per config).

### 3.5 `/dh pregen` minimum radius is 32, not 16

The ops doc's own example (`/dh pregen start overworld 0 0 16`) fails:
*"Integer must not be less than 32, found 16."* Ran the validation pregen at
radius 32 instead. Confirmed real chunk data (not just LODs) written to
`world/region` — 27 region files, 29 MB — plus a 58 MB LOD database. Both
prove `INTERNAL_SERVER` mode is doing what it claims.

Extrapolated area-wise to the real production radius (160 = 5× radius = 25×
area): roughly **2.2 GB**. Worth sanity-checking against the eventual
production host's disk before Phase 11 commits to the real run — this phase
deliberately did not run the full radius-160 pregen, since this world is a
scratch world slated for deletion at Phase 11 (§1 of the original ops doc).

---

## 4. What this phase did *not* do

Explicitly out of scope, or requiring hands-on testing this session couldn't
do:

- The full §11 gate checklist from `phase-9-server-ops.md` — several items
  need a human at a real client: Shtreimel in-game command tests
  (`freeze`/`archive`/`audit`), a second client confirming DH's real-time LOD
  push over 300+ blocks, the Sable CleanUp unloaded-body question.
- Simple Voice Chat two-machine test — needs two humans on two machines.
- The Lithium compatibility test (§10 of the ops doc) — separate protocol,
  not attempted.
- Migration to the Latitude 5400 — next phase, after this passes here.
- Any real-world pregen or Phase 11 world generation.
- Tuning anything for performance — Phase 9.5 owns limits and caps.

**Per the brief: this session does not tag `phase-9-pass`.** Tags are applied
by William after running the gate by hand.

---

## 5. Records updated on this pass

- **`docs/exceptions-register.md`** — created (didn't exist). One row: Create:
  High Seas.
- **`manual/README.md`** — created, `.gitignore` corrected from `manual/`
  (blocks everything) to `manual/*` + `!manual/README.md` so this file can
  actually be tracked.
- **`docs/lockfile.md`** — still does not exist. Referenced by multiple prior
  phases (`docs/phase-0.5-dev-environment.md` §—, carried forward since Phase
  2) as a "Now" item that has never been created. Out of scope for this
  phase's brief; flagged here so it isn't lost again.
- **`docs/standing-rules.md`** — still does not exist, for the same reason.
  The four additions the original ops doc §14 wanted written there (image
  pinning, side-audit-is-a-release-step, no automatic restarts, DH generation
  stays on both sides) are true and enforced in this phase's work, just not
  captured in a file that doesn't exist yet.
- **`server/`** — `docker-compose.yml`, `.env.example`, `README.md` all
  committed. `.env` and `rcon_password` gitignored, created on this machine,
  never committed.

---

## 6. Carried forward

| Item | Owning phase |
|---|---|
| `docs/lockfile.md` and `docs/exceptions-register.md` schema — create `lockfile.md`, keep extending the register | Overdue since Phase 2, still open |
| `docs/standing-rules.md` — create it; several phases' worth of rules are implicitly enforced but not written down | Overdue since Phase 0.5, still open |
| Full §11 gate checklist (Shtreimel commands, second-client DH test, Sable CleanUp question) | This phase, gate — run by William |
| Lithium compatibility test | Phase 8 carry-forward, still open |
| Real Phase 11 pregen at radius 160, on the real (non-scratch) world | Phase 11 |
| Migration to the Latitude 5400 | Next, after this gate passes |
| Whether the `main`-branch-as-live-source decision needs revisiting once friends are on the whitelist for real | Phase 12 candidate |

---

## 7. Change log

| Date | Change | Reason |
|---|---|---|
| 29 Aug 2026 | `docker-compose.yml`, `.env.example`, `README.md` added under `server/` | This phase's actual deliverable |
| 29 Aug 2026 | Create: High Seas moved to Tier C manual exception | CurseForge blocks third-party API distribution; blocks headless install |
| 29 Aug 2026 | Create: Linear Bearing removed | Hard-crashes dedicated servers, current release, no fix available |
| 29 Aug 2026 | Side flags fixed: EMI, YACL, Controlify → `client` | Were `both`; crash the server on mod construction |
| 29 Aug 2026 | The Porkchop Express removed | Root-caused via decompilation: common-scoped mixin references a client-only class inside Sable's own collision path |
| 29 Aug 2026 | Distant Horizons server config set: `generation.mode = INTERNAL_SERVER`, `generation.enable = true` | Matches the brief's "Full" mode; GUI label doesn't match the config enum name |
| 29 Aug 2026 | Backup/restore verified end-to-end; documented procedure corrected in `server/README.md` | The brief's `restore-backup` procedure doesn't work against the real `itzg/mc-backup:2026.8.2` image |
| 29 Aug 2026 | Validation pregen run at radius 32 (32 is the enforced minimum) | Confirms real chunk + LOD generation; gives disk-cost numbers for Phase 11 |
