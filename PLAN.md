# SkyHaxe — porting the Habbo-Sky client to Haxe

A plan, not a commitment. Written 2026-08-31 from measurements of
`c:/habbo/client/habbo-client-clean` (branch `wired2`) and the asset tree at `c:/habbo/ngh/`.
Every number below was counted, not estimated; where something is a judgement call it says so.

The Phase 2 technical gates now pass, including the local WebSocket path, real SWF/XML assets,
renderer load, and first-visible Habbo window. This document records the decisions that set the
timeline before bulk conversion, including the requirement that the clean client remain the
authoritative, refreshable source.

**Current baseline (2026-09-04):** the production client uses the generated `RoomEngine`,
`RoomMessageHandler`, and `RoomSpriteCanvas` for both public and guest rooms. The temporary room
renderer and creator classes have been deleted. The detailed milestones below retain the path and
measurements that produced that result; descriptions of an earlier frontier are historical.

---

## Historical execution target — first runnable client

This section records the runnable-client frontier before the generated RoomEngine cutover. The
production build at that point booted the
real `HabboCommunicationDemo` login layout, read the selected
`c:/habbo/ngh/gamedata/external_dev_vars.txt` through a read-only HTTP mount, and routes SSO login
through one reusable HTML5 connection adapter. That adapter is also used by the two-cycle G1b
regression so the demo and tested transport cannot silently diverge.

The ordered runtime path is: **real login view → authenticate as John → dispatch the normal
post-auth bootstrap stream → enter and render one room**. The client now reaches the real room-entry
stream and renders the configured `netcafe` public room from its Gordon SWF and embedded XML:
44 authored room layers, 74 packet-supplied public objects / 81 sprites, and three real scale-32
avatars (Ray, Tongbits and John). Ray receives packet 1640 updates, walks smoothly, changes
direction, and sorts against the bar through the same depth list as the room rather than through a
special case. Room drag/pan also works. The production scale-32 `TileCursor.swf` is now driven by
the generated 25x24 floor-map parser; it selects only the map's 400 room tiles. Clicking sends the
generated-registry MoveAvatar id 3320 contract and John was observed walking from 22,12 to 17,13
through server UserUpdate packets. UserRemove and RoomReady lifecycle resets also prevent stale
avatars surviving a leave/re-entry.

That is still an intermediate boundary, not a completed client: normal floor/wall furniture,
effects, the hotel UI, full avatar actions and 15 currently unresolved avatar-part diagnostics
remain. Furniture-surface cursor routing and full object interactions are also not yet ported. The
public-room implementation contains no per-room coordinates or artwork; RoomReady and
`external_dev_vars.txt` select the SWF, and its own XML selects, places and depth-sorts its layers
and objects. M2 pipeline expansion remains subordinate to runnable-client dependencies. This keeps
`habbo-client-clean` authoritative while measuring progress by client behavior rather than
converted-file counts.

---

## 1. Why this is more tractable than it looks

The usual reason a Flash port fails is that the app is welded to Flash's display list and its
runtime. This client mostly is not:

- **The room renderer owns its own depth model.** `RoomSpriteCanvas` builds a sprite list and
  sorts it by a single `z` number per frame. **Correction (2026-08-31, from review):** it then
  applies that order to a **real Flash display list** — one pooled `ExtendedSprite`
  (`extends Bitmap`) per sprite, inserted with `addChild` / `addChildAt`
  (`habbo-client-clean/src/com/sulake/room/renderer/RoomSpriteCanvas.as:680`, `:685`), with real
  per-sprite `filters`, `blendMode`, `alpha`, a `_display.mask`, and Flash `hitTestPoint` with
  `alphaTolerance` for picking. An earlier draft of this plan claimed the room was not in the
  display list. That was wrong.
- **The window toolkit owns layout, skinning and routing — not the pixels.**
  `com.sulake.core.window` (245 files) has its own `WindowRenderer`, skin system and event
  routing, but `GraphicContext` backs every window with a `Bitmap`, `TextField`, `Shape`,
  `MorphShape` or `Sprite`
  (`habbo-client-clean/src/com/sulake/core/window/graphics/GraphicContext.as:59-76`).
- **The audio mixer is self-implemented.** `TraxSequencer` synthesises songs into a raw sample
  buffer.

