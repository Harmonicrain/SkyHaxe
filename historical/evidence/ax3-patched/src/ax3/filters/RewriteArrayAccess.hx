package ax3.filters;

import ax3.TypedTreeTools.tUntypedObject;

class RewriteArrayAccess extends AbstractFilter {
	static final eGetProperty = mkBuiltin("ASCompat.getDynamicProperty", TTFun([tUntypedObject, TTString], TTAny));
	static final eSetProperty = mkBuiltin("Reflect.setProperty", TTFun([tUntypedObject, TTString, TTAny], TTVoid));

	// Patched for M2: see evidence/m2_patch_ax3.py
	//
	// `Map` is a flash.utils.Proxy, so AS3 reads and writes it as `map[key]` and
	// `map[key] = value`, dispatching to the getProperty/setProperty overrides. Haxe has no Proxy
	// and reserves array access for abstracts, so generated Map exposes the original Proxy
	// override as an ordinary public setProperty method while getValue remains its authored API.
	//
	// Without this, the untyped fallback below turns `map[key]` into a reflective field lookup on
	// the Map object. That compiles, finds no such field, and returns null: every offset, alias
	// and part set read silently becomes nothing. It is the worst possible failure mode for a
	// port, so Map is handled explicitly here rather than left to the fallback.
	static function isWindowIterator(t:TType):Bool {
		return t.match(TTInst({name: "IIterator", parentModule: {parentPack: {name: "com.sulake.core.window.utils"}}}));
	}

	static function isSulakeMap(t:TType):Bool {
		return switch t {
			case TTInst({name: "Map", parentModule: {parentPack: {name: "com.sulake.core.utils"}}}): true;
			case _: false;
		}
	}

	static function isRegExpExec(e:TExpr):Bool {
		return switch e.kind {
			case TECall({kind: TEField({kind: TOExplicit(_, {type: TTRegExp})}, "exec", _)}, _): true;
			case _: false;
		}
	}

	static function mkAccessorCall(eobj:TExpr, methodName:String, args:Array<TExpr>, ret:TType):TExpr {
		var tMethod = TTFun([for (_ in args) TTAny], ret);
		var eMethod = mk(TEField({kind: TOExplicit(mkDot(), eobj), type: eobj.type}, methodName,
			mkIdent(methodName)), tMethod, tMethod);
		return mkCall(eMethod, args, ret);
	}

	override function processExpr(e:TExpr):TExpr {
		return switch e.kind {
			case TEBinop({kind: TEArrayAccess(a)}, OpAssign(_), value) if (isWindowIterator(a.eobj.type)):
				mkCall(mkBuiltin("com.sulake.core.utils.ASProxy.set", TTFun([TTAny, TTAny, TTAny], TTAny)), [processExpr(a.eobj), processExpr(a.eindex), processExpr(value)], TTAny).with(expectedType = e.expectedType);
			case TEArrayAccess(a) if (isWindowIterator(a.eobj.type)):
				mkCall(mkBuiltin("com.sulake.core.utils.ASProxy.get", TTFun([TTAny, TTAny], TTAny)), [processExpr(a.eobj), processExpr(a.eindex)], TTAny).with(expectedType = e.expectedType);
			// The assignment form must be caught above the recursion: once the left-hand side has
			// become a getValue call there is nothing left to assign to.
			case TEBinop({kind: TEArrayAccess(a)}, OpAssign(_), evalue) if (isSulakeMap(a.eobj.type)):
				mkAccessorCall(processExpr(a.eobj), "setProperty",
					[processExpr(a.eindex), processExpr(evalue)], TTVoid);
			case TEBinop({kind: TEArrayAccess(a)}, OpAssign(_), evalue)
					if (a.eobj.type.match(TTAny | TTObject(_)) && a.eindex.type == TTString):
				mkCall(mkBuiltin("ASCompat.setDynamicProperty", TTFunction),
					[processExpr(a.eobj), processExpr(a.eindex), processExpr(evalue)], TTAny)
					.with(expectedType = e.expectedType);

			case TEArrayAccess(a):
				var eobj = processExpr(a.eobj);
				var eindex = processExpr(a.eindex);

				switch [eobj.type, eindex.type] {
					// RegExp.exec is declared as Object by Flash, but its result is an
					// array-like match object. Numeric capture access must remain numeric;
					// OpenFL/JS also exposes the match's `index` property on that value.
					case [TTObject(_), TTInt | TTUint | TTNumber] if (isRegExpExec(eobj)):
						e.with(kind = TEArrayAccess(a.with(eobj = eobj,
							eindex = eindex.with(expectedType = TTInt))));

					// Haxe classes cannot implement [] access. E4X XMLList can: a numeric index
					// selects one XML node, so route it through the port's explicit `at` API.
					case [TTXML | TTXMLList, TTInt | TTUint | TTNumber]:
						mkAccessorCall(eobj, "at", [eindex], TTXML).with(expectedType = e.expectedType);

					case [TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTNumber]:
						// ByteArray's AS3 indexed accessor coerces numeric positions to uint.
						e.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex.with(expectedType = TTUint))));

