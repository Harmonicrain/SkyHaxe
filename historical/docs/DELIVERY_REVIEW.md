# Faster delivery without abandoning Flash parity

> **Historical review:** this records an earlier migration frontier. Statements such as
> “Infostand is not complete” do not describe the preserved working v32 client. Current ownership
> and verified commands are documented in `README.md`, `REPOSITORY_LAYOUT.md`, and
> `reproducibility/v32/`.

Review started 2026-09-05. Current status and measurements are reproducible with
`evidence/port_delivery_audit.py`; they are not percentages of working features.

## Bottom line

Batch conversion and compilation of shared foundations; integrate and verify behavior in small
vertical slices. Do not keep rediscovering platform/compiler gaps inside each widget, and do not
equate emitted files with a finished feature. More handwritten feature implementations would
give short-term screenshots but repeat the room-renderer migration debt.

The infostand is **not complete**. Its handler/views and concrete window toolkit now compile
in the isolated V20/V21 target. The runtime room desktop/widget bus and real window service are still
needed. The existing client continues using its working bootstrap UI and generated room engine.
The isolated original window service now passes a browser canary across 34 authored frame/button
styles, default-button hover/press/click, list ownership and disposal. The combined compile root
names 498 types. V23 records the next original room UI graph: 850 additional sources / 126,337
lines. That graph includes Flash download/video dependencies which need explicit boundary review;
it is not a claim that 850 files must all become production features before the Infostand.
The attempted batch is currently blocked by E4X filters/namespaces, labelled control flow,
`with`, and video dependency typing. Its failed sync has published no V23 output. Primitive
constructor and other shared coercion fixes pass the converter/browser probe; each probe now
uses fresh output and requires every fixture, preventing stale generated files from hiding a
zero-exit partial conversion. This remains foundational work, not a live Infostand delivery.
An earlier window canary also exposed an intermittent skin-image preload failure: the file
exists and four subsequent fresh-browser runs passed the unchanged build. Repeat evidence is
retained; the latest regenerated-build pass supersedes the failed result file. HTTP errors and
browser stderr are now captured on failures.
The cause is not established, so repeated passes do not close that loading issue.

2026-09-06 continuation: indexed XML chains retain their node types; typed and dynamic
`toString` calls retain their actual arguments (removing six batch errors). Numeric singleton
XML indexing and wildcard/named descendant queries now have browser regressions. V21/V22
deterministic regeneration and the 34-style manager runtime passed after the first two fixes.
The larger V23 batch still has parser/E4X blockers and remains unpublished.
The user subsequently delegated the scope choice. Active delivery now uses a hash-pinned
Infostand/Avatar Info build profile: 118 additional sources, with the original retained factory
branches and the original desktop event/message routing. All 118 convert deterministically into
an isolated V24 candidate; compilation and live integration are not complete. This is an explicit
product build configuration, not a handwritten replacement or a claim the full V23 batch passed.
New shared regressions cover unsigned colour constants/default arguments, Boolean relational
coercion, Math.LN2, guarded switch exits and OpenFL callback identity. Truffle remains mandatory.
Additional regressions cover dynamic XML descendant type checks, construction-time whitespace
settings, the AvatarInfoWidget switch fall-through into a terminal default, and String.match
string/regex patterns with null, captures and match metadata. The original window manager,
embedded resources, host routing and asset-loading browser tests passed after the XML changes.
Qualified descendant selectors still fail explicitly; full namespace and predicate support
must not be inferred from the unqualified/wildcard query tests.

## Findings from this run

- The old sync deleted published closure outputs before attempting conversion. A failure could
  remove working types and create misleading missing-file errors on subsequent runs. Sync now
  converts in scratch, validates the requested passes, and only then publishes changed files.
  Seven automated tests cover failure, missing output, nondeterminism, helper-module drift,
  successful publication, unchanged timestamps and one-pass status.
- The earlier infostand compile root named leaf classes but did not exercise the concrete window
  implementation. The corrected root names the combined infostand/window candidate and now builds.
  This proves compilation, not interaction. `project.compile-all.xml` now additionally names every
  published generated type; its first run exposed missing dependencies and a parser syntax error
  that the working application never reaches.