So the client's *structure* is its own, but its **leaves are Flash display objects**. That is still
favourable — display objects, filters, blend modes and per-pixel hit testing are precisely what
OpenFL emulates — but it means the port depends on OpenFL's fidelity, not merely on OpenFL
existing. The bet is different from "we only need a canvas".

**Counter-weight:** 5,492 `.as` files, and an 8.3 GB runtime asset tree. This is not a weekend.

---

## 2. The three decisions

### D1 — Asset strategy: write a SWF reader in Haxe

**Decided: yes. This is the load-bearing decision and the evidence is unusually clear.**

The client's content model is runtime-loaded SWFs: `AssetLibrary.getClass()` calls
`_loader.hasDefinition(name)` then `getDefinition(name) as Class`
(`habbo-client-clean/src/com/sulake/core/assets/AssetLibrary.as:324-326`), pulling symbols out of
an `applicationDomain` by name.

**G0 has been run.** The claim was originally based on one file; it has now been tested across the
whole contracted corpus, and the finding is stronger than first stated — but with four corrections.

**The invariant that matters is not "these SWFs only contain four tags".** It is: *the only symbols
the client can reach are those exported through `SymbolClass`, and the runtime content contract
exports bitmaps, binary data and MP3 sounds.* Odd tags may exist in an archived client SWF; if
they are not exported by reachable content, the asset reader never has to serve them.

Measured across **18,608 files** under `c:/habbo/ngh/dcr/hof_furni/` (recursive, case-insensitive).
Scanner, gzipped per-symbol results and anchors in `evidence/`. **G0 exits non-zero on any
unreadable file or unexplained export — it is a regression test, not a report.** Current status:
**PASS, 0 unreadable.**

| Exported symbol backed by | Count |
|---|---|
| Bitmap | 268,647 |
| Binary data | 93,200 |
| Document root | 18,606 |
| Sound / font / no backing | 29 — all excluded, see below |
| **Shapes, sprites, video** | **0** |

Containers: **CWS 17,041 · FWS 1,543 · ZWS 24 (LZMA — all decode).**

**The reader's real scope, derived from the data rather than asserted:**

| Tag | Count | In scope |
|---|---|---|
| `DefineBitsLossless2` | 267,506 | yes |
| `DefineBinaryData` | 93,200 | yes |
| `DefineBitsJPEG3` | 1,135 | yes |
| `DefineBitsLossless` | 1 | **yes** — a single file, but real content |
| `DefineBitsJPEG2` | 5 | excluded here, but **required by Gordon** |

Two exclusions, both machine-readable in the scanner: `mp3/gamedata/` (`basicassets.swf`, a client
bundle in a stray subdirectory — the source of all 21 sound and 3 font exports) and `koekjes.swf`
(5 obfuscated names with no backing character; owner decision).

**Four corrections to the original claim:**

1. **Three container formats, not one.** Across all of `dcr/` and the non-ignored Gordon inventory: CWS 20,862 ·
   **FWS 1,596** · **ZWS 38 — LZMA**. SWF's LZMA framing is non-standard: props at byte 12, data at 17, and the
   declared size must be replaced with the unknown-size sentinel before liblzma will decode it.
2. **Four bitmap tags, not one.** `DefineBitsLossless2` dominates, but `DefineBitsJPEG3` (1,135),
   `DefineBitsLossless` (1) and `DefineBitsJPEG2` (5, excluded) all occur. "Two decoder families"
   is fair; "two tags" is not.
3. **Gordon is mixed, not generated wholesale.** NGHWin packages six boot-critical Gordon files
   (`HabboRoomContent`, three placeholders, `TileCursor`, `SelectionArrow`) and leaves the rest
   URL-driven. Current maps/config/source reach 3,270 production files; all are readable and stay
   in the asset contract. Runtime variables come from `external_dev_vars.txt`: it adds the live
   `elephants.swf` pet and explicitly names 12 public-room preload types. Three additional
   production `hh_room_*` files remain conservatively in scope by naming. The same directory also
   contains archived client/test SWFs, which is where the fonts and sprites come from. They are
   reported separately, never path-excluded.
   `flash-assets-PRODUCTION-202605152352-294132426` is outside the contract by owner decision.
4. **Sound is real content.** `hh_game_bb.swf` and `hh_game_snowwar.swf` are URL-loaded by the
   current client and export 24 MP3 sounds which game code actively plays. `DefineSound(MP3)` is
   therefore reader scope. Gordon also makes `DefineBitsJPEG2` mandatory (1,468 reachable
   exports), rather than conditional.

