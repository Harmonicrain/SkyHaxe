package ax3.filters;

/** AS3 permits a void call wherever `*` is expected and supplies undefined. */
class VoidValues extends AbstractFilter {
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch [e.kind, e.type, e.expectedType] {
            case [TECall(_), TTVoid, expected] if (expected != TTVoid):
                var undefined = mkCall(mkBuiltin("ASCompat.undefinedValue", TTFun([], TTAny)), [], TTAny)
                    .with(expectedType = expected);
                mk(TEBlock({
                    syntax: {openBrace: mkOpenBrace(), closeBrace: mkCloseBrace()},
                    exprs: [
                        {expr: e.with(expectedType = TTVoid), semicolon: mkSemicolon()},
                        {expr: undefined, semicolon: null}
                    ]
                }), TTAny, expected);
            case _: e;
        };
    }
}
