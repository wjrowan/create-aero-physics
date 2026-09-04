# Tier C Exceptions Register

Every row here is a manual step repeated on every install and every update,
for you and for every friend. Keep this table short.

| Mod | Version | Original source | SHA256 | Granted | Reason | Archived at | Re-check |
|---|---|---|---|---|---|---|---|
| Create: High Seas [Check Description] | 0.1.3 | CurseForge project 1539377, file 8291630 | 8a5b702f833ffb00953801c828588549ead19de761e9280a02cf7213b8bed3dd | 29 Aug 2026 | Deprecated, All Rights Reserved, and excluded from CurseForge's third-party distribution API — packwiz-installer cannot resolve or download it, on the server (headless, no TTY to prompt) or on a fresh client install. Flagged as a known exception at Phase 2 (`docs/phase-2-complete.md` §3) but never archived until the Phase 9 server build hit it. | `manual/highseas-0.1.3.jar` | If a working, redistributable substitute appears on Modrinth or CurseForge, migrate out of `manual/` and back into the manifest. |

The `Re-check` column exists because of the standing instruction that this
folder shrinks over time: if a Tier C mod later appears on Modrinth or
CurseForge, it migrates out of `manual/` and into the manifest.

**Operational note for every install, client or server:** `create-high-seas`
is no longer in `pack/mods/`. Copy `manual/highseas-0.1.3.jar` into the
instance's `mods/` folder by hand — packwiz will not do this for you.
