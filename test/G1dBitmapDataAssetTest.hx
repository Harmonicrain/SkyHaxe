import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.AssetTypeDeclaration;
import com.sulake.core.assets.BitmapDataAsset;
import com.sulake.core.assets.UnknownAsset;
import com.sulake.core.utils.xml.XMLList;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

class G1dBitmapDataAssetTest {
    public static var assertions(default, null):Int = 0;

    public static function main():Void {
        testOwnedBitmapAndParameters();
        testBorrowedBitmapOwnership();
        testManifestAliasOwnership();
        testRejectedInputs();
        trace('G1D_BITMAP_ASSET_PASS assertions=$assertions');
    }

    private static function testOwnedBitmapAndParameters():Void {
        var baselineInstances = BitmapDataAsset.instances;
        var baselineBytes = BitmapDataAsset.allocatedByteCount;
        var asset = new BitmapDataAsset(declaration(), "asset://bitmap");
        var bitmap = new BitmapData(4, 3, true, 0xFF336699);
        asset.setUnknownContent(bitmap);
        equal(bitmap, asset.content, "BitmapData identity adopted");
        equal(baselineInstances + 1, BitmapDataAsset.instances, "instance counted");
        equal(baselineBytes + 48, BitmapDataAsset.allocatedByteCount, "owned pixels counted once");
        equal(4.0, asset.rectangle.width, "default rectangle width");
        equal(3.0, asset.rectangle.height, "default rectangle height");

        asset.setParamsDesc(new XMLList([
            new com.sulake.core.utils.xml.XML('<param key="offset" value="-2,5"/>'),
            new com.sulake.core.utils.xml.XML('<param key="region" value="1,2,2,1"/>'),
            new com.sulake.core.utils.xml.XML('<param key="flipH" value="true"/>'),
            new com.sulake.core.utils.xml.XML('<param key="flipV" value="1"/>')
        ]));
        equal(-2.0, asset.offset.x, "offset x");
        equal(5.0, asset.offset.y, "offset y");
        equal(1.0, asset.rectangle.x, "region x");
        equal(2.0, asset.rectangle.width, "region width");
        equal(true, asset.flipH, "horizontal flip flag");
        equal(true, asset.flipV, "vertical flip flag");
        equal(0xFF336699, bitmap.getPixel32(0, 0), "pixel content intact");
        asset.dispose();
        asset.dispose();
        equal(baselineBytes, BitmapDataAsset.allocatedByteCount, "owned disposal balances bytes");
        equal(baselineInstances, BitmapDataAsset.instances, "owned disposal balances instances");
    }

    private static function testBorrowedBitmapOwnership():Void {
        var baselineBytes = BitmapDataAsset.allocatedByteCount;
        var owner = new BitmapDataAsset(declaration());
        var source = new BitmapData(2, 2, true, 0xFF112233);
        owner.setUnknownContent(source);
        equal(source, owner.content, "owner lazily adopts BitmapData");
        var afterOwner = BitmapDataAsset.allocatedByteCount;
        equal(baselineBytes + 16, afterOwner, "owner allocation");

        var borrower = new BitmapDataAsset(declaration());
        borrower.setFromOtherAsset(owner);
        equal(source, borrower.content, "borrower shares BitmapData identity");
        equal(false, borrower.ownsData, "copy is explicitly borrowed");
        equal(afterOwner, BitmapDataAsset.allocatedByteCount, "borrower is not double-counted");
        borrower.dispose();
        equal(0xFF112233, source.getPixel32(1, 1), "borrower disposal leaves owner pixels alive");
        equal(afterOwner, BitmapDataAsset.allocatedByteCount, "borrower disposal leaves accounting");
        owner.dispose();
        equal(baselineBytes, BitmapDataAsset.allocatedByteCount, "owner finally releases allocation");

        var wrapped = new BitmapDataAsset(declaration());
        wrapped.setUnknownContent(new Bitmap(new BitmapData(1, 1, true, 0xFFABCDEF)));
        var wrappedData:BitmapData = cast wrapped.content;
        equal(0xFFABCDEF, wrappedData.getPixel32(0, 0), "Bitmap wrapper transfers pixels");
        wrapped.dispose();
    }

    private static function testManifestAliasOwnership():Void {
        var baselineBytes = BitmapDataAsset.allocatedByteCount;
        var library = new AssetLibrary("bitmap-alias");
        library.registerAssetTypeDeclaration(declaration(), false);
        var manifest = new com.sulake.core.utils.xml.XML('<manifest><library><assets>'
            + '<asset mimeType="image/png" name="sheet"/>'
            + '</assets><aliases>'
            + '<asset mimeType="image/png" name="tile" ref="sheet"><param key="region" value="1,0,1,1"/></asset>'
            + '</aliases></library></manifest>');
        library.loadFromManifest(manifest, _ -> new BitmapData(2, 1, true, 0xFF778899));
        var sheet:BitmapDataAsset = cast library.getAssetByName("sheet");
        var tile:BitmapDataAsset = cast library.getAssetByName("tile");
        equal(sheet.content, tile.content, "manifest alias shares bitmap identity");
        equal(true, sheet.ownsData, "manifest source owns bitmap");
        equal(false, tile.ownsData, "manifest alias borrows bitmap");
        equal(1.0, tile.rectangle.width, "alias region applied independently");
        equal(baselineBytes + 8, BitmapDataAsset.allocatedByteCount, "manifest alias counted once");
        library.unload();
        equal(baselineBytes, BitmapDataAsset.allocatedByteCount, "library unload balances shared bitmap");
        library.dispose();
    }

    private static function testRejectedInputs():Void {
        var asset = new BitmapDataAsset(declaration());
        var wrongCopyThrew = false;
        try asset.setFromOtherAsset(new UnknownAsset(new AssetTypeDeclaration("unknown", UnknownAsset))) catch (_:Dynamic) wrongCopyThrew = true;
        equal(true, wrongCopyThrew, "wrong asset copy rejected");
        var bytes = new ByteArray();
        bytes.writeByte(1);
        asset.setUnknownContent(bytes);
        var encodedThrew = false;
        try asset.prepareLazyContent() catch (_:Dynamic) encodedThrew = true;
        equal(true, encodedThrew, "encoded bytes require G2 decoder");
        asset.dispose();
    }

    private static function declaration():AssetTypeDeclaration {
        return new AssetTypeDeclaration("image/png", BitmapDataAsset, null, "png");
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!js.Syntax.strictEq(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }
}
