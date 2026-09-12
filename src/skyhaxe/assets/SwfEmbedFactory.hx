package skyhaxe.assets;

import haxe.io.Bytes;
import openfl.display.BitmapData;

/** Runtime constructors replacing SymbolClass classes from downloaded content SWFs. */
class SwfEmbedFactory {
    /**
     * Mark a constructor so Haxe's JavaScript `Class` test accepts it.
     *
     * Flash exports each SWF symbol as a real class, and callers gate on that: given
     * `resource.animation`, `EffectAssetDownloadLibrary` takes the XML branch, else the
     * `is Class` branch, else leaves the field null. A bare function satisfies neither, so the
     * effect library completed with a null animation and `AnimationManager.registerAnimation`
     * brought the component graph down with it.
     *
     * `ComponentLibraryEmbedFactory` already does this for component-library embeds; downloaded
     * content SWFs need the same contract.
     */
    static function markAsClass(constructor:Dynamic, name:String):Class<Dynamic> {
        Reflect.setField(constructor, "__name__", "skyhaxe.swf." + name);
        return cast constructor;
    }

    public static function bitmap(source:BitmapData):Class<Dynamic> {
        return markAsClass(function() return new mx.core.BitmapAsset(source.clone()), "BitmapAsset");
    }

    public static function lazyBitmap(source:LazySwfBitmap):Class<Dynamic> {
        return markAsClass(function() return source.instantiate(), "LazyBitmapAsset");
    }

    public static function bytes(source:Bytes):Class<Dynamic> {
        return markAsClass(function() {
            var result = new mx.core.ByteArrayAsset();
            result.writeBytes(openfl.utils.ByteArray.fromBytes(source));
            result.position = 0;
            return result;
        }, "ByteArrayAsset");
    }
}
