# Handoff: make pack server-configs reach the live world

**For:** the agent/operator working on the machine that runs `aerophys-mc`.
**Written by:** the agent working on the pack repo, who made the change but
cannot reach the server.

This is self-contained. You do not need the conversation it came from.

---

## 1. The problem you are fixing

NeoForge configs come in three types, and the type decides where the file
lives:

| Type | Lives at | Reached by packwiz? |
|---|---|---|
| CLIENT | `config/<mod>-client.toml` | yes |
| COMMON | `config/<mod>-common.toml` | yes |
| **SERVER** | **`<world>/serverconfig/<mod>-server.toml`** | **no** |

SERVER configs are **per world**. `defaultconfigs/<mod>-server.toml` is only a
seed, and NeoForge copies it **when a world is created** — never again. The
relevant code is `ConfigTracker.loadDefaultServerConfigs` →
`createDefaultConfig`, which is a copy-if-missing.

Consequence: our world already exists, so every SERVER config the pack ships
has been silently ignored. Two of them matter right now:

- `fluidlogistics-server.toml` — disables the Infinite Fluid Tank
- `aero_player_tilt-server.toml` — magnetic boots / tilt permissions

## 2. The fix that is already in the repo

`server/docker-compose.yml` now sets three environment variables:

```yaml
COPY_CONFIG_SRC: "/data/defaultconfigs"
COPY_CONFIG_DEST: "/data/world/serverconfig"
SYNC_SKIP_NEWER_IN_DESTINATION: "false"
```

Why this works, so you can check the reasoning rather than trust it:

- The image syncs `COPY_CONFIG_SRC` → `COPY_CONFIG_DEST` on **every** start,
  in `scripts/start-setupMounts`. That sync is unconditional — unlike the
  mods and plugins syncs, which are wrapped in `if usesMods` / `if usesPlugins`.
- `scripts/start-setupModpack` runs the packwiz installer at line ~40 and
  only then `exec`s `start-setupMounts` at line ~400. So by sync time,
  packwiz has already written `/data/defaultconfigs` from `PACKWIZ_URL`.
  The pack stays the single source of truth; no host checkout is involved.
- `SYNC_SKIP_NEWER_IN_DESTINATION` defaults to **true**, which passes
  `--skip-newer-in-destination`. NeoForge rewrites `world/serverconfig` on
  shutdown, so the destination is **always** newer. Left at the default,
  every file is skipped and nothing happens. `false` is the whole fix.

## 3. Before you touch anything

**Blocks are NOT being unregistered.** This was checked against the jars:
`CDPBlocks` / `CDPBlockEntities` (Create: Dragons Plus) and `AllBlocks`
(Create: FluidLogistic) never consult their feature configs. The toggles gate
recipes and creative-tab visibility only. Blocks already placed in the world
keep working. You are not about to eat someone's build.

**Take a backup anyway**, because this is a restart of a production world:

```bash
cd ~/Source/create-aero-physics/server
docker compose exec backup backup now
```

## 4. Apply it

```bash
cd ~/Source/create-aero-physics
git pull
```

Confirm the change actually arrived before restarting:

```bash
grep -E "COPY_CONFIG_SRC|COPY_CONFIG_DEST|SYNC_SKIP_NEWER_IN_DESTINATION" \
  server/docker-compose.yml
```

You want all three lines. If they are missing, the push has not landed —
stop and report back rather than hand-editing the file.

Then restart. **`stop` can take up to five minutes and must not be
interrupted** — the world is mid-save and `stop_grace_period` is 5m:

```bash
cd server
./stop.sh
./start.sh
```

## 5. Verify — and "the container started" is not verification

**a. The sync ran.**

```bash
docker compose logs mc | grep "Copying any configs"
```

Expect: `Copying any configs from /data/defaultconfigs to /data/world/serverconfig`

**b. The files actually landed in the world.**

```bash
docker compose exec mc ls -la /data/world/serverconfig/
docker compose exec mc grep infiniteFluidTankEnabled \
  /data/world/serverconfig/fluidlogistics-server.toml
```

Expect `infiniteFluidTankEnabled = false`. If the file is absent, see §6.

**c. In game.** Join and check, in a recipe viewer:

- **Infinite Fluid Tank** — should not be craftable or listed
- **Fluid Hatch (Create: Dragons Plus)** — should be gone; the
  Create: FluidLogistic one stays
- **Experience Hatch** — should still have a recipe, now made by applying an
  Experience Block to the *FluidLogistic* Fluid Hatch. If this one has no
  recipe, say so — it means the datapack override did not load.

## 6. The one thing likely to go wrong

The config branch of `start-setupMounts` does **not** `mkdir -p` its
destination, unlike the plugins branch. If `/data/world/serverconfig` does
not exist, the sync can fail. One-off fix, then restart:

```bash
docker compose exec mc mkdir -p /data/world/serverconfig
```

If the log shows a sync error mentioning a missing path, that is this.

## 7. Rollback

Low-risk, but if you need it: remove the three env vars and restart. The
files already copied into `world/serverconfig/` stay — delete them and let
NeoForge regenerate defaults if you want the previous state exactly:

```bash
docker compose exec mc rm /data/world/serverconfig/fluidlogistics-server.toml
```

## 8. Standing consequence — tell the humans

From now on, **server config edits made on the server are discarded on the
next restart.** The pack overwrites them every start. That is the intended
behaviour, and it is a change from how this used to work.

To change a SERVER config from now on: edit `pack/defaultconfigs/<file>` in
the repo, `packwiz refresh` in `pack/`, push, restart the server.

Note `PACKWIZ_URL` points at `main` — so every push to `main` changes what
this container installs on its next restart. That is pre-existing and
documented in `server/README.md`, but it applies to these configs too now.

## 9. Report back

- The `Copying any configs` log line, or its absence
- Contents of `/data/world/serverconfig/`
- Whether the three in-game checks in §5c passed
