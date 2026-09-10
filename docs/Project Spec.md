
/
Minecraft Modpack

Beta
Minecraft Modpack
I want to create a minecraft modpack for a server for me and my friends that contains create coasters simulated and create aeronautics and see the breadth of the create, create aeronautics addon mods to play with and decide on the experience I want while having to modpack still be stable.








Recents
Sodium iris distant chunks compatibility
just now
Phase 2 sable mods command list
5 hours ago
Packwise phase 1 setup
Phase 2 doc finalised: 16 mods, Sodium pinned, handoff block added
7 hours ago
Phase 1 location decision
2 days ago
Minecraft installation for Linux
3 days ago
Phase 0 foundation and constraints setup
4 days ago
Building a personalized modlist
4 days ago
Disabling portals with dimension stacks
5 days ago
Instructions
# Modpack Build Prompt — Create Aeronautics Physics Server > Paste this back to Claude to start the build. Also worth dropping into the > project instructions so it survives across conversations. --- ## Context I'm building a Minecraft modpack for a private server for me and my friends. Platform is locked: **MC 1.21.1 / NeoForge / Create 6.x**, because Create: Aeronautics and Create: Coasters Simulated only exist there. The theme is **physics-first**. Sable is the spine of this pack. I want physics to show up everywhere — not just in vehicles, but in emergent world interactions (blocks that detach into physics contraptions, trees that fall properly, contraptions that shear through terrain at speed). Within that theme I want real breadth across the Create and Sable addon ecosystem so we can evaluate what's fun and prune later. ## About me - Advanced modded MC player. I don't need mechanics explained. - I **want** a heavily modded experience and I knowingly accept alpha and early-access mods. Don't cut something purely because it's young — flag the risk and let me decide. - My actual pain point is *process*: I lose the thread when errors start, and I end up with an unmanageable list I can't debug. - So: stability comes from build discipline and a documented cut order, not from playing it safe on mod selection. ## Design philosophy This is a **builder's pack, not a survival challenge**. Create and physics contraptions are the *point*, not the reward for grinding toward them. ### Abundance through engineering - I want effectively infinite resources — but earned by *building the machine that produces them*, not by config handouts or creative mode. **The answer to a grind should be a machine, not a handout.** Automation is the intended answer to every scarcity problem. - Still genuine survival. Keep hunger, keep death, keep the world real. Just remove tedium. - Progression should gate *interesting* things, never *tedious* ones. - When in doubt, err toward abundance. I'd rather over-supply and prune. ### Scope: deep, not wide - **Create-centric with light supporting mods.** Create, Sable and the physics ecosystem are the pack. Supporting mods exist to serve them. - **Default to NO.** Every mod outside the core theme must justify itself against a specific problem I actually have. Breadth belongs in Phase 2 and Phase 3 — the physics and Create ecosystems — not in the pack at large. - No second tech tree. No magic tree. If a mod duplicates something Create already does, it needs a strong argument. ### Comfort mods: base only, no addon chains I like mods such as Alex's Mobs, Supplementaries and MrCrayfish's Furniture. My known failure mode is that each of these has its own addon ecosystem, and following those chains is how packs become unmanageable. So: - **Base mods only. Addons of comfort mods are forbidden**, with no exceptions I don't explicitly grant. - **Hard cap: 5 comfort mods total** across the whole pack. They are chosen once, in Phase 6, and the list closes. - Each must be named on an allowlist with a one-line reason. If I ask for a sixth, make me trade one out rather than adding it. - Check each for conflict with the rest of the philosophy — e.g. a mob mod adds hostile mobs, which cuts against wanting a quiet world, and mobs from these packs are a known pathfinding problem on Sable sub-levels. ### Low friction - **Combat is a nuisance, not content.** I want the world quiet enough that I can build without interruption. Bias toward reducing mob pressure, not adding dungeons, bosses or raids. Anything that resembles an adventure pack is out of scope. - Because I don't want to *fight* for drops, mob and XP resources still matter — they should be **automated**, not fought for. ### Building: palettes, not furniture - **Minimal decoration mods.** Vanilla blocks plus Create's copycat system do the heavy lifting. Copycats mean I can texture almost anything, so huge block packs and furniture mods are mostly redundant weight. - Judge any aesthetic mod by whether it expands *palette and shape* usefully, not by how many blocks it adds. ### Block spam is a disqualifier I strongly dislike mods that add thousands of blocks that are just every variation of everything — every wood type times every shape times every colour. - **Block count is a cost, not a feature.** Treat a large block registry as a strike against a mod, not a selling point. - The damage is real, not aesthetic: it bloats the recipe viewer, buries useful items in search, slows loading, and makes creative tabs unusable. - **Prefer systems over variants.** Copycats, dyeing and painting mechanics give breadth from few registered blocks. A mod that adds one block with many states beats a mod that adds four hundred blocks. - When you propose anything decorative, tell me roughly how many blocks and items it registers, and whether it does it with variants or with a system. - This applies to Create addons too. A Create addon is not exempt because it says Create on it. --- ### Death: costs a trip, never your stuff Vanilla death is the worst of both worlds — you lose a lot, get frustrated, charge back into the cave, die again, and end up down half your inventory anyway. But full keep-inventory makes death meaningless and turns jumping off a building into a hunger reset. I want the middle. **Requirements:** - **The mechanism is open.** Gravestone, tombstone, a lootable corpse — I don't care which. Judge candidates on the requirements below, not on the form. If a corpse-style mod handles the hard cases more cleanly than a block-placing grave, take it. - **Nothing is ever scattered, and nothing ever despawns.** Whatever holds the items holds *everything*, permanently, until collected. - **The cost is the journey back.** Retrieval should take time and travel — that is the entire penalty, and it's enough. - Consider **keeping tools and armour on death** so the retrieval trip isn't attempted naked through the same hazard that killed me. The rest waits in the grave. - **Death must not be a shortcut.** If dying is a cheaper way to reset hunger or get home than walking, the design has failed. Propose a small non-item penalty — a brief debuff or similar — that makes death mildly unwelcome without making it punishing. Never solve this by taking items. - The grave must be **easy to find**: an automatic waypoint or coordinates in chat on death. Hunting for your own grave is exactly the tedium this pack rejects. ### Safety nets: prevent the death, don't just soften it I like forgiving systems — especially **void protection**, which catches a fall into the void and puts you back rather than killing you. In a pack about flying, falling off an airship at altitude is an ordinary Tuesday, and the void is the one place both you and your grave disappear for good. - Prioritise **prevention over recovery** for void and out-of-world deaths. This doesn't contradict "death costs a trip" — falling off a contraption is a physics accident, not a gameplay decision, and there's nothing to learn from losing an afternoon to it. - If Phase 4 lands on sky islands, this stops being a nicety and becomes core infrastructure. Weight it accordingly. - Look for the same forgiveness elsewhere it's cheap: deaths caused by contraption jank, sub-level unloading, or physics glitches shouldn't cost the same as walking into lava on purpose. **Pack-specific failure cases — check these explicitly, they're where items actually get lost:** - Dying **on a Sable sub-level**: does the grave place correctly, does it travel with the contraption, and what happens when that contraption is disassembled or unloaded? - Dying **over the void, deep ocean, or lava**, which is a live risk in a pack built around flying. A grave that falls into the void has failed at its one job. - Whether the mod has a **recovery command** so I can restore a lost grave if the above goes wrong anyway. Given one world and no resets, treat this as required rather than nice-to-have. - Who can open a grave — owner only, or anyone. Decide it deliberately for a friends' server rather than inheriting a default. ### Inventory: extend it, don't nest it **I dislike backpack mods.** Opening a second menu to reach a second inventory is friction I notice every single time. - Prefer mods that **extend the player inventory itself** — more rows, more slots, in the screen I already have open. - Also fine: **remote or "cloud" access** to a storage network from anywhere, so the answer to carrying capacity is a base I built rather than a bag I wear. That fits the pack's automation-first philosophy better than a container item does. - Rule out backpack-style container items unless nothing else covers the need, and tell me what I'm giving up if so. - Whatever we pick must not break when opened on a moving Sable contraption. ### Keybinds are curated, not accumulated Modded packs sprawl into unusable keymaps — every mod claims keys on install, half of them for menus I'll open twice a year, and conflicts surface silently. I don't want that, and I especially don't want to tell my friends to go and fix their own controls. - **The pack ships a keymap. Nobody configures anything.** Defaults are set by me, applied on first launch, and that's the end of it. - **Unbind by default.** A mod's keybind stays only if I'd realistically use it weekly. Rare functions get reached through a menu or an item, not a key. - **Vanilla bindings are untouched.** Muscle memory is worth more than any mod's preferred default. - **Group by function.** Create and physics controls belong in one coherent cluster, not scattered wherever each mod's author happened to put them. - Prefer **one key opening a radial or menu** over several keys doing several things. - Ship a **written keymap** in the install guide and the in-game guidebook, so nobody has to go hunting through the controls screen to find out what exists. **List the unbound functions too** — an unbound feature is an invisible feature, and the point is to reduce clutter, not to hide capability. - **Later updates need a keybind story.** First-launch defaults don't reach people who already launched, so any mod added in a post-launch update ships its keybind decision in the changelog as a line my friends can act on. ### Shaders are in scope I want the pack to look good, so shader support is a design goal, not an afterthought. - Aeronautics has **known visual issues with Iris**. Don't treat that as a veto and don't treat it as solved — find out what actually breaks and how bad it is. Do this as an **early spike during Phase 2**, not at Phase 8: if shaders fundamentally break physics contraption rendering, that changes what the pack is, and I'd rather know at the start. - Create's Flywheel rendering and shader pipelines have a history of friction. Confirm the current state on Create 6 rather than assuming either way. - Shaders interact with Distant Horizons, and that compatibility is version-specific. Treat the rendering stack as one decision, not three. - Per the distribution principle, **shader packs are not bundled**. Pick and document ones people can add themselves, and put them in the install guide. - Assume mixed hardware among my friends. The pack must run acceptably with shaders off. ## Distribution principle: references, not files **The pack is a list, not a bundle.** I am not moving jar files around. Nothing gets redistributed — no mod jars, no resource packs, no shaders, no libraries. - Every third-party asset is **referenced by link or project ID** and downloaded by the launcher from its official source. If I'm copying a file into a folder by hand, something has gone wrong. ### Source tiers - **Tier A — mod platforms** (Modrinth, CurseForge). The default. Use these whenever the mod exists there. - **Tier B — GitHub / GitLab releases.** Fully acceptable. A mod does **not** need to be on a mod platform. Release URLs are stable, versioned and hashable, which is all the pack needs. Verify in Phase 12 whether the chosen pack format restricts download domains — some formats allow only a whitelist, and it matters whether GitHub is on it. - **Tier C — Discord, Google Drive, personal sites.** Exception only, and I have to grant it explicitly. Never assume it. **When proposing a mod, state its tier.** If something I want is Tier C, tell me at proposal time, name the cost, and offer an alternative — then let me decide. ### Tier C exceptions If I grant one, it gets handled properly rather than informally: - Log it in an **exceptions register**: what it is, where it came from, exact version, file hash, why the exception was granted, and where the file is archived. - Be honest about what I'm buying. Discord CDN links carry signed, expiring parameters, so they can't be referenced at all — that mod has to be handed to every friend manually, every update, forever. Drive links can vanish without notice. - Keep an archived copy of the exact jar somewhere I control, because the original source may disappear. - Each exception adds a manual step to the install guide. Keep the count low enough that the guide stays one page. **The manual folder.** Anything that can't be referenced — Tier C jars, resource packs, shaders, odd files — goes in one designated folder that gets loaded alongside the manifest-built pack. - One folder, clearly named, for all of it. Not scattered per category. - **Gitignored.** The repo still contains no jars; the exceptions register records what's in there — name, version, hash, original source, date added — so the folder's contents are reconstructible even though the files aren't committed. - **The container needs these too.** It pulls the referenced pack automatically but can't fetch these, so mount the folder as a volume and treat it as part of the server's state. - Decide deliberately at Phase 12 whether these ship inside the exported pack (easy for my friends, but that *is* redistribution and may breach a licence) or as a separate one-time download. Flag the licensing on each. - **Recheck periodically.** If a Tier C mod later appears on a mod platform, migrate it out of the folder and into the manifest. This folder should shrink over time, never grow. - Keep it small on purpose — everything here is manual work repeated on every install and every update, for me and for everyone else. - No bundled resource packs or shaders. If we want one, it's referenced too, or it's a link in the install guide for people to add themselves. - **The only exception is content the pack itself authors:** configs, KubeJS scripts, and datapacks. These have no upstream to link to, so they live in the repo and ship with the pack. Keep them small and documented. - Consequence to respect in Phase 12: the pack format must support referenced downloads. Rule out anything that requires embedding files. ## Testing philosophy **I am not playtesting this pack.** This is a one-and-done build. Testing means **"does it crash"**, not "is it balanced" or "is it fun". - Validation is: the pack loads, the server boots, no missing registries, no duplicate-mod or dependency errors, and the headline features work when poked in creative mode. - I will not grind through progression to verify recipes. I will not evaluate pacing. Do not design phases that assume I played for hours between them. - **Consequence you must respect: there is no prune-after-play safety net.** Every mod has to earn its place by reasoning at selection time, because the pack I launch is the pack I keep. Be stricter up front than you would be if we were going to cut later. - **QUARANTINE now means exclude, not experiment.** Anything with a credible risk of save corruption or world-breaking behaviour is out. I accept alpha mods and jank; I do not accept losing the world. - Because validation is cheap, **make the phases big.** Don't ration mods across many small rounds — I'd rather do fewer, larger passes. ## Version freeze policy A constantly-changing pack creates incompatibilities that aren't worth the trouble. So the pack is **frozen by default**. - Maintain a **lockfile**: every mod with its exact file version and download link, updated as each phase closes. Versions are pinned from the moment they enter the pack. - These mods move fast — Coasters shipped two releases in two days. Do not silently propose a newer version of something already locked. - **Updates are deliberate, batched, and rare.** No rolling updates. - **Documented exception:** a fix for a crash or data-loss bug I am actually hitting. That gets taken, tested in isolation, and recorded in the change log with the reason. - Once the server world exists, any update must be assessed for whether it breaks existing builds — especially Sable contraptions already in the world. ## Scripting & recipe policy KubeJS is allowed, but I've been burned by it: it turns into days of testing and planning, and there's always one more workaround recipe. **It is a scalpel of last resort, never a design layer.** Follow this escalation ladder. Only move down a rung when the one above fails: 1. **Pick a different mod.** The cheapest fix to a bad recipe is not shipping the mod that has it. 2. **Mod config.** Most packs' recipe pain is a config toggle someone already wrote. 3. **A recipe-unification / tag-unification mod.** Most "random workaround recipe" problems are actually duplicate materials across mods — five copper ingots that don't interchange. Solving that once, globally, with tags removes a whole category of scripting before it starts. Propose a solution here early; it has the best effort-to-payoff ratio in the entire build. 4. **A plain datapack recipe override.** No scripting runtime, easy to delete. 5. **KubeJS.** Only when 1–4 genuinely fail. Rules when KubeJS is used: - **Reactive only.** Scripts fix a specific problem I actually hit in play. No speculative rebalancing, no progression rewrites, no economy design. - **Report-driven, batched.** I won't be playing enough to find recipe problems myself — they'll surface from my friends on the live server. Collect them into a list and fix the batch in one deliberate update. Never fix them one at a time as they arrive; that is the endless-testing failure mode. - **Small and self-contained.** A few lines each, one file, commented with what problem it solves so it can be deleted later without archaeology. - If a fix is getting complicated, that's a signal the mod choice was wrong. Say so and propose removing the mod instead. ## World policy - **One server world, generated once, never reset.** It is created at the very end, on the final frozen pack. - Every world used during Phases 1–11 is a **disposable scratch world**. Never build anything in a test world that I'd be upset to lose. - Do not let me start the real world before the Phase 11 gate passes, even if the pack looks finished. --- ## How I want you to work Work in **phases**. Do **one phase per response**, then stop and wait for my critique. Never jump ahead. Never revise an earlier phase's list unless I explicitly reopen it — if a later phase creates a conflict with a locked mod, raise it as a flag and let me decide. For every mod you propose, give me exactly this: | Field | Notes | |---|---| | Name | | | Source | Modrinth / CurseForge link — must be referenceable, see the distribution principle | | Version | exact 1.21.1 NeoForge build to pin | | Side | client / server / both | | Size | rough block/item count, if it's a content mod | | Role | one line — what job it does in *this* pack | | Risk tier | LOCKED / LOAD-BEARING / OPTIONAL / QUARANTINE | | Cut order | integer — the order I pull things when debugging | | Known conflicts | especially anything Sable / sub-level related | ### Rules - **Verify everything by searching.** Do not assert a mod has a 1.21.1 NeoForge build from memory. If you can't confirm it, say so. - Never fabricate a mod name or link. "There is likely a mod that does X, I couldn't confirm it" is a fine answer. - Phases can be large — validation is a crash check, not a play session. Group generously rather than dripping mods out over many rounds. - If a mod needs a companion compat patch, they're a single unit — never propose one without the other. - **Flag grind.** For any mod in any phase, call out anything that introduces repetitive manual labour, and propose the config, datapack, or recipe change that automates or removes it. - **Flag scope creep.** If you're proposing something outside the Create and physics core, say so explicitly and give me the one-line justification. - **Flag keybinds.** When a mod registers default keybinds, say how many and what they do, and recommend keep-or-unbind at that moment. Keybind decisions accumulate silently otherwise and become a Phase 7 archaeology project. - Tell me when you think I'm wrong. If a constraint I've set is hurting the pack, argue the case rather than quietly working around it. ### Stability at add-time, not after I expect some crashes — these are experimental mods and I've accepted that. What I won't accept is *more* than the jank inherently comes with. So don't defer all stability work to the integration phase: - **Every phase ends with a validation gate**, run in my **local dev instance** — single-player, creative, no server involved. Phases 1–8 never require a dedicated server; that only appears at Phase 9. I load the pack and confirm it starts clean before we move on, so a break is attributable to the handful of mods just added rather than to the whole pack. Say so explicitly at the end of each phase: "load and confirm before we continue." Phases that add no files (0, 0.5, 4) skip this. - **Check conflicts at add-time.** When a mod enters, name its known conflicts then — don't save them all for the Phase 10 matrix. The matrix is a final audit, not the first time we look. - **Flag subsystem overlap.** Most surprise crashes come from several mods patching the same thing: rendering, chunk loading, entity ticking, physics. When a proposal touches a subsystem another mod already patches, say so. - **Prefer the boring option among equals.** Where two mods do the same job, favour the one with a wider install base and more recent activity. Novelty is worth spending on the physics theme, not on utilities. --- ## Phases ### Phase 0 — Foundation & constraints Server specs, RAM budget, player count and my friends' hardware, tick-budget expectations, and shader appetite. Also settle, because these change real decisions downstream: - **Distribution:** which launcher my friends will use, and how comfortable they are with manual setup. This determines the pack format, so it can't wait for Phase 12. - **Hosting environment:** where the container runs now and where it might move later — home machine, VPS, NAS, rented host. Architecture matters, so ask. - **Recipe unification:** identify the tag-unification approach early, per the scripting policy above. This is a Phase 0 decision because it shapes every later recipe conversation. - **Programmability:** whether ComputerCraft-style vehicle control is in scope. **Output:** a locked constraints sheet everything else is checked against. Note: the worldgen direction question is deliberately deferred to Phase 4 — it needs research, not a snap answer. ### Phase 0.5 — Dev environment Set this up before any mods are chosen, because every later validation gate depends on it. Should be quick. - A **local dev instance** on my PC: launcher of choice, NeoForge 1.21.1, sane heap allocation. This is where the pack gets built and where every Phase 1–8 gate is run. Single-player and creative are enough — no dedicated server until Phase 9. - The **git repo**, initialised now rather than at Phase 12. Configs start mattering around Phase 5 and I don't want that work untracked. Phase 12 defines the release process; this is just the repo existing. - The **lockfile and exceptions register**, as empty files I start filling from Phase 1. - **A manifest-driven build, not manual jar wrangling.** The pack is defined by text files in the repo and built from them. This is how the lockfile, the reference-only rule and reproducibility all get satisfied by one mechanism instead of by hand. - Evaluate **packwiz** first — text-based, git-native, pins versions and hashes, supports Modrinth, CurseForge and arbitrary URLs, and exports a client pack. Confirm it's actively maintained and works for NeoForge 1.21.1 before we commit to it; recommend an alternative if not. - Define the **per-phase loop** concretely: add the phase's mods to the manifest, build into the dev instance, launch, confirm, commit. One commit per phase, so a bad phase is one revert rather than an archaeology dig. - **Tier C exceptions won't fit the manifest** — no referenceable URL. They live in the manual folder described in the distribution principle. Set that folder and its gitignore entry up now, alongside the exceptions register. - Tell me where the useful diagnostic files live — latest.log, crash reports, the mod list dump — so every later gate follows the same routine. **Two environments, don't confuse them:** the dev instance is mine, disposable, and rebuilt freely. The production environment — container, dedicated server, my friends' installs — is built at Phases 9 and 12 and validated at Phase 11. ### Phase 1 — Core physics stack (non-negotiable) Create, Sable, Create: Aeronautics, Create: Coasters Simulated, plus the mandatory compat and glue layer. This is the immovable base. ### Phase 2 — Physics breadth (the theme layer) The Sable ecosystem plus emergent-physics mods. **This is where breadth is welcome — go wide here.** Explicitly hunt for: - detached blocks becoming physics contraptions - tree and structure physics - contraptions cutting through terrain at speed - collision damage - sub-level tooling - cross-dimensional physics objects Highest-value and highest-risk phase. ### Phase 3 — Create breadth Create addons proper: trains, logistics, energy, economy, copycats, and the mechanics-expanding addons. Breadth for evaluation, flagged for later pruning. Prefer addons that **integrate with Create's systems** over ones that sit alongside it. Keep decoration-only addons to a minimum per the philosophy above. ### Phase 4 — Worldgen direction (decision phase) **Present options before mods.** I'm undecided, and this choice cascades into everything after it, so treat it as a fork in the road rather than a list. Give me a comparison of at least these directions: 1. **Enhanced vanilla** — better terrain, more dramatic landscapes, familiar rules. Safest, most compatible. 2. **Sky islands / archipelago** — thematically perfect for Aeronautics, since airships stop being a novelty and become the transport layer. Note that this fundamentally rewrites the resource economy. 3. **Extended vertical world / cubic-chunks-style** — huge build height and depth. Confirm what actually exists and is stable on 1.21.1 NeoForge before recommending; don't assume. 4. Anything else genuinely worth considering, including hybrids (e.g. normal terrain plus physics-enabled floating islands above it). For each: the gameplay experience it produces, how it interacts with Sable and Aeronautics, what it does to the resource economy, its performance cost, and its compatibility risk. **Then give me your recommendation and reasoning.** I'll pick, and only then do you propose the actual worldgen mod list. This choice is effectively permanent — one world, never reset — so treat it accordingly. ### Phase 5 — Resource economy & anti-grind Make abundance an engineering problem. Hunt for: bulk ore processing and multiplication, block and fluid generators (cobble, stone, lava, water), quarry and excavation systems, tree and crop farming automation, **mob drop and XP automation** (important — I want the drops without the fighting), and storage that scales without manual sorting. Also cover **config-level detox**: recipe simplification, ore density, and removal of artificial gates. Work down the escalation ladder in the scripting policy — configs and tag unification before any scripting. Everything must remain automatable — reject anything that just hands me items. This phase depends on Phase 4's outcome. A sky-island world needs a completely different economy from a normal one. ### Phase 6 — World quiet, guidance & comfort mods Deliberately lean. Three jobs only: 1. **Turn the threat down.** Mob spawning pressure, griefing mobs, hostile interruption of long builds. Bias toward quiet, not toward challenge. This includes **death handling and safety nets** — propose a grave, corpse or equivalent meeting the requirements in the philosophy section, plus void protection, and give me your answer on every pack-specific failure case listed there before I accept it. 2. **Guidance, not gating.** A guidebook or quest system used purely as a map of what the pack contains — never as a progression lock. 3. **The comfort mod allowlist.** Up to 5 base mods, chosen here, closed here. No addons. See the philosophy section above. Anything here must be checked for Sable sub-level compatibility. Do not propose exploration, dungeon, boss, or adventure content. ### Phase 7 — UI, QoL & information Recipe viewer, tooltips and probe, inventory management, minimap and waypoints, chunk claiming and loading, storage and logistics QoL. Inventory capacity follows the extend-don't-nest rule in the philosophy section. **Keybind consolidation pass.** Deliver an actual plan, not a principle: - A full audit of every keybind registered across the pack, gathered from the add-time flags — what it does, and whether it survives. - A proposed keymap: what's bound, to what, grouped by function, with vanilla untouched and everything else unbound by default. - A **controls-screen UX mod** with search, filtering and conflict highlighting. I believe the well-known one for this is *Controlling* — verify it has a current 1.21.1 NeoForge build before proposing it, and find an alternative if not. - The **shipping mechanism**: how default keybinds reach my friends' clients on first launch without overwriting choices they later make themselves. There are mods built for exactly this — identify the current working one for 1.21.1 NeoForge rather than assuming an older one still works. - A one-page keymap reference for the install guide and guidebook. ### Phase 8 — Performance & rendering Rendering pipeline, memory and startup optimizers, Distant Horizons, and shaders — which are in scope, per the philosophy above. Resolve the rendering stack as a single compatible set: Sodium/Iris or the alternative, Flywheel backend, Distant Horizons, and shader packs that actually work with all of it. Report back on the Phase 2 shader spike here and give me a final recommendation. Be explicit about which optimization mods are *unsafe* with Sable sub-levels rather than listing the usual suspects by reflex. ### Phase 9 — Server ops & failsafes Admin tooling, sub-level inspection / freezing / removal, profiling, backups, crash-report enrichment, anti-grief-by-accident measures. Backups matter more than usual here: one world, never reset, full of physics contraptions that alpha mods could corrupt. **The server runs in a container.** I want it portable — easy to move between machines and hosts without rebuilding anything by hand. - Recommend a container setup and give me a working `docker-compose.yml` in the repo. There are well-maintained images purpose-built for modded Minecraft servers that can fetch a pack automatically; identify the current best option for NeoForge 1.21.1 rather than assuming. - **Have the container pull the pack from the same referenced source the clients use.** One source of truth, consistent with the distribution principle, and no jars committed anywhere. - **Volume layout is the important design decision.** The world is the only irreplaceable state — it lives in its own volume. Pack files, mods and configs should be reproducible from the repo and the manifest, so a rebuild is disposable and a restore is not. - **Pin the image tag and the Java version.** A container that silently pulls a newer base image violates the freeze policy just as much as a mod update does. - Set **resource limits** so a runaway physics sub-level degrades the server rather than taking down the whole host. - Make JVM heap and flags configurable as environment variables so moving to bigger or smaller hardware is a config change, not a rebuild. - **Migration procedure:** the exact steps to move the server to different hardware. This should be moving one volume and starting a container — write it down and confirm it actually works before I need it in a hurry. ### Phase 9.5 — Config hardening Prevention, not cure. A lot of instability in a pack like this is limits rather than mod choice. Go through and set them deliberately: - Sable and Aeronautics: contraption size caps, sub-level counts, physics tick budgets, and whatever else can be bounded. - Create: contraption block limits, train limits, kinetic network sizes. - Entity and item-entity caps, chunk loading budgets, tick-time thresholds. - Anything with an "unlimited" default that a friend could accidentally use to halt the server. For each, tell me the default, the value you'd set, and what failure it prevents. Err toward generous-but-bounded: I want big builds, just not unbounded ones. ### Phase 10 — Integration pass Full conflict matrix across all phases, config changes required, load order notes, the completed lockfile, and a consolidated **cut order** — a single ranked list of what to disable first through last when something breaks. Explicitly address the known interaction: **infinite resources plus physics vehicles means very large builds very fast**, which loads directly onto the Sable performance budget. Treat that as a designed-for consequence, not a surprise. **Then run a curation pass — this is the only pruning that happens.** Since there's no play-based cut later, do it here on reasoning alone: - Which mods overlap enough that one should go? - Which are carrying real crash or corruption risk for their value? - Which did I add out of enthusiasm rather than need? - What's the total block and item registry count, and is it bloated? Argue for specific cuts. Don't just present the list back to me. ### Phase 11 — Validation & launch A crash-check protocol, not a playtest plan. Give me a concrete checklist: - Client loads clean; check the log for missing registries, dependency errors, duplicate mods, and mixin failures. - Dedicated server boots clean and a client connects. - Creative-mode smoke test: the headline features of each phase actually function when poked — assemble a Sable contraption, fly something, run a coaster, run a Create machine. - Scratch world is generated and thrown away, then a clean world is generated on the final pack. - Backups configured and **verified by restoring one** before anyone builds. Plus a **bisection procedure** for isolating a bad mod from a crash log, and a change-log format so I never lose track of what I altered between crashes. The final gate is the point at which the real server world gets generated. ### Phase 12 — Distribution & maintenance plan The pack has to be painless to install and painless to update, or it decays. Produce an actual operations plan covering: **Pack format & distribution** - Recommend a **reference-based** format — a plain zip of jars is disqualified by the distribution principle. Justify the choice against how my friends actually install things. - Confirm every mod in the final list resolves from its referenced source, and that the manifest carries versions and hashes so a build is reproducible. - Restrictive licensing is handled for free by referencing rather than bundling — but still flag any All Rights Reserved mods so I know where I have no fallback if a file is ever pulled from its host. - Split client-only, server-only, and both. Give me a server file list that isn't just the client list with shaders deleted. - A one-page install guide I can paste to a friend: launcher, pack import, RAM allocation, Java version, expected first-load time, and the two or three things that commonly go wrong. **Version control** - A **git repo** holding the pack manifest, configs, scripts, datapacks and lockfile — configs are the part that silently drifts and is impossible to reconstruct later. I'm comfortable with git, so use it properly: meaningful commits, tagged releases. - Give me a `.gitignore`. **No jars in the repo** — that would violate the distribution principle and bloat history. No world saves either; those belong in backups, not version control. - The `docker-compose.yml` and any container configuration live here too. The whole server should be reconstructible from this repo plus a world backup. - A version scheme and what each bump means (mod added/removed, config change, hotfix), plus tagged releases so any version can be rebuilt exactly. - A changelog format written for my friends, not for me. **Update workflow** - The full sequence for a deliberate update: stage it, validate it against a copy of the live world, back up, announce, push, confirm everyone's on the same version. Version mismatch is the most common way a small server breaks. - **Rollback plan:** always retain the last known-good pack version *and* a world backup from the same moment. A rollback that restores the pack but not a matching world is not a rollback. - Backup rotation and retention, given one irreplaceable world. **Handover** - Enough written down that someone else could run the server if I lose interest, or that I could pick it back up after six months away. ### Phase 13 — Post-launch triage Not a pruning phase — pruning happened in Phase 10. This is the runbook for when something goes wrong in a live world I'm not resetting: - Diagnosing a crash or performance problem from the server log. - **Safe removal:** what can be pulled without breaking existing builds, and what has become load-bearing because there are Sable contraptions in the world depending on it. Always tell me which category a mod is in before I remove it. - The batched recipe-fix process for problems my friends report. - When a freeze exception is justified, and how to apply one without collateral.

