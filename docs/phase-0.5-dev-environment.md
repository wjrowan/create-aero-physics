# Phase 0.5 — Dev Environment

**Pack:** Create Aeronautics Physics Server
**Status:** Proposed — awaiting critique
**Date:** 11 August 2026
**Adds mod files:** No. No validation gate, but there is a setup check at the end.

> Purpose: build the machine that every later phase is validated on. No mods are
> chosen here. If this phase is done properly, a bad Phase 3 is one `git revert`
> instead of an archaeology dig.

---

## 1. Tooling decision — packwiz

**Verdict: adopt.** Verified 11 August 2026, not asserted from memory.

| Requirement from the spec | packwiz status |
|---|---|
| Text-based, git-native | Yes — TOML metadata files, one per mod |
| Pins versions and hashes | Yes — `index.toml` carries per-file hashes |
| Supports Modrinth | Yes — `packwiz mr add` |
| Supports CurseForge | Yes — `packwiz cf add` |
| Supports arbitrary URLs (**Tier B**) | Yes — `packwiz url add` |
| Exports a client pack | Yes — `.mrpack` and CurseForge format |
| NeoForge support | Yes — `--neoforge-version` / `--neoforge-latest` |
| Actively maintained | Yes — commits through late 2025 into 2026 |

`packwiz url add` is the important one. It is what makes **Tier B GitHub
releases** work regardless of what the export format allows, and Phases 2 and 3
will almost certainly need it.

### Installation gotcha

packwiz has **no tagged releases**. You get it one of two ways:

1. `go install github.com/packwiz/packwiz@latest` — needs Go installed
   (`sudo zypper install go` on Tumbleweed). Recommended.
2. Prebuilt binaries from the repository's GitHub Actions artifacts. Workable
   but awkward, and the artifact UI is unpleasant.

### KNOWN BUG — check this first

packwiz had a defect where **Minecraft 1.21.1 resolved to NeoForge builds
intended for 1.21.10**, because the version strings compare wrong. Fixed
upstream, but:

- Install a **recent** packwiz build, not one sitting in a distro package.
- After `packwiz init`, **open `pack.toml` and confirm the NeoForge version
  reads `21.1.x`, not `21.10.x`.**

This would have been a very confusing Phase 1 crash.

### Unconfirmed

I could not confirm the exact current NeoForge **21.1.x** patch number. Take
whatever `--neoforge-latest` resolves to for 1.21.1, then **write that exact
number into the lockfile immediately** — from that moment the loader version is
frozen like any other pinned file.

---

## 2. Dev instance

| Item | Value |
|---|---|
| Launcher | Prism Launcher (same as production clients — deliberate) |
| Instance name | `physics-dev` |
| Minecraft | 1.21.1 |
| Loader | NeoForge 21.1.x (pinned at init) |
| Java | **21** — required by 1.21.1 |
| Heap | `-Xms2G -Xmx8G` |

**Keep the JVM flags boring for now.** No GC tuning, no aggressive flags, no
optimisation arguments during Phases 1–8. Every extra flag is another variable
when attributing a crash. Tuning happens at Phase 9, on the server, where it
actually matters.

Low `-Xms` on purpose: it makes it obvious when something is genuinely holding
memory instead of the heap simply having been pre-allocated.

**This instance is disposable.** It gets deleted and rebuilt from the repo
whenever that's easier than debugging it. Nothing of value lives here — see the
world policy: every world in Phases 1–11 is scratch.

---

## 3. Repository layout

```
create-aero-physics/
├─ pack/                        # packwiz root — the manifest
│  ├─ pack.toml
│  ├─ index.toml                # the real lockfile: paths + hashes
│  ├─ mods/                     # one .pw.toml per mod, no jars
│  ├─ config/                   # authored configs — ship with the pack
│  ├─ kubejs/                   # empty until it isn't (last resort)
│  └─ datapacks/
├─ docs/
│  ├─ phase-0-constraints-sheet.md
│  ├─ phase-0.5-dev-environment.md
│  ├─ lockfile.md               # human-readable summary
│  ├─ exceptions-register.md
│  ├─ keymap.md                 # starts empty, filled from Phase 1 flags
│  └─ changelog.md
├─ server/                      # Phase 9
│  └─ docker-compose.yml
├─ manual/                      # Tier C jars, shaders — GITIGNORED
├─ .gitignore
├─ .gitattributes
└─ README.md
```

`docs/keymap.md` is not in the original spec. It's there because the keybind
flags start arriving in Phase 1 and the spec explicitly warns that keybind
decisions accumulate silently and become a Phase 7 archaeology project. A file
that collects them as they arrive is the cheapest possible fix.

### `.gitignore`

```gitignore
# No jars, ever — distribution principle
*.jar

# Tier C manual folder — contents recorded in the exceptions register
manual/

# Build output
pack/*.mrpack
pack/*.zip
.packwiz-cache/

# Worlds and saves belong in backups, not version control
saves/
world/
world_nether/
world_the_end/

# Local instance noise
logs/
crash-reports/
*.log
```

### `.gitattributes`

```
* -text
```

**Not optional.** On Windows, git's line-ending conversion rewrites files on
checkout, which changes their hashes, which makes packwiz reject every affected
file. Your build machine is Linux, but the production host is Windows and this
repo will eventually be cloned there. Set it now, before there's history to
rewrite.

---

## 4. Initialising

```bash
mkdir -p create-aero-physics/pack && cd create-aero-physics
git init
# add .gitignore and .gitattributes first, before any other commit

cd pack
packwiz init \
  --name "Create Aeronautics Physics Server" \
  --author "<you>" \
  --version 0.1.0 \
  --mc-version 1.21.1 \
  --modloader neoforge

# NOW: open pack.toml. Confirm neoforge = "21.1.x" and NOT "21.10.x".
```

