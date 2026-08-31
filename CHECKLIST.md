# SkyHaxe — implementation checklist

Companion to [PLAN.md](PLAN.md). The plan holds the reasoning; this holds the order of work and
the definition of done. **Read the Standing Rules before the first task and re-read them whenever
you resume.**

Status key: `[ ]` not started · `[~]` in progress · `[x]` done and verified · `[!]` blocked

---

## Standing rules

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

---

## Phase 0 — Foundations

- [x] **P0. Put SkyHaxe under version control.** Initialized on `main`; foundation commit
      `3eafb63` contains `PLAN.md`, `CHECKLIST.md`, and the initial evidence set.
- [x] **P1. G0 — asset invariant.** **PASS** 2026-08-31 (exit 0, 0 unreadable, 18,608 files).
      Scanner `evidence/g0_scan_swf_exports.py`, results `evidence/g0_hof_furni.csv.gz`,
      anchors `evidence/PROVENANCE.md`. Re-run it rather than trusting any figure.
- [x] **P1b. Provenance anchored.** Commit `9b265927b277`, `git diff HEAD` sha256
      `5ce21ff780421d0d`, 89 tracked-modified + 226 untracked, artefact hashes and correction
      history — `evidence/PROVENANCE.md`. A commit id plus "dirty" is not reproducible; the diff
      hash is what pins it.
- [x] **P1d. Baseline decision recorded.** The owner delegated this decision on 2026-08-31.
      Do **not** create a synthetic commit from the client's 89 tracked modifications and 226
      untracked files: that would capture unrelated in-progress work. Retain the verified
      commit + diff hash + untracked manifest anchor until the client tree naturally reaches a
      clean owner-created commit, then replace the anchor.
- [x] **P1c. Extend G0 to the other corpora.** Whole `dcr/`: PASS, 18,611 files, 0 unreadable.
      Gordon is mixed, so `evidence/g0_gordon_contract.py` derives reachability from current maps,
      pet config, AS3 literals, public-room naming, and NGHWin's six local files: PASS across
      3,269 reachable production files, including 24 required MP3 sounds and 1,468 JPEG2 exports.
      Six checksumless-but-complete CWS files are accepted only after exact header-length checks.
      Two truly truncated SWFs and all font/sprite exports are confined to unclassified archived
      client/test files. Four map entries have no configured-production file and remain explicit
      corpus warnings. Owner decision: ignore the 2,891-file
      `flash-assets-PRODUCTION-202605152352-294132426` subtree.
- [ ] **P2. E4X descendant rewrite** in `habbo-client-clean`. **Four first-party sites**, verified
      by `evidence/e4x_api_contract.py`:
      `avatar/alias/AssetAliasCollection.as:43` (`..alias`),
      `avatar/geometry/GeometryBodyPart.as:22` (`..item`),
      `battleball/BattleBallArenaHud.as:362` and `battleball/BattleBallLobbyWindow.as:385`
      (`.descendants()`). Rewrite to explicit child walks; confirm the client still builds.
      A fifth site is in vendored `org/openvideoads` — leave it, and decide separately whether that
      tree is ported at all.
- [ ] **P3. Fix the ASI reliance** at `habbo-client-clean/src/com/sulake/habbo/communication/HabboMessages.as:1674`
      (missing semicolon). ax3 has no automatic-semicolon-insertion support.

---

## Phase 1 — Prove the platform

Nothing is ported in this phase. Every task is a spike that can kill the project cheaply.

- [ ] **G1. Toolchain.** Install `haxe`, `haxelib`, `lime`, `openfl`. **Done when:** an empty
      OpenFL HTML5 project builds and opens in a browser. Record exact versions in
      `evidence/PROVENANCE.md` — OpenFL behaviour is version-sensitive.
- [ ] **G1b. WebSocket transport.** Minimal OpenFL HTML5 page → `NitroWebsockets-3.2` plugin on
      Arcturus. **Done when:** binary frames go both ways, the opening protocol exchange completes,
      and disconnect/reconnect is clean. **Then repeat from an HTTPS page over `wss://`** with the
      real origin whitelist and proxy headers configured.
      **Do not defer the `wss://` half** — mixed-content, certificate and origin failures are
      cheap now and expensive at G6.
      Note: the plugin jar ships no source and its POM targets Habbo 3.0.0 against a 4.0.3-beta
      server. Runtime verification is the point of this gate.
