package mx.core;

/** Flex Embed boundary: the build macro supplies bytes from preloaded original assets. */
@:autoBuild(skyhaxe.assets.EmbeddedAssetMacro.build())
class ByteArrayAsset extends openfl.utils.ByteArray.ByteArrayData {
    public function new() { super(); endian = openfl.utils.Endian.BIG_ENDIAN; }
}
