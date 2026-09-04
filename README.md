# SkyHaxe

SkyHaxe is the measured, gated Haxe/OpenFL port of the NGH Habbo client. The production HTML5
path authenticates against NGH and renders public and guest rooms through the generated
`RoomEngine`, `RoomMessageHandler`, and `RoomSpriteCanvas`. Hand-written code is limited to the
browser/runtime seams, asset loading, application bootstrap, and the hotel UI that has not yet
been ported.

The legacy room renderer has been removed. Room shell, floor and wall furniture, avatars,
cursor/walking, room dragging, backgrounds, ads, state changes, and animation share the generated
engine path. Cross-origin photo loading is deliberately deferred; it is not a baseline failure.

## Porting rule

`habbo-client-clean` is the behavioural and architectural source of truth. Convert its existing
components and preserve their ownership boundaries; do not replace them with new hand-written
room, protocol, lifecycle, interaction, or UI layers. Hand-written Haxe is permitted only for an
unavoidable target boundary—such as browser transport, same-origin URL handling, SWF decoding,
or OpenFL integration—and must remain the smallest adapter that lets converted client code run.
Temporary adapters are removed when the converted owner becomes available. Files under
`generated/` are reproducible output and are never edited directly.

## G1 toolchain

The setup is local to this checkout. It does not add Haxe to the machine PATH or modify the
`habbo-client-clean` repository.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap-toolchain.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\build-html5.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\serve-html5.ps1
```

For the G1b localhost transport canary, start Arcturus with `NitroWebsockets-3.2.jar`, then open:

```text
http://localhost:8080/#sso=<ticket>&user=<expected-username>
```

Use `localhost`, not `127.0.0.1`, unless the latter is explicitly present in
`websockets.whitelist`. The SSO is placed after `#`, so it is available to the page but is not sent
to or logged by the HTTP server. Override the default `ws://localhost:2096/` endpoint with the
non-secret query parameter `?ws=<encoded-websocket-url>` when needed.

## Historical migration gates

The sections below preserve the evidence and reasoning that led to the current production room
path. Their intermediate frontier descriptions are historical; current status is summarized
above and in `CHECKLIST.md`.

G1c's 24-file ax3 canary converts but does not compile. The owner approved the hybrid response:
hand-port Flash-semantic foundations and keep ax3 for suitable leaf classes and message DTOs.
The ordered `Map`/`SingleWriteMap` foundation passes 75 assertions; XML/E4X passes 44;
ByteArray passes 41 in a real HTML5 browser, including Flash's required big-endian default; and
reflection passes 21 on both JavaScript and the interpreter with a DCE-safe definition registry.
Runtime ownership, IID routing, dependency lifecycle, and all 35 embedded component manifests pass
another 91 assertions. The non-visual asset foundation passes 29 assertions in a real HTML5
browser. AssetLibrary passes 43 more, including 153 supported assets and aliases from the real
catalog manifest. BitmapDataAsset passes 31 browser assertions with explicit owned/borrowed pixel
accounting. The final OpenFL component shell passes 27 browser assertions plus the 91-assertion
runtime regression. The real XML window-layout canary closes G1d with 30 browser assertions: it
parses the real 1,121-byte `HabboCatalogCom_redeemItemCodeWidget.bin` into OpenFL
`Sprite`/`TextField` objects and samples non-transparent pixels from `BitmapData.draw`, so it
proves structural parsing and real rendering together.

**G1d is complete as scoped** — 3,268 lines of hand-written Haxe across 33 files. Its former G3
and G4b deferrals are now closed by their dedicated gates. No
failed canary output was copied into `src/`. See
[`evidence/ax3-canary.md`](evidence/ax3-canary.md),
[`evidence/g1d_window_layout_verification.json`](evidence/g1d_window_layout_verification.json),
[`evidence/g1d_map_verification.json`](evidence/g1d_map_verification.json),
[`evidence/g1d_xml_verification.json`](evidence/g1d_xml_verification.json), and
[`evidence/g1d_bytearray_verification.json`](evidence/g1d_bytearray_verification.json).