So D1 stands, with the reader scoped as: **three containers (FWS/CWS/ZWS), three bitmap decoders
(zlib + JPEG + PNG), `DefineBinaryData`, `DefineSound(MP3)`, and `SymbolClass`.** Six checksumless
CWS files require tolerant streaming inflate followed by an exact SWF-header length check. Five
are reachable production content, including the configured `elephants.swf` pet, so this path is a
live G2 requirement rather than archive tolerance. Content assets stay untouched on disk and
unchanged in hosting.

**Correction 5, from G2a (2026-09-01): PNG is a third decoder family, and the tag id does not
identify the codec.** SWF 8 allows PNG and GIF89a payloads inside `DefineBitsJPEG2`/`JPEG3`, and
Habbo relies on it: **all 1,468 reachable Gordon `DefineBitsJPEG2` characters are PNG**, `JPEG3`
carries PNG 59 times, and three `dcr/` files mix JPEG and PNG within one SWF. So "two decoder
families" above was wrong in the same way "two tags" was — dispatch on payload magic per
character, and never apply the JPEG3 alpha block to a PNG, which carries its own. Measured by
`evidence/g2_embedded_format_survey.py`; G2a's reader does this and its 44-asset comparison
passes.

Rejected alternatives:

- **OpenFL SWFLite bundles** — requires preprocessing all ~27k SWFs into a second format, forever,
  and SWFLite does not support sounds. It is designed for build-time authored assets, not a live
  content pipeline.
- **Spritesheet + JSON rewrite (the Nitro road)** — best long-term format, but it invalidates
  `RoomContentLoader`, `AssetLibrary`, the visualization XML path and the layout rasterizer at
  once, and doubles the hosted asset footprint. That is a different project, not a port.

**Confidence:** high — measured reproducibly, per-symbol results retained, gate fails loudly.
Three earlier passes were each wrong in a different way (flat listing, no LZMA, collapsed tag
names), and P1c corrected the later Gordon classification error. The correction history is in
`evidence/PROVENANCE.md`. **Re-run the scanners; do not trust this prose.** The "few hundred lines"
estimate for the reader is still a judgement call; LZMA, JPEG and MP3 decode push it upward.

### D2 — E4X: a shim, plus a mechanical rewrite

Haxe has no E4X. Neither converter handles it well — as3hx "will fail in some cases", ax3 supports
"a small, most commonly used subset" and tells you to rewrite the AS3 first. Measured usage:

| Pattern | Occurrences |
|---|---|
| Attribute read `.@name` | 599 |
| Child element access | 734 |
| `:XML` / `:XMLList` type annotations | 845 |
| `new XML(...)` | 35 |
| `.length()` | 221 |
| **Descendants before P2** | **4 first-party + 1 third-party** |

The descendant operator was the hardest part to emulate. P2 replaced all **4 first-party sites**
with explicit depth-first child walks while preserving document order and first-match behavior.
The 1 remaining site is in vendored third-party code and stays outside the first-party contract.

**The shim is not three methods.** An early draft proposed `att` / `child` / `length`. The lexical
contract (`evidence/e4x_contract.json`, 231 files touch XML) gives this conservative upper bound:

`length` (685) · `@attribute` (486) · `name` (189) · `text` (88) · `child` (83) · `toString` (80) ·
`attribute` (76) · `parent` (64) · `children` (41) · `replace` (38) · `hasOwnProperty` (31) ·
`appendChild` (16) · `copy` (14) · `localName` (7) · `toXMLString` (3).

**Correction 2026-09-01:** those are member-name occurrences inside files that touch XML, not
receiver-proven calls. Common names such as `length`, `name`, `parent`, `replace`, `copy`, and
`toString` also belong to arrays, display objects, strings, and other classes in the same files.
The scanner now labels them as an upper bound. G1d implements the cheap bounded compatibility
surface and explicit rewrite rules; G3 is where representative real blobs must prove parity.

Predicate filters (`.(@id == "x")`) occur **once**, in vendored third-party code. Whether
`org/openvideoads`, `com/hurlant`, `adobe/` and `deng/` are ported at all is a decision to take
explicitly, not to discover mid-conversion.

