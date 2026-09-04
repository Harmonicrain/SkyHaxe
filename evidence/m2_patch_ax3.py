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
    python evidence/m2_patch_ax3.py            # apply
    python evidence/m2_patch_ax3.py --verify   # check the patch is present, change nothing
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path

AX3 = Path(__file__).resolve().parent.parent / ".toolchain/ax3"

PATCHES = [
    {
        "file": "compat/ASCompat.hx",
        "reason": "ax3 ships Array.sortOn as a Flash-only stub whose own TODO says it exists so JS compiles. It compiles and then throws on first use, and the converted RoomSpriteCanvas sorts its sprite list by depth every frame -- so the room rendered black. Implemented like the sortWithOptions helper beside it.",
        "old": "\tpublic static inline function sortOn<T>(a:Array<T>, fieldName:String, options:Int):Array<T> {\n\t\t// TODO: this will only work on Flash, but we need it to _compile_ on JS too for now, so `RectanglePacker` is not breaking the build :-P\n\t\treturn (cast a).sortOn(fieldName, options);\n\t}",
        "new": "\t/**\n\t\tAS3's `Array.sortOn(fieldName, options)`.\n\n\t\tUpstream ax3 ships this as a stub that calls through to the Flash-only method, with a TODO\n\t\tsaying it exists so JS *compiles*. It does compile, and then throws the moment it runs --\n\t\twhich is exactly what happened when the converted RoomSpriteCanvas took over the room: it\n\t\tsorts its sprite list by depth every frame, threw every frame, and the room stayed black.\n\n\t\tSame shape as sortWithOptions below, but ordering by a named field rather than by the\n\t\telements themselves. RETURNINDEXEDARRAY and UNIQUESORT change what the call returns, so\n\t\tthey are refused rather than quietly ignored.\n\t**/\n\tpublic static function sortOn<T>(a:Array<T>, fieldName:String, options:Int):Array<T> {\n\t\tif ((options & RETURNINDEXEDARRAY) != 0 || (options & UNIQUESORT) != 0) {\n\t\t\tthrow \"ASArray.sortOn: RETURNINDEXEDARRAY and UNIQUESORT are not implemented\";\n\t\t}\n\t\tvar numeric = (options & NUMERIC) != 0;\n\t\tvar descending = (options & DESCENDING) != 0;\n\t\tvar caseInsensitive = (options & CASEINSENSITIVE) != 0;\n\t\ta.sort(function(left, right) {\n\t\t\tvar lf = Reflect.getProperty(left, fieldName);\n\t\t\tvar rf = Reflect.getProperty(right, fieldName);\n\t\t\tvar result;\n\t\t\tif (numeric) {\n\t\t\t\tvar l:Float = lf == null ? 0 : cast lf;\n\t\t\t\tvar r:Float = rf == null ? 0 : cast rf;\n\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n\t\t\t} else {\n\t\t\t\tvar l = lf == null ? \"\" : Std.string(lf);\n\t\t\t\tvar r = rf == null ? \"\" : Std.string(rf);\n\t\t\t\tif (caseInsensitive) {\n\t\t\t\t\tl = l.toLowerCase();\n\t\t\t\t\tr = r.toLowerCase();\n\t\t\t\t}\n\t\t\t\tresult = l < r ? -1 : (l > r ? 1 : 0);\n\t\t\t}\n\t\t\treturn descending ? -result : result;\n\t\t});\n\t\treturn a;\n\t}",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "openfl spells Vector as `abstract Vector<T>(IVector<T>)` with no @:from for the underlying IVector, and Vector.convert is typed convert<T,U>(IVector<T>):IVector<U>. So its result cannot reach a Vector<T> parameter by unification or by a type hint -- IVector<Unknown> is a different type. AS3 `Vector.<T>(v)` is an unchecked runtime conversion and a Haxe cast is its exact equivalent, so the call is printed as one. The name stays Vector.convert everywhere in the typed tree; only the printed form changes.",
        "old": "\t\t\tcase (_.startsWith(\"Vector.\") => true):\n\t\t\t\timportVector();\n\t\t\t\tname;",
        "new": "\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n"
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
        "new": "\t\t\t\t\t\t\t// Patched for M2: a type parameter can be closed by the `>` of a `>=`. See evidence/m2_patch_ax3.py\n\t\t\t\t\t\t\tcase \"=\".code if (mode != MNoRightShift):\n\t\t\t\t\t\t\t\tpos++;\n\t\t\t\t\t\t\t\treturn mk(TkGtEquals);",
        "count": 1,
    },
    {
        "file": "compat/ASDictionary.hx",
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
               "evidence/m2_patch_ax3.py\n"
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
               "evidence/m2_patch_ax3.py\n"
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
        "new": '\t\t\t// Patched for M2: AS3 parseInt accepts a radix. See evidence/m2_patch_ax3.py\n'
               '\t\t\tcase "parseInt":  mk(TEBuiltin(i, "parseInt"), '
               'TTFun([TTString], TTInt, TRestSwc), expectedType);',
        "count": 1,
    },
    {
        "file": "src/ax3/ExprTyper.hx",
        "reason": "GenHaxe can only map an AS3 global after ExprTyper has classified it as a "
                  "builtin. Register isFinite and the three URI globals used by the corpus; "
                  "otherwise they remain unresolved local identifiers and bypass the mappings.",
        "old": '\t\t\tcase "isNaN": mk(TEBuiltin(i, "isNaN"), TTFun([TTNumber], TTBoolean), expectedType);',
        "new": '\t\t\tcase "isNaN": mk(TEBuiltin(i, "isNaN"), TTFun([TTNumber], TTBoolean), expectedType);\n'
               '\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n'
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
               '\t\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n'
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
        "new": "\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n"
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
               '\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n'
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
        "new": "\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n"
               "\t\tif (hasSuperCall(e)) {",
        "count": 1,
    },
    {
        "file": "src/ax3/GenHaxe.hx",
        "reason": "and emit it through the compat layer, because Std.parseInt has no radix "
                  "parameter -- mapping it directly would compile only for base 10 and silently "
                  "misread every colour and height-map value.",
        "old": '\t\t\tcase "parseInt": "Std.parseInt";',
        "new": '\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n'
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
        "legacy": "\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n"
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
        "new": "\t\t\t// Patched for M2: see evidence/m2_patch_ax3.py\n"
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
        "new": "\tpublic static inline function toInt(d:Dynamic):Int {\n"
               "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
               "\t\treturn Std.int(toNumber(d));\n\t\t#end\n\t}\n\n"
               "\t// uint(d). Keep this distinct from int(d): Haxe parses decimal literals above 0x7fffffff as\n"
               "\t// Float, while AS3 coerces them modulo 2^32. The JS bitwise conversion preserves those bits.\n"
               "\tpublic static inline function toUInt(d:Dynamic):UInt {\n"
               "\t\t#if flash\n\t\treturn d;\n\t\t#else\n"
               "\t\treturn cast (js.Syntax.code(\"Number({0}) >>> 0\", d));\n"
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
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--verify", action="store_true")
    args = ap.parse_args()

    applied, already, failed = 0, 0, []
    for patch in PATCHES:
        path = AX3 / patch["file"]
        if not path.is_file():
            failed.append("{}: missing".format(patch["file"]))
            continue
        text = path.read_text(encoding="utf-8")
        if patch["new"] in text:
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
    print("\nRebuild with:  powershell -File scripts/build-m2-converter.ps1")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
