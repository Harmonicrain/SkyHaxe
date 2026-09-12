# SkyHaxe — implementation checklist

> **Historical gate checklist:** retained for regression provenance. Some frontier and command
> descriptions below predate the working v32 component graph. Use `README.md`,
> `REPOSITORY_LAYOUT.md`, and `reproducibility/v32/` for current workflows.

Companion to [PLAN.md](PLAN.md). The plan holds the reasoning; this holds the order of work and
the definition of done. **Read the Standing Rules before the first task and re-read them whenever
you resume.**

Status key: `[ ]` not started · `[~]` in progress · `[x]` done and verified · `[!]` blocked

**Current baseline (2026-09-04):** the production build uses the generated `RoomEngine`,
`RoomMessageHandler`, and `RoomSpriteCanvas` for public and guest rooms. The five temporary room
implementation classes have been deleted. Photo CORS is intentionally deferred. The next product
work is hotel UI, beginning with navigation and room-object selection; preserve the room runtime
with build and browser smoke checks while that work lands.

---

## Standing rules

### Active UI slice (2026-09-05)

- [~] **Infostand.** V20 handler/views and V21 concrete windows convert into an isolated candidate
  at `.toolchain/v21/generated`. The V20/V21 concrete compile target now builds; the widget is not wired.
  Keep the production bootstrap UI until the generated manager/desktop cutover is verified.
- [~] **Original window manager (V22).** Isolated follow-on batch: 151 additional source files,
  including the skin renderer, themes, widget registry, embedded wrappers and original localization.
  See `evidence/v22_window_manager_closure.json`; the combined compile root names 498 types.
  `scripts/verify-window-runtime.ps1` now builds the root and passes the real-manager browser
  canary: original localization/skins, 34 authored frame/button styles, default button hover
  pixels/press/click/exit, list attachment/removal and window/manager disposal. This is not
  full Flash reference acceptance, editable-input parity or production promotion.
  Prior recheck: one preload failure for an existing skin PNG, followed by four successful
  fresh-browser runs of the unchanged build (`window_runtime_recheck.json` and
  `window_runtime_repeat_1.json` through `_3.json`). The latest regenerated-build run also
  passes (`window_runtime_verification.json`). Intermittent loading remains unresolved,
  not waived; the current result file supersedes the earlier failed run.
- [x] **Window-service boundaries.** Real HTTP text/image completion and failure, cancellation,
  asset ownership, host link routing and original embedded bytes/pixels have browser sub-tests
  (`scripts/verify-window-services.ps1`). This is not a completed window-manager gate.
- [!] **Original room UI owners (V23 conversion blocked).** 850 additional files / 126,337 source lines
  currently reachable from RoomDesktop/RoomUI/RoomWidgetFactory, before evaluating browser
  boundaries. `evidence/v23_room_ui_closure.json` records dependency chains, not a conversion pass.
  The current sync fails on E4X filters/namespaces, labelled control flow, `with`, and remaining
  shared conversion gaps; `evidence/v23_room_ui_sync.json` records the failed run. No V23 output was
  published. Shared constructor/coercion fixes pass the fresh-output converter regression.
  Follow-up: indexed XML chains and declared/dynamic `toString` signatures now pass; the six
  video playlist argument-count errors are gone. Wildcard/named descendants and singleton
  XML indexing have new browser regressions. Predicate and namespace syntax remain open.
  XML.ignoreWhitespace now applies at construction, and dynamic descendant access checks the
  runtime XML type. The AvatarInfoWidget final-case/default-return fall-through is preserved;
  String.match accepts string patterns and retains null/captures. These fixes have isolated
  browser regressions, not a completed V23 compile or live Infostand acceptance.
  Do not replace their widget message/event bus with a handwritten Infostand overlay.
- [~] **Infostand delivery profile (V24).** Following permission to choose the bounded delivery,
  keep original INFOSTAND and AVATAR_INFO factory/desktop branches and the original event bus.
  `evidence/infostand_build_profile.json` pins source and projected owner hashes; only staged
  copies change. The separate full V23 batch remains open. V24 adds 118 sources, converted
  deterministically into `.toolchain/v24/generated`; compilation and live wiring remain open.
  `project.v24-infostand.xml` is isolated: no production source promotion or handwritten widget.
  Shared browser regressions cover unsigned colour constants/defaults, Boolean numeric relations,
  Math.LN2, conditional switch exits (including loop targets), and event listener identity.
- [x] **Candidate Truffle text sub-gates.** Actual-font glyph coverage, selection visibility,
  thickness and character advances pass in Chrome (`scripts/verify-window-text.ps1`). Normal-AA
  rendering is tested with browser `fillText` forbidden. These are not Flash pixel-diff acceptance.
- **All font rendering must use Truffle**, including normal-AA and editable controls. The isolated
  Canvas/WebGL adapter implements this route; production-wide cutover and DOM/input parity are
  not complete. Do not introduce silent system/browser font fallback.
- [x] **Shadow numeric coercion.** Shared converter fix preserves AS3 int coercion after
  `ceil`/`floor`/`round`; NaN model values remain NaN. V7 output regenerated and production builds.
  `scripts/verify-shadow.ps1` exercises the actual generated shadow path at scales 32 and 64.
- [x] **Failure-safe conversion publication.** Scratch conversion precedes publication;
  `test/test_sync_publication.py` covers failures, deterministic helpers and timestamps.
  Converter probes also use fresh per-run outputs and require every fixture; the isolation test
  rejects zero-exit partial conversion even when stale outputs and prior PASS evidence exist.
- [x] **Candidate graphics-context sub-gate.** Actual converted attach/reparent, mouse,
  filters and disposal pass in Chrome (`scripts/verify-window-graphics.ps1`). This does not
  establish full Flash parity. The separate V22 canary now verifies manager initialization,
  skins and control interaction. Inline HTML image loading remains explicitly unsupported.
- [~] **Compile-all inventory.** `project.compile-all.xml` exists but fails on unreachable
  generated dependencies/syntax. Do not describe all generated code as compiling.

See [DELIVERY_REVIEW.md](DELIVERY_REVIEW.md) for the delivery plan, findings and remaining work.

### Rules

These exist because a long port drifts in predictable ways. They are not advice.

1. **`habbo-client-clean` is read-only**, with exactly two exceptions: **P2** (E4X descendant
   rewrite) and **P3** (the missing semicolon). Do not "fix" anything else there while porting. If you find a bug, write it
   down and keep going.
2. **The asset corpus at `c:/habbo/ngh/` is read-only. Always.** No conversion step, no renaming,
   no reorganising. If you believe an asset must change, stop — that contradicts decision D1 and
   needs a human.
3. **Never claim a gate passed without the artefact named in its "done when".** A clean compile is
   not a pass. A screenshot that "looks right" is not a pass unless it was diffed against the
   reference.
4. **Do not skip ahead.** Gates are ordered because each one can invalidate the ones after it. If a
   gate fails, stop and report — do not route around it.
5. **Port behaviour, not appearances.** When AS3 and Haxe differ, match what the AS3 *did*,
   including its bugs. The server expects the existing behaviour.
