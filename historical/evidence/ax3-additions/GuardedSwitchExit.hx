package ax3.filters;

/** Before terminal case-break validation, lower `if (x) { ...; break; } rest`
    to `if (x) { ...; } else { rest }`. No synthetic loop changes continue targets.
    Deliberately leaves other switch-exit shapes for the compiler to reject. */
class GuardedSwitchExit extends AbstractFilter {
	static function blockExprs(expr:TExpr):Null<Array<TBlockExpr>> {
		return switch expr.kind {
			case TEBlock(block): block.exprs;
			case _: null;
		};
	}

	static function endsInBreak(expr:TExpr):Bool {
		return switch expr.kind {
			case TEBreak(_): true;
			case TEBlock(block) if (block.exprs.length > 0): endsInBreak(block.exprs[block.exprs.length - 1].expr);
			case _: false;
		};
	}

	static function removeTerminalBreak(expr:TExpr):TExpr {
		return switch expr.kind {
			case TEBreak(_):
				mk(TEBlock({syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()}, exprs: []}), TTVoid, TTVoid);
			case TEBlock(block) if (block.exprs.length > 0):
				var exprs = block.exprs.copy();
				var tail = exprs[exprs.length - 1];
				switch tail.expr.kind {
					case TEBreak(_): exprs.pop();
					case TEBlock(_) if (endsInBreak(tail.expr)):
						exprs[exprs.length - 1] = tail.with(expr = removeTerminalBreak(tail.expr));
					case _:
				}
				expr.with(kind = TEBlock(block.with(exprs = exprs)));
			case _: expr;
		};
	}

	static function appendToBlock(expr:TExpr, tail:Array<TBlockExpr>):TExpr {
		return switch expr.kind {
			case TEBlock(block): expr.with(kind = TEBlock(block.with(exprs = block.exprs.concat(tail))));
			case _: expr;
		};
	}

    static function lower(body:Array<TBlockExpr>):Array<TBlockExpr> {
        // RewriteSwitch preserves a braced case as one TEBlock. Descend into that wrapper
        // so it has the same conditional-exit semantics as an unbraced case.
        if (body.length == 1) {
            switch body[0].expr.kind {
                case TEBlock(block):
                    body[0] = body[0].with(expr = body[0].expr.with(
                        kind = TEBlock(block.with(exprs = lower(block.exprs)))
                    ));
                    return body;
                case _:
            }
        }
        for (index in 0...body.length) {
            var item = body[index];
            switch item.expr.kind {
				case TETry(statement) if ([for (caught in statement.catches) if (endsInBreak(caught.expr)) caught].length > 0):
					// In AS3 a break nested in a catch still exits its surrounding switch.
					// Haxe has no labelled switch break, so put the case tail on every
					// path that did not break: the try success path and non-breaking catches.
					var remaining = lower(body.slice(index + 1));
					var tryExpr = appendToBlock(statement.expr, remaining);
					var catches = [for (caught in statement.catches) {
						var catchExpr = if (endsInBreak(caught.expr))
							removeTerminalBreak(caught.expr)
						else
							appendToBlock(caught.expr, remaining);
						caught.with(expr = catchExpr);
					}];
					var replacement = item.with(expr = item.expr.with(kind = TETry(statement.with(
						expr = tryExpr,
						catches = catches
					))));
					return body.slice(0, index).concat([replacement]);
				case TEIf(branch = {eelse: null}) if (endsInBreak(branch.ethen)):
                    var remaining = lower(body.slice(index + 1));
					var thenExpr = removeTerminalBreak(branch.ethen);
					var elseExpr = mk(TEBlock({
						syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
						exprs: remaining
					}), TTVoid, TTVoid);
                    var replacement = item.with(expr = item.expr.with(kind = TEIf(branch.with(
                        ethen = thenExpr,
                        eelse = {keyword: mkIdent("__guarded_else", [whitespace], [whitespace]), expr: elseExpr}
                    ))));
                    return body.slice(0, index).concat([replacement]);
                case TEIf(branch) if (index == body.length - 1):
                    // A nested guarded break in the final conditional still exits this
                    // switch. There is no containing case tail to duplicate here.
                    function lowerBranch(expr:TExpr):TExpr {
                        return switch expr.kind {
                            case TEBlock(block): expr.with(kind = TEBlock(block.with(exprs = lower(block.exprs))));
                            case _: expr;
                        };
                    }
                    var loweredElse = branch.eelse == null ? null : branch.eelse.with(
                        expr = lowerBranch(branch.eelse.expr)
                    );
                    body[index] = item.with(expr = item.expr.with(kind = TEIf(branch.with(
                        ethen = lowerBranch(branch.ethen),
                        eelse = loweredElse
                    ))));
                case _:
            }
        }
        return body;
    }

    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        switch e.kind {
            case TESwitch(statement):
                for (entry in statement.cases) entry.body = lower(entry.body);
                if (statement.def != null) statement.def.body = lower(statement.def.body);
            case _:
        }
        return e;
    }
}