Memory
Only you
Purpose & context William is building a private Minecraft modpack called "Create Aeronautics Physics Server" for 2–3 concurrent players, centered on physics-based gameplay. The platform is locked to MC 1.21.1 / NeoForge / Create 6.x, with Create, Sable, Create: Aeronautics, and Create: Coasters Simulated as the immovable core. The goal is a pack that feels like a game rather than a development environment — builder-focused, automation-answers-scarcity, physics-first throughout. Key design philosophy locked in: Physics-first, default-to-NO for mods outside the core; hard cap of five comfort mods (base only, no addon chains) Peaceful-ish combat: mob drops automated rather than fought for; ComputerCraft-class programmability explicitly excluded Death handling: items never scatter or despawn; journey back is the only penalty; void protection required given airship gameplay Shaders: Complementary Reimagined with Euphoria Patches only (preconfigured, no alternatives supported) Decoration: "palettes not furniture" principle; block count treated as a cost Validation means "does it crash" in creative mode, not extended playtesting Version freeze policy: deliberate batched updates only; no mid-phase zypper dup William is a developer by background and uses git comfortably. Development machine runs openSUSE Tumbleweed (username: willi) with an RTX 5070 Ti (Blackwell architecture) GPU. The dedicated server will run on a separate Windows machine using Docker Desktop with WSL2. Current state Phase 1 is underway. The four core Phase 1 mods with confirmed versions: Create 6.0.10+mc1.21.1 Sable 2.0.3+mc1.21.1 Create: Aeronautics 1.3.0+mc1.21.1 Create: Coasters Simulated 0.1.4 Infrastructure confirmed live: Repo at /home/willi/Source/create-aero-physics/ packwiz installed at ~/go/bin/packwiz, build commit dfd8b68 (18 Feb 2026), confirmed to include the NeoForge 1.21.1 vs. 1.21.10 version-string bug fix mr alias for packwiz modrinth confirmed working packwiz init run; NeoForge version 21.1.248 accepted as default; pack.toml should be verified to read 21.1.248 not 21.10.x Prism Launcher installed via upstream AppImage (extracted, version-pinned, stable symlink at ~/Applications/prismlauncher); desktop entry written to ~/.local/share/applications; dev instance named physics-dev created Konsole keybind resolution: Ctrl+C is rebound to Copy; Ctrl+Shift+C outputs raw \x03 (ETX/interrupt byte) via keytab edit. packwiz serve is stopped with Ctrl+Shift+C going forward. On the horizon Complete Phase 1 execution: add the four core mods via packwiz, run packwiz refresh, serve locally, install into physics-dev via packwiz-installer-bootstrap, commit with phase tag on pass Phase 2: shader spike — Iris/Aeronautics compatibility test (deliberately early to surface rendering issues before the stack grows) Phases 3–8: Create breadth, worldgen decision, resource economy, world quiet/comfort mods, UI/QoL, performance and rendering Phase 9: server ops and containerisation (Docker/WSL2) Phase 9.5: config hardening Phases 10–13: integration, validation and launch, distribution and maintenance, post-launch triage Deferred to Phase 12: where pack.toml is hosted for friends, whether distribution uses .mrpack import or packwiz-installer auto-update, Prism's enforcement behaviour around .mrpack download domain whitelist Worldgen concept under consideration: replacing dimensional teleportation with machinery-based traversal (drill down to Nether, fly up to End); sky islands folded into extended Overworld to avoid Sable ship-crossing problems; AeroPortals + craftable end portal frame at altitude as the one supported End crossing; Forgiving Void removal deferred to late curation pending stack validation Key learnings & principles The NeoForge version-string bug (1.21.1 pulling 1.21.10 builds) is a known packwiz issue; the Feb 2026 build resolves it but pack.toml must be verified manually after packwiz init Prism Launcher Flatpak rejected: bubblewrap sandbox interferes with pre-launch commands required by the per-phase packwiz-installer-bootstrap workflow openSUSE OBS RPM rejected: third-party, history of release lag and PGP key issues, lacks Java downloader GPU driver must be confirmed working before Phase 2 shaders spike; llvmpipe fallback produces misleading symptoms Sable ships are sub-levels, not entities — no existing supported path carries a ship across a Y-boundary without portal mechanics; this is the fundamental constraint shaping the worldgen dimension-stacking design .gitattributes with -text is non-optional given the eventual Windows production host keymap.md added to repo to accumulate keybind decisions incrementally rather than reconstructing at Phase 7 Almost Unified (recipe unification) enters at Phase 5, Tier A only due to ARR licence; Distant Horizons in, Voxy ruled out on licensing and maturity grounds Physics sub-level rendering cost does not scale down with render distance — Steam Deck class is the client hardware floor with this caveat standing Approach & patterns One phase per session; each phase follows a six-step loop: branch → add mods → refresh → packwiz serve locally → install into dev instance via packwiz-installer-bootstrap → commit with phase tag on pass Tiered mod source system: Tier A (Modrinth/CurseForge), Tier B (GitHub direct download), Tier C (manual exceptions with a formal register in a gitignored manual/ folder) Validation gates at each phase before proceeding; no dedicated server exists until late phases Packwiz pinned by commit SHA rather than @latest Phase documents produced as markdown files saved to the repo's docs/ folder for persistent reference Prefers iterative critique-and-continue workflow in chat (vs. cowork environment) for phase execution Prefers direct communication about design tradeoffs and bad fits rather than glossed-over assessments Tools & resources packwiz (Go install, commit-pinned) — manifest source of truth Prism Launcher (upstream AppImage, version-pinned via symlink) — dev instance physics-dev packwiz-installer-bootstrap.jar — wired as Prism pre-launch command git — repo at /home/willi/Source/create-aero-physics/; .gitattributes -text set Docker Desktop + WSL2 — planned server hosting on dedicated Windows machine Konsole — custom keytab for Ctrl+C (copy) / Ctrl+Shift+C (interrupt) KubeJS — escalation ladder: configs and tag unification before scripting

