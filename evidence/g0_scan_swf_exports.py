#!/usr/bin/env python3
"""G0 — does every symbol the client can reach resolve to an asset the reader will support?

This is the load-bearing measurement behind decision D1 in PLAN.md: that SkyHaxe can read Habbo
content SWFs directly, with no conversion pipeline.

The client reaches assets by name:

    _loader.hasDefinition(name) -> _loader.getDefinition(name) as Class
    habbo-client-clean/src/com/sulake/core/assets/AssetLibrary.as:324-326

so an unexported character is invisible to it no matter what tag defines it. That is why this
scans *exports*, not a tag histogram: several files legitimately contain shapes, fonts and
edit-text left over from authoring, and none of it is reachable.

Exit code is 0 only if every exported symbol is either a supported asset kind or covered by an
explicit exclusion below. Anything else is a finding and fails the gate.

Usage:
    python g0_scan_swf_exports.py <dir> [<dir> ...] [--csv out.csv] [--gzip]

Read-only with respect to the corpus. Writes only the CSV you name.
"""
from __future__ import annotations

import argparse
import collections
import csv
import gzip
import hashlib
import io
import lzma
import os
import struct
import sys
import zlib

# --- what the Haxe reader will have to implement -----------------------------------------
# Character-defining tags mapped to (kind, tag name). The tag name is recorded per row so the
# reader's scope is derived from data rather than from prose: collapsing these into "bitmap"
# hides which decoders are actually required.
BITMAP_TAGS = {
    6:  "DefineBits",            # JPEG, shared table
    20: "DefineBitsLossless",    # zlib, 8/15/24-bit
    21: "DefineBitsJPEG2",
    35: "DefineBitsJPEG3",       # JPEG + alpha
    36: "DefineBitsLossless2",   # zlib + alpha
}
BINARY_TAGS = {87: "DefineBinaryData"}
OTHER_TAGS = {
    39: ("sprite", "DefineSprite"),
    60: ("video", "DefineVideoStream"),
    2: ("shape", "DefineShape"), 22: ("shape", "DefineShape2"),
    32: ("shape", "DefineShape3"), 83: ("shape", "DefineShape4"),
    48: ("font", "DefineFont2"), 75: ("font", "DefineFont3"),
    37: ("edittext", "DefineEditText"),
}
SOUND_FORMATS = {
    0: "native", 1: "ADPCM", 2: "MP3", 3: "PCM-LE", 4: "Nellymoser-16k",
    5: "Nellymoser-8k", 6: "Nellymoser", 11: "Speex",
}
SYMBOL_CLASS = 76

SUPPORTED_KINDS = {"bitmap", "binary", "sound", "root"}

# --- explicit, machine-readable exclusions -----------------------------------------------
# A path substring here means: this file is NOT part of the runtime content contract, so its
# exports do not have to be readable by the SkyHaxe asset reader. Each needs a reason.
EXCLUSIONS = [
    {
        "match": "mp3/gamedata/",
        "reason": "client asset bundle (basicassets.swf) parked in a stray subdirectory of "
                  "hof_furni; not furniture content. Exports sounds and fonts.",
    },
    {
        "match": "koekjes.swf",
        "reason": "exports five obfuscated names (_o_--, _a_---, ...) with no backing character "
                  "definition - pure ABC classes carried in SymbolClass. Nothing for an asset "
                  "reader to return. Excluded by owner decision 2026-08-31.",
    },
]


def excluded(path: str) -> str | None:
    norm = path.replace("\\", "/")
    for rule in EXCLUSIONS:
        if rule["match"] in norm:
            return rule["reason"]
    return None


def decompress(raw: bytes) -> tuple[str, bytes | None, str | None]:
    """Return (signature, body-after-8-byte-header, error).

    Three containers exist in this corpus:
      FWS  uncompressed
      CWS  zlib from byte 8
      ZWS  LZMA: [4-byte compressed length][5-byte props][data], uncompressed size from header
    """
    sig = raw[:3].decode("ascii", "replace")
    if sig == "FWS":
        return sig, raw[8:], None
    if sig == "CWS":
        try:
            return sig, zlib.decompress(raw[8:]), None
        except Exception as exc:
            # Six Gordon files contain the entire declared SWF body but omit zlib's four-byte
            # Adler-32 trailer. Flash accepts them and the reader can too: use streaming inflate,
            # then require the decompressed length to match the SWF header exactly. This does not
            # mask genuinely truncated files; those still fail the length check below.
            try:
                expected = struct.unpack_from("<I", raw, 4)[0] - 8
                stream = zlib.decompressobj()
                body = stream.decompress(raw[8:])
                if len(body) == expected:
                    return sig, body, None
            except Exception:
                pass
            return sig, None, "zlib: " + repr(exc)[:50]
    if sig == "ZWS":
        try:
            # Header: 'ZWS' ver (4) + fileLength (4) = 8, then compressedLen (4), props (5).
            file_length = struct.unpack_from("<I", raw, 4)[0]
            props = raw[12:17]
            payload = raw[17:]
            # Rebuild an "LZMA alone" stream: props + 8-byte uncompressed size + data.
            # The declared size is rejected by liblzma here (these streams carry an
            # end-of-stream marker), so decode with the unknown-size sentinel and verify the
            # length against the header afterwards.
            expected = file_length - 8
            alone = props + (b"\xff" * 8) + payload
            body = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE).decompress(alone)
            if len(body) != expected:
                return sig, None, "lzma: got {} bytes, header says {}".format(len(body), expected)
            return sig, body, None
        except Exception as exc:
            return sig, None, "lzma: " + repr(exc)[:50]
    return sig, None, "unknown container"


