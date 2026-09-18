# Stage F — World Generation & Pregeneration Report

**Date:** 2026-09-04
**Operator:** Claude Code (unattended overnight run, approved step-by-step by William)

## Seed

**`1289279188466871405`**

SEED input was `RANDOM`; this is the value the server actually picked, captured via RCON `seed` immediately after world creation and re-confirmed multiple times through the night.

## Phase 1 — Pre-flight findings

- Git: branch `main`, up to date with origin. Working tree had 3 untracked files (`pack/config/ftbchunks-world.snbt`, `pack/configureddefaults/config/ftbchunks-world.snbt`, `pack/configureddefaults/inventoryprofilesnext/inventoryprofiles.json`) — inspected (no secrets), committed and pushed as `525718d` per your instruction.
- Manifest: 78 mods, all with explicit `side` (60 `both`, 18 `client`, 0 `server`-only — flagged as an observation, not acted on).
- `the_nether.json` already had the correct values (`min_y=0`, `height=384`, `logical_height=256`, `coordinate_scale=1.0`) — the pre-briefed Nether-height fault (Phase 1.5) was **not present**, so no fix was needed there.
- World border function sets 5120 in Overworld, Nether, and End.
- `aerophys.deaths` scoreboard objective (criterion `deathCount`) **does not exist** anywhere in the datapack — only `aerophys.init` does. Flagged; you said not to worry about it, so it was left alone.
- 8 structure sets present under `worldgen/structure_set/` (villages, pillager outposts, ruined portals, desert pyramids, igloos, jungle temples, swamp huts, woodland mansions, nether complexes).
- `ftbchunks-world.snbt` confirmed present with `disable_protection: true`.
- `server/.env` keys: `TZ`, `NEOFORGE_VERSION`, `PACKWIZ_URL`, `HEAP`, `MEM_LIMIT`, `CPU_LIMIT`, `JVM_XX_OPTS`, `VIEW_DISTANCE`, `SIMULATION_DISTANCE`, `BACKUP_DIR`. RCON auth and `LEVEL`/`LEVEL_TYPE` are set in `docker-compose.yml` instead (`LEVEL: "world"`, RCON via Docker secret file, not a plaintext env var).
- Disk: 347GB free of 441GB at the start — comfortable.

## Phase 2 — Destroy and regenerate

- `docker compose down` (no `-v`), then `aerophys_mc-data` and `aerophys_mc-world` removed **by explicit name only**, after your direct confirmation ("yup go") since the auto-mode safety classifier correctly flagged the volume deletion as irreversible.
- World volume recreated and chowned to `1000:1000`.
- `LEVEL: "world"` confirmed hardcoded in `docker-compose.yml`; no `SEED` env var existed, left unset per your choice of `RANDOM`.
- First boot took a full pack install. Two transient `502 Bad Gateway` errors from `maven.neoforged.net` during NeoForge install caused two automatic container restarts (`restart: unless-stopped` policy) before the third attempt succeeded — self-healed, not something I intervened on.
- After boot, confirmed `/data/world/level.dat` exists and `/data/world` is a distinct mount from `/data` (different device in `df`) — the level-name/mount trap did not occur.

### Boot log error-signature check
- `RuntimeDistCleaner`/`invalid dist` for `ClientLevel`: 12 incidents (24 log lines, 2 per incident), all clustered in a ~0.3s window during Mixin's config scan, alongside other soft-dependency mixin probe messages for unrelated mods (Farmer's Delight, Supplementaries, Lithium). Investigated: restart count was fully explained by the NeoForge 502s (unrelated), no `/data/crash-reports/` directory ever appeared, and the server stayed healthy for hours afterward. Concluded this is benign Mixin scan noise, not the wrong-sided-mod crash pattern you'd seen before. This exact same pattern (same count) recurred identically on the later restart, supporting that conclusion.
- No `missing.*registry`, `duplicate mod`, `Mixin apply failed`, or `overwrite conflict` hits — zero matches, both boots.
- Packwiz correctly skipped client-only mods server-side (Complementary Shaders - Reimagined, 3D Skin Layers, Chat Heads).

## Phase 3 — Pre-pregen verification