Last updated 2 days ago

Context
3% of project capacity used
Search mode

claude
3 items


phase-2-complete.md
345 lines

md



phase-2-section-10-water-revised.md
143 lines

md



phase-2-section-10-water-revised.md
143 lines

md



phase-1-document.md
265 lines

md



Phase 0.5 Document
336 lines

text



Project Spec
773 lines

text



Phase 0 Document
350 lines

text


Scheduled
Set up recurring tasks for this project.

Project Spec
# Modpack Build Prompt — Create Aeronautics Physics Server
 
> Paste this back to Claude to start the build. Also worth dropping into the
> project instructions so it survives across conversations.
 
---
 
## Context
 
I'm building a Minecraft modpack for a private server for me and my friends.
Platform is locked: **MC 1.21.1 / NeoForge / Create 6.x**, because Create:
Aeronautics and Create: Coasters Simulated only exist there.
 
The theme is **physics-first**. Sable is the spine of this pack. I want physics
to show up everywhere — not just in vehicles, but in emergent world
interactions (blocks that detach into physics contraptions, trees that fall
properly, contraptions that shear through terrain at speed). Within that theme
I want real breadth across the Create and Sable addon ecosystem so we can
evaluate what's fun and prune later.
 
## About me
 
- Advanced modded MC player. I don't need mechanics explained.
- I **want** a heavily modded experience and I knowingly accept alpha and
  early-access mods. Don't cut something purely because it's young — flag the
  risk and let me decide.