6. **Obfuscated names (`_Str_1675`, `k`, `_arg_2`) port as-is.** Renaming during conversion loses
   the only cross-reference back to the original. Rename later, deliberately, or never.
7. **Every measurement gets a saved script and saved output** in `evidence/`, like G0. Prose
   figures rot; scripts can be re-run.
8. **When something contradicts PLAN.md, the code wins — then fix PLAN.md** in the same session,
   in place. Do not leave two claims standing.
9. **Do not run destructive or history-rewriting git commands.** Committing in this repo is fine
   once it exists; touching `habbo-client-clean`'s git state is not.
10. **`habbo-client-clean` stays authoritative.** Converted Haxe must be reproducible output, not
    a second source tree maintained by hand. Never edit generated Haxe. Every hand-maintained
    replacement belongs in a machine-readable exception manifest with its AS3 source hash and
    contract tests; an upstream change to that source must fail the sync and demand review.
11. **Do not invent a parallel client architecture.** Room, protocol, lifecycle, interaction, and
    UI behaviour must come from converted clean-client components whenever they exist. A
    hand-written layer is allowed only at an unavoidable HTML5/OpenFL boundary, must be kept
    minimal, and must be deleted when its converted owner can take over. Convenience and faster
    visible progress are not sufficient reasons to duplicate Flash behaviour.

---

## Historical runnable-client milestone

This section preserves the browser-visible steps that led to the current generated room path.
Individual `[~]` entries describe their state at the time; the current baseline above supersedes
their old frontier wording.

- [x] **V1. Boot the real login screen.** The production `Main` now instantiates
      `com.sulake.habbo.communication.demo.HabboCommunicationDemo`, loads
      `c:/habbo/ngh/gamedata/external_dev_vars.txt` over the read-only `/ngh/` mount, and renders
      `HabboCommunicationDemoCom_login_window.bin` with the real theme/skins at `NO_SCALE`.
      The authored status field is blank at idle, as in AIR. Main HTML5 build and G4b compile
      regression pass.
- [x] **V2. Authenticate from that screen.** **PASS 2026-09-02.** Login click/Enter is wired to the shared
      `Html5HabboConnection` adapter and the existing G1b transport canary now uses that same
      adapter. It sends the clean-client packet ids/order, answers Ping with Pong, keeps the live
      socket open, and closes the login view after user identity arrives. The real input submitted
      the local SSO, authenticated as John, closed the login view, and produced zero console
      errors. The credential is not recorded. See `evidence/v2_login_verification.json`.
- [~] **V3. Dispatch the authenticated bootstrap stream.** The registry is generated from the
      authoritative `HabboMessages.as`: **600 incoming + 581 outgoing mappings**. A fail-closed
      parser generator now emits **228** parsers (see V3b below, which supersedes the original
      three). `FurnitureAliasesMessageParser` is still an exception, but no longer for its counted
      loop -- that shape now generates. It is excluded because its public API is method-style
      (`getName(index)`, `getAlias(index)`) rather than property-style. The
      live John login dispatched 73 packets / 53 mapped message ids with zero unknown ids, read
      NavigatorSettings, requested room 17413, parsed RoomReady (`netcafe`), and received the room
      entry stream. V3 remains open because broad post-auth parser/composer generation and feature
      dispatch are not complete. See `evidence/v3_message_registry.json` and
      `evidence/v3_parser_generation.json`.
- [x] **V3b. Parser generator reach.** **PASS 2026-09-02.** The generator moved from a hardcoded
      list of **3** files to **228 generated** from the authoritative AS3 — 41% of the 559
      attempted, 43 of them on the room-entry path — and **all 228 compile** against OpenFL HTML5
      through `test/M2ParserCompileMain.hx` and `project.m2-parsers.xml`.

      Shapes added beyond straight-line reads: counted-scalar loops into Array/Map/Vector,
      collection construction and reset, optional trailing fields behind `if (k.bytesAvailable)`,
      typed local declarations holding a read, deliberately discarded reads (which must still be
      *performed* or every later field desynchronises), and expression-wrapped assignments.
      Recognition lives in `scripts/m2_parser_shapes.py` so the accepted grammar is readable on
      its own, and it returns None rather than approximating.

      **The compile check earned itself immediately.** It caught three defects that would
      otherwise have shipped: `flush` emitting `new Vector.<int>(0)` as if it were Haxe;
      `int(k.readString())` mapped to `Std.int` when AS3's `int()` on a string *parses* it, so it
      had to become `Std.parseInt` or the value would have been silently wrong; and unqualified
      global `parseInt`/`parseFloat`. `generated/` is not on the client class path yet, so nothing
      else would have caught any of them.

      Shape census: `evidence/v3_parser_shape_census.py`. Result:
      `evidence/v3b_parser_generator_reach.json`.

      **Next tier is `delegated`** — a loop calling another parser per element, as
      `ObjectsMessageParser` does through `ObjectDataParser.parseObjectData()`. Floor furniture,
      wall items and users all take that shape, so V4 needs it and counted-scalar support does
      not reach them.
- [~] **V4. Enter and render one real room.** **PUBLIC ROOM + LIVE OBJECTS/AVATARS PASS
      2026-09-02; FULL GATE OPEN.**
      The production path enters John’s configured room 17413 and uses RoomReady’s `netcafe` type
      plus `external_dev_vars.txt:flash.client.url` to load the real configured Gordon SWF. Its own
      assets/visualization XML drives **44 layers / 25 unique decoded bitmaps**, including authored
      depth, alpha, additive lighting and flips; an independent scanner reports zero missing rows
      or exports, and the browser canary has zero warnings/errors. The first visual run exposed a
      real endian bug that made the room blue: HTML5 OpenFL defaulted ByteArray to little-endian at
      the final ARGB upload. `SwfBitmap.toBitmapData` now explicitly uses big-endian, and G2 guards
      the known green netcafe sample (**927 assertions / 118 comparisons pass**). The production
      stage is black like AIR, so the room bitmap’s opaque black bounds no longer show as a box.
      Room-canvas drag/pan now works. Packet 5202's public-room objects are deliberately loaded
      from the room SWF rather than furnidata: the live NetCafe renders **74 objects / 81 sprites**.
      They, the 44 room layers, and avatars now share one absolute depth list using the clean
      client's independent `(-135, 0.5, 0)` depth vector. Multi-layer public objects also apply
      their per-direction XML `z`, x/y, alpha and ink data; replacing those values with only the
      layer index was the remaining whole-room ordering bug. Normal floor/wall furniture (none in
      this room), effects and the hotel UI remain, so V4 correctly stays `[~]`. See
      `evidence/v4_public_room_contract.json`, `evidence/v4_public_room_verification.json`, and
      `evidence/v5_avatar_room_verification.json`.

      **Idle-frame correction 2026-09-02.** `AvatarImage` owns and clears a mutable work bitmap.
      Keeping that buffer directly in the display list let Ray/Tongbits flash transparent while
      another avatar recomposited. Each room unit now owns a cloned display snapshot; only moving
      units advance at 82ms. A settled localhost run compared 30 consecutive 75ms captures for
      Ray and Tongbits with no pixel changes. Evidence is in the V5 and V6 runtime JSON files.

