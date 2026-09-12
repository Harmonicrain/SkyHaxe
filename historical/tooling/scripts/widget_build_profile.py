"""Explicit source-derived widget build profile; never applied to the full UI batch.

Retain original enabled case bodies and the complete desktop registration/event bus.
Only factory switch alternatives, now-unused locals and imports are excluded. Avatar
info remains enabled because RoomDesktop's original bot callbacks reference it.
"""
import hashlib
import json
from pathlib import Path
import re

REPO = Path(__file__).resolve().parents[1]
MANIFEST = REPO / "evidence/infostand_build_profile.json"
OWNERS = ("com/sulake/habbo/ui/RoomDesktop.as",
          "com/sulake/habbo/ui/widget/RoomWidgetFactory.as")
ENABLED = {"INFOSTAND", "AVATAR_INFO"}
NONCODE = re.compile(r'''"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|//[^\n]*|/\*.*?\*/''', re.S)


def mask(text):
    return NONCODE.sub(lambda match: "".join("\n" if c == "\n" else " " for c in match[0]), text)


def close_brace(code, start):
    depth = 0
    for index in range(start, len(code)):
        depth += (code[index] == "{") - (code[index] == "}")
        if depth == 0:
            return index
    raise ValueError("Unbalanced source braces")


def project(relative, text):
    if relative not in OWNERS:
        return text, None
    code = mask(text)
    method = re.search(r"\bfunction\s+createWidget\s*\(", code)
    if not method:
        raise ValueError("Widget owner no longer declares createWidget")
    opening = code.index("{", method.end())
    ending = close_brace(code, opening)
    switch = re.search(r"\bswitch\s*\(\s*k\s*\)\s*\{", code[opening:ending])
    if not switch:
        raise ValueError("Widget owner switch contract changed")
    start = opening + switch.end() - 1
    end = close_brace(code, start)
    labels = []
    depth = 0
    for token in re.finditer(r"[{}]|\bcase\s+RoomWidgetEnum\.(\w+)\s*:|\bdefault\s*:", code[start + 1:end]):
        if token[0] == "{": depth += 1
        elif token[0] == "}": depth -= 1
        elif depth == 0: labels.append((start + 1 + token.start(), token[1]))
    names = {name for _, name in labels}
    if not ENABLED <= names or None in names:
        raise ValueError("Widget switch labels/default changed; review profile")
    retained, excluded = [], []
    for index, (position, name) in enumerate(labels):
        finish = labels[index + 1][0] if index + 1 < len(labels) else end
        body = text[position:finish]
        if name in ENABLED:
            # No synthesized widget constructors or registration code.
            retained.append(body)
        else:
            excluded.append(name)
    result = text[:start + 1] + "\n" + "\n".join(retained) + text[end:]
    # Only remove uninitialized locals unused after selection; never discard an initializer.
    method_code = mask(result)
    opening = method_code.index("{", method.end())
    ending = close_brace(method_code, opening)
    locals_ = list(re.finditer(r"\bvar\s+(\w+)\s*:\s*[\w.<>]+\s*;", method_code[opening:ending]))
    removed_locals = []
    for match in reversed(locals_):
        if len(re.findall(r"\b" + re.escape(match[1]) + r"\b", method_code[opening:ending])) == 1:
            position, finish = opening + match.start(), opening + match.end()
            result = result[:position] + result[finish:]
            removed_locals.append(match[1])
    imports = list(re.finditer(r"(?m)^[ \t]*import\s+([\w.]+)\s*;[^\S\n]*", result))
    used = mask(re.sub(r"(?m)^[ \t]*import\s+[^;]+;", "", result))
    for match in reversed(imports):
        if not re.search(r"\b" + re.escape(match[1].rsplit(".", 1)[-1]) + r"\b", used):
            result = result[:match.start()] + result[match.end():]
    return result, {"source_sha256": hashlib.sha256(text.encode()).hexdigest(),
                    "projected_sha256": hashlib.sha256(result.encode()).hexdigest(),
                    "excluded_widgets": excluded, "removed_unused_locals": removed_locals}


def apply_to_staged(root):
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    for relative, expected in manifest["owners"].items():
        path = root / relative
        if not path.is_file():
            raise ValueError("Build profile owner missing: " + relative)
        result, record = project(relative, path.read_text(encoding="utf-8-sig"))
        if record != expected:
            raise ValueError("Widget profile source/projection drift: " + relative)
        path.write_text(result, encoding="utf-8", newline="\n")
