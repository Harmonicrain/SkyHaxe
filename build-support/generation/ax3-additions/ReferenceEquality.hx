package ax3.filters;

/** AS3 compares object identity even when the two references have different static types. */
class ReferenceEquality extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TEBinop(a = {type: TTInst(_)},
                    op = OpEquals(_) | OpNotEquals(_) | OpStrictEquals(_) | OpNotStrictEquals(_),
                    b = {type: TTInst(_)}) if (!typeEq(a.type, b.type)):
                // This is a compile-time retype, NOT a checked downcast. Comparing a different
                // implementation must return false, not throw. Both operands evaluate once.
                var left = mk(TEHaxeRetype(a.with(expectedType = a.type)), TTAny, TTAny);
                var right = mk(TEHaxeRetype(b.with(expectedType = b.type)), TTAny, TTAny);
                e.with(kind = TEBinop(left, op, right));
            case _: e;
        }
    }
}
