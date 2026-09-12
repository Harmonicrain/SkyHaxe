package ax3.filters;

class ToString extends AbstractFilter {
	public static final tToString = TTFun([], TTString);
	static final tStdString = TTFun([TTAny], TTString);
	static final tToRadix = TTFun([TTNumber], TTString);

	override function processExpr(e:TExpr):TExpr {
		// Propagate String context before the generic child walk. Re-walking both
		// sides after mapping makes long left-associated AS3 concatenations
		// exponential (the VAST diagnostic string has hundreds of terms).
		switch e.kind {
			case TETernary(choice)
					if ((choice.ethen.type == TTString && choice.eelse.type.match(TTInt | TTUint | TTNumber | TTBoolean))
						|| (choice.eelse.type == TTString && choice.ethen.type.match(TTInt | TTUint | TTNumber | TTBoolean))):
				var whenTrue = choice.ethen.type == TTString ? processExpr(choice.ethen) : processExpr(choice.ethen.with(expectedType = TTString));
				var whenFalse = choice.eelse.type == TTString ? processExpr(choice.eelse) : processExpr(choice.eelse.with(expectedType = TTString));
				return e.with(kind = TETernary(choice.with(ethen = whenTrue, eelse = whenFalse)), type = TTString);
			case TEParens(open, inner, close) if (e.expectedType == TTString):
				return e.with(kind = TEParens(open, processExpr(inner.with(expectedType = TTString)), close), type = TTString);
			case TEBinop(left, op = OpAdd(_), right) if (left.type == TTString || right.type == TTString):
				return e.with(kind = TEBinop(processExpr(left.with(expectedType = TTString)), op,
					processExpr(right.with(expectedType = TTString))));
			case TETernary(choice) if (e.expectedType == TTString):
				return e.with(kind = TETernary(choice.with(
					ethen = processExpr(choice.ethen.with(expectedType = TTString)),
					eelse = processExpr(choice.eelse.with(expectedType = TTString)))), type = TTString);
			case _:
		}
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TECall({kind: TEField({kind: TOExplicit(_, eValue = {type: TTInt | TTUint | TTNumber | TTBoolean | TTAny | TTObject(_)})}, "toString", _)}, args = {args: []}):
				var eStdString = mkBuiltin("Std.string", tStdString, removeLeadingTrivia(eValue));
				e.with(kind = TECall(eStdString, args.with(args = [{expr: eValue, comma: null}])));

			case TECall({kind: TEField({kind: TOExplicit(_, eValue = {type: TTInt | TTUint | TTNumber})}, "toString", _)}, args = {args: [digitsArg] }):
				var eToRadix = mkBuiltin("ASCompat.toRadix", tToRadix, removeLeadingTrivia(eValue));
				e.with(kind = TECall(eToRadix, args.with(args = [{expr: eValue, comma: commaWithSpace}, digitsArg])));

			case _:
				// implicit to string coercions
				switch [e.type, e.expectedType] {
					case [TTString, TTString]:
						e; // ok

					case [TTAny | TTObject(_), TTString]:
						e; // handled at run-time

					case [TTArray(_) | TTVector(_), TTString]:
						var value = e.with(expectedType = e.type);
						var method = mkBuiltin("ASCompat.toString", TTFun([TTAny], TTString), removeLeadingTrivia(value));
						mkCall(method, [value], TTString, removeTrailingTrivia(value));

					case [TTInt | TTUint | TTNumber | TTBoolean, TTString]:
						var eStdString = mkBuiltin("Std.string", tStdString, removeLeadingTrivia(e));
						e.with(
							kind = TECall(eStdString, {
								openParen: mkOpenParen(),
								args: [{expr: e.with(expectedType = e.type), comma: null}],
								closeParen: mkCloseParen(removeTrailingTrivia(e))
							}),
							type = TTString
						);

					// Patched for M2: see evidence/m2_patch_ax3.py
					//
					// AS3 coerces an absent XMLList element to null instead of failing, so this
					// conversion has to tolerate null the same way.
					case [TTXML | TTXMLList, TTString]:
						var value = e.with(expectedType = e.type);
						var name = switch value.type {
							case TTXMLList: "ASCompat.xmlListToString";
							case _: "ASCompat.xmlToString";
						};
						var method = mkBuiltin(name, TTFun([value.type], TTString), removeLeadingTrivia(value));
						mkCall(method, [value], TTString, removeTrailingTrivia(e));

					// these are not really about "ToString", but I haven't found a better place to add them without introducing yet another filter
					// normally this can't happen in AS3, unless you do `for (var i:int in someObject)` then it can ¯\_(ツ)_/¯
					case [TTString, TTInt | TTUint]: mkCastCall("toInt", e, TTInt);
					case [TTString, TTNumber]: mkCastCall("toNumber", e, TTNumber);

					// Patched for M2: see evidence/m2_patch_ax3.py
					//
					// An untyped value used where AS3 expects a number is coerced by the VM.
					// RewriteArrayAccess marks such an index `expectedType = TTInt` but leaves the
					// expression untyped, so `offsets[indexes[i]]` -- indexes being a bare Array --
					// reaches Haxe as ASAny where Int is required. Make the coercion AS3 performs
					// implicit explicit.
					case [TTAny, TTInt | TTUint]: mkCastCall("toInt", e, TTInt);
					case [TTAny, TTNumber]: mkCastCall("toNumber", e, TTNumber);

					case [TTInst(_), TTInst(target)] if (determineCastKind(e.type, target).match(CKDowncast | CKUnknown)):
						e.with(kind = TECast({syntax: {path: {first: mkIdent(target.name), rest: []},
							openParen: mkOpenParen(), closeParen: mkCloseParen()},
							expr: e.with(expectedType = e.type), type: e.expectedType}), type = e.expectedType);

					case [_, TTString]:
						reportError(exprPos(e), "Unknown to string coercion (actual type is " + e.type + ")");
						e;

					case _:
						e;
				}
		}
	}

	static function mkCastCall(methodName:String, e:TExpr, t:TType):TExpr {
		var eCastMethod = mkBuiltin("ASCompat." + methodName, TTFunction, removeLeadingTrivia(e));
		return e.with(
			kind = TECall(eCastMethod, {
				openParen: mkOpenParen(),
				args: [{expr: e.with(expectedType = e.type), comma: null}],
				closeParen: mkCloseParen(removeTrailingTrivia(e))
			}),
			type = t
		);
	}
}