- **World border:** 5120 confirmed live in Overworld, Nether, and End via RCON.
- **Nether height:** confirmed live, not just in the JSON — force-loaded chunk (0,0) in the Nether and tested block placement: Y=300 succeeded (impossible under vanilla's 256 cap), Y=380 succeeded, Y=390 correctly failed ("out of this world"), exactly matching the intended 0–384 range. Test blocks and forceload cleaned up afterward.
- **Scoreboard:** still only `aerophys.init`, `aerophys.deaths` absent (as above, not actioned).
- **⚠️ Distant Horizons `generation.mode` was `FEATURES`, not the expected `INTERNAL_SERVER`.** Root cause: `pack/configureddefaults/config/DistantHorizons.toml` (the NeoForge "default configs" seed file, confirmed byte-identical to the live `/data/config/DistantHorizons.toml` it seeded) shipped with `distantGeneratorMode = "FEATURES"`. Per your explicit instruction, fixed and committed to `main` (`cde51f5`), and applied live via `/dh config generation.mode INTERNAL_SERVER` so the change took effect without a restart. This mattered a lot: `FEATURES` mode does not write real chunks to region files — only `INTERNAL_SERVER` does — so this had to be caught before pregen or the whole night would have produced LOD-only data with no real terrain.
- **⚠️ Whitelist was not empty.** `white-list=true` (enforced) but 4 players were listed (`TotallyTom`, `Gondorsbanejr`, `WinningWilliam`, `MajorMaxiMan`). You said to leave it as-is; not changed.
- **Spark TPS never worked over RCON.** `spark tps`, `spark profiler`, `spark tickmonitor` all returned completely empty responses (verified at the byte level), despite the mod loading cleanly with no errors and its background profiler starting normally per the boot log. You said this was a "later issue," not investigated further. No TPS readings exist anywhere in this report as a result — disk-usage and RCON responsiveness were used as rough proxies instead.

## Phase 4 — Pregeneration (two passes — see "The Distant Horizons database incident" below for why)

### Pass 1 — real chunk generation
DH LOD databases (`DistantHorizons.sqlite` + `-wal`/`-shm`) deleted in all three dimension folders before starting, per your instructions.

| Dimension | Radius | Started | Finished (console-confirmed) | Duration | Avg rate |
|---|---|---|---|---|---|
| Overworld | 160 chunks (2560 blocks, matching half the 5120 border) | 20:53:59 | ~21:33 | ~40 min | ~44 cps at completion |
| Nether | 160 chunks | 21:34:01 | 22:38:28 | ~64 min | ~26 cps steady |

DH threading raised for the unattended run (24 host cores, no CPU limit set): `threading.numberOfThreads` 4→8, `threading.threadRunTimeRatio` 0.5→1.0. Confirmed this persisted to the on-disk config, not just runtime memory.

### The Distant Horizons database incident
Deleting the LOD `.sqlite` files while the server was running (without a restart) turned out to be a real mistake on my part: Linux doesn't free a file's storage when it's unlinked while a process still holds it open. DH's Java process kept its original file handles and kept writing into now-invisible, zero-link orphaned inodes for the entire first pregen pass. Verified via `/proc/<pid>/fd/` — all 9 original file descriptors showed `(deleted)`, with real, growing byte counts (Overworld LOD data topped out ~453MB, Nether ~504MB before this was caught). This data would have been silently and permanently destroyed the moment the server process closed those handles at shutdown.

**What was and wasn't at risk:** the actual region files (real terrain — the entire point of the `INTERNAL_SERVER` fix) were completely unaffected; they're separate files that were never touched. Only the derived Distant Horizons LOD rendering cache was orphaned — recoverable by rebuilding, not the irreplaceable world data.

**Resolution, per your direction ("finish the pregen and then properly generate the lods"):** let the first pass's real chunk generation finish for both dimensions (confirmed via the authoritative server console message `[Rcon: Pregen is complete]`, not just the `/dh pregen status` command, which turned out to report ambiguous text like "Pregen is not running" right at completion in a way my monitoring script initially misread as failure — false alarms, not real problems, confirmed each time by checking the console log directly). Then:
1. Cleanly stopped the server via RCON `stop` — this triggered `restart: unless-stopped` to bring up a fresh container automatically (same volumes, no data loss), which closed the orphaned handles and let DH create real, linked `.sqlite` files on boot.
2. Verified `generation.mode=INTERNAL_SERVER` and the threading settings survived the restart (they're persisted to the on-disk config, confirmed).
3. Re-ran `dh pregen start` for both dimensions at the same radius/origin. Since real terrain already existed everywhere in that radius, this pass only had to load existing chunks and build LOD summaries — dramatically faster than generation.

### Pass 2 — LOD-only regeneration

| Dimension | Started (console) | Finished (console-confirmed) | Duration | Final DB size |
|---|---|---|---|---|
| Overworld | ~22:46 | 22:54:48 | ~9 min | 453 MB |
| Nether | ~22:59 | 23:06:10 | ~7 min | 549 MB |

Confirms the "should be much faster" expectation: chunk generation ran at 22–47 cps; LOD-only regeneration on already-generated terrain ran at 140–408 cps.

## Final chunk / data counts (both dimensions, after everything)

| Dimension | Region files | Region folder size | LOD database size |
|---|---|---|---|
| Overworld | 144 | 1.2 GB | 453 MB |
| Nether | 144 | 995 MB | 549 MB |

The End was not pregenerated (not requested) and has no region folder yet.

## Disk usage through the night

- Start: 347 GB free
- Lowest observed: 340 GB free (final check)
- Never came close to the 5 GB warning threshold at any point.

## TPS

Not available — see the spark/RCON issue in Phase 3. No numeric TPS readings exist for any point in this run. Server responsiveness (RCON round-trip, boot health checks) never indicated any problem.

## Whitelist

Left as you instructed: `white-list=true`, 4 players still listed (`TotallyTom`, `Gondorsbanejr`, `WinningWilliam`, `MajorMaxiMan`). No one joined overnight as far as I could tell from the logs.

## Tarball

**Path:** `/home/willi/aerophys-world-2026-09-04-seed1289279188466871405.tar.gz`
**Size:** 2.9 GB
**Verified:** readable via `tar tzf`, contains `world/level.dat`, `world/session.lock`, `world/level.dat_old`, `world/region/` (144 files), and `world/DIM-1/region/` (144 files).

The `aerophys_mc-world` volume was left in place, untouched, as instructed — nothing was deleted after packaging.

## Every error or anomaly hit tonight (including resolved ones)

1. Two transient `502 Bad Gateway` errors from `maven.neoforged.net` during the very first NeoForge install, causing two automatic container restarts before the third attempt succeeded. Self-resolved, not investigated further since it was clearly a remote/transient issue.
2. 12 recurring `RuntimeDistCleaner`/`invalid dist` mixin-scan log entries on every boot — investigated at length (restart-count cross-check, crash-report check, boot-log context), concluded benign. Flagged to you explicitly before proceeding, per your explicit historical concern about this exact signature.
3. `aerophys.deaths` scoreboard objective missing from the datapack — reported, not created (not authorized to fix).
4. Distant Horizons shipped with `generation.mode=FEATURES` instead of `INTERNAL_SERVER` — would have produced a night of LOD-only data with no real chunks. Fixed at your instruction, both in the pack source (committed/pushed) and live via RCON.
5. Whitelist not empty (4 players) despite enforcement being on — reported, left as-is per your instruction.
6. Spark TPS/profiler commands return completely empty RCON responses — never resolved, explicitly deferred by you as a "later issue."
7. **The LOD-database orphaning incident** (see above) — caused directly by my own cleanup method (deleting open files without a restart). Caught by investigating a size discrepancy you asked about ("is that only 160 chunks" led to checking file sizes, which led to finding the databases missing entirely). Fully resolved by restarting once real chunks were safely on disk and re-running a fast LOD-only pass for both dimensions.
8. My own monitoring script twice misreported a successful pregen completion as "stopped unexpectedly," because `/dh pregen status` returns ambiguous text ("Pregen is not running") right at completion that doesn't parse as either clearly-done or clearly-failed, and a follow-up check against the live console log was itself flaky under concurrent load. Both times, I verified the real outcome directly against the authoritative `[Rcon: Pregen is complete]` console message rather than trusting the script, and both pregens had in fact succeeded. This is a limitation of my monitoring approach, not of the pregen process itself — worth knowing if you ever rely on that script's own pass/fail verdict directly.

## Things I was unsure about and chose not to act on

- The 60/18/0 split of `both`/`client`/`server`-only mod sides (no server-only mods at all) — flagged as slightly unusual but not investigated further since nothing indicated it was actually wrong.
- Whether the spark RCON output issue is a config problem, a version incompatibility, or specific to this itzg image — did not investigate since you deferred it.
- Whether `aerophys.deaths` was intentionally never wired up or is a genuine gap in the datapack — reported the fact, made no judgment call on intent.
