package mx.core;

/** Flex Embed boundary: consumers still instantiate the converted asset subclass. */
@:autoBuild(skyhaxe.assets.EmbeddedAssetMacro.build())
class BitmapAsset extends openfl.display.Bitmap {
    public function new(?data:openfl.display.BitmapData) { super(data); }
}