- [~] **V5. Draw an avatar.** **THREE REAL AVATARS LIVE 2026-09-02; GATE STILL OPEN.** The
      **77-file** avatar compositor/parser closure -- AvatarImage, AvatarStructure, figure,
      geometry, actions, animation, cache, Users and UserUpdate parsers -- converts, compiles and
      passes a two-run deterministic sync
      (`evidence/v5_avatar_closure.json`, `scripts/sync.py --closure`). Getting there took fifteen
      converter fixes, all general rather than avatar-specific: dynamic arithmetic, `Map` proxy
      indexing, `enum` as a package segment, real switch fall-through, E4X literals, `1E-18`.

      The closure went 115 files -> 75 by drawing an explicit **seam** (`SEAM` in
      `evidence/v5_avatar_closure.py`, mirrored by `SEAM_REPLACEMENTS` in
      `evidence/m2_build_exceptions.py`). The AS3 component runtime, the profiler, LibraryLoader
      and its vendored FZip zip decoder are out of the port: SkyHaxe reads SWFs with `SwfFile`.
      One reference -- `EventDispatcherWrapper` calling `Core.crash` -- was pulling all of it in.

      The production localhost path now renders **Ray, Tongbits and John** through the generated
      compositor at real public-room **scale 32** (`AvatarScaleType.SMALL`, the
      `hh_human_50_*` libraries), not resized 64px. UsersEvent rows merge by room index, packet
      1640 applies generated UserUpdate rows, directions convert from packet degrees to the
      compositor's 0..7 indices, and compositor instances persist between packets. Ray was
      observed walking tiles 9–12 in both directions 0 and 4; John remained visible at direction
      2. Position tweening runs on display frames while the clean client's avatar frames advance
      every 82ms, without restarting at each network update. Avatar depth uses the clean
      `AVATAR_SPRITE_DEFAULT_DEPTH` of **-0.01**, so the bar masks rather than a hard-coded avatar
      exception decide whether Ray is in front or behind.

      **Open, in order.** Classify the 15 part keys still reported unresolved (real omissions vs
      small-library alias diagnostic false positives), close remaining actions/postures, then
      replace the temporary native placement boundary with more of generated
      `AvatarVisualization` as its dependencies become compileable. V5 remains `[~]`; visible
      avatars are a real vertical slice, not the full avatar subsystem. Runtime evidence:
      `evidence/v5_avatar_room_verification.json`.

      **Two traps already paid for.** A review caught `SwfAssetLibrary` guessing at the asset
      naming and being wrong twice, in ways that fail silently rather than loudly -- a null
      manifest and null part lookups render an empty avatar with no error. Measured and pinned in
      `evidence/v5_avatar_library_contract.py`: the manifest is `<library>_manifest`; bitmap
      symbols carry the library prefix (`hh_human_50_hair_sh_std_hr_1_0_0`) while the manifest and
      the compositor use the short name (`sh_std_hr_1_0_0`); every asset carries an `offset` param
      that positions it. Verified across three libraries at both scales: 1090/1090, 179/179,
      902/902. The adapter now strips the prefix and registers through
      `AssetLibrary.loadFromManifest`, which applies the offsets and aliases.

      **Converter patches are only snapshotted, not scripted.** `.toolchain/ax3` is gitignored;
      fourteen files are copied to `evidence/ax3-patched/` with a README listing every change.
      Folding them into `evidence/m2_patch_ax3.py` is the next task on that file -- until then the
      patch script restores 21 patches and none of these.

- [~] **V6. Interact with the room.** **TILE CURSOR + SERVER WALKING LIVE 2026-09-02; GATE
      STILL OPEN.** Packet 1301 is parsed by the generated `FloorHeightMapMessageParser`: NetCafe
      reports 25x24 cells and 400 real room tiles. Pointer hit-testing uses those heights and the
      exact scale-32 projection. The visible cursor is not redrawn: it is the genuine
      `TileCursor.swf` export `tile_cursor_32_a_0_0` (34x19), with its authored 16,10 registration
      and -2.9 layer depth. It hides over blocked/black space and remains correct while the room
      canvas is panned.

      Clicking without crossing the existing 15px drag threshold sends registry packet 3320,
      exactly `Int32(x), Int32(y)`. A live click at 17,13 made Arcturus emit normal UserUpdate
      rows and moved John from 22,12 to 17,13; there is no local teleport path. Packet 2661 now
      removes a unit by room index, and every RoomReady also disposes the previous compositor
      snapshots and resets the room-unit map, covering the leaving client's own same-room
      re-entry where a removal broadcast is not guaranteed. Full furniture-surface cursor logic,
      object interactions, and a live navigator leave/re-entry drill remain open. Evidence:
      `evidence/v6_room_interaction_verification.json`.

- [~] **V7. Render a guest room.** **ENGINE CONVERTED 2026-09-03; DRIVER NOT WRITTEN.**
      Entering a guest room (`custom_13698`) black-screens because there is no code path, not a
      broken one: `loadPublicRoom` is gated on `RoomReady.isPublic`. Upstream already works --
      **44 floor objects, 5 wall items** parsed with real data, and a **34x37** `FloorHeightMapEvent`.

      **Structural correction.** SkyHaxe had grown a bespoke loader per object kind
      (`PublicRoomVisualizationLoader`, `AvatarRoomRenderer`, `RoomTileCursorController`), each
      reimplementing part of one engine. The clean client has none of that: a single
      `RoomObjectVisualizationFactory` maps a type string to a visualization
      (`ROOM` -> RoomVisualization, `PUBLIC_ROOM` -> PublicRoomVisualization,
      `TILE_CURSOR`, `USER`/`BOT` -> AvatarVisualization) and every one feeds one
      `RoomSpriteCanvas`. Public rooms are **not** a separate renderer -- `PublicRoomVisualization`
      is 109 lines extending RoomVisualization's 1,054, overriding only `floorRelativeDepth` (131),
      `wallRelativeDepth` (135), `initialize` and `update`. Re-deriving depth three separate times
      this session was a symptom of the missing shared engine.

      **Converted: 84 files / 15,648 lines / 20 packages**, deterministic, compiling green under
      `project.v7-guest-room.xml` -- the shell engine, `rasterizer/basic` (15), plane masks,
      `FurnitureVisualization`, `PublicRoomVisualization`, plus `RoomObject`, `RoomObjectModel`
      and `GraphicAssetCollection`. `RoomGeometry` is now generated, so the hand-rolled `project3`
      can retire with it. See `evidence/v7_guest_room_closure.py`.

      **Converter gaps closed, all general:** `ASArray.sortWithOptions` implemented for JS (throws
      on RETURNINDEXEDARRAY/UNIQUESORT rather than returning a plausible wrong array); `ToString`
      coerces `[TTAny, TTInt/TTNumber]`; `ArgumentError` added beside `ASError`; guarded rules for
      E4X literals with `{expression}` attributes, the `elements`/`elements()` name collision, and
      an attribute read after an XMLList index. One decompiler artefact: `Canvas.as:96` had
      `(k) && (0xFF000000)` where the original was the bitwise `&` that preserves the alpha byte.

      **Two hand-written files retired** in favour of generated output -- `RoomPlaneParser` (its
      own stub comment said this closure would supersede it) and `RoomObjectSprite`. The generated
      sprite is authoritative; `RoomSpriteCanvas` needed exactly one documented boundary cast
      because AS3 types `filters` as an untyped Array. Nothing under `generated/` shadows `src/`.

      **The driver is fully specified and unwritten.** `HabboRoomContent.swf` in gordon is the
      generic shell library: `HabboRoomContent_room_visualization` (the XML
      `RoomVisualizationData` consumes), `HabboRoomContent_room_assets`,
      `HabboRoomContent_manifest`, and 258 bitmaps in `_32`/`_64` variants. So the slice is:
      load it through `SwfAssetLibrary`, wrap it in `GraphicAssetCollection`, build a `RoomObject`
      carrying the heightmap, call `initialize(RoomVisualizationData)` then
      `update(RoomGeometry, time)`, and feed `spriteCount`/`getSprite(i)` into the existing
      canvas. The same loop serves public rooms via the subclass, retiring the bespoke loader.

      **Also open:** avatar scale must come from room geometry rather than the hardcoded
      `AvatarScaleType.SMALL` -- guest rooms are 64, which is where the modern clothing that
      cannot render at 32 actually exists.

