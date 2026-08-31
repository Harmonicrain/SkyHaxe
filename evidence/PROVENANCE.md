# Evidence provenance

What each measurement was taken from, so it can be re-run and compared rather than believed.

## Anchors

### Client tree

| | |
|---|---|
| Repo | `habbo-client-clean`, branch `wired2-ngh` |
| Commit | `9b265927b277` |
| Working tree | **DIRTY** — 89 tracked files modified, 226 untracked |
| `git diff HEAD` sha256 (first 16) | `5ce21ff780421d0d` |
| Date | 2026-08-31 |

**A commit plus the word "dirty" is not reproducible**, because that working tree keeps changing.
The diff hash above pins the exact modified state at measurement time. To verify you are looking
at the same tree:

```
git rev-parse HEAD                     # expect 9b265927b277...
git diff HEAD | sha256sum              # expect 5ce21ff780421d0d...
git ls-files --others --exclude-standard | wc -l   # expect 226
```

If the diff hash differs, **re-run the scanners before trusting any figure here.** Note `git diff`
emits CRLF warnings on this checkout; they do not affect the hash of the diff body.

The owner delegated the commit/tag decision on 2026-08-31. SkyHaxe will **not** synthesize a
commit from 89 tracked modifications and 226 untracked files belonging to other in-progress
client work. Retain this anchor until that work naturally reaches a clean owner-created commit,
then replace it with the new commit id and regenerate the measurements.

### Artefact hashes (sha256, first 16)

| File | Hash |
|---|---|
| `g0_scan_swf_exports.py` | `8f1c323312db1b4f` |
| `g0_hof_furni.csv.gz` | `37a3bcf25005c691` |
| `e4x_api_contract.py` | `cb38017167f8e6df` |
| `e4x_contract.json` | `2edf30485e251749` |

---

## G0 — asset export invariant

**Result: PASS** (exit 0). Re-run with:

```
python evidence/g0_scan_swf_exports.py c:/habbo/ngh/dcr/hof_furni --csv out.csv --gzip
```

Corpus: `c:/habbo/ngh/dcr/hof_furni/`, walked recursively, `.swf` matched case-insensitively —
**18,608 files**.

| Container | Count |
|---|---|
| CWS (zlib) | 17,041 |
| FWS (uncompressed) | 1,543 |
| ZWS (LZMA) | 24 |

**Unreadable: 0.** All ZWS files decode.

### Exported symbols

| Kind | Count |
|---|---|
| bitmap | 268,647 |
| binary | 93,200 |
| root (character id 0) | 18,606 |
| sound | 21 — excluded |
| font | 3 — excluded |
| MISSING | 5 — excluded |

### Tag variants the reader must implement

Recorded per row in the CSV, not collapsed into "bitmap":

| Tag | Count | In reader scope? |
|---|---|---|
| `DefineBitsLossless2` | 267,506 | **yes** |
| `DefineBinaryData` | 93,200 | **yes** |
| `DefineBitsJPEG3` | 1,135 | **yes** |
| `DefineBitsLossless` | 1 | **yes** — one file only, but it is real content |
| `DefineBitsJPEG2` | 5 | only if `mp3/gamedata` enters the content contract |
| `DefineSound` | 21 | no — excluded |
| `DefineFont3` | 3 | no — excluded |

So: **three containers, four bitmap tags, `DefineBinaryData`, `SymbolClass`.**

### Exclusions (machine-readable, in the scanner)

| Match | Reason |
|---|---|
| `mp3/gamedata/` | `basicassets.swf` — a client asset bundle parked in a stray subdirectory of `hof_furni`; not furniture. Source of all sound and font exports |
| `koekjes.swf` | Five obfuscated names with no backing character — pure ABC classes in `SymbolClass`. Nothing for an asset reader to return. Excluded by owner decision 2026-08-31 |

The scanner **exits non-zero** on any unreadable file or any unexplained export, so this is a
regression test, not a report.

### Correction history

1. First pass used a **flat** directory listing → missed subdirectories, reported 18,543 files and
   claimed zero sound exports. The stray `basicassets.swf` was invisible.
2. Second pass walked the tree but **could not decode ZWS**, leaving 24 files unmeasured and the
   invariant unproven for them.
3. Third pass collapsed all bitmap tags into `bitmap`, hiding that `DefineBitsLossless` and
   `DefineBitsJPEG2` also occur — the reader scope was under-stated.

Current scanner fixes all three, matches `.swf` case-insensitively, and fails loudly.

### Not yet covered — checklist task P1c

- `c:/habbo/ngh/gordon/` — scanned ad hoc only. The 2016 `PRODUCTION-…` subtree exports 734
  sounds and 16 sprites; it is the old client's build output, not content, but that needs to be an
  explicit exclusion rather than a remark.
- `c:/habbo/ngh/dcr/` outside `hof_furni`.

---

## E4X API contract

Re-run with:

```
python evidence/e4x_api_contract.py c:/habbo/client/habbo-client-clean/src --json out.json
```

5,492 files scanned, **231 touch XML**.

The three-method shim proposed in an early draft of PLAN.md (`att` / `child` / `length`) was a
guess and is **too small**. Measured first-party surface, by occurrences:

| Member | Uses |
|---|---|
| `length` | 685 |
| `@attribute` | 486 |
| `name` | 189 |
| `text` | 88 |
| `child` | 83 |
| `toString` | 80 |
| `attribute` | 76 |
| `parent` | 64 |
| `replace` | 38 |
| `children` | 37 |
| `hasOwnProperty` | 31 |
| `appendChild` | 16 |
| `copy` | 14 |
| `localName` | 5 |
| `toXMLString` | 3 |

Vendored third-party trees (`org/openvideoads`, `com/hurlant`, `adobe/`, `deng/`) add
`(predicate filter)` — the only predicate use in the corpus — and are counted separately because
they may be dropped rather than ported. **That has to be a decision, not an accident.**

### Descendant sites — 4 first-party, 1 third-party

| File | Form |
|---|---|
| `com/sulake/habbo/avatar/alias/AssetAliasCollection.as:43` | `_local_2..alias` |
| `com/sulake/habbo/avatar/geometry/GeometryBodyPart.as:22` | `k..item` |
| `com/sulake/habbo/battleball/BattleBallArenaHud.as:362` | `source.descendants()` |
| `com/sulake/habbo/battleball/BattleBallLobbyWindow.as:385` | `source.descendants()` |
| `org/openvideoads/vast/config/ConfigPreConverter.as:808` | `k.ads.overlays..overlay` — third-party |

Earlier prose said "5 sites" from a naive grep that counted `...args` and `...types` **rest
parameters** as descendant operators, and missed `.descendants()` entirely. A later fix
over-corrected and dropped `_local_2..alias`. The current detector excludes only a preceding dot.

---

## Source-construct counts

Same client anchor as above. File counts via `grep -rl` unless noted.

| Construct | Files |
|---|---|
| `Vector.<T>` | 341 |
| `Dictionary` | 162 |
| `[Embed]` | 235 |
| Reflection | 23 |
| `XMLList` or `:XML` | 231 |
| Namespaces | 14 |
| `flash.desktop` | 2 |
| `com.sulake.core` total | **353** |
| `flash.text` | **150 imports across 74 files** |

**These still have no saved script** (Standing Rule 7). Generating one is outstanding work.
