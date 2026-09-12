# Repository cleanup and consolidation record

Inventory captured 2026-09-11 after the Batch 2 reproducibility gate. Classification is based on
active OpenFL source paths, script/project/doc references, file-set comparison with
`.toolchain/v32`, and the preserved baseline—not merely age, version numbers, or `.gitignore`
status. The owner-approved narrow cleanup has been moved recoverably to
`C:\Users\John\Documents\SkyHaxe-Cleanup-Archives\cleanup-20260911T1605`; its per-file hashes and
restoration instructions are stored there. No broader cleanup is approved by this document.

## Supported-entrypoint trace

`project.v32-runtime.xml` defines `skyhaxe_full_candidate` before including `project.xml`.
Consequently the old `generated/`, v21 generated/OpenFL overlay, and v24/v25/v26 source paths in
`project.xml` are excluded from the supported classpath. Three old-path asset includes are not
conditional and are genuine supported dependencies:

| Current dependency | Declarations | Status |
|---|---:|---|
| `.toolchain/v21/embedded-assets.xml` | 113 | Required; every declared source currently exists. |
| `.toolchain/v21/window-assets.xml` | 971 | Required; every declared source currently exists. |
| `.toolchain/v24/room-ui-assets.xml` | 536 | Required; every declared source currently exists. |

The supported project additionally consumes `.toolchain/v32/generated`,
`.toolchain/v32/platform`, `.toolchain/v32/component-library-assets.xml`, `candidate/v32`, `src`,
`.toolchain/ax3/compat`, and `public/swf-decode-worker.js`. None was included in cleanup.

## Required by the supported build/runtime

Keep unchanged:

- `candidate/v32/` — 3 files / 36,157 bytes; directly referenced by `project.v32-runtime.xml`.
- `.toolchain/v32/` — 5,397 files / 22,356,352 bytes; active generated, platform and component
  asset declarations.
- `.toolchain/ax3/compat/`, `src/`, `public/`, `project.xml`, and `project.v32-runtime.xml` — active
  class paths, shared project settings and browser payload.
- `build/v32/html5/bin/` — the preserved working artifact. It remains protected until a separate
  clean build/package smoke test passes.
- `scripts/serve-client.py` and external `C:\habbo\ngh` runtime data — required by the current
  local served client.

## Required for regeneration or regression testing

Keep for now:

- `reproducibility/v32/`, `scripts/reproduce-v32.py`, `scripts/sync.py`, `scripts/m2_rules.py`, the
  two closure manifests and named `m2_*` inputs.
- `.toolchain/ax3/` and `.toolchain/g1c/habbo-client.swc`, plus the pinned Flex SWCs and
  `habbo-client-clean` checkout.
- Top-level `generated/` (2,131 files / 4,890,366 bytes): it is still on 19 project class paths and
  is written by `scripts/generate-message-registry.py`. It is not the active v32 generated tree,
  but deleting it now would break regression projects.
- `.toolchain/v21`, `v24`, `v25`, `v26`, `v27`, `v31`, `v7-shadow`: explicit references remain in
  project files, tests or preparation scripts. These references must be retired or redirected
  before any archive/removal proposal can become executable.
- `test/`, the G1d/G2/G3/G4 project files, and their test scripts. These are semantic regression
  coverage, not obsolete merely because the working client has advanced.

## Historical evidence worth archiving

Remaining archive candidates, with original paths and hashes to be recorded before any move:

- `PLAN.md`, `CHECKLIST.md`, `DELIVERY_REVIEW.md` and superseded milestone narratives in
  `evidence/`. Keep them read-only under a clearly named historical area; retain active manifests,
  generators and contract baselines in place.
- `evidence/v32_boot_live_probe.json` and `evidence/v32_boot_screenshot.png`. Their pre-Batch-2
  versions were already unavailable; the current outputs match the Batch 1 preserved copies and
  must not be presented as older historical results.

## Completed owner-approved archive/removal

The following were moved to the recoverable external archive, not permanently erased:

1. `.toolchain/v32-habbomain/` — 4 files / 17,755 bytes. No supported command referenced it. Its
   two changed files contained no unique fix: old `Globals` was a strict subset of active v32 and
   old `HabboMain` lacked the guarded cooperative-loading fix now preserved by Batch 2.
2. `build/v32-double-click/` — 14 files / 42,179,126 bytes. Derived output only; its retained probe
   project can recreate the directory.
