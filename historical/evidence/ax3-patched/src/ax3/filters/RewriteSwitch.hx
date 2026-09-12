package ax3.filters;

// TODO: rewrite `default` to `case _`?
class RewriteSwitch extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TESwitch(s):
				var newCases:Array<TSwitchCase> = [];
				var valueAcc = [];

				function hasGuardedBreak(block:Array<TBlockExpr>):Bool {
					function branchEndsInBreak(expr:TExpr):Bool {
						return switch expr.kind {
							case TEBreak(_): true;
							case TEBlock(inner) if (inner.exprs.length > 0): branchEndsInBreak(inner.exprs[inner.exprs.length - 1].expr);
							case _: false;
						};
					}
					if (block.length == 1) {
						switch block[0].expr.kind {
							case TEBlock(inner): block = inner.exprs;
							case _:
						}
					}
					for (item in block) {
						switch item.expr.kind {
							case TEIf({eelse: null, ethen: branch}) if (branchEndsInBreak(branch)):
								return true;
							case _:
						}
					}
					return false;
				}

				function isTerminal(block:Array<TBlockExpr>):Bool {
					if (block.length == 1) {
						switch block[0].expr.kind {
							case TEBlock(inner): block = inner.exprs;
							case _:
						}
					}
					if (block.length == 0) return false;
					return block[block.length - 1].expr.kind.match(TEBreak(_) | TEReturn(_) | TEContinue(_) | TEThrow(_));
				}

				function appendFollowingCaseBody(index:Int, body:Array<TBlockExpr>):Array<TBlockExpr> {
					var expanded = body.copy();
					var next = index + 1;
					while (!isTerminal(expanded) && next < s.cases.length) {
						var following = s.cases[next++].body;
						if (following.length > 0) expanded = expanded.concat(following);
					}
					if (!isTerminal(expanded) && s.def != null
							&& s.def.syntax.keyword.pos > s.cases[index].syntax.keyword.pos) {
						expanded = expanded.concat(s.def.body);
					}
					return expanded;
				}

				function processCaseBody(block:Array<TBlockExpr>, allowNonTerminalLast:Bool):Array<Trivia> {
					var guardedBreak = hasGuardedBreak(block);
					switch block {
						case [{expr: {kind: TEBlock(b)}}]:  block = b.exprs; // for cases with "braced" body: `case value: {...}`
						case _:
					}

					if (block.length == 0) return []; // empty block - nothing to do here

					var lastExpr = block[block.length - 1].expr;
					switch lastExpr.kind {
						case TEBreak(breakToken):
							var blockExpr = block.pop();
							var trivia = breakToken.leadTrivia.concat(breakToken.trailTrivia);
							if (blockExpr.semicolon != null) {
								trivia = trivia.concat(blockExpr.semicolon.leadTrivia).concat(blockExpr.semicolon.trailTrivia);
							}
							return trivia;

						case TEReturn(_) | TEContinue(_) | TEThrow(_): // allowed terminators
							return [];

						case TEIf(i) if (i.eelse != null && i.eelse.keyword.text == "__guarded_else"):
							// GuardedSwitchExit has made the former fall-through tail an
							// explicit else branch, so this case is now terminal by design.
							return [];

						case _:
							if (!allowNonTerminalLast && !guardedBreak) {
								throwError(exprPos(lastExpr), "Non-terminal expression inside a switch case, possible fall-through?");
							}
							return [];
					}
				}

				for (i in 0...s.cases.length) {
					var c = s.cases[i];
					var value = switch c.values {
						case [value]: value;
						case _: throw "assert";
					};
					valueAcc.push({syntax: c.syntax, value: value});
					if (c.body.length > 0) {
						var values = [];
						for (v in valueAcc) {
							var expr = v.value;
							processLeadingToken(function(t) {
								t.leadTrivia = t.leadTrivia.concat(v.syntax.keyword.leadTrivia);
							}, expr);
							processTrailingToken(function(t) {
								t.trailTrivia = t.trailTrivia.concat(v.syntax.colon.leadTrivia).concat(v.syntax.colon.trailTrivia);
							}, expr);
							values.push(expr);
						}

						// AS3 permits default anywhere. A final case after the source default reaches
						// the end of the switch and is terminal even though `def` is non-null here.
						var defaultBeforeCase = s.def != null
							&& s.def.syntax.keyword.pos < c.syntax.keyword.pos;
						var isLast = i == s.cases.length - 1
							&& (s.def == null || defaultBeforeCase);
						var fallsIntoTrailingDefault = i == s.cases.length - 1
							&& s.def != null && !defaultBeforeCase && !isTerminal(c.body);
						if (!isLast && !isTerminal(c.body) && !hasGuardedBreak(c.body)) {
							c.body = appendFollowingCaseBody(i, c.body);
						}

						if (i == s.cases.length - 1 && s.def != null && !defaultBeforeCase
							&& s.def.body.length == 1
							&& s.def.body[0].expr.kind.match(TEReturn(_) | TEThrow(_))) {
							var tail = c.body[c.body.length - 1].expr;
							switch tail.kind {
								case TEBlock(block) if (block.exprs.length > 0): tail = block.exprs[block.exprs.length - 1].expr;
								case _: 
							}
							if (!tail.kind.match(TEBreak(_) | TEReturn(_) | TEThrow(_) | TEContinue(_)))
								c.body.push(s.def.body[0]);
						}
						var breakTrivia = processCaseBody(c.body, isLast || fallsIntoTrailingDefault);

						var colonTrivia = removeTrailingTrivia(values[values.length - 1]);
						if (breakTrivia.length > 0) {
							if (c.body.length == 0) {
								colonTrivia = colonTrivia.concat(breakTrivia);
							} else {
								var lastBlockExpr = c.body[c.body.length - 1];
								if (lastBlockExpr.semicolon != null) {
									lastBlockExpr.semicolon.trailTrivia = lastBlockExpr.semicolon.trailTrivia.concat(breakTrivia);
								} else {
									processTrailingToken(t -> t.trailTrivia = t.trailTrivia.concat(breakTrivia), lastBlockExpr.expr);
								}
							}
						}

						newCases.push({
							syntax: {
								keyword: new Token(0, TkIdent, "case", removeLeadingTrivia(values[0]), [whitespace]),
								colon: new Token(0, TkColon, ":", [], colonTrivia)
							},
							values: values,
							body: c.body // mutated inplace
						});
						valueAcc = [];
					}
				}

				if (s.def != null) {
					processCaseBody(s.def.body, true);
				}

				// A switch whose cases only contained `break` is a no-op after AS3
				// fall-through normalization. Preserve evaluation of its subject, but do
				// not emit Haxe case patterns (native Flash event constants are mutable
				// static fields and therefore illegal as Haxe patterns).
				var allCasesEmpty = true;
				for (branch in newCases) if (branch.body.length > 0) allCasesEmpty = false;
				if (allCasesEmpty && (s.def == null || s.def.body.length == 0)) {
					s.subj.with(expectedType = e.expectedType);
				} else {
					e.with(kind = TESwitch({
						syntax: s.syntax,
						subj: s.subj,
						cases: newCases,
						def: s.def
					}));
				}

			case _:
				e;
		}
	}
}
