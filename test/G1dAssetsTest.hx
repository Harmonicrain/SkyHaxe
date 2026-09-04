import com.sulake.core.assets.AssetTypeDeclaration;
import com.sulake.core.assets.TextAsset;
import com.sulake.core.assets.UnknownAsset;
import com.sulake.core.assets.XmlAsset;
import com.sulake.core.utils.xml.XML;
import openfl.utils.ByteArray;

class G1dAssetsTest {
    public static var assertions(default, null):Int = 0;

    public static function main():Void {
        testDeclaration();
        testUnknownAsset();
        testTextAsset();
        testXmlAsset();
        trace('G1D_ASSETS_PASS assertions=$assertions');
    }

    private static function testDeclaration():Void {
        var declaration = textDeclaration();
        equal("text/plain", declaration.mimeType, "mime type");
        equal(TextAsset, declaration.assetClass, "asset class");
        equal(null, declaration.loaderClass, "optional loader class");
        equal("txt,text", declaration.fileTypes.join(","), "rest file types preserve order");
    }

    private static function testUnknownAsset():Void {
        var declaration = unknownDeclaration();
        var asset = new UnknownAsset(declaration, "asset://opaque");
        var payload = {value: 7};
        asset.setUnknownContent(payload);
        equal(payload, asset.content, "unknown content identity");
        equal("asset://opaque", asset.url, "unknown URL");
        equal(declaration, asset.declaration, "unknown declaration");
        var copy = new UnknownAsset(declaration);
        copy.setFromOtherAsset(asset);
        equal(payload, copy.content, "unknown copy shares payload");
        asset.dispose();
        asset.dispose();
        equal(true, asset.disposed, "unknown disposal idempotent");
        equal(null, asset.content, "unknown disposal clears content");
        equal(null, asset.url, "unknown disposal clears URL");
    }

    private static function testTextAsset():Void {
        var declaration = textDeclaration();
        var asset = new TextAsset(declaration, "asset://text");
        asset.setUnknownContent("hello");
        equal("hello", asset.content, "text from string");

        var bytes = new ByteArray();
        bytes.writeUTFBytes("byte text");
        bytes.position = 0;
        asset.setUnknownContent(bytes);
        equal("byte text", asset.content, "text from ByteArray");
        equal(bytes.length, bytes.position, "text conversion advances ByteArray position");

        asset.setUnknownContent(123);
        equal("123", asset.content, "text fallback string conversion");
        asset.setUnknownContent(null);
        equal("", asset.content, "null text becomes empty string");
        asset.setUnknownContent("shared");
        var copy = new TextAsset(declaration);
        copy.setFromOtherAsset(asset);
        equal("shared", copy.content, "text copy");

        var wrongTypeThrew = false;
        try copy.setFromOtherAsset(new UnknownAsset(unknownDeclaration())) catch (_:Dynamic) wrongTypeThrew = true;
        equal(true, wrongTypeThrew, "text copy rejects wrong type");
        asset.dispose();
        equal(true, asset.disposed, "text disposed");
        equal(null, asset.content, "text disposal clears content");
    }

    private static function testXmlAsset():Void {
        var declaration = xmlDeclaration();
        var asset = new XmlAsset(declaration, "asset://xml");
        asset.setUnknownContent('<root><item id="7">value</item></root>');
        var parsed:XML = cast asset.content;
        equal("7", parsed.child("item").at(0).attribute("id").toString(), "lazy XML string parse");
        equal("value", parsed.child("item").at(0).toString(), "lazy XML text");

        var direct = new XML("<direct/>");
        asset.setUnknownContent(direct);
        equal(direct, asset.content, "direct XML identity");

        var bytes = new ByteArray();
        bytes.writeUTFBytes("<bytes><ok/></bytes>");
        bytes.position = 0;
        asset.setUnknownContent(bytes);
        var fromBytes:XML = cast asset.content;
        equal(1, fromBytes.child("ok").length(), "XML from ByteArray");
        equal(bytes.length, bytes.position, "XML conversion advances ByteArray position");

        var copy = new XmlAsset(declaration);
        copy.setFromOtherAsset(asset);
        equal(fromBytes, copy.content, "XML copy shares parsed node");
        var wrongTypeThrew = false;
        try copy.setFromOtherAsset(new TextAsset(textDeclaration())) catch (_:Dynamic) wrongTypeThrew = true;
        equal(true, wrongTypeThrew, "XML copy rejects wrong type");
        asset.dispose();
        asset.dispose();
        equal(true, asset.disposed, "XML disposal idempotent");
        equal(null, asset.content, "XML disposal remains empty");
    }

    private static function textDeclaration():AssetTypeDeclaration {
        return new AssetTypeDeclaration("text/plain", TextAsset, null, "txt", "text");
    }

    private static function xmlDeclaration():AssetTypeDeclaration {
        return new AssetTypeDeclaration("text/xml", XmlAsset, null, "xml");
    }

    private static function unknownDeclaration():AssetTypeDeclaration {
        return new AssetTypeDeclaration("application/octet-stream", UnknownAsset);
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
