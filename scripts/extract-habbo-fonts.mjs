// Reproduce the font-only module and assets from the pinned Habbo HTML5 release.
// The launcher is parsed as data; its application entry point is never executed.
import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';
import { inflateSync } from 'node:zlib';
import { parse } from 'acorn';
import { analyze } from 'eslint-scope';

const repo = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const archiveHash = 'f6a080f39dcdb10f920ce7c4153e4e04687b7e4c5f533d738fd8e9256f3b8ae9';
const launcherHash = '0827769ec42c99aa6206e6746007a5cbd159d99ea40f059f22a7377e69a65b3b';
const hash = bytes => createHash('sha256').update(bytes).digest('hex');

export function readArchive(bytes, path) {
  const tree = JSON.parse(bytes.subarray(16, 16 + bytes.readUInt32LE(12)));
  let entry = tree;
  for (const part of path.split('/')) entry = entry.files[part];
  if (!entry || entry.unpacked) throw new Error(`Missing packed ASAR entry: ${path}`);
  const start = 8 + bytes.readUInt32LE(4) + Number(entry.offset);
  const result = bytes.subarray(start, start + entry.size);
  if (result.length !== entry.size) throw new Error(`Truncated ASAR entry: ${path}`);
  return result;
}

export function fontClosure(source) {
  const ast = parse(source, { ecmaVersion: 'latest', sourceType: 'module', ranges: true });
  const scopes = analyze(ast, { ecmaVersion: 2024, sourceType: 'module', optimistic: true, ignoreEval: true });
  const top = scopes.scopes.find(scope => scope.type === 'module');
  const units = [];
  function bindings(node) {
    if (node.type === 'Identifier') return [node.name];
    if (node.type === 'ObjectPattern') return node.properties.flatMap(p => bindings(p.value || p.argument));
    if (node.type === 'ArrayPattern') return node.elements.filter(Boolean).flatMap(bindings);
    if (node.type === 'RestElement') return bindings(node.argument);
    if (node.type === 'AssignmentPattern') return bindings(node.left);
    throw new Error(`Unsupported binding ${node.type}`);
  }
  for (const statement of ast.body) {
    if (statement.type === 'VariableDeclaration') {
      for (const d of statement.declarations) {
        units.push({ names: bindings(d.id), start: d.start, end: d.end, code: `var ${source.slice(d.start, d.end)};` });
      }
    } else if (statement.type === 'FunctionDeclaration') {
      units.push({ names: [statement.id.name], start: statement.start, end: statement.end, code: source.slice(statement.start, statement.end) });
    } else if (statement.type === 'ExpressionStatement'
      && !(statement.expression.type === 'CallExpression' && statement.expression.callee.name === 'n')) {
      units.push({ names: [], start: statement.start, end: statement.end, code: source.slice(statement.start, statement.end) });
    }
  }
  for (const unit of units) unit.refs = new Set();
  // Associate resolved references with their owning top-level unit, including prototype setup.
  for (const variable of top.variables) for (const ref of variable.references) {
    let lo = 0, hi = units.length;
    while (lo < hi) { const mid = (lo + hi) >>> 1; if (units[mid].start <= ref.identifier.start) lo = mid + 1; else hi = mid; }
    const unit = units[lo - 1];
    if (unit && ref.identifier.end <= unit.end) unit.refs.add(variable.name);
  }
  const roots = ['Wc', 'bOe', 'fOe', 'lZ', 'rie', 'Zqe', 'qqe', 'Jqe', 'dZ'];
  const selected = new Set(roots), chosen = new Set();
  selected.add('n');
  let changed = true;
  while (changed) {
    changed = false;
    for (const unit of units) {
      if (chosen.has(unit) || unit.names.includes('n')) continue;
      if (!unit.names.some(name => selected.has(name))
        && !(unit.names.length === 0 && [...unit.refs].some(name => name !== 'n' && selected.has(name)))) continue;
      chosen.add(unit); changed = true;
      for (const name of unit.refs) selected.add(name);
    }
  }
  if (chosen.size > 1500) throw new Error('Font closure unexpectedly includes the application');
  const code = [...chosen].sort((a, b) => a.start - b.start).map(unit => unit.code).join('\n');
  return {
    code: '// Generated font-only dependency closure. See manifest.json for source provenance.\n'
      + 'var n = (value, name) => Object.defineProperty(value, "name", {value:name, configurable:true});\n'
      + code + '\nexport {Wc as NativeText, bOe as registerNative, fOe as prepareBundle, lZ as NativeRenderer, rie as VolterFallback, Zqe as registerTtf, qqe as ttfMetrics, Jqe as scaleTtfMetrics, dZ as parsedTtf};\n',
    units: [...chosen].sort((a, b) => a.start - b.start).map(u => ({ names: u.names, start: u.start, end: u.end }))
  };
}

