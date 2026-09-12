package skyhaxe.assets;

import com.sulake.core.assets.swf.SwfBitmap;
import com.sulake.core.assets.swf.SwfCharacter;
import com.sulake.core.assets.swf.SwfLoadMetrics;
import openfl.display.BitmapData;

/**
 * Flash exposes a lossless SymbolClass immediately and materializes its pixels when constructed.
 * Keep that contract instead of decoding every bitmap in a downloaded component SWF up front.
 */
class LazySwfBitmap {
    final character:SwfCharacter;
    var source:Null<BitmapData>;

    public function new(character:SwfCharacter) {
        this.character = character;
    }

    public function instantiate():mx.core.BitmapAsset {
        if (source == null) {
            #if (js && html5)
            var started = js.Browser.window.performance.now();
            #end
            source = SwfBitmap.toBitmapData(SwfBitmap.decode(character));
            SwfLoadMetrics.count("lazyLosslessDecodes");
            #if (js && html5)
            SwfLoadMetrics.add("lazyLosslessDecodeMs", js.Browser.window.performance.now() - started);
            #end
        }
        // A SymbolClass constructor owns a fresh BitmapData in Flash. Keep the cached source
        // immutable and give each caller its own surface so disposal and mutation stay isolated.
        return new mx.core.BitmapAsset(source.clone());
    }
}
