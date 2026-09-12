package ax3.filters;

/** AS3 functions declared :* may fall off the end, returning undefined rather than null. */
class ImplicitAnyReturn extends AbstractFilter {
    var className:String;
    override function processClass(cls:TClassOrInterfaceDecl) {
        className = cls.name;
        super.processClass(cls);
    }
    override function processClassField(field:TClassField) {
        switch field.kind {
            case TFFun(value) if (value.name == className): return; // Constructors are Void in Haxe.
            case _: super.processClassField(field);
        }
    }
    override function processFunction(fun:TFunction) {
        super.processFunction(fun);
        if (fun.sig.ret.type != TTAny || fun.expr == null) return;
        // AS3 `:*` permits every control-flow path to fall through as undefined.
        // An explicit return in one branch does not remove that contract from the
        // other branch. A final fallback is valid even when Haxe can prove it
        // unreachable, and avoids brittle whole-function control-flow analysis.
        var value = mkCall(mkBuiltin("ASCompat.undefinedValue", TTFun([], TTAny)), [], TTAny);
        var statement = mk(TEReturn(mkIdent("return", [newline], [whitespace]), value), TTVoid, TTVoid);
        switch fun.expr.kind {
            case TEBlock(block):
                var terminal = block.exprs.length > 0 && switch block.exprs[block.exprs.length - 1].expr.kind {
                    case TEReturn(_) | TEThrow(_): true;
                    case _: false;
                };
                if (!terminal) block.exprs.push({expr: statement, semicolon: semicolonWithSpace});
            case _: // Expression-bodied Haxe functions are not AS3 statement-only methods.
        }
    }

    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        switch e.kind {
            case TELocalFunction(local): processFunction(local.fun);
            case _:
        }
        return e;
    }
}