- Class-path precedence is a real hazard. With this project's `src`, compatibility, `generated`
  ordering, later generated definitions can win. The candidate `WindowController` was selected
  even while its handwritten counterpart still existed. `SourceResolutionGuard` verifies this.
  **Over-generating is safe only outside the production class path**, not simply because a seam
  exists in `src`.
- The window identity collisions include `IWindow`,
  `WindowController`, `ParamCodeTable`, `WindowParser`. The two `WindowParam` classes use different
  packages (`enums` versus `_enum`), so file names alone are not an ownership inventory.
  V22 also isolates the original `Localization` from the production bootstrap's static helper;
  use the audit's current collision list rather than treating this list as exhaustive.
- Windows path case and escaped Haxe package names confused closure selection: an AS3 identifier
  `MAP` could resolve to `Map.as`, bypassing a case-sensitive seam check. The active closure
  walkers now case-fold seam checks and account for `enum` -> `_enum` when finding existing output.
- Several failures share compiler causes, not missing feature code. Fixed and regression-tested:
  XML indexing losing its expected type, implicit interface downcasts in typed loops,
  `Object(this).constructor`, recursive setter assignment, complementary inherited accessors,
  and reference equality across interface/concrete types. The furniture-shadow bug was
  another: treating `Math.ceil` as already integer-valued erased AS3's NaN-to-zero conversion.
  The fix preserves Number results and performs coercion at the consuming integer boundary.
