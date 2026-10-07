# .hab asset bundles

SkyHaxe can load Habbo asset libraries as `.hab` bundles instead of SWFs. `.hab` is the format
Habbo's own HTML5 client loads in place of each SWF. The bundles are produced by **swf2hab**, a
separate, standalone converter (its location goes in `SWF2HAB_ROOT`). Its output was verified
pixel- and JSON-identical to the files Habbo serves.

## Turning it on and off

`client/config.ini` controls loading (edit it and reload the page; no rebuild is needed):

```
asset.hab.source.url=/runtime/|http://localhost/ngh/
asset.hab.url=/runtime/hab/|http://localhost/ngh/hab/
```

- An asset URL under a source prefix loads `<mirror at the same position>/<rest>.hab`.
- If a `.hab` is missing or fails to download, that one file falls back to its SWF. The fallback
  is counted as `habFallbacks` and logged as `SKYHAXE_HAB_FALLBACK`.
- Leave `asset.hab.url` empty to load SWFs only.
- For a single page load, `?assets=swf` or `?assets=hab` overrides the config, which is useful
  for A/B testing.
- `<html data-skyhaxe-assets="hab">` shows that HAB loading is active.

## Building the bundles

```powershell
$env:SKYHAXE_RUNTIME_ROOT = 'C:\path\to\ngh'
$env:SWF2HAB_ROOT = 'C:\path\to\swf2hab'
.\scripts\build-hab.ps1          # incremental; -Force reconverts everything
```

Output goes to `<runtime>\hab\<same relative path>.hab`, and the original SWFs are never
modified. A full conversion takes about 2.5 minutes for 22,000 libraries on 15 cores; a run with
nothing changed takes a few seconds.

## How it plugs in

`SwfFile.read` / `readAsync` recognise the `HAB\0` magic (`HabReader`) and return the same
export table a SWF produces. Because of that, `LibraryLoader`, `SwfAssetLibrary` and
`SkyRoomContentLoader` are unchanged apart from where they download from (`HabUrl`).

- **Atlas frames** become bitmap characters (`HabFrame`) named by their full SymbolClass name.
  Characters with the same pixel rectangle are shared, as SWF aliases are.
- **Atlas PNGs** (`HabAtlas`) are decoded once to exact straight RGBA. The decode runs in
  `swf-decode-worker.js`, or on the main thread through `HabPng` if a synchronous caller needs
  it first. Once every frame has been cut out, the decoded atlas is released.
- **Raw XML, binary, image and MP3 entries** get their `<library>_` prefix back. MP3s are rebuilt
  into DefineSound payloads from the entry params.

## Measured

Measurements below are for room `sso=12345` with a cold cache, 161 libraries, comparing the
previous build (SWF, Haxe `InflateImpl`) against this build. Assets are served the same way in
both builds.

| | Previous build | SWF + pako | HAB |
|---|---:|---:|---:|
| Main-thread lazy bitmap decode (`lazyLosslessDecodeMs`) | ~585 ms | ~210 ms | ~30 ms |
| First room rendered | ~12.8 s | ~12.1 s | ~11.6–12.2 s |
| Asset bytes | 5.58 MB | 5.58 MB | 5.07 MB |

A side note on `parseWallMs`: for `.hab` it includes waiting in the worker queue for the atlas
decode. Because concurrent libraries each add their own wait, the total looks large, but it is
not main-thread time.
