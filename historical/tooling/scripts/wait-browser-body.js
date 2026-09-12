/* Run a page in headless Chrome and print its body after a marker appears. */
const { spawn } = require("child_process");
const os = require("os");
const path = require("path");

function arg(name, fallback) {
  const i = process.argv.indexOf("--" + name);
  return i >= 0 && process.argv[i + 1] !== undefined ? process.argv[i + 1] : fallback;
}

const chrome = arg("chrome", "C:/Program Files/Google/Chrome/Application/chrome.exe");
const url = arg("url", "http://127.0.0.1:8791/swf-decode.html");
const marker = arg("marker", "SWF_DECODE_BASELINE ");
const timeout = Number(arg("timeout", "120000"));
const debugPort = Number(arg("debug-port", "9391"));
const profile = path.join(os.tmpdir(), "skyhaxe-test-" + Date.now());
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

(async () => {
  const child = spawn(chrome, ["--headless=new", "--disable-gpu", "--no-first-run",
    "--no-default-browser-check", `--user-data-dir=${profile}`,
    `--remote-debugging-port=${debugPort}`, url], {stdio: "ignore"});
  try {
    let target;
    for (let i = 0; i < 120 && !target; i++) {
      await sleep(100);
      try {
        const pages = await (await fetch(`http://127.0.0.1:${debugPort}/json`)).json();
        const wanted = new URL(url);
        target = pages.find((page) => page.type === "page" && page.webSocketDebuggerUrl
          && page.url.includes(wanted.host));
      } catch (_) {}
    }
    if (!target) throw new Error("Chrome exposed no page target");
    const ws = new WebSocket(target.webSocketDebuggerUrl);
    await new Promise((resolve, reject) => {
      ws.onopen = resolve;
      ws.onerror = () => reject(new Error("DevTools connection failed"));
    });
    let nextId = 0;
    const pending = new Map();
    ws.onmessage = (event) => {
      const message = JSON.parse(event.data);
      if (message.id && pending.has(message.id)) {
        pending.get(message.id)(message);
        pending.delete(message.id);
      }
    };
    const send = (method, params = {}) => new Promise((resolve) => {
      const id = ++nextId;
      pending.set(id, resolve);
      ws.send(JSON.stringify({id, method, params}));
    });
    const started = Date.now();
    let body = "";
    while (Date.now() - started < timeout) {
      const reply = await send("Runtime.evaluate", {
        expression: "document.body ? document.body.innerText : ''", returnByValue: true
      });
      body = reply.result && reply.result.result && reply.result.result.value || "";
      if (body.includes(marker) || body.includes("SWF_DECODE_BASELINE_FAIL ")) break;
      await sleep(100);
    }
    ws.close();
    process.stdout.write(body);
    if (!body.includes(marker)) process.exitCode = 2;
  } finally {
    child.kill();
  }
})().catch((error) => { console.error(error.stack || error); process.exitCode = 1; });
