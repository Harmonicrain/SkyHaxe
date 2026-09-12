package skyhaxe.assets;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

/** Preserve synchronous Flex Embed constructors: compile-time bytes, predecoded bitmap assets. */
class EmbeddedAssetMacro {
    static function resolveBuildPath(path:String):String {
        var marker = "$" + "{SKYHAXE_SOURCE_ROOT}";
        if (!StringTools.startsWith(path, marker)) return path;
        var root = Sys.getEnv("SKYHAXE_SOURCE_ROOT");
        if (root == null || StringTools.trim(root) == "")
            Context.fatalError("Set SKYHAXE_SOURCE_ROOT before building embedded assets",
                Context.currentPos());
        return root + path.substr(marker.length);
    }

    public static function build():Array<Field> {
        var type = Context.getLocalClass().get();
        var identity = type.pack.concat([type.name]).join(".");
        var manifest = Context.definedValue("skyhaxe_embed_manifest");
        if (manifest == null) Context.fatalError("Embedded assets require a pinned manifest", Context.currentPos());
        var records:Dynamic = haxe.Json.parse(sys.io.File.getContent(manifest));
        var record:Dynamic = Reflect.field(records, identity);
        if (record == null) Context.fatalError("Unregistered embedded class: " + identity, Context.currentPos());
        for (field in ["source", "asset"]) {
            var path:String = resolveBuildPath(Reflect.field(record, field));
            if (haxe.crypto.Sha256.make(sys.io.File.getBytes(path)).toHex() != Reflect.field(record, field + "_sha256"))
                Context.fatalError("Embedded source drift: " + path, Context.currentPos());
            Context.registerModuleDependency(type.module, path);
        }
        var id:String = record.id;
        // ByteArray embeds can be constructed in static initializers, before OpenFL's preloader.
        // Compile-time resources preserve that Flash contract; images still require decode/preload.
        var assetPath = resolveBuildPath(record.asset);
        var bytes = record.kind == "ByteArrayAsset" ? sys.io.File.getBytes(assetPath) : null;
        if (bytes != null) Context.addResource(id, bytes);
        var base64 = bytes == null ? "" : haxe.crypto.Base64.encode(bytes);
        var dataExpr = Context.defined("js") ? macro haxe.io.Bytes.ofData(js.Syntax.code(
            "Uint8Array.from(atob({0}), function(c) { return c.charCodeAt(0); }).buffer", $v{base64}))
            : macro haxe.Resource.getBytes($v{id});
        var body = record.kind == "BitmapAsset" ? macro {
            var original = openfl.Assets.getBitmapData($v{id});
            if (original == null) throw new haxe.Exception("Embedded bitmap was not preloaded: " + $v{id});
            super(original.clone());
        } : macro {
            super();
            // haxe.Resource.getBytes itself depends on Base64 static constants, which may be
            // initialized later than a converted class's static Embed consumer. Browser-native
            // decoding has no Haxe initialization-order dependency.
            var data = $dataExpr;
            var original = openfl.utils.ByteArray.fromBytes(data);
            writeBytes(original);
            position = 0;
        };
        var fields = Context.getBuildFields().filter(field -> field.name != "new");
        fields.push({name: "new", access: [APublic], pos: Context.currentPos(),
                     kind: FFun({args: [], ret: null, expr: body})});
        return fields;
    }
}
#end
