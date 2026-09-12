/*
 * Boot probe for the v32 candidate against a live server.
 *
 * `probe-v32-boot.ps1` drives headless Chrome with --virtual-time-budget, which is what makes a
 * sixty second boot cheap to measure. That policy pauses virtual time whenever a network fetch is
 * outstanding, and a WebSocket to the game server never settles -- so the moment the client is
 * given an SSO ticket and actually connects, virtual time stops advancing and --dump-dom returns
 * an empty document, which reads exactly like a client that failed to boot.
 *
 * So this waits in wall-clock time and watches the page over the DevTools protocol instead. It
 * follows navigations explicitly, because the client redirects away on a fatal error and a probe
 * that samples once ends up reading whatever page replaced it. The hidden in-app browser cannot
 * stand in for either harness: Lime drives its frame loop from requestAnimationFrame, and a
 * hidden page is never given frames.
 */
const { spawn } = require("child_process");
const fs = require("fs");
const os = require("os");
const path = require("path");

function arg(name, fallback) {
  const i = process.argv.indexOf("--" + name);
  return i !== -1 && process.argv[i + 1] !== undefined ? process.argv[i + 1] : fallback;
}

const CHROME = arg("chrome", "C:/Program Files/Google/Chrome/Application/chrome.exe");
const PORT = arg("port", "8766");
const SSO = arg("sso", "12345");
const SECONDS = parseInt(arg("wait", "45"), 10);
const DEBUG_PORT = parseInt(arg("debug-port", "9333"), 10);

// The page origin matters: the seam derives connection.info.host from location.hostname, and a
// gateway that whitelists origins answers 403 to one it does not recognise.
const PAGE_HOST = arg("page-host", "127.0.0.1");
const url = `http://${PAGE_HOST}:${PORT}/index.html` + (SSO ? `#sso=${SSO}` : "");
const profile = path.join(os.tmpdir(), "skyhaxe-live-" + Date.now());
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));


/*
 * Habbo frames the wire as a 4-byte big-endian length followed by a 2-byte header id, so the id
 * is the only part worth printing: it says which packet the client sent and which the server
 * answered with, without dumping the payload.
 */
function describeFrame(response) {
  const bytes = Buffer.from(response.payloadData, "base64");
  if (bytes.length < 6) return `len=${bytes.length} (too short for a header)`;
  const declared = bytes.readInt32BE(0);
  const header = bytes.readUInt16BE(4);
  return `len=${bytes.length} declared=${declared} header=${header}`;
}

const ATTRS = `(function () {
  var r = document.documentElement, out = {url: location.href};
  ["candidate", "frames", "locked", "census", "processlog", "swf-metrics"].forEach(function (k) {
    out[k] = r.getAttribute("data-skyhaxe-" + k);
  });
  return JSON.stringify(out);
})()`;