3. `.toolchain/v28/`, `v29/`, `v30/`, and `v32-isolated/` — 5,810 historical/generated files.
   Their manifests/logs and complete contents remain in the archive.

`build/tests/` was left untouched because its per-output mapping is incomplete.

Post-cleanup validation passed:

- The external archive contains 5,828 files / 66,153,248 bytes; every recorded size and SHA-256
  revalidated successfully.
- Two new isolated reproductions are byte-identical to one another and to the preserved working
  generated/platform/compatibility baseline. Evidence:
  `evidence/v32_post_cleanup_reproducibility.json`.
- All supported project, candidate, v32, compatibility, asset-manifest, worker and served-artifact
  paths still exist. Documentation has no missing local links.
- The only non-documentation reference to a moved path is
  `project.v32-double-click-check.xml` declaring `build/v32-double-click` as its output. That is
  intentional: running the retained probe recreates the derived directory.
- The served bundle SHA-256 remains
  `cae1e811e37a81bf812f3a5c097d1e186c5a31adf59b8fbe0ea60cd2ca79f9fd`; port 8766 was not
  restarted.

No deletion is proposed yet for `build/html5`, top-level `generated`, `node_modules`, `.haxelib`,
`.toolchain/downloads`, external assets, or any untracked work. Their derivation or current
references must be resolved first.

## Proposed supported-layout consolidation — approval required

1. Create one version-neutral `build-support/assets/` ownership boundary containing the component,
   embedded, window-skin and room-UI manifest specifications/generators. Emit isolated generated
   manifests inside each run workspace and add their inputs and expected hashes to the
   reproducibility composition.
2. Make the three old asset includes conditional for legacy projects and have
   `project.v32-runtime.xml` include only manifests from the version-neutral build-support boundary.
3. Build from a copied/isolated project root using the newly reproduced generated, platform,
   compatibility and asset-manifest trees. Compare packaged asset IDs/counts with the preserved
   build and smoke-test login plus room entry.
4. Only after that pass, remove the old v21/v24 asset-manifest locations. Retain or archive their
   other contents according to the historical regression groups below.
5. Archive `.toolchain/v25`, `v26`, and `v27` together with their vertical-slice project files,
   closure/sync evidence and helper scripts; supported v32 excludes these classpaths. Do not move
   them until the archive set has a reference-complete manifest.
6. Treat `.toolchain/v31` and `project.compile-all.xml` as one historical compile-frontier group.
   Preserve the inventory/log evidence together rather than leaving a dangling project.
7. Keep the shadow regression, but retarget its focused test to the active/reproduced v32 source;
   after it passes, archive `.toolchain/v7-shadow` with the old project rather than retaining a
   permanent milestone dependency.

## Superseded scripts and project files requiring a decision

The following are archive candidates, not confirmed dead:

- `scripts/build-html5.ps1` and `scripts/serve-html5.ps1` target the older
  `project.xml`/`build/html5/bin` workflow. Four G1d verification scripts still invoke the build
  wrapper, so removal requires a dedicated regression wrapper or an explicit archival decision.
- Vertical-slice projects `project.v20-infostand.xml`, `project.v24-infostand*.xml`,
  `project.v25-infostand-services.xml`, `project.v26-room-session-services.xml`,
  `project.v27-friend-list-services.xml`, `project.v4-*`, `project.v5-avatar.xml`, and
  `project.v7-guest-room.xml` document earlier compile frontiers. Some have no inbound text
  references, but they are executable entry points; absence of inbound references alone does not
  prove they are disposable.
- Probe projects (`project.probe.xml`, `project.shadow-check.xml`,
  `project.window-input-check.xml`, `project.bitmap-copy-check.xml`, and
  `project.v32-double-click-check.xml`) should be retained when their focused regression remains
  valuable, or archived together with its test and evidence. Do not remove only the project file.

## Validation sequence for a future approved cleanup

After the owner approves an exact subset:

1. Record paths, sizes and SHA-256 hashes; archive historical items before removal.
2. Remove only that subset as a recoverable, reviewable change.
3. Scan XML, scripts, manifests and documentation for dangling references.
4. Rerun `scripts/reproduce-v32.py` twice in a new external directory and require exact baseline
   parity.
5. Run a clean v32 build using a documented command, package its required deployment assets, and
   smoke-test login and room entry separately from the preserved served artifact.
6. Report any setup/deployment step not exercised as untested rather than inferred working.
