#!/usr/bin/env python3
"""G2 — reference decode of the SWF reader canary set.

The Haxe reader must return pixels, binary blobs and MP3 frames from real Habbo SWFs with no
conversion pipeline (decision D1). This produces the reference those outputs are compared against.

It is deliberately a *second, independent implementation*: Python + zlib + PIL, against Haxe +
OpenFL + the browser's own JPEG decoder. Two implementations agreeing byte-for-byte catches the
failures that actually happen here — row padding, premultiplied alpha, colormap sizing, the
erroneous JPEG header, LZMA framing. It does not catch both sides misreading the same spec
sentence, which is why G2's Flash-reference comparison is tracked separately in CHECKLIST.md.

The contract is deliberately explicit so both sides can only agree on purpose:

    pixels  = straight (un-premultiplied) RGBA8888, row-major, 4 bytes per pixel
    hash    = sha256 of those bytes
    binary  = sha256 of the DefineBinaryData payload
    sound   = sha256 of the MP3 frame bytes, after the 2-byte seek-sample prefix

Canary selection is fixed and reasoned, not "the first N files": every container, every bitmap tag
the corpus actually contains, plus the checksumless-CWS case P1c found in live content.

Usage:
    python g2_reader_contract.py [--json out.json] [--max-symbols-per-file N]

Read-only with respect to `c:/habbo/ngh`.
"""
from __future__ import annotations

import argparse
import base64
import collections
import hashlib
import io
import json
import lzma
import struct
import zlib
from pathlib import Path

import numpy as np
from PIL import Image

NGH = Path(r"C:\habbo\ngh")
GORDON = "gordon/PRODUCTION-201611291003-338511768"

# Every entry states what it is here to prove. A canary set without reasons rots into a list.
CANARIES = [
    ("dcr/hof_furni/15pillow.swf", "CWS container; DefineBitsLossless2 + DefineBinaryData, the corpus baseline"),
    ("dcr/hof_furni/01_dragonlamp_skream.swf", "FWS container, uncompressed body"),
    ("dcr/hof_furni/ads_tvoh_crate1.swf", "ZWS container; non-standard SWF LZMA framing"),
    ("dcr/hof_furni/vip_sof5.swf", "the corpus's only DefineBitsLossless (tag 20) file"),
    ("dcr/hof_furni/BW_HeadmasterChair.swf", "DefineBitsJPEG3, JPEG colour plus zlib alpha channel"),
    ("dcr/hof_furni/godin.swf", "one SWF mixing JPEG3/JPEG and JPEG3/PNG; codec chosen per character"),
    (GORDON + "/hh_game_bb_room.swf", "DefineBitsJPEG2 at volume (311 exports), mandatory per P1c"),
    (GORDON + "/hh_game_bb.swf", "DefineSound(MP3), 14 reachable exports the game code plays"),
    (GORDON + "/hh_game_snowwar.swf", "DefineSound(MP3), the other 10 reachable game exports"),
    (GORDON + "/elephants.swf", "checksumless CWS: complete body, no Adler-32 trailer"),
]

BITMAP_TAGS = {20: "DefineBitsLossless", 21: "DefineBitsJPEG2",
               35: "DefineBitsJPEG3", 36: "DefineBitsLossless2"}
BINARY_TAG = 87
SOUND_TAG = 14
SYMBOL_CLASS = 76


# --------------------------------------------------------------------------- containers

def decompress(raw: bytes) -> tuple[str, bytes]:
    """Return (signature, SWF body after the 8-byte header)."""
    sig = raw[:3].decode("ascii", "replace")
    declared = struct.unpack_from("<I", raw, 4)[0] - 8
    if sig == "FWS":
        return sig, raw[8:]
    if sig == "CWS":
        try:
            return sig, zlib.decompress(raw[8:])
        except zlib.error:
            # P1c: six live Gordon files carry the whole declared body but omit the Adler-32
            # trailer. Accept only after the length matches the header exactly.
            stream = zlib.decompressobj()
            body = stream.decompress(raw[8:])
            if len(body) != declared:
                raise
            return sig + "-no-adler", body
    if sig == "ZWS":
        # 'ZWS' ver(1) fileLength(4) compressedLength(4) props(5) data. liblzma rejects the
        # declared size, so decode with the unknown-size sentinel and verify afterwards.
        body = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE).decompress(
            raw[12:17] + (b"\xff" * 8) + raw[17:])
        if len(body) != declared:
            raise ValueError("lzma length {} != declared {}".format(len(body), declared))
        return sig, body
    raise ValueError("unknown container " + sig)