So E4X is still bounded, but it is not safe to infer its exact size from shared member names.
**P2 is complete:** the regenerated contract reports 0 first-party descendant sites and 1
untouched third-party site. The G1d XML foundation passes 44 assertions on both JavaScript and the
Haxe interpreter; its remaining claim is deliberately limited until G3 exercises real blobs.

### D3 — Target: HTML5 first, desktop second

Browser first, because it needs no shell rewrite. The AIR desktop shell is only 5 files touching
`flash.desktop` / `flash.filesystem`, but `HabboAir.as` (1,600 lines: config, overlays, hotkeys,
reload, modal guard) is a rewrite rather than a translation, against Electron or hxcpp. Defer it.

**Transport is solved, subject to test.** `openfl.net.Socket` uses WebSockets on HTML5 rather than
raw TCP, and the server already has a matching bridge: the `NitroWebsockets-3.2` plugin
(`c:/habbo/server/arcturus-community/plugins/`) binds a separate WebSocket listener, converts
binary frames to Netty `ByteBuf` and back, and reuses Arcturus's existing decoder, rate-limiting,
encryption and outgoing-encoder pipeline. It registers `ws.nitro.host`, `ws.nitro.port`,
`ws.nitro.ip.header` and `websockets.whitelist`, and supports origin whitelisting, proxy IP
headers and optional TLS.

`SocketConnection.as` already writes binary and flushes per packet, so its Haxe equivalent should
need little transport-specific code. **No core server modification appears necessary.**

Caveats carried into G1b: the jar ships **no source**, and its embedded POM says it was built
against Habbo 3.0.0 while this server is 4.0.3-beta. The APIs it uses still exist, but that is a
compile-time observation, not a runtime one. Use it for the prototype; for production, build a
source-controlled equivalent against the current API.

---

## 3. Vertical slice — prove the risk before porting anything

Do **not** start by converting 5,492 files. Build the smallest thing that exercises every risky
decision at once: **load one furni SWF from `c:/habbo/ngh/dcr/hof_furni/` and draw it, correctly
depth-sorted, in an isometric room.**

That single slice exercises D1 (SWF reading), D2 (visualization XML is E4X-parsed), the geometry
maths, and the sprite compositor. If it works, the rest is volume. If it does not, stop.

### Gates

Each gate is a thing you can look at, not a percentage.

