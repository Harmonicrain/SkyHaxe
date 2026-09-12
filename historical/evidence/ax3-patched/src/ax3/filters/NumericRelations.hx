package ax3.filters;

/** Preserve AVM2 Boolean-to-number relational and loose-equality comparisons. */
class NumericRelations extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TEBinop(a, op = OpGt(_) | OpGte(_) | OpLt(_) | OpLte(_), b)
                    if (a.type == TTBoolean || b.type == TTBoolean):
                function numeric(value:TExpr):TExpr {
                    if (value.type != TTBoolean) return value;
                    var fn = mkBuiltin("ASCompat.toNumber", TTFun([TTAny], TTNumber), removeLeadingTrivia(value));
                    return mkCall(fn, [value.with(expectedType = TTAny)]);
                }
                e.with(kind = TEBinop(numeric(a), op, numeric(b)));
            case TEBinop(a, op = OpEquals(_) | OpNotEquals(_), b)
                    if ((a.type == TTBoolean && b.type.match(TTInt | TTUint | TTNumber))
                        || (b.type == TTBoolean && a.type.match(TTInt | TTUint | TTNumber))):
                function numeric(value:TExpr):TExpr {
                    if (value.type != TTBoolean) return value;
                    var fn = mkBuiltin("ASCompat.toNumber", TTFun([TTAny], TTNumber), removeLeadingTrivia(value));
                    return mkCall(fn, [value.with(expectedType = TTAny)]);
                }
                e.with(kind = TEBinop(numeric(a), op, numeric(b)));
            case _: e;
        }
    }
}