---

## Phase 0 — Foundations

- [x] **P0. Put SkyHaxe under version control.** Initialized on `main`; foundation commit
      `3eafb63` contains `PLAN.md`, `CHECKLIST.md`, and the initial evidence set.
- [x] **P1. G0 — asset invariant.** **PASS** 2026-08-31 (exit 0, 0 unreadable, 18,608 files).
      Scanner `evidence/g0_scan_swf_exports.py`, results `evidence/g0_hof_furni.csv.gz`,
      anchors `evidence/PROVENANCE.md`. Re-run it rather than trusting any figure.
- [x] **P1b. Provenance anchored.** Commit `9b265927b277`; pre-cleanup `git diff HEAD` sha256
      `5ce21ff780421d0d` (89 tracked-modified + 226 untracked), and post-P2/P3 sha256
      `60bfe073e18bbb40` (93 tracked-modified + 226 untracked). Artefact hashes and correction
      history are in `evidence/PROVENANCE.md`; a commit id plus "dirty" is not reproducible.
- [x] **P1d. Baseline decision recorded.** The owner delegated this decision on 2026-08-31.
      Do **not** create a synthetic commit from the client's 89 tracked modifications and 226
      untracked files: that would capture unrelated in-progress work. Retain the verified
      commit + diff hash + untracked manifest anchor until the client tree naturally reaches a
      clean owner-created commit, then replace the anchor.
- [x] **P1c. Extend G0 to the other corpora.** Whole `dcr/`: PASS, 18,611 files, 0 unreadable.
      Gordon is mixed, so `evidence/g0_gordon_contract.py` derives reachability from current maps,
      `external_dev_vars.txt`, AS3 literals, public-room config plus a naming fallback, and NGHWin's
      six local files: PASS across 3,270 reachable production files, including 24 required MP3
      sounds and 1,468 JPEG2 exports. Five of the six checksumless-but-complete CWS files are live
      reachable content; `elephants.swf` is one of them. G2 must support tolerant inflate followed
      by an exact header-length check or that configured pet will not load.
      Two truly truncated SWFs and all font/sprite exports are confined to unclassified archived
      client/test files. Four map entries have no configured-production file and remain explicit
      corpus warnings. Owner decision: ignore the 2,891-file
      `flash-assets-PRODUCTION-202605152352-294132426` subtree.
- [x] **P2. E4X descendant rewrite** in `habbo-client-clean`. The four first-party sites now use
      class-local, depth-first `children()` walks, preserving descendant document order and the
      BattleBall first-match rule. Regenerated contract: **0 first-party descendants**, 1 untouched
      vendored `org/openvideoads` site. Official NGHWin compile passed 2026-09-01.
- [x] **P3. Fix the ASI reliance** at
      `habbo-client-clean/src/com/sulake/habbo/communication/HabboMessages.as:1674`.
      Added only the missing semicolon after `FireworkChargeDataEvent`; packet ID/class unchanged.
      The already-dirty file's unrelated leaderboard, ticket, and SnowStorm edits were preserved.

---

## Phase 1 — Prove the platform

Nothing is ported in this phase. Every task is a spike that can kill the project cheaply.

- [x] **G1. Toolchain.** **PASS 2026-09-01.** Project-local, SHA-256-pinned Haxe 4.3.7,
      Neko 2.4.1, Haxelib 4.1.1, Lime 8.3.2, and OpenFL 9.5.2. The minimal HTML5 project builds,
      opens over HTTP, renders its 960×540 canvas, sets `data-skyhaxe-g1="ready"`, and logs
      `SKYHAXE_G1_READY` with no browser-console errors. See `evidence/g1_toolchain.json`.
- [x] **G1b. Local WebSocket transport.** **PASS 2026-09-01.** OpenFL HTML5 → unmodified
      `NitroWebsockets-3.2` → current Arcturus. Two cycles each completed `ClientHello`, `UniqueID`,
      SSO authentication, and `InfoRetrieve`; both returned a `UserObject` for John. Two normal
      closes and one reconnect completed. See `evidence/g1b_websocket_transport.json`.
- [ ] **Deployment transport follow-up.** Repeat from the real HTTPS page over `wss://` with its
      production certificate, origin whitelist, and proxy configuration. Explicitly deferred for
      localhost on 2026-09-01; local TLS files were not changed.
      Complete this before G6; mixed-content, certificate, proxy, and origin behavior cannot be
      established from the localhost HTTP test.
      Note: the plugin jar ships no source and its POM targets Habbo 3.0.0 against a 4.0.3-beta
      server. Runtime verification is the point of this gate.
- [ ] **G1c. Converter canary.** Pick **20–30 deliberately awkward** files and run ax3 → Haxe →
      **compile**. Cover, at minimum: `Vector.<T>` (341 files use it), `Dictionary` (162),
      `ByteArray` (88), reflection (23), XML (231 files touch it), and at least one file using
      namespaces (14 exist). **Done when:** they compile, and every manual fix is written up in
      `evidence/ax3-canary.md` as a repeatable rule. If the fixes are not expressible as rules,
      that is the finding — report it.
      **FAILED CANARY 2026-09-01:** all 24 files converted after 77 guarded AS3 repairs and one
      reproducible ax3 patch, but Haxe compilation failed with 123 source-located diagnostic lines
      across 12 canaries. Stop at the Phase 1 exit and reassess. See `evidence/ax3-canary.md`.
