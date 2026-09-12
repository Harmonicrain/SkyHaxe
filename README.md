# SkyHaxe

SkyHaxe is the browser/OpenFL port of the NGH Habbo client. The supported client uses the
converted original component graph and narrow browser/platform adaptations; Truffle renders its
fonts.

## Build the client

From this directory:

```powershell
$env:SKYHAXE_SOURCE_ROOT = 'C:\path\to\Habbo-Sky'
.\scripts\build.ps1
```

The deployable output is `build/client/html5/bin/`. The build consumes the current Haxe tree and
does not regenerate it from AS3.

Run it locally with:

```powershell
$env:SKYHAXE_RUNTIME_ROOT = 'C:\path\to\your\runtime-pack'
python .\scripts\serve-client.py --port 8766 --runtime-root $env:SKYHAXE_RUNTIME_ROOT
```

Then open `http://localhost:8766/#sso=YOUR_TICKET`.

## Where to work

- `project.xml` — the one supported OpenFL project.
- `client/` — browser entry point and editable client configuration.
- `src/` — deliberate browser/OpenFL seams and hand-maintained runtime code.
- `.skyhaxe/generated/` — generated Haxe component graph.
- `.skyhaxe/platform/` — generated/platform patch result used by the supported build.
- `.skyhaxe/compat/` — AS3 compatibility layer used by converted code.
- `build-support/generation/` — pinned conversion rules, closures, manifests and guarded patches.
- `build-support/assets/` — OpenFL indexes for original clean-client assets.
- `build-support/platform/` — tracked platform overrides that take precedence at compile time.
- `public/` — browser payloads, including the SWF decoder worker and Truffle resources.
- `test/` — retained semantic regression sources.
- `historical/` — superseded projects, probes, tooling and delivery records; not supported entrypoints.

## Source and asset ownership

The [`wired2-ngh` Habbo-Sky branch](https://github.com/habbo-cc/Habbo-Sky/tree/wired2-ngh)
remains the authoritative AS3 source. The XML files under
`build-support/assets/` are OpenFL declaration indexes: they refer to the original layouts and
images under that clean-client checkout and package them into the web build. A build machine must
provide a compatible corpus; a production web server hosting the already-built output does not.

At runtime the client also needs a separately supplied/configured NGH SWF and gamedata corpus.
That corpus is not bundled into this repository or transferred by repository cleanup.

## Reproduce generated Haxe

Regeneration is deliberately separate from normal compilation and writes only to a new external
directory:

```powershell
python .\build-support\generation\reproduce.py `
  --run-root C:\path\outside\SkyHaxe\verification-run `
  --runs 2
```

It converts from the pinned Habbo-Sky commit twice, applies the guarded working patches,
and requires byte-identical generated/platform/compat trees against both runs and the preserved
baseline. It does not replace `.skyhaxe/` automatically.

## Update from Habbo Sky

An upstream update is separate from strict reproduction and ordinary compilation. It snapshots
the selected checkout, rediscovers the dependency-connected component graph and embedded assets,
then converts and builds entirely outside this repository:

```powershell
$env:SKYHAXE_CANDIDATES_ROOT = 'C:\path\outside\SkyHaxe\candidates'
$env:SKYHAXE_FLEX_ROOT = 'C:\path\to\Flex-SDK'
.\scripts\update-client.ps1 -SourceRoot C:\path\to\Habbo-Sky
```

A dirty checkout is refused unless `-IncludeDirty` is supplied; that captures its exact `src/`
content and Git status. Development candidates use one conversion pass. Once a candidate is ready,
run its final two-pass determinism gate and promote it explicitly:

```powershell
.\scripts\finalize-client-update.ps1 -Candidate C:\path\to\candidate
$env:SKYHAXE_BASELINE_ROOT = 'C:\path\outside\SkyHaxe\rollbacks'
.\scripts\promote-client.ps1 -Candidate C:\path\to\candidate
```

Promotion refuses a stale or merely converted candidate, verifies that active inputs have not
changed since preparation, and saves a rollback snapshot. Generated Haxe, platform adaptations,
compatibility code and asset manifests move together. Compilation is not reported as browser
verification; the changed feature and compact client journeys still need runtime testing.

Historical migration detail is retained under `historical/docs/`. Current layout ownership is
described in `REPOSITORY_LAYOUT.md`.