| Gate | Proves | Done when |
|---|---|---|
| **G0** | ✅ **PASSED 2026-09-01** | All 18,611 `dcr/` SWFs scanned; Gordon's runtime contract derived from `external_dev_vars.txt` passes across 3,270 files. Required exports are bitmap, binary, root, and 24 reachable MP3 sounds. Five live files require checksumless-CWS tolerant inflate, including `elephants.swf`. The non-ignored Gordon inventory remains in evidence, including mixed archived-client files. Scanners exit non-zero on reader-contract regressions |
| **G1** | ✅ **PASSED 2026-09-01** | Project-local Haxe 4.3.7, Neko 2.4.1, Haxelib 4.1.1, Lime 8.3.2, and OpenFL 9.5.2 are archive-hash-pinned. The minimal HTML5 target builds and renders a 960×540 canvas over HTTP with deterministic DOM and console readiness markers and no console errors. Evidence: `evidence/g1_toolchain.json` |
| **G1b** | ✅ **LOCAL PASS 2026-09-01** | OpenFL HTML5 connected through the unmodified `NitroWebsockets-3.2` jar and authenticated as John twice using the real 2016 packet framing (`ClientHello` → `UniqueID` → SSO → `InfoRetrieve`). Binary frames worked both ways; two clean closes and one reconnect completed. The production HTTPS/`wss://` certificate, origin, and proxy check is explicitly deferred and remains a deployment follow-up. Evidence: `evidence/g1b_websocket_transport.json` |
| **G1c** | ❌ **FAILED CANARY 2026-09-01** | All 24 deliberately awkward files converted after 77 guarded AS3 repairs and one reproducible ax3 generator patch, but Haxe 4.3.7 compilation failed: 123 source-located diagnostic lines across 12 canaries. Failures include E4X, Proxy/namespace signatures, Dictionary boundaries, property access, arity, control flow, and interface typing. Phase 1 stop condition reached. Evidence: `evidence/ax3-canary.md` |
| **G1d** | ✅ **PASSED 2026-09-01** | Owner-approved hybrid foundation. All ten enumerated slices pass: Map, XML/E4X, ByteArray, reflection, runtime/lifecycle, non-visual assets, AssetLibrary, BitmapDataAsset, final OpenFL component shell, and a genuine XML window-layout canary. Its deferred full-UI fidelity work was later closed by G4b. |
| **G2** | ✅ **PASSED 2026-09-01** | Complete integrated browser regression: **927 assertions, 118 compared exports, zero console errors**, over same-origin HTTP. Covers FWS/CWS/checksumless-CWS/ZWS, `SymbolClass`, binary data, all measured zlib bitmap forms, per-character PNG/JPEG dispatch, exact JPEG3 alpha, the final big-endian ARGB `BitmapData` upload, and all 24 reachable MP3s; trusted-click OpenFL playback advanced to 154 ms. A separate AIR 51.2.2 Flash harness exactly matched 20 RGBA bitmap captures across three furni. Evidence: `evidence/g2_verification.json`, `evidence/g2e_flash_reference.json` |
| **G3** | ✅ **PASSED 2026-09-01** | 25 real `DefineBinaryData` XML blobs across five SWFs: five each of assets, visualization, logic, index, and manifest. OpenFL/Chrome passes 375 assertions with zero console errors; raw bytes and independent metrics match. AIR 51.2.2 native E4X independently matches all structural/value metrics for all 25, including live `elephants.swf`. Evidence: `evidence/g3_verification.json`, `evidence/g3_flash_reference.json` |
| **G4** | ✅ **PASSED 2026-09-01** | 160 real decoded furni sprites ran for 180.022s / 13,495 frames in a real OpenFL display list over HTTP. Depth ordering, mask, 7 filtered sprites, 6 additive sprites and alpha picking pass; 2,700 shrink/grow releases were all reused with creation fixed at 160. Render p95 0.1ms, frame-interval p95 14ms; heap range 5.702 MiB with 21 observed GC drops. AIR 51.2.2 exactly matched the 36-pixel ARGB reference plus order/mask/blend and alpha 127/128/129 boundaries. Evidence: `evidence/g4_verification.json` |
| **G4b** | ✅ **PASSED 2026-09-02** | The complete first-visible 360×242 `HabboCommunicationDemo` login window renders from its real XML with production bitmap skins, multiply colorization, internal frame layout, labels, editable SSO input and drop shadow. The theme's 3,36 placeholder is correctly overridden by the app layout's live 6,25 margins. Dynamic status captions re-render through Truffle rather than an obsolete TextField. The AIR wrapper's real background/foreground images use its exact resize formulas; production window-param titlebar dragging and data-declared button hovering/pressed states now work generically. A declared real catalogue fragment supplies only the HTML-link and masked scrolling-list behavior absent from login XML. 39 browser assertions plus live pointer drag/hover checks pass at authored scale with zero console errors; the primary window matches the actual NGHWin Harman AIR client side-by-side. Evidence: `evidence/g4b_verification.json` |
| **G5** | Avatar | One avatar renders from a figure string — proves `figuredata`/`figuremap`, the part cache and the avatar library path |
| **G6** | Protocol | Connect to the live emulator, complete the DH/RC4 handshake, receive a room, render it. Proves `ByteArray` semantics end-to-end |

**G4 and G4b together are the decision point** — both now hold. Phase 2 is technically complete;
the owner accepted the refresh architecture and M2a/M2b are now in progress.

What follows is **not** "mechanical". It is *estimable*, which is different: the volume becomes
predictable, but `com.sulake.core.window` still leans on Flash display semantics throughout, and
`GraphicContext`, `TextField` fidelity and filter behaviour will need real work per target.

**End-goal invariant, confirmed by the owner 2026-09-02:** `habbo-client-clean` stays authoritative.
Updating it must normally mean rerunning a deterministic conversion pipeline and reviewing a
bounded generated diff—not substantially rewriting SkyHaxe. Hand-maintained semantic adapters are
allowed only through an explicit exception manifest that fails when its AS3 counterpart changes.

The Phase 2 exit review is saved in `evidence/m2_recost.md`. M2 is re-costed as 26–42 focused
engineering days across seven bounded gates. This is a planning range, not a delivery promise.

---

## 4. Bulk conversion, after G4