- [x] **G1d. Hybrid semantic foundation.** **COMPLETE AS SCOPED 2026-09-01.** Hand-port the
      Flash-specific semantic boundaries that poisoned G1c, then reserve ax3 plus guarded rewrite
      rules for leaf classes and message DTOs. Work in dependency order:
      - [x] Ordered `Map` / `SingleWriteMap` plus explicit replacements for Proxy property access.
        **PASS 2026-09-01:** 75 assertions pass on JavaScript and the Haxe interpreter; the normal
        OpenFL HTML5 build also passes. The scan found 252 AS3 files importing the custom Map and
        1,185 collision-sensitive packet registrations. Legacy null-key and shared-value removal
        quirks are deliberately covered. See `evidence/g1d_map_contract.json` and
        `evidence/g1d_map_verification.json`.
      - [x] XML/E4X compatibility foundation. **PASS 2026-09-01:** 44 assertions pass on
        JavaScript and the Haxe interpreter; the OpenFL HTML5 build passes. `XML`/`XMLList`
        implement explicit child/attribute access, ordered lists, text/name/coercion, copying,
        mutation, and serialization. The scanner now honestly labels shared member-name counts as
        lexical upper bounds. Representative real `DefineBinaryData` parity remains G3. See
        `evidence/g1d_xml_foundation.json` and `evidence/g1d_xml_verification.json`.
      - [x] ByteArray semantics. **PASS 2026-09-01:** a thin adapter over OpenFL corrects its
        platform-endian default to Flash/AIR big-endian while preserving explicit little-endian
        use. A real localhost HTML5 browser passed 41 assertions covering numeric widths, UTF-8,
        slicing, indexed access, position/length, zlib, raw deflate, and OpenFL adaptation; the
        normal SkyHaxe HTML5 build also passes. The corpus has 57 ByteArray files and 51
        constructors; `readObject`/`writeObject` occur only in vendored OpenVideoAds. See
        `evidence/g1d_bytearray_contract.json` and `evidence/g1d_bytearray_verification.json`.
      - [x] Reflection and dynamic definition lookup. **PASS 2026-09-01:** 21 assertions pass on
        both JavaScript and the Haxe interpreter, and the normal HTML5 build passes. Qualified
        names preserve AS3 `package::Class` spelling; interface checks do not run constructors;
        dynamic definitions use an explicit DCE-safe registry with a linked-class fallback. The
        measured first-party surface is 47 `getQualifiedClassName`, 4 `getDefinitionByName`, and
        1 `describeType` occurrence. See `evidence/g1d_reflection_contract.json` and
        `evidence/g1d_reflection_verification.json`.
      - [x] Component/runtime ownership and embedded-manifest primitives. **PASS 2026-09-01:** IID,
        IUnknown, ComponentDependency, InterfaceStruct/List, deferred interface queues, and DCE-safe
        manifest resolution pass as part of 91 runtime assertions on both JavaScript and the
        interpreter; the normal
        HTML5 build passes. The measured corpus has 50 IID classes, 432 IID constructions, 324
        dependency declarations, and 46 Component subclasses. All 35 embedded manifests are in the
        contract: 35 components and 36 IID declarations; the communication demo is the one
        component without an exported interface. See `evidence/g1d_runtime_contract.json` and
        `evidence/g1d_runtime_verification.json`.
      - [x] Platform-neutral Component/ComponentContext lifecycle core. **PASS 2026-09-01:**
        required and optional injection, synchronous/deferred readiness, dependency listener
        cleanup, exactly-once releases, queued IID routing, locked-provider announcement, and
        attach/detach ownership are included in the 91-assertion runtime suite. The OpenFL-facing
        shell deliberately remains with the asset/event boundary rather than depending on stubs.
      - [x] OpenFL asset/window boundary contracts needed by G2–G4b. **MEASURED 2026-09-01:**
        25 core asset files versus 245 core window files. The window corpus alone contains 56
        `flash.display`, 33 `flash.text`, 125 `flash.geom`, 90 `BitmapData`, 12 `htmlText`, and 79
        scroll-related occurrences. Proceed in bounded sub-gates: non-visual assets; AssetLibrary;
        browser-tested BitmapData ownership; final component shell; then a real layout canary.
        Full UI fidelity stays at G4b. See `evidence/g1d_asset_window_contract.json`.
        - [x] Non-visual asset contracts. **PASS 2026-09-01:** `AssetTypeDeclaration`, `IAsset`,
          `ILazyAsset`, `UnknownAsset`, `TextAsset`, and `XmlAsset` pass 29 assertions in a real
          OpenFL HTML5 browser. This covers String/ByteArray/XML conversion, lazy parsing, content
          identity, copy validation, ByteArray position advancement, and idempotent disposal. The
          normal HTML5 build passes. See `evidence/g1d_assets_contract.json` and
          `evidence/g1d_assets_verification.json`.
        - [x] AssetLibrary registration, lookup, alias, type, removal, and ownership contracts.
          **PASS 2026-09-01:** 43 assertions pass in a real HTML5 browser. The canary loads all
          153 supported text/XML assets and aliases from the read-only real
          `HabboCatalogCom_manifest.bin`; source/alias content identity matches and PNG content is
          explicitly deferred. The full 35-manifest contract contains 3,255 assets and 57 aliases.
          See `evidence/g1d_asset_library_contract.json` and
          `evidence/g1d_asset_library_verification.json`.
        - [x] BitmapDataAsset ownership in a real browser. **PASS 2026-09-01:** 31 assertions prove
          exact owned-byte accounting, borrowed alias identity, pixel survival after borrower
          disposal, Bitmap transfer, regions, offsets, flips, and balanced AssetLibrary unload.
          Encoded ByteArray input fails explicitly until G2 decodes it. This corrects the AS3
          double-ownership/accounting defect without cloning pixels. See
          `evidence/g1d_bitmap_asset_contract.json` and
          `evidence/g1d_bitmap_asset_verification.json`.
        - [x] Final OpenFL component shell. **PASS 2026-09-01:** 27 real-browser assertions cover
          root context ownership, real OpenFL events, immediate/deferred required dependencies,
          lock/unlock announcement, interface reference counts, direct/context disposal,
          zero-reference interface-component disposal, and balanced late delivery after waiter
          disposal. The 91-assertion lower runtime regression and normal HTML5 build remain green.
          See `evidence/g1d_component_shell_contract.json` and
          `evidence/g1d_component_shell_verification.json`.
        - [x] Minimal real XML window-layout browser canary. **PASS 2026-09-01:** 30 assertions
          in a real OpenFL HTML5 browser, zero console errors. `WindowParser` parses the read-only
          1,121-byte `HabboCatalogCom_redeemItemCodeWidget.bin` — not a synthetic fixture —
          and the test checks the layout/container/children hierarchy, positions and sizes, style
          and param fields, the URL-decoded caption, typed Boolean/String/int/Number variables, and
          real OpenFL `TextField` captions. `BitmapData.draw` of the parsed tree is then sampled
          for non-transparent pixels, so this proves structural parsing *and* real rendering.
          Skins, input behavior, scrolling, masks, and HTML links remain honestly at G4b. See
          `evidence/g1d_window_layout_contract.json` and
          `evidence/g1d_window_layout_verification.json`.
      Each slice needs focused Haxe tests, an HTML5 build, saved evidence, and a recorded mechanical
      call-site rewrite rule. **All enumerated slices pass**; 3,268 lines of hand-written Haxe
      across 33 files under `src/`, and no converted G1c output was copied in.
      **Done when:** the semantic
      foundation compiles and its behavior tests pass without copying failed canary output into
      `src/`; only then may G2 begin. **Met 2026-09-01.**

