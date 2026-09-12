package ax3.filters;

class FixNonInlineableDefaultArgs extends AbstractFilter {
	override function processFunction(fun:TFunction) {
		// Patched for M2: an interface has no body, but its defaults still need rewriting.
		var initExprs = [];
		var indent = if (fun.expr == null) [] else getInnerIndent(fun.expr);
		for (arg in fun.sig.args) {
			switch arg.kind {
				// Patched for M2: NaN is a builtin, not a static field, and is not a Haxe constant.
				case TArgNormal(type, init = {expr: {kind: TEBuiltin(_, "NaN")}}):
					// An interface method has no body and no local for the argument, so there is
					// nothing to move the assignment into -- only the default itself is rewritten.
					if (fun.expr != null) {
					var eLocal = mk(TELocal(mkIdent(arg.name), arg.v), arg.v.type, arg.v.type);
					initExprs.push({
						expr: mk(TEIf({
							syntax: {
								keyword: mkIdent("if", indent, [whitespace]),
								openParen: mkOpenParen(),
								closeParen: addTrailingWhitespace(mkCloseParen())
							},
							econd: mk(TEBinop(eLocal, OpEquals(mkEqualsEqualsToken()), mkNullExpr()), TTBoolean, TTBoolean),
							ethen: mk(TEBinop(eLocal, OpAssign(new Token(0, TkEquals, "=", [whitespace], [whitespace])), init.expr), eLocal.type, eLocal.type),
							eelse: null
						}), TTVoid, TTVoid),
						semicolon: addTrailingNewline(mkSemicolon()),
					});
					}
					arg.kind = TArgNormal(type, init.with(expr = mkNullExpr()));

				case TArgNormal(type, init = {expr: {kind: TEField({type: TTStatic(cls)}, fieldName, fieldToken)}}):
					switch cls.findField(fieldName, true) {
						case {kind: TFVar(f)}:
							if (!f.isInline) {
								var eLocal = mk(TELocal(mkIdent(arg.name), arg.v), arg.v.type, arg.v.type);
								var check = mk(TEIf({
									syntax: {
										keyword: mkIdent("if", indent, [whitespace]),
										openParen: mkOpenParen(),
										closeParen: addTrailingWhitespace(mkCloseParen())
									},
									econd: mk(TEBinop(eLocal, OpEquals(mkEqualsEqualsToken()), mkNullExpr()), TTBoolean, TTBoolean),
									ethen: mk(TEBinop(eLocal, OpAssign(new Token(0, TkEquals, "=", [whitespace], [whitespace])), init.expr), eLocal.type, eLocal.type),
									eelse: null
								}), TTVoid, TTVoid);
								initExprs.push({
									expr: check,
									semicolon: addTrailingNewline(mkSemicolon()),
								});
								arg.kind = TArgNormal(type, init.with(expr = mkNullExpr()));
							}

						case _:
							throwError(init.equalsToken.pos, "Unsupported default arg initialization");
					}
				case _:
			}
		}
		if (initExprs.length > 0 && fun.expr != null) {
			var initBlock = mk(TEBlock({
				syntax: {
					openBrace: addTrailingNewline(mkOpenBrace()),
					closeBrace: mkCloseBrace()
				},
				exprs: initExprs,
			}), TTVoid, TTVoid);
			fun.expr = concatExprs(initBlock, fun.expr);
		}
	}
}