- My actual pain point is *process*: I lose the thread when errors start, and I
  end up with an unmanageable list I can't debug.
- So: stability comes from build discipline and a documented cut order, not from
  playing it safe on mod selection.
 
## Design philosophy
 
This is a **builder's pack, not a survival challenge**. Create and physics
contraptions are the *point*, not the reward for grinding toward them.
 
### Abundance through engineering
 
- I want effectively infinite resources — but earned by *building the machine
  that produces them*, not by config handouts or creative mode. **The answer to
  a grind should be a machine, not a handout.** Automation is the intended
  answer to every scarcity problem.
- Still genuine survival. Keep hunger, keep death, keep the world real. Just
  remove tedium.
- Progression should gate *interesting* things, never *tedious* ones.
- When in doubt, err toward abundance. I'd rather over-supply and prune.
 
### Scope: deep, not wide
 
- **Create-centric with light supporting mods.** Create, Sable and the physics
  ecosystem are the pack. Supporting mods exist to serve them.
- **Default to NO.** Every mod outside the core theme must justify itself
  against a specific problem I actually have. Breadth belongs in Phase 2 and
  Phase 3 — the physics and Create ecosystems — not in the pack at large.
- No second tech tree. No magic tree. If a mod duplicates something Create
  already does, it needs a strong argument.
 
