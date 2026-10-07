# Habbo HTML5 font rendering

SkyHaxe uses the font engine and matching font assets in the supplied 6 October 2026 Habbo HTML5 launcher. Normal builds verify the extracted resources and compile the maintained OpenFL adapter. The ASAR is needed to reproduce the resources and run the independent reference comparison.

## Provenance

- Archive SHA-256: `f6a080f39dcdb10f920ce7c4153e4e04687b7e4c5f533d738fd8e9256f3b8ae9`.
- Launcher: `habbo-air/HabboAirLauncher.app.js`.
- Launcher SHA-256: `0827769ec42c99aa6206e6746007a5cbd159d99ea40f059f22a7377e69a65b3b`.
- Font container: `generated/habbo-window-manager-com.hab`.
- Native profile format: `air32-native-font-bundle-v1`, recorded runtime `51.3.2.1`.
- Nine TTF assets and seven matching AIR51 native profiles. UbuntuMedium and UbuntuThick use the reference TTF/Canvas fallback.

`scripts/extract-habbo-fonts.mjs` parses the launcher with Acorn and follows resolved top-level dependencies. It keeps original font functions, classes, initialization statements and cache logic; the minifier's class-name helper is reproduced separately. The application entry point is excluded. `manifest.json` records resource lengths, hashes and the source offsets of the 885 extracted code units. The deployed tree contains 19 files totaling 10,509,074 bytes.

## Integration

`HabboText.hx` is the browser boundary. The OpenFL TextEngine measures format runs through the reference engine, including cumulative character advances and native ascent, descent and line metrics. CanvasTextField draws ordinary and selected runs through the same backend. TextController coverage uses the actual TTF glyph registry. `TruffleText.hx` remains a compatibility typedef for the pinned converter and older callers.

`src/skyhaxe/text/habbo-text.mjs` normalizes the existing Ubuntu and Volter aliases, registers all matching TTF/profile pairs, waits for FontFace loading and checks fetched resource hashes before startup completes. The native support gate and raster math come from the reference. Unsupported native combinations use its specialized Volter fallback or browser Canvas with the supplied TTFs.

For ordinary advanced text drawn into BitmapData with an integer translation, the platform adaptation composites directly into retained destination pixels with the reference premultiply/render/unpremultiply sequence. This preserves background-dependent native compositing. Input fields, selections, underlines, complex transforms, masks, filters and non-normal blend modes use OpenFL's normal text drawing path, backed by the same font engine. OpenFL continues to own selection, wrapping, scrolling, underline and text layout geometry.

The default resource URL is `assets/habbo-text` relative to the document; `text.resource.base` can override it. Localhost or HTTPS is required for WebCrypto integrity checks. Release packaging includes the font tree and verifies its manifest. The local server and nginx example serve `.mjs` as JavaScript.

## Verification

Run these from the repository root with the supported toolchain:

```powershell
npm ci
node scripts/extract-habbo-fonts.mjs C:/path/to/app.asar
./scripts/build-font-tests.ps1 -SourceRoot C:/path/to/habbo-client-clean
node scripts/verify-habbo-fonts.mjs C:/path/to/app.asar
./scripts/build.ps1 -SkipBootstrap -Release -SourceRoot C:/path/to/habbo-client-clean
./scripts/package-release.ps1 -OutputDirectory C:/habbo/client/SkyHaxe/build/font-release
```

The reference test uses the unmodified launcher prefix as an independent oracle and never launches the reference application. It compares widths, native metrics, character positions and every retained raster byte for 84 combinations across seven profiles, three sizes, two colors and two thickness settings, plus four destination-background comparisons. Eight further cases check Volter fallback widths/pixels and TTF-only metrics. Coverage, aliases, unsupported styles, surrogate caret boundaries and same-length profile corruption are also checked.

The compiled OpenFL test exercises 18 face/size combinations and checks text width, character bounds, pixel output, selection rendering, empty-input metrics, clipping, ColorTransform, coverage and wrapping. Reports are written to `build/font-reference/report.json` and its screenshot to `build/font-reference/openfl.png`.

Two fresh extractions were byte-identical to each other and the deployed tree. The release build and package passed. The live client authenticated with the requested SSO and reached a room; `evidence/habbo-fonts-live-client.jpg` records the visible result. The browser reported no startup warnings or errors at that check.

These checks establish parity for the measured cases. Browser-dependent Canvas fallback and every UI screen are not claimed to have universal pixel parity.

## Rollback and ownership

The prior adapter and build script are preserved under `historical/font-rendering/`. Active dependencies no longer require the Truffle package or its payload. A rollback should restore the previous renderer, resources, package lock, platform adaptations and generation metadata together, then rebuild. Existing unrelated worktree changes are preserved.
