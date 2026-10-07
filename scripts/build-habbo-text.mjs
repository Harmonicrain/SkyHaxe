import { readFile, writeFile } from 'node:fs/promises';
import { createHash } from 'node:crypto';
const root = 'public/assets/habbo-text';
const manifest = JSON.parse(await readFile(`${root}/manifest.json`));
const hash = bytes => createHash('sha256').update(bytes).digest('hex');
for (const file of manifest.files.filter(f => f.file !== 'text.mjs')) {
  if (!/^(native-core\.mjs|(fonts|profiles)\/[\w.-]+)$/.test(file.file)) throw new Error('Unsafe font manifest path');
  const data = await readFile(`${root}/${file.file}`);
  if (data.length !== file.bytes || hash(data) !== file.sha256) throw new Error(`Font resource differs: ${file.file}`);
}
const adapter = await readFile('src/skyhaxe/text/habbo-text.mjs');
await writeFile(`${root}/text.mjs`, adapter);
manifest.files = manifest.files.filter(f => f.file !== 'text.mjs');
manifest.files.splice(1, 0, { file: 'text.mjs', bytes: adapter.length, sha256: hash(adapter) });
await writeFile(`${root}/manifest.json`, JSON.stringify(manifest, null, 2) + '\n');
console.log('Habbo font resources verified and adapter copied');