### Comfort mods: base only, no addon chains
 
I like mods such as Alex's Mobs, Supplementaries and MrCrayfish's Furniture.
My known failure mode is that each of these has its own addon ecosystem, and
following those chains is how packs become unmanageable. So:
 
- **Base mods only. Addons of comfort mods are forbidden**, with no exceptions
  I don't explicitly grant.
- **Hard cap: 5 comfort mods total** across the whole pack. They are chosen
  once, in Phase 6, and the list closes.
- Each must be named on an allowlist with a one-line reason. If I ask for a
  sixth, make me trade one out rather than adding it.
- Check each for conflict with the rest of the philosophy — e.g. a mob mod adds
  hostile mobs, which cuts against wanting a quiet world, and mobs from these
  packs are a known pathfinding problem on Sable sub-levels.
 
### Low friction
 
- **Combat is a nuisance, not content.** I want the world quiet enough that I
  can build without interruption. Bias toward reducing mob pressure, not adding
  dungeons, bosses or raids. Anything that resembles an adventure pack is out
  of scope.
- Because I don't want to *fight* for drops, mob and XP resources still matter
  — they should be **automated**, not fought for.
 
### Building: palettes, not furniture
 
- **Minimal decoration mods.** Vanilla blocks plus Create's copycat system do
  the heavy lifting. Copycats mean I can texture almost anything, so huge block
  packs and furniture mods are mostly redundant weight.
- Judge any aesthetic mod by whether it expands *palette and shape* usefully,
  not by how many blocks it adds.
 
### Block spam is a disqualifier
 
I strongly dislike mods that add thousands of blocks that are just every
variation of everything — every wood type times every shape times every colour.
 
- **Block count is a cost, not a feature.** Treat a large block registry as a
  strike against a mod, not a selling point.
- The damage is real, not aesthetic: it bloats the recipe viewer, buries useful
  items in search, slows loading, and makes creative tabs unusable.
- **Prefer systems over variants.** Copycats, dyeing and painting mechanics give
  breadth from few registered blocks. A mod that adds one block with many states
  beats a mod that adds four hundred blocks.
- When you propose anything decorative, tell me roughly how many blocks and
  items it registers, and whether it does it with variants or with a system.
- This applies to Create addons too. A Create addon is not exempt because it
  says Create on it.
 
---
 
### Death: costs a trip, never your stuff
 
Vanilla death is the worst of both worlds — you lose a lot, get frustrated,
charge back into the cave, die again, and end up down half your inventory
anyway. But full keep-inventory makes death meaningless and turns jumping off a
building into a hunger reset. I want the middle.
 
**Requirements:**
 
- **The mechanism is open.** Gravestone, tombstone, a lootable corpse — I don't
  care which. Judge candidates on the requirements below, not on the form. If a
  corpse-style mod handles the hard cases more cleanly than a block-placing
  grave, take it.
- **Nothing is ever scattered, and nothing ever despawns.** Whatever holds the
  items holds *everything*, permanently, until collected.
- **The cost is the journey back.** Retrieval should take time and travel — that
  is the entire penalty, and it's enough.
- Consider **keeping tools and armour on death** so the retrieval trip isn't
  attempted naked through the same hazard that killed me. The rest waits in the
  grave.
- **Death must not be a shortcut.** If dying is a cheaper way to reset hunger or
  get home than walking, the design has failed. Propose a small non-item penalty
  — a brief debuff or similar — that makes death mildly unwelcome without making
  it punishing. Never solve this by taking items.
- The grave must be **easy to find**: an automatic waypoint or coordinates in
  chat on death. Hunting for your own grave is exactly the tedium this pack
  rejects.
 
### Safety nets: prevent the death, don't just soften it
 
I like forgiving systems — especially **void protection**, which catches a fall
into the void and puts you back rather than killing you. In a pack about flying,
falling off an airship at altitude is an ordinary Tuesday, and the void is the
one place both you and your grave disappear for good.
 
- Prioritise **prevention over recovery** for void and out-of-world deaths. This
  doesn't contradict "death costs a trip" — falling off a contraption is a
  physics accident, not a gameplay decision, and there's nothing to learn from
  losing an afternoon to it.
- If Phase 4 lands on sky islands, this stops being a nicety and becomes core
  infrastructure. Weight it accordingly.
- Look for the same forgiveness elsewhere it's cheap: deaths caused by
  contraption jank, sub-level unloading, or physics glitches shouldn't cost the
  same as walking into lava on purpose.
 
**Pack-specific failure cases — check these explicitly, they're where items
actually get lost:**
 
