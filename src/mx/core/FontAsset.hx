package mx.core;

import openfl.text.Font;
import openfl.text.FontStyle;
import openfl.text.FontType;
import skyhaxe.assets.EmbeddedFontCatalog;

/**
 * Flex FontAsset VM boundary.
 *
 * The original generated subclasses remain the class identities registered by FontEnum. Their
 * family and style come from a generated, hash-pinned catalogue of the AS3 Embed declarations.
 * Browser text never rasterizes through this object: the OpenFL text path is patched to HabboText.
 */
class FontAsset extends Font {
    public function new() {
        super();
        var className = Type.getClassName(Type.getClass(this));
        var metadata = EmbeddedFontCatalog.metadataFor(className);
        fontName = metadata.name;
        fontStyle = cast switch (metadata.style) {
            case "bold": FontStyle.BOLD;
            case "italic": FontStyle.ITALIC;
            case "boldItalic": FontStyle.BOLD_ITALIC;
            default: FontStyle.REGULAR;
        };
        fontType = FontType.EMBEDDED;
    }
}
