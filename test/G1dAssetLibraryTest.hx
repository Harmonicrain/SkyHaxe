import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.AssetTypeDeclaration;
import com.sulake.core.assets.TextAsset;
import com.sulake.core.assets.UnknownAsset;
import com.sulake.core.assets.XmlAsset;
import com.sulake.core.utils.xml.XML;
import openfl.utils.Assets;

class G1dAssetLibraryTest {
    public static var assertions(default, null):Int = 0;

    public static function main():Void {
        testTypeRegistry();
        testAssetOwnership();
        testManifestAndAliases();
        testRealCatalogManifest();
        trace('G1D_ASSET_LIBRARY_PASS assertions=$assertions');
    }

    private static function testTypeRegistry():Void {
        var library = new AssetLibrary("types");
        equal("text/xml", library.getAssetTypeDeclarationByFileName("layout.xml").mimeType, "XML extension");
        equal("text/xml", library.getAssetTypeDeclarationByFileName("layout.xml?cache=7").mimeType, "query stripped");
        equal(null, library.getAssetTypeDeclarationByFileName("layout"), "missing extension");
        equal("text/plain", library.getAssetTypeDeclarationByClass(TextAsset).mimeType, "class lookup");

        var local = new AssetTypeDeclaration("test/local", UnknownAsset, null, "local");
        equal(true, library.registerAssetTypeDeclaration(local, false), "local registration");
        equal(local, library.getAssetTypeDeclarationByMimeType("test/local", false), "local MIME lookup");
        equal(local, library.getAssetTypeDeclarationByFileName("file.local", false), "local extension lookup");
        var duplicateThrew = false;
        try library.registerAssetTypeDeclaration(local, false) catch (_:Dynamic) duplicateThrew = true;
        equal(true, duplicateThrew, "duplicate registration throws");
        library.dispose();
    }

    private static function testAssetOwnership():Void {
        var before = AssetLibrary.numAssetLibraryInstances;
        var library = new AssetLibrary("ownership");
        equal(before + 1, AssetLibrary.numAssetLibraryInstances, "instance count");
        equal(true, AssetLibrary.assetLibraryRefArray.indexOf(library) > -1, "instance reference tracked");
        var declaration = library.getAssetTypeDeclarationByMimeType("application/octet-stream");
        var first = new UnknownAsset(declaration);
        var second = new UnknownAsset(declaration);
        first.setUnknownContent({id: 1});
        second.setUnknownContent({id: 2});
        equal(true, library.setAsset("item", first), "first asset inserted");
        equal(false, library.setAsset("item", second, false), "overwrite can be refused");
        equal(first, library.getAssetByName("item"), "refused overwrite preserves asset");
        equal(true, library.setAsset("item", second), "overwrite allowed");
        equal(false, first.disposed, "replacement does not dispose transferred-out asset");
        equal(1, library.numAssets, "overwrite does not duplicate name");
        equal(second, library.getAssetByIndex(0), "index lookup");
        equal(0, library.getAssetIndex(second), "asset index");
        equal(second, library.getAssetByContent(second.content), "content identity lookup");
        equal(second, library.removeAsset(second), "remove returns ownership");
        equal(false, second.disposed, "remove does not dispose");
        equal(0, library.numAssets, "remove updates count");
        equal(null, library.removeAsset(second), "removed asset absent");

        library.setAsset("owned", first);
        library.unload();
        equal(true, first.disposed, "unload disposes owned asset");
        equal(0, library.numAssets, "unload clears asset count");
        equal(0, library.nameArray.length, "unload clears stale names");
        library.dispose();
        library.dispose();
        equal(before, AssetLibrary.numAssetLibraryInstances, "dispose decrements once");
        equal(false, AssetLibrary.assetLibraryRefArray.indexOf(library) > -1, "disposed reference removed");
        second.dispose();
    }

    private static function testManifestAndAliases():Void {
        var library = new AssetLibrary("manifest");
        var manifest = new XML('<manifest><library><assets>'
            + '<asset mimeType="text/plain" name="greeting"/>'
            + '<asset mimeType="text/xml" name="layout"/>'
            + '<asset mimeType="missing/type" name="ignored"/>'
            + '</assets><aliases>'
            + '<asset mimeType="text/plain" name="greeting_alias" ref="greeting"/>'
            + '</aliases></library></manifest>');
        var content = [
            "greeting" => "hello",
            "layout" => "<layout><window/></layout>",
            "ignored" => "ignored"
        ];
        equal(true, library.loadFromManifest(manifest, name -> content.get(name)), "manifest load");
        equal(true, library.isReady, "manifest marks library ready");
        equal(3, library.numAssets, "supported assets and alias loaded");
        equal("greeting,layout,greeting_alias", library.nameArray.join(","), "manifest order");
        equal("hello", library.getAssetByName("greeting").content, "text manifest content");
        equal("hello", library.getAssetByName("greeting_alias").content, "alias shares content");
        var xml:XML = cast library.getAssetByName("layout").content;
        equal(1, xml.child("window").length(), "XML manifest content lazily parsed");
        equal(false, library.hasAsset("ignored"), "unknown MIME skipped like AS3 eager load");

        var badAlias = new AssetLibrary("bad-alias");
        var aliasThrew = false;
        try {
            badAlias.loadFromManifest(new XML(
                '<manifest><library><aliases><asset mimeType="text/plain" name="bad" ref="missing"/>'
                + '</aliases></library></manifest>'
            ), _ -> null);
        } catch (_:Dynamic) aliasThrew = true;
        equal(true, aliasThrew, "missing alias reference fails explicitly");
        badAlias.dispose();
        library.dispose();
    }

    private static function testRealCatalogManifest():Void {
        var source = Assets.getText("fixtures/HabboCatalogCom_manifest.bin");
        equal(true, source != null && source.length > 0, "real catalog manifest packaged read-only");
        var library = new AssetLibrary("real-catalog");
        library.loadFromManifest(new XML(source), name -> '<asset name="$name"/>');
        equal(153, library.numAssets, "all supported real catalog XML assets and aliases load");
        equal(true, library.hasAsset("layout_default_3x3"), "real source asset loaded");
        equal(true, library.hasAsset("layout_default_3x3_extrainfo"), "real alias loaded");
        equal(
            library.getAssetByName("layout_default_3x3").content,
            library.getAssetByName("layout_default_3x3_extrainfo").content,
            "real alias preserves content identity"
        );
        equal(false, library.hasAsset("bot_thumb_bg"), "unsupported bitmap waits for BitmapData gate");
        library.dispose();
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!same(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        return js.Syntax.strictEq(left, right);
    }
}