- Dying **on a Sable sub-level**: does the grave place correctly, does it travel
  with the contraption, and what happens when that contraption is disassembled
  or unloaded?
- Dying **over the void, deep ocean, or lava**, which is a live risk in a pack
  built around flying. A grave that falls into the void has failed at its one
  job.
- Whether the mod has a **recovery command** so I can restore a lost grave if
  the above goes wrong anyway. Given one world and no resets, treat this as
  required rather than nice-to-have.
- Who can open a grave — owner only, or anyone. Decide it deliberately for a
  friends' server rather than inheriting a default.
 
### Inventory: extend it, don't nest it
 
**I dislike backpack mods.** Opening a second menu to reach a second inventory
is friction I notice every single time.
 
- Prefer mods that **extend the player inventory itself** — more rows, more
  slots, in the screen I already have open.
- Also fine: **remote or "cloud" access** to a storage network from anywhere, so
  the answer to carrying capacity is a base I built rather than a bag I wear.
  That fits the pack's automation-first philosophy better than a container item
  does.
- Rule out backpack-style container items unless nothing else covers the need,
  and tell me what I'm giving up if so.
- Whatever we pick must not break when opened on a moving Sable contraption.
 
### Keybinds are curated, not accumulated
 
Modded packs sprawl into unusable keymaps — every mod claims keys on install,
half of them for menus I'll open twice a year, and conflicts surface silently.
I don't want that, and I especially don't want to tell my friends to go and fix
their own controls.
 
- **The pack ships a keymap. Nobody configures anything.** Defaults are set by
  me, applied on first launch, and that's the end of it.
- **Unbind by default.** A mod's keybind stays only if I'd realistically use it
  weekly. Rare functions get reached through a menu or an item, not a key.
- **Vanilla bindings are untouched.** Muscle memory is worth more than any mod's
  preferred default.
- **Group by function.** Create and physics controls belong in one coherent
  cluster, not scattered wherever each mod's author happened to put them.
- Prefer **one key opening a radial or menu** over several keys doing several
  things.
- Ship a **written keymap** in the install guide and the in-game guidebook, so
  nobody has to go hunting through the controls screen to find out what exists.
  **List the unbound functions too** — an unbound feature is an invisible
  feature, and the point is to reduce clutter, not to hide capability.
- **Later updates need a keybind story.** First-launch defaults don't reach
  people who already launched, so any mod added in a post-launch update ships
  its keybind decision in the changelog as a line my friends can act on.
 
### Shaders are in scope
 
I want the pack to look good, so shader support is a design goal, not an
afterthought.
 
- Aeronautics has **known visual issues with Iris**. Don't treat that as a veto
  and don't treat it as solved — find out what actually breaks and how bad it
  is. Do this as an **early spike during Phase 2**, not at Phase 8: if shaders
  fundamentally break physics contraption rendering, that changes what the pack
  is, and I'd rather know at the start.
- Create's Flywheel rendering and shader pipelines have a history of friction.
  Confirm the current state on Create 6 rather than assuming either way.
- Shaders interact with Distant Horizons, and that compatibility is
  version-specific. Treat the rendering stack as one decision, not three.
- Per the distribution principle, **shader packs are not bundled**. Pick and
  document ones people can add themselves, and put them in the install guide.
- Assume mixed hardware among my friends. The pack must run acceptably with
  shaders off.
 
## Distribution principle: references, not files
 
**The pack is a list, not a bundle.** I am not moving jar files around. Nothing
gets redistributed — no mod jars, no resource packs, no shaders, no libraries.
 
- Every third-party asset is **referenced by link or project ID** and downloaded
  by the launcher from its official source. If I'm copying a file into a folder
  by hand, something has gone wrong.
### Source tiers
 
- **Tier A — mod platforms** (Modrinth, CurseForge). The default. Use these
  whenever the mod exists there.
- **Tier B — GitHub / GitLab releases.** Fully acceptable. A mod does **not**
  need to be on a mod platform. Release URLs are stable, versioned and
  hashable, which is all the pack needs. Verify in Phase 12 whether the chosen
  pack format restricts download domains — some formats allow only a whitelist,
  and it matters whether GitHub is on it.
- **Tier C — Discord, Google Drive, personal sites.** Exception only, and I
  have to grant it explicitly. Never assume it.
 
**When proposing a mod, state its tier.** If something I want is Tier C, tell me
at proposal time, name the cost, and offer an alternative — then let me decide.
 
### Tier C exceptions
 
If I grant one, it gets handled properly rather than informally:
 
- Log it in an **exceptions register**: what it is, where it came from, exact
  version, file hash, why the exception was granted, and where the file is
  archived.
- Be honest about what I'm buying. Discord CDN links carry signed, expiring
  parameters, so they can't be referenced at all — that mod has to be handed to
  every friend manually, every update, forever. Drive links can vanish without
  notice.
- Keep an archived copy of the exact jar somewhere I control, because the
  original source may disappear.
- Each exception adds a manual step to the install guide. Keep the count low
  enough that the guide stays one page.
 
**The manual folder.** Anything that can't be referenced — Tier C jars, resource
packs, shaders, odd files — goes in one designated folder that gets loaded
alongside the manifest-built pack.
 
- One folder, clearly named, for all of it. Not scattered per category.
- **Gitignored.** The repo still contains no jars; the exceptions register
  records what's in there — name, version, hash, original source, date added —
  so the folder's contents are reconstructible even though the files aren't
  committed.
- **The container needs these too.** It pulls the referenced pack automatically
  but can't fetch these, so mount the folder as a volume and treat it as part of
  the server's state.
- Decide deliberately at Phase 12 whether these ship inside the exported pack
  (easy for my friends, but that *is* redistribution and may breach a licence)
  or as a separate one-time download. Flag the licensing on each.
- **Recheck periodically.** If a Tier C mod later appears on a mod platform,
  migrate it out of the folder and into the manifest. This folder should shrink
  over time, never grow.
- Keep it small on purpose — everything here is manual work repeated on every
  install and every update, for me and for everyone else.
- No bundled resource packs or shaders. If we want one, it's referenced too, or
  it's a link in the install guide for people to add themselves.
- **The only exception is content the pack itself authors:** configs, KubeJS
  scripts, and datapacks. These have no upstream to link to, so they live in the
  repo and ship with the pack. Keep them small and documented.
- Consequence to respect in Phase 12: the pack format must support referenced
  downloads. Rule out anything that requires embedding files.
 
## Testing philosophy
 
**I am not playtesting this pack.** This is a one-and-done build. Testing means
**"does it crash"**, not "is it balanced" or "is it fun".
 
- Validation is: the pack loads, the server boots, no missing registries, no
  duplicate-mod or dependency errors, and the headline features work when poked
  in creative mode.
- I will not grind through progression to verify recipes. I will not evaluate
  pacing. Do not design phases that assume I played for hours between them.
- **Consequence you must respect: there is no prune-after-play safety net.**
  Every mod has to earn its place by reasoning at selection time, because the
  pack I launch is the pack I keep. Be stricter up front than you would be if
  we were going to cut later.
- **QUARANTINE now means exclude, not experiment.** Anything with a credible
  risk of save corruption or world-breaking behaviour is out. I accept alpha
  mods and jank; I do not accept losing the world.
- Because validation is cheap, **make the phases big.** Don't ration mods across
  many small rounds — I'd rather do fewer, larger passes.
 
## Version freeze policy
 
A constantly-changing pack creates incompatibilities that aren't worth the
trouble. So the pack is **frozen by default**.
 
- Maintain a **lockfile**: every mod with its exact file version and download
  link, updated as each phase closes. Versions are pinned from the moment they
  enter the pack.
- These mods move fast — Coasters shipped two releases in two days. Do not
  silently propose a newer version of something already locked.
- **Updates are deliberate, batched, and rare.** No rolling updates.
- **Documented exception:** a fix for a crash or data-loss bug I am actually
  hitting. That gets taken, tested in isolation, and recorded in the change log
  with the reason.
- Once the server world exists, any update must be assessed for whether it
  breaks existing builds — especially Sable contraptions already in the world.
 
## Scripting & recipe policy
 
KubeJS is allowed, but I've been burned by it: it turns into days of testing and
planning, and there's always one more workaround recipe. **It is a scalpel of
last resort, never a design layer.**
 
Follow this escalation ladder. Only move down a rung when the one above fails:
 
1. **Pick a different mod.** The cheapest fix to a bad recipe is not shipping
   the mod that has it.
2. **Mod config.** Most packs' recipe pain is a config toggle someone already
   wrote.
3. **A recipe-unification / tag-unification mod.** Most "random workaround
   recipe" problems are actually duplicate materials across mods — five copper
   ingots that don't interchange. Solving that once, globally, with tags removes
   a whole category of scripting before it starts. Propose a solution here early;
   it has the best effort-to-payoff ratio in the entire build.
4. **A plain datapack recipe override.** No scripting runtime, easy to delete.
5. **KubeJS.** Only when 1–4 genuinely fail.
 
Rules when KubeJS is used:
 
- **Reactive only.** Scripts fix a specific problem I actually hit in play.
  No speculative rebalancing, no progression rewrites, no economy design.
