# SkyHaxe — porting the Habbo-Sky client to Haxe

A plan, not a commitment. Written 2026-08-31 from measurements of
`c:/habbo/client/habbo-client-clean` (branch `wired2`) and the asset tree at `c:/habbo/ngh/`.
Every number below was counted, not estimated; where something is a judgement call it says so.

No SkyHaxe runtime has been built. This document exists to make the three decisions that set the timeline
*before* any code is written, because two of them are irreversible in practice.

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

So D1 stands, with the reader scoped as: **three containers (FWS/CWS/ZWS), two bitmap decoders
(lossless + JPEG), `DefineBinaryData`, `DefineSound(MP3)`, and `SymbolClass`.** Six checksumless
CWS files require tolerant streaming inflate followed by an exact SWF-header length check. Five
are reachable production content, including the configured `elephants.swf` pet, so this path is a
live G2 requirement rather than archive tolerance. Content assets stay untouched on disk and
unchanged in hosting.

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

**The shim is not three methods.** An early draft proposed `att` / `child` / `length`; the
corpus-derived contract (`evidence/e4x_contract.json`, 231 files touch XML) needs at least:

`length` (685) · `@attribute` (486) · `name` (189) · `text` (88) · `child` (83) · `toString` (80) ·
`attribute` (76) · `parent` (64) · `children` (41) · `replace` (38) · `hasOwnProperty` (31) ·
`appendChild` (16) · `copy` (14) · `localName` (7) · `toXMLString` (3)

Predicate filters (`.(@id == "x")`) occur **once**, in vendored third-party code. Whether
`org/openvideoads`, `com/hurlant`, `adobe/` and `deng/` are ported at all is a decision to take
explicitly, not to discover mid-conversion.

So E4X is still bounded — but it is a ~15-member shim, not a trivial one. **P2 is complete:** the
regenerated contract reports 0 first-party descendant sites and 1 untouched third-party site.

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
| **G1** | Toolchain | `haxe`, `haxelib`, `lime`, OpenFL installed; empty HTML5 project builds and runs. **None is installed today** — Node 24 and npm are |
| **G1b** | Transport | A minimal OpenFL HTML5 page connects through `NitroWebsockets`, exchanges binary frames, completes the opening protocol exchange, then disconnects and reconnects cleanly. Repeat from an **HTTPS page over `wss://`** with the real origin whitelist and proxy config, to surface mixed-content, certificate and origin problems now rather than at G6 |
| **G1c** | Converter canary | 20–30 deliberately awkward representative files pushed through ax3 and **compiled** by the current Haxe compiler. Pick them to hit the known-hard constructs: `Vector.<T>` (341 files), `Dictionary` (162), `ByteArray` (88), reflection (23), `XMLList` (70). Tells you whether the toolchain cooperates *before* committing to thousands of files |
| **G2** | SWF reader | Haxe code opens a real furni SWF, lists its `SymbolClass` names, and returns a `BitmapData` for one of them, matching the Flash client's output pixel-for-pixel |
| **G3** | XML shim | The same SWF's 5 `DefineBinaryData` blobs parse through the shim; asset/visualization/logic data reads back identically to the AS3 path |
| **G4** | Renderer under load | **Not one screenshot.** A busy room — many objects, overlapping depths — matching a Flash reference, *and* holding up on: sprite pooling and reuse, `_display.mask` clipping, per-sprite `filters` and `blendMode`, `hitTestPoint` picking with `alphaTolerance`, frame time, and allocation/GC behaviour over minutes. The room is a real display list (see §1), so this gate is testing OpenFL's fidelity, not just its existence |
| **G4b** | Window and text | One **real** window rendered from its XML layout: labels, HTML text with links, an input field, a scrolling item list, skins and a mask. OpenFL's `TextField` implements a subset of Flash's, and filters vary by target — UI/text failure would be as consequential as renderer failure, and it is cheaper to discover here |
| **G5** | Avatar | One avatar renders from a figure string — proves `figuredata`/`figuremap`, the part cache and the avatar library path |
| **G6** | Protocol | Connect to the live emulator, complete the DH/RC4 handshake, receive a room, render it. Proves `ByteArray` semantics end-to-end |

**G4 and G4b together are the decision point** — the renderer and the UI both have to hold.

What follows is **not** "mechanical". It is *estimable*, which is different: the volume becomes
predictable, but `com.sulake.core.window` still leans on Flash display semantics throughout, and
`GraphicContext`, `TextField` fidelity and filter behaviour will need real work per target.
Reassess after G4b, not before, and treat the M-series below as a plan to be re-costed at that
point rather than a schedule.

---

## 4. Bulk conversion, after G4

| Milestone | Scope | Notes |
|---|---|---|
| **M1** | Pre-conversion cleanup in AS3 | P2/P3 complete: 4 first-party descendant uses rewritten and ASI reliance fixed; review the 14 files using namespaces |
| **M2** | `com.sulake.core` (353 files) | Runtime, window toolkit, communication, assets. Everything else depends on it |
| **M3** | `com.sulake.room` + `habbo.room` (415) | Renderer and room engine |
| **M4** | `habbo.communication` (1,885) | Overwhelmingly mechanical — 1,185 message classes of near-identical shape. Good candidate for scripted conversion |
| **M5** | `habbo.avatar`, `session`, `window`, `ui` | |
| **M6** | Features | `catalog`, `roomevents` (429), `navigator`, `inventory`, the games |
| **M7** | Desktop shell | Only if wanted |

Converter: **ax3** over as3hx — compiler-grade, SWC-aware, production-used at InnoGames. Caveat:
its authors state they are "NOT planning to maintain and provide official support". Treat it as a
one-way tool you may end up patching, not a dependency.

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
| OpenFL `TextField.htmlText` too weak for habbopage | Medium | 150 `flash.text` imports across 74 files; **assess at G4b, not M5** |
| ax3 output needs more repair than expected | Medium | M2 is the canary — if `core` is painful, reconsider scope |
| Reflection (23 files, `describeType`/`getDefinitionByName`) | Medium | `MessageClassManager` and `ClassUtils` need hand-porting |
| 8.3 GB asset tree, ops load | Low under D1 | D1 exists to avoid touching it |
| Obfuscated symbols (9,463 distinct `_Str_NNNN`) | Low | Cosmetic; they port as-is |

---

## 6. What would make me stop

- **G0 shows furni SWFs are not uniform** — D1 collapses, and the project becomes the spritesheet
  rewrite instead, which is a different and much larger proposal.
- **G4 needs sustained fighting with OpenFL's rendering** — if the compositor cannot be made to
  behave, the value of the port drops sharply.
- **M2 (`core`) takes disproportionately long** — 353 files is 6% of the tree; if it is not
  substantially mechanical, 5,492 will not be.

---

## 7. Order of work

Superseded by **[CHECKLIST.md](CHECKLIST.md)**, which carries the full task list, the definition
of done per gate, and the standing rules an implementer must not drift from. In summary:

1. **P0–P3 are complete** — foundations, asset evidence, E4X cleanup, and ASI cleanup are verified.
2. **G1** empty OpenFL HTML5 build → **G1b** WebSocket transport spike through `NitroWebsockets`,
   including `wss://` from an HTTPS page → **G1c** ax3 conversion canary on 20–30 awkward files.
3. **G2** SWF reader, fetching over HTTP rather than from `C:\`, with pixel and timing checks.
4. **G3** XML shim against a representative corpus.
5. **G4** realistic room under load → **G4b** a real window with HTML text and input.
6. Only then treat the bulk conversion as schedulable — and re-cost it at that point.

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