**Phase 1 exit:** G1c triggered the stop condition. The owner chose the hybrid strategy; G1d was
the required recovery gate and is now complete as scoped. Do not start Phase 2 merely because ax3
emitted files — start it because G1d's foundation is verified.

**Reproducibility repairs, 2026-09-01** (both were Standing Rule 7 gaps, not behaviour changes):

- `scripts/verify-g1d-{map,reflection,runtime,xml}.ps1` could not complete on Windows PowerShell
  5.1: `Set-Content -Encoding utf8NoBOM` is PowerShell 7 only and threw a parameter-binding error
  at the final write, after all the real work had already passed. They now write through
  `System.IO.File.WriteAllText` with `UTF8Encoding(false)`, which behaves identically on 5.1 and 7.
  All four were re-run end to end and independently reproduced their recorded counts: XML 44,
  Map 75, reflection 21, runtime 91.
- G1c's headline figure had no saved output — the hxml that produced it lives under gitignored
  `.toolchain/`. `evidence/g1c_compile_flash.log` is now committed alongside
  `evidence/g1c_compile_diagnostics.py`, which re-derives **123 source-located lines across 12
  files**, per-file counts included, and exits non-zero if that failure stops reproducing.

---

## Phase 2 — Vertical slice

Still not a port. One furni, one room, one window — end to end.

- [x] **G2. SWF reader.** **PASS 2026-09-01.** Haxe reads real furni SWFs and returns decoded
      pixels/binary/sound content for exported names. Scope is fixed by G0/P1c's data, not by
      assumption: **three containers** — FWS 1,596 ·
      CWS 20,862 · ZWS 38 in the measured, non-ignored inventory. SWF LZMA is non-standard: props
      at byte 12, data at 17, declared size replaced by the unknown-size sentinel. Six Gordon CWS
      streams omit Adler-32 but contain the complete declared body; tolerate only after exact
      length verification. **Four bitmap tags** — `DefineBitsLossless2`, `DefineBitsJPEG3`,
      `DefineBitsLossless`, and `DefineBitsJPEG2` (mandatory: 1,468 reachable Gordon exports).
      Plus `DefineBinaryData`, `DefineSound(MP3)`, and `SymbolClass`. **Done when:** output is
      pixel-identical to the Flash client's for at least 20 assets across several furni, one
      Gordon MP3 export decodes and plays, *and* the SWF is fetched **over HTTP, not from `C:\\`**
      — path-loading hides CORS, MIME and caching problems. Record cold and warm load timing.

      **Corpus correction, 2026-09-01.** The bullet above says "four bitmap tags" and PLAN said
      "two decoder families". Both understate it. `evidence/g2_embedded_format_survey.py` measured
      every JPEG-family character in the corpus: **all 1,468 reachable Gordon `DefineBitsJPEG2`
      characters are PNG**, `DefineBitsJPEG3` carries PNG 59 times, and **three `dcr/` files mix
      JPEG and PNG inside one SWF**. SWF 8 allows PNG and GIF89a inside those tags, so the tag id
      does not identify the codec — only the payload magic does, per character. Decoder scope is
      **zlib + JPEG + PNG**. A payload's separate JPEG3 alpha block must not be applied to a PNG,
      which carries its own; the first reference decoder made exactly that mistake and would have
      silently dropped alpha on all 1,468.

      Ordered sub-gates, because the container and codec risks are independent:
      - [x] **G2a. Containers, tag layer, and the zlib bitmap family.** **PASS 2026-09-01:**
        348 assertions and **44 assets compared byte-for-byte** against an independent
        Python/PIL reference, fetched **over HTTP** from a same-origin read-only corpus mount
        (`scripts/serve-g2.py`). Covers FWS, CWS and checksumless CWS containers, `SymbolClass`
        export resolution, `DefineBinaryData`, and `DefineBitsLossless`/`Lossless2` in the
        colormapped, PIX15, PIX24 and ARGB formats — including un-premultiplying alpha and
        stripping 32-bit scanline padding. Cold 0.065s / warm 0.033s across five canaries.
        Deferred files are asserted, not skipped. See `evidence/g2a_verification.json`.
      - [x] **G2b. PNG and JPEG payloads.** **PASS 2026-09-01:** 499 assertions and 68
        assets compared in a fresh real-browser tab with zero console errors. Eighteen JPEG
        characters decode through OpenFL/Chrome with exact SWF alpha; their RGB differs from
        Pillow by at most 1 channel value (mean 0.1931), which is the expected bounded variance
        between lossy JPEG decoders rather than false SHA-256 equality. One PNG character from
        `godin.swf` is byte-identical after canonicalizing invisible RGB below alpha 0, and proves
        per-character codec dispatch in a SWF that mixes JPEG and PNG. PNG-in-JPEG3 ignores the
        separate alpha block as required. See `evidence/g2b_verification.json`.
      - [x] **G2c. ZWS/LZMA container.** **PASS 2026-09-01:** all three real ZWS canaries decode
        in OpenFL/Chrome, including both BattleBall packs. SkyHaxe reconstructs SWF's non-standard
        LZMA-alone framing (properties at 12, data at 17, unknown-size sentinel) and rejects output
        unless its length exactly matches the SWF header. Correction: pinned Lime 8.3.2 does embed
        a JS LZMA core; its public wrapper mishandles the decoder's numeric-array return, so the
        reader normalizes that bounded result locally. Integrated regression: 927 assertions.
      - [x] **G2d. `DefineSound(MP3)`.** **PASS 2026-09-01:** all 24 reachable exports from
        `hh_game_bb.swf` and `hh_game_snowwar.swf` match format/rate/bits/channels/sample count,
        seek offset, length, and MP3 SHA-256. A trusted browser click started the largest verified
        MP3 through OpenFL, advanced to 154 ms, and stopped cleanly at 4% volume.
      - [x] **G2e. Parity with the Flash client itself.** **PASS 2026-09-01:** a separate Harman
        AIR 51.2.2 harness fetched the same files over HTTP, loaded exported symbol classes through
        Flash `ApplicationDomain`, instantiated 20 lossless bitmap assets across three furni, and
        matched exact straight-RGBA MD5 values with the shared independent contract. This is a
        real Flash VM/display reference, not a second Haxe decoder. See
        `evidence/g2e_flash_reference.json` and `evidence/g2_verification.json`.
- [x] **G3. XML shim against real blobs.** **PASS 2026-09-01.** Regenerate the lexical upper-bound contract with
      `evidence/e4x_api_contract.py`; do not treat shared names such as `length`, `parent`,
      `replace`, or `toString` as receiver-proven merely because their file also uses XML. The G1d
      compatibility layer covers that bounded candidate surface and records explicit E4X rewrite
      rules. Predicate filters occur once, in third-party code.
      **Done when:** the `DefineBinaryData` blobs of a representative corpus — not one file — parse
      to the same values the AS3 path produces. Include assets, visualization, logic and index
      blobs. **Verified:** 25 genuine blobs from five SWFs—exactly five each of assets,
      visualization, logic, index, and manifest—pass 375 assertions in a fresh OpenFL/Chrome tab
      with zero console errors. Raw bytes and independent Python XML metrics match. A separate
      AIR 51.2.2 harness instantiates the same exported `ByteArray` classes and native E4X matches
      root, ordered canonical structure, attributes, text nodes, depth, and tag counts for all 25.
      The set includes live `elephants.swf`. See `evidence/g3_verification.json` and
      `evidence/g3_flash_reference.json`.