| Milestone | Scope | Notes |
|---|---|---|
| **M1** | Pre-conversion cleanup in AS3 | P2/P3 complete: 4 first-party descendant uses rewritten and ASI reliance fixed; review the 14 files using namespaces |
| **M2a** | Refresh pipeline — `[~]` | The current 77/353-core-file slice (no `window/`) emits 79 Haxe deterministically; its one-file copied-source drill changes only the generated counterpart; production cutover remains |
| **M2b** | 200 measured low semantic-pressure candidates — `[~]` | 35/79 generated identities compile through OpenFL HTML5 (44.3% of this slice), with compiler-enforced generated precedence across ten collisions; expand in dependency order |
| **M2c** | Non-window core (108 files / 11,408 lines) | Full APIs for runtime/assets/utils/localization/communication/Core; retain G1–G3 |
| **M2d** | Window declarations/leaves | Interfaces, enums, events, iterators, motion, services, theme, tools |
| **M2e** | Window engine (81 files / 11,588 lines) | Root, graphics and utils; lifecycle/state/layout/skin/event/text/disposal; retain G4b |
| **M2f** | Window components (100 files / 11,169 lines) | Land in behavior groups with real layout/interaction canaries |
| **M2g** | Whole-core refresh gate | All 353 identities generated or explicit exceptions; compile, no-stub audit, deterministic rerun, Phase 2 regression |
| **M3** | `com.sulake.room` + `habbo.room` (415) | Renderer and room engine |
| **M4** | `habbo.communication` (1,885) | Overwhelmingly mechanical — 1,185 message classes of near-identical shape. Good candidate for scripted conversion |
| **M5** | `habbo.avatar`, `session`, `window`, `ui` | |
| **M6** | Features | `catalog`, `roomevents` (429), `navigator`, `inventory`, the games |
| **M7** | Desktop shell | Only if wanted |

Converter: **ax3** over as3hx — compiler-grade, SWC-aware, production-used at InnoGames. Caveat:
its authors state they are "NOT planning to maintain and provide official support". Treat it as a
one-way tool you may end up patching, not a dependency.

`as2hx` was reconsidered on 2026-09-01 after an owner suggestion. Despite its name it accepts AS3,
but its own documentation says it is incomplete, performs no semantic analysis, turns `Function`
and `Class` into `Dynamic`, and requires semicolons after every statement. That makes it a possible
source of syntax-level leaf rewrite ideas, not a replacement for ax3 or the G1d hand-ported
semantic boundaries. Do not add a second bulk-conversion pipeline unless a measured leaf canary
beats the existing ax3 + guarded-rule result.

`[Embed]` (235 files) maps onto OpenFL's asset system; that is mechanical but touches every Com.

---

## 5. Risks

| Risk | Severity | Mitigation |
|---|---|---|
| ~~Runtime content exports something the reader cannot serve~~ | **Closed** | G0/P1c derive and scan the DCR and Gordon contracts; both pass |
| LZMA (`ZWS`) container adds unplanned work | Low | 38 files total; bounded, but must be in the reader from the start |
| Live Gordon CWS files omit Adler-32 trailers | **High if missed** | G2 must use tolerant streaming inflate and accept only exact SWF-header-length output; five reachable files depend on it, including `elephants.swf` |
| Gordon game packs require SWF sound extraction | Medium | Implement `DefineSound(MP3)` in G2; 24 reachable exports, all MP3 |
| Four current map entries have no file in the configured production set | Medium | Track as corpus/config completeness: `flycarpet`, `zombieduck`, `hh_human_50_fx`, `hh_human_fx`; the owner-excluded newer subtree is not a fallback |
| `ByteArray` / endianness differences break the wire format | **High** | G6; the protocol is unforgiving and fails silently |
| OpenFL `TextField.htmlText` too weak for habbopage | Medium | G4b proves the measured link/formatting subset, including HTTP-to-event rewriting, but not every complex habbopage; retain targeted tests while porting the 150 imports across 74 files |
| ax3 cannot preserve Flash semantics at core boundaries | **Confirmed by G1c** | Use the G1d hybrid boundary: hand-port Map/Proxy, XML/E4X, ByteArray/reflection/runtime contracts; use ax3 only where guarded, mechanical repairs compile and test |
| Reflection (23 files, `describeType`/`getDefinitionByName`) | Medium | `MessageClassManager` and `ClassUtils` need hand-porting |
| 8.3 GB asset tree, ops load | Low under D1 | D1 exists to avoid touching it |
| Obfuscated symbols (9,463 distinct `_Str_NNNN`) | Low | Cosmetic; they port as-is |

