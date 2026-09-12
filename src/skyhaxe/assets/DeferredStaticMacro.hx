package skyhaxe.assets;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

/** Narrow AVM2/OpenFL initialization boundary: stage-dependent constants cannot run at JS boot.
 * Keeps the original initializer intact and evaluates it once on first access after boot.
 * This is not a general implementation of AVM2 class initialization order.
 */
class DeferredStaticMacro {
    /**
     * Defer every initialized static field in a converted AS3 class.
     *
     * AVM2 initializes a class when it is first used. Haxe/JavaScript instead emits its static
     * assignments while the script itself is loading. Converted classes which instantiate Flex
     * bitmap embeds in statics therefore run before OpenFL's asset preloader has registered the
     * default library. Turning the fields into one-shot properties restores the observable AS3
     * ordering while leaving their original initializer expressions untouched.
     */
    public static function buildAll():Array<Field> {
        var fields = Context.getBuildFields();
        var additions:Array<Field> = [];
        for (field in fields) {
            if (field.access.indexOf(AStatic) == -1 || field.access.indexOf(AInline) != -1) continue;
            switch field.kind {
                case FVar(type, initializer) if (initializer != null):
                    defer(field, type, initializer, additions);
                case _:
            }
        }
        return fields.concat(additions);
    }

    public static function build(name:String):Array<Field> {
        var fields = Context.getBuildFields();
        var field = fields.filter(field -> field.name == name)[0];
        if (field == null || field.access.indexOf(AStatic) == -1 || field.access.indexOf(AFinal) == -1)
            Context.fatalError("Deferred static contract changed: " + name, Context.currentPos());
        switch field.kind {
            case FVar(type, initializer) if (initializer != null):
                var additions:Array<Field> = [];
                defer(field, type, initializer, additions);
                fields = fields.concat(additions);
            case _: Context.fatalError("Deferred static initializer missing: " + name, field.pos);
        }
        return fields;
    }

    static function defer(field:Field, type:Null<ComplexType>, initializer:Expr,
            additions:Array<Field>):Void {
        var name = field.name;
        var backing = "__deferred_" + name;
        var ready = backing + "_ready";
        field.access.remove(AFinal);
        field.kind = FProp("get", "never", type);
        additions.push({name: backing, access: [APrivate, AStatic], pos: field.pos,
            kind: FVar(type)});
        additions.push({name: ready, access: [APrivate, AStatic], pos: field.pos,
            kind: FVar(macro:Bool, macro false)});
        additions.push({name: "get_" + name, access: [APrivate, AStatic], pos: field.pos,
            kind: FFun({args: [], ret: type, expr: macro {
                if (!$i{ready}) {
                    $i{backing} = $initializer;
                    $i{ready} = true;
                }
                return $i{backing};
            }})});
    }
}
#end
