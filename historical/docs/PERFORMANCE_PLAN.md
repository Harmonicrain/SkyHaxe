# Loading performance — implementation status

## Delivered 2026-09-07

- Navigation-relative phase markers in `data-skyhaxe-boot-ms` and Performance marks.
- Truffle and external variables start together; window construction still waits for both.
- Figuredata, figuremap and avatar actions fetch concurrently; original initialization order retained.
- Avatar SWF transport shares pending requests and caches compressed bytes with a 32 MiB LRU budget. Failed requests remain retryable; mutable bitmap libraries are not shared.
- Compatibility dictionary indexes string keys while preserving ordered entries, non-string lookup semantics and undefined misses. Patch recorded in the converter patch script.

First instrumented local login before dictionary indexing: client start 1440 ms,
variables 1754 ms, fonts 4140 ms, windows 4402 ms, localization 11546 ms,
engine 14061 ms, login 14182 ms. This is one run, not a statistical baseline.

Follow-up after string indexing and local corpus origin normalization: localization
4585 ms, room furnidata download 4846 ms, parse 6256 ms, engine 8275 ms,
login 8367 ms. The session loaders now use the existing same-origin `/ngh/` mount
instead of cross-origin localhost port 80. Productdata's null regex-result
enumeration is adapted explicitly to AS3's empty iteration behaviour.

## Still to deliver / validate

1. Repeat cold/warm boots and separate localization download from parsing. Add long-frame and decode measurements; verify dictionary semantics and cache concurrency under automated tests.
2. Bounded parallel avatar library scheduling with per-library union of requested parts. Preserve aliases, both scales, registration ownership and retries.
3. Versioned persistent asset caching with explicit uncached development mode; do not remove the current stale-asset protection without a replacement.
4. Split optional UI assets from bootstrap; original feature owners await their bundles. No handwritten replacement widgets.
5. Compare release/debug builds and opt-in verbose logging.
6. Profile before adding workers; validate guest/public rooms, animation timing, repeated room changes and memory disposal.

Authentication remains gated on engine handler registration. Truffle remains the text renderer.

## Delivered 2026-09-10 — direct SWF pipeline

- The active v32 `LibraryLoader` and the older `SwfAssetLibrary` now share bounded compressed-byte
  caching and pending-request deduplication. Failed requests remain retryable.
- Lossless SWF bitmaps decode in a bounded 2–4 worker pool (64 MiB queued-memory ceiling), with
  transferable buffers, disposal/stale-result handling and a main-thread fallback.
- CWS parsing uses the browser's asynchronous `DecompressionStream` where available.
- Lossless pixels now move RGBA -> Lime `ImageBuffer` -> `BitmapData.fromImage`; the former
  per-byte ARGB rewrite and second `setPixels` traversal are gone. PNG/JPEG outputs from
  `BitmapData.loadFromBytes` are retained instead of read back and rebuilt.
- Export/alias overlap is deduplicated without sharing caller-owned mutable bitmap surfaces.
- The 517-export digest baseline passes unchanged under the asynchronous path. The release v32
  build passes, and guest/public room boots completed with a live connection, avatars, furniture
  and animation.
- On comparable local cold-room probes, readiness improved from roughly 23 seconds to 18 seconds
  (about 22%). The previously measured worst image-copy phase fell from 4.36 seconds to about
  1.3 seconds. These are a small number of local runs, not a statistical benchmark.

The original Flash `HabboLoadingScreen`, `PhotoSplashScreen`, postcard assets, Ubuntu text and
framed progress display are now converted and wired. The temporary handwritten blue-bar loader
has been removed. A measured AVM2/Haxe static-initialization mismatch in `NineSplitSprite` is
handled by the reproducible converter/runtime compatibility boundary, and the browser host mirrors
HabboAir's `client.starting=Scratching ear's ear` default.

## Remaining measured ceiling

Cold boot is now dominated by eager native PNG/JPEG decoding and materializing thousands of SWF
bitmap exports, not network transfer alone. Before changing scheduling again, profile that phase
with full stacks. The next candidate is a bounded `createImageBitmap`/native-decode handoff that
preserves pixels and ownership; persistent revision-keyed byte caching is useful mainly for warm
reloads and must retain an explicit uncached development path. Do not introduce an offline SWF
conversion pipeline or replace original client components to obtain either gain.