---

## 6. What would make me stop

- **G0 shows furni SWFs are not uniform** — D1 collapses, and the project becomes the spritesheet
  rewrite instead, which is a different and much larger proposal.
- **G4 needs sustained fighting with OpenFL's rendering** — if the compositor cannot be made to
  behave, the value of the port drops sharply.
- **M2 cannot remain refreshable** — stop if generated output is nondeterministic, a one-file
  source change causes unrelated churn, generated files require routine manual repair, or permanent
  exceptions exceed 15% of source identities / 25% of core source lines. A first build that cannot absorb
  later `habbo-client-clean` changes is not success.

---

## 7. Order of work

Superseded by **[CHECKLIST.md](CHECKLIST.md)**, which carries the full task list, the definition
of done per gate, and the standing rules an implementer must not drift from. In summary:

1. **P0–P3 are complete** — foundations, asset evidence, E4X cleanup, and ASI cleanup are verified.
2. **G1** and the localhost **G1b** WebSocket transport spike are complete. **G1c failed** on 24
   awkward files despite guarded repairs. The owner approved the **G1d hybrid strategy** on
   2026-09-01: hand-port semantic boundaries and retain ax3 for suitable leaves/DTOs. The production
   HTTPS/`wss://` transport check remains a deployment follow-up.
3. **G1d is complete as scoped** (2026-09-01). All ten slices pass with saved evidence: ordered
   Map/SingleWriteMap and Proxy-access rewrites; XML/E4X; ByteArray; reflection and dynamic
   definition lookup; runtime ownership, embedded manifests, and the platform-neutral
   Component/ComponentContext lifecycle core; then the OpenFL asset/window boundary — non-visual
   assets, AssetLibrary, BitmapDataAsset ownership, the final component shell, and the real XML
   window-layout canary. **G2 is therefore unblocked.**
   G2 now passes end to end for its scoped reader contract. G3's representative real XML-blob
   parity suite and G4's sustained renderer gate now pass.
4. **G3** XML shim against a representative corpus.
5. ~~**G4** realistic room under load~~ ✅ → ~~**G4b** complete first-screen window plus HTML/link/list behavior~~ ✅.
6. Phase 2 now holds, the owner accepted the technical re-cost, and M2a has a deterministic
   scoped pass plus a bounded one-file update proof. The current runnable-client frontier also has
   a deterministic 77-file avatar/parser closure and a live scale-32 room proof. Next close the
   unresolved avatar-part/action gaps, then continue the room and hotel-UI dependency path; do not
   substitute converted-file counts for visible client behavior.
7. **The generated room stack is the production path (2026-09-04).** `RoomMessageHandler`,
   `RoomRenderer`, `RoomSpriteCanvas`, and `RoomEngine` landed through deterministic closures and
   now own public and guest room objects in one depth-sorted canvas. The temporary room creator,
   guest-room renderer, furniture compositor, shell, and cursor controller were removed.

   Browser-only responsibilities remain explicit seams: `RoomEngineRuntime` supplies component
   dependencies, `SkyRoomContentLoader`/`RoomContentLoader` load SWFs without Flash's
   LibraryLoader/FZip stack, and the HTML5 connection adapter owns transport. New room behaviour
   belongs in generated client code or one of those named seams, not in
   `HabboCommunicationDemo`.

---

## 8. Evidence

`evidence/` holds the scanner, the per-symbol results and `PROVENANCE.md` (the client commit, its
dirty state, corpus paths and the correction history). Re-run rather than trusting the prose here:

```
python evidence/g0_scan_swf_exports.py c:/habbo/ngh/dcr/hof_furni --csv out.csv
```

---

## Notes

- The existing client stays authoritative throughout. Nothing in this plan modifies
  `habbo-client-clean` except the small P2/P3 cleanups, which are independently useful.
- The client's own documentation (`habbo-client-clean/docs/`) is the reference for how each
  subsystem behaves. **Two of its claims were wrong** — that the room was not in the display list,
  and that the window toolkit did not use one — and were corrected on 2026-08-31 after review.
- Asset tree is read-only from this project's perspective under D1.
