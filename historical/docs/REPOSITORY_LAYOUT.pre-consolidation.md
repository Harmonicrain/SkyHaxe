# Repository ownership

This file distinguishes the supported working client from regeneration inputs, regression
fixtures, historical evidence, and disposable build products. Git-ignored does not mean dead.

## Supported working client

| Path | Owner and role |
|---|---|
| `project.v32-runtime.xml` | Active OpenFL project composition. Includes `project.xml` for shared libraries/assets. |
| `candidate/v32/` | Browser entry point, runtime host and editable configuration template. All three files are required. |
| `.toolchain/v32/generated/` | Complete converted v32 component graph plus v33 original loading screen. Generated; never hand-edit. |
| `.toolchain/v32/platform/` | Nine browser/OpenFL adaptations reproduced by the guarded platform patch. |
| `.toolchain/v32/component-library-assets.xml` | Generated embedded-component asset declarations required by the active project. |
| `.toolchain/ax3/compat/` | AS3 compatibility layer used by converted code. |
| `src/` | Deliberate browser/OpenFL/runtime seams and shared tested foundations. A same-named AS3 class requires explicit ownership review. |
| `public/` | Browser runtime payload, including the SWF decode worker and ignored generated Truffle assets. |
| `build/v32/html5/bin/` | Preserved working served artifact. Derived, but protected until a clean rebuild and package smoke test pass. |
| `scripts/serve-client.py` | Development server with `/ngh/`, Truffle and allow-listed remote-image handling. |

The runtime also depends on external NGH content beneath `C:\habbo\ngh`. That corpus is not
SkyHaxe source and should be supplied/configured separately for distribution. The current machine’s
corpus is a private runtime input, not something cleanup may absorb or delete.

The active v32 project currently has three genuine legacy-path dependencies inherited through
`project.xml`: `.toolchain/v21/embedded-assets.xml`, `.toolchain/v21/window-assets.xml`, and
`.toolchain/v24/room-ui-assets.xml`. The `skyhaxe_full_candidate` define excludes the old v21 and
v24–v26 source/class paths, but it does not exclude those asset includes. Keep them until their
1,620 declarations are reproduced through a version-neutral `build-support/assets/` boundary and
an isolated v32 build passes. The build-support directory should own specifications/generators;
each isolated run should emit its generated manifests into its own workspace.

## Reproduction ownership

`https://github.com/habbo-cc/Habbo-Sky/tree/wired2-ngh` is the authoritative AS3 source. The pinned converter, SWCs,
rules, closures, compatibility layer and post-generation patches are declared by
`reproducibility/v32/composition.json`. `scripts/reproduce-v32.py` may write only to a new external
run root. Its final generated/platform/compat trees must match the preserved baseline exactly.

The converter and its required local inputs under `.toolchain/ax3`, `.toolchain/g1c`, the pinned
Flex SWCs, `scripts/sync.py`, `scripts/m2_rules.py`, and the named `evidence/m2_*` inputs are
regeneration dependencies. Do not delete them as caches.

## Regression and historical ownership

- Top-level `generated/`, `.toolchain/v21`, `.toolchain/v24`–`v27`, `.toolchain/v31`, historical
  project files and `test/` still participate in older regression paths. They are not active v32
  runtime inputs, but references must be migrated or archived before removal.
- `evidence/` contains both active manifests and historical gate evidence. Version age alone is not
  permission to delete it.
- `PLAN.md`, `CHECKLIST.md`, and `DELIVERY_REVIEW.md` are historical migration records. Current
  instructions live here and in `README.md`.
- `build/tests/` and most other `build/` children are derived test outputs. They may be removed only
  after their producing command and retained evidence have been identified.

## Validation boundary

Batch 2 proves deterministic generation and byte parity, not clean-checkout compilation,
packaging, deployment, or production hosting. After an approved cleanup, validate affected
references first, rerun the external two-run reproduction gate, perform a clean v32 build, and
smoke-test the packaged client without replacing the preserved artifact until it passes.
