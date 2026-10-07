package com.sulake.core.assets.swf;

/**
 * The only SWF tags the reader has to understand, derived from the corpus rather than the spec.
 *
 * Measured over 18,611 `dcr/` files and 3,269 reachable Gordon files:
 *   DefineBitsLossless2  267,506    DefineBinaryData  93,200
 *   DefineBitsJPEG3        1,869    DefineBitsJPEG2    1,473
 *   DefineSound(MP3)          24    DefineBitsLossless     1
 *
 * Everything else in these files is authoring residue that `SymbolClass` never exports, so
 * `getDefinition(name)` can never reach it.
 */
class SwfTag {
	public static inline var END = 0;
	public static inline var DEFINE_SOUND = 14;
	public static inline var DEFINE_BITS_LOSSLESS = 20;
	public static inline var DEFINE_BITS_JPEG2 = 21;
	public static inline var DEFINE_BITS_JPEG3 = 35;
	public static inline var DEFINE_BITS_LOSSLESS2 = 36;
	public static inline var SYMBOL_CLASS = 76;
	public static inline var DEFINE_BINARY_DATA = 87;

	/** Not a SWF tag: marks a bitmap read from a .hab atlas (see HabReader). */
	public static inline var HAB_ATLAS_FRAME = 0x10000;
}