G2 is complete as scoped. The integrated real-browser regression passes 926 assertions and
compares 118 exports over HTTP with zero console errors: every measured container, bitmap codec,
binary blobs, and all 24 reachable Gordon MP3s, including trusted-click OpenFL playback. A
separate Harman AIR/Flash harness exactly matches 20 straight-RGBA bitmap captures across three
furni, satisfying the Flash-reference requirement without editing the clean client. See
[`evidence/g2_verification.json`](evidence/g2_verification.json) and
[`evidence/g2e_flash_reference.json`](evidence/g2e_flash_reference.json).

Window rendering is driven by the client's own theme data — `habbo_element_description_xml.bin` and the `habbo_window_layout_*` documents — rather than by per-control constants, and text is rendered with `truffle-text` over the client's Ubuntu/Volter faces. G4b was re-verified after that change; its evidence now records differences, not only matches.

G3 is also complete: 25 genuine XML blobs across five SWFs—five each of assets, visualization,
logic, index, and manifest—match independent Python metrics and AIR 51.2.2's native E4X behavior.
The OpenFL browser regression passes 375 assertions with zero console errors. See
[`evidence/g3_verification.json`](evidence/g3_verification.json).

G4 is complete too. A 160-sprite room built from five real furni SWFs ran in OpenFL for 180.022
seconds / 13,495 frames, with masks, filters, additive blending, alpha-aware picking, and repeated
pool shrink/regrow cycles. Only 160 display objects were created; 2,700 releases were reused.
Render-update p95 was 0.1 ms, the sampled heap range was 5.702 MiB with 21 observed GC drops, and
a native AIR 51.2.2 reference matched the deterministic 36-pixel ARGB capture exactly. The AIR run
also pinned Flash's surprising alpha-128 signed-shift hit-test behavior. See
[`evidence/g4_verification.json`](evidence/g4_verification.json).

G4b is complete. The primary canary is the entire first-visible 360×242
`HabboCommunicationDemo` login window, rendered from its original XML with production skins,
colorization, the live 6,25 frame margins (not the theme's 3,36 placeholder), editable SSO input,
and drop shadow. The login XML has no HTML
or list, so a declared real catalogue fragment supplies only HTML/link and masked scrolling-list
coverage. Trusted browser input, click, link and wheel events pass with zero console errors, and
the primary window matches the actual NGHWin Harman AIR client side-by-side. See
[`evidence/g4b_verification.json`](evidence/g4b_verification.json).

G4 and G4b now close the Phase 2 technical gates. The technical review/re-cost in
`evidence/m2_recost.md` measures core at 353 source files / 37,787 lines, with 200 low
semantic-pressure conversion candidates but a
245-file window hard tail. M2 now has a deterministic **slice** pass: 77 of 353 core AS3 files
(excluding `window/`) produce 79 byte-identical Haxe files across two runs. Of those 79 generated
files, 35 (44.3%) compile through the real OpenFL HTML5 target.
The pipeline fails closed on source/tool/rule/exception and UI-asset drift, keeping
`habbo-client-clean` authoritative. A copied-source drill proves one `IIDCore.as` change modifies
only generated `IIDCore.hx`; later room closures completed the production cutover for the room
path.

Generated Haxe is committed so a baseline checkout contains the exact production source. Local
toolchains, Haxelib packages, dependencies, and HTML5 build output are ignored. The project pins
Haxe 4.3.7, Neko 2.4.1, Haxelib 4.1.1, Lime 8.3.2, and OpenFL 9.5.2; the bootstrap script also
verifies every downloaded archive by SHA-256.

See [CHECKLIST.md](CHECKLIST.md) for gate status and [PLAN.md](PLAN.md) for the migration order.
