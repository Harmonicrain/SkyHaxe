# G1c ax3 converter canary

Date: 2026-09-01

Verdict: **FAIL — stop at the Phase 1 exit and reassess the conversion strategy.**

ax3 converted the complete 24-file canary and exited zero, but Haxe 4.3.7 did not compile the
result. The compile produced 123 source-located diagnostic lines across 12 of the 24 converted
classes. This is not a missing-semicolon result: the remaining failures cross E4X semantics,
`Proxy`/namespace contracts, `Dictionary` types, generated property access, control flow, and
method signatures. No G1c output is suitable for merging into `src/`.

## Scope and anchors

- Source: `C:/habbo/client/habbo-client-clean/src`, read-only throughout the run.
- Selection: 24 files; the exact paths, per-file hashes, line counts, and detected constructs are
  in `evidence/g1c_canary_selection.json`.
- Coverage by file: Vector 7, Dictionary 11, ByteArray 9, reflection 7, XML 13, namespace 5.
- Canonical converter: [innogames/ax3](https://github.com/innogames/ax3), commit
  `70f0ae5f9ce466b207c70952163aaa83a7aff357`.
- Upstream `converter.jar` SHA-256:
  `1fc45325a9eeeaa22ffff694402b09a5b0b46722975c1da0364ce6846a146b38`.
- Type library: existing `C:/habbo/apps/NGHWin/build/HabboAir.swf`, 7,258,363 bytes, SHA-256
  `08d6a9907dad027827685775685289e4f86570f80608ce31507f2e8eb10ee991`.
- The selected AS3 was copied under ignored `.toolchain/g1c`; neither the clean client nor NGH
  assets were written.

## Repeatable repairs needed before ax3 could finish

`evidence/g1c_rewrite_as3.py` applies exact, count-guarded replacements and refuses to operate
outside `SkyHaxe/.toolchain/g1c`. The final run applied 77 replacements represented by 40 guarded
change records across 13 files. `evidence/g1c_rewrites.json` is the machine-readable record.

The repair families were:

1. Terminate three ASI-dependent declarations/statements.
2. Remove four redundant `super()` calls from classes with no explicit superclass.
3. Parenthesize two nested immediately-invoked functions (four token repairs).
4. Replace one E4X literal with `new XML(...)` and remove its decompiler residue.
5. Remove six explicit and five wildcard `__AS3__.vec` imports; Haxe supplies `Vector`.
6. Remove five `flash_proxy` imports and five `use namespace` directives, then make 19 proxy
   overrides public. This gets through ax3, but does **not** make the generated Proxy signatures
   valid Haxe; that is one of the compile failures below.
7. Narrow seven known-singleton XML child lists before `child`, `children`, or `appendChild`.
8. Rewrite five unsupported `value as XML` expressions as equivalent `XML(value)` coercions.
9. Normalize reused or field-targeted loop variables into forms ax3 can scope.
10. Replace custom `Map` Proxy iteration/indexing with its `getKeys`/`getValue` public API at the
    measured call sites.
11. Remove the reserved Haxe package segment `enum` from the generated import using
    `evidence/g1c_rewrite_haxe.py`; compilation uses a four-constant compile-only alias package.

All rules above are mechanical and guarded. They are not edits to the clean AS3 tree.

## Required ax3 tool patch

Upstream ax3 types the AS3 global `unescape` but its Haxe generator throws `unknown builtin` when
printing it. `evidence/g1c_patch_ax3.py` applies a two-file patch to the pinned checkout:

- map `escape` and `unescape` to `ASCompat`;
- implement `ASCompat.unescape` with the native Flash/JavaScript global, preserving legacy
  `%uXXXX` behavior instead of substituting the non-equivalent URI decoder.

The rebuilt canary converter SHA-256 was
`51a3b8d4d680b4c9119bc365183b532e5b32b3dc37f3bd815cf6decb943b6392`.
With that patch, ax3 exited zero in about six seconds and emitted 26 Haxe files: 24 selected
classes plus `Globals.hx` and `import.hx`.

## Haxe compile result

An HTML5 compile cannot use the Flash SWF as a native type library and immediately lacks the
unported client dependencies. Generating permissive HTML5 stubs would hide signature failures, so
the diagnostic compile used Haxe's Flash target with the exact compiled client SWF as its type
library. This is the more favorable compile: it supplies real dependency signatures. It still
failed and produced no SWF.

Compile-only accommodations were limited to an `Error` alias and the four `WindowParam` constants
used by the canary. The latter is necessary because AS3's package segment `enum` is a Haxe keyword.

Measured diagnostics (categories overlap where one Haxe error emits explanatory lines):

| Category | Source-located lines | Example |
|---|---:|---|
| E4X/XML incompatibility | 11 | generated `compat.XML` has no dynamic `assets`/`aliases` child field |
| Wrong method arity | 6 | `Std.parseInt(value, 16)` although Haxe's `Std.parseInt` has no radix argument |
| Proxy override signature | 9 | generated `ASAny` does not match `flash.utils.Proxy`'s `Dynamic` contract |
| Dictionary boundary mismatch | 6 | `ASDictionary<ASAny, ASAny>` versus real `flash.utils.Dictionary` APIs |
| Generated unreadable property access | 15 | getter/setter shape inferred incorrectly in `WindowParser` |
| QName not mapped | 3 | Proxy key normalization emits an unknown global `QName` |
| Numeric/return typing | 7 | comparator returning `Float` where Haxe `Array.sort` requires `Int` |
| Control-flow mistranslation | 1 | AS3 `break` from a `switch` case becomes Haxe `break` outside a loop |
| Interface signature mismatch | 4 | converted methods disagree with the real SWF interfaces |

Diagnostics touched these 12 canaries:

- `WindowParser` (36 source-located lines)
- `Map` (18)
- `EmptyIterator`, `ItemListIterator`, and `SelectorIterator` (12 each)
- `AssetLibrary` (11)
- `Component` (7)
- `ComponentContext` and `SkinParserUtil` (4 each)
- `GeometryBodyPart` (3)
- `SingleWriteMap` and `GraphicAssetCollection` (2 each)

The compiler also reported cascades while loading native window classes from the SWF. Those were
excluded from the 123-line and 12-file figures above.

**Saved output, added 2026-09-01.** These figures originally existed only as prose here, because
the hxml that produced them lives under gitignored `.toolchain/`. The full 285-line compiler output
is now committed as `evidence/g1c_compile_flash.log`, and
`evidence/g1c_compile_diagnostics.py` re-derives the 123 lines, the 12 files, and every per-file
count in the list above:

```
python evidence/g1c_compile_diagnostics.py            # parse the saved log
python evidence/g1c_compile_diagnostics.py --run      # recompile first; needs .toolchain/g1c
```

A "source-located diagnostic line" is defined mechanically as one carrying a `path:line:` location
inside the converted canary tree, which excludes the 149 location-less SWF type-library cascades by
rule rather than by hand. Since this records a **failed** gate, reproducing the failure is the pass
condition — the script exits non-zero if the count moves in either direction.

## Decision

Direct ax3 conversion is not a safe bulk strategy for the foundational client code. A passing
result would require more than source cleanup: it needs an owned compatibility architecture for
E4X, `Proxy`, `Dictionary`, properties, and Flash globals, plus hand review of generated control
flow and signatures.

Recommended reassessment: hand-port the semantic foundation (`Map`/Proxy behavior, XML shim,
assets, window parsing, component/runtime interfaces) and reserve ax3 for leaf classes and message
DTOs after those Haxe-native contracts exist. Do not begin G2 or bulk conversion merely to see
whether later gates fare better; the checklist's Phase 1 stop condition has been reached.
