package skyhaxe.assets;

#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;

/** Restore the asset-class initializers which the Flex compiler synthesized for `[Embed]`. */
class ComponentLibraryEmbedMacro {
    static var manifestPath:String;
    static var owners:Dynamic;

    static function load():Void {
        if (owners != null) return;
        manifestPath = Context.definedValue("skyhaxe_component_embed_manifest");
        if (manifestPath == null)
            Context.fatalError("Component embeds require skyhaxe_component_embed_manifest",
                Context.currentPos());
        owners = Reflect.field(Json.parse(File.getContent(manifestPath)), "owners");
    }

    public static function build():Array<Field> {
        load();
        var fields = Context.getBuildFields();
        var type = Context.getLocalClass().get();
        var ownerName = type.pack.concat([type.name]).join(".");
        var owner:Dynamic = Reflect.field(owners, ownerName);
        if (owner == null) return fields;

        Context.registerModuleDependency(type.module, manifestPath);
        var records:Dynamic = Reflect.field(owner, "fields");
        var seen = new Map<String, Bool>();
        for (field in fields) {
            var record:Dynamic = Reflect.field(records, field.name);
            if (record == null) continue;
            switch (field.kind) {
                case FVar(type, _):
                    var id:String = Reflect.field(record, "id");
                    var kind:String = Reflect.field(record, "kind");
                    field.kind = FVar(type,
                        macro skyhaxe.assets.ComponentLibraryEmbedFactory.create($v{id}, $v{kind}));
                    seen.set(field.name, true);
                default:
                    Context.fatalError("Embedded component member is no longer a field: " +
                        ownerName + "." + field.name, field.pos);
            }
        }
        for (name in Reflect.fields(records)) {
            if (!seen.exists(name))
                Context.fatalError("Converted component embed is missing: " + ownerName + "." + name,
                    Context.currentPos());
        }
        return fields;
    }
}
#end