- [ ] **G1c. Converter canary.** Pick **20–30 deliberately awkward** files and run ax3 → Haxe →
      **compile**. Cover, at minimum: `Vector.<T>` (341 files use it), `Dictionary` (162),
      `ByteArray` (88), reflection (23), XML (231 files touch it), and at least one file using
      namespaces (14 exist). **Done when:** they compile, and every manual fix is written up in
      `evidence/ax3-canary.md` as a repeatable rule. If the fixes are not expressible as rules,
      that is the finding — report it.

**Phase 1 exit:** if G1b or G1c fails badly, stop and reassess. Do not start Phase 2 to "see how it
goes".

---

## Phase 2 — Vertical slice

Still not a port. One furni, one room, one window — end to end.

- [ ] **G2. SWF reader.** Haxe reads a real furni SWF and returns a `BitmapData` for a named
      symbol. Scope is fixed by G0/P1c's data, not by assumption: **three containers** — FWS 1,596 ·
      CWS 20,862 · ZWS 38 in the measured, non-ignored inventory. SWF LZMA is non-standard: props
      at byte 12, data at 17, declared size replaced by the unknown-size sentinel. Six Gordon CWS
      streams omit Adler-32 but contain the complete declared body; tolerate only after exact
      length verification. **Four bitmap tags** — `DefineBitsLossless2`, `DefineBitsJPEG3`,
      `DefineBitsLossless`, and `DefineBitsJPEG2` (mandatory: 1,468 reachable Gordon exports).
      Plus `DefineBinaryData`, `DefineSound(MP3)`, and `SymbolClass`. **Done when:** output is
      pixel-identical to the Flash client's for at least 20 assets across several furni, one
      Gordon MP3 export decodes and plays, *and* the SWF is fetched **over HTTP, not from `C:\\`**
      — path-loading hides CORS, MIME and caching problems. Record cold and warm load timing.
- [ ] **G3. XML shim.** **First regenerate the API contract** with
      `evidence/e4x_api_contract.py`, then implement what it lists — currently **~15 members**
      (`length`, `@attribute`, `name`, `text`, `child`, `toString`, `attribute`, `parent`,
      `replace`, `children`, `hasOwnProperty`, `appendChild`, `copy`, `localName`, `toXMLString`),
      not the three an early draft guessed at. Predicate filters occur once, in third-party code.
      **Done when:** the `DefineBinaryData` blobs of a representative corpus — not one file — parse
      to the same values the AS3 path produces. Include assets, visualization, logic and index
      blobs.
- [ ] **G4. Renderer under load.** **Not one screenshot.** A busy room, many overlapping objects.
      Must hold up on: sprite **pooling and reuse**, `_display.mask` clipping, per-sprite `filters`
      and `blendMode`, `hitTestPoint` picking with `alphaTolerance`, frame time, and
      allocation/GC over several minutes. **Done when:** it matches a Flash reference capture and
      the frame time is recorded in `evidence/`.
      Remember the room **is** a real display list (PLAN.md §1) — this gate tests OpenFL's
      fidelity, not merely its existence.
- [ ] **G4b. Window and text.** One real window from its XML layout: labels, HTML text **with
      links**, an input field, a scrolling item list, skins, and a mask. OpenFL's `TextField` is a
      subset of Flash's and filters vary by target. **Done when:** it renders and behaves against a
      Flash reference. UI failure is as consequential as renderer failure.

**Phase 2 exit — the decision point.** G4 *and* G4b must both hold. Re-cost Phase 3 here; do not
treat the remaining work as "mechanical", because `com.sulake.core.window` leans on Flash display
semantics throughout.

---

## Phase 3 — Bulk conversion

Only after a human has reviewed the Phase 2 exit.

- [ ] **M2. `com.sulake.core`** (353 files) — runtime, window toolkit, communication, assets.
      **This is the canary for the whole conversion.** It is 6% of the tree; if it is not
      substantially mechanical, 5,492 files will not be. Report honestly before continuing.
- [ ] **M3. `com.sulake.room` + `habbo.room`** (415) — renderer and room engine.
- [ ] **M4. `habbo.communication`** (1,885) — 1,185 message classes of near-identical shape.
      Best scripted-conversion candidate; write the script, do not hand-port.
- [ ] **M5. `habbo.avatar`, `session`, `window`, `ui`.**
- [ ] **M6. Features** — `catalog`, `roomevents` (429), `navigator`, `inventory`, the games.
- [ ] **M7. Desktop shell** — only if wanted. `HabboAir.as` is a rewrite, not a translation.

Per-package definition of done: compiles · no `TODO`/stub left un-listed · behaviour spot-checked
against the Flash client for at least one real flow.

---

## Phase 4 — Whole-client gates

- [ ] **G5. Avatar.** One avatar renders from a figure string. Proves `figuredata`/`figuremap`,
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
