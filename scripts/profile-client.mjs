#!/usr/bin/env node
import { spawn } from "node:child_process";
import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, resolve } from "node:path";

function argumentsOf(argv) {
  const result = {};
  for (let index = 0; index < argv.length; index += 2) {
    const key = argv[index]?.replace(/^--/, "");
    if (!key || argv[index + 1] == null) throw new Error(`Missing value for ${argv[index]}`);
    result[key] = argv[index + 1];
  }
  return result;
}

function safeName(value) {
  return value.replace(/[^a-z0-9_.-]+/gi, "-").replace(/^-|-$/g, "") || "profile";
}

function findBrowser(explicit) {
  const candidates = [
    explicit,
    "C:/Program Files/Google/Chrome/Application/chrome.exe",
    "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe",
    "C:/Program Files/Microsoft/Edge/Application/msedge.exe"
  ].filter(Boolean);
  return candidates[0];
}

async function waitForJson(url, timeoutMs) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    try {
      const response = await fetch(url);
      if (response.ok) return await response.json();
    } catch {}
    await new Promise(resolve => setTimeout(resolve, 250));
  }
  throw new Error(`Timed out waiting for ${url}`);
}

class Cdp {
  constructor(url) {
    this.nextId = 1;
    this.pending = new Map();
    this.listeners = new Map();
    this.socket = new WebSocket(url);
    this.socket.onmessage = event => {
      const message = JSON.parse(event.data);
      if (!message.id) {
        const listeners = this.listeners.get(message.method) || [];
        for (const listener of listeners) listener(message.params || {});
        return;
      }
      const pending = this.pending.get(message.id);
      if (!pending) return;
      this.pending.delete(message.id);
      message.error ? pending.reject(new Error(message.error.message)) : pending.resolve(message.result);
    };
  }
  once(method) {
    return new Promise(resolve => {
      const listeners = this.listeners.get(method) || [];
      const listener = value => {
        this.listeners.set(method, listeners.filter(item => item !== listener));
        resolve(value);
      };
      listeners.push(listener);
      this.listeners.set(method, listeners);
    });
  }
  on(method, listener) {
    const listeners = this.listeners.get(method) || [];
    listeners.push(listener);
    this.listeners.set(method, listeners);
  }
  async open() {
    if (this.socket.readyState === WebSocket.OPEN) return;
    await new Promise((resolve, reject) => {
      this.socket.onopen = resolve;
      this.socket.onerror = reject;
    });
  }
  call(method, params = {}) {
    const id = this.nextId++;
    return new Promise((resolve, reject) => {
      this.pending.set(id, { resolve, reject });
      this.socket.send(JSON.stringify({ id, method, params }));
    });
  }
  close() { this.socket.close(); }
}

async function evaluate(cdp, expression) {
  const result = await cdp.call("Runtime.evaluate", { expression, returnByValue: true, awaitPromise: true });
  if (result.exceptionDetails) throw new Error(result.exceptionDetails.text || "Browser evaluation failed");
  return result.result.value;
}

async function readStream(cdp, handle) {
  let value = "";
  while (true) {
    const chunk = await cdp.call("IO.read", { handle });
    value += chunk.base64Encoded ? Buffer.from(chunk.data, "base64").toString("utf8") : chunk.data;
    if (chunk.eof) break;
  }
  await cdp.call("IO.close", { handle });
  return value;
}

const args = argumentsOf(process.argv.slice(2));
const baseUrl = args.url || "http://localhost:8766/";
const scenario = args.scenario || "large-room-walk";
const durationMs = Number(args.duration || 15000);
const warmupMs = Number(args.warmup || 5000);
const repetitions = Number(args.repetitions || 1);
const outputDirectory = resolve(args.output || "evidence/profiles");
const browser = findBrowser(args.browser);
const ticket = args.sso;
if (!ticket) throw new Error("Pass --sso for the authorised local test account");
await mkdir(outputDirectory, { recursive: true });