- **Report-driven, batched.** I won't be playing enough to find recipe problems
  myself — they'll surface from my friends on the live server. Collect them into
  a list and fix the batch in one deliberate update. Never fix them one at a
  time as they arrive; that is the endless-testing failure mode.
- **Small and self-contained.** A few lines each, one file, commented with what
  problem it solves so it can be deleted later without archaeology.
- If a fix is getting complicated, that's a signal the mod choice was wrong.
  Say so and propose removing the mod instead.
 
## World policy
 
- **One server world, generated once, never reset.** It is created at the very
  end, on the final frozen pack.
- Every world used during Phases 1–11 is a **disposable scratch world**. Never
  build anything in a test world that I'd be upset to lose.
- Do not let me start the real world before the Phase 11 gate passes, even if
  the pack looks finished.
 
---
 
## How I want you to work
 
Work in **phases**. Do **one phase per response**, then stop and wait for my
critique. Never jump ahead. Never revise an earlier phase's list unless I
explicitly reopen it — if a later phase creates a conflict with a locked mod,
raise it as a flag and let me decide.
 
For every mod you propose, give me exactly this:
 
| Field | Notes |
|---|---|
| Name | |
| Source | Modrinth / CurseForge link — must be referenceable, see the distribution principle |
| Version | exact 1.21.1 NeoForge build to pin |
| Side | client / server / both |
| Size | rough block/item count, if it's a content mod |
| Role | one line — what job it does in *this* pack |
| Risk tier | LOCKED / LOAD-BEARING / OPTIONAL / QUARANTINE |
| Cut order | integer — the order I pull things when debugging |
| Known conflicts | especially anything Sable / sub-level related |
 
### Rules
 
- **Verify everything by searching.** Do not assert a mod has a 1.21.1 NeoForge
  build from memory. If you can't confirm it, say so.
- Never fabricate a mod name or link. "There is likely a mod that does X, I
  couldn't confirm it" is a fine answer.
- Phases can be large — validation is a crash check, not a play session. Group
  generously rather than dripping mods out over many rounds.
- If a mod needs a companion compat patch, they're a single unit — never propose
  one without the other.
- **Flag grind.** For any mod in any phase, call out anything that introduces
  repetitive manual labour, and propose the config, datapack, or recipe change
  that automates or removes it.
- **Flag scope creep.** If you're proposing something outside the Create and
  physics core, say so explicitly and give me the one-line justification.
- **Flag keybinds.** When a mod registers default keybinds, say how many and
  what they do, and recommend keep-or-unbind at that moment. Keybind decisions
  accumulate silently otherwise and become a Phase 7 archaeology project.
- Tell me when you think I'm wrong. If a constraint I've set is hurting the
  pack, argue the case rather than quietly working around it.
 
### Stability at add-time, not after
 
I expect some crashes — these are experimental mods and I've accepted that. What
I won't accept is *more* than the jank inherently comes with. So don't defer all
stability work to the integration phase:
 
- **Every phase ends with a validation gate**, run in my **local dev instance**
  — single-player, creative, no server involved. Phases 1–8 never require a
  dedicated server; that only appears at Phase 9. I load the pack and confirm it
  starts clean before we move on, so a break is attributable to the handful of
  mods just added rather than to the whole pack. Say so explicitly at the end of
  each phase: "load and confirm before we continue." Phases that add no files
  (0, 0.5, 4) skip this.
- **Check conflicts at add-time.** When a mod enters, name its known conflicts
  then — don't save them all for the Phase 10 matrix. The matrix is a final
  audit, not the first time we look.
- **Flag subsystem overlap.** Most surprise crashes come from several mods
  patching the same thing: rendering, chunk loading, entity ticking, physics.
  When a proposal touches a subsystem another mod already patches, say so.
- **Prefer the boring option among equals.** Where two mods do the same job,
  favour the one with a wider install base and more recent activity. Novelty is
  worth spending on the physics theme, not on utilities.
 
---
 
## Phases
 
### Phase 0 — Foundation & constraints
 
Server specs, RAM budget, player count and my friends' hardware, tick-budget
expectations, and shader appetite.
 
Also settle, because these change real decisions downstream:
 
- **Distribution:** which launcher my friends will use, and how comfortable
  they are with manual setup. This determines the pack format, so it can't wait
  for Phase 12.
- **Hosting environment:** where the container runs now and where it might move
  later — home machine, VPS, NAS, rented host. Architecture matters, so ask.
- **Recipe unification:** identify the tag-unification approach early, per the
  scripting policy above. This is a Phase 0 decision because it shapes every
  later recipe conversation.
- **Programmability:** whether ComputerCraft-style vehicle control is in scope.
 
**Output:** a locked constraints sheet everything else is checked against.
 
Note: the worldgen direction question is deliberately deferred to Phase 4 — it
needs research, not a snap answer.
 
### Phase 0.5 — Dev environment
 
Set this up before any mods are chosen, because every later validation gate
depends on it. Should be quick.
 
- A **local dev instance** on my PC: launcher of choice, NeoForge 1.21.1, sane
  heap allocation. This is where the pack gets built and where every Phase 1–8
  gate is run. Single-player and creative are enough — no dedicated server until
  Phase 9.
- The **git repo**, initialised now rather than at Phase 12. Configs start
  mattering around Phase 5 and I don't want that work untracked. Phase 12 defines
  the release process; this is just the repo existing.
- The **lockfile and exceptions register**, as empty files I start filling from
  Phase 1.
- **A manifest-driven build, not manual jar wrangling.** The pack is defined by
  text files in the repo and built from them. This is how the lockfile, the
  reference-only rule and reproducibility all get satisfied by one mechanism
  instead of by hand.
  - Evaluate **packwiz** first — text-based, git-native, pins versions and
    hashes, supports Modrinth, CurseForge and arbitrary URLs, and exports a
    client pack. Confirm it's actively maintained and works for NeoForge 1.21.1
    before we commit to it; recommend an alternative if not.
  - Define the **per-phase loop** concretely: add the phase's mods to the
    manifest, build into the dev instance, launch, confirm, commit. One commit
    per phase, so a bad phase is one revert rather than an archaeology dig.
  - **Tier C exceptions won't fit the manifest** — no referenceable URL. They
    live in the manual folder described in the distribution principle. Set that
    folder and its gitignore entry up now, alongside the exceptions register.
- Tell me where the useful diagnostic files live — latest.log, crash reports,
  the mod list dump — so every later gate follows the same routine.
 
**Two environments, don't confuse them:** the dev instance is mine, disposable,
and rebuilt freely. The production environment — container, dedicated server, my
friends' installs — is built at Phases 9 and 12 and validated at Phase 11.
 
### Phase 1 — Core physics stack (non-negotiable)
 
Create, Sable, Create: Aeronautics, Create: Coasters Simulated, plus the
mandatory compat and glue layer. This is the immovable base.
 
### Phase 2 — Physics breadth (the theme layer)
 
The Sable ecosystem plus emergent-physics mods. **This is where breadth is
welcome — go wide here.** Explicitly hunt for:
 
- detached blocks becoming physics contraptions
- tree and structure physics
- contraptions cutting through terrain at speed
- collision damage
- sub-level tooling
- cross-dimensional physics objects
 
Highest-value and highest-risk phase.
 
### Phase 3 — Create breadth
 
Create addons proper: trains, logistics, energy, economy, copycats, and the
mechanics-expanding addons. Breadth for evaluation, flagged for later pruning.
 
Prefer addons that **integrate with Create's systems** over ones that sit
alongside it. Keep decoration-only addons to a minimum per the philosophy above.
 
### Phase 4 — Worldgen direction (decision phase)
 
**Present options before mods.** I'm undecided, and this choice cascades into
everything after it, so treat it as a fork in the road rather than a list.
 
Give me a comparison of at least these directions:
 
1. **Enhanced vanilla** — better terrain, more dramatic landscapes, familiar
   rules. Safest, most compatible.
2. **Sky islands / archipelago** — thematically perfect for Aeronautics, since
   airships stop being a novelty and become the transport layer. Note that this
   fundamentally rewrites the resource economy.
3. **Extended vertical world / cubic-chunks-style** — huge build height and
   depth. Confirm what actually exists and is stable on 1.21.1 NeoForge before
   recommending; don't assume.
4. Anything else genuinely worth considering, including hybrids (e.g. normal
   terrain plus physics-enabled floating islands above it).
 
For each: the gameplay experience it produces, how it interacts with Sable and
Aeronautics, what it does to the resource economy, its performance cost, and its
compatibility risk. **Then give me your recommendation and reasoning.**
I'll pick, and only then do you propose the actual worldgen mod list.
 
This choice is effectively permanent — one world, never reset — so treat it
accordingly.
 
### Phase 5 — Resource economy & anti-grind
 
Make abundance an engineering problem. Hunt for: bulk ore processing and
multiplication, block and fluid generators (cobble, stone, lava, water), quarry
and excavation systems, tree and crop farming automation, **mob drop and XP
automation** (important — I want the drops without the fighting), and storage
that scales without manual sorting.
 