def tags(body: bytes):
    """Yield (code, payload) for each tag, skipping the frame rect / rate / count header."""
    offset = ((5 + (body[0] >> 3) * 4) + 7) // 8 + 4
    while offset < len(body) - 1:
        record = struct.unpack_from("<H", body, offset)[0]
        offset += 2
        code, length = record >> 6, record & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", body, offset)[0]
            offset += 4
        yield code, body[offset:offset + length]
        offset += length
        if code == 0:
            break


# --------------------------------------------------------------------------- bitmaps

def unpremultiply(argb: np.ndarray) -> np.ndarray:
    """DefineBitsLossless2 stores premultiplied alpha; BitmapData exposes straight alpha."""
    alpha = argb[..., 0].astype(np.uint16)
    out = np.empty(argb.shape[:2] + (4,), dtype=np.uint8)
    out[..., 3] = argb[..., 0]
    for channel in range(3):
        value = argb[..., channel + 1].astype(np.uint16) * 255
        with np.errstate(divide="ignore", invalid="ignore"):
            scaled = np.where(alpha > 0, (value + alpha // 2) // np.maximum(alpha, 1), 0)
        out[..., channel] = np.minimum(scaled, 255).astype(np.uint8)
    return out


def rows_padded(data: bytes, width: int, height: int, stride_bytes: int) -> bytes:
    """SWF pads each scanline to a 32-bit boundary; strip the padding."""
    padded = (stride_bytes + 3) & ~3
    if padded == stride_bytes:
        return data[:stride_bytes * height]
    return b"".join(data[y * padded:y * padded + stride_bytes] for y in range(height))


def decode_lossless(payload: bytes, tag: int) -> tuple[int, int, int, bytes]:
    character_id, fmt, width, height = struct.unpack_from("<HBHH", payload, 0)
    cursor = 7
    table_size = 0
    if fmt == 3:
        table_size = payload[cursor] + 1
        cursor += 1
    data = zlib.decompress(payload[cursor:])
    has_alpha = tag == 36

    if fmt == 3:
        entry = 4 if has_alpha else 3
        table = np.frombuffer(data[:table_size * entry], dtype=np.uint8).reshape(table_size, entry)
        indices = np.frombuffer(rows_padded(data[table_size * entry:], width, height, width),
                                dtype=np.uint8).reshape(height, width)
        picked = table[indices]
        rgba = np.empty((height, width, 4), dtype=np.uint8)
        if has_alpha:
            # Colormapped Lossless2 entries are premultiplied RGBA, not ARGB.
            rgba[...] = unpremultiply(picked[..., [3, 0, 1, 2]])
        else:
            rgba[..., :3] = picked
            rgba[..., 3] = 255
    elif fmt == 4:
        raw = np.frombuffer(rows_padded(data, width, height, width * 2), dtype=">u2")
        raw = raw.reshape(height, width)
        rgba = np.empty((height, width, 4), dtype=np.uint8)
        # PIX15: 0RRRRRGG GGGBBBBB, scaled 5 -> 8 bits the way Flash does.
        for shift, channel in ((10, 0), (5, 1), (0, 2)):
            five = ((raw >> shift) & 0x1F).astype(np.uint8)
            rgba[..., channel] = (five << 3) | (five >> 2)
        rgba[..., 3] = 255
    elif fmt == 5:
        pixels = np.frombuffer(data[:width * height * 4], dtype=np.uint8)
        pixels = pixels.reshape(height, width, 4)
        if has_alpha:
            rgba = unpremultiply(pixels)                       # stored ARGB, premultiplied
        else:
            rgba = np.empty((height, width, 4), dtype=np.uint8)
            rgba[..., :3] = pixels[..., 1:]                    # PIX24: reserved, R, G, B
            rgba[..., 3] = 255
    else:
        raise ValueError("unsupported bitmap format {}".format(fmt))
    return character_id, width, height, rgba.tobytes()


def strip_erroneous_header(jpeg: bytes) -> bytes:
    """Some SWFs prefix JPEG data with a stray EOI+SOI pair. Flash ignores it."""
    if jpeg[:4] == b"\xff\xd9\xff\xd8":
        return jpeg[4:]
    return jpeg


def embedded_format(data: bytes) -> str:
    """SWF 8+ allows PNG and GIF89a inside the 'JPEG' tags. Habbo uses this heavily."""
    if data[:4] == b"\x89PNG":
        return "png"
    if data[:3] == b"GIF":
        return "gif"
    return "jpeg"


def decode_jpeg(payload: bytes, tag: int) -> tuple[int, int, int, bytes, str]:
    character_id = struct.unpack_from("<H", payload, 0)[0]
    if tag == 35:
        alpha_offset = struct.unpack_from("<I", payload, 2)[0]
        data = payload[6:6 + alpha_offset]
        alpha_zlib = payload[6 + alpha_offset:]
    else:
        data, alpha_zlib = payload[2:], None

    encoding = embedded_format(data)
    if encoding == "jpeg":
        data = strip_erroneous_header(data)
    image = Image.open(io.BytesIO(data))

    if encoding == "jpeg":
        # Only true JPEG uses the separate zlib alpha block; PNG/GIF carry their own.
        image = image.convert("RGB")
        width, height = image.size
        rgba = np.empty((height, width, 4), dtype=np.uint8)
        rgba[..., :3] = np.asarray(image, dtype=np.uint8)
        if alpha_zlib:
            alpha = np.frombuffer(zlib.decompress(alpha_zlib)[:width * height], dtype=np.uint8)
            rgba[..., 3] = alpha.reshape(height, width)
        else:
            rgba[..., 3] = 255
    else:
        image = image.convert("RGBA")
        width, height = image.size
        rgba = np.asarray(image, dtype=np.uint8).copy()
        # BitmapData/canvas canonicalizes fully transparent pixels to transparent black. PNG may
        # retain arbitrary hidden RGB under alpha=0; hashing that invisible payload would compare
        # encoder residue rather than Flash/OpenFL pixel semantics.
        rgba[rgba[..., 3] == 0, :3] = 0
    return character_id, width, height, rgba.tobytes(), encoding


# --------------------------------------------------------------------------- sound

SOUND_RATES = {0: 5512, 1: 11025, 2: 22050, 3: 44100}


def decode_sound(payload: bytes) -> dict:
    character_id = struct.unpack_from("<H", payload, 0)[0]
    flags = payload[2]
    fmt = flags >> 4
    if fmt != 2:
        return {"character_id": character_id, "format": fmt, "supported": False}
    sample_count = struct.unpack_from("<I", payload, 3)[0]
    seek_samples = struct.unpack_from("<h", payload, 7)[0]
    frames = payload[9:]
    return {
        "character_id": character_id,
        "format": "MP3",
        "rate_hz": SOUND_RATES[(flags >> 2) & 3],
        "bits": 16 if (flags >> 1) & 1 else 8,
        "channels": 2 if flags & 1 else 1,
        "sample_count": sample_count,
        "seek_samples": seek_samples,
        "mp3_bytes": len(frames),
        "mp3_sha256": hashlib.sha256(frames).hexdigest(),
        "supported": True,
    }


# --------------------------------------------------------------------------- driver

def scan(path: Path, cap: int) -> dict:
    raw = path.read_bytes()
    signature, body = decompress(raw)

    characters: dict[int, dict] = {}
    names: list[tuple[int, str]] = []
    counts: collections.Counter = collections.Counter()

    for code, payload in tags(body):
        if code in BITMAP_TAGS:
            tag_name = BITMAP_TAGS[code]
            counts[tag_name] += 1
            if code in (20, 36):
                cid, width, height, pixels = decode_lossless(payload, code)
                encoding = "zlib"
            else:
                cid, width, height, pixels, encoding = decode_jpeg(payload, code)
            counts[tag_name + ":" + encoding] += 1
            characters[cid] = {"kind": "bitmap", "tag": tag_name, "encoding": encoding,
                               "width": width, "height": height,
                               "rgba_sha256": hashlib.sha256(pixels).hexdigest(),
                               "rgba_md5": hashlib.md5(pixels).hexdigest()}
            if encoding in ("png", "jpeg"):
                # Lossy JPEG IDCT/color conversion is not byte-identical across Pillow, Chrome,
                # and Flash. Keep the independent pixels so the browser test can measure a
                # bounded channel error instead of pretending a SHA-256 comparison is valid.
                characters[cid]["reference_rgba_zlib_base64"] = base64.b64encode(
                    zlib.compress(pixels, 9)).decode("ascii")
        elif code == BINARY_TAG:
            cid = struct.unpack_from("<H", payload, 0)[0]
            counts["DefineBinaryData"] += 1
            characters[cid] = {"kind": "binary", "tag": "DefineBinaryData",
                               "bytes": len(payload) - 6,
                               "sha256": hashlib.sha256(payload[6:]).hexdigest()}
        elif code == SOUND_TAG:
            sound = decode_sound(payload)
            counts["DefineSound"] += 1
            characters[sound["character_id"]] = dict(sound, kind="sound", tag="DefineSound")
        elif code == SYMBOL_CLASS:
            count = struct.unpack_from("<H", payload, 0)[0]
            cursor = 2
            for _ in range(count):
                cid = struct.unpack_from("<H", payload, cursor)[0]
                cursor += 2
                end = payload.index(b"\0", cursor)
                names.append((cid, payload[cursor:end].decode("utf8", "replace")))
                cursor = end + 1

    # Only exported characters are reachable: AssetLibrary looks assets up by name.
    exported = []
    for cid, name in sorted(names):
        if cid in characters:
            exported.append(dict(characters[cid], character_id=cid, name=name))
    return {
        "signature": signature,
        "bytes": len(raw),
        "tag_counts": dict(counts.most_common()),
        "exported_total": len(exported),
        # Cap ordinary content to keep the browser canary bounded, but G2d's contract is all 24
        # reachable sounds. Never let the generic cap silently omit two BattleBall exports.
        "symbols": exported[:cap] + [
            symbol for symbol in exported[cap:] if symbol["kind"] == "sound"
        ],
        "symbols_capped_at": cap,
    }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", type=Path,
                    default=Path(__file__).resolve().parent / "g2_reader_contract.json")
    ap.add_argument("--max-symbols-per-file", type=int, default=12,
                    help="deterministic cap: the first N exported symbols by character id")
    args = ap.parse_args()

    files = {}
    totals: collections.Counter = collections.Counter()
    for relative, reason in CANARIES:
        path = NGH / relative
        if not path.exists():
            raise SystemExit("missing canary: " + str(path))
        result = scan(path, args.max_symbols_per_file)
        result["reason"] = reason
        result["sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
        files[relative] = result
        for symbol in result["symbols"]:
            totals[symbol["tag"]] += 1
        print("{:<58} {:<10} {:>4} exported, {} hashed".format(
            relative.split("/")[-1], result["signature"],
            result["exported_total"], len(result["symbols"])))

    contract = {
        "gate": "G2-swf-reader",
        "corpus": str(NGH),
        "corpus_policy": "read-only; the reader fetches over HTTP, never from a local path",
        "pixel_contract": "straight (un-premultiplied) RGBA8888, row-major, 4 bytes per pixel",
        "reference_implementation": "independent: Python zlib/lzma + PIL, versus Haxe/OpenFL + the "
                                    "browser JPEG decoder",
        "reference_limitation": "this proves two independent decoders agree, not parity with the "
                                "Flash client itself; that comparison is tracked separately",
        "hashed_symbols_by_tag": dict(totals.most_common()),
        "hashed_symbols_total": sum(totals.values()),
        "files": files,
    }
    args.json.write_text(json.dumps(contract, indent=2) + "\n", encoding="utf-8")
    print("\nhashed {} symbols: {}".format(
        contract["hashed_symbols_total"], contract["hashed_symbols_by_tag"]))
    print("written to", args.json)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
