// OpenFL adapter for the pinned Habbo HTML5 font engine. Raster math lives in native-core.mjs.
import { NativeText, registerNative, registerTtf, parsedTtf, ttfMetrics, scaleTtfMetrics, VolterFallback } from './native-core.mjs';

const faces = [
  ['ubuntu_regular', 'Ubuntu', '400', 'normal'], ['ubuntu_bold', 'Ubuntu', '700', 'normal'],
  ['ubuntu_italic', 'Ubuntu', '400', 'italic'], ['ubuntu_bold_italic', 'Ubuntu', '700', 'italic'],
  ['ubuntu_condensed', 'UbuntuCondensed', '400', 'normal'], ['ubuntuThick_bold', 'UbuntuThick', '700', 'normal'],
  ['ubuntuMedium', 'UbuntuMedium', '700', 'normal'], ['volter', 'Volter', '400', 'normal'],
  ['volterb', 'Volter Bold', '400', 'normal'], ['volterb', 'Volter', '700', 'normal']
];
const aliases = new Map([
  ['ubuntu', ['Ubuntu', false, false]], ['ubuntubold', ['Ubuntu', true, false]],
  ['ubuntuitalic', ['Ubuntu', false, true]], ['ubuntubolditalic', ['Ubuntu', true, true]],
  ['ubuntucondensed', ['UbuntuCondensed', false, false]], ['ubuntumedium', ['UbuntuMedium', true, false]],
  ['ubuntuthick', ['UbuntuThick', true, false]], ['volter', ['Volter', false, false]],
  ['volterbold', ['Volter Bold', false, false]]
]);
export function normalizeStyle(input = {}) {
  const name = String(input.fontFamily || 'Ubuntu').replace(/[\s'"]/g, '').toLowerCase();
  const face = aliases.get(name);
  return { fontFamily: face?.[0] || input.fontFamily || 'Ubuntu', fontSize: Number(input.fontSize ?? input.size ?? 12),
    bold: !!input.bold || !!face?.[1], italic: !!input.italic || !!face?.[2], color: input.color ?? 0,
    antiAliasType: input.antiAliasType || 'advanced', gridFitType: input.gridFitType || 'pixel',
    sharpness: Number(input.sharpness ?? 0), thickness: Number(input.thickness ?? 0),
    kerning: input.kerning !== false, letterSpacing: Number(input.letterSpacing ?? 0),
    leading: Number(input.leading ?? 0), stageQuality: input.stageQuality === 'low' ? 'low' : 'high',
    underline: false, ...(input.colorTransform ? { colorTransform: input.colorTransform } : {}) };
}
function canvas(width = 1, height = 1) {
  if (typeof OffscreenCanvas !== 'undefined') return new OffscreenCanvas(width, height);
  const c = document.createElement('canvas'); c.width = width; c.height = height; return c;
}
function css(style) { return `${style.italic ? 'italic ' : ''}${style.bold ? 'bold ' : ''}${style.fontSize}px "${style.fontFamily}"`; }
function remember(map, key, value, limit = 1000) {
  map.delete(key); map.set(key, value);
  while (map.size > limit) map.delete(map.keys().next().value);
  return value;
}
async function digest(bytes) {
  if (!globalThis.crypto?.subtle) throw new Error('Font integrity validation requires a secure context (HTTPS or localhost)');
  return [...new Uint8Array(await crypto.subtle.digest('SHA-256', bytes))].map(v => v.toString(16).padStart(2, '0')).join('');
}

export class HabboTextEngine {
  constructor() {
    this.context = canvas().getContext('2d'); this.volter = new VolterFallback();
    this.widthCache = new Map(); this.positionCache = new Map(); this.fallbackRuns = 0; this.nativeRuns = 0;
  }
  static async load(base) {
    const root = new URL(base.replace(/\/?$/, '/') , typeof document !== 'undefined' ? document.baseURI : undefined);
    const response = await fetch(new URL('manifest.json', root));
    if (!response.ok) throw new Error(`Font manifest HTTP ${response.status}`);
    const manifest = await response.json();
    if (manifest.schema !== 1 || manifest.renderer !== 'habbo-html5-air51'
      || manifest.launcherSha256 !== '0827769ec42c99aa6206e6746007a5cbd159d99ea40f059f22a7377e69a65b3b') throw new Error('Unsupported Habbo font manifest');
    async function resource(file) {
      const record = manifest.files.find(f => f.file === file);
      if (!record || !/^(fonts|profiles)\/[\w.-]+$/.test(file)) throw new Error(`Unlisted font resource: ${file}`);
      const result = await fetch(new URL(file, root), { cache: 'no-cache' });
      if (!result.ok) throw new Error(`${file}: HTTP ${result.status}`);
      const bytes = await result.arrayBuffer();
      if (bytes.byteLength !== record.bytes || await digest(bytes) !== record.sha256) throw new Error(`Font integrity failed: ${file}`);
      return bytes;
    }
    const loaded = new Map(await Promise.all(manifest.fonts.map(async f => {
      const [ttf, profile] = await Promise.all([resource(f.file), f.profile ? resource(f.profile) : null]);
      return [f.asset, {ttf, profile: profile ? JSON.parse(new TextDecoder().decode(profile)) : null}];
    })));
    // Validate every resource before publishing any face. FontFace.load is joined into startup.
    await Promise.all(faces.map(async ([asset, family, weight, style]) => {
      const f = loaded.get(asset); if (!f) throw new Error(`Missing required font ${asset}`);
      registerTtf(family, weight, style, f.ttf);
      if (f.profile) registerNative(family, weight, style, f.profile);
      const face = new FontFace(family, f.ttf, { weight, style });
      await face.load(); document.fonts.add(face);
    }));
    const engine = new HabboTextEngine(); engine.manifest = manifest;
    return engine;
  }
  strategy(text, style) { return NativeText.supports(style, text) ? 'native' : /^volter/i.test(style.fontFamily) ? 'volter' : 'canvas'; }
  width(text, input) {
    if (!text) return 0;
    const style = normalizeStyle(input), key = JSON.stringify([NativeText.revision, style, text]);
    if (this.widthCache.has(key)) return this.widthCache.get(key);
    const native = NativeText.measure(text, style);
    const width = native == null ? this.fallbackWidth(text, style) : native;
    return remember(this.widthCache, key, width);
  }
  fallbackWidth(text, style) {
    let width = this.volter._r96ee8f119769f8(text, style);
    if (width == null) {
      this.context.font = css(style);
      const spacing = text.length > 1 ? style.letterSpacing * (text.length - 1) : 0;
      width = Math.max(0, Math.ceil(this.context.measureText(text).width + spacing));
    }
    return width;
  }
  positions(text, input) {
    const style = normalizeStyle(input), key = JSON.stringify([NativeText.revision, style, text]);
    if (this.positionCache.has(key)) return this.positionCache.get(key);
    let positions = NativeText._r81e37669947234(text, style);
    if (!positions) {
      // The reference fallback uses prefix measurements, keeping UTF-16 caret indices.
      positions = [0];
      for (let i = 1; i <= text.length; i++) positions.push(this.fallbackWidth(text.slice(0, i), style));
      for (let i = 1; i < text.length; i++) {
        const a = text.charCodeAt(i - 1), b = text.charCodeAt(i);
        if (a >= 0xd800 && a <= 0xdbff && b >= 0xdc00 && b <= 0xdfff) positions[i] = positions[i - 1];
      }
    }
    return remember(this.positionCache, key, positions);
  }
  advances(text, input) {
    // Line separators have no advance. Measure each complete line before OpenFL slices words.
    const result = [];
    for (const part of text.split(/([\r\n])/)) {
      if (part === '\r' || part === '\n') { result.push(0); continue; }
      const positions = this.positions(part, input);
      for (let i = 0; i < part.length; i++) result.push(positions[i + 1] - positions[i]);
    }
    return result;
  }
  metrics(input) {
    const style = normalizeStyle(input), native = NativeText.metrics(style);
    if (native) return native;
    const ttf = ttfMetrics(style.fontFamily, style.bold ? '700' : '400', style.italic ? 'italic' : 'normal');
    if (ttf) return scaleTtfMetrics(ttf, style.fontSize, style.leading);
    this.context.font = css(style);
    const m = this.context.measureText('Mg'), ascent = m.fontBoundingBoxAscent || m.actualBoundingBoxAscent || style.fontSize;
    const descent = m.fontBoundingBoxDescent || m.actualBoundingBoxDescent || 0;
    return { ascent, descent, lineGap: 0, baseline: ascent, lineHeight: ascent + descent + style.leading };
  }
  hasGlyphs(input, text) {
    const style = normalizeStyle(input);
    const ttf = parsedTtf(style.fontFamily, style.bold ? '700' : '400', style.italic ? 'italic' : 'normal');
    if (!ttf) return true; // Device fonts retain the original permissive coverage behavior.
    for (const character of text) if (character !== '\r' && character !== '\n' && character !== '\t'
      && ttf.charToGlyphIndex(character) === 0) return false;
    return true;
  }
  draw(context, text, x, baseline, input) {
    if (!text) return;
    const style = normalizeStyle(input), metrics = this.metrics(style);
    // OpenFL positions baselines from ascent. Habbo has a separately rounded native baseline.
    const y = baseline - metrics.ascent + metrics.baseline;
    context.save();
    try {
      if (NativeText.draw(context, text, x, y, style)) { this.nativeRuns++; return; }
      this.fallbackRuns++; context.font = css(style); context.textBaseline = 'alphabetic';
      context.fillStyle = '#' + (style.color & 0xffffff).toString(16).padStart(6, '0');
      const plain = () => {
        if (style.letterSpacing === 0) context.fillText(text, x, Math.round(y));
        else {
          const positions = this.positions(text, style); let index = 0;
          for (const character of text) { context.fillText(character, x + positions[index], Math.round(y)); index += character.length; }
        }
      };
      if (!this.volter._r9832c7c612cd08(context, text, x, y, metrics, style, plain)) plain();
    } finally { context.restore(); }
  }
  drawRetained(context, runs, clip) {
    if (!runs.every(r => NativeText.supports(normalizeStyle(r.style), r.text))) return false;
    const left = Math.max(0, Math.ceil(clip.x)), top = Math.max(0, Math.ceil(clip.y));
    const right = Math.min(context.canvas.width, Math.floor(clip.right)), bottom = Math.min(context.canvas.height, Math.floor(clip.bottom));
    if (right <= left || bottom <= top) return true;
    if ((right - left) * (bottom - top) > 2 * 1024 * 1024) return false;
    const image = context.getImageData(left, top, right - left, bottom - top);
    NativeText.premultiply(image.data);
    for (const run of runs) {
      const style = normalizeStyle(run.style), metrics = this.metrics(style);
      NativeText._ree8b220e73c49e(run.text, style, { pixels: image.data, width: image.width, height: image.height,
        offsetX: Math.round(run.x) - 2 - left, offsetY: Math.round(run.baseline - metrics.ascent + metrics.baseline) - (metrics.baseline + 2) - top });
    }
    NativeText._rba605347eb19cf(image.data);
    context.putImageData(image, left, top);
    return true;
  }
  clearCaches() { this.widthCache.clear(); this.positionCache.clear(); }
  stats() { return { nativeRuns: this.nativeRuns, fallbackRuns: this.fallbackRuns,
    widthEntries: this.widthCache.size, positionEntries: this.positionCache.size }; }
}

export const load = base => HabboTextEngine.load(base);