					case [TTObject(_), TTString]:
						mkCall(eGetProperty, [eobj, eindex], TTAny).with(expectedType = e.expectedType);

					case [TTArray(_) | TTVector(_), TTNumber]:
						e.with(kind = TEArrayAccess(a.with(eobj = eobj,
							eindex = eindex.with(expectedType = TTInt))));

					case [TTArray(_) | TTVector(_) | TTInst({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}}), TTInt | TTUint]
					   | [TTObject(_), _]
					   :
						e.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex)));

					case [TTArray(_), TTString]:
						reportError(exprPos(e), "String index used for array access on Array. Did you mean to use Dictionary/Object? Falling back to reflection.");
						e.with(kind = TEArrayAccess({
							syntax: a.syntax,
							eobj: eobj.with(kind = TEHaxeRetype(eobj), type = TTAny),
							eindex: eindex
						}));

					case [TTVector(_), TTString]:
						throwError(exprPos(e), "String index used for array access on Vector. Reflection doesn't currently work consistently on this");
						// e.with(kind = TEArrayAccess({
						// 	syntax: a.syntax,
						// 	eobj: eobj.with(kind = TEHaxeRetype(eobj), type = TTAny),
						// 	eindex: eindex
						// }));

					case [TTArray(_) | TTVector(_), _]:
						e.with(kind = TEArrayAccess({
							syntax: a.syntax,
							eobj: eobj,
							eindex: eindex.with(expectedType = TTInt)
						}));

					case [TTDictionary(expectedKeyType, _), keyType]:
						switch [expectedKeyType, keyType] {
							case [TTAny, _] | [_, TTAny]: // oh well
							case [TTObject(TTAny), _]:
							case [TTClass, TTStatic(_)]: //allowed
							case _:
								if (!typeEq(expectedKeyType, keyType)) {
									reportError(exprPos(e), 'Invalid dictionary key type, expected $expectedKeyType, got $keyType');
								}
						}
						e.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex)));

					case [t, _] if (isSulakeMap(t)):
						mkAccessorCall(eobj, "getValue", [eindex], TTAny);

					// Patched for M2: see evidence/m2_patch_ax3.py
					// `node["set"]` is E4X for `node.child("set")` -- the same element query the
					// dot form does, spelled so the name can be a value. The XMLList case above
					// already handles a numeric index, so only the string form lands here.
					case [TTXML, TTString]:
						mkAccessorCall(eobj, "child", [eindex], TTXMLList);

					case _:
						// Patched for M2: see evidence/m2_patch_ax3.py
						// An index into something already typed TTAny is what ASAny's @:op([])
						// overloads exist for, so the fallback below is right and the error is
						// noise. Any other type still stops the batch: `Map` in particular must
						// become getValue/setProperty, and reflecting on it would compile and
						// silently return null.
						if (!eobj.type.match(TTAny)) {
							eobj = eobj.with(kind = TEHaxeRetype(eobj), type = TTAny);
						}
						e.with(kind = TEArrayAccess(a.with(eobj = eobj, eindex = eindex)));
				}

			case _:
				mapExpr(processExpr, e);
		}
	}

}