- [x] **G4. Renderer under load.** **PASS 2026-09-01.** A real OpenFL display list held
      **160 decoded furni sprites** for **180.022 seconds / 13,495 frames**. The scene used five
      real SWFs over same-origin HTTP, overlapping depth order, a real `_display.mask`, seven
      filtered sprites, six additive sprites, and alpha-aware front-to-back picking. Repeated
      160→100→160 load cycles produced **2,700 releases and 2,700 reuses while creating only the
      initial 160 `ExtendedSprite`s**; pooled filters, blend modes, bitmap references, transforms,
      and mouse flags are reset before reuse. Render-update p95/p99/max were 0.1/0.1/0.5 ms;
      frame-interval p95 was 14 ms. The JS heap stayed within a 5.702 MiB range over 89 samples,
      with 21 drops of at least 0.5 MiB, so allocation/GC behavior is recorded rather than guessed.
      A separate Harman AIR 51.2.2 harness matched all 36 ARGB pixels, depth order, mask clipping,
      additive blend mode, and alpha 127/128/129 hit boundaries exactly. AIR exposed a real client
      quirk: its signed `>> 24` makes alpha 128 clickable at tolerance 128; SkyHaxe preserves that
      runtime behavior. **33 browser assertions, zero current-run console errors.** See
      `evidence/g4_verification.json`, `evidence/g4_flash_reference.json`, and
      `evidence/g4_renderer_contract.json`.
      Original gate contract retained below for regression context: a busy room, many overlapping objects.
      Must hold up on: sprite **pooling and reuse**, `_display.mask` clipping, per-sprite `filters`
      and `blendMode`, `hitTestPoint` picking with `alphaTolerance`, frame time, and
      allocation/GC over several minutes. **Done when:** it matches a Flash reference capture and
      the frame time is recorded in `evidence/`.
      Remember the room **is** a real display list (PLAN.md §1) — this gate tests OpenFL's
      fidelity, not merely its existence.
- [x] **G4b. Window and text — PASSED 2026-09-02, re-verified after correction.** The complete
      real login window renders at authored 1:1 scale with 39 assertions and no console errors.
      The clean client's AIR background/foreground artwork uses the same cover and bottom-right
      resize formulas. Its data-declared titlebar/frame dragging relationship works in the live
      production page, as do the skin XML's hovering and pressed button states; a real pointer
      check moved the window -40,-12 and left the fully composed window visible.

      **The first pass recorded matches only and passed with six visible defects**, all found by
      the owner in minutes: white button caption, button at its authored width, button off-centre
      once narrowed, caption not bold, title left-aligned, and the whole page CSS-scaled ~1.87x.
      Each is now listed with its cause and the source that settles it in
      `evidence/g4b_verification.json`, which carries a `differences_found_and_fixed` list. **A
      fidelity gate whose evidence can only record matches will keep passing broken output.**

      **Root cause was hand-written approximation.** Control appearance now comes from the data the
      client ships: `habbo_element_description_xml.bin` (332 rows binding type/style to skin and
      internal layout) and the `habbo_window_layout_*` documents, read through the existing parser.
      `BUTTON_TEXT_INSET`, `TITLE_BAR_TEXT_Y`, `resolveButtonWidth`, the per-control text-style
      defaults and the hardcoded frame content offset are **deleted**; `inherit_caption`,
      `expand_to_accommodate_children`, the resize-align and relative-scale params and `_CONTENT`
      are handled generically. The title bar's help and close buttons then appeared without being
      written, which is the point.

      The theme's `_CONTENT` node is a **3,36 design-time placeholder**. The real login layout's
      `margin_left/top/right/bottom` values override it at runtime, giving **6,25** and a 348×210
      content area, matching `FrameController`. The test and evidence now assert both layers rather
      than confusing the placeholder with live geometry.

      Typography is `truffle-text` 2.0.0 — HarfBuzz shaping and FreeType hinting over the client's
      own Ubuntu/Volter — because OpenFL's `TextField` cannot render Ubuntu at advanced
      anti-aliasing with sharpness 80 and thickness -15. `input` and `html` stay on `TextField` for
      caret and link behaviour. Geometry checks: title bar centre 174, title centre 174.125,
      button centre 174 against an authored 174.

      **Still a subset:** 8 of 44 internal layouts packaged, `WindowController` covers 17 of the
      original 148 functions, and `ElementDescription` ignores `intent`. See
      `evidence/g4b_window_contract.json` and `evidence/g4b_verification.json`.
- [x] **Phase 2 exit technical review/re-cost.** Reproducible census: 353 core source identities /
      37,787 lines; 245 / 26,379 are window code. SkyHaxe has 25 matching source paths plus 18 helpers,
      but the matching paths are Phase 2 contract slices, not full API ports. 123 interfaces,
      237 files at ≤80 lines, and 200 measured low semantic-pressure candidates support a
      generated pipeline (they are not yet claimed to be dependency-graph leaves); the
      31 files above 320 lines and the full window engine/components are the hard tail. M2 is now
      seven bounded gates with a 26–42 focused-engineering-day planning range. See
      `evidence/m2_recost.md` and `evidence/m2_core_recost.json`.

---

## Phase 3 — Bulk conversion

The owner accepted the refresh architecture on 2026-09-02. M2 is an upstream-refresh pipeline, not
a one-off port. `habbo-client-clean` remains authoritative throughout.

- [~] **M2a. Deterministic client sync pipeline.** Read a selected clean-client tree read-only;
      pin source/converter/rule/tool hashes; write generated Haxe plus a machine-readable exception
      manifest. Two identical runs must have the same tree hash. A one-file change in a copied
      fixture must produce only the expected generated/manifest delta. Generated files are never
      edited manually.

      **SCOPED PIPELINE PASS 2026-09-02; GATE STILL INCOMPLETE.** The pinned
      `assets + runtime + utils` batch reads **77 of 353 core AS3 files (21.8%)** and produces
      **79 Haxe files**; it excludes the 245-file `window/` tree. Two clean
      runs have the same tree SHA-256 (`502d0550…`), zero unpinned rules, and leave the clean client
      unchanged. **35 of 79 generated identities (44.3%)** now compile through a real OpenFL HTML5
      project. A compile-time guard proves generated resolution for all 35, including ten
      same-identity hand-written collisions. The copied-
      source update drill now changes `IIDCore.as` in a temporary fixture and proves that only
      `IIDCore.hx` changes across the 79-file output, with both sides deterministic and the real
      clean-client source/status unchanged. Production generated/manual cutover remains
      outstanding, so M2a stays `[~]`.

      The original four blockers are all cleared by 21 count-guarded normalizations and 13
      reproducible ax3 patches (**37 as of 2026-09-04**). Shared converter/runtime fixes now cover
      E4X, OpenFL Vector runtime
      checks, the isolated AS3 `ASError` boundary, and abstract XML/ByteArray `is`/`as` handling.
      The sync now fails closed on zero output, unverified determinism,
      unpinned rules, source mutation, Haxe/AS3 exception drift, unlisted/stale/unannotated
      exceptions, missing contract/API checks, and 55 clean-client UI/style inputs (including all
      44 internal layouts). `evidence/m2_exceptions.json` derives all 43 current core Haxe files
      plus the global `ASError` boundary: **26 transitional hand-written ports** and **18 platform
      adapters**. See
      `evidence/m2_sync_manifest.json`, `evidence/m2a_conversion_blockers.json`, and
      `evidence/m2_asset_inputs.json`; update proof is in `evidence/m2_update_drill.json` and the
      exact generated compile set is in `evidence/m2_compile_frontier.json`.
