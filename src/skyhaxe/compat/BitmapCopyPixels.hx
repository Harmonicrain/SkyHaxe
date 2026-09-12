package skyhaxe.compat;

#if (js && html5)
import lime.graphics.Image;
import lime.math.Rectangle;
import lime.math.Vector2;

/** Correct Flash-style joint clipping before Lime's independently-clipped copyPixels path. */
class BitmapCopyPixels {
    static var installed = false;
    static var original:Dynamic;

    public static function install():Void {
        if (installed) return;
        installed = true;
        var prototype:Dynamic = untyped Image.prototype;
        original = Reflect.field(prototype, "copyPixels");
        var bridge = patched;
        Reflect.setField(prototype, "copyPixels", untyped js.Syntax.code(
            "function(sourceImage, sourceRect, destPoint, alphaImage, alphaPoint, mergeAlpha) { return {0}(this, sourceImage, sourceRect, destPoint, alphaImage, alphaPoint, mergeAlpha); }",
            bridge));
    }

    static function patched(target:Image, source:Image, sourceRect:Rectangle, destPoint:Vector2,
            alphaImage:Image, alphaPoint:Vector2, mergeAlpha:Bool):Void {
        if (target == null || source == null || sourceRect == null || destPoint == null) return;

        // Parameter t is the distance from the original rectangle's upper-left pixel. Intersect
        // source and destination constraints in that one coordinate system so a negative source
        // and a negative destination cannot shorten the copy twice.
        var left = Math.max(0, Math.max(-sourceRect.x, -destPoint.x));
        var top = Math.max(0, Math.max(-sourceRect.y, -destPoint.y));
        var right = Math.min(sourceRect.width,
            Math.min(source.width - sourceRect.x, target.width - destPoint.x));
        var bottom = Math.min(sourceRect.height,
            Math.min(source.height - sourceRect.y, target.height - destPoint.y));
        if (right <= left || bottom <= top) return;

        var clippedSource = new Rectangle(sourceRect.x + left, sourceRect.y + top,
            right - left, bottom - top);
        var clippedDest = new Vector2(destPoint.x + left, destPoint.y + top);
        var clippedAlpha = alphaPoint == null ? null
            : new Vector2(alphaPoint.x + left, alphaPoint.y + top);
        untyped original.call(target, source, clippedSource, clippedDest,
            alphaImage, clippedAlpha, mergeAlpha);
    }
}
#end
