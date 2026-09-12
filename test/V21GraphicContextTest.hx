import com.sulake.core.window.graphics.GraphicContext;
import com.sulake.core.window.graphics.IGraphicContext;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.filters.ColorMatrixFilter;

/** Actual converted display-list behavior, not a handwritten substitute. */
class V21GraphicContextTest {
    static function main() {
        var baseline = GraphicContext.numGraphicContexts;
        var first = new Sprite();
        var second = new Sprite();
        var context = new GraphicContext("canary", GraphicContext.GC_TYPE_BITMAP, new Rectangle(0, 0, 8, 8));
        var surface:IGraphicContext = context;
        surface.graphicParent = first;
        if (context.parent != first || first.numChildren != 1 || surface.graphicParent != first)
            throw "Context was not attached to its native parent";
        surface.graphicParent = second;
        if (first.numChildren != 0 || second.numChildren != 1 || context.parent != second)
            throw "Reparenting did not detach the old parent";
        surface.mouse = true;
        if (!context.mouseEnabled || !surface.mouse) throw "Mouse property did not reach OpenFL";
        surface.filters = [new ColorMatrixFilter()];
        if (surface.filters.length != 1 || context.getDisplayObject().filters.length != 1)
            throw "Filters did not reach the inner display object";
        context.dispose();
        if (!surface.disposed || second.numChildren != 0 || context.parent != null)
            throw "Disposal left the context attached";
        if (GraphicContext.numGraphicContexts != baseline) throw "Context allocation count leaked";
        trace("V21_GRAPHIC_CONTEXT_PASS attach reparent mouse filters dispose");
    }
}
