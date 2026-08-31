# Evidence provenance

What each measurement was taken from, so it can be re-run and compared rather than believed.

## Anchors

### Client tree

| | |
|---|---|
| Repo | `habbo-client-clean`, branch `wired2` |
| Commit | `9b265927b277` |
| Working tree | **DIRTY** — 93 tracked files modified, 226 untracked |
| `git diff HEAD` sha256 (first 16) | `60bfe073e18bbb40` |
| Date | 2026-09-01 |

**A commit plus the word "dirty" is not reproducible**, because that working tree keeps changing.
The diff hash above pins the exact modified state at measurement time. To verify you are looking
at the same tree:

```
git rev-parse HEAD                     # expect 9b265927b277...
git diff HEAD --output=client.diff
Get-FileHash client.diff -Algorithm SHA256  # expect 60bfe073e18bbb40...
git ls-files --others --exclude-standard | wc -l   # expect 226
```

If the diff hash differs, **re-run the scanners before trusting any figure here.** Note `git diff`
emits CRLF warnings on this checkout; they do not affect the hash of the diff body.

The pre-P2/P3 anchor was `5ce21ff780421d0d` with 89 tracked modifications and 226 untracked files.
The current anchor adds only the four P2 files and P3's one-character fix to that dirty state.
The owner explicitly prohibited staging, committing, tagging, or pushing on the client side.
SkyHaxe will **not** synthesize a client commit from unrelated in-progress work.

### Artefact hashes (sha256, first 16)

| File | Hash |
|---|---|
| `g0_scan_swf_exports.py` | `23f08f9735b13f4d` |
| `g0_hof_furni.csv.gz` | `18dbf6474aa985a5` |
| `g0_dcr.csv.gz` | `14242bb88185ce1e` |
| `g0_gordon_contract.py` | `2fc0da3907264740` |
| `g0_gordon_contract.csv.gz` | `120deb9e72765fd2` |
| `g0_gordon_contract.json` | `b6fa4f68eaf0bb6a` |
| `e4x_api_contract.py` | `cb38017167f8e6df` |
| `e4x_contract.json` | `ec963a68ddf8584e` |

All three gzip evidence files use header `mtime=0`; identical scanner input now produces identical
compressed bytes instead of a timestamp-only diff.

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
| `DefineBitsJPEG2` | 5 | no for this corpus; **required by Gordon** |
| `DefineSound(MP3)` | 21 | excluded here; **required by Gordon** |
| `DefineFont3` | 3 | no — excluded |

Global reader scope after P1c: **three containers, four bitmap tags, `DefineBinaryData`,
`DefineSound(MP3)`, and `SymbolClass`.**

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

### P1c — remaining DCR and Gordon contract

Whole DCR re-run:

```
python evidence/g0_scan_swf_exports.py c:/habbo/ngh/dcr --csv evidence/g0_dcr.csv --gzip
```

**PASS:** 18,611 files; FWS 1,544 · CWS 17,043 · ZWS 24; zero unreadable. The three files outside
`hof_furni` add 24 bitmap, 15 binary, and three root exports without expanding reader scope.

Gordon is not one homogeneous set, so its reachability test is separate:

```
python evidence/g0_gordon_contract.py \
  --csv evidence/g0_gordon_contract.csv.gz \
  --json evidence/g0_gordon_contract.json
```

**Reader contract PASS:** 3,270 configured-production files derived from current `figuremap.xml`,
`effectmap.xml`, `external_dev_vars.txt`, AS3 SWF literals, public-room configuration plus a
conservative naming fallback, and NGHWin's six `local_include` files. Zero unreadable and zero
unsupported exports in that set. `external_battleship_vars.txt` is not the runtime contract.

| Reachable Gordon export | Count |
|---|---:|
| bitmap | 240,142 |
| binary | 5,315 |
| document root | 3,270 |
| sound | 24 — all `DefineSound(MP3)` |

Required Gordon bitmap variants include `DefineBitsJPEG2` (**1,468**), so JPEG2 is no longer
conditional. NGHWin's exact local subset is `HabboRoomContent`, `PlaceHolderFurniture`,
`PlaceHolderWallItem`, `PlaceHolderPet`, `TileCursor`, and `SelectionArrow`.

`public.room.preload.types` confirms 12 `hh_room_<type>.swf` production files. Three more
production `hh_room_*` files are retained as a conservative naming-derived fallback; the JSON and
CSV distinguish the two reasons. A root-level `hh_room_gamehall.swf` is also reported separately
as a duplicate, not another production contract member.

The non-ignored Gordon inventory is 3,885 SWFs: CWS 3,819 · FWS 52 · ZWS 14. Six CWS files omit
the Adler-32 trailer but inflate to exactly the SWF-header length. **Five are reachable production
content.** In particular, `external_dev_vars.txt` adds `elephants.swf`; its 122 exports are 107
`DefineBitsJPEG3`, 9 `DefineBitsLossless2`, 5 `DefineBinaryData`, and 1 document root. Therefore
tolerant streaming inflate with an exact header-length check is load-bearing in G2, not merely
support for archived junk. Two genuinely truncated files (`ngh846.swf`, `nghkash2.swf`) and all
font/sprite exports are in unclassified archived client/test files, not the reachable set.

Four current map references have no file in the configured production directory: `flycarpet.swf`,
`zombieduck.swf`, `hh_human_50_fx.swf`, and `hh_human_fx.swf`. These are corpus/config completeness
warnings, not decoder failures.

Owner decision 2026-08-31: **ignore**
`gordon/flash-assets-PRODUCTION-202605152352-294132426` (2,891 files). The contract script omits it
and records that exclusion in its JSON; it is not a fallback for missing production assets.

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
| `children` | 41 |
| `hasOwnProperty` | 31 |
| `appendChild` | 16 |
| `copy` | 14 |
| `localName` | 7 |
| `toXMLString` | 3 |

Vendored third-party trees (`org/openvideoads`, `com/hurlant`, `adobe/`, `deng/`) add
`(predicate filter)` — the only predicate use in the corpus — and are counted separately because
they may be dropped rather than ported. **That has to be a decision, not an accident.**

### P2/P3 result — 0 first-party descendants, 1 third-party

P2 replaced the four first-party forms below with class-local depth-first `children()` walks:

- `AssetAliasCollection`: collect every descendant `alias` in document order.
- `GeometryBodyPart`: collect every descendant `item` in document order.
- `BattleBallArenaHud` and `BattleBallLobbyWindow`: return the first descendant with the requested
  `bb_id`, preserving the original first-match behavior.

The only remaining site is
`org/openvideoads/vast/config/ConfigPreConverter.as:808` (`k.ads.overlays..overlay`), which is
vendored third-party code and was deliberately left untouched.

P3 added the missing semicolon to
`INCOMING_PACKETS[5210] = FireworkChargeDataEvent;`; no packet mapping changed.

Verification on 2026-09-01:

- `e4x_api_contract.py`: 5,492 files, 231 XML files, **0 first-party descendants**, 1 third-party.
- Missing-semicolon packet-map grep: 0 findings.
- Baseline official NGHWin compile: PASS before editing.
- Post-edit `build.bat compile`: PASS in 73.561s; `HabboAir.swf` 7,258,363 bytes, SHA-256
  `08d6a9907dad0278`, header version byte 51.
- No client-side git staging, commit, tag, or push was performed.

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