(async () => {
  const chrome = spawn(CHROME, [
    "--headless=new", "--no-first-run", "--no-default-browser-check",
    "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--disable-dev-shm-usage",
    // The room is far larger than the default headless viewport, so content sits off-screen and
    // reads as an empty room. Match roughly what a real window shows.
    `--window-size=${arg("window", "1600,1000")}`,
    `--user-data-dir=${profile}`, `--remote-debugging-port=${DEBUG_PORT}`, url,
  ], { stdio: "ignore" });

  const events = [];
  const requestUrls = new Map();
  let last = null;
  try {
    let page = null;
    for (let i = 0; i < 60 && !page; i++) {
      await sleep(250);
      try {
        const list = await (await fetch(`http://127.0.0.1:${DEBUG_PORT}/json`)).json();
        page = list.find((t) => t.type === "page" && t.url.indexOf(`:${PORT}/`) !== -1)
            || list.find((t) => t.type === "page" && t.webSocketDebuggerUrl);
      } catch (_) { /* devtools not up yet */ }
    }
    if (!page) throw new Error("Chrome exposed no page target");

    const ws = new WebSocket(page.webSocketDebuggerUrl);
    await new Promise((res, rej) => { ws.onopen = res; ws.onerror = () => rej(new Error("devtools socket failed")); });

    let id = 100;
    const pending = new Map();
    ws.onmessage = (m) => {
      const d = JSON.parse(m.data);
      if (d.id && pending.has(d.id)) { pending.get(d.id)(d); pending.delete(d.id); return; }
      if (d.method === "Page.frameNavigated" && !d.params.frame.parentId) {
        events.push(`navigated -> ${d.params.frame.url}`);
      } else if (d.method === "Network.webSocketCreated") {
        events.push("ws created -> " + d.params.url);
      } else if (d.method === "Network.webSocketHandshakeResponseReceived") {
        events.push("ws handshake status=" + d.params.response.status);
      } else if (d.method === "Network.requestWillBeSent") {
        // loadingFailed carries no URL, so keep the mapping to name whatever fails.
        requestUrls.set(d.params.requestId, d.params.request.url);
        // Only the localization fetch matters here: HabboConfigurationManager unlocks on the
        // localization COMPLETE callback, which fires after external.texts.txt loads.
        if (/texts|localization|\.txt/i.test(d.params.request.url)) {
          events.push("http -> " + d.params.request.url.slice(0, 120));
        }
      } else if (d.method === "Network.responseReceived") {
        if (/texts|localization|\.txt/i.test(d.params.response.url)) {
          events.push("http " + d.params.response.status + " <- " + d.params.response.url.slice(0, 120));
        }
      } else if (d.method === "Network.loadingFailed") {
        events.push("http FAILED " + (requestUrls.get(d.params.requestId) || "<unknown url>")
          + " errorText=" + d.params.errorText
          + (d.params.blockedReason ? " blockedReason=" + d.params.blockedReason : "")
          + (d.params.corsErrorStatus ? " cors=" + JSON.stringify(d.params.corsErrorStatus) : ""));
      } else if (d.method === "Network.webSocketFrameSent") {
        events.push("ws SENT " + describeFrame(d.params.response));
      } else if (d.method === "Network.webSocketFrameReceived") {
        events.push("ws RECV " + describeFrame(d.params.response));
      } else if (d.method === "Network.webSocketClosed") {
        events.push("ws closed");
      } else if (d.method === "Network.webSocketFrameError") {
        events.push("ws frame error: " + d.params.errorMessage);
      } else if (d.method === "Runtime.consoleAPICalled") {
        // eventProcessor logs the failing handler's stack trace before the context is torn down;
        // the console is otherwise unusable here because the embed system floods it.
        const text = (d.params.args || []).map(function (a) {
          return a.value !== undefined ? String(a.value) : (a.description || "");
        }).join(" ");
        if (/iterator|dispatchEvent|Cannot read properties/i.test(text)) {
          events.push("console: " + text.slice(0, 1500));
        }
      } else if (d.method === "Runtime.exceptionThrown") {
        const e = d.params.exceptionDetails;
        events.push("exception: " + (e.exception && (e.exception.description || e.exception.value) || e.text));
      }
    };
    const send = (method, params) => new Promise((res) => { const n = ++id; pending.set(n, res); ws.send(JSON.stringify({ id: n, method, params })); });

    // Network.webSocketClosed carries no code or reason, and "closed" alone cannot say whether the
    // client or the server hung up. Wrapping the constructor before any page script runs records
    // both, plus anything the client sends after login.
    const WS_TAP = `
      (function () {
        window.__wsLog = [];
        var Native = window.WebSocket;
        window.WebSocket = function (url, protocols) {
          var socket = protocols === undefined ? new Native(url) : new Native(url, protocols);
          window.__wsLog.push("open " + url);
          socket.addEventListener("close", function (e) {
            window.__wsLog.push("close code=" + e.code + " clean=" + e.wasClean +
              (e.reason ? " reason=" + e.reason : ""));
          });
          // A local close() proves the client hung up; without this, code 1005 is ambiguous.
          var close = socket.close.bind(socket);
          socket.close = function (code, reason) {
            var stack = String(new Error("close").stack || "").substr(0, 4000);
            window.__wsLog.push("client called close(" + (code === undefined ? "" : code) + ") " + stack);
            return close(code, reason);
          };
          var send = socket.send.bind(socket);
          socket.send = function (data) {
            window.__wsLog.push("send bytes=" + (data && data.byteLength !== undefined ? data.byteLength : String(data).length));
            return send(data);
          };
          return socket;
        };
        window.WebSocket.prototype = Native.prototype;
        window.WebSocket.OPEN = Native.OPEN;
        window.WebSocket.CLOSED = Native.CLOSED;
        window.WebSocket.CLOSING = Native.CLOSING;
        window.WebSocket.CONNECTING = Native.CONNECTING;
      })();
    `;

    await send("Page.enable", {});
    await send("Runtime.enable", {});
    // The WebSocket lifecycle is the only way to tell a rejected ticket from a failed handshake:
    // both end as a disconnect reason, and the client redirects to logout.url either way.
    await send("Network.enable", {});
    await send("Page.addScriptToEvaluateOnNewDocument", { source: WS_TAP });

    // A sampling profile is the only way to attribute boot time without knowing in advance which
    // code is hot: wrapping guessed classes measures whatever you already suspected.
    const profiling = arg("profile", null) !== null;
    if (profiling) {
      await send("Profiler.enable", {});
      await send("Profiler.setSamplingInterval", { interval: 1000 });
    }
    await send("Page.reload", { ignoreCache: false });
    if (profiling) await send("Profiler.start", {});

    // Sampled every second: the client redirects to `logout.url` as soon as the server rejects a
    // ticket, and a coarser interval walks straight past the fully-resolved graph.
    for (let t = 0; t < SECONDS; t += 1) {
      await sleep(1000);
      const reply = await send("Runtime.evaluate", { expression: ATTRS, returnByValue: true });
      const value = reply.result && reply.result.result && reply.result.result.value;
      if (value) {
        const parsed = JSON.parse(value);
        if (parsed.candidate || parsed.census) last = parsed;
        events.push(`t=${t + 1}s candidate=${parsed.candidate} url=${parsed.url}`);
      }
    }
    // Drive the room the way a person would: pan the camera to find content in a large room,
    // then double-click it. A crash on interaction is invisible to a probe that only ever loads.
    const drag = arg("drag", null);
    if (drag) {
      const [x1, y1, x2, y2] = drag.split(",").map(Number);
      await send("Input.dispatchMouseEvent", { type: "mousePressed", x: x1, y: y1, button: "left", clickCount: 1 });
      const steps = 12;
      for (let i = 1; i <= steps; i++) {
        await send("Input.dispatchMouseEvent", {
          type: "mouseMoved", button: "left", buttons: 1,
          x: Math.round(x1 + (x2 - x1) * i / steps),
          y: Math.round(y1 + (y2 - y1) * i / steps) });
        await sleep(30);
      }
      await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: x2, y: y2, button: "left", clickCount: 1 });
      events.push(`dragged ${x1},${y1} -> ${x2},${y2}`);
      await sleep(1500);
    }

    const dbl = arg("doubleclick", null);
    if (dbl) {
      const [x, y] = dbl.split(",").map(Number);
      for (const count of [1, 2]) {
        await send("Input.dispatchMouseEvent", { type: "mousePressed", x, y, button: "left", clickCount: count });
        await send("Input.dispatchMouseEvent", { type: "mouseReleased", x, y, button: "left", clickCount: count });
        await sleep(60);
      }
      events.push(`double-clicked ${x},${y}`);
      await sleep(4000);
    }

    // Everything else here measures packets and attributes; this is the only check that says
    // whether any of it reached the screen.
    const shot = await send("Page.captureScreenshot", { format: "png" });
    if (shot.result && shot.result.data) {
      fs.writeFileSync("evidence/v32_boot_screenshot.png", Buffer.from(shot.result.data, "base64"));
      events.push("screenshot saved: evidence/v32_boot_screenshot.png");
    }
    const painted = await send("Runtime.evaluate", { returnByValue: true, expression: `(function () {
      var c = document.querySelector("canvas");
      if (!c) return JSON.stringify({canvas: false});
      return JSON.stringify({canvas: true, width: c.width, height: c.height,
        cssWidth: c.clientWidth, cssHeight: c.clientHeight});
    })()` });
    const paintedValue = painted.result && painted.result.result && painted.result.result.value;
    if (paintedValue) events.push("canvas " + paintedValue);

    if (profiling) {
      const stopped = await send("Profiler.stop", {});
      const profile = stopped.result && stopped.result.profile;
      if (profile) {
        // Self time per function: attribute each sample to the node it landed in.
        const byId = new Map();
        profile.nodes.forEach((n) => byId.set(n.id, n));
        const self = new Map();
        const deltas = profile.timeDeltas || [];
        (profile.samples || []).forEach((id, i) => {
          self.set(id, (self.get(id) || 0) + (deltas[i] || 0));
        });
        const rows = [...self.entries()].map(([id, us]) => {
          const f = byId.get(id) && byId.get(id).callFrame;
          const where = f ? (f.functionName || "(anonymous)") : "?";
          const url = f && f.url ? f.url.split("/").pop() + ":" + (f.lineNumber + 1) : "";
          return { fn: where, at: url, ms: Math.round(us / 1000) };
        }).filter((r) => r.ms > 0).sort((a, b) => b.ms - a.ms);
        fs.writeFileSync("evidence/v32_boot_profile.json", JSON.stringify(rows.slice(0, 60), null, 2));
        events.push("profile: top " + Math.min(60, rows.length) + " frames written to evidence/v32_boot_profile.json");
        rows.slice(0, 20).forEach((r) => events.push(`  ${String(r.ms).padStart(6)}ms  ${r.fn}  ${r.at}`));
      }
    }

    const tap = await send("Runtime.evaluate", {
      expression: "JSON.stringify(window.__wsLog || [])", returnByValue: true });
    const tapValue = tap.result && tap.result.result && tap.result.result.value;
    if (tapValue) for (const line of JSON.parse(tapValue)) events.push("tap " + line);

    ws.close();
  } finally {
    chrome.kill();
  }

  const report = { events, final: last };
  fs.writeFileSync("evidence/v32_boot_live_probe.json", JSON.stringify(report, null, 2) + "\n");
  for (const e of events) console.log(e);
  console.log("\n=== FINAL ===");
  console.log(last ? JSON.stringify(last, null, 2).slice(0, 2500) : "(no diagnostics captured)");
})().catch((e) => { console.error("PROBE FAILED: " + e.message); process.exit(1); });
