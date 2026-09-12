# Reproducible v32 composition

This composition reproduces the working SkyHaxe client without writing to the live generated tree,
the served artifact, or port 8766. The authoritative client source is the pinned
`https://github.com/habbo-cc/Habbo-Sky/tree/wired2-ngh` AS3 checkout.

The ordered composition is the complete v32 component-graph closure followed by the v33 original
loading-screen closure. It then applies two hash-guarded patches: proven post-generation behavior
fixes, followed by the browser/OpenFL platform adaptations (including Truffle font integration).
The existing ax3 compatibility layer is copied as a separately hashed platform boundary.

Run two isolated reproductions in a new directory outside this repository:

```powershell
python scripts/reproduce-v32.py --run-root C:\Users\John\Documents\SkyHaxe-Batch2\verification-YYYYMMDD-HHMM --runs 2
```

The command refuses a destination inside SkyHaxe, checks every pinned input, runs each conversion
batch with its own two-pass converter determinism gate, applies patches with LF-preserving Git
settings, compares both final runs byte-for-byte, and compares their manifests to the preserved
working baseline. It never builds or publishes the HTML5 client.
