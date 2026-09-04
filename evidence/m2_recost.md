# M2 review and re-cost — 2026-09-02

## Verdict

Proceed, but not as a one-off 353-file port. M2 must first build and prove an upstream-refresh
pipeline in which `habbo-client-clean` remains authoritative. Generated Haxe is disposable output;
hand-maintained Haxe is limited to an explicit compatibility/exception layer whose source changes
fail closed.

Phase 2 proves that OpenFL can support the required asset, XML, renderer, window, text, input,
mask, filter, sound, and localhost transport behavior. It does **not** prove that classes sharing
an original name expose the complete original API. In particular, the current `IWindow`,
`WindowController`, and `WindowParser` are deliberate canary subsets.

## Measured source surface

The reproducible census is `evidence/m2_core_recost.py`; its complete output is
`evidence/m2_core_recost.json`.

| Area | Files | Source lines |
|---|---:|---:|
| `window` | 245 | 26,379 |
| `assets` | 25 | 3,591 |
| `runtime` | 32 | 2,851 |
| `utils` | 19 | 2,534 |
| `communication` | 23 | 1,643 |
| `localization` | 8 | 673 |
| `Core.as` | 1 | 116 |
| **Total** | **353** | **37,787** |

The tree contains 123 interfaces and 224 classes. 237 files are at most 80 lines, and a declared
heuristic identifies 200 low semantic-pressure candidates (at most 100 lines with none of
Dictionary, XML, Proxy/namespaces, reflection, or Flash display/filter/network/sound/text usage).
That heuristic does not prove dependency-graph leaves; M2b must order them using measured internal
dependencies. This is strong evidence for generated conversion—but not for converting the whole
package in one batch.

The hard tail is concentrated: 31 files exceed 320 lines. The window package alone is 69.4% of
files and 69.8% of lines. Its largest structural groups are 100 components / 11,169 lines,
30 graphics files / 4,115 lines, 39 utilities / 3,463 lines, and 12 root files / 4,010 lines.

Measured semantic pressure across core includes 27 Dictionary files, 34 XML/XMLList files,
13 namespace files, 16 reflection files, 47 Flash-display files, 16 Flash-text files, 99 geometry
files, and 52 event files. The window package owns most display, geometry, text, scrolling, mask,
and filter work.

## What the current Haxe tree means

SkyHaxe currently has 43 `com.sulake.core` Haxe files: 25 paths share an original class identity
and 18 are SkyHaxe-only adapters/readers. The 25 source counterparts are contract slices, not
completed M2 ports. A declared-function heuristic
shows the scale of deliberate API narrowing:

| Class | Original functions | Current Haxe functions | Original names absent* |
|---|---:|---:|---:|
| `window/WindowController` | 148 | 17 | 146 |
| `window/IWindow` | 125 | 2 | 125 |
| `runtime/ComponentContext` | 33 | 6 | 28 |
| `runtime/Component` | 30 | 20 | 24 |
| `runtime/IContext` | 24 | 2 | 22 |

\*Heuristic: accessor properties can produce false positives, so this is an alarm, not an API
compliance score. The underlying conclusion is unambiguous: M2 must reconcile all 353 identities,
not count 328 absent files and call the 25 matching names finished.

## Required refresh architecture

1. A single sync command reads a chosen `habbo-client-clean` tree without modifying it and writes
   only to a temporary workspace plus a generated-source directory.
2. The command pins the source tree hash, ax3 commit, converter patch, pre-rules, post-rules, and
   toolchain versions in a machine-readable manifest.
3. Guarded rewrites match exact counts or fail; no best-effort textual mutation is allowed.
4. Generated Haxe is never manually edited. Formatting may be deterministic and automatic.
5. An exception manifest owns every hand-maintained replacement: original path and hash, Haxe
   path, reason, contract tests, and API-surface check. If its AS3 source changes, sync stops and
   demands review.
6. Two runs against the same source must produce the same generated-tree hash.
7. An update drill against a copied fixture changes one AS3 leaf and must yield only the expected
   generated file and manifest delta.
8. Every original core class must end in exactly one state: generated or declared exception. No
   implicit omission and no unlisted stub is permitted.

## Re-costed M2 gates

| Gate | Scope | Focused engineering cost* |
|---|---|---:|
| **M2a** | Deterministic sync pipeline, manifests, generated/exception separation, double-run and update drill | 2–3 days |
| **M2b** | Order and convert/compile the 200 measured low semantic-pressure candidates; generalize converter rules | 3–5 days |
| **M2c** | Complete non-window core: 108 source identities / 11,408 lines; reconcile existing runtime/assets APIs and wire actual communication | 4–6 days |
| **M2d** | Window declarations and leaf behavior: enums, interfaces, events, iterators, motion, services, theme, tools | 3–5 days |
| **M2e** | Window engine: root, graphics, and utils (81 files / 11,588 lines), including full lifecycle/state/layout/skin/event behavior | 6–10 days |
| **M2f** | Window components (100 files / 11,169 lines) in compileable behavior groups | 5–8 days |
| **M2g** | Whole-core compile, no-stub audit, refresh rerun, and Phase 2 regression suite | 3–5 days |
| | **First complete M2 range** | **26–42 focused days** |

\*Planning range, not a delivery promise. It includes building the reusable refresh mechanism.
Skipping that mechanism would make the first conversion appear cheaper while making every client
update expensive, which violates the product goal.

After M2, an ordinary upstream change that stays inside generated classes should be a sync run plus
bounded review. A change touching an exception should fail immediately and cost only that named
compatibility contract—not a broad re-port.

## Stop/re-cost conditions

- Generated output is not deterministic across identical runs.
- A one-file copied-source update causes unrelated generated churn.
- More than 15% of original core source identities or more than 25% of original core lines require permanent
  hand-maintained exceptions.
- Generated files need routine manual edits to compile.
- M2c cannot retain G1/G1b/G2/G3, or M2e/M2f cannot retain G4/G4b.
- The exception manifest cannot detect an upstream edit to a hand-maintained source counterpart.

These thresholds preserve the actual objective: easy refreshes from `habbo-client-clean`, not just
a successful first build.