def scan(path: str):
    """Return (sig, [(character_id, name, kind, tag_name)], error)."""
    with open(path, "rb") as fh:
        raw = fh.read()
    sig, body, err = decompress(raw)
    if body is None:
        return sig, None, err

    nbits = body[0] >> 3                       # frame rect, variable bit width
    offset = ((5 + nbits * 4) + 7) // 8 + 4    # + frame rate and frame count

    kind_by_id: dict[int, tuple[str, str]] = {}
    symbols: list[tuple[int, str]] = []

    while offset < len(body) - 1:
        record = struct.unpack_from("<H", body, offset)[0]
        offset += 2
        code, length = record >> 6, record & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", body, offset)[0]
            offset += 4
        payload = offset

        if code in BITMAP_TAGS:
            kind_by_id[struct.unpack_from("<H", body, payload)[0]] = ("bitmap", BITMAP_TAGS[code])
        elif code in BINARY_TAGS:
            kind_by_id[struct.unpack_from("<H", body, payload)[0]] = ("binary", BINARY_TAGS[code])
        elif code == 14:
            character_id = struct.unpack_from("<H", body, payload)[0]
            sound_format = body[payload + 2] >> 4
            format_name = SOUND_FORMATS.get(sound_format, "format-{}".format(sound_format))
            kind_by_id[character_id] = ("sound", "DefineSound({})".format(format_name))
        elif code in OTHER_TAGS:
            kind_by_id[struct.unpack_from("<H", body, payload)[0]] = OTHER_TAGS[code]
        elif code == SYMBOL_CLASS:
            count = struct.unpack_from("<H", body, payload)[0]
            cursor = payload + 2
            for _ in range(count):
                cid = struct.unpack_from("<H", body, cursor)[0]
                cursor += 2
                end = body.index(b"\0", cursor)
                symbols.append((cid, body[cursor:end].decode("utf8", "replace")))
                cursor = end + 1

        offset += length
        if code == 0:
            break

    rows = []
    for cid, name in symbols:
        if cid == 0:
            rows.append((cid, name, "root", "-"))
        else:
            kind, tag = kind_by_id.get(cid, ("MISSING", "-"))
            rows.append((cid, name, kind, tag))
    return sig, rows, None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("dirs", nargs="+")
    ap.add_argument("--csv", default="g0_results.csv")
    ap.add_argument("--gzip", action="store_true", help="write <csv>.gz instead")
    args = ap.parse_args()

    files = []
    for d in args.dirs:
        for dirpath, _, names in os.walk(d):
            # Case-insensitive: the corpus contains .swf and .SWF.
            files.extend(os.path.join(dirpath, n) for n in names if n.lower().endswith(".swf"))
    files.sort()

    kinds = collections.Counter()
    tags = collections.Counter()
    sigs = collections.Counter()
    unreadable: list[tuple[str, str]] = []
    excluded_unreadable: list[tuple[str, str, str]] = []
    findings: list[tuple[str, str, str, str]] = []
    excluded_files = 0

    path_out = args.csv + (".gz" if args.gzip else "")
    opener = (lambda p: gzip.open(p, "wt", newline="", encoding="utf-8")) if args.gzip \
        else (lambda p: open(p, "w", newline="", encoding="utf-8"))

    with opener(path_out) as out:
        w = csv.writer(out)
        w.writerow(["file", "character_id", "exported_name", "kind", "tag", "excluded"])
        for path in files:
            why = excluded(path)
            if why:
                excluded_files += 1
            try:
                sig, rows, err = scan(path)
            except Exception as exc:
                problem = repr(exc)[:60]
                if why:
                    excluded_unreadable.append((path, problem, why))
                else:
                    unreadable.append((path, problem))
                continue
            sigs[sig] += 1
            if rows is None:
                problem = err or "?"
                if why:
                    excluded_unreadable.append((path, problem, why))
                else:
                    unreadable.append((path, problem))
                continue
            for cid, name, kind, tag in rows:
                kinds[kind] += 1
                if tag != "-":
                    tags[tag] += 1
                w.writerow([os.path.relpath(path), cid, name, kind, tag, "yes" if why else ""])
                if kind not in SUPPORTED_KINDS and not why:
                    findings.append((os.path.relpath(path), name, kind, tag))

    print("files found      :", len(files))
    print("containers       :", dict(sigs))
    print("excluded files   :", excluded_files, "({} rule(s))".format(len(EXCLUSIONS)))
    print("excluded unread. :", len(excluded_unreadable))
    print("unreadable       :", len(unreadable))
    print("\nexported symbols by kind:")
    for kind, n in kinds.most_common():
        print("   {:<10} {:>9}".format(kind, n))
    print("\ncharacter tag variants the reader must implement:")
    for tag, n in tags.most_common():
        print("   {:<22} {:>9}".format(tag, n))
    if unreadable:
        print("\nUNREADABLE ({}):".format(len(unreadable)))
        for row in unreadable[:20]:
            print("   ", row)
    if excluded_unreadable:
        print("\nEXCLUDED UNREADABLE ({}; outside reader contract):".format(
            len(excluded_unreadable)))
        for path, problem, _ in excluded_unreadable[:20]:
            print("   ", (path, problem))
    if findings:
        print("\nUNEXPLAINED EXPORTS ({}):".format(len(findings)))
        for row in findings[:20]:
            print("   ", row)
    print("\nper-symbol results written to", path_out)

    ok = not unreadable and not findings
    print("\nG0:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
