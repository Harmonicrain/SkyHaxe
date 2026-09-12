package mx.core;

#if html5
import openfl.display.Sprite;

/**
 * HTML5 boundary for Flex's generated SWF application base.
 *
 * The clean client component-library wrappers extend SimpleApplication only because the Flex
 * compiler used it as their SWF document root. Their executable contract is DisplayObject/Sprite;
 * preloading and SWF frame construction belong to the browser boot pipeline.
 */
#if skyhaxe_component_embed_manifest
@:autoBuild(skyhaxe.assets.ComponentLibraryEmbedMacro.build())
#end
class SimpleApplication extends Sprite {
    public function new() {
        super();
    }
}
#end
