package ax3.filters;

import ax3.ParseTree.Binop;

class RewriteAssignOps extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			// AS3 applies ToInt32 to dynamic operands of compound bitwise assignments.
			// Haxe cannot apply the operator directly to ASAny, so spell out the read,
			// coercion and assignment while retaining the original lvalue.
			case TEBinop(a = {type: TTAny}, OpAssignOp(aop = (AOpBitAnd(_) | AOpBitOr(_) | AOpBitXor(_)
				| AOpShl(_) | AOpShr(_) | AOpUshr(_))), b):
				if (!canBeRepeated(a)) throwError(exprPos(a), "dynamic bitwise assignment lvalue must be safe to repeat");
				var op:Binop = switch aop {
					case AOpBitAnd(t): OpBitAnd(t.clone());
					case AOpBitOr(t): OpBitOr(t.clone());
					case AOpBitXor(t): OpBitXor(t.clone());
					case AOpShl(t): OpShl(t.clone());
					case AOpShr(t): OpShr(t.clone());
					case AOpUshr(t): OpUshr(t.clone());
					case _: throw "assert";
				}
				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var value = mk(TEBinop(leftSide.with(expectedType = TTInt), op,
					b.with(expectedType = TTInt)), TTInt, TTAny);
				e.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

			// Prefix ++/-- over an untyped Array slot is likewise a numeric read followed
			// by a write; coercing the lvalue itself produces an invalid assignment.
			case TEPreUnop(pre = (PreIncr(_) | PreDecr(_)), a = {type: TTAny}):
				if (!canBeRepeated(a)) throwError(exprPos(a), "dynamic prefix lvalue must be safe to repeat");
				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
				var op:Binop = switch pre {
					case PreIncr(t): OpAdd(t.clone());
					case PreDecr(t): OpSub(t.clone());
					case _: throw "assert";
				}
				var value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
				e.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

			// A discarded postfix result has the same write effect as the prefix form. Preserve
			// postfix value semantics by refusing value-consuming sites until they have a dedicated
			// temporary; statement sites need only perform the numeric read and write.
			case TEPostUnop(a = {type: TTAny}, post = (PostIncr(_) | PostDecr(_))) if (e.expectedType == TTVoid):
				if (!canBeRepeated(a)) {
					// Evaluate a prefix-mutating array index exactly once, then use its
					// updated value for the numeric slot write (for example a[++i]++).
					// Calls and postfix-mutating indexes still need a true temporary.
					var split = switch a.kind {
						case TEArrayAccess(access = {eindex: {kind: TEPreUnop(_, indexTarget)}})
								if (canBeRepeated(access.eobj) && canBeRepeated(indexTarget)):
							var indexStep = access.eindex.with(expectedType = TTVoid);
							var stable = a.with(kind = TEArrayAccess(access.with(eindex = cloneExpr(indexTarget))));
							{indexStep: indexStep, stable: stable};
						case _: null;
					};
					if (split == null) throwError(exprPos(a), "dynamic postfix lvalue must be safe to repeat");
					var leftSide = cloneExpr(split.stable);
					removeLeadingTrivia(leftSide);
					var one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
					var op:Binop = switch post {
						case PostIncr(t): OpAdd(t.clone());
						case PostDecr(t): OpSub(t.clone());
						case _: throw "assert";
					};
					var value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
					var assignment = mk(TEBinop(split.stable.with(expectedType = TTAny),
						OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value), TTAny, TTVoid);
					return mk(TEBlock({
						syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
						exprs: [
							{expr: split.indexStep, semicolon: mkSemicolon()},
							{expr: assignment, semicolon: mkSemicolon()}
						]
					}), TTVoid, TTVoid);
				}
				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var one = mk(TELiteral(TLInt(new Token(0, TkDecimalInteger, "1", [], []))), TTInt, TTNumber);
				var op:Binop = switch post {
					case PostIncr(t): OpAdd(t.clone());
					case PostDecr(t): OpSub(t.clone());
					case _: throw "assert";
				}
				var value = mk(TEBinop(leftSide.with(expectedType = TTNumber), op, one), TTNumber, TTAny);
				e.with(kind = TEBinop(a.with(expectedType = TTAny), OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), value));

			// int/uint /= int/uint/Number
			case TEBinop(a = {type: TTInt | TTUint}, OpAssignOp(AOpDiv(t)), b):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `/=` must be safe to repeat");
				}

				var op:Binop = OpDiv(t.clone());

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b.with(expectedType = TTNumber)), TTNumber, a.type);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			// int/uint %= Number
			// int/uint *= Number
			case TEBinop(a = {type: TTInt | TTUint}, OpAssignOp(aop = (AOpMod(_) | AOpMul(_))), b = {type: TTNumber}):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `%=` and `*=` must be safe to repeat");
				}

				var op:Binop = switch aop {
					case AOpMod(t): OpMod(t.clone());
					case AOpMul(t): OpMul(t.clone());
					case _: throw "assert";
				}

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b.with(expectedType = TTNumber)), TTNumber, a.type);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			// ||=
			// &&=
			case TEBinop(a, OpAssignOp(aop = (AOpAnd(_) | AOpOr(_))), b):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `||=` and `&&=` must be safe to repeat");
				}

				var op:Binop = switch aop {
					case AOpAnd(t): OpAnd(t.clone());
					case AOpOr(t): OpOr(t.clone());
					case _: throw "assert";
				}

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b), a.type, a.expectedType);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			case _:
				e;
		}
	}
}
