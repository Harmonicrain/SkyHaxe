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

self.onmessage = async function (event) {
  const id = event.data.id;
  const started = performance.now();
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
