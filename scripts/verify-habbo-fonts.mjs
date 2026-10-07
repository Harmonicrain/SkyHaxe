import { readFile, writeFile, mkdir, mkdtemp, rm, stat } from 'node:fs/promises';
import { resolve, dirname, extname, sep } from 'node:path';
import { tmpdir } from 'node:os';
import { createServer } from 'node:http';
import { spawn } from 'node:child_process';
import { parse } from 'acorn';
import { readArchive } from './extract-habbo-fonts.mjs';

const repo = resolve('.');
const archive = process.argv[2];
if (!archive) throw new Error('Usage: node scripts/verify-habbo-fonts.mjs PATH_TO_ASAR');
const launcher = readArchive(await readFile(archive), 'habbo-air/HabboAirLauncher.app.js').toString();
const ast = parse(launcher, { ecmaVersion: 'latest', sourceType: 'module' });
const end = ast.body.find(s => s.type === 'VariableDeclaration' && s.declarations.some(d => d.id.name === 'Wc')).end;
await mkdir('build/font-reference', { recursive: true });
// Independent reference: the unmodified original launcher prefix, including its complete
// original dependencies. It stops before the application classes and never boots Habbo.
await writeFile('build/font-reference/native-oracle.mjs', launcher.slice(0, end)
  + '\nexport {Wc as NativeText, bOe as registerNative, Zqe as registerTtf, dZ as parsedTtf, rie as VolterFallback, qqe as ttfMetrics, Jqe as scaleTtfMetrics};\n');
const mime = { '.html':'text/html', '.js':'application/javascript', '.mjs':'application/javascript', '.json':'application/json', '.ttf':'font/ttf', '.png':'image/png', '.pak':'application/octet-stream' };
const server = createServer(async (request, response) => {
  try {
    const path = decodeURIComponent(new URL(request.url, 'http://localhost').pathname);
    const relative = path.startsWith('/assets/habbo-text/') ? '/public' + path : path;
    const file = resolve(repo, '.' + relative);
    if (!file.startsWith(repo + sep)) { response.writeHead(403).end(); return; }
    const data = await readFile(file);
    response.writeHead(200, { 'Content-Type': mime[extname(file)] || 'application/octet-stream' }).end(data);
  } catch { response.writeHead(404).end(); }
});
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const base = `http://127.0.0.1:${server.address().port}`;
const profile = await mkdtemp(resolve(tmpdir(), 'skyhaxe-font-'));
const debugPort = 9500 + Math.floor(Math.random() * 400);
const browser = spawn('C:/Program Files/Google/Chrome/Application/chrome.exe', [
  '--headless=new', '--no-first-run', '--no-default-browser-check', '--enable-unsafe-swiftshader',
  `--user-data-dir=${profile}`, `--remote-debugging-port=${debugPort}`, '--window-size=900,600', 'about:blank'
], { windowsHide: true, stdio: 'ignore' });
let socket;
const report = { schema: 1, browser: 'Chrome headless', errors: [] };
try {
  let targets;
  for (let i=0;i<100;i++) {
    try { targets=await (await fetch(`http://127.0.0.1:${debugPort}/json/list`)).json(); break; } catch {}
    await new Promise(r=>setTimeout(r,100));
  }
  if (!targets) throw new Error('Chrome did not start');
  socket=new WebSocket(targets.find(t=>t.type==='page').webSocketDebuggerUrl);
  await new Promise((resolve,reject)=>{socket.onopen=resolve;socket.onerror=reject;});
  let id=0;const pending=new Map();
  socket.onmessage=event=>{const m=JSON.parse(event.data);if(m.id){const p=pending.get(m.id);pending.delete(m.id);if(m.error)p.reject(new Error(JSON.stringify(m.error)));else p.resolve(m.result);}
    else if(m.method==='Runtime.exceptionThrown')report.errors.push(m.params.exceptionDetails.exception?.description||m.params.exceptionDetails.text);};
  const call=(method,params={})=>new Promise((resolve,reject)=>{const next=++id;pending.set(next,{resolve,reject});socket.send(JSON.stringify({id:next,method,params}));});
  await call('Page.enable');await call('Runtime.enable');
  async function page(path, expression) {
    await call('Page.navigate',{url:base+path});
    for(let i=0;i<300;i++) {
      const r=await call('Runtime.evaluate',{expression,returnByValue:true,awaitPromise:true});
      if(r.exceptionDetails)throw new Error(r.exceptionDetails.exception?.description||r.exceptionDetails.text);
      if(r.result?.value)return r.result.value;
      await new Promise(r=>setTimeout(r,100));
    }
    throw new Error('Timed out waiting for '+path);
  }
  report.reference=await page('/test/habbo-fonts.html','window.__fontTestsPromise');
  console.log('Reference comparison:',JSON.stringify(report.reference));
  if(!report.reference.ok)throw new Error(report.reference.stack||report.reference.error);
  report.openfl=await page('/build/font-tests/html5/bin/index.html','window.__fontHaxe');
  console.log('OpenFL integration:',JSON.stringify(report.openfl));
  if(!report.openfl.ok)throw new Error(report.openfl.stack||report.openfl.error);
  const screenshot=await call('Page.captureScreenshot',{format:'png'});
  await writeFile('build/font-reference/openfl.png',Buffer.from(screenshot.data,'base64'));
  report.ok=true;
} catch(error) { report.ok=false;report.error=String(error);console.error(error);process.exitCode=1;
} finally {
  await writeFile('build/font-reference/report.json',JSON.stringify(report,null,2)+'\n');
  socket?.close();browser.kill();server.close();
  // Chrome may still be closing its profile files; this cleanup is best-effort.
  await new Promise(r=>setTimeout(r,300));await rm(profile,{recursive:true,force:true,maxRetries:3,retryDelay:200}).catch(()=>{});
}
