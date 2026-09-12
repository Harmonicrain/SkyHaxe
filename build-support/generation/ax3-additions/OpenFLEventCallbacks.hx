package ax3.filters;

/** Only Flash EventDispatcher descendants, never the client's window event bus. */
class OpenFLEventCallbacks extends AbstractFilter {
    static function isDispatcher(owner:TClassOrInterfaceDecl):Bool {
        if (owner.name == "EventDispatcher" && owner.parentModule.parentPack.name == "flash.events") return true;
        return switch owner.kind {
            case TClass({extend: extension}) if (extension != null): isDispatcher(extension.superClass);
            case _: false;
        }
    }
    override function processExpr(e:TExpr):TExpr {
        e = mapExpr(processExpr, e);
        return switch e.kind {
            case TECall(method = {kind: TEField({type: TTInst(owner)}, "addEventListener" | "removeEventListener", _)}, args)
                    if (args.args.length >= 2 && isDispatcher(owner)):
                var callback = args.args[1].expr;
                args.args[1].expr = mk(TEHaxeRetype(callback.with(expectedType = callback.type)), TTAny, TTAny);
                e.with(kind = TECall(method, args));
            case _: e;
        }
    }
}