- [~] **M2b. Low semantic-pressure generated candidates.** Order by internal dependencies, then
      convert and compile the measured 200 ≤100-line candidates without Dictionary/XML/Proxy/
      namespace/reflection or Flash display/filter/network/sound/text pressure. Generalize guarded
      rules; do not add file-specific silent repairs. **Started:** 35 generated identities compile
      through the real OpenFL HTML5 target. The next cutover work is a selective override layer:
      blanket `src` precedence is invalid because transitional interfaces such as `IAsset` are
      intentionally narrower, while Proxy-backed `Map` still requires the semantic hand port.
- [ ] **M2c. Non-window core.** Reconcile all 108 `Core`/assets/communication/localization/runtime/
      utils identities (11,408 lines), including the full APIs behind the Phase 2 contract slices.
      G1/G1b/G2/G3 regressions must remain green.
- [ ] **M2d. Window declarations and leaves.** Enums, interfaces, events, iterators, motion,
      services, theme, and tools. No omitted member or unlisted stub.
- [ ] **M2e. Window engine.** Root + graphics + utils: 81 files / 11,588 lines. Complete lifecycle,
      state, internal layout, skin, event, text, geometry, and disposal behavior; retain G4b.
- [ ] **M2f. Window components.** 100 files / 11,169 lines in compileable behavior groups; retain
      real layout and interaction canaries as each family lands.
- [ ] **M2g. Whole-core refresh gate.** Every one of 353 original identities is exactly generated
      or an explicit exception; compile all core, audit TODO/stubs, rerun Phase 2, and rerun sync.
      Stop/re-cost if permanent exceptions exceed 15% of source identities or 25% of source lines, if
      generated files need routine manual edits, or if a one-file source update causes unrelated
      churn.
- [x] **M3. `com.sulake.room` + `habbo.room` — production room path.**

      **CUT OVER 2026-09-04.** The deterministic v11-v19 closures provide `RoomManager`, object
      factories, furniture logic and visualizations, `RoomMessageHandler`, `RoomRenderer`,
      `RoomSpriteCanvas`, and `RoomEngine`. The v19 increment contains 93 AS3 files and is pinned
      by `evidence/v19_room_engine_closure.json` and `evidence/v19_room_engine_sync.json`; the
      combined tree compiles through `project.room-engine.xml`.

      Public and guest rooms now use the generated engine for the shell, floor/wall furniture,
      avatars, cursor input, backgrounds, room ads, animation, state updates, and shared depth
      sorting. `GuestRoomEngine`, `GuestRoomFurniture`, `GuestRoomShell`, `SkyRoomCreator`, and
      `RoomTileCursorController` have been deleted. `RoomEngineRuntime`, the browser content
      loaders, connection adapter, and avatar asset manager remain intentional platform seams.

      Photo CORS is deferred. It does not reopen the room-engine gate.

      **Pipeline defects this closure exposed, all now gated:**
      - ax3 could report a parse error for one file, skip it, and still exit 0 — a run that
        staged 55 sources and produced 54 was reported green, and `AvatarVisualization` went
        missing. `sync.py` now fails when `staged != produced`.
      - Closures were typed against `habbo-client.swc` for anything outside their own file list,
        and SWC rest arguments are marked `TRestSwc`, which the `RestArgs` filter deliberately
        skips. Cross-closure calls were left unwrapped. Closures now stage a context, and
        `as3Swc` tells ax3 which SWCs hold AS3 this pipeline also converts.
      - Context staging then stopped copying `Globals.hx` back, because it belongs to no AS3
        source — so ax3's `untyped __global__` shim silently froze. It is copied explicitly now,
        and the shim routes through `ASCompat.globalFunction`, which has a real JS branch;
        `__global__` exists only on Flash and threw the moment `Component` queued a dependency.
- [ ] **M4. `habbo.communication`** (1,885) — 1,185 message classes of near-identical shape.
      Best scripted-conversion candidate; write the script, do not hand-port.
- [ ] **M5. `habbo.avatar`, `session`, `window`, `ui`.**
- [ ] **M6. Features** — `catalog`, `roomevents` (429), `navigator`, `inventory`, the games.
- [ ] **M7. Desktop shell** — only if wanted. `HabboAir.as` is a rewrite, not a translation.

Per-package definition of done: compiles · no `TODO`/stub left un-listed · behaviour spot-checked
against the Flash client for at least one real flow.

---

## Phase 4 — Whole-client gates

- [x] **G5. Avatar.** One avatar renders from a figure string. Proves `figuredata`/`figuremap`,
      the part cache and the avatar library path.
- [ ] **G6. Protocol.** Connect to the live emulator through `NitroWebsockets`, complete the
      **DH/RC4 handshake**, receive a room, render it. Proves `ByteArray` semantics end to end.
      The wire format is unforgiving and **fails silently** — see
      `habbo-client-clean/docs/protocol/wire-format.md`.
- [ ] **G7. Soak.** Enter and leave rooms repeatedly; watch memory and frame time. The AS3 client
      has known disposal hazards (pending image callbacks, `RoomPreviewer` sharing the live
      engine); a port inherits them.

---

## Reference

Behaviour questions go to `habbo-client-clean/docs/` — 45 pages, structurally verified,
`npm run docs:check` enforces citation integrity. Start at:

| Topic | Page |
|---|---|
| Component model, boot order | `docs/orientation/component-model.md` |
| Session state, room sessions | `docs/orientation/session.md` |
| Wire format, message pattern, encryption | `docs/protocol/` |
| Room engine, rendering, heightmaps | `docs/room/` |
| Asset registration and runtime loading | `docs/ui/asset-registration.md`, `docs/ui/assets-and-images.md` |
| What is ours vs upstream | `docs/orientation/fork-delta.md` |

**Known-wrong-before:** those docs claimed the room was not in the display list and that the window
toolkit did not use one. Both were corrected 2026-08-31 after review. If something in the docs
contradicts the code, the code wins — fix the doc in place.

---

## Drift check

Re-read this before resuming after any break:

- Am I working on the lowest unchecked gate, or did I skip one?
- Did I write to `habbo-client-clean` outside P2/P3, or to the asset corpus at all?
- Did I mark a gate done without producing its artefact?
- Have I made a claim in PLAN.md that the code no longer supports?
- Is there a measurement here with no saved script in `evidence/`?
- Did I edit generated Haxe, or fail to make an upstream exception-source change fail closed?
