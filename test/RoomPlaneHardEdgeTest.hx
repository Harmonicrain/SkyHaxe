import com.sulake.habbo.room.object.visualization.room.RoomPlane;
import openfl.display.BitmapData;
import openfl.geom.Matrix;

/**
 * The wall-top rasterisation defect, pinned to the matrix that actually produced it.
 *
 * Wall tops reach `RoomPlane.draw` with a sheared, half-scaled transform that fails its pixel-exact
 * fast path (which admits only `a == 1 && d == 1 && c == 0`), so before this fix they fell back to
 * `BitmapData.draw`. OpenFL applies `smoothing = false` to interior sampling only and lets the
 * canvas antialias the transformed quad's boundary, baking partial alpha into the plane bitmap --
 * the dark staircase along the tops.
 *
 * `a=1 b=0.5 c=-1 d=0.5` over a 256x8 source is measured, not invented: it is what a live wall top
 * reported when its texture rebuild was forced. Wall faces arrive as `a=1 b=0.5 c=0 d=1`, pass the
 * gate, and were never affected -- which is why the artifact was confined to the sloping tops.
 *
 * Both directions are asserted on purpose. Proving the blit emits hard edges is only half a
 * regression test; the control proves the old path still antialiases the very same transform, so
 * this fails if the rewrite rule ever stops applying rather than quietly passing against a
 * reference that no longer reproduces the defect.
 */
@:access(com.sulake.habbo.room.object.visualization.room.RoomPlane)
class RoomPlaneHardEdgeTest {
    static inline var SOURCE_WIDTH = 256;
    static inline var SOURCE_HEIGHT = 8;

    static function main() {
        var source = new BitmapData(SOURCE_WIDTH, SOURCE_HEIGHT, true, 0xFF8A5A2B);
        if (partialAlphaCount(source) != 0) throw "Fixture source must be fully opaque";

        var wallTop = new Matrix(1, 0.5, -1, 0.5, 64, 64);

        var hard = new BitmapData(512, 256, true, 0x00000000);
        RoomPlane._skyHardEdgedDraw(hard, source, wallTop);
        var hardPartial = partialAlphaCount(hard);
        if (hardPartial != 0)
            throw 'Hard-edged blit produced $hardPartial antialiased pixels; wall tops regressed';
        if (opaqueCount(hard) == 0)
            throw "Hard-edged blit drew nothing; the transform or bounds are wrong";

        // Control: the path the defect came from, on the identical transform.
        var soft = new BitmapData(512, 256, true, 0x00000000);
        soft.draw(source, wallTop, null, null, null, false);
        if (partialAlphaCount(soft) == 0)
            throw "Control draw no longer antialiases; this test can no longer detect the defect";

        trace("ROOM_PLANE_HARD_EDGE_PASS matrix=a1,b0.5,c-1,d0.5 source=" + SOURCE_WIDTH + "x"
            + SOURCE_HEIGHT + " hard-partial=0 control-partial=" + partialAlphaCount(soft));
    }

    /** Pixels that are neither fully opaque nor fully clear -- the antialiasing signature. */
    static function partialAlphaCount(bitmap:BitmapData):Int {
        var total = 0;
        for (y in 0...bitmap.height) {
            for (x in 0...bitmap.width) {
                var alpha = (bitmap.getPixel32(x, y) >>> 24) & 0xFF;
                if (alpha != 0 && alpha != 255) total++;
            }
        }
        return total;
    }

    static function opaqueCount(bitmap:BitmapData):Int {
        var total = 0;
        for (y in 0...bitmap.height) {
            for (x in 0...bitmap.width) {
                if (((bitmap.getPixel32(x, y) >>> 24) & 0xFF) == 255) total++;
            }
        }
        return total;
    }
}