Also cover **config-level detox**: recipe simplification, ore density, and
removal of artificial gates. Work down the escalation ladder in the scripting
policy — configs and tag unification before any scripting. Everything must
remain automatable — reject anything that just hands me items.
 
This phase depends on Phase 4's outcome. A sky-island world needs a completely
different economy from a normal one.
 
### Phase 6 — World quiet, guidance & comfort mods
 
Deliberately lean. Three jobs only:
 
1. **Turn the threat down.** Mob spawning pressure, griefing mobs, hostile
   interruption of long builds. Bias toward quiet, not toward challenge.
   This includes **death handling and safety nets** — propose a grave, corpse or
   equivalent meeting the requirements in the philosophy section, plus void
   protection, and give me your answer on every pack-specific failure case
   listed there before I accept it.
2. **Guidance, not gating.** A guidebook or quest system used purely as a map
   of what the pack contains — never as a progression lock.
3. **The comfort mod allowlist.** Up to 5 base mods, chosen here, closed here.
   No addons. See the philosophy section above.
 
Anything here must be checked for Sable sub-level compatibility. Do not propose
exploration, dungeon, boss, or adventure content.
 
### Phase 7 — UI, QoL & information
 
Recipe viewer, tooltips and probe, inventory management, minimap and waypoints,
chunk claiming and loading, storage and logistics QoL. Inventory capacity
follows the extend-don't-nest rule in the philosophy section.
 
**Keybind consolidation pass.** Deliver an actual plan, not a principle:
 
- A full audit of every keybind registered across the pack, gathered from the
  add-time flags — what it does, and whether it survives.
- A proposed keymap: what's bound, to what, grouped by function, with vanilla
  untouched and everything else unbound by default.
- A **controls-screen UX mod** with search, filtering and conflict highlighting.
  I believe the well-known one for this is *Controlling* — verify it has a
  current 1.21.1 NeoForge build before proposing it, and find an alternative if
  not.
- The **shipping mechanism**: how default keybinds reach my friends' clients on
  first launch without overwriting choices they later make themselves. There
  are mods built for exactly this — identify the current working one for 1.21.1
  NeoForge rather than assuming an older one still works.
- A one-page keymap reference for the install guide and guidebook.
 
### Phase 8 — Performance & rendering
 
Rendering pipeline, memory and startup optimizers, Distant Horizons, and
shaders — which are in scope, per the philosophy above. Resolve the rendering
stack as a single compatible set: Sodium/Iris or the alternative, Flywheel
backend, Distant Horizons, and shader packs that actually work with all of it.
 
Report back on the Phase 2 shader spike here and give me a final recommendation.
 
Be explicit about which optimization mods are *unsafe* with Sable sub-levels
rather than listing the usual suspects by reflex.
 
### Phase 9 — Server ops & failsafes
 
Admin tooling, sub-level inspection / freezing / removal, profiling, backups,
crash-report enrichment, anti-grief-by-accident measures.
 
Backups matter more than usual here: one world, never reset, full of physics
contraptions that alpha mods could corrupt.
 
**The server runs in a container.** I want it portable — easy to move between
machines and hosts without rebuilding anything by hand.
 
- Recommend a container setup and give me a working `docker-compose.yml` in the
  repo. There are well-maintained images purpose-built for modded Minecraft
  servers that can fetch a pack automatically; identify the current best option
  for NeoForge 1.21.1 rather than assuming.
- **Have the container pull the pack from the same referenced source the clients
  use.** One source of truth, consistent with the distribution principle, and no
  jars committed anywhere.
- **Volume layout is the important design decision.** The world is the only
  irreplaceable state — it lives in its own volume. Pack files, mods and configs
  should be reproducible from the repo and the manifest, so a rebuild is
  disposable and a restore is not.
- **Pin the image tag and the Java version.** A container that silently pulls a
  newer base image violates the freeze policy just as much as a mod update does.
- Set **resource limits** so a runaway physics sub-level degrades the server
  rather than taking down the whole host.
- Make JVM heap and flags configurable as environment variables so moving to
  bigger or smaller hardware is a config change, not a rebuild.
- **Migration procedure:** the exact steps to move the server to different
  hardware. This should be moving one volume and starting a container — write it
  down and confirm it actually works before I need it in a hurry.
 
### Phase 9.5 — Config hardening
 
Prevention, not cure. A lot of instability in a pack like this is limits rather
than mod choice. Go through and set them deliberately:
 
- Sable and Aeronautics: contraption size caps, sub-level counts, physics tick
  budgets, and whatever else can be bounded.
- Create: contraption block limits, train limits, kinetic network sizes.
- Entity and item-entity caps, chunk loading budgets, tick-time thresholds.
- Anything with an "unlimited" default that a friend could accidentally use to
  halt the server.
 
For each, tell me the default, the value you'd set, and what failure it
prevents. Err toward generous-but-bounded: I want big builds, just not
unbounded ones.
 
### Phase 10 — Integration pass
 
Full conflict matrix across all phases, config changes required, load order
notes, the completed lockfile, and a consolidated **cut order** — a single
ranked list of what to disable first through last when something breaks.
 
Explicitly address the known interaction: **infinite resources plus physics
vehicles means very large builds very fast**, which loads directly onto the
Sable performance budget. Treat that as a designed-for consequence, not a
surprise.
 
**Then run a curation pass — this is the only pruning that happens.** Since
there's no play-based cut later, do it here on reasoning alone:
 
- Which mods overlap enough that one should go?
- Which are carrying real crash or corruption risk for their value?
- Which did I add out of enthusiasm rather than need?
- What's the total block and item registry count, and is it bloated?
 
Argue for specific cuts. Don't just present the list back to me.
 
### Phase 11 — Validation & launch
 
A crash-check protocol, not a playtest plan. Give me a concrete checklist:
 
- Client loads clean; check the log for missing registries, dependency errors,
  duplicate mods, and mixin failures.
- Dedicated server boots clean and a client connects.
- Creative-mode smoke test: the headline features of each phase actually
  function when poked — assemble a Sable contraption, fly something, run a
  coaster, run a Create machine.
- Scratch world is generated and thrown away, then a clean world is generated
  on the final pack.
- Backups configured and **verified by restoring one** before anyone builds.
 
Plus a **bisection procedure** for isolating a bad mod from a crash log, and a
change-log format so I never lose track of what I altered between crashes.
 
The final gate is the point at which the real server world gets generated.
 
### Phase 12 — Distribution & maintenance plan
 
The pack has to be painless to install and painless to update, or it decays.
Produce an actual operations plan covering:
 
**Pack format & distribution**
 
- Recommend a **reference-based** format — a plain zip of jars is disqualified
  by the distribution principle. Justify the choice against how my friends
  actually install things.
- Confirm every mod in the final list resolves from its referenced source, and
  that the manifest carries versions and hashes so a build is reproducible.
- Restrictive licensing is handled for free by referencing rather than
  bundling — but still flag any All Rights Reserved mods so I know where I have
  no fallback if a file is ever pulled from its host.
- Split client-only, server-only, and both. Give me a server file list that
  isn't just the client list with shaders deleted.
- A one-page install guide I can paste to a friend: launcher, pack import, RAM
  allocation, Java version, expected first-load time, and the two or three
  things that commonly go wrong.
 
**Version control**
 
- A **git repo** holding the pack manifest, configs, scripts, datapacks and
  lockfile — configs are the part that silently drifts and is impossible to
  reconstruct later. I'm comfortable with git, so use it properly: meaningful
  commits, tagged releases.
- Give me a `.gitignore`. **No jars in the repo** — that would violate the
  distribution principle and bloat history. No world saves either; those belong
  in backups, not version control.
- The `docker-compose.yml` and any container configuration live here too. The
  whole server should be reconstructible from this repo plus a world backup.
- A version scheme and what each bump means (mod added/removed, config change,
  hotfix), plus tagged releases so any version can be rebuilt exactly.
- A changelog format written for my friends, not for me.
 
**Update workflow**
 
- The full sequence for a deliberate update: stage it, validate it against a
  copy of the live world, back up, announce, push, confirm everyone's on the
  same version. Version mismatch is the most common way a small server breaks.
- **Rollback plan:** always retain the last known-good pack version *and* a
  world backup from the same moment. A rollback that restores the pack but not
  a matching world is not a rollback.
- Backup rotation and retention, given one irreplaceable world.
 
**Handover**
 
- Enough written down that someone else could run the server if I lose interest,
  or that I could pick it back up after six months away.
 
### Phase 13 — Post-launch triage
 
Not a pruning phase — pruning happened in Phase 10. This is the runbook for
when something goes wrong in a live world I'm not resetting:
 
- Diagnosing a crash or performance problem from the server log.
- **Safe removal:** what can be pulled without breaking existing builds, and
  what has become load-bearing because there are Sable contraptions in the world
  depending on it. Always tell me which category a mod is in before I remove it.
- The batched recipe-fix process for problems my friends report.
- When a freeze exception is justified, and how to apply one without collateral.
