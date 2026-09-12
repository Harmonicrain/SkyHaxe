"""Explicit AS3 null-enumeration boundary for the generated productdata parser."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
relative = Path("com/sulake/habbo/session/product/ProductDataParser.hx")
source = ROOT / ".toolchain/v25/generated" / relative
target = ROOT / ".toolchain/v21/openfl" / relative
text = source.read_text(encoding="utf-8")
old = "for (_tmp_ in _local_9)"
new = "for (_tmp_ in (_local_9 == null ? [] : _local_9))"
if text.count(old) != 1:
    raise RuntimeError("ProductDataParser enumeration changed; review the boundary")
target.parent.mkdir(parents=True, exist_ok=True)
target.write_text(text.replace(old, new), encoding="utf-8", newline="\n")