export async function extract(archivePath, output = resolve(repo, 'public/assets/habbo-text')) {
  const bytes = await readFile(archivePath);
  if (hash(bytes) !== archiveHash) throw new Error('ASAR does not match the pinned font reference');
  const launcher = readArchive(bytes, 'habbo-air/HabboAirLauncher.app.js');
  if (hash(launcher) !== launcherHash) throw new Error('Launcher hash differs');
  const closure = fontClosure(launcher.toString());
  const hab = readArchive(bytes, 'generated/habbo-window-manager-com.hab');
  if (hab.subarray(0, 4).toString() !== 'HAB\0' || hab.readUInt16LE(4) !== 1) throw new Error('Unsupported HAB container');
  const index = JSON.parse(inflateSync(hab.subarray(20, 20 + hab.readUInt32LE(8))));
  const payload = hab.subarray(20 + hab.readUInt32LE(8));
  await mkdir(resolve(output, 'fonts'), { recursive: true });
  await mkdir(resolve(output, 'profiles'), { recursive: true });
  const files = [];
  async function emit(path, data) {
    await writeFile(resolve(output, path), data);
    files.push({ file: path, bytes: Buffer.byteLength(data), sha256: hash(data) });
  }
  await emit('native-core.mjs', closure.code);
  await emit('text.mjs', await readFile(resolve(repo, 'src/skyhaxe/text/habbo-text.mjs')));
  const fonts = [];
  for (const e of index.entries) {
    if (e.mimeType !== 'application/x-font-truetype' && !e.name.endsWith('_air51')) continue;
    let data = payload.subarray(e.offset, e.offset + e.storedLength);
    if (e.compression === 'deflate') data = inflateSync(data);
    else if (e.compression !== 'none') throw new Error('Unsupported HAB compression');
    if (data.length !== e.originalLength) throw new Error(`HAB length differs: ${e.name}`);
    const path = e.name.endsWith('_air51') ? `profiles/${e.name}.json` : `fonts/${e.name}.ttf`;
    await emit(path, data);
    if (e.name.endsWith('_air51')) {
      const bundle = JSON.parse(data);
      if (bundle.format !== 'air32-native-font-bundle-v1') throw new Error(`Unsupported profile ${e.name}`);
    } else fonts.push({ asset: e.name, file: path, sha256: hash(data) });
  }
  for (const font of fonts) {
    const profile = files.find(f => f.file === `profiles/${font.asset}_air51.json`);
    if (profile) {
      const bundle = JSON.parse(await readFile(resolve(output, profile.file)));
      if (bundle.fontSha256 !== font.sha256) throw new Error(`TTF/profile mismatch: ${font.asset}`);
      font.profile = profile.file;
    }
  }
  const manifest = { schema: 1, renderer: 'habbo-html5-air51', archiveSha256: archiveHash,
    launcherSha256: launcherHash, runtime: '51.3.2.1', fonts, files, sourceUnits: closure.units };
  await writeFile(resolve(output, 'manifest.json'), JSON.stringify(manifest, null, 2) + '\n');
  return manifest;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  if (!process.argv[2]) throw new Error('Usage: node scripts/extract-habbo-fonts.mjs PATH_TO_APP_ASAR [OUTPUT]');
  const manifest = await extract(process.argv[2], process.argv[3] && resolve(process.argv[3]));
  console.log(`Extracted ${manifest.fonts.length} fonts, ${manifest.sourceUnits.length} code units, ${manifest.files.reduce((n,f)=>n+f.bytes,0)} bytes`);
}
