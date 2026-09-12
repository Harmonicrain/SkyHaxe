#!/usr/bin/env python3
"""M2 — patch ax3 so E4X constructs the client actually uses can be converted.

`.toolchain/ax3` is gitignored, so the patch lives here as a script rather than as a diff against
a checked-in tree. Every replacement is exact and count-guarded: if upstream ax3 changes under us,
this fails loudly instead of silently not patching.

Why patch the converter rather than rewrite the AS3:

  The client has 231 files touching XML. A pre-conversion rewrite fixes one site at a time and
  edits a tree that is supposed to stay authoritative; a converter fix travels with the tool and
  covers every file. G1c established the precedent by patching `unescape`.

  The exception is the XML *literal* (`var x:XML = <foo/>`). That needs E4X lexing in the scanner,
  which is a genuine feature rather than a patch, and `com.sulake.core` contains exactly one site.
  A guarded pre-rule is the right tool for that one, and this script does not attempt it.

Usage:
    python build-support/generation/patch-converter.py            # apply
    python build-support/generation/patch-converter.py --verify   # check only
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

SUPPORT = Path(__file__).resolve().parent
AX3 = SUPPORT.parents[1] / ".toolchain/ax3"
ADDITIONS = {
    "src/ax3/filters/OpenFLEventCallbacks.hx": "ax3-additions/OpenFLEventCallbacks.hx",
    "src/ax3/filters/GuardedSwitchExit.hx": "ax3-additions/GuardedSwitchExit.hx",
    "src/ax3/filters/PlatformApi.hx": "ax3-additions/PlatformApi.hx",
    "src/ax3/filters/NumericRelations.hx": "ax3-additions/NumericRelations.hx",
    "src/ax3/filters/ImplicitAnyReturn.hx": "ax3-additions/ImplicitAnyReturn.hx",
    "src/ax3/filters/InheritedAccessors.hx": "ax3-additions/InheritedAccessors.hx",
    "src/ax3/filters/ReferenceEquality.hx": "ax3-additions/ReferenceEquality.hx",
    "src/ax3/filters/XMLStringEquality.hx": "ax3-additions/XMLStringEquality.hx",
    "src/ax3/filters/GraphicContextPlatform.hx": "ax3-additions/GraphicContextPlatform.hx",
    "src/ax3/filters/OpenFLTextTypes.hx": "ax3-additions/OpenFLTextTypes.hx",
    "src/ax3/filters/FunctionScopedVars.hx": "ax3-additions/FunctionScopedVars.hx",
    "src/ax3/filters/VoidValues.hx": "ax3-additions/VoidValues.hx",
}

PATCHES = [
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Preserve undefined fallthrough for AS3 :* statement-only methods.",
        "old": "\t\t\tnew VarInits(context),",
        "new": "\t\t\tnew ImplicitAnyReturn(context),\n\t\t\tnew VarInits(context),",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Undefined is not null when consumed by Number; retain the Flash return value on JS.",
        "old": "\tpublic static inline final MAX_INT = 2147483647;",
        "new": "\tpublic static inline function undefinedValue():ASAny {\n\t\t#if js\n\t\treturn js.Syntax.code(\"undefined\");\n\t\t#else\n\t\treturn null;\n\t\t#end\n\t}\n\tpublic static inline final MAX_UINT:UInt = 0xFFFFFFFF;\n\tpublic static inline final MIN_UINT:UInt = 0;\n\tpublic static inline final MAX_INT = 2147483647;",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/NumberApi.hx",
        "reason": "AS3 uint limits exist as runtime constants; Haxe UInt abstract has no MAX_VALUE/MIN_VALUE.",
        "old": '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEBuiltin(builtinToken, "int")})}, "MAX_VALUE", fieldToken):',
        "new": '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEBuiltin(builtinToken, "uint")})}, "MAX_VALUE", fieldToken):\n'
               '\t\t\t\treturn mkBuiltin("ASCompat.MAX_UINT", TTUint, builtinToken.leadTrivia, fieldToken.trailTrivia);\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEBuiltin(builtinToken, "uint")})}, "MIN_VALUE", fieldToken):\n'
               '\t\t\t\treturn mkBuiltin("ASCompat.MIN_UINT", TTUint, builtinToken.leadTrivia, fieldToken.trailTrivia);\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEBuiltin(builtinToken, "int")})}, "MAX_VALUE", fieldToken):',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "present": "public static function sortOn<T>(a:Array<T>, fieldName:Dynamic, options:Dynamic)",
        "reason": "ax3 ships Array.sortOn as a Flash-only stub whose own TODO says it exists so JS compiles. It compiles and then throws on first use, and the converted RoomSpriteCanvas sorts its sprite list by depth every frame -- so the room rendered black. Implemented like the sortWithOptions helper beside it.",
        "old": "\tpublic static inline function sortOn<T>(a:Array<T>, fieldName:String, options:Int):Array<T> {\n\t\t// TODO: this will only work on Flash, but we need it to _compile_ on JS too for now, so `RectanglePacker` is not breaking the build :-P\n\t\treturn (cast a).sortOn(fieldName, options);\n\t}",
        "new": "\t/**\n\t\tAS3's `Array.sortOn(fieldName, options)`.\n\n\t\tUpstream ax3 ships this as a stub that calls through to the Flash-only method, with a TODO\n\t\tsaying it exists so JS *compiles*. It does compile, and then throws the moment it runs --\n\t\twhich is exactly what happened when the converted RoomSpriteCanvas took over the room: it\n\t\tsorts its sprite list by depth every frame, threw every frame, and the room stayed black.\n\n\t\tSame shape as sortWithOptions below, but ordering by a named field rather than by the\n\t\telements themselves. RETURNINDEXEDARRAY and UNIQUESORT change what the call returns, so\n\t\tthey are refused rather than quietly ignored.\n\t**/\n\tpublic static function sortOn<T>(a:Array<T>, fieldName:String, options:Int):Array<T> {\n\t\tif ((options & RETURNINDEXEDARRAY) != 0 || (options & UNIQUESORT) != 0) {\n\t\t\tthrow \"ASArray.sortOn: RETURNINDEXEDARRAY and UNIQUESORT are not implemented\";\n\t\t}\n\t\tvar numeric = (options & NUMERIC) != 0;\n\t\tvar descending = (options & DESCENDING) != 0;\n\t\tvar caseInsensitive = (options & CASEINSENSITIVE) != 0;\n\t\ta.sort(function(left, right) {\n\t\t\tvar lf = Reflect.getProperty(left, fieldName);\n\t\t\tvar rf = Reflect.getProperty(right, fieldName);\n\t\t\tvar result;\n\t\t\tif (numeric) {\n\t\t\t\tvar l:Float = lf == null ? 0 : cast lf;\n\t\t\t\tvar r:Float = rf == null ? 0 : cast rf;\n\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n\t\t\t} else {\n\t\t\t\tvar l = lf == null ? \"\" : Std.string(lf);\n\t\t\t\tvar r = rf == null ? \"\" : Std.string(rf);\n\t\t\t\tif (caseInsensitive) {\n\t\t\t\t\tl = l.toLowerCase();\n\t\t\t\t\tr = r.toLowerCase();\n\t\t\t\t}\n\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n\t\t\t}\n\t\t\treturn descending ? -result : result;\n\t\t});\n\t\treturn a;\n\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "openfl spells Vector as `abstract Vector<T>(IVector<T>)` with no @:from for the underlying IVector, and Vector.convert is typed convert<T,U>(IVector<T>):IVector<U>. So its result cannot reach a Vector<T> parameter by unification or by a type hint -- IVector<Unknown> is a different type. AS3 `Vector.<T>(v)` is an unchecked runtime conversion and a Haxe cast is its exact equivalent, so the call is printed as one. The name stays Vector.convert everywhere in the typed tree; only the printed form changes.",
        "old": "\t\t\tcase (_.startsWith(\"Vector.\") => true):\n\t\t\t\timportVector();\n\t\t\t\tname;",
        "new": "\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n"
               "\t\t\tcase \"Vector.convert\":\n"
               "\t\t\t\timportVector();\n"
               "\t\t\t\t\"cast Vector.convert\";\n"
               "\t\t\tcase (_.startsWith(\"Vector.\") => true):\n"
               "\t\t\t\t// every other Vector.* builtin prints unchanged\n"
               "\t\t\t\timportVector();\n"
               "\t\t\t\tname;",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteVectorDecl.hx",
        "reason": "A covariant Vector cast -- AS3 `Vector.<IAreaHideInfo>(v)` over a Vector.<AreaHideMessageData> -- becomes `Vector.convert(v)`, whose signature is convert<T,U>(IVector<T>):IVector<U>. U is only ever resolved by the type hint, and ax3 omits that hint when the expected type already equals the cast target, which is precisely the covariant case. The result does not unify and the call is rejected. Haxe generics are invariant, so no AS3-level rewrite can express this; the hint is what carries it. 426 such casts exist across the client.",
        "old": "\t\t\t\t\t\t\tif (typeEq(e.expectedType, TTVector(elemType))) {\n\t\t\t\t\t\t\t\te;\n\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\te.with(kind = TEHaxeRetype(e));\n\t\t\t\t\t\t\t}",
        "new": "\t\t\t\t\t\t\t// Patched for M2: Vector.convert returns an unbound element type, so it always needs\n\t\t\t\t\t\t\t// the hint -- including when the expected type already matches the cast target,\n\t\t\t\t\t\t\t// which is exactly the covariant cast ax3 was leaving unhinted.\n\t\t\t\t\t\t\te.with(kind = TEHaxeRetype(e));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/FixNonInlineableDefaultArgs.hx",
        "reason": "This filter moves a non-constant default into the body behind a null check, and bails immediately on a function with no body -- which is every interface method. So an interface declaring `_arg:Number=NaN` kept the NaN that Haxe rejects, while its implementations were rewritten to `=null`: the two no longer agreed, and IRoomEngine alone failed 18 times. An interface has no body to move the assignment into, but it still needs the same `null` default its implementations now carry.",
        "old": "\t\tif (fun.expr == null) return;\n\t\tvar initExprs = [];\n\t\tvar indent = getInnerIndent(fun.expr);",
        "new": "\t\t// Patched for M2: an interface has no body, but its defaults still need rewriting.\n\t\tvar initExprs = [];\n\t\tvar indent = if (fun.expr == null) [] else getInnerIndent(fun.expr);",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/FixNonInlineableDefaultArgs.hx",
        "reason": "...and only prepend the generated null checks where there is a body to prepend them to.",
        "old": "\t\tif (initExprs.length > 0) {",
        "new": "\t\tif (initExprs.length > 0 && fun.expr != null) {",
        "count": 1,
    },
    {
        "file": "src/ax3/Scanner.hx",
        "reason": "A Vector type parameter followed straight by a default value -- `Vector.<IAreaHideInfo>=null` -- lexes its closing bracket and the equals as one TkGtEquals, so parseTypeParam throws 'Expected >' and ax3 skips the whole file. The scanner already suppresses the `>>` right-shift token in MNoRightShift mode, which is the mode parseTypeParam scans in and exists for exactly this reason (nested Vector.<Vector.<T>>); the `>=` case simply was not given the same guard. 8 sites across 6 files, IRoomCreator, IRoomEngine and RoomEngine among them.",
        "old": "\t\t\t\t\t\t\tcase \"=\".code:\n\t\t\t\t\t\t\t\tpos++;\n\t\t\t\t\t\t\t\treturn mk(TkGtEquals);",
        "new": "\t\t\t\t\t\t\t// Patched for M2: a type parameter can be closed by the `>` of a `>=`. See build-support/generation/patch-converter.py\n\t\t\t\t\t\t\tcase \"=\".code if (mode != MNoRightShift):\n\t\t\t\t\t\t\t\tpos++;\n\t\t\t\t\t\t\t\treturn mk(TkGtEquals);",
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
        "present": "// Flash Dictionary returns `undefined` for an absent key.",
        "reason": "Flash Dictionary returns undefined for an absent key. The JS compatibility "
                  "table returned null, so Number(missing) became 0 instead of NaN and "
                  "FurnitureAnimatedVisualization treated a missing automatic-state index as "
                  "animation zero, overwriting the server-provided furniture state.",
        "old": "\tpublic function get(key:K):Null<V> {\n"
               "\t\tfor (entry in entries) if (entry.key == key) return entry.value;\n"
               "\t\treturn null;\n"
               "\t}",
        "new": "\tpublic function get(key:K):Null<V> {\n"
               "\t\tfor (entry in entries) if (entry.key == key) return entry.value;\n"
               "\t\t// Flash Dictionary returns `undefined` for an absent key. This distinction is observable:\n"
               "\t\t// Number(undefined) is NaN, while Number(null) is 0. RoomObjectModel relies on the former\n"
               "\t\t// when deciding whether FURNITURE_AUTOMATIC_STATE_INDEX exists; returning null made every\n"
               "\t\t// animated furniture visualization overwrite its packet state with animation zero.\n"
               "\t\treturn js.Syntax.code(\"undefined\");\n"
               "\t}",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "ax3 emits a Globals module whose every member is `untyped "
                  "__global__[\"some.flash.function\"]`. That identifier only exists on the "
                  "Flash target: on JS it compiles to a bare `__global__` reference and throws "
                  "ReferenceError the first time it is reached -- which is what happened the "
                  "moment Component's constructor asked for a dependency's qualified class name. "
                  "This is the lookup those members go through instead.",
        "old": "\tpublic static inline function unescape(s:String):String {",
        "new": "\t/**\n"
               "\t\tA Flash global function, by name.\n"
               "\t\t\n"
               "\t\tax3's generated Globals module reaches the Flash player's module-level "
               "functions through\n"
               "\t\t`untyped __global__[name]`, which does not exist off Flash. Each name "
               "the client actually\n"
               "\t\treaches is given a JS equivalent here; an unimplemented one throws by "
               "name rather than\n"
               "\t\treturning null, because a global that silently does nothing is a "
               "worse failure than a\n"
               "\t\tloud one.\n"
               "\t**/\n"
               "\tpublic static function globalFunction(name:String):Dynamic {\n"
               "\t\t#if flash\n"
               "\t\treturn untyped __global__[name];\n"
               "\t\t#else\n"
               "\t\treturn switch name {\n"
               "\t\t\tcase \"flash.utils.getQualifiedClassName\": "
               "getQualifiedClassName;\n"
               "\t\t\tcase \"escape\": escape;\n"
               "\t\t\tcase \"unescape\": unescape;\n"
               "\t\t\tcase \"encodeURIComponent\": encodeURIComponent;\n"
               "\t\t\tcase \"decodeURIComponent\": decodeURIComponent;\n"
               "\t\t\tcase \"decodeURI\": decodeURI;\n"
               "\t\t\tcase _: throw new haxe.Exception("
               "\"no JS equivalent for the Flash global \" + name);\n"
               "\t\t};\n"
               "\t\t#end\n"
               "\t}\n"
               "\n"
               "\t/**\n"
               "\t\tAS3's flash.utils.getQualifiedClassName.\n"
               "\t\t\n"
               "\t\tAS3 spells a qualified name `package::Class`, and callers use it as an "
               "identity key --\n"
               "\t\tComponent keys its required dependencies by it. So the separator "
               "matters only in that it\n"
               "\t\thas to match what other AS3 code would produce, and the value has to "
               "be stable.\n"
               "\t**/\n"
               "\tpublic static function getQualifiedClassName(value:Any):String {\n"
               "\t\tif (value == null) return \"null\";\n"
               "\t\tvar path = Std.isOfType(value, Class) "
               "? Type.getClassName(cast value) : Type.getClassName(Type.getClass(value));\n"
               "\t\tif (path == null) return Std.string(value);\n"
               "\t\tvar dot = path.lastIndexOf(\".\");\n"
               "\t\treturn dot < 0 ? path : path.substr(0, dot) + \"::\" + "
               "path.substr(dot + 1);\n"
               "\t}\n"
               "\n"
               "\tpublic static inline function unescape(s:String):String {",
        "present": "\tpublic static function globalFunction(name:String):Dynamic {",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ExternModuleLevelImports.hx",
        "reason": "Emit the Globals module against that lookup rather than against __global__.",
        "old": "\t\tvar eGlobal = mkBuiltin(\"untyped __global__\", TTBuiltin);\n"
               "\t\treturn mk(TEArrayAccess({\n"
               "\t\t\tsyntax: {\n"
               "\t\t\t\topenBracket: mkOpenBracket(),\n"
               "\t\t\t\tcloseBracket: mkCloseBracket()\n"
               "\t\t\t},\n"
               "\t\t\teobj: eGlobal,",
        "new": "\t\t// Patched for M2: __global__ exists only on Flash. See "
               "build-support/generation/patch-converter.py\n"
               "\t\tvar eGlobal = mkBuiltin(\"ASCompat.globalFunction\", TTBuiltin);\n"
               "\t\treturn mk(TECall(eGlobal, {\n"
               "\t\t\topenParen: mkOpenParen(),\n"
               "\t\t\tcloseParen: mkCloseParen(),\n"
               "\t\t\targs: [{comma: null, expr:\n"
               "\t\t\t\tmk(TELiteral(TLString(new Token(0, TkStringDouble, "
               "'\"$name\"', [], []))), TTString, TTString)}]\n"
               "\t\t}), TTBuiltin, TTBuiltin);\n"
               "\t}\n"
               "\n"
               "\tstatic function mkGlobalAccessUnused(name:String):TExpr {\n"
               "\t\tvar eGlobal = mkBuiltin(\"untyped __global__\", TTBuiltin);\n"
               "\t\treturn mk(TEArrayAccess({\n"
               "\t\t\tsyntax: {\n"
               "\t\t\t\topenBracket: mkOpenBracket(),\n"
               "\t\t\t\tcloseBracket: mkCloseBracket()\n"
               "\t\t\t},\n"
               "\t\t\teobj: eGlobal,",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "The XMLList(value) cast rewrite emits an XMLList.coerce builtin, and GenHaxe "
                  "refuses to print a builtin it does not know. The E4X shim owns that name the "
                  "same way ASCompat owns its own.",
        "old": "\t\t\tcase (_.startsWith(\"ASCompat.\") => true)",
        "new": "\t\t\t// Patched for M2: the E4X shim's coercion, emitted by the "
               "XMLList(value) cast rewrite.\n"
               "\t\t\tcase \"com.sulake.core.utils.xml.XMLList.coerce\": name;\n"
               "\t\t\tcase (_.startsWith(\"ASCompat.\") => true)",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "`XML(value)` is recognised as a cast here but `XMLList(value)` is not, so the "
                  "latter stayed a call on a builtin and was printed as a call on the shim class "
                  "-- which Haxe rejects. E4X gives them the same shape; type it the same way.",
        "old": "\t\t\tcase {kind: TEBuiltin(syntax, \"XML\")}:\n"
               "\t\t\t\ttype = TTXML;",
        "new": "\t\t\tcase {kind: TEBuiltin(syntax, \"XML\")}:\n"
               "\t\t\t\ttype = TTXML;\n"
               "\n"
               "\t\t\t// Patched for M2: XMLList(value) is E4X's parse, and a cast like "
               "XML(value).\n"
               "\t\t\tcase {kind: TEBuiltin(syntax, \"XMLList\")}:\n"
               "\t\t\t\treturn mkCast(mkDotPath(syntax), TTXMLList);",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "`XMLList(value)` parses a string into an XMLList in E4X. ax3 resolves XMLList "
                  "to playerglobal's class rather than to TTXMLList, so the cast fell through to "
                  "the generic class-cast branch and was emitted as a call on the type -- which "
                  "Haxe rejects, because a class is not callable. The shim spells this coercion "
                  "XMLList.coerce, so name it.",
        "old": "\t\t\t\t\t// SomeClass(value)\n"
               "\t\t\t\t\tcase [exprType, TTInst(cls)]:",
        "new": "\t\t\t\t\t// Patched for M2: XMLList(value) is E4X's parse, not a "
               "class cast.\n"
               "\t\t\t\t\tcase [_, TTXMLList]:\n"
               "\t\t\t\t\t\tvar eCoerce = mkBuiltin(\"com.sulake.core.utils.xml.XMLList.coerce\", "
               "TTFun([TTAny], TTXMLList), removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(eCoerce, {\n"
               "\t\t\t\t\t\t\topenParen: syntax.openParen,\n"
               "\t\t\t\t\t\t\targs: [{expr: expr, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: syntax.closeParen\n"
               "\t\t\t\t\t\t}), type = TTXMLList);\n"
               "\n"
               "\t\t\t\t\t// SomeClass(value)\n"
               "\t\t\t\t\tcase [exprType, TTInst(cls)]:",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteE4X.hx",
        "reason": "An attribute read is coerced to String unless the expected type is numeric, "
                  "but E4X says `node.@x` *is* an XMLList and the client assigns it to one "
                  "(`var _local_3:XMLList = _local_2.@x;` in FurnitureLogic, which then calls "
                  "length() on it). Appending toString() there produces a String where the "
                  "declared type is XMLList. When the expected type is already XML or XMLList "
                  "there is nothing to coerce.",
        "old": "\t\tvar eToString = mk(TEField({kind: TOExplicit(mkDot(), eCall), "
               "type: TTXMLList}, \"toString\",",
        "new": "\t\t// Patched for M2: an attribute read already is an XMLList, so a "
               "context that wants\n"
               "\t\t// XML or XMLList needs no coercion at all.\n"
               "\t\tif (expectedType.match(TTXML | TTXMLList)) return eCall;\n"
               "\t\tvar eToString = mk(TEField({kind: TOExplicit(mkDot(), eCall), "
               "type: TTXMLList}, \"toString\",",
        "present": "// XML or XMLList needs no coercion at all.",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/FixNonInlineableDefaultArgs.hx",
        "reason": "AS3's `function f(x:Number = NaN)` is legal; Haxe requires a constant default, "
                  "and NaN is not one. This filter already moves a non-inlineable default into "
                  "the body behind a null check, but only recognises a static field reference. "
                  "NaN reaches it as a builtin, so the room messages -- which use it for every "
                  "optional coordinate -- failed to compile.",
        "old": "\t\t\t\tcase TArgNormal(type, init = {expr: {kind: TEField({type: "
               "TTStatic(cls)}, fieldName, fieldToken)}}):",
        "new": "				// Patched for M2: NaN is a builtin, not a static field, and is not a Haxe constant.\n"
               "				case TArgNormal(type, init = {expr: {kind: TEBuiltin(_, \"NaN\")}}):\n"
               "					// An interface method has no body and no local for the argument, so there is\n"
               "					// nothing to move the assignment into -- only the default itself is rewritten.\n"
               "					if (fun.expr != null) {\n"
               "					var eLocal = mk(TELocal(mkIdent(arg.name), arg.v), arg.v.type, arg.v.type);\n"
               "					initExprs.push({\n"
               "						expr: mk(TEIf({\n"
               "							syntax: {\n"
               "								keyword: mkIdent(\"if\", indent, [whitespace]),\n"
               "								openParen: mkOpenParen(),\n"
               "								closeParen: addTrailingWhitespace(mkCloseParen())\n"
               "							},\n"
               "							econd: mk(TEBinop(eLocal, OpEquals(mkEqualsEqualsToken()), mkNullExpr()), TTBoolean, TTBoolean),\n"
               "							ethen: mk(TEBinop(eLocal, OpAssign(new Token(0, TkEquals, \"=\", [whitespace], [whitespace])), init.expr), eLocal.type, eLocal.type),\n"
               "							eelse: null\n"
               "						}), TTVoid, TTVoid),\n"
               "						semicolon: addTrailingNewline(mkSemicolon()),\n"
               "					});\n"
               "					}\n"
               "					arg.kind = TArgNormal(type, init.with(expr = mkNullExpr()));\n"
               "\n"
               "				case TArgNormal(type, init = {expr: {kind: TEField({type: TTStatic(cls)}, fieldName, fieldToken)}}):",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteRedefinedPrivate.hx",
        "reason": "AS3 lets a subclass declare a var with the same name as a private one in its "
                  "parent -- the parent's is invisible to it, so they are two separate fields. "
                  "Haxe rejects that, and ax3 resolves it by renaming the *parent's* field. That "
                  "cannot work here: closures are converted in batches, so the parent usually "
                  "belongs to a batch that has already been written and is only staged for "
                  "typing, and its rename is discarded. Renaming the subclass's copy instead is "
                  "self-contained -- the field is private, so nothing outside the subclass can "
                  "name it -- and produces the same two distinct fields AS3 had.",
        "old": "\t\t\t\t\t\t\t\tcase TFVar({name: name}) | TFFun({name: name}) | TFGetter({name: name}) | TFSetter({name: name}):\n"
               "\t\t\t\t\t\t\t\t\tmarkRedefinition(info.extend.superClass, name);",
        "new": "\t\t\t\t\t\t\t\tcase TFVar({name: name}) | TFFun({name: name}) | TFGetter({name: name}) | TFSetter({name: name}):\n"
               "\t\t\t\t\t\t\t\t\tmarkRedefinition(c, info.extend.superClass, name);",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteRedefinedPrivate.hx",
        "reason": "Register the mangled name against the subclass that redeclares the field.",
        "old": "\tfunction markRedefinition(superClass:TClassOrInterfaceDecl, name:String) {",
        "new": "\tfunction markRedefinition(subClass:TClassOrInterfaceDecl, "
               "superClass:TClassOrInterfaceDecl, name:String) {",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteRedefinedPrivate.hx",
        "reason": "Qualify the mangled name by the subclass, and register it there.",
        "old": "\t\tvar c = parentDefinition.declaringClass;",
        "new": "\t\tvar c = subClass;",
        "count": 1,
    },
    {
        "file": "src/ax3/Context.hx",
        "reason": "ax3 marks every rest argument it reads out of a SWC as TRestSwc, and the "
                  "RestArgs filter deliberately leaves those calls alone: a SWC rest function is "
                  "normally a Flash builtin whose Haxe counterpart really is variadic. "
                  "habbo-client.swc is not that -- it is the client's own AS3, which this "
                  "pipeline converts to a trailing `Array<ASAny>` parameter. A call that crossed "
                  "a closure boundary therefore resolved through the SWC and was left unwrapped, "
                  "so `appendAction(POSTURE, a, b)` compiled against `appendAction(String, "
                  "Array<ASAny>)`. This declares which SWCs hold AS3 the pipeline also converts.",
        "old": "\tvar swc:Array<String>;\n",
        "new": "\tvar swc:Array<String>;\n"
               "\t// SWCs holding AS3 that this pipeline also converts, so their rest\n"
               "\t// arguments behave like a source rest argument rather than a builtin's.\n"
               "\tvar ?as3Swc:Array<String>;\n",
        "count": 1,
    },
    {
        "file": "src/ax3/SWCLoader.hx",
        "reason": "Thread the declared AS3 SWCs through to the signature builder.",
        "old": "\tpublic static function load(tree:TypedTree, "
               "haxeTypes:DynamicAccess<HaxeTypeAnnotation>, files:Array<String>) {",
        "new": "\tvar restKind:TRestKind = TRestSwc;\n\n"
               "\tpublic static function load(tree:TypedTree, "
               "haxeTypes:DynamicAccess<HaxeTypeAnnotation>, files:Array<String>, "
               "?as3Swc:Array<String>) {",
        "count": 1,
    },
    {
        "file": "src/ax3/SWCLoader.hx",
        "reason": "Choose the rest kind per library, so only a declared AS3 SWC is treated as one.",
        "old": "\t\t\tvar swf = getLibrary(file);\n"
               "\t\t\tloader.processLibrary(file, swf);",
        "new": "\t\t\tvar swf = getLibrary(file);\n"
               "\t\t\tloader.restKind = "
               "if (as3Swc != null && as3Swc.indexOf(file) != -1) TRestAs3 else TRestSwc;\n"
               "\t\t\tloader.processLibrary(file, swf);",
        "count": 1,
    },
    {
        "file": "src/ax3/SWCLoader.hx",
        "reason": "Use the per-library rest kind when building a function signature.",
        "old": "\t\t\t\tkind: TArgRest(null, TRestSwc, null),",
        "new": "\t\t\t\tkind: TArgRest(null, restKind, null),",
        "count": 1,
    },
    {
        "file": "src/ax3/Main.hx",
        "reason": "Pass the declared AS3 SWCs to the loader.",
        "old": "\t\tSWCLoader.load(tree, config.haxeTypes, config.swc);",
        "new": "\t\tSWCLoader.load(tree, config.haxeTypes, config.swc, config.as3Swc);",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "E4X makes any field access on XML or XMLList itself an XMLList, so ax3 cannot "
                  "tell `list.length()` (a real method) from `list.child()` (an element query) "
                  "and refuses to type either as callable. Treating a call on XML/XMLList like a "
                  "call on TTAny lets both through with untyped arguments; the XML shim decides "
                  "what they mean at runtime.",
        "old": "\t\t\tcase TTVoid | TTBoolean | TTNumber | TTInt | TTUint | TTString | TTArray(_) "
               "| TTObject(_) | TTXML | TTXMLList | TTRegExp | TTVector(_) | TTInst(_) "
               "| TTDictionary(_):",
        "new": "\t\t\t// Patched for M2: XML and XMLList are callable in E4X. See "
               "build-support/generation/patch-converter.py\n"
               "\t\t\tcase TTVoid | TTBoolean | TTNumber | TTInt | TTUint | TTString | TTArray(_) "
               "| TTObject(_) | TTRegExp | TTVector(_) | TTInst(_) | TTDictionary(_):",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "and route them to the untyped-argument branch",
        "old": "\t\t\tcase TTAny | TTFunction:\n\t\t\t\t(i,earg) -> TTAny;",
        "new": "\t\t\tcase TTAny | TTFunction | TTXML | TTXMLList:\n\t\t\t\t(i,earg) -> TTAny;",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3's `parseInt(text, radix)` takes an optional radix; ax3 types it as a "
                  "one-argument function, so every hexadecimal or base-36 call is rejected as "
                  "'Invalid number of arguments'. Three of the five files blocking the whole "
                  "559-file parser tree fail on exactly this. Accept the trailing argument.",
        "old": '\t\t\tcase "parseInt":  mk(TEBuiltin(i, "parseInt"), TTFun([TTString], TTInt), '
               'expectedType);',
        "new": '\t\t\t// Patched for M2: AS3 parseInt accepts a radix. See build-support/generation/patch-converter.py\n'
               '\t\t\tcase "parseInt":  mk(TEBuiltin(i, "parseInt"), '
               'TTFun([TTString], TTInt, TRestSwc), expectedType);',
        "present": 'case "parseInt":  mk(TEBuiltin(i, "parseInt"), TTFun([TTString], TTInt, TRestSwc), expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "GenHaxe can only map an AS3 global after ExprTyper has classified it as a "
                  "builtin. Register isFinite and the three URI globals used by the corpus; "
                  "otherwise they remain unresolved local identifiers and bypass the mappings.",
        "old": '\t\t\tcase "isNaN": mk(TEBuiltin(i, "isNaN"), TTFun([TTNumber], TTBoolean), expectedType);',
        "new": '\t\t\tcase "isNaN": mk(TEBuiltin(i, "isNaN"), TTFun([TTNumber], TTBoolean), expectedType);\n'
               '\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n'
               '\t\t\tcase "isFinite": mk(TEBuiltin(i, "isFinite"), TTFun([TTNumber], TTBoolean), expectedType);\n'
               '\t\t\tcase "encodeURIComponent": mk(TEBuiltin(i, "encodeURIComponent"), TTFun([TTString], TTString), expectedType);\n'
               '\t\t\tcase "decodeURIComponent": mk(TEBuiltin(i, "decodeURIComponent"), TTFun([TTString], TTString), expectedType);\n'
               '\t\t\tcase "decodeURI": mk(TEBuiltin(i, "decodeURI"), TTFun([TTString], TTString), expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/Scanner.hx",
        "reason": "The string lexer accepts only t n r backslash slash quote apostrophe and u. AS3 "
                  "also allows \\x with two hex digits, which is what the vendored Adobe JSON "
                  "library needs -- and what a pre-rule must rewrite \\f into, since Haxe has no "
                  "\\f either. Without this the escape is rejected before any rule can help.",
        "old": '\t\t\tcase "u".code:',
        "new": '\t\t\tcase "x".code:\n'
               '\t\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n'
               '\t\t\t\tfor (_ in 0...2) {\n'
               '\t\t\t\t\tif (pos >= end) {\n'
               '\t\t\t\t\t\tthrow "Unterminated hex character sequence at " + start;\n'
               '\t\t\t\t\t}\n'
               '\t\t\t\t\tch = text.fastCodeAt(pos);\n'
               '\t\t\t\t\tif (!isHexDigit(ch)) {\n'
               '\t\t\t\t\t\tthrow "Invalid hex character sequence at " + start;\n'
               '\t\t\t\t\t}\n'
               '\t\t\t\t\tpos++;\n'
               '\t\t\t\t}\n'
               '\t\t\tcase "u".code:',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "AS3 gives a class with no declared constructor an implicit one; Haxe does not, "
                  "so `new ObjectDataParser()` fails to compile against generated output. Emit a "
                  "default constructor when the class declares none. A subclass must call super() "
                  "or Haxe rejects it, so the extends case is handled separately.",
        "old": "\t\tif (staticInits.length > 0) {\n"
               "\t\t\tbuf.add(\"\\n\\tstatic final ___init = {\\n\");",
        "new": "\t\t// Patched for M2: see build-support/generation/patch-converter.py\n"
               "\t\tvar hasCtor = false;\n"
               "\t\tfor (m in c.members) {\n"
               "\t\t\tswitch (m) {\n"
               "\t\t\t\tcase TMField({kind: TFFun(f)}) if (f.name == c.name): hasCtor = true;\n"
               "\t\t\t\tcase _:\n"
               "\t\t\t}\n"
               "\t\t}\n"
               "\t\tif (!hasCtor) {\n"
               "\t\t\tbuf.add(if (info.extend != null) \"\\n\\tpublic function new() { super(); }\\n\""
               " else \"\\n\\tpublic function new() {}\\n\");\n"
               "\t\t}\n\n"
               "\t\tif (staticInits.length > 0) {\n"
               "\t\t\tbuf.add(\"\\n\\tstatic final ___init = {\\n\");",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "ax3 maps some AS3 top-level functions and passes the rest through verbatim, so "
                  "`isFinite` and the URI globals reach Haxe as unknown identifiers. The corpus "
                  "uses isFinite in 3 files, encodeURIComponent in 3, decodeURIComponent in 1 and "
                  "decodeURI in 1; Infinity and encodeURI are unused.",
        "old": '\t\t\tcase "isNaN": "Math.isNaN";',
        "new": '\t\t\tcase "isNaN": "Math.isNaN";\n'
               '\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n'
               '\t\t\tcase "isFinite": "Math.isFinite";\n'
               '\t\t\tcase "encodeURIComponent": "ASCompat.encodeURIComponent";\n'
               '\t\t\tcase "decodeURIComponent": "ASCompat.decodeURIComponent";\n'
               '\t\t\tcase "decodeURI": "ASCompat.decodeURI";',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "and back the URI mappings above with host calls. Haxe's StringTools.urlEncode "
                  "and urlDecode are not equivalent: they percent-escape characters that "
                  "encodeURIComponent leaves alone, which would change the bytes the client puts "
                  "on the wire.",
        "old": "\t/**\n\t\tAS3's global `parseInt(text, radix)`.",
        "new": "\t/*\n"
               "\t\tAS3's URI globals. Haxe's StringTools.urlEncode/urlDecode are not equivalent "
               "-- they\n"
               "\t\tpercent-escape characters (`!`, `~`, `*`, `'`) that encodeURIComponent leaves "
               "alone, which\n"
               "\t\twould change the bytes the client puts on the wire. Call the host functions "
               "instead, the\n"
               "\t\tsame way escape/unescape above do.\n"
               "\t*/\n"
               "\tpublic static inline function encodeURIComponent(s:String):String {\n"
               "\t\t#if flash\n"
               "\t\treturn untyped __global__[\"encodeURIComponent\"](s);\n"
               "\t\t#else\n"
               "\t\treturn js.Lib.global.encodeURIComponent(s);\n"
               "\t\t#end\n"
               "\t}\n\n"
               "\tpublic static inline function decodeURIComponent(s:String):String {\n"
               "\t\t#if flash\n"
               "\t\treturn untyped __global__[\"decodeURIComponent\"](s);\n"
               "\t\t#else\n"
               "\t\treturn js.Lib.global.decodeURIComponent(s);\n"
               "\t\t#end\n"
               "\t}\n\n"
               "\tpublic static inline function decodeURI(s:String):String {\n"
               "\t\t#if flash\n"
               "\t\treturn untyped __global__[\"decodeURI\"](s);\n"
               "\t\t#else\n"
               "\t\treturn js.Lib.global.decodeURI(s);\n"
               "\t\t#end\n"
               "\t}\n\n"
               "\t/**\n\t\tAS3's global `parseInt(text, radix)`.",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/AddSuperCtorCall.hx",
        "reason": "the filter refuses to insert super() when the base class declares no "
                  "constructor, which was right for stock ax3 -- there was nothing to call. Once "
                  "GenHaxe emits a default constructor for every class (patch above) there always "
                  "is, and Haxe rejects a subclass constructor that does not call it: "
                  "'Missing super constructor call'. AS3 already guarantees the call is valid, "
                  "since an implicit constructor calls super() with no arguments and the source "
                  "compiled, so the base constructor must be callable with none.",
        "old": "\t\tif (getConstructor(superClass) == null || hasSuperCall(e)) {",
        "new": "\t\t// Patched for M2: see build-support/generation/patch-converter.py\n"
               "\t\tif (hasSuperCall(e)) {",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "and emit it through the compat layer, because Std.parseInt has no radix "
                  "parameter -- mapping it directly would compile only for base 10 and silently "
                  "misread every colour and height-map value.",
        "old": '\t\t\tcase "parseInt": "Std.parseInt";',
        "new": '\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n'
               '\t\t\tcase "parseInt": "ASCompat.parseInt";',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "typeCallArgs now accepts the call, but the result type still falls through to "
                  "`unknown callable type`. Resolve it from the method name: E4X's own methods "
                  "have real return types and typing them all as XMLList is wrong -- `length()` "
                  "is an int and `toString()` is a String. Only an unrecognised name is an "
                  "element query, and only that yields XMLList.",
        "old": "\t\t\tcase _:\n\t\t\t\terr(\"unknown callable type: \" + eobj.type, exprPos(e));\n"
               "\t\t\t\ttype = TTAny;",
        "legacy": "\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n"
               "\t\t\tcase {kind: TEField(_, fieldName, _), type: TTXML | TTXMLList}:\n"
               "\t\t\t\ttype = switch fieldName {\n"
               "\t\t\t\t\tcase \"length\" | \"childIndex\": TTInt;\n"
               "\t\t\t\t\tcase \"toString\" | \"toXMLString\" | \"localName\" | \"nodeKind\": TTString;\n"
               "\t\t\t\t\tcase \"hasOwnProperty\" | \"hasSimpleContent\" | \"hasComplexContent\"\n"
               "\t\t\t\t\t\t| \"contains\" | \"propertyIsEnumerable\": TTBoolean;\n"
               "\t\t\t\t\tcase \"name\" | \"namespace\" | \"valueOf\": TTAny;\n"
               "\t\t\t\t\t// Everything else is an element/attribute query, which is the one\n"
               "\t\t\t\t\t// case that genuinely produces an XMLList.\n"
               "\t\t\t\t\tcase _: TTXMLList;\n"
               "\t\t\t\t}\n\n"
               "\t\t\tcase {type: TTXML} | {type: TTXMLList}:\n"
               "\t\t\t\t// Callee is XML but not a plain field access; the shim decides at runtime.\n"
               "\t\t\t\ttype = TTAny;\n\n"
               "\t\t\tcase _:\n\t\t\t\terr(\"unknown callable type: \" + eobj.type, exprPos(e));\n"
               "\t\t\t\ttype = TTAny;",
        "new": "\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n"
               "\t\t\tcase {kind: TEField(_, fieldName, _), type: TTXML | TTXMLList}:\n"
               "\t\t\t\ttype = switch fieldName {\n"
               "\t\t\t\t\tcase \"length\" | \"childIndex\": TTInt;\n"
               "\t\t\t\t\tcase \"toString\" | \"toXMLString\" | \"localName\" | \"nodeKind\": TTString;\n"
               "\t\t\t\t\tcase \"hasOwnProperty\" | \"hasSimpleContent\" | \"hasComplexContent\"\n"
               "\t\t\t\t\t\t| \"contains\" | \"propertyIsEnumerable\": TTBoolean;\n"
               "\t\t\t\t\tcase \"name\" | \"namespace\" | \"valueOf\": TTAny;\n"
               "\t\t\t\t\tcase \"attribute\" | \"attributes\" | \"child\" | \"children\"\n"
               "\t\t\t\t\t\t| \"comments\" | \"descendants\" | \"elements\"\n"
               "\t\t\t\t\t\t| \"processingInstructions\" | \"text\": TTXMLList;\n"
               "\t\t\t\t\t// Mutators and ambiguous methods differ between XML and XMLList.\n"
               "\t\t\t\t\t// TTAny is honest and lets the compatibility shim retain runtime semantics;\n"
               "\t\t\t\t\t// pretending appendChild/copy/parent/replace return XMLList is wrong.\n"
               "\t\t\t\t\tcase _: TTAny;\n"
               "\t\t\t\t}\n\n"
               "\t\t\tcase {type: TTXML} | {type: TTXMLList}:\n"
               "\t\t\t\t// Callee is XML but not a plain field access; the shim decides at runtime.\n"
               "\t\t\t\ttype = TTAny;\n\n"
               "\t\t\tcase _:\n\t\t\t\terr(\"unknown callable type: \" + eobj.type, exprPos(e));\n"
               "\t\t\t\ttype = TTAny;",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "recognize the explicit form used by the guarded E4X predicate normalization; "
                  "otherwise ax3 mistakes it for a child element named filterAttributeEquals",
        "present": 'case "filterAttributeEquals": TTFun([TTString, TTString], TTXMLList);',
        "old": "\t\t\tcase \"attribute\": TTFun([], TTString);\n"
               "\t\t\tcase \"length\": TTFun([], TTInt);",
        "new": "\t\t\tcase \"attribute\": TTFun([], TTString);\n"
               "\t\t\tcase \"filterAttributeEquals\": TTFun([TTString, TTString], TTXMLList);\n"
               "\t\t\tcase \"length\": TTFun([], TTInt);",
        "count": 1,
    },
    {
        "file": "compat/compat/XMLList.hx",
        "reason": "runtime half of the guarded E4X predicate normalization",
        "old": "\tpublic function child(name:String):XMLList {\n"
               "\t\t#if flash\n"
               "\t\treturn this.child(name);\n"
               "\t\t#else\n"
               "\t\treturn [for (x in this) for (child in (x : StdXml).elementsNamed(name)) child];\n"
               "\t\t#end\n"
               "\t}\n",
        "new": "\tpublic function child(name:String):XMLList {\n"
               "\t\t#if flash\n"
               "\t\treturn this.child(name);\n"
               "\t\t#else\n"
               "\t\treturn [for (x in this) for (child in (x : StdXml).elementsNamed(name)) child];\n"
               "\t\t#end\n"
               "\t}\n\n"
               "\tpublic function filterAttributeEquals(name:String, value:String):XMLList {\n"
               "\t\t#if flash\n"
               "\t\treturn [for (x in new std.NativeValueIterator<XML>(this))\n"
               "\t\t\tif (x.attribute(name).toString() == value) x];\n"
               "\t\t#else\n"
               "\t\treturn [for (x in this) if ((x : StdXml).get(name) == value) x];\n"
               "\t\t#end\n"
               "\t}\n",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteAs.hx",
        "reason": "AS3 permits checked `as XML`/`as XMLList` casts. After the adjacent `is` "
                  "guard, Haxe only needs the expression retyped to the compatibility abstract",
        "old": "\t\t\t\t\tcase TTFunction:\n"
               "\t\t\t\t\t\tvar eAsFunctionMethod = mkBuiltin(\"ASCompat.asFunction\", TTFunction, removeLeadingTrivia(e));",
        "new": "\t\t\t\t\tcase TTXML | TTXMLList:\n"
               "\t\t\t\t\t\te.with(kind = TEHaxeRetype(eobj));\n\n"
               "\t\t\t\t\tcase TTFunction:\n"
               "\t\t\t\t\t\tvar eAsFunctionMethod = mkBuiltin(\"ASCompat.asFunction\", TTFunction, removeLeadingTrivia(e));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteForIn.hx",
        "reason": "the clean client's Proxy-backed Map exposes AS3 enumeration through getKeys; "
                  "Haxe must call that explicit API for `for (key in map)`",
        "old": "\t\t\t\tloopVarType = TTInt;\n\n"
               "\t\t\tcase other:\n"
               "\t\t\t\tthrowError(exprPos(f.iter.eobj), \"Unsupported iteratee type: \" + other);\n"
               "\t\t}\n"
               "\t\treturn {\n"
               "\t\t\toriginalExpr: f.iter.eobj,",
        "new": "\t\t\t\tloopVarType = TTInt;\n\n"
               "\t\t\tcase TTInst({name: \"Map\", parentModule: {parentPack: {name: \"com.sulake.core.utils\"}}}):\n"
               "\t\t\t\teobj = mkIteratorMethodCallExpr(eobj, \"getKeys\");\n"
               "\t\t\t\tloopVarType = TTAny;\n\n"
               "\t\t\tcase other:\n"
               "\t\t\t\tthrowError(exprPos(f.iter.eobj), \"Unsupported iteratee type: \" + other);\n"
               "\t\t}\n"
               "\t\treturn {\n"
               "\t\t\toriginalExpr: f.iter.eobj,",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "OpenFL 9.5.2's Vector is an abstract and has no static isVector method. "
                  "The JS representation is an Array carrying the VectorData `fixed` marker; "
                  "use a target-neutral structural check so generated AS3 `as`/`is Vector` "
                  "support compiles without patching generated files.",
        "old": "\t@:noCompletion public static inline function _asVector<T>(value:Any):Null<flash.Vector<T>> return if (openfl.Vector.isVector(value)) value else null;\n"
               "\t@:noCompletion public static inline function _isVector(value:Any):Bool return openfl.Vector.isVector(value);",
        "new": "\t// Patched for OpenFL 9.5.2: Vector is an abstract, not a runtime class with isVector.\n"
               "\t@:noCompletion public static inline function _asVector<T>(value:Any):Null<flash.Vector<T>> return if (_isVector(value)) cast value else null;\n"
               "\t@:noCompletion public static inline function _isVector(value:Any):Bool return value != null && Reflect.hasField(value, \"fixed\") && Reflect.hasField(value, \"length\") && Reflect.hasField(value, \"push\");",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "AS3 has a global Error class but Haxe does not. Defining global Error shadows "
                  "the compiler/OpenFL error type and breaks unrelated framework code. Emit the "
                  "isolated ASError compatibility boundary whenever the resolved SWC declaration "
                  "is the root Error type. The same type-output boundary routes flash.utils."
                  "ByteArray through SkyHaxe's big-endian adapter.",
        "old": "\tinline function getClassLocalPath(cls:TClassOrInterfaceDecl):String {\n"
               "\t\treturn if (currentModule.isImported(cls)) cls.name else makeFQN(cls);\n"
               "\t}",
        "new": "\tinline function getClassLocalPath(cls:TClassOrInterfaceDecl):String {\n"
               "\t\t// Patched for M2: never introduce a global Haxe `Error` type.\n"
               "\t\tif (cls.name == \"Error\" && cls.parentModule.parentPack.name == \"\") return \"ASError\";\n"
               "\t\tif (cls.name == \"ByteArray\" && cls.parentModule.parentPack.name == \"flash.utils\") return \"com.sulake.core.utils.ByteArray\";\n"
               "\t\treturn if (currentModule.isImported(cls)) cls.name else makeFQN(cls);\n"
               "\t}",
        "present": 'if (cls.name == "ByteArray" && cls.parentModule.parentPack.name == "flash.utils") return "com.sulake.core.utils.ByteArray";',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Class heritage is printed from the original syntax path instead of through "
                  "getClassLocalPath, so the root Error mapping also has to cover `extends Error`.",
        "old": "\t\tif (info.extend != null) {\n"
               "\t\t\tprintTextWithTrivia(\"extends\", info.extend.syntax.keyword);\n"
               "\t\t\tprintDotPath(info.extend.syntax.path);\n"
               "\t\t}",
        "new": "\t\tif (info.extend != null) {\n"
               "\t\t\tprintTextWithTrivia(\"extends\", info.extend.syntax.keyword);\n"
               "\t\t\tvar superClass = info.extend.superClass;\n"
               "\t\t\tif (superClass.name == \"Error\" && superClass.parentModule.parentPack.name == \"\")\n"
               "\t\t\t\tprintTextWithTrivia(\"ASError\", info.extend.syntax.path.first);\n"
               "\t\t\telse\n"
               "\t\t\t\tprintDotPath(info.extend.syntax.path);\n"
               "\t\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteIs.hx",
        "reason": "OpenFL ByteArray and compat.XML are abstracts on HTML5 and cannot be supplied "
                  "as class values to Std.is; use compatibility checks against their concrete "
                  "underlying representations",
        "old": "\t\t\t\t\tcase _:\n"
               "\t\t\t\t\t\tfinal stdIs = mkBuiltin(\"Std.is\", tStdIs, removeLeadingTrivia(e));",
        "new": "\t\t\t\t\tcase TEBuiltin(_, \"XML\"):\n"
               "\t\t\t\t\t\tfinal isXML = mkBuiltin(\"ASCompat.isXML\", tIsFunction, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(isXML, {\n"
               "\t\t\t\t\t\t\topenParen: mkOpenParen(),\n"
               "\t\t\t\t\t\t\targs: [{expr: a, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e)),\n"
               "\t\t\t\t\t\t}));\n\n"
               "\t\t\t\t\tcase TEDeclRef(_, {kind: TDClassOrInterface({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}})}):\n"
               "\t\t\t\t\t\tfinal isByteArray = mkBuiltin(\"ASCompat.isByteArray\", tIsFunction, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(isByteArray, {\n"
               "\t\t\t\t\t\t\topenParen: mkOpenParen(),\n"
               "\t\t\t\t\t\t\targs: [{expr: a, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e)),\n"
               "\t\t\t\t\t\t}));\n\n"
               "\t\t\t\t\tcase _:\n"
               "\t\t\t\t\t\tfinal stdIs = mkBuiltin(\"Std.is\", tStdIs, removeLeadingTrivia(e));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteAs.hx",
        "reason": "OpenFL ByteArray is an abstract on HTML5 and cannot be supplied to "
                  "ASCompat.dynamicAs; emit the structural ByteArray compatibility cast",
        "old": "\t\t\t\t\tcase TTInst(cls):\n"
               "\t\t\t\t\t\tvar path = switch (typeRef.syntax) {",
        "new": "\t\t\t\t\tcase TTInst({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}}):\n"
               "\t\t\t\t\t\tvar asByteArray = mkBuiltin(\"ASCompat.asByteArray\", TTFunction, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(asByteArray, {\n"
               "\t\t\t\t\t\t\topenParen: mkOpenParen(),\n"
               "\t\t\t\t\t\t\targs: [{expr: eobj, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))\n"
               "\t\t\t\t\t\t}));\n\n"
               "\t\t\t\t\tcase TTInst(cls):\n"
               "\t\t\t\t\t\tvar path = switch (typeRef.syntax) {",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "runtime half of the type-aware XML/ByteArray `is` and ByteArray `as` rewrites",
        "old": "\t@:noCompletion public static inline function _isVector(value:Any):Bool return value != null && Reflect.hasField(value, \"fixed\") && Reflect.hasField(value, \"length\") && Reflect.hasField(value, \"push\");\n\t#end",
        "legacy": "\t@:noCompletion public static inline function _isVector(value:Any):Bool return value != null && Reflect.hasField(value, \"fixed\") && Reflect.hasField(value, \"length\") && Reflect.hasField(value, \"push\");\n\n"
                  "\tpublic static inline function isByteArray(value:Any):Bool return Std.isOfType(value, openfl.utils.ByteArray.ByteArrayData);\n"
                  "\tpublic static inline function asByteArray(value:Any):Null<com.sulake.core.utils.ByteArray> return isByteArray(value) ? cast value : null;\n"
                  "\t#end",
        "new": "\t@:noCompletion public static inline function _isVector(value:Any):Bool return value != null && Reflect.hasField(value, \"fixed\") && Reflect.hasField(value, \"length\") && Reflect.hasField(value, \"push\");\n\n"
               "\t// Patched for M2: AS3 `is XML` must recognise the XML the port actually carries.\n"
               "\t//\n"
               "\t// Converted code never holds a haxe.Xml -- RewriteE4X rewrites every AS3 XML expression onto\n"
               "\t// com.sulake.core.utils.xml.XML, the E4X shim. Testing only haxe.Xml therefore made `is XML`\n"
               "\t// answer false for every value the client can produce, and XMLValidator's sole type test is\n"
               "\t// this one: checkRequiredAttributes fell through to its XMLList branch, found no match, and\n"
               "\t// returned false for documents whose attributes were all present. That is a silent no --\n"
               "\t// RoomVisualization drops a whole room's planes on it without an error.\n"
               "\tpublic static inline function isXML(value:Any):Bool\n"
               "\t\treturn Std.isOfType(value, Xml) || Std.isOfType(value, com.sulake.core.utils.xml.XML);\n"
               "\tpublic static inline function isByteArray(value:Any):Bool return Std.isOfType(value, openfl.utils.ByteArray.ByteArrayData);\n"
               "\tpublic static inline function asByteArray(value:Any):Null<com.sulake.core.utils.ByteArray> return isByteArray(value) ? cast value : null;\n"
               "\t#end",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "AS3 uint coercion is not int coercion. Decimal constants above signed-int "
                  "range become Float literals in Haxe unless the explicit uint cast survives; "
                  "the JS unsigned shift preserves the original modulo-2^32 value.",
        "old": "\tpublic static inline function toInt(d:Dynamic):Int {\n"
               "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
               "\t\treturn Std.int(toNumber(d));\n\t\t#end\n\t}",
        # The emitted fragment must carry its own parentheses. `toUInt` is inline and its body is a
        # js.Syntax.code string, which Haxe prints verbatim -- it cannot parenthesise an opaque
        # fragment the way it would a real expression. Unparenthesised, the converted
        # `ASCompat.toUInt(k) - 1` printed as `Number(k) >>> 0 - 1`, and JS binds `-` tighter than
        # `>>>`, making that `k >>> -1` -- i.e. `k >>> 31`, which is 0 for every index in range.
        # Every window iterator's `nextValue` therefore returned child 0 forever. The friend bar is
        # what surfaced it: its layout packs children by iterating the container, so it stacked the
        # first child five times, set a 750px width against 526px of available space and pushed its
        # own expand arrow 585px off the desktop. ContainerIterator, DropListIterator,
        # ItemGridIterator, ItemListIterator and SelectorIterator all share the defect, so every
        # converted `for each` over a window collection was affected.
        "legacy": "\tpublic static inline function toInt(d:Dynamic):Int {\n"
                  "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
                  "\t\treturn Std.int(toNumber(d));\n\t\t#end\n\t}\n\n"
                  "\t// uint(d). Keep this distinct from int(d): Haxe parses decimal literals above 0x7fffffff as\n"
                  "\t// Float, while AS3 coerces them modulo 2^32. The JS bitwise conversion preserves those bits.\n"
                  "\tpublic static inline function toUInt(d:Dynamic):UInt {\n"
                  "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
                  "\t\treturn cast (js.Syntax.code(\"Number({0}) >>> 0\", d));\n"
                  "\t\t#end\n\t}",
        "new": "\tpublic static inline function toInt(d:Dynamic):Int {\n"
               "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
               "\t\treturn Std.int(toNumber(d));\n\t\t#end\n\t}\n\n"
               "\t// uint(d). Keep this distinct from int(d): Haxe parses decimal literals above 0x7fffffff as\n"
               "\t// Float, while AS3 coerces them modulo 2^32. The JS bitwise conversion preserves those bits.\n"
               "\t// The parentheses are part of the emitted fragment on purpose: this body is inlined, and\n"
               "\t// js.Syntax.code is printed verbatim, so without them a surrounding operator binds wrong.\n"
               "\tpublic static inline function toUInt(d:Dynamic):UInt {\n"
               "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
               "\t\treturn cast (js.Syntax.code(\"(Number({0}) >>> 0)\", d));\n"
               "\t\t#end\n\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "give RewriteCasts a correctly typed runtime helper for uint coercions",
        "old": "\tstatic final tToInt = TTFun([TTAny], TTInt);",
        "new": "\tstatic final tToInt = TTFun([TTAny], TTInt);\n"
               "\tstatic final tToUInt = TTFun([TTAny], TTUint);",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "preserve uint(Number) and uint(int) instead of stripping their unsigned coercion",
        "old": "\t\t\t\t\tcase [TTNumber, TTInt | TTUint]:\n"
               "\t\t\t\t\t\tvar stdInt = mkBuiltin(\"Std.int\", tStdInt, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(stdInt, {\n"
               "\t\t\t\t\t\t\topenParen: syntax.openParen,\n"
               "\t\t\t\t\t\t\targs: [{expr: expr, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: syntax.closeParen\n"
               "\t\t\t\t\t\t}));",
        "new": "\t\t\t\t\tcase [TTNumber, TTInt]:\n"
               "\t\t\t\t\t\tvar stdInt = mkBuiltin(\"Std.int\", tStdInt, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(stdInt, {\n"
               "\t\t\t\t\t\t\topenParen: syntax.openParen,\n"
               "\t\t\t\t\t\t\targs: [{expr: expr, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: syntax.closeParen\n"
               "\t\t\t\t\t\t}));\n\n"
               "\t\t\t\t\t// uint(number), and uint(int). Keeping this coercion is observable for decimal\n"
               "\t\t\t\t\t// literals above 0x7fffffff: Haxe types those as Float, whereas AS3 wraps them\n"
               "\t\t\t\t\t// into the unsigned 32-bit domain.\n"
               "\t\t\t\t\tcase [TTNumber | TTInt, TTUint]:\n"
               "\t\t\t\t\t\tvar toUInt = mkBuiltin(\"ASCompat.toUInt\", tToUInt, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(toUInt, {\n"
               "\t\t\t\t\t\t\topenParen: syntax.openParen,\n"
               "\t\t\t\t\t\t\targs: [{expr: expr, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: syntax.closeParen\n"
               "\t\t\t\t\t\t}));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "only erase a numeric cast when it does not cross the signed/unsigned boundary",
        "old": "\t\t\t\t\tcase [TTInt | TTUint, TTInt | TTUint]:",
        "new": "\t\t\t\t\tcase [TTInt, TTInt] | [TTUint, TTUint] | [TTUint, TTInt]:",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "route non-numeric uint casts through the unsigned helper as well",
        "old": "\t\t\t\t\t\tvar eCastMethod = mkBuiltin(\"ASCompat.toInt\", tToInt, removeLeadingTrivia(e));",
        "new": "\t\t\t\t\t\tvar methodName = castType == TTUint ? \"ASCompat.toUInt\" : \"ASCompat.toInt\";\n"
               "\t\t\t\t\t\tvar methodType = castType == TTUint ? tToUInt : tToInt;\n"
               "\t\t\t\t\t\tvar eCastMethod = mkBuiltin(methodName, methodType, removeLeadingTrivia(e));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteCasts.hx",
        "reason": "retain an explicit uint coercion when expected-type propagation has already "
                  "labelled its decimal literal UInt; large decimal literals are still Floats in Haxe",
        "old": "\t\t\t\t\t// int(already an int)\n"
               "\t\t\t\t\tcase [TTInt, TTInt] | [TTUint, TTUint] | [TTUint, TTInt]:\n"
               "\t\t\t\t\t\tstripCast();",
        "new": "\t\t\t\t\t// The typer can propagate the outer uint expectation into a literal before this\n"
               "\t\t\t\t\t// filter runs.  Do not then erase the explicit AS3 coercion: decimal literals\n"
               "\t\t\t\t\t// above 0x7fffffff are Floats in Haxe source and need a real uint conversion.\n"
               "\t\t\t\t\tcase [TTUint, TTUint] if (expr.kind.match(TELiteral(TLInt(_)))):\n"
               "\t\t\t\t\t\tvar toUInt = mkBuiltin(\"ASCompat.toUInt\", tToUInt, removeLeadingTrivia(e));\n"
               "\t\t\t\t\t\te.with(kind = TECall(toUInt, {\n"
               "\t\t\t\t\t\t\topenParen: syntax.openParen,\n"
               "\t\t\t\t\t\t\targs: [{expr: expr, comma: null}],\n"
               "\t\t\t\t\t\t\tcloseParen: syntax.closeParen\n"
               "\t\t\t\t\t\t}));\n\n"
               "\t\t\t\t\t// int(already an int)\n"
               "\t\t\t\t\tcase [TTInt, TTInt] | [TTUint, TTUint] | [TTUint, TTInt]:\n"
               "\t\t\t\t\t\tstripCast();",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "emit large decimal literals through AS3 uint coercion when their expected "
                  "type is UInt; Haxe otherwise parses them as Float",
        "old": "\t\t\tcase TELiteral(l): printLiteral(l);",
        "new": "\t\t\tcase TELiteral(l): printLiteral(l, e.expectedType);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "implement expected-UInt large-decimal emission without changing Number literals",
        "present": "function printLiteral(l:TLiteral, expectedType:TType)",
        "old": "\tfunction printLiteral(l:TLiteral) {\n"
               "\t\tswitch (l) {\n"
               "\t\t\tcase TLSuper(syntax): printTextWithTrivia(\"super\", syntax);\n"
               "\t\t\tcase TLThis(syntax): printTextWithTrivia(\"this\", syntax);\n"
               "\t\t\tcase TLBool(syntax): printTextWithTrivia(syntax.text, syntax);\n"
               "\t\t\tcase TLNull(syntax): printTextWithTrivia(\"null\", syntax);\n"
               "\t\t\tcase TLUndefined(syntax): printTextWithTrivia(\"/*undefined*/null\", syntax);\n"
               "\t\t\tcase TLInt(syntax): printTextWithTrivia(syntax.text, syntax);",
        "new": "\tfunction printLiteral(l:TLiteral, expectedType:TType) {\n"
               "\t\tswitch (l) {\n"
               "\t\t\tcase TLSuper(syntax): printTextWithTrivia(\"super\", syntax);\n"
               "\t\t\tcase TLThis(syntax): printTextWithTrivia(\"this\", syntax);\n"
               "\t\t\tcase TLBool(syntax): printTextWithTrivia(syntax.text, syntax);\n"
               "\t\t\tcase TLNull(syntax): printTextWithTrivia(\"null\", syntax);\n"
               "\t\t\tcase TLUndefined(syntax): printTextWithTrivia(\"/*undefined*/null\", syntax);\n"
               "\t\t\tcase TLInt(syntax):\n"
               "\t\t\t\t// Haxe parses decimal integers above the signed 32-bit range as Float. AS3\n"
               "\t\t\t\t// still permits them wherever a uint is expected (CRC tables are a common\n"
               "\t\t\t\t// example), so preserve that coercion explicitly at the output boundary.\n"
               "\t\t\t\tvar decimal = ~/^[0-9]+$/;\n"
               "\t\t\t\tif (expectedType.match(TTUint) && decimal.match(syntax.text)\n"
               "\t\t\t\t\t&& Std.parseFloat(syntax.text) > 2147483647.0) {\n"
               "\t\t\t\t\tprintTrivia(syntax.leadTrivia);\n"
               "\t\t\t\t\tbuf.add(\"ASCompat.toUInt(\" + syntax.text + \")\");\n"
               "\t\t\t\t\tprintTrivia(syntax.trailTrivia);\n"
               "\t\t\t\t} else {\n"
               "\t\t\t\t\tprintTextWithTrivia(syntax.text, syntax);\n"
               "\t\t\t\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "preserve the identity of the AS3 uint builtin so RewriteCasts can apply "
                  "unsigned rather than signed coercion semantics",
        "old": "\t\t\tcase \"uint\": mk(TEBuiltin(i, \"int\"), TTBuiltin, expectedType);",
        "new": "\t\t\tcase \"uint\": mk(TEBuiltin(i, \"uint\"), TTBuiltin, expectedType);",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3 permits the default clause anywhere in a switch. ax3 already stores "
                  "the default separately and GenHaxe emits it in Haxe's required final "
                  "position, so rejecting a later case discards valid client code.",
        "old": "\t\t\t\tcase CCase(keyword, v, colon, body):\n"
               "\t\t\t\t\tif (def != null) throwErr(\"`case` after `default` in switch\", keyword.pos);\n"
               "\t\t\t\t\ttcases.push({",
        "new": "\t\t\t\tcase CCase(keyword, v, colon, body):\n"
               "\t\t\t\t\t// AS3 allows default before case. `def` is stored separately and the Haxe\n"
               "\t\t\t\t\t// generator emits it last, so source order does not need rejecting here.\n"
               "\t\t\t\t\ttcases.push({",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteSwitch.hx",
        "reason": "A final AS3 case needs no break when the source default clause appeared "
                  "earlier: execution reaches the end of the switch, not the earlier default. "
                  "ax3 stores default separately, so its former check mistook that valid case "
                  "for fall-through into a trailing default.",
        "present": 'var defaultBeforeCase = s.def != null',
        "old": "\t\t\t\t\t\tvar isLast = (i == s.cases.length - 1) && s.def == null;\n\n"
               "\t\t\t\t\t\tvar breakTrivia = processCaseBody(c.body, isLast);",
        "new": "\t\t\t\t\t\t// AS3 permits default anywhere. A final case after the source default reaches\n"
               "\t\t\t\t\t\t// the end of the switch and is terminal even though `def` is non-null here.\n"
               "\t\t\t\t\t\tvar defaultBeforeCase = s.def != null\n"
               "\t\t\t\t\t\t\t&& s.def.syntax.keyword.pos < c.syntax.keyword.pos;\n"
               "\t\t\t\t\t\tvar isLast = i == s.cases.length - 1\n"
               "\t\t\t\t\t\t\t&& (s.def == null || defaultBeforeCase);\n\n"
               "\t\t\t\t\t\tvar breakTrivia = processCaseBody(c.body, isLast);",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/StringApi.hx",
        "reason": "AS3 String.split accepts an optional result limit. Haxe String.split has no "
                  "limit argument, so route the two-argument form through the compatibility "
                  "runtime instead of rejecting otherwise valid client source.",
        "old": "\tstatic final tSplitMethod = TTFun([TTString], TTArray(TTString));",
        "new": "\tstatic final tSplitMethod = TTFun([TTString], TTArray(TTString));\n"
               "\tstatic final tSplitLimitMethod = TTFun([TTString, TTString, TTInt], TTArray(TTString));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/StringApi.hx",
        "reason": "lower AS3 String.split(separator, limit) to the compatibility helper while "
                  "preserving the receiver and both arguments",
        "old": "\t\t\t\t\tcase [{expr: {type: TTString}}]:\n"
               "\t\t\t\t\t\teMethod = eMethod.with(kind = TEField({kind: TOExplicit(dot, processExpr(eString)), type: TTString}, \"split\", fieldToken));\n"
               "\t\t\t\t\t\te.with(kind = TECall(eMethod, args));\n\n"
               "\t\t\t\t\tcase _:",
        "new": "\t\t\t\t\tcase [{expr: {type: TTString}}]:\n"
               "\t\t\t\t\t\teMethod = eMethod.with(kind = TEField({kind: TOExplicit(dot, processExpr(eString)), type: TTString}, \"split\", fieldToken));\n"
               "\t\t\t\t\t\te.with(kind = TECall(eMethod, args));\n\n"
               "\t\t\t\t\tcase [ePattern = {expr: {type: TTString}}, eLimit = {expr: {type: TTInt}}]:\n"
               "\t\t\t\t\t\teString = processExpr(eString);\n"
               "\t\t\t\t\t\tvar eSplitMethod = mkBuiltin(\"ASCompat.stringSplit\", tSplitLimitMethod, removeLeadingTrivia(eString));\n"
               "\t\t\t\t\t\te.with(kind = TECall(eSplitMethod, args.with(args = [\n"
               "\t\t\t\t\t\t\t{expr: eString, comma: commaWithSpace}, ePattern, eLimit\n"
               "\t\t\t\t\t\t])));\n\n"
               "\t\t\t\t\tcase _:",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "implement the optional result-limit semantics missing from Haxe's "
                  "String.split API; this is the target of StringApi's generated lowering",
        "old": "\tpublic static inline function unescape(s:String):String {",
        "new": "\t/** AS3 String.split(separator, limit); Haxe's String.split omits `limit`. */\n"
               "\tpublic static function stringSplit(s:String, delimiter:String, limit:Int):Array<String> {\n"
               "\t\tif (limit == 0) return [];\n"
               "\t\tvar parts = s.split(delimiter);\n"
               "\t\treturn limit < 0 || parts.length <= limit ? parts : parts.slice(0, limit);\n"
               "\t}\n\n"
               "\tpublic static inline function unescape(s:String):String {",
        "present": "\tpublic static function stringSplit(s:String, delimiter:String, limit:Int):Array<String> {",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "ExprTyper recognises both legacy AS3 URI globals, but GenHaxe only knew how "
                  "to print escape and emitted it as a nonexistent Haxe global. Route escape and "
                  "unescape through the already tested JS compatibility implementations.",
        "old": "\t\t\tcase \"escape\": \"escape\";",
        "new": "\t\t\t// Patched for M2: legacy AS3 globals live in the JS compatibility runtime.\n"
               "\t\t\tcase \"escape\": \"ASCompat.escape\";\n"
               "\t\t\tcase \"unescape\": \"ASCompat.unescape\";",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/HaxeProperties.hx",
        "reason": "Haxe normally permits private property accessors, but an AS3 subclass may "
                  "supply only the setter half of a property whose getter is inherited. That "
                  "translation requires a real overridable set_name method on the parent, so "
                  "preserve public visibility on generated accessor methods.",
        "old": "\tfunction removePublicModifier(field:TClassField) {\n"
               "\t\t// TODO: handle trivia (if `public` or namespace is the first modifier we probably have an indent whitespace before it)\n"
               "\t\tfield.modifiers = [for (m in field.modifiers) if (!m.match(FMPublic(_))) m];\n"
               "\t\tfield.namespace = null;\n"
               "\t}",
        "new": "\tfunction removePublicModifier(field:TClassField) {\n"
               "\t\t// Patched for M2: keep public accessor methods overridable. AS3 permits a\n"
               "\t\t// subclass to contribute only the setter half of an inherited property.\n"
               "\t\tfield.namespace = null;\n"
               "\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteArrayAccess.hx",
        "reason": "An indexed XML node must retain its consumer's expected type so later "
                  "boolean/string coercion filters run; losing it makes UI XML silently untyped.",
        "old": 'mkAccessorCall(eobj, "at", [eindex], TTXML);',
        "new": 'mkAccessorCall(eobj, "at", [eindex], TTXML).with(expectedType = e.expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ToString.hx",
        "reason": "AS3 permits implicit runtime-checked reference downcasts, including typed "
                  "for-each loop variables. Haxe requires the cast to be explicit.",
        "old": '\t\t\t\t\tcase [_, TTString]:',
        "new": '\t\t\t\t\tcase [TTInst(_), TTInst(target)] if (determineCastKind(e.type, target).match(CKDowncast | CKUnknown)):\n'
               '\t\t\t\t\t\te.with(kind = TECast({syntax: {path: {first: mkIdent(target.name), rest: []},\n'
               '\t\t\t\t\t\t\topenParen: mkOpenParen(), closeParen: mkCloseParen()},\n'
               '\t\t\t\t\t\t\texpr: e.with(expectedType = e.type), type: e.expectedType}), type = e.expectedType);\n\n'
               '\t\t\t\t\tcase [_, TTString]:',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/UtilFunctions.hx",
        "reason": "AS3 instance.constructor is the runtime class. Haxe has no constructor "
                  "property; Type.getClass preserves polymorphic cloning of window controllers.",
        "old": '\t\treturn switch e.kind {',
        "new": '\t\treturn switch e.kind {\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, instance), type: TTInst(_)}, "constructor", _)\n'
               '\t\t\t   | TEField({kind: TOExplicit(_, instance = {kind: TECast({expr: {type: TTInst(_)}})})}, "constructor", _):\n'
               '\t\t\t\tmkCall(mkBuiltin("Type.getClass", TTFun([TTAny], TTClass)), [instance], TTClass)\n'
               '\t\t\t\t\t.with(expectedType = e.expectedType);',
        "legacy": '\t\treturn switch e.kind {\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, instance), type: TTInst(_)}, "constructor", _):\n'
               '\t\t\t\tmkCall(mkBuiltin("Type.getClass", TTFun([TTAny], TTClass)), [instance], TTClass)\n'
               '\t\t\t\t\t.with(expectedType = e.expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/MathApi.hx",
        "reason": "Math.ceil/floor/round return Number in AS3, including NaN and infinities. "
                  "Pretending they return Int suppresses the int coercion at assignments and "
                  "returns; on JavaScript NaN then leaks into furniture shadow coordinates. "
                  "Keep the floating result and let NumberToInt perform the actual conversion.",
        "old": '\t\t\t\tif (e.expectedType.match(TTInt | TTUint)) {\n'
               '\t\t\t\t\te.with(type = TTInt);\n'
               '\t\t\t\t} else {\n'
               '\t\t\t\t\tfieldName = "f" + fieldName;\n'
               '\t\t\t\t\tfieldToken = mkIdent(fieldName, fieldToken.leadTrivia, fieldToken.trailTrivia);\n'
               '\t\t\t\t\teMethod = eMethod.with(kind = TEField(fieldObj, fieldName, fieldToken));\n'
               '\t\t\t\t\te.with(kind = TECall(eMethod, args));\n'
               '\t\t\t\t}',
        "new": '\t\t\t\t// Preserve Number until the consuming int/uint boundary coerces it.\n'
               '\t\t\t\tfieldName = "f" + fieldName;\n'
               '\t\t\t\tfieldToken = mkIdent(fieldName, fieldToken.leadTrivia, fieldToken.trailTrivia);\n'
               '\t\t\t\teMethod = eMethod.with(kind = TEField(fieldObj, fieldName, fieldToken));\n'
               '\t\t\t\te.with(kind = TECall(eMethod, args), type = TTNumber);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/HaxeProperties.hx",
        "reason": "An AS3 setter assigning its own property invokes the setter again. Haxe "
                  "treats that spelling as direct backing-field access, requiring @:isVar and "
                  "changing behavior. Emit an explicit accessor call instead.",
        "old": '\t\t\t\t\t\tcase TELocalFunction(_): e;',
        "new": '\t\t\t\t\t\tcase TELocalFunction(_): e;\n'
               '\t\t\t\t\t\tcase TEBinop({kind: TEField(obj, name, token)}, OpAssign(_), value)\n'
               '\t\t\t\t\t\t\tif (name == accessor.name && obj.kind.match(TOImplicitThis(_) | TOImplicitClass(_))):\n'
               '\t\t\t\t\t\t\tvar methodType = TTFun([type], type);\n'
               '\t\t\t\t\t\t\tvar method = mk(TEField(obj, "set_" + name, token), methodType, methodType);\n'
               '\t\t\t\t\t\t\tmkCall(method, [rewriteReturns(value)], type).with(expectedType = e.expectedType);',
        "present": 'var method = mk(TEField(obj, "set_" + name, token), methodType, methodType);',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Unify inherited accessor declarations before Haxe property emission, without "
                  "hard-coded WindowModel setters or silent base implementations.",
        "old": '\t\t\tnew HaxeProperties(context),',
        "new": '\t\t\tnew InheritedAccessors(context),\n\t\t\tnew HaxeProperties(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Compare reference identity across interface/concrete types without runtime downcasts.",
        "old": '\t\t\tnew ToString(context),',
        "new": '\t\t\tnew ReferenceEquality(context),\n\t\t\tnew ToString(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Implement XML/XMLList versus String equality through the E4X runtime contract.",
        "old": '\t\t\tnew ReferenceEquality(context),',
        "new": '\t\t\tnew XMLStringEquality(context),\n\t\t\tnew ReferenceEquality(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit the narrow XML string-comparison runtime helper introduced by XMLStringEquality.",
        "present": '"com.sulake.core.utils.xml.XML.equalsStringOperands"',
        "old": '| "Type.getClass"',
        "new": '| "Type.getClass" | "com.sulake.core.utils.xml.XML.equalsStringOperands"',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Map the GraphicContext parent accessor and raw filter array at the OpenFL boundary.",
        "old": '\t\t\tnew InheritedAccessors(context),',
        "new": '\t\t\tnew GraphicContextPlatform(context),\n\t\t\tnew InheritedAccessors(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Retain Flash text enum strings and coerce numeric TextFormat.leading at the native boundary.",
        "old": '\t\t\tnew NumberToInt(context),',
        "new": '\t\t\tnew OpenFLTextTypes(context),\n\t\t\tnew NumberToInt(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit Font.hasGlyphs through the actual loaded font-program coverage adapter.",
        "present": '"com.sulake.core.window.text.TruffleText.fontHasGlyphs"',
        "old": '| "Type.getClass"',
        "new": '| "Type.getClass" | "com.sulake.core.window.text.TruffleText.fontHasGlyphs"',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteIs.hx",
        "reason": "AS3 uint tests require numeric range semantics; Haxe UInt cannot be passed as a runtime class.",
        "old": '\t\t\t\t\tcase TEBuiltin(_, "Function"):',
        "new": '\t\t\t\t\tcase TEBuiltin(_, "uint"):\n'
               '\t\t\t\t\t\tmkCall(mkBuiltin("com.sulake.core.utils.ASNumericType.isUInt", tIsFunction), [a], TTBoolean).with(expectedType = e.expectedType);\n\n'
               '\t\t\t\t\tcase TEBuiltin(_, "Function"):',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit the explicit AS3 uint type-test helper.",
        "old": '| "Type.getClass"',
        "new": '| "Type.getClass" | "com.sulake.core.utils.ASNumericType.isUInt"',
        "present": '"com.sulake.core.utils.ASNumericType.isUInt"',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteForIn.hx",
        "reason": "Window IIterator hides Flash Proxy enumeration hooks; call the VM adapter instead of treating the implementation fields as values.",
        "old": '\t\t\tcase TTXMLList:\n\t\t\t\tloopVarType = TTXML;',
        "new": '\t\t\tcase TTInst({name: "IIterator", parentModule: {parentPack: {name: "com.sulake.core.window.utils"}}}):\n'
               '\t\t\t\teobj = mkCall(mkBuiltin("com.sulake.core.utils.ASProxy.values", TTFun([TTAny], TTBuiltin)), [eobj], TTBuiltin);\n'
               '\t\t\t\tloopVarType = TTAny;\n'
               '\t\t\tcase TTXMLList:\n\t\t\t\tloopVarType = TTXML;',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit the Proxy enumeration VM boundary.",
        "old": '| "Type.getClass"',
        "new": '| "Type.getClass" | "com.sulake.core.utils.ASProxy.values"',
        "present": '"com.sulake.core.utils.ASProxy.values"',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "AS3's root SecurityError class is namespaced under openfl.errors on this target.",
        "old": '\t\tif (cls.name == "Error" && cls.parentModule.parentPack.name == "") return "ASError";',
        "new": '\t\tif (cls.name == "SecurityError" && cls.parentModule.parentPack.name == "") return "openfl.errors.SecurityError";\n'
               '\t\tif (cls.name == "Error" && cls.parentModule.parentPack.name == "") return "ASError";',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/StringApi.hx",
        "reason": "AS3 string-pattern replace is first-match (not StringTools.replace all-match), and the pattern may arrive from an untyped Array. Preserve native pattern and replacement coercion.",
        "present": 'var eStringToolsReplace = mkBuiltin("ASCompat.stringReplace",',
        "old": 'case [ePattern = {expr: {type: TTString}}, eBy = {expr: {type: TTString}}]:\n\t\t\t\t\t\tvar eStringToolsReplace = mkBuiltin("StringTools.replace", tStringToolsReplace, removeLeadingTrivia(eString));',
        "new": 'case [ePattern = {expr: {type: TTString | TTAny}}, eBy]:\n\t\t\t\t\t\tvar eStringToolsReplace = mkBuiltin("ASCompat.stringReplace", TTFun([TTString, TTAny, TTAny], TTString), removeLeadingTrivia(eString));',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Delegate AS3 String.replace to the target native ECMAScript implementation, preserving first-match strings, regex flags, dollar substitutions and callbacks.",
        "present": "public static inline function stringReplace(value:String, pattern:Dynamic, replacement:Dynamic):String",
        "old": "class ASCompat {",
        "new": 'class ASCompat {\n\tpublic static inline function stringReplace(value:String, pattern:Dynamic, replacement:Dynamic):String {\n\t\t#if js\n\t\treturn js.Syntax.code("{0}.replace({1}, {2})", value, pattern, replacement);\n\t\t#elseif flash\n\t\treturn untyped value.replace(pattern, replacement);\n\t\t#else\n\t\tthrow "AS3 String.replace requires an ECMAScript target";\n\t\t#end\n\t}',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "AVM2 initializes the motion class on use; JS eagerly runs its stage-dependent Timer before OpenFL boot. Preserve the initializer with a checked lazy constant boundary.",
        "old": '\tfunction printClassDecl(c:TClassOrInterfaceDecl, info:TClassDeclInfo, isPrivate:Bool) {',
        "new": '\tfunction printClassDecl(c:TClassOrInterfaceDecl, info:TClassDeclInfo, isPrivate:Bool) {\n'
               '\t\tif (c.name == "Motions" && c.parentModule.parentPack.name == "com.sulake.core.window.motion")\n'
               '\t\t\tbuf.add("@:build(skyhaxe.assets.DeferredStaticMacro.build(\\"_Str_5307\\"))\\n");',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteE4X.hx",
        "reason": "An untyped attribute receiver must retain its XMLList, especially before [0]; stringifying it indexes the first character instead of the attribute node.",
        "old": 'if (expectedType.match(TTXML | TTXMLList)) return eCall;',
        "new": 'if (expectedType.match(TTXML | TTXMLList | TTAny | TTBoolean)) return eCall.with(expectedType = expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "A terminal AS3 catch(Error) catches VM TypeErrors too. Route native JS/OpenFL errors through the declared Error boundary; do not catch arbitrary thrown values.",
        "old": '\t\tfor (c in t.catches) {\n\t\t\tprintTextWithTrivia("catch", c.syntax.keyword);',
        "new": '\t\tfor (c in t.catches) {\n'
               '\t\t\tif (c.v.type.match(TTInst({name: "Error", parentModule: {parentPack: {name: ""}}})) && t.catches.indexOf(c) == t.catches.length - 1) {\n'
               '\t\t\t\tbuf.add("catch (__as3Caught:Dynamic) { var " + c.v.name + ":ASError = ASError.caught(__as3Caught); ");\n'
               '\t\t\t\tprintExpr(c.expr);\n'
               '\t\t\t\tbuf.add(" }");\n'
               '\t\t\t\tcontinue;\n'
               '\t\t\t}\n'
               '\t\t\tprintTextWithTrivia("catch", c.syntax.keyword);',
        "present": 'if (c.v.type.match(TTInst({name: "Error", parentModule: {parentPack: {name: ""}}}))',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteArrayAccess.hx",
        "reason": "IIterator indexed writes add/reorder actual window children via Flash Proxy hooks. Raw JS properties silently orphan the controls.",
        "old": '\t\treturn switch e.kind {\n\t\t\t// The assignment form',
        "new": '\t\treturn switch e.kind {\n'
               '\t\t\tcase TEBinop({kind: TEArrayAccess(a)}, OpAssign(_), value) if (isWindowIterator(a.eobj.type)):\n'
               '\t\t\t\tmkCall(mkBuiltin("com.sulake.core.utils.ASProxy.set", TTFun([TTAny, TTAny, TTAny], TTAny)), [processExpr(a.eobj), processExpr(a.eindex), processExpr(value)], TTAny).with(expectedType = e.expectedType);\n'
               '\t\t\tcase TEArrayAccess(a) if (isWindowIterator(a.eobj.type)):\n'
               '\t\t\t\tmkCall(mkBuiltin("com.sulake.core.utils.ASProxy.get", TTFun([TTAny, TTAny], TTAny)), [processExpr(a.eobj), processExpr(a.eindex)], TTAny).with(expectedType = e.expectedType);\n'
               '\t\t\t// The assignment form',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteArrayAccess.hx",
        "reason": "Identify the window Proxy interface explicitly; do not reroute normal Array or Dictionary indexing.",
        "old": '\tstatic function isSulakeMap(t:TType):Bool {',
        "new": '\tstatic function isWindowIterator(t:TType):Bool {\n'
               '\t\treturn t.match(TTInst({name: "IIterator", parentModule: {parentPack: {name: "com.sulake.core.window.utils"}}}));\n'
               '\t}\n\n\tstatic function isSulakeMap(t:TType):Bool {',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit indexed Proxy VM boundaries.",
        "old": '| "Type.getClass"',
        "new": '| "Type.getClass" | "com.sulake.core.utils.ASProxy.get" | "com.sulake.core.utils.ASProxy.set"',
        "present": '"com.sulake.core.utils.ASProxy.set"',
        "count": 1,
    },
    {
        "file": "src/ax3/Scanner.hx",
        "reason": "AS3 wildcard type followed immediately by its initializer (:*=) is a type token plus equals, not multiplication assignment.",
        "old": '\tMNoRightShift;\n',
        "new": '\tMNoRightShift;\n\tMType;\n',
        "count": 1,
    },
    {
        "file": "src/ax3/Scanner.hx",
        "reason": "Split *= only in a type position; retain ordinary multiplication assignment lexing.",
        "old": '\t\t\t\tcase "*".code:\n\t\t\t\t\tpos++;\n\t\t\t\t\tif (pos < end',
        "new": '\t\t\t\tcase "*".code:\n\t\t\t\t\tpos++;\n\t\t\t\t\tif (mode == MType) return mk(TkAsterisk);\n\t\t\t\t\tif (pos < end',
        "count": 1,
    },
    {
        "file": "src/ax3/Parser.hx",
        "reason": "Type hints need context-sensitive wildcard scanning.",
        "old": '\tfunction parseSyntaxType(allowAny:Bool):SyntaxType {\n\t\tvar token = scanner.advance();',
        "new": '\tfunction parseSyntaxType(allowAny:Bool):SyntaxType {\n\t\tvar token = scanner.doAdvance(MType);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3 new String() constructs an empty string; Haxe has no zero-argument String constructor.",
        "old": '\t\t\tcase TEBuiltin(syntax, "Array"):\n',
        "legacy": '\t\t\tcase TEBuiltin(syntax, "String") if (args == null || args.args.length == 0):\n'
               '\t\t\t\treturn mk(TELiteral(TLString(new Token(keyword.pos, TkStringDouble, \'""\', keyword.leadTrivia, args == null ? syntax.trailTrivia : args.closeParen.trailTrivia))), TTString, expectedType);\n'
               '\t\t\tcase TEBuiltin(syntax, "Array"):\n',
        "new": '\t\t\tcase TEBuiltin(syntax, "String") if (args == null || args.args == null):\n'
               '\t\t\t\treturn mk(TELiteral(TLString(new Token(keyword.pos, TkStringDouble, \'""\', keyword.leadTrivia, args == null ? syntax.trailTrivia : args.closeParen.trailTrivia))), TTString, expectedType);\n'
               '\t\t\tcase TEBuiltin(syntax, "Array"):\n',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "The parenthesized typeof operator is used by the original video/layout code and must retain AS3 XML semantics.",
        "old": '\t\t\tcase "parseInt":  mk',
        "new": '\t\t\tcase "typeof": mk(TEBuiltin(i, "ASCompat.typeOf"), TTFun([TTAny], TTString), expectedType);\n\t\t\tcase "parseInt":  mk',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "AS3 typeof distinguishes XML/XMLList and class objects from ordinary JavaScript object/function types.",
        "present": "public static function typeOf(value:Dynamic):String",
        "old": 'class ASCompat {',
        "new": 'class ASCompat {\n\tpublic static function typeOf(value:Dynamic):String {\n'
               '\t\t#if js\n'
               '\t\tif (Std.isOfType(value, com.sulake.core.utils.xml.XML) || Std.isOfType(value, com.sulake.core.utils.xml.XMLList)) return "xml";\n'
               '\t\tif (value != null && Reflect.field(value, "__name__") != null) return "object";\n'
               '\t\treturn js.Syntax.code("typeof {0}", value);\n'
               '\t\t#else\n\t\treturn untyped __global__["typeof"](value);\n\t\t#end\n\t}',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3 Arrays are dynamic; an absent .count is undefined, not .length. Preserve this original behavior instead of repairing the client source.",
        "old": 'case other: err(\'Unknown Array instance field $other\', field.pos); TTAny;',
        "new": 'case other: TTAny; // AS3 Array dynamic properties retain undefined when absent.',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Route dynamic Array properties through ASAny so Haxe does not require nonexistent statically declared fields.",
        "old": '\t\t\t\tcase [_, {type: TTArray(t)}]: getArrayInstanceFieldType(fieldToken, t);',
        "legacy": '\t\t\t\tcase [_, {type: TTArray(t)}]:\n'
               '\t\t\t\t\tvar memberType = getArrayInstanceFieldType(fieldToken, t);\n'
               '\t\t\t\t\tif (memberType == TTAny) return mkExplicitFieldAccess(obj.with(kind = TEHaxeRetype(obj), type = TTAny), dot, fieldToken, TTAny, expectedType);\n'
               '\t\t\t\t\tmemberType;',
        "new": '\t\t\t\tcase [_, {type: TTArray(t)}]:\n'
               '\t\t\t\t\tvar memberType = getArrayInstanceFieldType(fieldToken, t);\n'
               '\t\t\t\t\tif (memberType == TTAny) return mkExplicitFieldAccess(mk(TEHaxeRetype(obj), TTAny, TTAny), dot, fieldToken, TTAny, expectedType);\n'
               '\t\t\t\t\tmemberType;',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3 primitive constructors with arguments have the same value coercion as their cast forms; emit the existing tested conversion path rather than an unsupported Haxe constructor.",
        "old": '\t\t\tcase TEBuiltin(_, _):\n\t\t\t\treturn throwErr("Unprocessed `new builtin`", keyword.pos);',
        "new": '\t\t\tcase TEBuiltin(_, "String" | "Number" | "Boolean" | "int" | "uint") if (args != null && args.args != null):\n'
               '\t\t\t\treturn typeCall(switch e.kind { case TEBuiltin(token, _): EIdent(token); case _: throw "assert"; }, args, expectedType);\n'
               '\t\t\tcase TEBuiltin(_, _):\n\t\t\t\treturn throwErr("Unprocessed `new builtin`", keyword.pos);',
        "count": 1,
    },
]


PATCHES.extend([
    {
        "file": "src/ax3/filters/NumberToInt.hx",
        "reason": "AS3 implicitly converts XML/XMLList simple content at an int/uint argument or assignment boundary; JavaScript/Haxe needs the coercion made explicit.",
        "old": '\t\t\tcase [TTNumber, TTInt | TTUint]:\n'
               '\t\t\t\tvar stdInt = mkBuiltin("Std.int", tStdInt, removeLeadingTrivia(e));\n'
               '\t\t\t\tmkCall(stdInt, [e.with(expectedType = TTNumber)]);',
        "new": '\t\t\tcase [TTNumber, TTInt | TTUint]:\n'
               '\t\t\t\tvar stdInt = mkBuiltin("Std.int", tStdInt, removeLeadingTrivia(e));\n'
               '\t\t\t\tmkCall(stdInt, [e.with(expectedType = TTNumber)]);\n'
               '\t\t\tcase [TTXML | TTXMLList, TTInt | TTUint]:\n'
               '\t\t\t\tvar name = e.expectedType == TTUint ? "ASCompat.toUInt" : "ASCompat.toInt";\n'
               '\t\t\t\tvar coerce = mkBuiltin(name, TTFun([TTAny], e.expectedType), removeLeadingTrivia(e));\n'
               '\t\t\t\tmkCall(coerce, [e.with(expectedType = TTAny)]);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "E4X xml.name is a child lookup, distinct from xml.name(); the existing call-aware E4X rewrite preserves the latter.",
        "old": '\t\t\tcase "name": TTFun([], TTString);',
        "new": '\t\t\tcase "name": null; // E4X property lookup; invocation is resolved separately.',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Flash EventDispatcher accepts Function listeners without OpenFL's inferred event-type constraint; an erased retype retains callback identity for removal.",
        "old": '\t\t\tnew OpenFLArrayArguments(context),',
        "new": '\t\t\tnew OpenFLArrayArguments(context),\n\t\t\tnew OpenFLEventCallbacks(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Preserve a conditional switch exit by guarding the remaining case statements; nested loop breaks and outer-loop continues retain their targets.",
        "old": '\t\t\tnew RewriteSwitch(context),',
        "new": '\t\t\tnew RewriteSwitch(context),\n\t\t\tnew GuardedSwitchExit(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/StringApi.hx",
        "reason": "RegExp replacement values also accept numeric/Boolean/null coercion; use the shared native replacement boundary when the typed String/Function fast path does not match.",
        "old": 'case [ePattern = {expr: {type: TTString | TTAny}}, eBy]:',
        "new": 'case [ePattern = {expr: {type: TTString | TTAny | TTRegExp}}, eBy]:',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/StringApi.hx",
        "reason": "String.match accepts string/dynamic patterns as well as RegExp and returns null on no match. Keep native match arrays and their capture/index metadata.",
        "old": '\t\t\tcase TECall({kind: TEField({kind: TOExplicit(dot, eString = {type: TTString})}, "match", fieldToken)}, args):\n'
               '\t\t\t\teString = processExpr(eString);',
        "new": '\t\t\tcase TECall({kind: TEField({kind: TOExplicit(dot, eString = {type: TTString})}, "match", fieldToken)}, args):\n'
               '\t\t\t\tif (args.args.length == 1) {\n'
               '\t\t\t\t\treturn mkCall(mkBuiltin("ASCompat.stringMatch", TTFun([TTString, TTAny], TTArray(TTString))),\n'
               '\t\t\t\t\t\t[processExpr(eString), processExpr(args.args[0].expr)], TTArray(TTString)).with(expectedType = e.expectedType);\n'
               '\t\t\t\t}\n'
               '\t\t\t\teString = processExpr(eString);',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Use VM String.match at the runtime boundary, including implicit RegExp construction and null for a missing match.",
        "old": 'class ASCompat {',
        "present": 'public static function stringMatch(',
        "new": 'class ASCompat {\n'
               '\tpublic static function stringMatch(value:String, pattern:Dynamic):Array<String> {\n'
               '\t\t#if js\n'
               '\t\treturn js.Syntax.code("{0}.match({1})", value, pattern);\n'
               '\t\t#elseif flash\n'
               '\t\treturn untyped value.match(pattern);\n'
               '\t\t#else\n'
               '\t\tthrow "String.match requires a supported VM boundary";\n'
               '\t\t#end\n'
               '\t}\n',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteSwitch.hx",
        "reason": "Preserve fall-through from the final case into an immediately following return/throw default. Appending that terminator retains the source early exit instead of silently inserting a break.",
        "present": 'c.body.push(s.def.body[0]);',
        "old": '\t\t\t\t\t\tvar breakTrivia = processCaseBody(c.body, isLast);',
        "new": '\t\t\t\t\t\tif (i == s.cases.length - 1 && s.def != null && !defaultBeforeCase\n'
               '\t\t\t\t\t\t\t&& s.def.body.length == 1\n'
               '\t\t\t\t\t\t\t&& s.def.body[0].expr.kind.match(TEReturn(_) | TEThrow(_))) {\n'
               '\t\t\t\t\t\t\tvar tail = c.body[c.body.length - 1].expr;\n'
               '\t\t\t\t\t\t\tif (!tail.kind.match(TEBreak(_) | TEReturn(_) | TEThrow(_) | TEContinue(_)))\n'
               '\t\t\t\t\t\t\t\tc.body.push(s.def.body[0]);\n'
               '\t\t\t\t\t\t}\n'
               '\t\t\t\t\t\tvar breakTrivia = processCaseBody(c.body, isLast);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Recognize XML.ignoreWhitespace as the E4X constructor's Boolean parsing setting, not an unknown builtin field.",
        "old": '\t\t\t\tcase [_, {kind: TEBuiltin(_, "String")}]: getStringStaticFieldType(fieldToken);',
        "new": '\t\t\t\tcase ["ignoreWhitespace", {kind: TEBuiltin(_, "XML")}]: TTBoolean;\n'
               '\t\t\t\tcase [_, {kind: TEBuiltin(_, "String")}]: getStringStaticFieldType(fieldToken);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteE4X.hx",
        "reason": "An AS3 :* receiver can carry XML at runtime; descendant access must check the runtime value rather than reject conversion or coerce an ordinary object into XML.",
        "old": '\t\t\tcase TEXmlDescend(x):\n\t\t\t\tvar eobj = processExpr(x.eobj);\n\t\t\t\tassertIsXML(eobj);',
        "new": '\t\t\tcase TEXmlDescend(x):\n\t\t\t\tvar eobj = processExpr(x.eobj);\n'
               '\t\t\t\tif (eobj.type.match(TTAny | TTObject(_))) {\n'
               '\t\t\t\t\tvar name = mk(TELiteral(TLString(new Token(0, TkStringDouble, haxe.Json.stringify(x.name), [], []))), TTString, TTString);\n'
               '\t\t\t\t\treturn mkCall(mkBuiltin("ASCompat.xmlDescendants", TTFun([TTAny, TTString], TTXMLList)), [eobj, name], TTXMLList).with(expectedType = e.expectedType);\n'
               '\t\t\t\t}\n'
               '\t\t\t\tassertIsXML(eobj);',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Runtime-checked dynamic E4X descendants: accept XML/XMLList and reject non-XML receivers without string coercion.",
        "old": 'class ASCompat {',
        "present": 'public static function xmlDescendants(',
        "new": 'class ASCompat {\n'
               '\tpublic static function xmlDescendants(value:Dynamic, name:String):com.sulake.core.utils.xml.XMLList {\n'
               '\t\tif (Std.isOfType(value, com.sulake.core.utils.xml.XML)) return (cast value : com.sulake.core.utils.xml.XML).descendants(name);\n'
               '\t\tif (Std.isOfType(value, com.sulake.core.utils.xml.XMLList)) return (cast value : com.sulake.core.utils.xml.XMLList).descendants(name);\n'
               '\t\tthrow new openfl.errors.TypeError("Descendant access requires XML or XMLList");\n'
               '\t}\n',
        "count": 1,
    },
    {
        "file": "src/ax3/Parser.hx",
        "reason": "Accept the E4X descendant wildcard as a name token; retain multiplication parsing outside the descendant selector.",
        "old": '\t\t\tcase TkDotDot:\n\t\t\t\treturn parseExprNext(EXmlDescend(first, scanner.consume(), expectKind(TkIdent)), allowComma);',
        "new": '\t\t\tcase TkDotDot:\n'
               '\t\t\t\tvar dotDot = scanner.consume();\n'
               '\t\t\t\tvar name = scanner.advance().kind == TkAsterisk ? scanner.consume() : expectKind(TkIdent);\n'
               '\t\t\t\treturn parseExprNext(EXmlDescend(first, dotDot, name), allowComma);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteArrayAccess.hx",
        "reason": "XML is a singleton E4X list: numeric index zero returns the node and other indices are absent, just as XMLList numeric indexing uses at().",
        "old": 'case [TTXMLList, TTInt | TTUint | TTNumber]:',
        "new": 'case [TTXML | TTXMLList, TTInt | TTUint | TTNumber]:',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Honor declared toString signatures and dynamically dispatched arguments before the Object zero-argument fallback.",
        "old": '\t\t\t\tcase ["toString", _]: TTFun([], TTString);',
        "new": '\t\t\t\tcase ["toString", {type: TTAny | TTObject(_)}]: TTAny;\n'
               '\t\t\t\tcase ["toString", {type: TTInst(cls)}]: typeInstanceField(cls, fieldName, fieldToken.pos);\n'
               '\t\t\t\tcase ["toString", _]: TTFun([], TTString);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Retain implicit Object.toString only after searching declared and inherited class fields.",
        "old": "\t\treturn throwErr('Unknown instance field $fieldName on class ${cls.name}', pos);",
        "new": '\t\tif (fieldName == "toString") return TTFun([], TTString);\n'
               "\t\treturn throwErr('Unknown instance field $fieldName on class ${cls.name}', pos);",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Keep indexed XML nodes typed as XML before typing chained E4X access; the later at() rewrite cannot repair an already untyped child/attribute chain.",
        "old": '\t\t\tcase TTDictionary(k, v):\n\t\t\t\ttype = v;\n\t\t\t\texpectedKeyType = k;',
        "legacy": '\t\t\tcase TTXML | TTXMLList:\n'
               '\t\t\t\tvar index = typeExpr(eindex, TTAny);\n'
               '\t\t\t\ttype = index.type.match(TTInt | TTUint | TTNumber) ? TTXML : TTXMLList;\n'
               '\t\t\t\texpectedKeyType = TTAny;\n'
               '\t\t\tcase TTDictionary(k, v):\n\t\t\t\ttype = v;\n\t\t\t\texpectedKeyType = k;',
        "new": '\t\t\tcase TTXML | TTXMLList:\n'
               '\t\t\t\tvar index = typeExpr(eindex, TTAny);\n'
               '\t\t\t\ttype = switch index.type { case TTInt | TTUint | TTNumber: TTXML; case TTString: TTXMLList; case _: TTAny; };\n'
               '\t\t\t\texpectedKeyType = TTAny;\n'
               '\t\t\tcase TTDictionary(k, v):\n\t\t\t\ttype = v;\n\t\t\t\texpectedKeyType = k;',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "XMLList child/children queries return lists, not an untyped callable child named children. Attribute takes a name and returns a list, as on XML.",
        "old": '\t\t\tcase "attribute": TTFun([], TTString);',
        "new": '\t\t\tcase "attribute": TTFun([TTAny], TTXMLList);\n'
               '\t\t\tcase "child": TTFun([tUntypedObject], TTXMLList);\n'
               '\t\t\tcase "children": TTFun([], TTXMLList);',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RestArgs.hx",
        "reason": "Keep Event.formatToString calls variadic for the native Flash/OpenFL API instead of packing their tail into an Array.",
        "old": "\t\t\tcase _:\n\t\t\t\tfalse;\n\t\t}\n\t}\n\n\tstatic function transformArgs",
        "new": "\t\t\t// Flash/OpenFL exposes Event.formatToString as a native variadic API. Packing\n\t\t\t// its tail into an Array produces Array<String> where haxe.Rest<String> is\n\t\t\t// required, unlike AS3 source rest functions which genuinely take an Array.\n\t\t\tcase TEField(_, \"formatToString\", _):\n\t\t\t\ttrue;\n\t\t\tcase _:\n\t\t\t\tfalse;\n\t\t}\n\t}\n\n\tstatic function transformArgs",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteSwitch.hx",
        "reason": "Preserve subject evaluation but eliminate normalized no-op switches, whose mutable Flash constants cannot be Haxe case patterns.",
        "old": "\t\t\t\te.with(kind = TESwitch({\n\t\t\t\t\tsyntax: s.syntax,\n\t\t\t\t\tsubj: s.subj,\n\t\t\t\t\tcases: newCases,\n\t\t\t\t\tdef: s.def\n\t\t\t\t}));",
        "new": "\t\t\t\t// A switch whose cases only contained `break` is a no-op after AS3\n\t\t\t\t// fall-through normalization. Preserve evaluation of its subject, but do\n\t\t\t\t// not emit Haxe case patterns (native Flash event constants are mutable\n\t\t\t\t// static fields and therefore illegal as Haxe patterns).\n\t\t\t\tvar allCasesEmpty = true;\n\t\t\t\tfor (branch in newCases) if (branch.body.length > 0) allCasesEmpty = false;\n\t\t\t\tif (allCasesEmpty && (s.def == null || s.def.body.length == 0)) {\n\t\t\t\t\ts.subj.with(expectedType = e.expectedType);\n\t\t\t\t} else {\n\t\t\t\t\te.with(kind = TESwitch({\n\t\t\t\t\t\tsyntax: s.syntax,\n\t\t\t\t\t\tsubj: s.subj,\n\t\t\t\t\t\tcases: newCases,\n\t\t\t\t\t\tdef: s.def\n\t\t\t\t\t}));\n\t\t\t\t}",
        "count": 1,
    },
])


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Explicit radix 16 accepts a signed 0x prefix in AS3; window XML colours use this form.",
    "old": '\t\tif (negative || StringTools.startsWith(trimmed, "+")) trimmed = trimmed.substr(1);',
    "new": '\t\tif (negative || StringTools.startsWith(trimmed, "+")) trimmed = trimmed.substr(1);\n'
           '\t\tif (radix == 16 && trimmed.substr(0, 2).toLowerCase() == "0x") trimmed = trimmed.substr(2);',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/ExprTyper.hx",
    "reason": "Type Flash ByteArray indexed reads as uint and indexes as uint instead of losing both to Dynamic.",
    "old": "\t\t\tcase TTDictionary(k, v):\n\t\t\t\ttype = v;\n\t\t\t\texpectedKeyType = k;\n\t\t\tcase _:",
    "new": "\t\t\tcase TTDictionary(k, v):\n\t\t\t\ttype = v;\n\t\t\t\texpectedKeyType = k;\n\t\t\tcase TTInst({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}}):\n\t\t\t\t// Flash ByteArray indexed access returns an unsigned byte and coerces its\n\t\t\t\t// numeric index to uint. Keeping this typed avoids later dynamic calls and\n\t\t\t\t// matches the browser ByteArray adapter's array-access contract.\n\t\t\t\ttype = TTUint;\n\t\t\t\texpectedKeyType = TTUint;\n\t\t\tcase _:",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "AS3 implicitly stringifies uint values just like int and Number, including numeric Array delete keys.",
    "old": "\t\t\t\t\tcase [TTInt | TTNumber, TTString]:",
    "new": "\t\t\t\t\tcase [TTInt | TTUint | TTNumber, TTString]:",
    "present": "\t\t\t\t\tcase [TTInt | TTUint | TTNumber | TTBoolean, TTString]:",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteE4X.hx",
    "reason": "Preserve AS3 E4X simple-content delegation for String case-conversion methods.",
    "old": '''\t\treturn switch e.kind {
\t\t\t// The AS3 parser represents `xml.text()`''',
    "new": '''\t\treturn switch e.kind {
\t\t\t// E4X delegates String methods on simple XML/XMLList content. The AS3
\t\t\t// parser cannot distinguish this from a child query, so lower the
\t\t\t// receiver through the AS3 String boundary before selecting the method.
\t\t\tcase TECall({kind: TEXmlChild(x)}, args)
\t\t\t\t\tif (x.name == "toUpperCase" || x.name == "toLowerCase"):
\t\t\t\tvar eobj = processExpr(x.eobj);
\t\t\t\tassertIsXML(eobj);
\t\t\t\tvar eString = mkCall(mkBuiltin("ASCompat.toString", TTFun([TTAny], TTString)), [eobj], TTString);
\t\t\t\tvar methodType = TTFun([for (_ in args.args) TTAny], TTString);
\t\t\t\tvar fieldObject = {kind: TOExplicit(x.syntax.dot, eString), type: TTString};
\t\t\t\tvar eMethod = mk(TEField(fieldObject, x.name, mkIdent(x.name)), methodType, methodType);
\t\t\t\te.with(kind = TECall(eMethod, {
\t\t\t\t\topenParen: args.openParen,
\t\t\t\t\targs: [for (arg in args.args) arg.with(expr = processExpr(arg.expr))],
\t\t\t\t\tcloseParen: args.closeParen
\t\t\t\t}), type = TTString);

\t\t\t// The AS3 parser represents `xml.text()`''',
    "present": "E4X delegates String methods on simple XML/XMLList content",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteE4X.hx",
    "reason": "Treat SkyHaxe's staged E4X childByNamespace helper as a method instead of a child query.",
    "old": '''\t\t\tcase "attribute" | "attributes" | "child" | "children" | "comments"''',
    "new": '''\t\t\tcase "attribute" | "attributes" | "child" | "childByNamespace" | "children" | "comments"''',
    "present": '''case "attribute" | "attributes" | "child" | "childByNamespace" | "children"''',
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Flash System.pauseForGCIfCollectionImminent permits its imminence argument to be omitted.",
    "old": "\tpublic static function pauseForGCIfCollectionImminent(_:Float):Void {",
    "new": "\tpublic static function pauseForGCIfCollectionImminent(_:Float = 0):Void {",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteSwitch.hx",
    "reason": "Inspect a braced case's effective tail before deciding it falls through; preserve an existing break inside that block.",
    "old": '\t\t\t\t\t\t\tvar tail = c.body[c.body.length - 1].expr;',
    "new": '\t\t\t\t\t\t\tvar tail = c.body[c.body.length - 1].expr;\n'
           '\t\t\t\t\t\t\tswitch tail.kind {\n'
           '\t\t\t\t\t\t\t\tcase TEBlock(block) if (block.exprs.length > 0): tail = block.exprs[block.exprs.length - 1].expr;\n'
           '\t\t\t\t\t\t\t\tcase _: \n'
           '\t\t\t\t\t\t\t}',
    "count": 1,
})


PATCHES.extend([
    {
        "file": "src/ax3/Filters.hx",
        "reason": "AS3 relational comparisons numerically coerce Boolean operands; Haxe rejects Boolean/number comparisons.",
        "old": '\t\t\tnew UintComparison(context),',
        "new": '\t\t\tnew NumericRelations(context),\n\t\t\tnew UintComparison(context),',
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Unsigned 32-bit decimal literals must remain constant expressions in static constants and default arguments; use their exact hexadecimal bit pattern.",
        "old": '\t\t\t\t\tbuf.add("ASCompat.toUInt(" + syntax.text + ")");',
        "legacy": '\t\t\t\t\tif (Std.parseFloat(syntax.text) <= 4294967295.0)\n'
               '\t\t\t\t\t\tbuf.add("0x" + StringTools.hex(Std.int(Std.parseFloat(syntax.text)), 8));\n'
               '\t\t\t\t\telse buf.add("ASCompat.toUInt(" + syntax.text + ")");',
        "new": '\t\t\t\t\tif (Std.parseFloat(syntax.text) <= 4294967295.0)\n'
               '\t\t\t\t\t\tbuf.add("0x" + StringTools.hex(Std.int(Std.parseFloat(syntax.text) - 2147483648.0) | (-2147483647 - 1), 8));\n'
               '\t\t\t\t\telse buf.add("ASCompat.toUInt(" + syntax.text + ")");',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/MathApi.hx",
        "reason": "Haxe Math omits the AS3 LN2 constant; preserve its double value as a literal.",
        "old": '\t\treturn switch e.kind {',
        "legacy": '\t\treturn switch e.kind {\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEDeclRef(_, {kind: TDClassOrInterface({name: "Math", parentModule: {parentPack: {name: ""}}})})})}, "LN2", _):\n'
               '\t\t\t\te.with(kind = TEBuiltin(mkIdent("0.6931471805599453", removeLeadingTrivia(e), removeTrailingTrivia(e)), "0.6931471805599453"));',
        "new": '\t\treturn switch e.kind {\n'
               '\t\t\tcase TEField({kind: TOExplicit(_, {kind: TEDeclRef(_, {kind: TDClassOrInterface({name: "Math", parentModule: {parentPack: {name: ""}}})})})}, "LN2", _):\n'
               '\t\t\t\te.with(kind = TELiteral(TLNumber(new Token(0, TkFloat, "0.6931471805599453", removeLeadingTrivia(e), removeTrailingTrivia(e)))));',
        "count": 1,
    },
])


PATCHES.extend([
    {"file": "compat/ASDictionary.hx", "reason": "Index string keys without changing mixed-key equality, undefined misses or enumeration order.", "old": old, "new": new, "count": 1}
    for old, new in [
        ('\tfinal entries:Array<{key:K, value:V}> = [];', '\tfinal entries:Array<{key:K, value:V}> = [];\n\tfinal strings = new haxe.ds.StringMap<{key:K, value:V}>();'),
        ('\tpublic function get(key:K):Null<V> {', '\tpublic function get(key:K):Null<V> {\n\t\tif (Std.isOfType(key, String)) {\n\t\t\tvar entry = strings.get(cast key);\n\t\t\treturn entry == null ? js.Syntax.code("undefined") : entry.value;\n\t\t}'),
        ('\tpublic function set(key:K, value:V):V {', '\tpublic function set(key:K, value:V):V {\n\t\tif (Std.isOfType(key, String)) {\n\t\t\tvar entry = strings.get(cast key);\n\t\t\tif (entry == null) {\n\t\t\t\tentry = {key:key, value:value};\n\t\t\t\tstrings.set(cast key, entry);\n\t\t\t\tentries.push(entry);\n\t\t\t} else entry.value = value;\n\t\t\treturn value;\n\t\t}'),
        ('\tpublic function exists(key:K):Bool {', '\tpublic function exists(key:K):Bool {\n\t\tif (Std.isOfType(key, String)) return strings.exists(cast key);'),
    ]
])


# The friend-list closure is the first converted batch to exercise AS3's multi-column
# Array.sortOn form. Keep this as a general converter/runtime capability: the generated call
# remains sortOn, while the compatibility helper accepts either scalar or Array arguments and
# applies the per-column option flags lexicographically.
PATCHES.extend([
    {
        "file": "src/ax3/filters/ArrayApi.hx",
        "reason": "Type the scalar and multi-column Array.sortOn forms through the same compatibility helper.",
        "old": "\tstatic final tSortOn = TTFun([TTArray(TTAny), TTString, TTInt], TTArray(TTAny));",
        "new": "\tstatic final tSortOn = TTFun([TTArray(TTAny), TTAny, TTAny], TTArray(TTAny));",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ArrayApi.hx",
        "reason": "Accept Array field names and per-field option arrays used by the original friend ordering.",
        "old": "\t\t\t\t\tcase [eFieldName = {expr: {type: TTString}}, eOptions = {expr: {type: TTInt | TTUint}}]:",
        "new": "\t\t\t\t\tcase [eFieldName = {expr: {type: TTString | TTArray(_)}}, eOptions = {expr: {type: TTInt | TTUint | TTArray(_)}}]:",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Accept both scalar and Array arguments for AS3 Array.sortOn.",
        "old": "\tpublic static function sortOn<T>(a:Array<T>, fieldName:String, options:Int):Array<T> {",
        "new": "\tpublic static function sortOn<T>(a:Array<T>, fieldName:Dynamic, options:Dynamic):Array<T> {",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Normalize Array.sortOn fields/options and reject unsupported result-changing flags per column.",
        "old": "\t\tif ((options & RETURNINDEXEDARRAY) != 0 || (options & UNIQUESORT) != 0) {\n"
               "\t\t\tthrow \"ASArray.sortOn: RETURNINDEXEDARRAY and UNIQUESORT are not implemented\";\n"
               "\t\t}\n"
               "\t\tvar numeric = (options & NUMERIC) != 0;\n"
               "\t\tvar descending = (options & DESCENDING) != 0;\n"
               "\t\tvar caseInsensitive = (options & CASEINSENSITIVE) != 0;",
        "new": "\t\tvar fields:Array<Dynamic> = Std.isOfType(fieldName, Array)\n"
               "\t\t\t? cast fieldName : [fieldName];\n"
               "\t\tvar optionList:Array<Dynamic> = Std.isOfType(options, Array)\n"
               "\t\t\t? cast options : [options];\n"
               "\t\tfor (option in optionList) {\n"
               "\t\t\tvar flags = Std.int(option);\n"
               "\t\t\tif ((flags & RETURNINDEXEDARRAY) != 0 || (flags & UNIQUESORT) != 0) {\n"
               "\t\t\t\tthrow \"ASArray.sortOn: RETURNINDEXEDARRAY and UNIQUESORT are not implemented\";\n"
               "\t\t\t}\n"
               "\t\t}",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Compare multiple Array.sortOn columns in order using each column's AS3 flags.",
        "old": "\t\t\tvar lf = Reflect.getProperty(left, fieldName);\n"
               "\t\t\tvar rf = Reflect.getProperty(right, fieldName);\n"
               "\t\t\tvar result;\n"
               "\t\t\tif (numeric) {\n"
               "\t\t\t\tvar l:Float = lf == null ? 0 : cast lf;\n"
               "\t\t\t\tvar r:Float = rf == null ? 0 : cast rf;\n"
               "\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n"
               "\t\t\t} else {\n"
               "\t\t\t\tvar l = lf == null ? \"\" : Std.string(lf);\n"
               "\t\t\t\tvar r = rf == null ? \"\" : Std.string(rf);\n"
               "\t\t\t\tif (caseInsensitive) {\n"
               "\t\t\t\t\tl = l.toLowerCase();\n"
               "\t\t\t\t\tr = r.toLowerCase();\n"
               "\t\t\t\t}\n"
               "\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n"
               "\t\t\t}\n"
               "\t\t\treturn descending ? -result : result;",
        "new": "\t\t\tfor (index in 0...fields.length) {\n"
               "\t\t\t\tvar field = Std.string(fields[index]);\n"
               "\t\t\t\tvar flags = Std.int(optionList.length == 1 ? optionList[0]\n"
               "\t\t\t\t\t: (index < optionList.length ? optionList[index] : 0));\n"
               "\t\t\t\tvar lf = Reflect.getProperty(left, field);\n"
               "\t\t\t\tvar rf = Reflect.getProperty(right, field);\n"
               "\t\t\t\tvar result:Int;\n"
               "\t\t\t\tif ((flags & NUMERIC) != 0) {\n"
               "\t\t\t\t\tvar l:Float = ASCompat.toNumber(lf);\n"
               "\t\t\t\t\tvar r:Float = ASCompat.toNumber(rf);\n"
               "\t\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n"
               "\t\t\t\t} else {\n"
               "\t\t\t\t\tvar l = lf == null ? \"\" : Std.string(lf);\n"
               "\t\t\t\t\tvar r = rf == null ? \"\" : Std.string(rf);\n"
               "\t\t\t\t\tif ((flags & CASEINSENSITIVE) != 0) {\n"
               "\t\t\t\t\t\tl = l.toLowerCase();\n"
               "\t\t\t\t\t\tr = r.toLowerCase();\n"
               "\t\t\t\t\t}\n"
               "\t\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n"
               "\t\t\t\t}\n"
               "\t\t\t\tif (result != 0) return (flags & DESCENDING) != 0 ? -result : result;\n"
               "\t\t\t}\n"
               "\t\t\treturn 0;",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ArrayApi.hx",
        "reason": "AS3 Array.sortOn has an optional options argument. Supply zero flags when it "
                  "is omitted, using the same tested compatibility implementation.",
        "old": '\t\t\t\t\tcase [eFieldName = {expr: {type: TTString | TTArray(_)}}, eOptions = {expr: {type: TTInt | TTUint | TTArray(_)}}]:',
        "new": '\t\t\t\t\tcase [eFieldName = {expr: {type: TTString | TTArray(_)}}]:\n'
               '\t\t\t\t\t\tvar eCompatArray = mkBuiltin("ASCompat.ASArray", TTBuiltin, removeLeadingTrivia(eArray));\n'
               '\t\t\t\t\t\tvar fieldObj = {kind: TOExplicit(dot, eCompatArray), type: eCompatArray.type};\n'
               '\t\t\t\t\t\tvar eMethod = mk(TEField(fieldObj, "sortOn", fieldToken), tSortOn, tSortOn);\n'
               '\t\t\t\t\t\tvar zero = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "0", [], []))), TTInt, TTInt);\n'
               '\t\t\t\t\t\te.with(kind = TECall(eMethod, args.with(args = [\n'
               '\t\t\t\t\t\t\t{expr: eArray, comma: commaWithSpace},\n'
               '\t\t\t\t\t\t\t{expr: eFieldName.expr, comma: commaWithSpace},\n'
               '\t\t\t\t\t\t\t{expr: zero, comma: null}\n'
               '\t\t\t\t\t\t])));\n\n'
               '\t\t\t\t\tcase [eFieldName = {expr: {type: TTString | TTArray(_)}}, eOptions = {expr: {type: TTInt | TTUint | TTArray(_)}}]:',
        "present": '{expr: eFieldName.expr.with(expectedType = eFieldName.expr.type), comma: commaWithSpace}',
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "AS3's `property in object` operator is JavaScript's prototype-aware `in`, "
                  "not Haxe Reflect.hasField. Keep the target operation explicit.",
        "old": '\tpublic static function typeOf(value:Dynamic):String {',
        "legacy": '\tpublic static inline function inOperator(property:Dynamic, object:Dynamic):Bool {\n'
                  '\t\t#if js\n'
                  '\t\treturn js.Syntax.code("{0} in {1}", property, object);\n'
                  '\t\t#elseif flash\n'
                  '\t\treturn untyped property in object;\n'
                  '\t\t#else\n'
                  '\t\treturn Reflect.hasField(object, Std.string(property));\n'
                  '\t\t#end\n'
                  '\t}\n\n'
                  '\tpublic static function typeOf(value:Dynamic):String {',
        "new": '\tpublic static function inOperator(property:Dynamic, object:Dynamic):Bool {\n'
               '\t\t#if js\n'
               '\t\treturn js.Syntax.code("{0} in {1}", property, object);\n'
               '\t\t#elseif flash\n'
               '\t\treturn untyped property in object;\n'
               '\t\t#else\n'
               '\t\treturn Reflect.hasField(object, Std.string(property));\n'
               '\t\t#end\n'
               '\t}\n\n'
               '\tpublic static function typeOf(value:Dynamic):String {',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteHasOwnProperty.hx",
        "reason": "Rewrite non-Dictionary AS3 `in` expressions to the target compatibility "
                  "operation instead of leaving an operator Haxe cannot print.",
        "old": '\t\t\tcase TECall(eField = {kind: TEField(obj, "hasOwnProperty", fieldToken)}, args):',
        "new": '\t\t\tcase TEBinop(ekey, OpIn(_), eobject):\n'
               '\t\t\t\tekey = processExpr(ekey);\n'
               '\t\t\t\teobject = processExpr(eobject);\n'
               '\t\t\t\tvar method = mkBuiltin("ASCompat.inOperator", TTFun([TTAny, TTAny], TTBoolean), removeLeadingTrivia(ekey));\n'
               '\t\t\t\tmkCall(method, [ekey.with(expectedType = TTAny), eobject.with(expectedType = TTAny)], TTBoolean).with(expectedType = e.expectedType);\n\n'
               '\t\t\tcase TECall(eField = {kind: TEField(obj, "hasOwnProperty", fieldToken)}, args):',
        "count": 1,
    },
])


PATCHES.extend([
    {"file": "compat/ASDictionary.hx", "reason": "AS3 Dictionary distinguishes numeric and string keys; JS loose equality does not.", "old": old, "new": new, "count": count}
    for old, new, count in [
        ('entry.key == key', 'js.Syntax.code("{0} === {1}", entry.key, key)', 3),
        ('entries[index].key == key', 'js.Syntax.code("{0} === {1}", entries[index].key, key)', 1),
    ]
])

PATCHES.extend([
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "AS3 Vector.filter supplies item, index and the source vector to its callback. "
                  "Type the callback dynamically here; ArrayApi routes the call through the "
                  "existing ASVectorTools compatibility implementation.",
        "old": '\t\t\tcase "forEach": TTFun([TTFunction, tUntypedObject], TTVoid);',
        "new": '\t\t\tcase "forEach": TTFun([TTFunction, tUntypedObject], TTVoid);\n'
               '\t\t\tcase "filter": TTFun([TTFunction], TTVector(t));',
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ArrayApi.hx",
        "reason": "OpenFL Vector.filter only invokes a unary callback. Route AS3 Vector.filter "
                  "through ASVectorTools, which preserves Flash's item/index/vector callback.",
        "old": '\t\t\t// Vector/Array.sort\n'
               '\t\t\tcase TECall(obj = {kind: TEField({kind: TOExplicit(dot, eVector = {type: TTVector(_) | TTArray(_)})}, "sort", _)}, args):',
        "new": '\t\t\t// AS3 Vector.filter callback receives (item, index, vector); OpenFL only supplies item.\n'
               '\t\t\tcase TECall({kind: TEField({kind: TOExplicit(dot, eVector = {type: TTVector(_)})}, "filter", fieldToken)}, args)\n'
               '\t\t\t\t\tif (args.args.length == 1):\n'
               '\t\t\t\tvar tools = mkBuiltin("ASCompat.ASVectorTools", TTBuiltin, removeLeadingTrivia(eVector));\n'
               '\t\t\t\tvar method = mk(TEField({kind: TOExplicit(dot, tools), type: tools.type}, "filter", fieldToken), TTFunction, TTFunction);\n'
               '\t\t\t\te.with(kind = TECall(method, args.with(args = [\n'
               '\t\t\t\t\t{expr: eVector, comma: commaWithSpace}, args.args[0]\n'
               '\t\t\t\t])));\n\n'
               '\t\t\t// Vector/Array.sort\n'
               '\t\t\tcase TECall(obj = {kind: TEField({kind: TOExplicit(dot, eVector = {type: TTVector(_) | TTArray(_)})}, "sort", _)}, args):',
        "present": "// AS3 Vector.filter callback receives (item, index, vector)",
        "count": 1,
    },
])

# Full-client candidate: preserve the two E4X operations used by JSONEncoder's
# describeType walk. These belong in the shared E4X boundary, not in generated code.
PATCHES.extend([
    {
        "file": "compat/compat/XML.hx",
        "reason": "AS3 descendants('*') treats the asterisk as a wildcard; the compatibility tree must include every descendant, not search for a literal star element.",
        "old": '\t\t\tif (child.nodeName == name) {',
        "new": '\t\t\tif (name == "*" || child.nodeName == name) {',
        "count": 1,
    },
    {
        "file": "compat/compat/XMLList.hx",
        "reason": "Runtime half of JSONEncoder's normalized E4X predicate over describeType variable/accessor nodes.",
        "old": '\t#if flash inline #end\n\tpublic function attribute(name:String):String {',
        "new": '\t/** AS3 describeType query: descendants that are variables or readable accessors. */\n'
               '\tpublic function filterVariablesAndReadableAccessors():XMLList {\n'
               '\t\t#if flash\n'
               '\t\treturn [for (x in new std.NativeValueIterator<XML>(this))\n'
               '\t\t\tif (x.localName() == "variable" || (x.localName() == "accessor" && x.attribute("access").charAt(0) == "r")) x];\n'
               '\t\t#else\n'
               '\t\treturn [for (x in this)\n'
               '\t\t\tif (x.localName() == "variable" || (x.localName() == "accessor" && x.attribute("access").charAt(0) == "r")) x];\n'
               '\t\t#end\n'
               '\t}\n\n'
               '\t#if flash inline #end\n\tpublic function attribute(name:String):String {',
        "present": "public function filterVariablesAndReadableAccessors():XMLList",
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "Type the normalized XMLList describeType predicate as a zero-argument XMLList-returning compatibility method.",
        "old": '\t\t\tcase "filterAttributeEquals": TTFun([TTString, TTString], TTXMLList);',
        "new": '\t\t\tcase "filterAttributeEquals": TTFun([TTString, TTString], TTXMLList);\n'
               '\t\t\tcase "filterVariablesAndReadableAccessors": TTFun([], TTXMLList);',
        "present": 'case "filterVariablesAndReadableAccessors": TTFun([], TTXMLList);',
        "count": 1,
    },
])

# Full-client platform boundary. The original client reaches a handful of Flash-only
# reflection, GC, locale and decoded-audio APIs. Keep those call sites generated and
# translate only the platform operation at the converter/runtime boundary.
PATCHES.extend([
    {
        "file": "src/ax3/Filters.hx",
        "reason": "Run the tracked Flash-platform API rewrite after DateApi so generated client code stays faithful while browser operations terminate at ASCompat.",
        "old": "\t\t\tnew DateApi(context),\n\t\t\tnew ArrayApi(context),",
        "new": "\t\t\tnew DateApi(context),\n\t\t\tnew PlatformApi(context),\n\t\t\tnew ArrayApi(context),",
        "present": "\t\t\tnew PlatformApi(context),",
        "count": 1,
    },
    {
        "file": "compat/ASCompat.hx",
        "reason": "Provide the narrow browser/OpenFL implementations needed by the full-client candidate: describeType data discovery, an explicit no-op GC hint, native locale dates and WebAudio PCM extraction.",
        "old": "\tpublic static inline function registerClassAlias(aliasName:String, classObject:Any) {\n"
               "\t\tuntyped __global__[\"flash.net.registerClassAlias\"](aliasName, classObject);\n"
               "\t}\n"
               "\t#end\n\n"
               "\t// int(d), uint(d)",
        "new": "\tpublic static inline function registerClassAlias(aliasName:String, classObject:Any) {\n"
               "\t\tuntyped __global__[\"flash.net.registerClassAlias\"](aliasName, classObject);\n"
               "\t}\n"
               "\t#else\n"
               "\t/**\n"
               "\t\tBrowser replacement for Flash describeType.\n"
               "\n"
               "\t\tTwo callers need different halves of this document. JSONEncoder passes an instance and\n"
               "\t\treads the `<variable>` nodes. `ClassUtils.implementsInterface` passes a Class and reads\n"
               "\t\t`<factory><implementsInterface>`, which is how the client decides whether a message event\n"
               "\t\tclass is legal -- emitting only the first half made that check answer false for every\n"
               "\t\tclass, so `MessageClassManager` rejected the first message it was handed and aborted\n"
               "\t\t`HabboCommunicationManager.initComponent`, and with it the rest of the component graph.\n"
               "\n"
               "\t\tAS3 describes instance members under `<factory>` when handed a Class and directly under\n"
               "\t\t`<type>` when handed an instance, so the two cases stay apart rather than collapsing.\n"
               "\t**/\n"
               "\tpublic static function describeType(value:Any):com.sulake.core.utils.xml.XML {\n"
               "\t\tvar isClass = Std.isOfType(value, Class);\n"
               "\t\tvar cls:Class<Dynamic> = isClass ? cast value : Type.getClass(value);\n"
               "\t\tvar typeName = cls == null ? \"Object\" : Type.getClassName(cls);\n"
               "\t\tvar body = new StringBuf();\n"
               "\t\tif (!isClass) {\n"
               "\t\t\tvar names:Array<String> = [];\n"
               "\t\t\tfor (name in Reflect.fields(value)) if (names.indexOf(name) < 0) names.push(name);\n"
               "\t\t\tif (cls != null) for (name in Type.getInstanceFields(cls)) {\n"
               "\t\t\t\tif (names.indexOf(name) < 0) names.push(name);\n"
               "\t\t\t}\n"
               "\t\t\tfor (name in names) {\n"
               "\t\t\t\tvar member:Dynamic = null;\n"
               "\t\t\t\ttry member = Reflect.getProperty(value, name) catch (_:Dynamic) continue;\n"
               "\t\t\t\tif (!Reflect.isFunction(member)) {\n"
               "\t\t\t\t\tbody.add('<variable name=\"' + escapeXmlAttribute(name) + '\"/>');\n"
               "\t\t\t\t}\n"
               "\t\t\t}\n"
               "\t\t}\n"
               "\t\tvar interfaces = new StringBuf();\n"
               "\t\tfor (name in implementedInterfaceNames(cls)) {\n"
               "\t\t\tinterfaces.add('<implementsInterface type=\"' + escapeXmlAttribute(name) + '\"/>');\n"
               "\t\t}\n"
               "\t\tvar described = isClass\n"
               "\t\t\t? '<factory type=\"' + escapeXmlAttribute(getQualifiedClassName(value)) + '\">'\n"
               "\t\t\t\t+ interfaces.toString() + '</factory>'\n"
               "\t\t\t: interfaces.toString();\n"
               "\t\treturn new com.sulake.core.utils.xml.XML('<type name=\"' + escapeXmlAttribute(typeName)\n"
               "\t\t\t+ '\">' + body.toString() + described + '</type>');\n"
               "\t}\n"
               "\n"
               "\t/**\n"
               "\t\tEvery interface an instance of `cls` satisfies, spelled the way getQualifiedClassName\n"
               "\t\tspells them so both sides of an implementsInterface comparison agree.\n"
               "\n"
               "\t\tAS3 reports these transitively, so this walks the superclass chain and follows interface\n"
               "\t\tinheritance. The visited check removes duplicates and terminates diamonds.\n"
               "\t**/\n"
               "\tstatic function implementedInterfaceNames(cls:Class<Dynamic>):Array<String> {\n"
               "\t\tvar found:Array<String> = [];\n"
               "\t\tvar current = cls;\n"
               "\t\twhile (current != null) {\n"
               "\t\t\tcollectInterfaces(untyped current.__interfaces__, found);\n"
               "\t\t\tcurrent = Type.getSuperClass(current);\n"
               "\t\t}\n"
               "\t\treturn found;\n"
               "\t}\n"
               "\n"
               "\tstatic function collectInterfaces(list:Array<Dynamic>, found:Array<String>):Void {\n"
               "\t\tif (list == null) return;\n"
               "\t\tfor (item in list) {\n"
               "\t\t\tif (item == null) continue;\n"
               "\t\t\tvar name = getQualifiedClassName(item);\n"
               "\t\t\tif (found.indexOf(name) >= 0) continue;\n"
               "\t\t\tfound.push(name);\n"
               "\t\t\tcollectInterfaces(untyped item.__interfaces__, found);\n"
               "\t\t}\n"
               "\t}\n"
               "\n"
               "\tstatic function escapeXmlAttribute(value:String):String {\n"
               "\t\treturn StringTools.replace(StringTools.replace(StringTools.replace(\n"
               "\t\t\tStringTools.replace(value, \"&\", \"&amp;\"), \"\\\"\", \"&quot;\"), \"<\", \"&lt;\"), \">\", \"&gt;\");\n"
               "\t}\n\n"
               "\tpublic static function pauseForGCIfCollectionImminent(_:Float):Void {\n"
               "\t\t// Browsers intentionally expose no synchronous garbage-collection request.\n"
               "\t}\n\n"
               "\tpublic static function dateToLocaleString(value:Date):String {\n"
               "\t\treturn js.Syntax.code(\"{0}.toLocaleString()\", value);\n"
               "\t}\n\n"
               "\t/** Flash Sound.extract over Howler's decoded WebAudio buffer. */\n"
               "\tpublic static function extractSound(sound:Dynamic, output:Dynamic, length:Int, startPosition:Int = 0):Float {\n"
               "\t\t#if (js && html5)\n"
               "\t\tvar openflBuffer = Reflect.field(sound, \"__buffer\");\n"
               "\t\tvar howl = openflBuffer == null ? null : Reflect.getProperty(openflBuffer, \"src\");\n"
               "\t\tvar sounds:Dynamic = howl == null ? null : Reflect.field(howl, \"_sounds\");\n"
               "\t\tvar first:Dynamic = sounds == null || sounds.length == 0 ? null : sounds[0];\n"
               "\t\tvar node = first == null ? null : Reflect.field(first, \"_node\");\n"
               "\t\tvar decoded = node == null ? null : Reflect.field(node, \"buffer\");\n"
               "\t\tif (decoded == null) return 0;\n"
               "\t\tvar available:Int = Std.int(Reflect.field(decoded, \"length\")) - startPosition;\n"
               "\t\tvar frames = Std.int(Math.max(0, Math.min(length, available)));\n"
               "\t\tvar getChannel:Dynamic = Reflect.field(decoded, \"getChannelData\");\n"
               "\t\tvar left:Dynamic = Reflect.callMethod(decoded, getChannel, [0]);\n"
               "\t\tvar channelCount:Int = Std.int(Reflect.field(decoded, \"numberOfChannels\"));\n"
               "\t\tvar right:Dynamic = channelCount > 1 ? Reflect.callMethod(decoded, getChannel, [1]) : left;\n"
               "\t\tvar writeFloat:Dynamic = Reflect.field(output, \"writeFloat\");\n"
               "\t\tfor (index in 0...frames) {\n"
               "\t\t\tReflect.callMethod(output, writeFloat, [left[startPosition + index]]);\n"
               "\t\t\tReflect.callMethod(output, writeFloat, [right[startPosition + index]]);\n"
               "\t\t}\n"
               "\t\treturn frames;\n"
               "\t\t#else\n"
               "\t\treturn 0;\n"
               "\t\t#end\n"
               "\t}\n\n"
               "\t#end\n\n"
               "\t// int(d), uint(d)",
        "present": "public static function extractSound(sound:Dynamic, output:Dynamic, length:",
        "count": 1,
    },
])

PATCHES.extend([
    {
        "file": "src/ax3/Scanner.hx",
        "old": ("\tpublic function consume():Token {\n"
                "\t\tlastConsumedToken = lastToken;\n"
                "\t\tlastToken = null;\n"
                "\t\tlastMode = null;\n"
                "\t\treturn lastConsumedToken;\n"
                "\t}\n"),
        "new": ("\tpublic function consume():Token {\n"
                "\t\tlastConsumedToken = lastToken;\n"
                "\t\tlastToken = null;\n"
                "\t\tlastMode = null;\n"
                "\t\treturn lastConsumedToken;\n"
                "\t}\n\n"
                "\t/** Look through the current semicolon without changing scanner state. */\n"
                "\tpublic function semicolonFollowedByElse():Bool {\n"
                "\t\tvar savedPos = pos;\n"
                "\t\tvar savedLastPos = lastPos;\n"
                "\t\tvar savedLastToken = lastToken;\n"
                "\t\tvar savedLastMode = lastMode;\n"
                "\t\tvar savedLastConsumedToken = lastConsumedToken;\n"
                "\t\tvar result = false;\n"
                "\t\tif (advance().kind == TkSemicolon) {\n"
                "\t\t\tconsume();\n"
                "\t\t\tvar next = advance();\n"
                "\t\t\tresult = next.kind == TkIdent && next.text == \"else\";\n"
                "\t\t}\n"
                "\t\tpos = savedPos;\n"
                "\t\tlastPos = savedLastPos;\n"
                "\t\tlastToken = savedLastToken;\n"
                "\t\tlastMode = savedLastMode;\n"
                "\t\tlastConsumedToken = savedLastConsumedToken;\n"
                "\t\treturn result;\n"
                "\t}\n"),
        "present": "public function semicolonFollowedByElse():Bool",
        "count": 1,
    },
    {
        "file": "src/ax3/Parser.hx",
        "old": ("\t\tvar ethen = parseExpr(true);\n"
                "\t\tvar eelse = switch scanner.advance() {\n"
                "\t\t\tcase {kind: TkIdent, text: \"else\"}:\n"
                "\t\t\t\t{keyword: scanner.consume(), expr: parseExpr(true)};"),
        "new": ("\t\tvar ethen = parseExpr(true);\n"
                "\t\tvar branchSemicolon = scanner.semicolonFollowedByElse()\n"
                "\t\t\t? expectKind(TkSemicolon) : null;\n"
                "\t\tvar eelse = switch scanner.advance() {\n"
                "\t\t\tcase {kind: TkIdent, text: \"else\"}:\n"
                "\t\t\t\tvar elseKeyword = scanner.consume();\n"
                "\t\t\t\tif (branchSemicolon != null) {\n"
                "\t\t\t\t\telseKeyword.leadTrivia = branchSemicolon.leadTrivia\n"
                "\t\t\t\t\t\t.concat(branchSemicolon.trailTrivia).concat(elseKeyword.leadTrivia);\n"
                "\t\t\t\t}\n"
                "\t\t\t\t{keyword: elseKeyword, expr: parseExpr(true)};"),
        "present": "var branchSemicolon = scanner.semicolonFollowedByElse()",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteDelete.hx",
        "reason": "AS3 permits deleting a named property from a dynamic Object. Rewrite the field form through Reflect.deleteField just like the existing indexed-property form, while rejecting statically sealed receivers.",
        "old": ("\t\t\t\t\tcase TEArrayAccess(a) | TEParens(_, {kind: TEArrayAccess(a)}, _):\n"
                "\t\t\t\t\t\trewrite(keyword, a, eobj, e);\n\n"
                "\t\t\t\t\tcase _:\n"),
        "new": ("\t\t\t\t\tcase TEArrayAccess(a) | TEParens(_, {kind: TEArrayAccess(a)}, _):\n"
                "\t\t\t\t\t\trewrite(keyword, a, eobj, e);\n\n"
                "\t\t\t\t\tcase TEField({kind: TOExplicit(_, object)}, fieldName, fieldToken)\n"
                "\t\t\t\t\t\t| TEParens(_, {kind: TEField({kind: TOExplicit(_, object)}, fieldName, fieldToken)}, _):\n"
                "\t\t\t\t\t\trewriteField(keyword, object, fieldName, fieldToken, e);\n\n"
                "\t\t\t\t\tcase _:\n"),
        "present": "rewriteField(keyword, object, fieldName, fieldToken, e)",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteDelete.hx",
        "reason": "Emit named dynamic-property deletion as a Boolean Reflect.deleteField call and preserve the original delete expression's expected type.",
        "old": "\n\tfunction rewrite(deleteKeyword:Token, a:TArrayAccess, eDeleteObj:TExpr, eDelete:TExpr):TExpr {",
        "new": ("\n\tfunction rewriteField(deleteKeyword:Token, object:TExpr, fieldName:String, fieldToken:Token, eDelete:TExpr):TExpr {\n"
                "\t\treturn switch object.type {\n"
                "\t\t\tcase TTObject(_) | TTAny:\n"
                "\t\t\t\tvar name = mk(TELiteral(TLString(new Token(0, TkStringDouble, haxe.Json.stringify(fieldName),\n"
                "\t\t\t\t\tfieldToken.leadTrivia, fieldToken.trailTrivia))), TTString, TTString);\n"
                "\t\t\t\tvar eDeleteField = mkBuiltin(\"Reflect.deleteField\", tDeleteField, deleteKeyword.leadTrivia);\n"
                "\t\t\t\tmkCall(eDeleteField, [object, name], TTBoolean).with(expectedType = eDelete.expectedType);\n\n"
                "\t\t\tcase _:\n"
                "\t\t\t\tthrowError(exprPos(object), 'Cannot delete sealed field `$fieldName` from ${object.type.getName()}');\n"
                "\t\t}\n"
                "\t}\n\n"
                "\tfunction rewrite(deleteKeyword:Token, a:TArrayAccess, eDeleteObj:TExpr, eDelete:TExpr):TExpr {"),
        "present": "function rewriteField(deleteKeyword:Token, object:TExpr",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "AS3 permits Haxe-keyword member names such as SnowWar's `final` accessor. Escape generated property declarations consistently with package identifiers.",
        "old": "\t\t\t\tbuf.add(p.name);",
        "new": "\t\t\t\tbuf.add(PrinterBase.escapePathSegment(p.name));",
        "present": "emittedMemberName(owner, p.name, p.isStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword method names while retaining constructor spelling.",
        "old": "\t\t\t\tprintTextWithTrivia(if (isCtor) \"new\" else f.name, f.syntax.name);",
        "new": "\t\t\t\tprintTextWithTrivia(if (isCtor) \"new\" else PrinterBase.escapePathSegment(f.name), f.syntax.name);",
        "present": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Keep generated getter function names aligned with escaped Haxe property names.",
        "old": "\t\t\t\tprintTextWithTrivia(\"get_\" + f.name, f.syntax.name);",
        "new": "\t\t\t\tprintTextWithTrivia(\"get_\" + PrinterBase.escapePathSegment(f.name), f.syntax.name);",
        "present": "\"get_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Keep generated setter function names aligned with escaped Haxe property names.",
        "old": "\t\t\t\tprintTextWithTrivia(\"set_\" + f.name, f.syntax.name);",
        "new": "\t\t\t\tprintTextWithTrivia(\"set_\" + PrinterBase.escapePathSegment(f.name), f.syntax.name);",
        "present": "\"set_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword variable-field names at their declaration site.",
        "old": "\t\tprintTextWithTrivia(v.name, v.syntax.name);",
        "new": "\t\tprintTextWithTrivia(PrinterBase.escapePathSegment(v.name), v.syntax.name);",
        "present": "printTextWithTrivia(emittedMemberName(owner, v.name, isStatic), v.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword member names at every typed field access.",
        "old": "\t\tbuf.add(name);\n\t\tprintTrivia(token.trailTrivia);",
        "new": "\t\tbuf.add(PrinterBase.escapePathSegment(name));\n\t\tprintTrivia(token.trailTrivia);",
        "present": "buf.add(emittedMemberName(memberOwner, name, staticAccess));",
        "count": 1,
    },
    {
        "file": "src/ax3/PrinterBase.hx",
        "reason": "Normalize the first alphabetic character of decompiler package segments for Haxe without changing class or member names.",
        "old": ("\tpublic static function escapePathSegment(segment:String):String {\n"
                "\t\treturn if (RESERVED_PACKAGE_SEGMENTS.indexOf(segment) != -1) \"_\" + segment else segment;\n"
                "\t}\n\n"
                "\tfunction printDotPath(p:DotPath) {"),
        "new": ("\tpublic static function escapePathSegment(segment:String):String {\n"
                "\t\treturn if (RESERVED_PACKAGE_SEGMENTS.indexOf(segment) != -1) \"_\" + segment else segment;\n"
                "\t}\n\n"
                "\tpublic static function escapePackageSegment(segment:String):String {\n"
                "\t\tsegment = escapePathSegment(segment);\n"
                "\t\tvar firstLetter = ~/^([^A-Za-z]*)([A-Z])(.*)$/;\n"
                "\t\treturn if (firstLetter.match(segment))\n"
                "\t\t\tfirstLetter.matched(1) + firstLetter.matched(2).toLowerCase() + firstLetter.matched(3)\n"
                "\t\telse segment;\n"
                "\t}\n\n"
                "\tfunction printPackageDotPath(p:DotPath) {\n"
                "\t\tprintSeparated(p, t -> printTextWithTrivia(escapePackageSegment(t.text), t), t -> printDot(t));\n"
                "\t}\n\n"
                "\tfunction printDotPath(p:DotPath) {"),
        "present": "public static function escapePackageSegment(segment:String)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Print package declarations through package-specific normalization.",
        "old": "\t\t\tprintDotPath(p.syntax.name);",
        "new": "\t\t\tprintPackageDotPath(p.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Normalize every imported package segment, including names whose first letter follows an underscore.",
        "old": ("\t\t\t\t\tbuf.add(PrinterBase.escapePathSegment(\n"
                "\t\t\t\t\t\tpart.charAt(0).toLowerCase() + part.substring(1)));"),
        "new": "\t\t\t\t\tbuf.add(PrinterBase.escapePackageSegment(part));",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Normalize package segments in synthesized fully qualified type names.",
        "old": ("\tstatic function makeFQN(cls:TClassOrInterfaceDecl) {\n"
                "\t\tvar packName = cls.parentModule.parentPack.name;\n"
                "\t\treturn if (packName == \"\") cls.name else packName + \".\" + cls.name;\n"
                "\t}"),
        "new": ("\tstatic function makeFQN(cls:TClassOrInterfaceDecl) {\n"
                "\t\tvar packName = cls.parentModule.parentPack.name;\n"
                "\t\tvar haxePack = [for (part in packName.split(\".\")) PrinterBase.escapePackageSegment(part)].join(\".\");\n"
                "\t\treturn if (packName == \"\") cls.name else haxePack + \".\" + cls.name;\n"
                "\t}"),
        "present": "var haxePack = [for (part in packName.split(\".\")) PrinterBase.escapePackageSegment(part)]",
        "count": 1,
    },
    {
        "file": "src/ax3/Main.hx",
        "reason": "Write generated modules under the same normalized package directories printed in their declarations.",
        "old": "\t\t\t\tvar parts = [for (p in packName.split(\".\")) ax3.PrinterBase.escapePathSegment(p)];",
        "new": "\t\t\t\tvar parts = [for (p in packName.split(\".\")) ax3.PrinterBase.escapePackageSegment(p)];",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword local references while preserving their AS3 symbol binding.",
        "old": "\t\t\tcase TELocal(syntax, v): printTextWithTrivia(syntax.text, syntax);",
        "new": "\t\t\tcase TELocal(syntax, v): printTextWithTrivia(PrinterBase.escapePathSegment(syntax.text), syntax);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword local function names.",
        "old": "\t\tif (f.name != null) printTextWithTrivia(f.name.name, f.name.syntax);",
        "new": "\t\tif (f.name != null) printTextWithTrivia(PrinterBase.escapePathSegment(f.name.name), f.name.syntax);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword function argument names.",
        "old": "\t\t\t\t\tprintTextWithTrivia(arg.name, arg.syntax.name);",
        "new": "\t\t\t\t\tprintTextWithTrivia(PrinterBase.escapePathSegment(arg.name), arg.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword catch variable names in both generic and typed catch output.",
        "old": ("\t\t\t\tbuf.add(\"catch (__as3Caught:Dynamic) { var \" + c.v.name + \":ASError = ASError.caught(__as3Caught); \");\n"
                "\t\t\t\tprintExpr(c.expr);\n"
                "\t\t\t\tbuf.add(\" }\");"),
        "new": ("\t\t\t\tbuf.add(\"catch (__as3Caught:Dynamic) { var \" + PrinterBase.escapePathSegment(c.v.name) + \":ASError = ASError.caught(__as3Caught); \");\n"
                "\t\t\t\tprintExpr(c.expr);\n"
                "\t\t\t\tbuf.add(\" }\");"),
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword typed catch variable names.",
        "old": "\t\t\tprintTextWithTrivia(c.v.name, c.syntax.name);",
        "new": "\t\t\tprintTextWithTrivia(PrinterBase.escapePathSegment(c.v.name), c.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Escape Haxe-keyword local variable declarations.",
        "old": "\t\t\tprintTextWithTrivia(v.v.name, v.syntax.name);",
        "new": "\t\t\tprintTextWithTrivia(PrinterBase.escapePathSegment(v.v.name), v.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/TypedTreeTools.hx",
        "reason": "Treat side-effect-free binary expressions as repeatable so logical assignment can preserve indexed lvalues such as values[i + 1].",
        "old": "\t\t\tcase TEArrayAccess(a): canBeRepeated(a.eobj) && canBeRepeated(a.eindex);\n\n\t\t\tcase _: false;",
        "new": ("\t\t\tcase TEArrayAccess(a): canBeRepeated(a.eobj) && canBeRepeated(a.eindex);\n\n"
                "\t\t\t// Pure operators over repeatable operands remain repeatable. This matters for indexed\n"
                "\t\t\t// assignment rewrites such as values[i + 1] ||= fallback: evaluating the index twice\n"
                "\t\t\t// is faithful, while calls, increments, assignments and comma expressions stay rejected.\n"
                "\t\t\tcase TEBinop(a, OpAdd(_) | OpSub(_) | OpDiv(_) | OpMul(_) | OpMod(_)\n"
                "\t\t\t\t| OpEquals(_) | OpNotEquals(_) | OpStrictEquals(_) | OpNotStrictEquals(_)\n"
                "\t\t\t\t| OpGt(_) | OpGte(_) | OpLt(_) | OpLte(_) | OpIn(_)\n"
                "\t\t\t\t| OpAnd(_) | OpOr(_) | OpShl(_) | OpShr(_) | OpUshr(_)\n"
                "\t\t\t\t| OpBitAnd(_) | OpBitOr(_) | OpBitXor(_) | OpIs(_), b):\n"
                "\t\t\t\tcanBeRepeated(a) && canBeRepeated(b);\n\n"
                "\t\t\tcase _: false;"),
        "present": "// Pure operators over repeatable operands remain repeatable.",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteNewArray.hx",
        "reason": "Accept AS3's legal constructor form `new Array` without parentheses; only inspect arguments when a call-argument node exists.",
        "old": "\t\t\tcase TENew(keyword, TNType({type: TTArray(tElem)}), args) if (args.args.length > 0):",
        "new": "\t\t\tcase TENew(keyword, TNType({type: TTArray(tElem)}), args) if (args != null && args.args.length > 0):",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteDelete.hx",
        "reason": "Preserve AS3 Array deletion as a property deletion: keep the array length and create a hole instead of assigning null.",
        "old": ("\t\t\tcase [TTArray(_), TTInt | TTUint]:\n"
                "\t\t\t\treportError(exprPos(a.eindex), 'delete on array?');\n\n"
                "\t\t\t\tif (eDelete.expectedType == TTBoolean) {\n"
                "\t\t\t\t\tthrow \"TODO\"; // always true probably\n"
                "\t\t\t\t}\n\n"
                "\t\t\t\tprocessLeadingToken(function(t) {\n"
                "\t\t\t\t\tt.leadTrivia = deleteKeyword.leadTrivia.concat(t.leadTrivia);\n"
                "\t\t\t\t}, eDeleteObj);\n\n"
                "\t\t\t\tmk(TEBinop(eDeleteObj, OpAssign(new Token(0, TkEquals, \"=\", [], [])), mkNullExpr()), TTVoid, TTVoid);"),
        "new": ("\t\t\tcase [TTArray(_), TTInt | TTUint]:\n"
                "\t\t\t\t// AS3 delete removes the indexed property without compacting or shortening an Array.\n"
                "\t\t\t\t// Reflect.deleteField has the same JavaScript behavior; assigning null does not.\n"
                "\t\t\t\tvar eindex = a.eindex.with(expectedType = TTString);\n"
                "\t\t\t\tvar eDeleteField = mkBuiltin(\"Reflect.deleteField\", tDeleteField, deleteKeyword.leadTrivia);\n"
                "\t\t\t\tmkCall(eDeleteField, [a.eobj, eindex], TTBoolean).with(expectedType = eDelete.expectedType);"),
        "present": "// AS3 delete removes the indexed property without compacting or shortening an Array.",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/RewriteArrayAccess.hx",
        "reason": "Coerce Number indexes at the ByteArray boundary as AS3 does instead of rejecting valid expressions such as bytes[i / 2].",
        "old": ("\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}}), TTInt | TTUint | TTNumber]\n"
                "\t\t\t\t\t   | [TTObject(_), _]"),
        "new": ("\t\t\t\t\tcase [TTInst({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}}), TTNumber]:\n"
                "\t\t\t\t\t\t// ByteArray's AS3 indexed accessor coerces numeric positions to uint.\n"
                "\t\t\t\t\t\te.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex.with(expectedType = TTUint))));\n\n"
                "\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: \"ByteArray\", parentModule: {parentPack: {name: \"flash.utils\"}}}), TTInt | TTUint | TTNumber]\n"
                "\t\t\t\t\t   | [TTObject(_), _]"),
        "present": "// ByteArray's AS3 indexed accessor coerces numeric positions to uint.",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/DateApi.hx",
        "reason": "Accept AS3's legal `new Date` form without parentheses before mapping constructor arguments.",
        "old": "\t\t\t\targs = mapCallArgs(processExpr, args);",
        "new": "\t\t\t\tif (args != null) args = mapCallArgs(processExpr, args);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Retain the statement terminator between a non-block `if` branch and `else`; the parser consumes the AS3 semicolon to recognize the branch.",
        "old": ("\t\tprintExpr(i.ethen);\n"
                "\t\tif (i.eelse != null) {\n"
                "\t\t\tprintTextWithTrivia(\"else\", i.eelse.keyword);"),
        "new": ("\t\tprintExpr(i.ethen);\n"
                "\t\tif (i.eelse != null) {\n"
                "\t\t\tif (needsSemicolon(i.ethen)) buf.add(\";\");\n"
                "\t\t\tprintTextWithTrivia(\"else\", i.eelse.keyword);"),
        "count": 1,
    },
    {
        "file": "src/ax3/PrinterBase.hx",
        "reason": "Escape reserved member names separately from ordinary underscore-prefixed backing fields, so AS3 `get final()` cannot collide with `_final`.",
        "old": ("\tpublic static function escapePathSegment(segment:String):String {\n"
                "\t\treturn if (RESERVED_PACKAGE_SEGMENTS.indexOf(segment) != -1) \"_\" + segment else segment;\n"
                "\t}\n\n"
                "\tpublic static function escapePackageSegment"),
        "new": ("\tpublic static function escapePathSegment(segment:String):String {\n"
                "\t\treturn if (RESERVED_PACKAGE_SEGMENTS.indexOf(segment) != -1) \"_\" + segment else segment;\n"
                "\t}\n\n"
                "\t/** Member keywords need a distinct escape from ordinary `_name` backing fields. */\n"
                "\tpublic static function escapeMemberName(name:String):String {\n"
                "\t\treturn if (RESERVED_PACKAGE_SEGMENTS.indexOf(name) != -1) \"__as3_\" + name else name;\n"
                "\t}\n\n"
                "\tpublic static function escapePackageSegment"),
        "present": "public static function escapeMemberName(name:String):String",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape for properties, fields, methods, accessors and member references.",
        "old": "PrinterBase.escapePathSegment(p.name)",
        "new": "PrinterBase.escapeMemberName(p.name)",
        "present": "emittedMemberName(owner, p.name, p.isStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape for method declarations.",
        "old": "if (isCtor) \"new\" else PrinterBase.escapePathSegment(f.name)",
        "new": "if (isCtor) \"new\" else PrinterBase.escapeMemberName(f.name)",
        "present": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape for getter method declarations.",
        "old": "\"get_\" + PrinterBase.escapePathSegment(f.name)",
        "new": "\"get_\" + PrinterBase.escapeMemberName(f.name)",
        "present": "\"get_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape for setter method declarations.",
        "old": "\"set_\" + PrinterBase.escapePathSegment(f.name)",
        "new": "\"set_\" + PrinterBase.escapeMemberName(f.name)",
        "present": "\"set_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape for class variable declarations.",
        "old": "printTextWithTrivia(PrinterBase.escapePathSegment(v.name), v.syntax.name);",
        "new": "printTextWithTrivia(PrinterBase.escapeMemberName(v.name), v.syntax.name);",
        "present": "printTextWithTrivia(emittedMemberName(owner, v.name, isStatic), v.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the collision-safe member escape at every typed member access.",
        "old": "buf.add(PrinterBase.escapePathSegment(name));\n\t\tprintTrivia(token.trailTrivia);",
        "new": "buf.add(PrinterBase.escapeMemberName(name));\n\t\tprintTrivia(token.trailTrivia);",
        "present": "buf.add(emittedMemberName(memberOwner, name, staticAccess));",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Import the typed static-field predicate used by collision-safe member output.",
        "old": "import ax3.TypedTreeTools.exprPos;\nimport ax3.TypedTreeTools.skipParens;",
        "new": "import ax3.TypedTreeTools.exprPos;\nimport ax3.TypedTreeTools.isFieldStatic;\nimport ax3.TypedTreeTools.skipParens;",
        "present": "import ax3.TypedTreeTools.isFieldStatic;",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Detect AS3's separate static and instance member namespaces and assign only the static side a stable Haxe name.",
        "old": "\tfunction printHaxeProperty(f:TClassField) {",
        "new": ("\tfunction rawFieldName(f:TClassField):String {\n"
                "\t\treturn switch f.kind {\n"
                "\t\t\tcase TFVar(v): v.name;\n"
                "\t\t\tcase TFFun(fun): fun.name;\n"
                "\t\t\tcase TFGetter(a) | TFSetter(a): a.name;\n"
                "\t\t};\n"
                "\t}\n\n"
                "\tfunction hasStaticInstanceCollision(owner:TClassOrInterfaceDecl, name:String):Bool {\n"
                "\t\tvar hasStatic = false;\n"
                "\t\tvar hasInstance = false;\n"
                "\t\tfor (member in owner.members) switch member {\n"
                "\t\t\tcase TMField(field) if (rawFieldName(field) == name):\n"
                "\t\t\t\tif (isFieldStatic(field)) hasStatic = true else hasInstance = true;\n"
                "\t\t\tcase _:\n"
                "\t\t}\n"
                "\t\treturn hasStatic && hasInstance;\n"
                "\t}\n\n"
                "\tfunction emittedMemberName(owner:Null<TClassOrInterfaceDecl>, name:String, isStatic:Bool):String {\n"
                "\t\tvar escaped = PrinterBase.escapeMemberName(name);\n"
                "\t\treturn owner != null && isStatic && hasStaticInstanceCollision(owner, name)\n"
                "\t\t\t? \"__as3_static_\" + escaped\n"
                "\t\t\t: escaped;\n"
                "\t}\n\n"
                "\tfunction printHaxeProperty(f:TClassField, ?owner:TClassOrInterfaceDecl) {"),
        "present": "function hasStaticInstanceCollision(owner:TClassOrInterfaceDecl, name:String):Bool",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Pass the declaring class into member emission so collision detection is consistent at declarations.",
        "old": "printClassField(c.name, f);",
        "new": "printClassField(c, f);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Carry owner/static context through property and field declaration output.",
        "old": ("\tfunction printClassField(className:String, f:TClassField) {\n"
                "\t\tprintHaxeProperty(f);"),
        "new": ("\tfunction printClassField(owner:TClassOrInterfaceDecl, f:TClassField) {\n"
                "\t\tvar className = owner.name;\n"
                "\t\tprintHaxeProperty(f, owner);"),
        "present": "function printClassField(owner:TClassOrInterfaceDecl, f:TClassField)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Carry owner/static context into class variable output while leaving module variables unchanged.",
        "old": ("\t\t\tcase TFVar(v):\n\t\t\t\tprintVarField(v);"),
        "new": ("\t\t\tcase TFVar(v):\n\t\t\t\tprintVarField(v, owner, isFieldStatic(f));"),
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Emit colliding static variable names through the same stable member-name function.",
        "old": ("function printVarField(v:TVarField) {\n"
                "\t\tif (v.isInline)"),
        "new": ("function printVarField(v:TVarField, ?owner:TClassOrInterfaceDecl, isStatic:Bool = false) {\n"
                "\t\tif (v.isInline)"),
        "present": "function printVarField(v:TVarField, ?owner:TClassOrInterfaceDecl, isStatic:Bool = false)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Resolve typed member-reference ownership so explicit and implicit static calls use the renamed collision side.",
        "old": "\t\tbuf.add(PrinterBase.escapeMemberName(name));",
        "new": ("\t\tvar memberOwner:Null<TClassOrInterfaceDecl> = null;\n"
                "\t\tvar staticAccess = false;\n"
                "\t\tswitch obj.kind {\n"
                "\t\t\tcase TOImplicitClass(c): memberOwner = c; staticAccess = true;\n"
                "\t\t\tcase TOImplicitThis(c): memberOwner = c;\n"
                "\t\t\tcase TOExplicit(_, e): switch e.type {\n"
                "\t\t\t\tcase TTStatic(c): memberOwner = c; staticAccess = true;\n"
                "\t\t\t\tcase TTInst(c): memberOwner = c;\n"
                "\t\t\t\tcase _:\n"
                "\t\t\t}\n"
                "\t\t}\n"
                "\t\tbuf.add(emittedMemberName(memberOwner, name, staticAccess));"),
        "present": "buf.add(emittedMemberName(memberOwner, name, staticAccess));",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Apply static/instance collision naming to property declarations.",
        "old": "buf.add(PrinterBase.escapeMemberName(p.name));",
        "new": "buf.add(emittedMemberName(owner, p.name, p.isStatic));",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Apply static/instance collision naming to method declarations.",
        "old": "if (isCtor) \"new\" else PrinterBase.escapeMemberName(f.name)",
        "new": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, isFieldStatic(f))",
        "present": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Apply static/instance collision naming to getter declarations.",
        "old": "\"get_\" + PrinterBase.escapeMemberName(f.name)",
        "new": "\"get_\" + emittedMemberName(owner, f.name, isFieldStatic(f))",
        "present": "\"get_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Apply static/instance collision naming to setter declarations.",
        "old": "\"set_\" + PrinterBase.escapeMemberName(f.name)",
        "new": "\"set_\" + emittedMemberName(owner, f.name, isFieldStatic(f))",
        "present": "\"set_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Apply static/instance collision naming to class variable declarations.",
        "old": "printTextWithTrivia(PrinterBase.escapeMemberName(v.name), v.syntax.name);",
        "new": "printTextWithTrivia(emittedMemberName(owner, v.name, isStatic), v.syntax.name);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Compute staticness before destructuring the class field so function/accessor payload variables cannot shadow it.",
        "old": ("\t\tvar className = owner.name;\n"
                "\t\tprintHaxeProperty(f, owner);"),
        "new": ("\t\tvar className = owner.name;\n"
                "\t\tvar fieldIsStatic = isFieldStatic(f);\n"
                "\t\tprintHaxeProperty(f, owner);"),
        "present": "var fieldIsStatic = isFieldStatic(f);",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the precomputed class-field staticness for method collision naming.",
        "old": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, isFieldStatic(f))",
        "new": "if (isCtor) \"new\" else emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the precomputed class-field staticness for getter collision naming.",
        "old": "\"get_\" + emittedMemberName(owner, f.name, isFieldStatic(f))",
        "new": "\"get_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "Use the precomputed class-field staticness for setter collision naming.",
        "old": "\"set_\" + emittedMemberName(owner, f.name, isFieldStatic(f))",
        "new": "\"set_\" + emittedMemberName(owner, f.name, fieldIsStatic)",
        "count": 1,
    },
])

PATCHES.append({
    "file": "src/ax3/filters/RewriteAssignOps.hx",
    "reason": "Apply AS3 ToInt32 semantics to compound bitwise assignments whose lvalue is dynamically typed.",
    "present": "dynamic bitwise assignment lvalue must be safe to repeat",
    "old": "\t\t\t// int/uint /= int/uint/Number",
    "new": '''\t\t\t// AS3 applies ToInt32 to dynamic operands of compound bitwise assignments.
\t\t\t// Haxe cannot apply the operator directly to ASAny, so spell out the read,
\t\t\t// coercion and assignment while retaining the original lvalue.
\t\t\tcase TEBinop(a = {type: TTAny}, OpAssignOp(aop = (AOpBitAnd(_) | AOpBitOr(_) | AOpBitXor(_)
\t\t\t\t| AOpShl(_) | AOpShr(_) | AOpUshr(_))), b):
\t\t\t\tif (!canBeRepeated(a)) throwError(exprPos(a), "dynamic bitwise assignment lvalue must be safe to repeat");
\t\t\t\tvar op:Binop = switch aop {
\t\t\t\t\tcase AOpBitAnd(t): OpBitAnd(t.clone());
\t\t\t\t\tcase AOpBitOr(t): OpBitOr(t.clone());
\t\t\t\t\tcase AOpBitXor(t): OpBitXor(t.clone());
\t\t\t\t\tcase AOpShl(t): OpShl(t.clone());
\t\t\t\t\tcase AOpShr(t): OpShr(t.clone());
\t\t\t\t\tcase AOpUshr(t): OpUshr(t.clone());
\t\t\t\t\tcase _: throw "assert";
\t\t\t\t}
\t\t\t\tvar leftSide = cloneExpr(a);
\t\t\t\tremoveLeadingTrivia(leftSide);
\t\t\t\tvar value = mk(TEBinop(leftSide.with(expectedType = TTInt), op,
\t\t\t\t\tb.with(expectedType = TTInt)), TTInt, TTAny);
\t\t\t\te.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

\t\t\t// int/uint /= int/uint/Number''',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteAssignOps.hx",
    "reason": "Rewrite dynamic prefix increment/decrement as a numeric read and assignment so coercion never replaces the lvalue.",
    "present": "dynamic prefix lvalue must be safe to repeat",
    "old": "\t\t\t// int/uint /= int/uint/Number",
    "new": '''\t\t\t// Prefix ++/-- over an untyped Array slot is likewise a numeric read followed
\t\t\t// by a write; coercing the lvalue itself produces an invalid assignment.
\t\t\tcase TEPreUnop(pre = (PreIncr(_) | PreDecr(_)), a = {type: TTAny}):
\t\t\t\tif (!canBeRepeated(a)) throwError(exprPos(a), "dynamic prefix lvalue must be safe to repeat");
\t\t\t\tvar leftSide = cloneExpr(a);
\t\t\t\tremoveLeadingTrivia(leftSide);
\t\t\t\tvar one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
\t\t\t\tvar op:Binop = switch pre {
\t\t\t\t\tcase PreIncr(t): OpAdd(t.clone());
\t\t\t\t\tcase PreDecr(t): OpSub(t.clone());
\t\t\t\t\tcase _: throw "assert";
\t\t\t\t}
\t\t\t\tvar value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
\t\t\t\te.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

\t\t\t// int/uint /= int/uint/Number''',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/ExprTyper.hx",
    "reason": "AS3 bitwise complement applies ToInt32 to its operand; type the operand as int rather than Number.",
    "old": "\t\t\tcase PreBitNeg(_): inType = TTNumber; outType = TTInt;",
    "new": "\t\t\tcase PreBitNeg(_): inType = TTInt; outType = TTInt;",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Expose OpenFL LoaderInfo.parameters through the Flash Object property-bag contract.",
    "old": "class ASCompat {\n",
    "new": "class ASCompat {\n\t/** OpenFL narrows LoaderInfo.parameters to Dynamic<String>; Flash exposes an Object property bag. */\n\tpublic static inline function loaderParameters(loader:Dynamic):ASObject {\n\t\treturn loader == null ? null : cast Reflect.field(loader, \"parameters\");\n\t}\n\n",
    "present": "function loaderParameters(loader:Dynamic):ASObject",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Recognize the Flash RegExp.exec result as the array-like match object needed by numeric capture access.",
    "old": "\tstatic function mkAccessorCall(eobj:TExpr, methodName:String, args:Array<TExpr>, ret:TType):TExpr {",
    "new": "\tstatic function isRegExpExec(e:TExpr):Bool {\n\t\treturn switch e.kind {\n\t\t\tcase TECall({kind: TEField({kind: TOExplicit(_, {type: TTRegExp})}, \"exec\", _)}, _): true;\n\t\t\tcase _: false;\n\t\t}\n\t}\n\n\tstatic function mkAccessorCall(eobj:TExpr, methodName:String, args:Array<TExpr>, ret:TType):TExpr {",
    "present": "static function isRegExpExec(e:TExpr):Bool",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Keep RegExp.exec capture indexes numeric instead of coercing them to Object property-name strings.",
    "old": "\t\t\t\tswitch [eobj.type, eindex.type] {\n\t\t\t\t\t// Haxe classes cannot implement [] access.",
    "new": "\t\t\t\tswitch [eobj.type, eindex.type] {\n\t\t\t\t\t// RegExp.exec is declared as Object by Flash, but its result is an\n\t\t\t\t\t// array-like match object. Numeric capture access must remain numeric;\n\t\t\t\t\t// OpenFL/JS also exposes the match's `index` property on that value.\n\t\t\t\t\tcase [TTObject(_), TTInt | TTUint | TTNumber] if (isRegExpExec(eobj)):\n\t\t\t\t\t\te.with(kind = TEArrayAccess(a.with(eobj = eobj,\n\t\t\t\t\t\t\teindex = eindex.with(expectedType = TTInt))));\n\n\t\t\t\t\t// Haxe classes cannot implement [] access.",
    "present": "case [TTObject(_), TTInt | TTUint | TTNumber] if (isRegExpExec(eobj)):",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Retain Flash TextFormat.display values across OpenFL, whose TextFormat surface omits that property.",
    "old": "\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "new": "\tpublic static inline function textFormatDisplay(format:Dynamic):Dynamic {\n\t\treturn format == null ? null : Reflect.field(format, \"display\");\n\t}\n\n\tpublic static inline function setTextFormatDisplay(format:Dynamic, value:Dynamic):Dynamic {\n\t\tif (format != null) Reflect.setField(format, \"display\", value);\n\t\treturn value;\n\t}\n\n\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "present": "function setTextFormatDisplay(format:Dynamic, value:Dynamic):Dynamic",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/DateApi.hx",
    "reason": "Route multi-argument AS3 Date construction through the browser adapter, including Flash's optional milliseconds argument.",
    "old": "\t\t\t\t\tcase _:\n\t\t\t\t\t\te;",
    "new": "\t\t\t\t\tcase {args: values} if (values.length >= 2):\n\t\t\t\t\t\tvar method = mkBuiltin(\"ASCompat.newDateWithMilliseconds\", TTFunction, keyword.leadTrivia);\n\t\t\t\t\t\te.with(kind = TECall(method, args), type = TTInst(dateCls));\n\t\t\t\t\tcase _: e;",
    "present": "case {args: values} if (values.length >= 2):",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Preserve Flash Date's seventh millisecond constructor argument across Haxe's six-argument Date API.",
    "old": "\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "new": "\t/** Flash Date's seventh constructor argument is milliseconds; Haxe stops at seconds. */\n\tpublic static function newDateWithMilliseconds(year:Dynamic, month:Dynamic, day:Dynamic = 1,\n\t\t\thour:Dynamic = 0, minute:Dynamic = 0, second:Dynamic = 0, millisecond:Dynamic = 0):Date {\n\t\tvar base = new Date(toInt(year), toInt(month), toInt(day), toInt(hour), toInt(minute), toInt(second));\n\t\treturn Date.fromTime(base.getTime() + toInt(millisecond));\n\t}\n\n\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "present": "function newDateWithMilliseconds(year:Dynamic, month:Dynamic, day:Dynamic = 1",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/NumberToInt.hx",
    "reason": "Preserve AS3 uint-to-int wraparound when a browser/OpenFL API narrows an unsigned value to Int.",
    "old": "\t\treturn switch [e.type, e.expectedType] {\n\t\t\tcase [TTNumber, TTInt | TTUint]:",
    "new": "\t\treturn switch [e.type, e.expectedType] {\n\t\t\tcase [TTUint, TTInt]:\n\t\t\t\tvar toInt = mkBuiltin(\"ASCompat.toInt\", TTFun([TTAny], TTInt), removeLeadingTrivia(e));\n\t\t\t\tmkCall(toInt, [e.with(expectedType = TTAny)]);\n\t\t\tcase [TTNumber, TTInt | TTUint]:",
    "present": "case [TTUint, TTInt]:",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/ExprTyper.hx",
    "reason": "Classify AS3 integer literals outside signed Int range as uint (or Number beyond uint) so browser API narrowing preserves wraparound.",
    "old": "\t\t\tcase LDecInt(t) | LHexInt(t): mk(TELiteral(TLInt(t)), TTInt, expectedType);",
    "new": '''\t\t\tcase LDecInt(t):
\t\t\t\tvar digits = t.text;
\t\t\t\twhile (digits.length > 1 && digits.charAt(0) == "0") digits = digits.substr(1);
\t\t\t\tif (digits == "") digits = "0";
\t\t\t\tvar type = digits.length < 10 || (digits.length == 10 && digits <= "2147483647") ? TTInt
\t\t\t\t\t: digits.length == 10 && digits <= "4294967295" ? TTUint : TTNumber;
\t\t\t\tmk(TELiteral(TLInt(t)), type, expectedType);
\t\t\tcase LHexInt(t):
\t\t\t\tvar digits = t.text.substr(2);
\t\t\t\twhile (digits.length > 1 && digits.charAt(0) == "0") digits = digits.substr(1);
\t\t\t\tvar type = digits.length < 8 || (digits.length == 8 && "01234567".indexOf(digits.charAt(0).toLowerCase()) >= 0)
\t\t\t\t\t? TTInt : digits.length <= 8 ? TTUint : TTNumber;
\t\t\t\tmk(TELiteral(TLInt(t)), type, expectedType);''',
    "present": "digits <= \"4294967295\" ? TTUint : TTNumber",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Bridge Flash Date.parse and ByteArray-to-ByteArray writes to their stricter browser/OpenFL APIs.",
    "old": "\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "new": "\tpublic static function dateParse(value:String):Float {\n\t\treturn Date.fromString(value).getTime();\n\t}\n\n\tpublic static function byteArrayWriteBytes(target:Dynamic, source:Dynamic,\n\t\t\toffset:Int = 0, length:Int = 0):Void {\n\t\tvar output:openfl.utils.ByteArray = cast target;\n\t\tvar input:openfl.utils.ByteArray = cast source;\n\t\toutput.writeBytes(input, offset, length);\n\t}\n\n\tpublic static inline function stringSearch(value:String, pattern:Dynamic):Int {",
    "present": "function byteArrayWriteBytes(target:Dynamic, source:Dynamic",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Route Sulake Map indexed assignments to the original generated setProperty Proxy override instead of requiring a renamed handwritten setValue seam.",
    "old": 'mkAccessorCall(processExpr(a.eobj), "setValue",',
    "new": 'mkAccessorCall(processExpr(a.eobj), "setProperty",',
    "present": 'mkAccessorCall(processExpr(a.eobj), "setProperty",',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/ExprTyper.hx",
    "reason": "Generated Map declares setProperty itself, so remove the synthetic setValue type that belonged to the retired handwritten port.",
    "old": '''\t\t// Patched for M2: see build-support/generation/patch-converter.py
\t\t//
\t\t// `Map` is a flash.utils.Proxy, so AS3 writes it as `map[key] = value` and the class
\t\t// declares only the flash_proxy setProperty override -- there is no ordinary method to
\t\t// call. Haxe has no Proxy and reserves array access for abstracts, so the port spells that
\t\t// override `setValue`, and a pre-conversion rule rewrites the indexed writes onto it.
\t\t// ax3 typechecks against the AS3 class and so has never heard of the name. Its companion
\t\t// `getValue` is a real AS3 method and needs no help.
\t\t//
\t\t// ax3 already special-cases this exact class in RewriteForIn, so keying on it here is
\t\t// consistent rather than novel.
\t\tif (fieldName == "setValue" && cls.name == "Map"
\t\t\t\t&& cls.parentModule.parentPack.name == "com.sulake.core.utils") {
\t\t\treturn TTFun([TTAny, TTAny], TTVoid);
\t\t}

\t\tif (fieldName == "toString") return TTFun([], TTString);''',
    "new": '''\t\t// Generated Sulake Map retains its authored setProperty method; normal field lookup owns it.
\t\tif (fieldName == "toString") return TTFun([], TTString);''',
    "present": "Generated Sulake Map retains its authored setProperty method",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/AddSuperCtorCall.hx",
    "reason": "An explicit AS3 super constructor call may be nested in try/catch. Search the whole constructor tree so the converter does not insert a second super() before it.",
    "old": '''\t\t\tcase _:
\t\t\t\treturn false;
\t\t}
\t}
}''',
    "new": '''\t\t\tcase _:
\t\t\t\tvar found = false;
\t\t\t\titerExpr(function(child) {
\t\t\t\t\tif (!found && hasSuperCall(child)) found = true;
\t\t\t\t}, e);
\t\t\t\treturn found;
\t\t}
\t}
}''',
    "present": "if (!found && hasSuperCall(child)) found = true",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteAssignOps.hx",
    "reason": "Rewrite discarded postfix increment/decrement over dynamic lvalues as a numeric read/write; coercing the lvalue itself emits an invalid assignment.",
    "old": "\n\t\t\t// int/uint /= int/uint/Number",
    "new": '''
\t\t\t// A discarded postfix result has the same write effect as the prefix form. Preserve
\t\t\t// postfix value semantics by refusing value-consuming sites until they have a dedicated
\t\t\t// temporary; statement sites need only perform the numeric read and write.
\t\t\tcase TEPostUnop(a = {type: TTAny}, post = (PostIncr(_) | PostDecr(_))) if (e.expectedType == TTVoid):
\t\t\t\tif (!canBeRepeated(a)) throwError(exprPos(a), "dynamic postfix lvalue must be safe to repeat");
\t\t\t\tvar leftSide = cloneExpr(a);
\t\t\t\tremoveLeadingTrivia(leftSide);
\t\t\t\tvar one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
\t\t\t\tvar op:Binop = switch post {
\t\t\t\t\tcase PostIncr(t): OpAdd(t.clone());
\t\t\t\t\tcase PostDecr(t): OpSub(t.clone());
\t\t\t\t\tcase _: throw "assert";
\t\t\t\t}
\t\t\t\tvar value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
\t\t\t\te.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

\t\t\t// int/uint /= int/uint/Number''',
    "present": "dynamic postfix lvalue must be safe to repeat",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteAssignOps.hx",
    "reason": "Preserve single evaluation for discarded dynamic postfix writes whose array index uses prefix increment/decrement.",
    "old": '\\t\\t\\t\\tif (!canBeRepeated(a)) throwError(exprPos(a), "dynamic postfix lvalue must be safe to repeat");',
    "new": '''\t\t\t\tif (!canBeRepeated(a)) {
\t\t\t\t\t// Evaluate a prefix-mutating array index exactly once, then use its
\t\t\t\t\t// updated value for the numeric slot write (for example a[++i]++).
\t\t\t\t\t// Calls and postfix-mutating indexes still need a true temporary.
\t\t\t\t\tvar split = switch a.kind {
\t\t\t\t\t\tcase TEArrayAccess(access = {eindex: {kind: TEPreUnop(_, indexTarget)}})
\t\t\t\t\t\t\t\tif (canBeRepeated(access.eobj) && canBeRepeated(indexTarget)):
\t\t\t\t\t\t\tvar indexStep = access.eindex.with(expectedType = TTVoid);
\t\t\t\t\t\t\tvar stable = a.with(kind = TEArrayAccess(access.with(eindex = cloneExpr(indexTarget))));
\t\t\t\t\t\t\t{indexStep: indexStep, stable: stable};
\t\t\t\t\t\tcase _: null;
\t\t\t\t\t};
\t\t\t\t\tif (split == null) throwError(exprPos(a), "dynamic postfix lvalue must be safe to repeat");
\t\t\t\t\tvar leftSide = cloneExpr(split.stable);
\t\t\t\t\tremoveLeadingTrivia(leftSide);
\t\t\t\t\tvar one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
\t\t\t\t\tvar op:Binop = switch post {
\t\t\t\t\t\tcase PostIncr(t): OpAdd(t.clone());
\t\t\t\t\t\tcase PostDecr(t): OpSub(t.clone());
\t\t\t\t\t\tcase _: throw "assert";
\t\t\t\t\t};
\t\t\t\t\tvar value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
\t\t\t\t\tvar assignment = mk(TEBinop(split.stable.with(expectedType = TTAny),
\t\t\t\t\t\tOpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value), TTAny, TTVoid);
\t\t\t\t\treturn mk(TEBlock({
\t\t\t\t\t\tsyntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
\t\t\t\t\t\texprs: [
\t\t\t\t\t\t\t{expr: split.indexStep, semicolon: mkSemicolon()},
\t\t\t\t\t\t\t{expr: assignment, semicolon: mkSemicolon()}
\t\t\t\t\t\t]
\t\t\t\t\t}), TTVoid, TTVoid);
\t\t\t\t}''',
    "present": "updated value for the numeric slot write",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteSwitch.hx",
    "reason": "Recognize braceless conditional break as an AS3 switch exit before fall-through expansion.",
    "old": '''\t\t\t\tfunction hasGuardedBreak(block:Array<TBlockExpr>):Bool {
\t\t\t\t\tif (block.length == 1) {''',
    "new": '''\t\t\t\tfunction hasGuardedBreak(block:Array<TBlockExpr>):Bool {
\t\t\t\t\tfunction branchEndsInBreak(expr:TExpr):Bool {
\t\t\t\t\t\treturn switch expr.kind {
\t\t\t\t\t\t\tcase TEBreak(_): true;
\t\t\t\t\t\t\tcase TEBlock(inner) if (inner.exprs.length > 0): branchEndsInBreak(inner.exprs[inner.exprs.length - 1].expr);
\t\t\t\t\t\t\tcase _: false;
\t\t\t\t\t\t};
\t\t\t\t\t}
\t\t\t\t\tif (block.length == 1) {''',
    "present": "function branchEndsInBreak(expr:TExpr):Bool",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteSwitch.hx",
    "reason": "Treat both braced and braceless conditional breaks as guarded switch exits.",
    "old": '''\t\t\t\t\t\t\tcase TEIf({eelse: null, ethen: {kind: TEBlock(inner)}})
\t\t\t\t\t\t\t\t\tif (inner.exprs.length > 0 && inner.exprs[inner.exprs.length - 1].expr.kind.match(TEBreak(_))):''',
    "new": '''\t\t\t\t\t\t\tcase TEIf({eelse: null, ethen: branch}) if (branchEndsInBreak(branch)):''',
    "present": "case TEIf({eelse: null, ethen: branch}) if (branchEndsInBreak(branch))",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ArrayApi.hx",
    "reason": "Route AS3 Array.filter through a helper that supplies item, index, and owner array.",
    "old": '\\n\\t\\t\\t// Vector/Array.sort',
    "new": '''
\t\t\t// AS3 Array.filter has the same three-argument callback contract as Vector.filter.
\t\t\tcase TECall({kind: TEField({kind: TOExplicit(dot, eArray = {type: TTArray(_)})}, "filter", fieldToken)}, args)
\t\t\t\t\tif (args.args.length == 1):
\t\t\t\tvar tools = mkBuiltin("ASCompat.ASArray", TTBuiltin, removeLeadingTrivia(eArray));
\t\t\t\tvar method = mk(TEField({kind: TOExplicit(dot, tools), type: tools.type}, "filter", fieldToken), TTFunction, TTFunction);
\t\t\t\te.with(kind = TECall(method, args.with(args = [
\t\t\t\t\t{expr: eArray, comma: commaWithSpace}, args.args[0]
\t\t\t\t])));

\t\t\t// Vector/Array.sort''',
    "present": "AS3 Array.filter has the same three-argument callback contract",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Implement AS3 Array.filter's three-argument callback contract on Haxe arrays.",
    "old": '\\n\\t/**\\n\\t\\tAS3\'s `Array.sortOn(fieldName, options)`.',
    "new": '''
\tpublic static function filter<T>(a:Array<T>, callback:(item:T, index:Int, array:Array<T>)->Bool):Array<T> {
\t\tvar result = new Array<T>();
\t\tfor (index in 0...a.length) if (callback(a[index], index, a)) result.push(a[index]);
\t\treturn result;
\t}

\t/**
\t\tAS3's `Array.sortOn(fieldName, options)`.''',
    "present": "callback:(item:T, index:Int, array:Array<T>)->Bool",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Flash Sound.extract accepts Number sample positions; coerce to integer only at the WebAudio indexing boundary.",
    "old": '''\tpublic static function extractSound(sound:Dynamic, output:Dynamic, length:Int, startPosition:Int = 0):Float {
\t\t#if (js && html5)
\t\tvar openflBuffer = Reflect.field(sound, "__buffer");''',
    "new": '''\tpublic static function extractSound(sound:Dynamic, output:Dynamic, length:Float, startPosition:Float = 0):Float {
\t\t#if (js && html5)
\t\tvar start = Std.int(startPosition);
\t\tvar openflBuffer = Reflect.field(sound, "__buffer");''',
    "present": "length:Float, startPosition:Float = 0",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Use the integer WebAudio start calculated from Flash's Number position.",
    "old": '''\t\tvar available:Int = Std.int(Reflect.field(decoded, "length")) - startPosition;''',
    "new": '''\t\tvar available:Int = Std.int(Reflect.field(decoded, "length")) - start;''',
    "present": "length\")) - start;",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Index decoded sound channels with the integer boundary position.",
    "old": '''\t\t\tReflect.callMethod(output, writeFloat, [left[startPosition + index]]);
\t\t\tReflect.callMethod(output, writeFloat, [right[startPosition + index]]);''',
    "new": '''\t\t\tReflect.callMethod(output, writeFloat, [left[start + index]]);
\t\t\tReflect.callMethod(output, writeFloat, [right[start + index]]);''',
    "present": "left[start + index]",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/GenHaxe.hx",
    "reason": "Map expression-level references to the AS3 root Error class onto the same ASError boundary used by signatures and catches.",
    "old": '''\n\t\t\tcase TEDeclRef(dotPath, c): printDotPath(dotPath);''',
    "new": '''
\t\t\tcase TEDeclRef(dotPath, {kind: TDClassOrInterface({parentModule: {parentPack: {name: ""}}, name: "Error"})}):
\t\t\t\t// Haxe's root Error name is not the AS3 Error class. Keep expression-level
\t\t\t\t// class references aligned with the ASError type mapping used in signatures.
\t\t\t\tprintTextWithTrivia("ASError", dotPath.first);

\t\t\tcase TEDeclRef(dotPath, c): printDotPath(dotPath);''',
    "present": "name: \"Error\"})}):\n\t\t\t\t// Haxe's root Error name",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Expose Flash Date.toLocaleDateString through the browser Date boundary.",
    "old": '''\tpublic static function dateToLocaleString(value:Date):String {
\t\treturn js.Syntax.code("{0}.toLocaleString()", value);
\t}
''',
    "new": '''\tpublic static function dateToLocaleString(value:Date):String {
\t\treturn js.Syntax.code("{0}.toLocaleString()", value);
\t}

\tpublic static function dateToLocaleDateString(value:Date):String {
\t\treturn js.Syntax.code("{0}.toLocaleDateString()", value);
\t}
''',
    "present": "public static function dateToLocaleDateString(value:Date):String",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/Filters.hx",
    "reason": "Materialize AS3 void calls as undefined when a surrounding expression consumes their value.",
    "old": '''\t\t\tnew ToString(context),
\t\t\tnew NamespacedToPublic(context),''',
    "new": '''\t\t\tnew ToString(context),
\t\t\tnew VoidValues(context),
\t\t\tnew NamespacedToPublic(context),''',
    "present": "new VoidValues(context)",
    "count": 1,
})


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Support Flash LoaderContext parameters writes and dynamic embedded-Class property reads at the platform boundary.",
    "old": '''\tpublic static inline function loaderParameters(loader:Dynamic):ASObject {
\t\treturn loader == null ? null : cast Reflect.field(loader, "parameters");
\t}
''',
    "new": '''\tpublic static inline function loaderParameters(loader:Dynamic):ASObject {
\t\treturn loader == null ? null : cast Reflect.field(loader, "parameters");
\t}

\tpublic static inline function setLoaderParameters(loader:Dynamic, value:Dynamic):Dynamic {
\t\tif (loader != null) Reflect.setField(loader, "parameters", value);
\t\treturn value;
\t}

\tpublic static inline function classProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}
''',
    "present": "public static inline function classProperty(owner:Dynamic, name:String):Dynamic",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/OpenFLArrayArguments.hx",
    "reason": "Supply Haxe/OpenFL's typed gradient arrays and URLRequestHeader array at their platform API boundaries.",
    "old": '''\n            case _: e;
        }
    }
}''',
    "new": '''
            case TECall(method = {kind: TEField(_, "beginGradientFill", _)}, args)
                    if (args.args.length >= 4):
                args.args[1].expr = args.args[1].expr.with(expectedType = TTArray(TTUint));
                args.args[2].expr = args.args[2].expr.with(expectedType = TTArray(TTNumber));
                args.args[3].expr = args.args[3].expr.with(expectedType = TTArray(TTInt));
                e.with(kind = TECall(method, args));

            case TEBinop(left = {kind: TEField({kind: TOExplicit(_, {type: TTInst({name: "URLRequest", parentModule: {parentPack: {name: "flash.net"}}})})},
                    "requestHeaders", _)}, assign = OpAssign(_), value):
                var dynamicValue = value.with(kind = TEHaxeRetype(value.with(expectedType = value.type)),
                    type = TTAny, expectedType = TTAny);
                e.with(kind = TEBinop(left, assign, dynamicValue));

            case _: e;
        }
    }
}''',
    "present": "case TEBinop(left = {kind: TEField({kind: TOExplicit(_, {type: TTInst({name: \"URLRequest\"",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/HaxeProperties.hx",
    "reason": "Route explicit this.property assignments inside an AS3 setter through the generated recursive setter, just like implicit-this assignments.",
    "old": '''\t\t\tvar funExpr = {
\t\t\t\tfunction rewriteReturns(e:TExpr):TExpr {''',
    "new": '''\t\t\tfunction isSelfPropertyObject(obj:TFieldObject):Bool {
\t\t\t\treturn switch obj.kind {
\t\t\t\t\tcase TOImplicitThis(_) | TOImplicitClass(_): true;
\t\t\t\t\tcase TOExplicit(_, {kind: TELiteral(TLThis(_))}): true;
\t\t\t\t\tcase _: false;
\t\t\t\t};
\t\t\t}

\t\t\tvar funExpr = {
\t\t\t\tfunction rewriteReturns(e:TExpr):TExpr {''',
    "present": "function isSelfPropertyObject(obj:TFieldObject):Bool",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/NumberToInt.hx",
    "reason": "AS3 coerces a dynamic value when it crosses an int/uint parameter or assignment boundary; make that coercion explicit for Haxe/JS.",
    "old": '''\t\treturn switch [e.type, e.expectedType] {
\t\t\tcase [TTUint, TTInt]:''',
    "new": '''\t\treturn switch [e.type, e.expectedType] {
\t\t\tcase [TTAny, TTInt | TTUint]:
\t\t\t\tvar name = e.expectedType == TTUint ? "ASCompat.toUInt" : "ASCompat.toInt";
\t\t\t\tvar coerce = mkBuiltin(name, TTFun([TTAny], e.expectedType), removeLeadingTrivia(e));
\t\t\t\tmkCall(coerce, [e.with(expectedType = TTAny)]);
\t\t\tcase [TTUint, TTInt]:''',
    "present": "case [TTAny, TTInt | TTUint]:",
    "count": 1,
})

PATCHES.extend([
    {
        "file": "src/ax3/filters/HaxeProperties.hx",
        "reason": "Pre-index getter types so a broad AS3 setter declared before its typed getter still emits one Haxe property type.",
        "old": '''\tvar currentClass:TClassOrInterfaceDecl;
\tvar currentProperties:Null<Map<String,THaxePropDecl>>;

\toverride function processClass(c:TClassOrInterfaceDecl) {
\t\tcurrentClass = c;
\t\tsuper.processClass(c);
\t\tcurrentClass = null;
\t\tcurrentProperties = null;
\t}''',
        "new": '''\tvar currentClass:TClassOrInterfaceDecl;
\tvar currentProperties:Null<Map<String,THaxePropDecl>>;
\tvar currentGetterTypes:Null<Map<String,TType>>;

\toverride function processClass(c:TClassOrInterfaceDecl) {
\t\tcurrentClass = c;
\t\tcurrentGetterTypes = new Map();
\t\tfor (member in c.members) {
\t\t\tswitch member {
\t\t\t\tcase TMField({kind: TFGetter(accessor)}):
\t\t\t\t\tcurrentGetterTypes.set(accessor.name, accessor.fun.sig.ret.type);
\t\t\t\tcase _:
\t\t\t}
\t\t}
\t\tsuper.processClass(c);
\t\tcurrentClass = null;
\t\tcurrentProperties = null;
\t\tcurrentGetterTypes = null;
\t}''',
        "present": "var currentGetterTypes:Null<Map<String,TType>>;",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/HaxeProperties.hx",
        "reason": "Resolve a broad setter return/property type from its getter regardless of declaration order.",
        "old": '''\t\tvar propertyType = currentProperties == null ? null : currentProperties[accessor.name];
\t\tvar returnType = propertyType != null && type == TTAny ? propertyType.type : type;''',
        "new": '''\t\tvar propertyType = currentProperties == null ? null : currentProperties[accessor.name];
\t\tvar getterType = currentGetterTypes == null ? null : currentGetterTypes[accessor.name];
\t\tvar returnType = type == TTAny
\t\t\t? (propertyType != null && propertyType.type != TTAny ? propertyType.type
\t\t\t\t: getterType != null ? getterType : type)
\t\t\t: type;''',
        "present": "var getterType = currentGetterTypes == null ? null : currentGetterTypes[accessor.name];",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/HaxeProperties.hx",
        "reason": "Use the getter-resolved type when the setter is the property declaration site.",
        "old": "var prop = addProperty(accessor.name, true, type, mods, leadToken, removeMetadata(field));",
        "new": "var prop = addProperty(accessor.name, true, returnType, mods, leadToken, removeMetadata(field));",
        "present": "var prop = addProperty(accessor.name, true, returnType, mods, leadToken, removeMetadata(field));",
        "count": 1,
    },
])

PATCHES.append({
    "file": "src/ax3/filters/HaxeProperties.hx",
    "reason": "Use the shared self-property test when lowering assignments in setters.",
    "old": "if (name == accessor.name && obj.kind.match(TOImplicitThis(_) | TOImplicitClass(_))):",
    "new": "if (name == accessor.name && isSelfPropertyObject(obj)):",
    "present": "if (name == accessor.name && isSelfPropertyObject(obj)):",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Route AS3 Object/Dynamic string-index assignments through one-evaluation property semantics.",
    "old": '''\n\t\t\tcase TEArrayAccess(a):''',
    "new": '''
\t\t\tcase TEBinop({kind: TEArrayAccess(a)}, OpAssign(_), evalue)
\t\t\t\t\tif (a.eobj.type.match(TTAny | TTObject(_)) && a.eindex.type == TTString):
\t\t\t\tmkCall(mkBuiltin("ASCompat.setDynamicProperty", TTFunction),
\t\t\t\t\t[processExpr(a.eobj), processExpr(a.eindex), processExpr(evalue)], TTAny)
\t\t\t\t\t.with(expectedType = e.expectedType);

\t\t\tcase TEArrayAccess(a):''',
    "present": "ASCompat.setDynamicProperty",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Read AS3 Object string indexes as dynamic properties instead of Haxe integer array indexes.",
    "old": '''\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTInt | TTUint | TTNumber]
\t\t\t\t\t   | [TTObject(_), _]''',
    "new": '''\t\t\t\t\tcase [TTObject(_), TTString]:
\t\t\t\t\t\tmkCall(eGetProperty, [eobj, eindex], TTAny).with(expectedType = e.expectedType);

\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTInt | TTUint | TTNumber]
\t\t\t\t\t   | [TTObject(_), _]''',
    "present": "case [TTObject(_), TTString]:",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Propagate an AS3 String context into both ternary branches so mixed String/numeric alternatives coerce before Haxe unification.",
    "old": '''\t\treturn switch e.kind {
\t\t\tcase TECall''',
    "new": '''\t\treturn switch e.kind {
\t\t\tcase TETernary(choice) if (e.expectedType == TTString):
\t\t\t\tvar whenTrue = processExpr(choice.ethen.with(expectedType = TTString));
\t\t\t\tvar whenFalse = processExpr(choice.eelse.with(expectedType = TTString));
\t\t\t\te.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
\t\t\tcase TECall''',
    "present": "case TETernary(choice) if (e.expectedType == TTString)",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Preserve AS3 dynamic string-index assignment as a property write returning the assigned value.",
    "old": '''\tpublic static inline function classProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}
''',
    "new": '''\tpublic static inline function classProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}

\tpublic static inline function setDynamicProperty(owner:Dynamic, name:String, value:Dynamic):Dynamic {
\t\tif (owner != null) Reflect.setProperty(owner, name, value);
\t\treturn value;
\t}
''',
    "present": "public static inline function setDynamicProperty(owner:Dynamic, name:String, value:Dynamic):Dynamic",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Use the recognized ASCompat boundary for dynamic Object string-index reads.",
    "old": 'static final eGetProperty = mkBuiltin("Reflect.getProperty",',
    "new": 'static final eGetProperty = mkBuiltin("ASCompat.getDynamicProperty",',
    "present": 'static final eGetProperty = mkBuiltin("ASCompat.getDynamicProperty",',
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Expose dynamic Object property reads through the recognized compatibility namespace.",
    "old": '''\tpublic static inline function setDynamicProperty(owner:Dynamic, name:String, value:Dynamic):Dynamic {
\t\tif (owner != null) Reflect.setProperty(owner, name, value);
\t\treturn value;
\t}
''',
    "new": '''\tpublic static inline function setDynamicProperty(owner:Dynamic, name:String, value:Dynamic):Dynamic {
\t\tif (owner != null) Reflect.setProperty(owner, name, value);
\t\treturn value;
\t}

\tpublic static inline function getDynamicProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}
''',
    "present": "public static inline function getDynamicProperty(owner:Dynamic, name:String):ASAny",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Propagate AS3 String concatenation into both operands before ternary unification.",
    "old": '''\t\treturn switch e.kind {
\t\t\tcase TETernary(choice)''',
    "new": '''\t\treturn switch e.kind {
\t\t\tcase TEBinop(left, op = OpAdd(_), right) if (left.type == TTString || right.type == TTString):
\t\t\t\tvar stringLeft = processExpr(left.with(expectedType = TTString));
\t\t\t\tvar stringRight = processExpr(right.with(expectedType = TTString));
\t\t\t\te.with(kind = TEBinop(stringLeft, op, stringRight));
\t\t\tcase TETernary(choice)''',
    "present": "case TEBinop(left, op = OpAdd(_), right) if (left.type == TTString || right.type == TTString)",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Carry an AS3 String expectation through parentheses before coercing a nested ternary.",
    "old": '''\t\treturn switch e.kind {
\t\t\tcase TEBinop(left''',
    "new": '''\t\treturn switch e.kind {
\t\t\tcase TEParens(open, inner, close) if (e.expectedType == TTString):
\t\t\t\te.with(kind = TEParens(open, processExpr(inner.with(expectedType = TTString)), close), type = TTString);
\t\t\tcase TEBinop(left''',
    "present": "case TEParens(open, inner, close) if (e.expectedType == TTString)",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Unify mixed String/numeric AS3 ternary branches directly; Haxe requires both alternatives to share a type.",
    "old": '''\t\treturn switch e.kind {
\t\t\tcase TEParens(open''',
    "new": '''\t\treturn switch e.kind {
\t\t\tcase TETernary(choice)
\t\t\t\t\tif ((choice.ethen.type == TTString && choice.eelse.type.match(TTInt | TTUint | TTNumber))
\t\t\t\t\t\t|| (choice.eelse.type == TTString && choice.ethen.type.match(TTInt | TTUint | TTNumber))):
\t\t\t\tvar whenTrue = choice.ethen.type == TTString ? choice.ethen : processExpr(choice.ethen.with(expectedType = TTString));
\t\t\t\tvar whenFalse = choice.eelse.type == TTString ? choice.eelse : processExpr(choice.eelse.with(expectedType = TTString));
\t\t\t\te.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
\t\t\tcase TEParens(open''',
    "present": "case TETernary(choice)\n\t\t\t\t\tif ((choice.ethen.type == TTString",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteHasOwnProperty.hx",
    "reason": "Route hasOwnProperty on dynamically typed AS3 objects through the runtime boundary.",
    "old": '''\t\t\t\t\t\t\tcase TTObject(_) | TTAny:
\t\t\t\t\t\t\t\treportError(exprPos(e), "untyped hasOwnProperty detected");
\t\t\t\t\t\t\t\te.with(kind = TECall(
\t\t\t\t\t\t\t\t\teField.with(kind = TEField(obj.with(kind = TOExplicit(dot, eobj)), "hasOwnProperty", fieldToken)),
\t\t\t\t\t\t\t\t\targs
\t\t\t\t\t\t\t\t));''',
    "new": '''\t\t\t\t\t\t\tcase TTObject(_) | TTAny:
\t\t\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.hasOwnProperty", TTFun([TTAny, TTAny], TTBoolean), removeLeadingTrivia(eobj));
\t\t\t\t\t\t\t\tvar property = args.args.length == 0
\t\t\t\t\t\t\t\t\t? mkCall(mkBuiltin("ASCompat.undefinedValue", TTFun([], TTAny)), [], TTAny)
\t\t\t\t\t\t\t\t\t: args.args[0].expr;
\t\t\t\t\t\t\t\tmkCall(method, [eobj.with(expectedType = TTAny), property.with(expectedType = TTAny)], TTBoolean)
\t\t\t\t\t\t\t\t\t.with(expectedType = e.expectedType);''',
    "present": 'var method = mkBuiltin("ASCompat.hasOwnProperty"',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/DateApi.hx",
    "reason": "Preserve the AS3 Date(value:*) constructor through a runtime coercion boundary.",
    "old": '''\t\t\t\t\t\t\tcase TTInt | TTUint | TTNumber:
\t\t\t\t\t\t\t\t// exactly what we want

\t\t\t\t\t\t\tcase other:''',
    "new": '''\t\t\t\t\t\t\tcase TTInt | TTUint | TTNumber:
\t\t\t\t\t\t\t\t// exactly what we want

\t\t\t\t\t\t\tcase TTAny | TTObject(_):
\t\t\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.dateFromValue", TTFun([TTAny], TTInst(dateCls)), removeLeadingTrivia(e));
\t\t\t\t\t\t\t\treturn mkCall(method, [arg.expr.with(expectedType = TTAny)], TTInst(dateCls)).with(expectedType = e.expectedType);

\t\t\t\t\t\t\tcase other:''',
    "present": 'var method = mkBuiltin("ASCompat.dateFromValue"',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/ArrayApi.hx",
    "reason": "Preserve AS3 Array.concat when the argument is dynamically typed and may be an array or scalar.",
    "old": '''\t\t\t\t\tcase _:
\t\t\t\t\t\treportError(exprPos(e), "Unhandled Array.concat() call (possibly untyped?). Leaving as is.");''',
    "new": '''\t\t\t\t\tcase [dynamicValue]:
\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.arrayConcat", TTFun([TTArray(TTAny), TTAny], TTArray(TTAny)), removeLeadingTrivia(eArray));
\t\t\t\t\t\tmkCall(method, [eArray.with(expectedType = TTArray(TTAny)), dynamicValue.expr.with(expectedType = TTAny)], TTArray(TTAny))
\t\t\t\t\t\t\t.with(expectedType = e.expectedType);

\t\t\t\t\tcase _:
\t\t\t\t\t\treportError(exprPos(e), "Unhandled Array.concat() call (possibly untyped?). Leaving as is.");''',
    "present": 'var method = mkBuiltin("ASCompat.arrayConcat"',
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Add browser runtime boundaries for dynamic own-property checks and Date construction.",
    "old": '''\tpublic static inline function getDynamicProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}
''',
    "new": '''\tpublic static inline function getDynamicProperty(owner:Dynamic, name:String):Dynamic {
\t\treturn owner == null ? null : Reflect.getProperty(owner, name);
\t}

\tpublic static inline function hasOwnProperty(owner:Dynamic, name:Dynamic):Bool {
\t\treturn owner != null && Reflect.hasField(owner, toString(name));
\t}

\tpublic static function dateFromValue(value:Dynamic):Date {
\t\t#if js
\t\treturn cast js.Syntax.code("new Date({0})", value);
\t\t#else
\t\treturn Date.fromTime(toNumber(value));
\t\t#end
\t}
''',
    "present": "public static function dateFromValue(value:Dynamic):Date",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Implement AS3 dynamic Array.concat without assuming whether the value is an array.",
    "old": '''\tpublic static inline function arraySetLength<T>(a:Array<T>, newLength:Int):Int {''',
    "new": '''\tpublic static function arrayConcat(source:Array<Dynamic>, value:Dynamic):Array<Dynamic> {
\t\tvar result = source.copy();
\t\tif (Std.isOfType(value, Array)) {
\t\t\tfor (item in (cast value : Array<Dynamic>)) result.push(item);
\t\t} else {
\t\t\tresult.push(value);
\t\t}
\t\treturn result;
\t}

\tpublic static inline function arraySetLength<T>(a:Array<T>, newLength:Int):Int {''',
    "present": "public static function arrayConcat(source:Array<Dynamic>",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Apply AS3 ToInt32 to Number and dynamic Array/Vector indexes without treating the supported coercion as fatal.",
    "old": '''\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTInt | TTUint | TTNumber]
\t\t\t\t\t   | [TTObject(_), _]
\t\t\t\t\t   :
\t\t\t\t\t\tif (eindex.type == TTNumber) reportError(exprPos(e), "Array access using Number index");
\t\t\t\t\t\te.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex)));''',
    "new": '''\t\t\t\t\tcase [TTArray(_) | TTVector(_), TTNumber]:
\t\t\t\t\t\te.with(kind = TEArrayAccess(a.with(eobj = eobj,
\t\t\t\t\t\t\teindex = eindex.with(expectedType = TTInt))));

\t\t\t\t\tcase [TTArray(_) | TTVector(_) | TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTInt | TTUint]
\t\t\t\t\t   | [TTObject(_), _]
\t\t\t\t\t   :
\t\t\t\t\t\te.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex)));''',
    "present": "case [TTArray(_) | TTVector(_), TTNumber]:",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "The converter already coerces dynamically typed Array indexes and dynamic object access correctly; do not fail the batch for that supported boundary.",
    "old": '''\t\t\t\t\tcase [TTArray(_) | TTVector(_), _]:
\t\t\t\t\t\treportError(exprPos(e), "Non-integer index used for array access on Array/Vector, coercing to Int");''',
    "new": '''\t\t\t\t\tcase [TTArray(_) | TTVector(_), _]:''',
    "present": '''case [TTArray(_) | TTVector(_), _]:
\t\t\t\t\t\te.with''',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteArrayAccess.hx",
    "reason": "Typed AS3 objects permit bracket property access; retain the existing ASAny reflection lowering without a fatal diagnostic.",
    "old": '''\t\t\t\t\t\tif (!eobj.type.match(TTAny)) {
\t\t\t\t\t\t\treportError(exprPos(e), "Dynamic array access?");
\t\t\t\t\t\t}
\t\t\t\t\t\tif (!eobj.type.match(TTAny)) {''',
    "new": '''\t\t\t\t\t\tif (!eobj.type.match(TTAny)) {''',
    "present": '''if (!eobj.type.match(TTAny)) {
\t\t\t\t\t\t\teobj = eobj.with(kind = TEHaxeRetype(eobj), type = TTAny);''',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteHasOwnProperty.hx",
    "reason": "AS3 class instances support own-property tests; use the same runtime reflection boundary as dynamic objects.",
    "old": '''\t\t\t\t\t\t\tcase TTInst(_):
\t\t\t\t\t\t\t\treportError(exprPos(e), "hasOwnProperty on class instance detected");
\t\t\t\t\t\t\t\te.with(kind = TECall(
\t\t\t\t\t\t\t\t\teField.with(kind = TEField(
\t\t\t\t\t\t\t\t\t\tobj.with(kind = TOExplicit(dot, eobj.with(kind = TEHaxeRetype(eobj), type = TTAny))),
\t\t\t\t\t\t\t\t\t\t"hasOwnProperty",
\t\t\t\t\t\t\t\t\t\tfieldToken
\t\t\t\t\t\t\t\t\t)),
\t\t\t\t\t\t\t\t\targs
\t\t\t\t\t\t\t\t));''',
    "new": '''\t\t\t\t\t\t\tcase TTInst(_):
\t\t\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.hasOwnProperty", TTFun([TTAny, TTAny], TTBoolean), removeLeadingTrivia(eobj));
\t\t\t\t\t\t\t\tvar property = args.args.length == 0
\t\t\t\t\t\t\t\t\t? mkCall(mkBuiltin("ASCompat.undefinedValue", TTFun([], TTAny)), [], TTAny)
\t\t\t\t\t\t\t\t\t: args.args[0].expr;
\t\t\t\t\t\t\t\tmkCall(method, [eobj.with(expectedType = TTAny), property.with(expectedType = TTAny)], TTBoolean)
\t\t\t\t\t\t\t\t\t.with(expectedType = e.expectedType);''',
    "present": 'case TTInst(_):\n\t\t\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.hasOwnProperty"',
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Clear the consumed expected type inside generated ASCompat coercion calls so the coercion pass cannot wrap its own argument recursively.",
    "old": '''\t\t\t\targs: [{expr: e, comma: null}],
\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))
\t\t\t}),
\t\t\ttype = t''',
    "new": '''\t\t\t\targs: [{expr: e.with(expectedType = e.type), comma: null}],
\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))
\t\t\t}),
\t\t\ttype = t''',
    "present": "args: [{expr: e.with(expectedType = e.type), comma: null}]",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Clear consumed String expectations inside generated numeric and XML string conversions so the pass cannot recursively convert its own receiver.",
    "old": '''\t\t\t\t\t\t\t\targs: [{expr: e, comma: null}],
\t\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))''',
    "new": '''\t\t\t\t\t\t\t\targs: [{expr: e.with(expectedType = e.type), comma: null}],
\t\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))''',
    "present": '''case [TTInt | TTUint | TTNumber | TTBoolean, TTString]:
\t\t\t\t\t\tvar eStdString = mkBuiltin("Std.string", tStdString, removeLeadingTrivia(e));
\t\t\t\t\t\te.with(
\t\t\t\t\t\t\tkind = TECall(eStdString, {
\t\t\t\t\t\t\t\topenParen: mkOpenParen(),
\t\t\t\t\t\t\t\targs: [{expr: e.with(expectedType = e.type), comma: null}]''',
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Clear consumed String expectations from XML receivers before emitting their toString call.",
    "old": '''\t\t\t\t\tcase [TTXML | TTXMLList, TTString]:
\t\t\t\t\t\tvar eToString = mk(TEField({kind: TOExplicit(mkDot(), e), type: e.type}, "toString", mkIdent("toString")), tToString, tToString);''',
    "new": '''\t\t\t\t\tcase [TTXML | TTXMLList, TTString]:
\t\t\t\t\t\tvar value = e.with(expectedType = e.type);
\t\t\t\t\t\tvar eToString = mk(TEField({kind: TOExplicit(mkDot(), value), type: value.type}, "toString", mkIdent("toString")), tToString, tToString);''',
    "present": "var value = e.with(expectedType = e.type);",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "AS3 concatenation applies String() to Boolean values just as it does to numbers.",
    "old": "case [TTInt | TTUint | TTNumber, TTString]:",
    "new": "case [TTInt | TTUint | TTNumber | TTBoolean, TTString]:",
    "present": "case [TTInt | TTUint | TTNumber | TTBoolean, TTString]:",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "Propagate String expectations in one traversal; remapping an already-mapped left-associated concatenation is exponential.",
    "old": '''\toverride function processExpr(e:TExpr):TExpr {
\t\te = mapExpr(processExpr, e);
\t\treturn switch e.kind {
\t\t\tcase TETernary(choice)
\t\t\t\t\tif ((choice.ethen.type == TTString && choice.eelse.type.match(TTInt | TTUint | TTNumber))
\t\t\t\t\t\t|| (choice.eelse.type == TTString && choice.ethen.type.match(TTInt | TTUint | TTNumber))):
\t\t\t\tvar whenTrue = choice.ethen.type == TTString ? choice.ethen : processExpr(choice.ethen.with(expectedType = TTString));
\t\t\t\tvar whenFalse = choice.eelse.type == TTString ? choice.eelse : processExpr(choice.eelse.with(expectedType = TTString));
\t\t\t\te.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
\t\t\tcase TEParens(open, inner, close) if (e.expectedType == TTString):
\t\t\t\te.with(kind = TEParens(open, processExpr(inner.with(expectedType = TTString)), close), type = TTString);
\t\t\tcase TEBinop(left, op = OpAdd(_), right) if (left.type == TTString || right.type == TTString):
\t\t\t\tvar stringLeft = processExpr(left.with(expectedType = TTString));
\t\t\t\tvar stringRight = processExpr(right.with(expectedType = TTString));
\t\t\t\te.with(kind = TEBinop(stringLeft, op, stringRight));
\t\t\tcase TETernary(choice) if (e.expectedType == TTString):
\t\t\t\tvar whenTrue = processExpr(choice.ethen.with(expectedType = TTString));
\t\t\t\tvar whenFalse = processExpr(choice.eelse.with(expectedType = TTString));
\t\t\t\te.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
\t\t\tcase TECall''',
    "new": '''\toverride function processExpr(e:TExpr):TExpr {
\t\t// Propagate String context before the generic child walk. Re-walking both
\t\t// sides after mapping makes long left-associated AS3 concatenations
\t\t// exponential (the VAST diagnostic string has hundreds of terms).
\t\tswitch e.kind {
\t\t\tcase TETernary(choice)
\t\t\t\t\tif ((choice.ethen.type == TTString && choice.eelse.type.match(TTInt | TTUint | TTNumber | TTBoolean))
\t\t\t\t\t\t|| (choice.eelse.type == TTString && choice.ethen.type.match(TTInt | TTUint | TTNumber | TTBoolean))):
\t\t\t\tvar whenTrue = choice.ethen.type == TTString ? processExpr(choice.ethen) : processExpr(choice.ethen.with(expectedType = TTString));
\t\t\t\tvar whenFalse = choice.eelse.type == TTString ? processExpr(choice.eelse) : processExpr(choice.eelse.with(expectedType = TTString));
\t\t\t\treturn e.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
\t\t\tcase TEParens(open, inner, close) if (e.expectedType == TTString):
\t\t\t\treturn e.with(kind = TEParens(open, processExpr(inner.with(expectedType = TTString)), close), type = TTString);
\t\t\tcase TEBinop(left, op = OpAdd(_), right) if (left.type == TTString || right.type == TTString):
\t\t\t\treturn e.with(kind = TEBinop(processExpr(left.with(expectedType = TTString)), op,
\t\t\t\t\tprocessExpr(right.with(expectedType = TTString))));
\t\t\tcase TETernary(choice) if (e.expectedType == TTString):
\t\t\t\treturn e.with(kind = TETernary(choice.with(
\t\t\t\t\tethen = processExpr(choice.ethen.with(expectedType = TTString)),
\t\t\t\t\teelse = processExpr(choice.eelse.with(expectedType = TTString)))), type = TTString);
\t\t\tcase _:
\t\t}
\t\te = mapExpr(processExpr, e);
\t\treturn switch e.kind {
\t\t\tcase TECall''',
    "present": "Re-walking both\n\t\t// sides after mapping makes long left-associated AS3 concatenations",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ToString.hx",
    "reason": "AS3 String(Array/Vector) joins its elements; make mixed array literals legal in Haxe string-concatenation contexts.",
    "old": '''\t\t\t\t\tcase [TTAny | TTObject(_), TTString]:
\t\t\t\t\t\te; // handled at run-time
''',
    "new": '''\t\t\t\t\tcase [TTAny | TTObject(_), TTString]:
\t\t\t\t\t\te; // handled at run-time

\t\t\t\t\tcase [TTArray(_) | TTVector(_), TTString]:
\t\t\t\t\t\tvar value = e.with(expectedType = e.type);
\t\t\t\t\t\tvar method = mkBuiltin("ASCompat.toString", TTFun([TTAny], TTString), removeLeadingTrivia(value));
\t\t\t\t\t\tmkCall(method, [value], TTString, removeTrailingTrivia(value));
''',
    "present": "case [TTArray(_) | TTVector(_), TTString]:",
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Expose reflected property reads as ASAny so generated dynamic iteration retains the AS3 abstract's typed keys iterator.",
    "old": "public static inline function getDynamicProperty(owner:Dynamic, name:String):Dynamic {",
    "new": "public static inline function getDynamicProperty(owner:Dynamic, name:String):ASAny {",
    "present": "public static inline function getDynamicProperty(owner:Dynamic, name:String):ASAny {",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/HaxeProperties.hx",
    "reason": "When an AS3 setter accepts * but its getter fixes the property type, retain the broad parameter while returning the getter type required by Haxe properties.",
    "old": '''\t\tvar arg = sig.args[0];
\t\tvar type = arg.type;
\t\tsig.ret = {
\t\t\ttype: type,''',
    "new": '''\t\tvar arg = sig.args[0];
\t\tvar type = arg.type;
\t\tvar propertyType = currentProperties == null ? null : currentProperties[accessor.name];
\t\tvar returnType = propertyType != null && type == TTAny ? propertyType.type : type;
\t\tsig.ret = {
\t\t\ttype: returnType,''',
    "present": "var returnType = type == TTAny",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/HaxeProperties.hx",
    "reason": "Apply the resolved Haxe property return type to generated setter returns and recursive setter calls.",
    "old": '''\t\t\tvar argLocal = mk(TELocal(mkIdent(arg.name, [whitespace]), arg.v), arg.v.type, arg.v.type);''',
    "new": '''\t\t\tvar argLocal = mk(TELocal(mkIdent(arg.name, [whitespace]), arg.v), arg.v.type, returnType);''',
    "present": "arg.v.type, returnType);",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/HaxeProperties.hx",
    "reason": "Use the resolved getter-backed property type for recursive setter calls.",
    "old": '''\t\t\t\t\t\t\tvar methodType = TTFun([type], type);
\t\t\t\t\t\t\tvar method = mk(TEField(obj, "set_" + name, token), methodType, methodType);
\t\t\t\t\t\t\tmkCall(method, [rewriteReturns(value)], type).with(expectedType = e.expectedType);''',
    "new": '''\t\t\t\t\t\t\tvar methodType = TTFun([type], returnType);
\t\t\t\t\t\t\tvar method = mk(TEField(obj, "set_" + name, token), methodType, methodType);
\t\t\t\t\t\t\tmkCall(method, [rewriteReturns(value)], returnType).with(expectedType = e.expectedType);''',
    "present": "var methodType = TTFun([type], returnType);",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/ArrayApi.hx",
    "reason": "Clear Flash's stale String expectation from Array.sortOn's String-or-Array field-name argument.",
    "old": '''\t\t\t\t\t\t\t{expr: eFieldName.expr, comma: commaWithSpace},''',
    "new": '''\t\t\t\t\t\t\t{expr: eFieldName.expr.with(expectedType = eFieldName.expr.type), comma: commaWithSpace},''',
    "present": "eFieldName.expr.with(expectedType = eFieldName.expr.type)",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/ArrayApi.hx",
    "reason": "Clear stale expected types from both arguments of the two-argument Array.sortOn rewrite.",
    "old": '''\t\t\t\t\t\te.with(kind = TECall(eMethod, args.with(args = [
\t\t\t\t\t\t\t{expr: eArray, comma: commaWithSpace}, eFieldName, eOptions''',
    "new": '''\t\t\t\t\t\te.with(kind = TECall(eMethod, args.with(args = [
\t\t\t\t\t\t\t{expr: eArray, comma: commaWithSpace},
\t\t\t\t\t\t\t{expr: eFieldName.expr.with(expectedType = eFieldName.expr.type), comma: eFieldName.comma},
\t\t\t\t\t\t\t{expr: eOptions.expr.with(expectedType = eOptions.expr.type), comma: eOptions.comma}''',
    "present": "eOptions.expr.with(expectedType = eOptions.expr.type)",
    "count": 1,
})

PATCHES.append({
    "file": "src/ax3/filters/RewriteAs.hx",
    "reason": "Preserve AS3 checked primitive `as` semantics. In particular, an absent Dictionary value `as String` is null; converting it with String(undefined) produces the literal 'undefined' and can make property-probing loops infinite.",
    "old": '''\t\t\t\t\tcase TTInt | TTUint | TTNumber | TTString | TTBoolean: // omg
\t\t\t\t\t\t// TODO: this is not correct: we need to actually check and return null here
\t\t\t\t\t\t//
\t\t\t\t\t\t// Patched for M2: see build-support/generation/patch-converter.py
\t\t\t\t\t\t// The cast below is emitted either way; only the error was stopping the
\t\t\t\t\t\t// batch. It differs from AS3 solely when the value is *not* of the named
\t\t\t\t\t\t// type -- AS3 yields null, the cast passes the value through. Every site
\t\t\t\t\t\t// in the avatar closure reads back a value the client itself stored with
\t\t\t\t\t\t// that type (`geometry[0] as Number`, `getValue("setid") as int`), so the
\t\t\t\t\t\t// failing branch is unreachable there. This is a known imprecision, not a
\t\t\t\t\t\t// claim of equivalence.

\t\t\t\t\t\tvar path, trail;
\t\t\t\t\t\tswitch (typeRef.syntax) {
\t\t\t\t\t\t\tcase TPath(dotPath):
\t\t\t\t\t\t\t\tpath = dotPath;
\t\t\t\t\t\t\t\tpath.first.leadTrivia = removeLeadingTrivia(eobj).concat(path.first.leadTrivia);
\t\t\t\t\t\t\t\ttrail = processDotPathTrailingToken(t -> t.removeTrailingTrivia(), path);
\t\t\t\t\t\t\tcase _:
\t\t\t\t\t\t\t\tthrow "asset";
\t\t\t\t\t\t};

\t\t\t\t\t\te.with(kind = TECast({
\t\t\t\t\t\t\tsyntax: {
\t\t\t\t\t\t\t\topenParen: mkOpenParen(),
\t\t\t\t\t\t\t\tcloseParen: mkCloseParen(trail),
\t\t\t\t\t\t\t\tpath: path
\t\t\t\t\t\t\t},
\t\t\t\t\t\t\texpr: eobj,
\t\t\t\t\t\t\ttype: typeRef.type
\t\t\t\t\t\t}));''',
    "new": '''\t\t\t\t\tcase TTInt | TTUint | TTNumber | TTString | TTBoolean:
\t\t\t\t\t\tvar methodName = switch typeRef.type {
\t\t\t\t\t\t\tcase TTInt: "asInt";
\t\t\t\t\t\t\tcase TTUint: "asUint";
\t\t\t\t\t\t\tcase TTNumber: "asNumber";
\t\t\t\t\t\t\tcase TTString: "asString";
\t\t\t\t\t\t\tcase TTBoolean: "asBoolean";
\t\t\t\t\t\t\tcase _: throw "primitive as";
\t\t\t\t\t\t};
\t\t\t\t\t\tvar method = mkBuiltin("ASCompat." + methodName, TTFunction, removeLeadingTrivia(e));
\t\t\t\t\t\te.with(kind = TECall(method, {
\t\t\t\t\t\t\topenParen: mkOpenParen(),
\t\t\t\t\t\t\targs: [{expr: eobj, comma: null}],
\t\t\t\t\t\t\tcloseParen: mkCloseParen(removeTrailingTrivia(e))
\t\t\t\t\t\t}));''',
    "present": 'var methodName = switch typeRef.type {',
    "count": 1,
})

PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": "Runtime half of checked primitive `as`: return the unchanged value only when it already has the requested AS3 primitive type, otherwise null.",
    "old": '''\tpublic static inline function as<T>(v:Dynamic, c:Class<T>):T {
\t\treturn flash.Lib.as(v, c);
\t}''',
    "new": '''\tpublic static inline function asString(value:Dynamic):String
\t\treturn typeOf(value) == "string" ? value : null;
\tpublic static inline function asNumber(value:Dynamic):Float
\t\treturn typeOf(value) == "number" ? value : null;
\tpublic static inline function asInt(value:Dynamic):Int
\t\treturn typeOf(value) == "number" && Math.isFinite(value) && value == Std.int(value)
\t\t\t&& value >= -2147483648.0 && value <= 2147483647.0 ? value : null;
\tpublic static inline function asUint(value:Dynamic):UInt
\t\treturn typeOf(value) == "number" && Math.isFinite(value) && value == Math.floor(value)
\t\t\t&& value >= 0 && value <= 4294967295.0 ? value : null;
\tpublic static inline function asBoolean(value:Dynamic):Bool
\t\treturn typeOf(value) == "boolean" ? value : null;

\tpublic static inline function as<T>(v:Dynamic, c:Class<T>):T {
\t\treturn flash.Lib.as(v, c);
\t}''',
    "present": 'public static inline function asString(value:Dynamic):String',
    "count": 1,
})


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": 'AS3 String.fromCharCode converts with ToUint16 and wraps; Haxe compiles its own to String.fromCodePoint on JS, which throws RangeError on the negative codes HabboCommunicationManager.getKeyValue counts down through.',
    "old": "\t/** AS3 String.split(separator, limit); Haxe's String.split omits `limit`. */\n",
    "new": '\t/**\n\t\tAS3\'s String.fromCharCode.\n\n\t\tAS3 converts every argument with ToUint16, so an out-of-range code wraps instead of\n\t\tfailing: `String.fromCharCode(-1)` is charCode 65535. Haxe compiles its own\n\t\tString.fromCharCode to String.fromCodePoint on JS, which throws RangeError on exactly those\n\t\tvalues. `HabboCommunicationManager.getKeyValue` depends on the wrap -- it builds obfuscated\n\t\tproperty names from `65290 - value + index--`, which counts down through zero -- so the\n\t\tdifference aborts the component graph before the client can connect.\n\n\t\tJavaScript\'s own String.fromCharCode applies the same ToUint16 conversion AS3 does, which\n\t\tmakes the native call the faithful one rather than a masked approximation.\n\t**/\n\tpublic static function stringFromCharCode(code:Int):String {\n\t\t#if flash\n\t\treturn String.fromCharCode(code);\n\t\t#else\n\t\treturn js.Syntax.code("String.fromCharCode({0})", code);\n\t\t#end\n\t}\n\n\t/** AS3 String.split(separator, limit); Haxe\'s String.split omits `limit`. */\n',
    "present": "public static function stringFromCharCode(",
    "count": 1,
})


PATCHES.extend([
    {
        "file": "compat/ASDictionary.hx",
        "reason": 'Flash normalises a Dictionary\'s non-object keys to property names, so d[10] and d["10"] are one slot; only object keys compare by identity. Map.setProperty writes int keys while its nextName is declared :String, so MessageClassManager.registerMessages reads every message id back as a string -- splitting the two rejected the first event class and aborted prepareCore with the rest of the component graph unbuilt.',
        "old": '\tpublic function new(weakKeys:Bool = false) {}\n',
        "new": '\tpublic function new(weakKeys:Bool = false) {}\n\n\t/**\n\t\tFlash stores a Dictionary\'s non-object keys the way an Object stores property names, so\n\t\t`d[10]` and `d["10"]` are one slot; only object keys compare by identity.\n\n\t\tThe client depends on this. `Map` is a Proxy: `setProperty` writes its table under the key\n\t\tit was given -- `HabboMessages` registers all 601 message ids as ints -- while `nextName` is\n\t\tdeclared `:String`, so AS3 coerces every key a `for..in` yields to its string form. The\n\t\toriginal `MessageClassManager.registerMessages` reads each event class back with that\n\t\tstring, which only finds anything because Flash normalises the two to one slot.\n\n\t\tReturns null for object keys, which keep the identity comparison.\n\t**/\n\tstatic inline function propertyKey(key:Dynamic):Null<String> {\n\t\tvar kind = js.Syntax.typeof(key);\n\t\treturn (kind == "string" || kind == "number" || kind == "boolean") ? Std.string(key) : null;\n\t}\n',
        "present": 'static inline function propertyKey(',
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
        "reason": 'Flash normalises a Dictionary\'s non-object keys to property names, so d[10] and d["10"] are one slot; only object keys compare by identity. Map.setProperty writes int keys while its nextName is declared :String, so MessageClassManager.registerMessages reads every message id back as a string -- splitting the two rejected the first event class and aborted prepareCore with the rest of the component graph unbuilt.',
        "old": '\tpublic function get(key:K):Null<V> {\n\t\tif (Std.isOfType(key, String)) {\n\t\t\tvar entry = strings.get(cast key);\n\t\t\treturn entry == null ? js.Syntax.code("undefined") : entry.value;\n\t\t}\n',
        "new": '\tpublic function get(key:K):Null<V> {\n\t\tvar name = propertyKey(key);\n\t\tif (name != null) {\n\t\t\tvar entry = strings.get(name);\n\t\t\treturn entry == null ? js.Syntax.code("undefined") : entry.value;\n\t\t}\n',
        "present": '\t\tvar name = propertyKey(key);\n\t\tif (name != null) {\n\t\t\tvar entry = strings.get(name);\n\t\t\treturn entry == null ? js.Syntax.code("undefined") : entry.value;',
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
        "reason": 'Flash normalises a Dictionary\'s non-object keys to property names, so d[10] and d["10"] are one slot; only object keys compare by identity. Map.setProperty writes int keys while its nextName is declared :String, so MessageClassManager.registerMessages reads every message id back as a string -- splitting the two rejected the first event class and aborted prepareCore with the rest of the component graph unbuilt.',
        "old": '\t\tif (Std.isOfType(key, String)) {\n\t\t\tvar entry = strings.get(cast key);\n\t\t\tif (entry == null) {\n\t\t\t\tentry = {key:key, value:value};\n\t\t\t\tstrings.set(cast key, entry);\n\t\t\t\tentries.push(entry);\n\t\t\t} else entry.value = value;\n\t\t\treturn value;\n\t\t}\n',
        "new": '\t\tvar name = propertyKey(key);\n\t\tif (name != null) {\n\t\t\tvar entry = strings.get(name);\n\t\t\tif (entry == null) {\n\t\t\t\tentry = {key:key, value:value};\n\t\t\t\tstrings.set(name, entry);\n\t\t\t\tentries.push(entry);\n\t\t\t} else entry.value = value;\n\t\t\treturn value;\n\t\t}\n',
        "present": 'strings.set(name, entry);',
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
        "reason": 'Flash normalises a Dictionary\'s non-object keys to property names, so d[10] and d["10"] are one slot; only object keys compare by identity. Map.setProperty writes int keys while its nextName is declared :String, so MessageClassManager.registerMessages reads every message id back as a string -- splitting the two rejected the first event class and aborted prepareCore with the rest of the component graph unbuilt.',
        "old": '\t\tif (Std.isOfType(key, String)) return strings.exists(cast key);\n',
        "new": '\t\tvar name = propertyKey(key);\n\t\tif (name != null) return strings.exists(name);\n',
        "present": 'if (name != null) return strings.exists(name);',
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
        "reason": 'Flash normalises a Dictionary\'s non-object keys to property names, so d[10] and d["10"] are one slot; only object keys compare by identity. Map.setProperty writes int keys while its nextName is declared :String, so MessageClassManager.registerMessages reads every message id back as a string -- splitting the two rejected the first event class and aborted prepareCore with the rest of the component graph unbuilt.',
        "old": '\t\tfor (index in 0...entries.length) if (js.Syntax.code("{0} === {1}", entries[index].key, key)) {\n',
        "new": '\t\t// Primitive-key removal reads the entry before deleting its lookup slot.\n\t\tvar name = propertyKey(key);\n\t\tif (name != null) {\n\t\t\t// Removed by reference: the entry still carries the key as first written, which for a\n\t\t\t// normalised key is not identical to the one it is being removed under.\n\t\t\tvar entry = strings.get(name);\n\t\t\tif (entry == null) return false;\n\t\t\tstrings.remove(name);\n\t\t\tentries.remove(entry);\n\t\t\treturn true;\n\t\t}\n\t\tfor (index in 0...entries.length) if (js.Syntax.code("{0} === {1}", entries[index].key, key)) {\n',
        "present": 'entries.remove(entry);',
        "count": 1,
    },
])


PATCHES.append({
    "file": "compat/ASCompat.hx",
    "reason": 'AS3 iterates a null collection zero times; with checkNullIteratee enabled the guard reproduces that language rule, so it must not report legitimate code. The upstream FIXME trace fires once per null loop into an already-flooded console.',
    "old": '\tpublic static inline function checkNullIteratee<T>(v:Null<T>, ?pos:haxe.PosInfos):Bool {\n\t\tif (v == null) {\n\t\t\treportNullIteratee(pos);\n\t\t\treturn false;\n\t\t}\n\t\treturn true;\n\t}\n',
    "new": '\t/**\n\t\tAS3 iterates a null collection zero times, so this guard reproduces a language rule\n\t\trather than catching a mistake -- `WindowController._children` is declared without an\n\t\tinitialiser in the original too. It stays silent for that reason: the upstream FIXME\n\t\ttrace fires on legitimate code, once per loop, into a console the component embed\n\t\tsystem already floods.\n\t**/\n\tpublic static inline function checkNullIteratee<T>(v:Null<T>, ?pos:haxe.PosInfos):Bool {\n\t\treturn v != null;\n\t}\n',
    "present": "return v != null;",
    "count": 1,
})


PATCHES.extend([
    {
        "file": "compat/ASCompat.hx",
        "reason": 'AS3 coerces an absent XMLList element (undefined) to a null String; calling toString on it throws instead, and XMLVariableParser reads k.child(KEY)[0] that way for keyless tokens.',
        "old": "\t/** AS3 String.split(separator, limit); Haxe's String.split omits `limit`. */\n",
        "new": "\t/**\n\t\tAS3's coercion of an XML or XMLList value to String.\n\n\t\tIndexing past the end of an XMLList yields `undefined` in AS3, and assigning that to a\n\t\tString gives null rather than failing -- `XMLVariableParser.parseVariableToken` reads\n\t\t`k.child(KEY)[0]` exactly that way for tokens that carry no key. Calling toString on\n\t\tthe absent element instead throws, and the throw escapes into the component graph.\n\n\t\tThese are the client's own XML classes, which is what the converter's TTXML/TTXMLList\n\t\tresolve to here -- not the compat abstracts.\n\t**/\n\tpublic static inline function xmlToString(value:Null<com.sulake.core.utils.xml.XML>):Null<String> {\n\t\treturn value == null ? null : value.toString();\n\t}\n\n\tpublic static inline function xmlListToString(value:Null<com.sulake.core.utils.xml.XMLList>):Null<String> {\n\t\treturn value == null ? null : value.toString();\n\t}\n\n\t/** AS3 String.split(separator, limit); Haxe's String.split omits `limit`. */\n",
        "present": "public static inline function xmlToString(",
        "count": 1,
    },
    {
        "file": "src/ax3/filters/ToString.hx",
        "reason": 'Route XML/XMLList to String coercion through the null-tolerant compat helpers so an absent element becomes null, as AS3 does, rather than throwing into the component graph.',
        "old": '\t\t\t\t\tcase [TTXML | TTXMLList, TTString]:\n\t\t\t\t\t\tvar value = e.with(expectedType = e.type);\n\t\t\t\t\t\tvar eToString = mk(TEField({kind: TOExplicit(mkDot(), value), type: value.type}, "toString", mkIdent("toString")), tToString, tToString);\n\t\t\t\t\t\tmkCall(eToString, [], TTString, removeTrailingTrivia(e));\n',
        "new": '\t\t\t\t\t// Patched for M2: see build-support/generation/patch-converter.py\n\t\t\t\t\t//\n\t\t\t\t\t// AS3 coerces an absent XMLList element to null instead of failing, so this\n\t\t\t\t\t// conversion has to tolerate null the same way.\n\t\t\t\t\tcase [TTXML | TTXMLList, TTString]:\n\t\t\t\t\t\tvar value = e.with(expectedType = e.type);\n\t\t\t\t\t\tvar name = switch value.type {\n\t\t\t\t\t\t\tcase TTXMLList: "ASCompat.xmlListToString";\n\t\t\t\t\t\t\tcase _: "ASCompat.xmlToString";\n\t\t\t\t\t\t};\n\t\t\t\t\t\tvar method = mkBuiltin(name, TTFun([value.type], TTString), removeLeadingTrivia(value));\n\t\t\t\t\t\tmkCall(method, [value], TTString, removeTrailingTrivia(e));\n',
        "present": "ASCompat.xmlListToString",
        "count": 1,
    },
])


PATCHES.append({
    "file": "compat/compat/RegExp.hx",
    "reason": 'AS3 patterns carry inline flags like (?i) that JavaScript rejects as an invalid group, and an inlined constructor lets Closure fold them into regex literals that fail at parse time, taking the whole release bundle down before lime loads.',
    "old": '\tpublic inline function new(pattern, options = "") {\n\t\tthis = new RegExpImpl(pattern, options);\n\t}\n',
    "new": '\tpublic inline function new(pattern, options = "") {\n\t\tthis = create(pattern, options);\n\t}\n\n\t/**\n\t\tAS3 patterns in this corpus carry inline flags -- `new RegExp("(?i).*[.](mp4|flv)")` --\n\t\twhich JavaScript\'s engine rejects as an invalid group. Lifting the leading flags into\n\t\treal flags keeps those patterns usable instead of throwing the moment they are built.\n\n\t\tIt also has to stay a real call rather than an inlined constructor. Closure folds an\n\t\tinlined `new RegExp("literal")` into a regex literal, and a literal is validated when\n\t\tthe script is parsed -- so a single unreachable video-ad pattern took down the whole\n\t\trelease bundle before `lime` could load, while the debug build ran fine because nothing\n\t\tever executed that line.\n\t**/\n\tstatic function create(pattern:Dynamic, options:String):RegExpImpl {\n\t\tif (!Std.isOfType(pattern, String)) return new RegExpImpl(pattern, options);\n\t\tvar text:String = cast pattern;\n\t\twhile (StringTools.startsWith(text, "(?")) {\n\t\t\tvar close = text.indexOf(")");\n\t\t\tif (close <= 2) break;\n\t\t\tvar flags = text.substring(2, close);\n\t\t\tvar letters = true;\n\t\t\tfor (index in 0...flags.length) {\n\t\t\t\tvar code = flags.charCodeAt(index);\n\t\t\t\tif (!((code >= 97 && code <= 122) || (code >= 65 && code <= 90))) letters = false;\n\t\t\t}\n\t\t\tif (!letters) break;\n\t\t\tfor (index in 0...flags.length) {\n\t\t\t\tvar flag = flags.charAt(index);\n\t\t\t\tif (options.indexOf(flag) == -1) options += flag;\n\t\t\t}\n\t\t\ttext = text.substring(close + 1);\n\t\t}\n\t\treturn new RegExpImpl(text, options);\n\t}\n',
    "present": "static function create(pattern:Dynamic",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/CoerceToBool.hx",
    "reason": 'ASAny overloads && and || to keep AS3 value semantics, but an operator overload is a static call whose arguments are all evaluated first, so `asset != null && asset.content` read a property off a null asset and threw where Flash short-circuits. Coerce each operand in boolean context so the binop compiles to a real Haxe &&.',
    "old": '\tpublic function coerce(e:TExpr):TExpr {\n\t\tif (e.kind.match(TEBinop(_, OpAnd(_) | OpOr(_), _))) {\n\t\t\t// inner expressions are already coerced, so we just need to fix the type for the binop\n\t\t\treturn e.with(type = TTBoolean);\n\t\t}\n',
    "new": '\tstatic final tToBool = TTFun([TTAny], TTBoolean);\n\n\t/**\n\t\tCoerce one operand of `&&`/`||` so the binop stays a real Haxe one.\n\n\t\tASAny overloads both operators to preserve AS3\'s value semantics, but an operator\n\t\toverload is a static call, and Haxe evaluates every argument before entering it. So\n\t\t`asset != null && asset.content` read `content` from a null asset -- the guard ran\n\t\tafter the thing it was guarding, and the resulting error aborted whatever operation\n\t\tit was part of. Flash stops at the first operand.\n\n\t\tCoercing each side restores the short-circuit, and leaves `&&` in value position to\n\t\tthe abstract, which is the only place its AS3 result semantics matter.\n\t**/\n\tfunction coerceOperand(e:TExpr):TExpr {\n\t\tif (e.type.match(TTBoolean)) return e;\n\t\treturn switch (e.type) {\n\t\t\tcase TTAny | TTObject(_):\n\t\t\t\tvar lead = removeLeadingTrivia(e);\n\t\t\t\tvar tail = removeTrailingTrivia(e);\n\t\t\t\tvar eToBool = mkBuiltin("ASCompat.toBool", tToBool, lead, []);\n\t\t\t\tmk(TECall(eToBool, {\n\t\t\t\t\topenParen: mkOpenParen(),\n\t\t\t\t\tcloseParen: mkCloseParen(tail),\n\t\t\t\t\targs: [{expr: e.with(expectedType = e.type), comma: null}],\n\t\t\t\t}), TTBoolean, TTBoolean);\n\t\t\tcase _:\n\t\t\t\tcoerce(e);\n\t\t}\n\t}\n\n\tpublic function coerce(e:TExpr):TExpr {\n\t\tswitch (e.kind) {\n\t\t\tcase TEBinop(a, op = OpAnd(_) | OpOr(_), b):\n\t\t\t\treturn e.with(kind = TEBinop(coerceOperand(a), op, coerceOperand(b)), type = TTBoolean);\n\t\t\tcase _:\n\t\t}\n',
    "present": "function coerceOperand(",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/filters/MathApi.hx",
    "reason": "AS3 Math.min/max accept a single argument and return it; Haxe requires two. "
              "Collapse the one-argument form in the converter instead of patching each client file.",
    "old": '\t\t\t\te.with(kind = TECall(eMethod, args), type = TTNumber);\n\n\t\t\tcase TECall(\n',
    "new": '\t\t\t\te.with(kind = TECall(eMethod, args), type = TTNumber);\n\n'
           '\t\t\t// AS3 Math.min/max accept one argument and return it. Haxe requires two.\n'
           '\t\t\tcase TECall(\n'
           '\t\t\t\t\t{kind: TEField({kind: TOExplicit(_,\n'
           '\t\t\t\t\t\t{kind: TEDeclRef(_, {kind: TDClassOrInterface({name: "Math", parentModule: {parentPack: {name: ""}}})})}\n'
           '\t\t\t\t\t)}, "min" | "max", _)}, args\n'
           '\t\t\t\t) if (args.args.length == 1):\n'
           '\t\t\t\tprocessExpr(args.args[0].expr).with(expectedType = e.expectedType);\n\n'
           '\t\t\tcase TECall(\n',
    "present": "AS3 Math.min/max accept one argument",
    "count": 1,
})


PATCHES.append({
    "file": "src/ax3/GenHaxe.hx",
    "reason": "AVM2 initializes classes on first use, but Haxe/JS eagerly runs static field "
              "initializers while loading the script. NineSplitSprite instantiates Flex bitmap "
              "embeds in those fields before OpenFL registers its default asset library, so mark "
              "the class for the generic one-shot deferred-static macro.",
    "old": '\t\tif (c.name == "Motions" && c.parentModule.parentPack.name == "com.sulake.core.window.motion")\n'
           '\t\t\tbuf.add("@:build(skyhaxe.assets.DeferredStaticMacro.build(\\"_Str_5307\\"))\\n");\n',
    "new": '\t\tif (c.name == "Motions" && c.parentModule.parentPack.name == "com.sulake.core.window.motion")\n'
           '\t\t\tbuf.add("@:build(skyhaxe.assets.DeferredStaticMacro.build(\\"_Str_5307\\"))\\n");\n'
           '\t\t// AVM2 initializes this class on first access, after the loader assets exist. Haxe/JS\n'
           '\t\t// otherwise executes its embedded-bitmap static initializers before OpenFL\'s preloader.\n'
           '\t\tif (c.name == "NineSplitSprite" && c.parentModule.parentPack.name == "onBoardingHcUi")\n'
           '\t\t\tbuf.add("@:build(skyhaxe.assets.DeferredStaticMacro.buildAll())\\n");\n',
    "present": "DeferredStaticMacro.buildAll()",
    "count": 1,
})


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--snapshot", action="store_true", help="Refresh archival patched-source copies after verifying/applying the reproducible patch set")
    args = ap.parse_args()

    applied, already, failed = 0, 0, []
    for relative, source in ADDITIONS.items():
        path = AX3 / relative
        content = (Path(__file__).resolve().parent / source).read_text(encoding="utf-8")
        if path.is_file() and path.read_text(encoding="utf-8") == content:
            continue
        if args.verify:
            failed.append(relative + ": tracked converter addition differs or is missing")
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8", newline="\n")
    for patch in PATCHES:
        path = AX3 / patch["file"]
        if not path.is_file():
            failed.append("{}: missing".format(patch["file"]))
            continue
        text = path.read_text(encoding="utf-8")
        if patch.get("present", patch["new"]) in text:
            already += 1
            continue
        legacy = patch.get("legacy")
        if legacy and legacy in text:
            if not args.verify:
                path.write_text(text.replace(legacy, patch["new"]), encoding="utf-8", newline="\n")
                applied += 1
            continue
        found = text.count(patch["old"])
        if found != patch["count"]:
            failed.append("{}: expected {} occurrence(s) of the patch target, found {}".format(
                patch["file"], patch["count"], found))
            continue
        if not args.verify:
            path.write_text(text.replace(patch["old"], patch["new"]), encoding="utf-8", newline="\n")
            applied += 1

    print("patches applied  :", applied)
    print("already present  :", already)
    if failed:
        print("FAILED:")
        for item in failed:
            print("   ", item)
        return 1
    if args.verify and applied == 0 and already != len(PATCHES):
        print("patch not fully present")
        return 1
    if args.snapshot:
        archive = Path(__file__).resolve().parent / "ax3-patched"
        for relative in sorted({patch["file"] for patch in PATCHES} | set(ADDITIONS)):
            target = archive / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes((AX3 / relative).read_bytes())
        print("Patched-source archive refreshed from verified converter sources")
    print("\nRebuild with: powershell -File build-support/generation/build-converter.ps1")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