Then create `docs/lockfile.md` and `docs/exceptions-register.md` as empty
templates (section 6), and commit.

```bash
git add -A
git commit -m "Phase 0.5: dev environment, empty manifest, NeoForge 21.1.x pinned"
git tag phase-0.5
```

---

## 5. The per-phase loop

This is the part that solves the stated process problem. Same six steps every
time, no improvisation.

```bash
# 1. Branch
git checkout -b phase-N

# 2. Add the phase's mods
cd pack
packwiz mr add <modrinth-slug>          # Tier A — Modrinth
packwiz cf add <curseforge-slug>        # Tier A — CurseForge
packwiz url add <name> <https://...>    # Tier B — GitHub release
packwiz refresh                         # rebuild index + hashes

# 3. Serve the pack locally
packwiz serve                           # built-in HTTP server, localhost:8080

# 4. Install into the dev instance
#    Prism → Edit Instance → Settings → Custom Commands → Pre-launch command:
#    "$INST_JAVA" -jar packwiz-installer-bootstrap.jar http://localhost:8080/pack.toml
#    (packwiz-installer-bootstrap.jar goes in the instance's minecraft/ folder)

# 5. Launch. Run the validation gate for that phase.

# 6. On pass:
git add -A
git commit -m "Phase N: <what went in>"
git tag phase-N-pass
#    ...and update docs/lockfile.md in the same commit.
```

**One commit per phase.** A bad phase is one `git revert`. A phase that half
works gets its own commit anyway, with the failure recorded in the changelog —
never leave the tree in a state that doesn't match what's installed.

`packwiz serve` matters more than it looks. It means the dev loop uses the
**exact same install path** your friends will use in production, so the
distribution mechanism is being tested continuously from Phase 1 rather than
discovered to be broken at Phase 12.

---

## 6. Lockfile and exceptions register

### `docs/lockfile.md`

Do **not** hand-maintain hashes. `pack/index.toml` already carries them and
packwiz keeps them correct. This file is the human-readable view — the thing you
read when debugging at 1am.

```markdown
# Lockfile

| Mod | Tier | Source | Version | Side | Phase | Risk | Cut order |
|---|---|---|---|---|---|---|---|
| NeoForge | — | neoforged.net | 21.1.x | both | 0.5 | LOCKED | — |
```

### `docs/exceptions-register.md`

Empty, and the goal is for it to stay that way.

```markdown
# Tier C Exceptions Register

Every row here is a manual step repeated on every install and every update,
for you and for every friend. Keep this table short.

| Mod | Version | Original source | SHA256 | Granted | Reason | Archived at | Re-check |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |
```

The `Re-check` column exists because of the standing instruction that this
folder shrinks over time: if a Tier C mod later appears on Modrinth or
CurseForge, it migrates out of `manual/` and into the manifest.

---

## 7. Diagnostics — where to look, every time

Prism: **right-click instance → Folder** opens the instance directory. Inside:

| File | What it tells you |
|---|---|
| `minecraft/logs/latest.log` | First stop, always. Mod loading, mixin failures, missing registries. |
| `minecraft/logs/debug.log` | Fuller trace. Where the real cause usually is when `latest.log` is vague. |
| `minecraft/crash-reports/` | Hard crashes, with the mod list appended at the bottom. |
| `minecraft/mods/` | What packwiz actually installed. Compare against `index.toml` when something's missing. |
| Prism's **Logs** button | Launcher-side failures — Java version, arguments, pre-launch command errors. |

**The four things to grep for at every gate**, per the spec's definition of
validation:

```bash
grep -iE "missing registry|registry entry" minecraft/logs/latest.log
grep -iE "duplicate mod|already loaded" minecraft/logs/latest.log
grep -iE "missing dependenc|requires" minecraft/logs/latest.log
grep -iE "mixin apply failed|mixin.*error" minecraft/logs/latest.log
```

Save that as a script now (`check.sh`) and run it after every phase. The point is
that the check is identical every time, so a new line in the output means
something actually changed.

The mod count NeoForge loaded is printed near the top of `latest.log` at
startup — a quick sanity check that the number matches what you expect from the
manifest.

---

## 8. Setup check

Phase 0.5 adds no mod files, so there is no formal validation gate. But do
confirm the machine works before Phase 1 lands mods on it:

- [ ] packwiz installed, `packwiz --version` runs
- [ ] `pack.toml` reads NeoForge **21.1.x**, not 21.10.x
- [ ] Prism instance `physics-dev` launches to the main menu on NeoForge, no mods
- [ ] A scratch creative world generates and loads
- [ ] `packwiz serve` + the pre-launch command runs without error (it will
      install nothing — that's the expected result)
- [ ] `git log` shows one commit, `phase-0.5` tagged
- [ ] `check.sh` runs and returns nothing

If the empty pack doesn't launch cleanly, Phase 1 will be debugging two problems
at once.

---

## 9. Deferred from this phase

| Item | Owning phase |
|---|---|
| Where `pack.toml` is hosted for friends (GitHub Pages, raw URL, other) | Phase 12 |
| Whether friends get `.mrpack` import or `packwiz-installer` auto-update | Phase 12 |
| Prism's enforcement of `.mrpack` download domains | Phase 12 |
| JVM flags and GC tuning | Phase 9 |
| Second Prism instance for clean-import testing | Phase 11 |

---

## 10. Change log

| Date | Change | Reason |
|---|---|---|
| 11 Aug 2026 | Phase 0.5 drafted | packwiz verified; awaiting critique |
