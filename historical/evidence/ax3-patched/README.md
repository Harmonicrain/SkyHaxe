# Patched ax3 sources — snapshot

`.toolchain/ax3` is gitignored, so every converter change has to live somewhere tracked or it is
one clean checkout away from gone. `evidence/m2_patch_ax3.py` is the proper home: exact,
count-guarded replacements that fail loudly if upstream ax3 moves under them.

**This directory is a snapshot, not that.** It holds the 14 converter files as they stood after the
V5 avatar work, so nothing is lost, but the changes below are **not yet folded into
`m2_patch_ax3.py`**. Doing that is the next task on this file — until then, restoring the converter
from the patch script alone gives you the 21 recorded patches and none of these.

## What is here and not in the patch script

| File | Change |
|---|---|
| `src/ax3/ExprTyper.hx` | field access on a `Class` typed `TTAny` instead of erroring; `Map.setValue` known; dynamic arithmetic no longer fatal (ASAny carries the operators) |
| `src/ax3/Scanner.hx` | exponent without a decimal point, so `1E-18` lexes as a float |
| `src/ax3/PrinterBase.hx` | escape Haxe-reserved package segments — `com.sulake.habbo.avatar.enum` becomes `._enum` |
| `src/ax3/GenHaxe.hx` | same escape for package paths; XML and XMLList map to `com.sulake.core.utils.xml`, not `compat` |
| `src/ax3/Main.hx` | write output into the escaped directory, matching the printed package |
| `src/ax3/filters/RewriteArrayAccess.hx` | `map[k]` and `map[k] = v` become `getValue`/`setValue`; `xml["set"]` becomes `child("set")`; an index into `TTAny` no longer errors |
| `src/ax3/filters/RewriteE4X.hx` | attribute reads emit the `toString()` the declared `TTString` already claims |
| `src/ax3/filters/RewriteForIn.hx` | `for each` over a `Map` iterates `getValues()`, not its key iterator |
| `src/ax3/filters/RewriteAs.hx` | `as Number` / `as int` no longer fatal (the cast was already emitted) |
| `src/ax3/filters/RewriteHasOwnProperty.hx` | `hasOwnProperty` on XML goes straight through to the shim |
| `src/ax3/filters/AddSuperCtorCall.hx` | insert `super()` even when the base declares no constructor, since GenHaxe now emits one for every class |
| `compat/ASAny.hx` | `%` and the mixed ASAny/Float arithmetic overloads |

## Why the XML mapping matters most

The port had two XML shims: ax3's thin `compat.XML` over `haxe.Xml`, and SkyHaxe's
`com.sulake.core.utils.xml.XML`, which has the E4X surface the client uses and the G1d contract
tests. Generated code was compiling against one and hand-written code against the other.

Unifying on SkyHaxe's is right, and it moved one contract: `compat.XML.attribute()` returns a
`String`, while the E4X-shaped shim returns an `XMLList`, as E4X says. ax3 types an attribute read
as `TTString` either way, so `String(k.@name)` had its cast stripped as redundant and the coercion
vanished — `this._name = k.attribute("name")` against a `String` field. The RewriteE4X change
writes that coercion out.
