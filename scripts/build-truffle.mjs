// Bundle truffle-text into a single ESM file the OpenFL page can dynamic-import.
//
// truffle-text is ESM with two Emscripten/WASM dependencies (FreeType and HarfBuzz). Those
// resolve their .wasm relative to the importing module's URL, so the bundle and the .wasm files
// have to sit in the same directory. esbuild's `file` loader emits them there and rewrites the
// URLs to match.
import { build } from 'esbuild';
import { copyFile, mkdir, readFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';

const OUT_DIR = 'public/assets/truffle/lib';

await mkdir(OUT_DIR, { recursive: true });

const result = await build({
  entryPoints: ['node_modules/truffle-text/src/packed.js'],
  outfile: join(OUT_DIR, 'truffle.js'),
  bundle: true,
  format: 'esm',
  platform: 'browser',
  target: 'es2022',          // truffle and harfbuzz both use top-level await
  loader: { '.wasm': 'file' },
  assetNames: '[name]',
  external: ['react'],          // the React entry point is not used here
  plugins: [{
    // SkyHaxe only needs the baked raster chunks for its known boot styles. Upstream
    // `ensureStyles()` also enables the three legacy calibration tables first, which downloads
    // and JSON-parses roughly 50 MiB before HabboMain can start. Add an explicit fast path while
    // preserving upstream `ensureStyles()` for callers which genuinely need generative fallback.
    name: 'skyhaxe-baked-styles',
    setup(build) {
      const packed = /[\\/]truffle-text[\\/]src[\\/]packed\.js$/;
      build.onLoad({ filter: packed }, async args => {
        let contents = await readFile(args.path, 'utf8');
        const marker = '  /** Lazily add raster chunks for more styles, then invalidate cached engines. */\n'
          + '  truffle.ensureStyles = async styleList => {';
        if (!contents.includes(marker)) {
          throw new Error('truffle-text packed loader changed; baked-style fast path was not applied');
        }
        contents = contents.replace(marker,
          '  /** Load only already-baked raster chunks; no legacy calibration JSON is required. */\n'
          + '  truffle.ensureBakedStyles = async styleList => {\n'
          + '    await loadSignatures(signaturesForStyles(styleList, manifest));\n'
          + '    truffle._engines.clear();\n'
          + '  };\n\n'
          + marker);
        return { contents, loader: 'js' };
      });
    },
  }, {
    // truffle and freetype-wasm keep Node-only branches behind `await import('node:...')`.
    // Those paths never run in a browser, so resolve them to an empty module rather than
    // letting esbuild fail on built-ins that do not exist here.
    name: 'stub-node-builtins',
    setup(build) {
      const builtins = /^(node:fs\/promises|node:fs|node:path|node:url|module|fs|path|url)$/;
      build.onResolve({ filter: builtins }, (args) => ({ path: args.path, namespace: 'node-stub' }));
      build.onLoad({ filter: /.*/, namespace: 'node-stub' }, () => ({
        contents: 'export default {}; export const readFile = undefined; '
          + 'export const createRequire = () => () => ({});',
        loader: 'js',
      }));
    },
  }],
  logLevel: 'info',
  metafile: true,
});

// Emscripten also probes for its .wasm by filename next to the module, so place both copies
// regardless of what the loader rewrote.
for (const source of [
  'node_modules/@zkl2333/freetype-wasm/dist/freetype.wasm',
  'node_modules/harfbuzzjs/dist/harfbuzz.wasm',
]) {
  await copyFile(source, join(OUT_DIR, source.split('/').pop()));
}

const bytes = Object.values(result.metafile.outputs).reduce((sum, o) => sum + o.bytes, 0);
console.log(`truffle bundle written to ${OUT_DIR} (${(bytes / 1048576).toFixed(2)} MiB)`);
