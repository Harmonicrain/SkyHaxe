/* Lossless SWF bitmap decoder. Kept standalone so browsers can run it off the UI thread. */
"use strict";

function u16(bytes, offset) {
  return bytes[offset] | (bytes[offset + 1] << 8);
}

function unpremultiply(channel, alpha) {
  if (alpha === 0) return 0;
  return Math.min(255, Math.floor((channel * 255 + (alpha >> 1)) / alpha));
}

async function inflate(bytes) {
  const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream("deflate"));
  return new Uint8Array(await new Response(stream).arrayBuffer());
}

/* .hab atlas: PNG -> straight RGBA, exactly (a canvas would premultiply and round alpha edges). */
function be32(b, o) { return ((b[o] << 24) | (b[o + 1] << 16) | (b[o + 2] << 8) | b[o + 3]) >>> 0; }

async function decodePng(png) {
  let pos = 8, width = 0, height = 0, type = -1, palette = null, trns = null;
  const parts = [];
  while (pos + 8 <= png.length) {
    const length = be32(png, pos);
    const kind = String.fromCharCode(png[pos + 4], png[pos + 5], png[pos + 6], png[pos + 7]);
    const body = png.subarray(pos + 8, pos + 8 + length);
    if (kind === "IHDR") {
      width = be32(body, 0); height = be32(body, 4); type = body[9];
      if (body[8] !== 8 || body[12] !== 0) throw new Error("unsupported PNG depth/interlace");
    } else if (kind === "PLTE") palette = body;
    else if (kind === "tRNS") trns = body;
    else if (kind === "IDAT") parts.push(body);
    else if (kind === "IEND") break;
    pos += 12 + length;
  }
  const bpp = type === 6 ? 4 : type === 2 ? 3 : type === 3 ? 1 : 0;
  if (!bpp) throw new Error("unsupported PNG colour type " + type);
  const raw = await inflate(new Uint8Array(await new Blob(parts).arrayBuffer()));
  const stride = width * bpp, cur = new Uint8Array(stride * height);
  let ip = 0;
  for (let y = 0; y < height; y++) {
    const filter = raw[ip++], row = y * stride, prev = row - stride;
    for (let x = 0; x < stride; x++) {
      const v = raw[ip++], a = x >= bpp ? cur[row + x - bpp] : 0, b = y ? cur[prev + x] : 0;
      let value;
      if (filter === 0) value = v;
      else if (filter === 1) value = v + a;
      else if (filter === 2) value = v + b;
      else if (filter === 3) value = v + ((a + b) >> 1);
      else {
        const c = x >= bpp && y ? cur[prev + x - bpp] : 0, p = a + b - c;
        const pa = Math.abs(p - a), pb = Math.abs(p - b), pc = Math.abs(p - c);
        value = v + (pa <= pb && pa <= pc ? a : pb <= pc ? b : c);
      }
      cur[row + x] = value;
    }
  }
  if (type === 6) return { width, height, rgba: cur };
  const rgba = new Uint8Array(width * height * 4);
  for (let i = 0, o = 0; i < width * height; i++, o += 4) {
    if (type === 2) { rgba[o] = cur[i * 3]; rgba[o + 1] = cur[i * 3 + 1]; rgba[o + 2] = cur[i * 3 + 2]; rgba[o + 3] = 255; }
    else {
      const k = cur[i];
      rgba[o] = palette[k * 3]; rgba[o + 1] = palette[k * 3 + 1]; rgba[o + 2] = palette[k * 3 + 2];
      rgba[o + 3] = trns && k < trns.length ? trns[k] : 255;
    }
  }
  return { width, height, rgba };
}

self.onmessage = async function (event) {
  const id = event.data.id;
  const started = performance.now();
  if (event.data.kind === "png") {
    try {
      const { width, height, rgba } = await decodePng(new Uint8Array(event.data.payload));
      self.postMessage({ id, width, height, rgba: rgba.buffer, decodeMs: performance.now() - started }, [rgba.buffer]);
    } catch (error) {
      self.postMessage({ id, error: String(error && error.message || error) });
    }
    return;
  }
  try {
    const payload = new Uint8Array(event.data.payload);
    const format = payload[2];
    const width = u16(payload, 3);
    const height = u16(payload, 5);
    const hasAlpha = event.data.tag === 36;
    let cursor = 7;
    let tableSize = 0;
    if (format === 3) tableSize = payload[cursor++] + 1;
    const data = await inflate(payload.subarray(cursor));
    const rgba = new Uint8Array(width * height * 4);
    let out = 0;

    if (format === 3) {
      const entry = hasAlpha ? 4 : 3;
      const tableBytes = tableSize * entry;
      const stride = (width + 3) & ~3;
      for (let y = 0; y < height; y++) {
        const row = tableBytes + y * stride;
        for (let x = 0; x < width; x++) {
          const base = tableBytes + data[row + x] * entry;
          if (hasAlpha) {
            const alpha = data[base + 3];
            rgba[out++] = unpremultiply(data[base], alpha);
            rgba[out++] = unpremultiply(data[base + 1], alpha);
            rgba[out++] = unpremultiply(data[base + 2], alpha);
            rgba[out++] = alpha;
          } else {
            rgba[out++] = data[base]; rgba[out++] = data[base + 1];
            rgba[out++] = data[base + 2]; rgba[out++] = 255;
          }
        }
      }
    } else if (format === 4) {
      const stride = (width * 2 + 3) & ~3;
      const widen5 = value => (value << 3) | (value >> 2);
      for (let y = 0; y < height; y++) {
        const row = y * stride;
        for (let x = 0; x < width; x++) {
          const value = (data[row + x * 2] << 8) | data[row + x * 2 + 1];
          rgba[out++] = widen5((value >> 10) & 31);
          rgba[out++] = widen5((value >> 5) & 31);
          rgba[out++] = widen5(value & 31); rgba[out++] = 255;
        }
      }
    } else if (format === 5) {
      for (let index = 0; index < width * height; index++) {
        const base = index * 4;
        if (hasAlpha) {
          const alpha = data[base];
          rgba[out++] = unpremultiply(data[base + 1], alpha);
          rgba[out++] = unpremultiply(data[base + 2], alpha);
          rgba[out++] = unpremultiply(data[base + 3], alpha);
          rgba[out++] = alpha;
        } else {
          rgba[out++] = data[base + 1]; rgba[out++] = data[base + 2];
          rgba[out++] = data[base + 3]; rgba[out++] = 255;
        }
      }
    } else {
      throw new Error("unsupported lossless bitmap format " + format);
    }
    self.postMessage({ id, width, height, rgba: rgba.buffer, decodeMs: performance.now() - started }, [rgba.buffer]);
  } catch (error) {
    self.postMessage({ id, error: String(error && error.message || error) });
  }
};
