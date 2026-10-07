# Reproducible v32 composition

This composition reproduces the working SkyHaxe client without writing to the live generated tree,
the served artifact, or port 8766. The authoritative client source is the pinned
`https://github.com/habbo-cc/Habbo-Sky/tree/wired2-ngh` AS3 checkout.

The ordered composition is the complete v32 component-graph closure followed by the v33 original
loading-screen closure. It then applies two hash-guarded patches: proven post-generation behavior
fixes, followed by the browser/OpenFL platform adaptations (including Habbo HTML5 font integration).
The existing ax3 compatibility layer is copied as a separately hashed platform boundary.

`.gitattributes` preserves the exact bytes of generated trees, generation inputs, runtime seams
and packaged font resources. Some converter outputs contain mixed line endings; those bytes are
part of the pinned hashes. Do not normalize them independently of the reproduction manifests.

Run two isolated reproductions in a new directory outside this repository:

```powershell
python build-support/generation/reproduce.py --run-root C:\path\outside\SkyHaxe\verification-YYYYMMDD-HHMM --runs 2
```

The command refuses a destination inside SkyHaxe, checks every pinned input, runs each conversion
batch with its own two-pass converter determinism gate, applies patches with LF-preserving Git
settings, compares both final runs byte-for-byte, and compares their manifests to the preserved
working baseline. It never builds or publishes the HTML5 client.

Intentional upstream changes use `scripts/update-client.ps1`, not this strict reproduction gate.
That workflow snapshots a selected checkout, discovers a fresh dependency closure and asset set,
builds an isolated candidate, and requires an explicit deterministic finalization and promotion.