- Window skin XML/String comparison now has a tested, narrow E4X runtime bridge. It preserves
  singleton/simple-content rules rather than flattening every XMLList to a string. The contract
  comes from [ECMA-357 sections 9.2.1.9 and 11.5.1](https://www.ecma-international.org/wp-content/uploads/ECMA-357_2nd_edition_december_2005.pdf).
- The candidate GraphicContext keeps the original attach/detach implementation. Its writable
  parent property is mechanically renamed to `graphicParent` because OpenFL's native `parent`
  is read-only; a getter delegates to the native field. Filter arrays use the native BitmapFilter
  element type. `scripts/verify-window-graphics.ps1` tests actual converted attach/reparent,
  mouse, filters and disposal behavior in headless Chrome. This is a sub-gate, not a complete
  skinned-window or infostand acceptance test.
- The communication host accepted new message-event registrations without registering them.
  It now delegates registration/removal to the real connection. A green interface check would
  never have detected that runtime omission.
- Truffle now supplies candidate Canvas/WebGL text pixels and character advances, including
  normal-AA text. Browser tests cover exact-face glyph availability, unfocused selection,
  thickness and width; one test disables browser `fillText` to reject fallback. The OpenFL
  override is pinned and prepared in isolation, not installed globally. All font rendering is
  required to use Truffle at cutover. DOM/input, wrapped/mixed-style Flash reference fidelity,
  and inline HTML images are not completed by these tests.

## Recommended order

1. Finish a **concrete window-runtime gate**, including a real skinned button/frame/list/text
   canary with input and disposal. The inherited-property, reference/XML comparison, and basic
   graphic-context and tested text gaps now have fixes. V22 adds the actual manager/skin service
   (151 additional source files, including embedded wrappers and localization, measured separately).
   The combined compile root names 498 types. Do not add silent
   no-op methods just to reduce the error count.
2. Integrate the original window manager and room desktop/widget ownership, then the infostand.
   Accept the slice only when clicking furniture/avatars shows live data and authorized
   Move/Rotate/Pick up actions reach the normal generated engine/protocol path. Include room
   leave/re-entry, removal and selection changes in that test.
3. Expand by dependency-coherent packages to **compiles**, in the candidate tree. Group compiler
   errors by root cause and write a tiny AS3 -> generated Haxe -> JS test before each shared fix.
   Re-run representative room/avatar/parser/window gates before publication.
4. Wire features one at a time, keeping the working client usable. Do not postpone browser
   verification until many widgets have been wired together.

Deleting the old UI files belongs to the successful cutover, not the start of conversion: the
current login/toolbar still consume their Sprite-oriented API. Update those consumers to the
original manager's API, verify source resolution, and only then retire the old implementation.

## What would improve speed most

**A reproducible candidate-to-release workflow.** One command should regenerate, compile all
named concrete types, run small semantic tests, and build the client. A separate explicit
promotion step should check ownership collisions and replace only validated outputs. The current
scratch publication fix prevents conversion failures from clearing output, but is not yet a
whole-directory transactional release system and does not itself prove compilation.

**One ownership registry, not expanding per-slice guesses.** Record fully qualified source
identity, generated owner, unavoidable platform adapter, compile profile and runtime status.
Build closure selection, collision checks and compile roots from it. Keep platform exclusions
separate from optional product features. This is recommended next framework work; it has not been
silently imposed across all existing closures in this run.

**Stable boundaries and automatic evidence.** Include emitted helper modules (`Globals.hx`,
`import.hx`) in reproducibility checks. Preserve unchanged timestamps. Avoid redefining closures
based solely on whichever files happen to be present after the last failed run. Replace repeated
manual context/count edits with guarded per-source normalization contracts where practical.

**A fixed browser acceptance fixture.** Maintain one guest room with stateful furniture/shadows,
one public room at avatar scale 32, and a predictable selected-user/furniture flow. Record packet
inputs and expected model values; sample actual rendered output and input dispatch. Keep secrets
out of fixtures. This catches the silent state/offset/lifecycle regressions that builds cannot.

**Measure delivery, not activity.** Track time to a verified interaction, number of regressions,
distinct converter gaps, deterministic rebuilds and how many handwritten feature owners were
retired. File totals are useful planning inputs, not progress scores. No defensible numeric speedup
estimate exists yet; start measuring this workflow before promising one.

## Assessment of Claude's proposal

Agree: batching to **compiles**, then incremental wiring, is the right direction. The compile-all
target is implemented and deliberately reports the current failures rather than hiding them.

Disagree: generated duplicates are not automatically dead weight. The actual class-path test
disproves that for this build. Isolate candidates and assert ownership.

Qualify: three states are useful, but **wired** is not proof of Flash parity. Record a fourth
acceptance state: behavior verified, with the test/reference named. Likewise, broad compilation
does not make missing methods or placeholders legitimate implementations.

Do not automatically exclude Snowwar, onboarding or entire vendor namespaces based on counts.
Those are product-scope decisions or dependency questions. Some vendor code is already replaced
at a genuine browser boundary; that does not prove every file in its namespace is unnecessary.
No new product-feature exclusions were made in this run. The supplied per-area counts have not
been independently validated as a complete target inventory.

## Commands and limits

`python -m unittest discover -s test -p test_sync_publication.py`

After loading `scripts/toolchain-env.ps1`:

- `python evidence/v21_converter_regression.py` — real conversion plus JavaScript semantics.
- `powershell -File scripts/verify-shadow.ps1` — published generated shadow path in headless Chrome.
- `powershell -File scripts/verify-window-graphics.ps1` — isolated generated graphics-context behavior.
- `python scripts/generate-infostand-compile-root.py` then
  `haxelib run openfl build project.v20-infostand.xml html5 -debug` — isolated concrete UI gate;
  currently builds; this is not a product or runtime acceptance build.
- `powershell -File scripts/verify-window-services.ps1` — real HTTP asset lifecycle, embedded
  binary/bitmap ownership and host-link sub-gates.
- `python scripts/generate-infostand-compile-root.py --window-manager` then
  `haxelib run openfl build project.v22-window-manager.xml html5 -debug` — expanded isolated root.
- `haxelib run openfl build project.v22-window-runtime.xml html5 -debug` then
  `python scripts/verify-browser-probe.py --page test/window-runtime.html --marker V22_WINDOW_RUNTIME_PASS --result evidence/window_runtime_verification.json`
  — original manager, localization and original skin assets. This canary now passes;
  a pass here alone does not establish Flash pixel parity or complete Infostand wiring.
- `powershell -File scripts/verify-window-runtime.ps1` — prepare pinned assets/overrides, build
  the combined root, then run the 34-style/control/list/disposal canary.
- `python evidence/m2_patch_ax3.py --verify --snapshot` — verify the reproducible converter
  patches and refresh archival copies; the patch script plus tracked additions are authoritative.
- `python scripts/generate-compile-all.py` then
  `haxelib run openfl build project.compile-all.xml html5 -debug` — full published-type inventory
  gate; currently failing on previously unreachable types.
- `haxelib run openfl build project.xml html5 -debug` — historical pre-v32 runnable build. This is
  not the preserved working v32 project; see `README.md` for the current, not-yet-clean-validated
  v32 development command.

No edits were made to the clean-client source or asset corpus. No commits or staging were done.
Photo CORS and loading-performance changes remain out of scope.