for (let repetition = 1; repetition <= repetitions; repetition++) {
  const port = 9400 + Math.floor(Math.random() * 400);
  const profile = await mkdtemp(resolve(tmpdir(), "skyhaxe-profile-"));
  const child = spawn(browser, [
    `--remote-debugging-port=${port}`,
    `--user-data-dir=${profile}`,
    "--no-first-run",
    "--no-default-browser-check",
    "--disable-background-timer-throttling",
    "--window-size=1280,960",
    "about:blank"
  ], { stdio: "ignore" });
  try {
    const targets = await waitForJson(`http://127.0.0.1:${port}/json/list`, 15000);
    const page = targets.find(target => target.type === "page");
    if (!page) throw new Error("Browser did not expose a page target");
    const cdp = new Cdp(page.webSocketDebuggerUrl);
    await cdp.open();
    await cdp.call("Page.enable");
    await cdp.call("Runtime.enable");
    await cdp.call("Log.enable");
    await cdp.call("Network.enable");
    const diagnostics = { console: [], exceptions: [], log: [], webSockets: [] };
    const safeText = value => String(value ?? "")
      .replace(/([#?&]sso=)[^&#\s]+/gi, "$1<redacted>")
      .slice(0, 1000);
    cdp.on("Runtime.consoleAPICalled", event => {
      if ((event.type === "warning" || event.type === "error") && diagnostics.console.length < 100)
        diagnostics.console.push({
          type: event.type,
          text: safeText((event.args || []).map(item => item.value ?? item.description ?? "").join(" "))
        });
    });
    cdp.on("Runtime.exceptionThrown", event => {
      if (diagnostics.exceptions.length < 100) diagnostics.exceptions.push({
        text: safeText(event.exceptionDetails?.exception?.description || event.exceptionDetails?.text)
      });
    });
    cdp.on("Log.entryAdded", event => {
      if ((event.entry?.level === "warning" || event.entry?.level === "error") && diagnostics.log.length < 100)
        diagnostics.log.push({level: event.entry?.level, text: safeText(event.entry?.text)});
    });
    cdp.on("Network.webSocketCreated", event => diagnostics.webSockets.push({
      event: "created", url: safeText(event.url)
    }));
    cdp.on("Network.webSocketWillSendHandshakeRequest", event => diagnostics.webSockets.push({
      event: "handshake-request", url: safeText(event.request?.url)
    }));
    cdp.on("Network.webSocketHandshakeResponseReceived", event => diagnostics.webSockets.push({
      event: "handshake-response", status: event.response?.status,
      statusText: safeText(event.response?.statusText), url: safeText(event.response?.url)
    }));
    cdp.on("Network.webSocketClosed", event => diagnostics.webSockets.push({
      event: "closed", timestamp: event.timestamp
    }));
    const url = new URL(baseUrl);
    url.searchParams.set("profile", "1");
    url.searchParams.set("profileScenario", scenario);
    url.searchParams.set("profileDurationMs", String(durationMs));
    url.searchParams.set("profileWarmupMs", String(warmupMs));
    url.searchParams.set("profileManaged", "1");
    url.hash = `sso=${encodeURIComponent(ticket)}`;
    await cdp.call("Page.navigate", { url: url.toString() });

    const deadline = Date.now() + warmupMs + durationMs + Number(args.timeout || 180000);
    let prepared = false;
    let acted = false;
    let traceStarted = false;
    let zoomTransitionMs = null;
    let result = null;
    async function canvasRect() {
      return await evaluate(cdp, "(function(){var c=document.querySelector('canvas');if(!c)return null;var r=c.getBoundingClientRect();return {left:r.left,top:r.top,width:r.width,height:r.height};})()");
    }
    async function click(x, y) {
      await cdp.call("Input.dispatchMouseEvent", { type: "mousePressed", x, y, button: "left", clickCount: 1 });
      await cdp.call("Input.dispatchMouseEvent", { type: "mouseReleased", x, y, button: "left", clickCount: 1 });
    }
    async function applyZoom(zoom, rect) {
      let measured = Number.NaN;
      for (let attempt = 0; attempt < 3; attempt++) {
        await click(rect.left + rect.width * 0.48, rect.top + rect.height - 78);
        await cdp.call("Input.insertText", { text: `:zoom ${zoom}` });
        await cdp.call("Input.dispatchKeyEvent", { type: "keyDown", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
        await cdp.call("Input.dispatchKeyEvent", { type: "keyUp", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
        const zoomDeadline = Date.now() + 3500;
        while (Date.now() < zoomDeadline) {
          measured = Number(await evaluate(cdp, "window.__skyhaxeProfileGauge && (window.__skyhaxeProfileGauge('mainRoomScale') ?? window.__skyhaxeProfileGauge('roomScale'))"));
          if (Math.abs(measured - zoom) <= 0.01) return measured;
          await new Promise(resolve => setTimeout(resolve, 100));
        }
      }
      return measured;
    }
    async function waitForStableMainRoom() {
      const roomDeadline = Date.now() + 30000;
      let stableSamples = 0;
      let previousObjects = null;
      while (Date.now() < roomDeadline) {
        const room = await evaluate(cdp, "(function(){var g=window.__skyhaxeProfileGauge;if(!g)return null;return {objects:Number(g('mainRoomObjects')),scale:Number(g('mainRoomScale'))};})()");
        const stable = room && Number.isFinite(room.objects) && room.objects >= 1000
          && Number.isFinite(room.scale) && room.objects === previousObjects;
        stableSamples = stable ? stableSamples + 1 : 0;
        previousObjects = room?.objects;
        if (stableSamples >= 5) return room;
        await new Promise(resolve => setTimeout(resolve, 200));
      }
      throw new Error("Large main-room canvas did not become stable before benchmark setup");
    }
    while (Date.now() < deadline) {
      const state = await evaluate(cdp, "window.__skyhaxeProfileState || 'booting'");
      if (state === "setup" && !prepared) {
        prepared = true;
        if (args.trace === "1") {
          await cdp.call("Tracing.start", {
            categories: "devtools.timeline,v8,blink,cc,gpu,disabled-by-default-devtools.timeline.frame,disabled-by-default-v8.cpu_profiler,disabled-by-default-v8.cpu_profiler.hires",
            options: "sampling-frequency=10000",
            transferMode: "ReturnAsStream"
          });
          traceStarted = true;
        }
        // The test account may receive a canvas-rendered moderation dialog after login. Its
        // centred acknowledgement button otherwise consumes every walking click.
        const setupRect = await canvasRect();
        if (!setupRect) throw new Error("Client canvas is unavailable");
        await click(setupRect.left + setupRect.width * .5, setupRect.top + setupRect.height * .55);
        await new Promise(resolve => setTimeout(resolve, 500));
        await waitForStableMainRoom();
        const zoom = Number(args.zoom || 0);
        if (zoom) {
          const rect = await canvasRect();
          if (!rect) throw new Error("Client canvas is unavailable");
          const transitionStarted = performance.now();
          let measured = await applyZoom(zoom, rect);
          if (Math.abs(measured - zoom) > 0.01)
            throw new Error(`Requested zoom ${zoom}, but setup remained at ${measured}; run invalidated`);
          // Room entry can recreate/reset its canvas shortly after the ready signal. Keep that
          // reset outside both warm-up and recording, then establish the requested steady state.
          await new Promise(resolve => setTimeout(resolve, 2500));
          measured = Number(await evaluate(cdp, "window.__skyhaxeProfileGauge && (window.__skyhaxeProfileGauge('mainRoomScale') ?? window.__skyhaxeProfileGauge('roomScale'))"));
          if (Math.abs(measured - zoom) > 0.01) measured = await applyZoom(zoom, rect);
          if (Math.abs(measured - zoom) > 0.01)
            throw new Error(`Requested zoom ${zoom}, but room setup reset it to ${measured}; run invalidated`);
          zoomTransitionMs = performance.now() - transitionStarted;
        }
        await evaluate(cdp, "window.__skyhaxeProfilePrepareDone()");
      }
      if (state === "recording" && !acted) {
        acted = true;
        const walk = args.walk !== "0";
        const rect = await canvasRect();
        if (!rect) throw new Error("Client canvas is unavailable");
        if (walk) {
          const avatarX = Number(await evaluate(cdp, "window.__skyhaxeProfileGauge && window.__skyhaxeProfileGauge('ownAvatarScreenX')"));
          const avatarY = Number(await evaluate(cdp, "window.__skyhaxeProfileGauge && window.__skyhaxeProfileGauge('ownAvatarScreenY')"));
          const points = Number(args.zoom || 0) === 0.5
            ? [[rect.width * .62, rect.height * .38], [rect.width * .50, rect.height * .45],
               [rect.width * .40, rect.height * .60], [rect.width * .30, rect.height * .69],
               [rect.width * .60, rect.height * .58], [rect.width * .78, rect.height * .76]]
            : Number(args.zoom || 0) === 1
            ? [[rect.width * .70, rect.height * .25], [rect.width * .60, rect.height * .35],
               [rect.width * .30, rect.height * .65], [rect.width * .45, rect.height * .70]]
            : Number.isFinite(avatarX) && Number.isFinite(avatarY)
            ? [[avatarX - 80, avatarY + 35], [avatarX - 40, avatarY + 5], [avatarX + 40, avatarY + 5], [avatarX + 80, avatarY + 35]]
            : [[rect.width * .32, rect.height * .60], [rect.width * .42, rect.height * .58]];
          for (const [x, y] of points) {
            await click(rect.left + x, rect.top + y);
            await new Promise(resolve => setTimeout(resolve, 1500));
          }
        }
      }
      if (state === "complete") {
        result = await evaluate(cdp, "window.__skyhaxeProfileResult");
        break;
      }
      const firstError = await evaluate(cdp, "window.__skyhaxeFirstError || null");
      if (firstError) throw new Error(`Client failed: ${firstError}`);
      await new Promise(resolve => setTimeout(resolve, 500));
    }
    if (!result) {
      const stamp = new Date().toISOString().replace(/[:.]/g, "-");
      const diagnosticPath = resolve(outputDirectory, `${stamp}-${safeName(scenario)}-failed.json`);
      const state = await evaluate(cdp, "window.__skyhaxeProfileState || 'booting'");
      await writeFile(diagnosticPath, JSON.stringify({scenario, state, diagnostics}, null, 2) + "\n", "utf8");
      throw new Error(`Profile did not complete (state ${state}); diagnostics: ${diagnosticPath}`);
    }
    const requestedZoom = Number(args.zoom || 0);
    if (args.walk !== "0" && Number(result.counters?.ownAvatarLocationChanges || 0) === 0)
      throw new Error("Walking was requested, but no own-avatar location change was measured; run invalidated");
    const mainRoomFrames = Number(result.counters?.["mainRoomFrames.total"] || 0);
    const halfScaleFrames = Number(result.counters?.["mainRoomFrames.scaleHalf"] || 0);
    const otherScaleFrames = Number(result.counters?.["mainRoomFrames.scaleOther"] || 0);
    if (requestedZoom === 0.5 && (mainRoomFrames === 0 || halfScaleFrames !== mainRoomFrames || otherScaleFrames !== 0))
      throw new Error(`Half-scale run invalidated: ${halfScaleFrames}/${mainRoomFrames} large-room renders were at 0.5 scale (${otherScaleFrames} at another scale)`);
    // `gauges.roomScale` is the last RoomSpriteCanvas rendered. Opening an infostand while
    // walking can make that a scale-1 preview canvas even though the measured main room remains
    // at the zoom that was explicitly confirmed above.
    result.runner = { repetition, requestedScenario: scenario, requestedZoomScale: requestedZoom,
      confirmedZoomScale: requestedZoom, lastRenderedCanvasScale: result.gauges?.roomScale,
      zoomTransitionMs, walkingClicks: args.walk !== "0", diagnostics };
    const stamp = new Date().toISOString().replace(/[:.]/g, "-");
    const destination = resolve(outputDirectory, `${stamp}-${safeName(scenario)}-r${repetition}.json`);
    await writeFile(destination, JSON.stringify(result, null, 2) + "\n", "utf8");
    const screenshot = await cdp.call("Page.captureScreenshot", { format: "png", captureBeyondViewport: false });
    await writeFile(destination.replace(/\.json$/, ".png"), Buffer.from(screenshot.data, "base64"));
    if (traceStarted) {
      const complete = cdp.once("Tracing.tracingComplete");
      await cdp.call("Tracing.end");
      const event = await complete;
      await writeFile(destination.replace(/\.json$/, ".trace.json"), await readStream(cdp, event.stream), "utf8");
    }
    console.log(destination);
    await cdp.call("Browser.close");
    cdp.close();
  } finally {
    child.kill();
    await new Promise(resolve => {
      if (child.exitCode != null) return resolve();
      child.once("exit", resolve);
      setTimeout(resolve, 3000);
    });
    for (let attempt = 0; attempt < 5; attempt++) {
      try { await rm(profile, { recursive: true, force: true }); break; }
      catch (error) {
        if (attempt === 4) console.warn(`Could not remove temporary browser profile: ${error.message}`);
        else await new Promise(resolve => setTimeout(resolve, 500));
      }
    }
  }
}
