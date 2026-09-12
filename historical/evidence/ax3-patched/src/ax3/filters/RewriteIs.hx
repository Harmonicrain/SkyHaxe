package ax3.filters;

class RewriteIs extends AbstractFilter {
	static final tStdIs = TTFun([TTAny, TTAny], TTBoolean);
	static final tIsFunction = TTFun([TTAny], TTBoolean);

	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TEBinop(a, OpIs(isToken), b):
				switch b.kind {
					case TEBuiltin(_, "uint"):
						mkCall(mkBuiltin("com.sulake.core.utils.ASNumericType.isUInt", tIsFunction), [a], TTBoolean).with(expectedType = e.expectedType);

					case TEBuiltin(_, "Function"):
						final isFunction = mkBuiltin("Reflect.isFunction", tIsFunction, removeLeadingTrivia(e));
						e.with(kind = TECall(isFunction, {
							openParen: mkOpenParen(),
							args: [{expr: a, comma: null}],
							closeParen: mkCloseParen(removeTrailingTrivia(e)),
						}));

					case TEBuiltin(objectToken, "Object"):
						// only `null` is failing the `is object` check, so we can convert this to `!= null`
						var neqToken = new Token(isToken.pos, TkExclamationEquals, "!=", isToken.leadTrivia, isToken.trailTrivia);
						var nullToken = new Token(objectToken.pos, TkIdent, "null", objectToken.leadTrivia, objectToken.trailTrivia);
						var nullExpr = mk(TELiteral(TLNull(nullToken)), TTAny, TTAny);
						e.with(kind = TEBinop(a, OpNotEquals(neqToken), nullExpr));

					case TEVector(_, elemType):
						var eIsVectorMethod = mkBuiltin("ASCompat.isVector", TTFunction, removeLeadingTrivia(e));
						e.with(kind = TECall(eIsVectorMethod, {
							openParen: mkOpenParen(),
							args: [
								{expr: a, comma: commaWithSpace},
								{expr: RewriteAs.mkVectorTypeCheckMacroArg(elemType), comma: null}
							],
							closeParen: mkCloseParen(removeTrailingTrivia(e))
						}));

					case TEBuiltin(_, "XML"):
						final isXML = mkBuiltin("ASCompat.isXML", tIsFunction, removeLeadingTrivia(e));
						e.with(kind = TECall(isXML, {
							openParen: mkOpenParen(),
							args: [{expr: a, comma: null}],
							closeParen: mkCloseParen(removeTrailingTrivia(e)),
						}));

					case TEDeclRef(_, {kind: TDClassOrInterface({name: "ByteArray", parentModule: {parentPack: {name: "flash.utils"}}})}):
						final isByteArray = mkBuiltin("ASCompat.isByteArray", tIsFunction, removeLeadingTrivia(e));
						e.with(kind = TECall(isByteArray, {
							openParen: mkOpenParen(),
							args: [{expr: a, comma: null}],
							closeParen: mkCloseParen(removeTrailingTrivia(e)),
						}));

					case _:
						final stdIs = mkBuiltin("Std.is", tStdIs, removeLeadingTrivia(e));
						e.with(kind = TECall(stdIs, {
							openParen: mkOpenParen(),
							args: [
								{expr: a, comma: commaWithSpace},
								{expr: b, comma: null},
							],
							closeParen: mkCloseParen(removeTrailingTrivia(e)),
						}));
				}
			case _:
				e;
		}
	}
}
