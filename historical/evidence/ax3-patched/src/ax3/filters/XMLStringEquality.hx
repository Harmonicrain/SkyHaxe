package ax3.filters;

/** E4X content comparison is not object identity or unconditional string coercion. */
class XMLStringEquality extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TEBinop(a, op = OpEquals(_) | OpNotEquals(_), b)
                    if ((a.type.match(TTXML | TTXMLList) && b.type == TTString)
                     || (b.type.match(TTXML | TTXMLList) && a.type == TTString)):
                var equal = mkCall(mkBuiltin("com.sulake.core.utils.xml.XML.equalsStringOperands",
                    TTFun([TTAny, TTAny], TTBoolean)),
                    [a.with(expectedType = a.type), b.with(expectedType = b.type)], TTBoolean);
                if (op.match(OpNotEquals(_)))
                    equal = mk(TEPreUnop(PreNot(new Token(0, TkExclamation, "!", [], [])), equal),
                        TTBoolean, TTBoolean);
                equal.with(expectedType = e.expectedType);
            case _: e;
        }
    }
}
