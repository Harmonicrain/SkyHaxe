package skyhaxe.render;

#if (js && html5 && skyhaxe_room_batch)
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.OpenGLRenderer;
import openfl.display.PixelSnapping;
import openfl.display.Shader;
import openfl.display._internal.Context3DBuffer;
import openfl.display._internal.Context3DBuffer.Context3DElementType;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import haxe.ds.ObjectMap;

@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
@:access(openfl.display.OpenGLRenderer)
@:access(openfl.display.Shader)
@:access(openfl.display3D.Context3D)
class RoomBitmapBatch {
    static inline final STRIDE = 14;
    static var shaderTextureLimit = 8;
    static var context:Context3D;
    static var buffer:Context3DBuffer;
    static var shader:Shader;
    static var textureLimit = 1;
    static var deviceToStage = new Matrix();
    static var stats:Dynamic;

    /**
     * Experimental room-only renderer. It preserves display-list order and batches only
     * adjacent, state-compatible Bitmaps using a hardware-bounded set of existing decoded textures.
     * Everything else is flushed and rendered by OpenFL's original path.
     */
    public static function renderChildren(container:DisplayObjectContainer, renderer:OpenGLRenderer):Void {
        var children = container.__children;
        var operations:Array<Dynamic> = [];
        var eligible:Array<Bitmap> = [];
        var textureSlots:Array<Int> = [];
        var runStart = 0;
        var runLength = 0;
        var runTextures:Array<BitmapData> = [];
        var runTextureSlots:ObjectMap<BitmapData, Int> = new ObjectMap();
        var runBlend:BlendMode = null;
        var runSmoothing = false;
        var breakBlend = 0, breakSmoothing = 0, breakTextures = 0;
        var additiveFlags:Array<Bool> = [];
        // ADD sprites can share NORMAL runs: with NORMAL's (ONE, ONE_MINUS_SRC_ALPHA) factors a
        // fragment written with alpha 0 blends as (ONE, ONE), i.e. exactly OpenFL's ADD, for the
        // colour channels. Alpha then keeps the destination's value instead of src + dst, which is
        // the same only while the destination is opaque: the screen (not a render-target
        // texture), an opaque stage clear, no blend override, and no SUBTRACT drawn before.
        // Interleaved light layers otherwise split the room into ~250 draw calls a frame.
        var foldAdditive = renderer.__defaultRenderTarget == null && renderer.__overrideBlendMode == null
            && renderer.__stage != null && !renderer.__stage.__transparent;

        ensureContext(renderer);

        function flushRun():Void {
            if (runLength == 0) return;
            operations.push({start: runStart, length: runLength, textures: runTextures,
                blend: runBlend, smoothing: runSmoothing});
            runLength = 0;
            runTextures = [];
            runTextureSlots = new ObjectMap();
        }

        for (child in children) {
            var bitmap = Std.downcast(child, Bitmap);
            var valid = bitmap != null && bitmap.__renderable && bitmap.__worldAlpha > 0
                && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid
                && bitmap.__cacheBitmap == null && bitmap.__mask == null
                && bitmap.__scrollRect == null
                && (bitmap.__filters == null || bitmap.__filters.length == 0)
                && bitmap.__worldShader == null;
            if (!valid) {
                flushRun();
                operations.push({fallback: child});
                continue;
            }
            var smoothing = renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled);
            var blend = bitmap.__worldBlendMode;
            var additive = false;
            if (foldAdditive) {
                switch (blend) {
                    case ADD:
                        additive = true;
                        blend = NORMAL;
                    case MULTIPLY, SCREEN:
                    case SUBTRACT:
                        foldAdditive = false;
                    default:
                        // OpenGLRenderer.__setBlendMode gives every other mode NORMAL's factors on HTML5.
                        blend = NORMAL;
                }
            }
            if (runLength == 0 || runBlend != blend || runSmoothing != smoothing) {
                if (runLength > 0) { if (runBlend != blend) breakBlend++; else breakSmoothing++; }
                flushRun();
                runStart = eligible.length;
                runBlend = blend;
                runSmoothing = smoothing;
            }
            var textureSlot:Null<Int> = runTextureSlots.get(bitmap.__bitmapData);
            if (textureSlot == null && runTextures.length >= textureLimit) {
                breakTextures++;
                flushRun();
                runStart = eligible.length;
                runBlend = blend;
                runSmoothing = smoothing;
            }
            textureSlot = runTextureSlots.get(bitmap.__bitmapData);
            if (textureSlot == null) {
                textureSlot = runTextures.length;
                runTextures.push(bitmap.__bitmapData);
                runTextureSlots.set(bitmap.__bitmapData, textureSlot);
            }
            eligible.push(bitmap);
            textureSlots.push(textureSlot);
            additiveFlags.push(additive);
            runLength++;
        }
        flushRun();

        // Last-frame shape of the room batch, readable from the console as window.__skyRoomBatchStats.
        if (stats == null) {
            stats = {frames: 0, sprites: 0, eligible: 0, runs: 0, fallbacks: 0, textureBinds: 0, textureLimit: 0};
            js.Syntax.code("window.__skyRoomBatchStats = {0}", stats);
        }
        stats.frames++;
        stats.sprites = children.length;
        stats.eligible = eligible.length;
        stats.textureLimit = textureLimit;
        var statRuns = 0, statFallbacks = 0, statBinds = 0;
        for (operation in operations) {
            if (Reflect.field(operation, "fallback") != null) statFallbacks++;
            else { statRuns++; statBinds += (operation.textures : Array<BitmapData>).length; }
        }
        stats.runs = statRuns;
        stats.fallbacks = statFallbacks;
        stats.textureBinds = statBinds;
        stats.breakBlend = breakBlend;
        stats.breakSmoothing = breakSmoothing;
        stats.breakTextures = breakTextures;

        #if skyhaxe_profile
        var fallbackCount = 0;
        var batchRunCount = 0;
        for (operation in operations) {
            if (Reflect.field(operation, "fallback") != null) fallbackCount++;
            else batchRunCount++;
        }
        skyhaxe.ProfileRuntime.count("roomBatch.inputSprites", children.length);
        skyhaxe.ProfileRuntime.count("roomBatch.eligibleSprites", eligible.length);
        skyhaxe.ProfileRuntime.count("roomBatch.fallbackSprites", fallbackCount);
        skyhaxe.ProfileRuntime.count("roomBatch.runs", batchRunCount);
        skyhaxe.ProfileRuntime.gauge("roomBatch.textureLimit", textureLimit);
        #end

        if (eligible.length > 0) {
            if (buffer == null || context != renderer.__context3D) {
                context = renderer.__context3D;
                buffer = new Context3DBuffer(context, Context3DElementType.QUADS, eligible.length, STRIDE);
            } else {
                buffer.resize(eligible.length, STRIDE);
            }
            var data = buffer.vertexBufferData;
            var position = 0;
            // Vertices are written in device space, snapped exactly as OpenGLRenderer.__getMatrix
            // snaps a single Bitmap draw: concatenate the renderer's world transform first, then
            // round only for ALWAYS, or AUTO at unit scale. Rounding in stage space instead
            // shifts the NEAREST sampling phase of whole planes on scaled (high-DPI) stages.
            var world = renderer.__worldTransform;
            for (bitmap in eligible) {
                var transform = bitmap.__renderTransform;
                var a = transform.a * world.a + transform.b * world.c;
                var b = transform.a * world.b + transform.b * world.d;
                var c = transform.c * world.a + transform.d * world.c;
                var d = transform.c * world.b + transform.d * world.d;
                var tx = transform.tx * world.a + transform.ty * world.c + world.tx;
                var ty = transform.tx * world.b + transform.ty * world.d + world.ty;
                var snapping = bitmap.pixelSnapping;
                if (snapping == PixelSnapping.ALWAYS || (snapping == PixelSnapping.AUTO && b == 0 && c == 0
                        && a < 1.001 && a > 0.999 && d < 1.001 && d > 0.999)) {
                    tx = Math.round(tx);
                    ty = Math.round(ty);
                }
                var width = bitmap.__bitmapData.width;
                var height = bitmap.__bitmapData.height;
                var x0 = tx;
                var y0 = ty;
                var x1 = a * width + tx;
                var y1 = b * width + ty;
                var x2 = c * height + tx;
                var y2 = d * height + ty;
                var x3 = a * width + c * height + tx;
                var y3 = b * width + d * height + ty;
                var color = bitmap.__worldColorTransform;
                var spriteIndex = Std.int(position / (STRIDE * 4));
                // Folded ADD sprites carry +32 on their texture id; the shader zeroes their alpha.
                var textureSlot = textureSlots[spriteIndex] + (additiveFlags[spriteIndex] ? 32 : 0);
                writeVertex(data, position, x0, y0, 0, 0, bitmap.__worldAlpha, color, textureSlot); position += STRIDE;
                writeVertex(data, position, x1, y1, 1, 0, bitmap.__worldAlpha, color, textureSlot); position += STRIDE;
                writeVertex(data, position, x2, y2, 0, 1, bitmap.__worldAlpha, color, textureSlot); position += STRIDE;
                writeVertex(data, position, x3, y3, 1, 1, bitmap.__worldAlpha, color, textureSlot); position += STRIDE;
                if (bitmap.__bitmapData.image != null)
                    bitmap.__imageVersion = bitmap.__bitmapData.image.version;
            }
            buffer.flushVertexBufferData();
        }

        for (operation in operations) {
            var fallback:DisplayObject = Reflect.field(operation, "fallback");
            if (fallback != null) {
                renderer.__renderDrawable(fallback);
                fallback.__renderDirty = false;
                continue;
            }
            drawRun(renderer, operation);
            var start:Int = operation.start;
            var end:Int = start + operation.length;
            for (index in start...end) {
                var bitmap = eligible[index];
                renderer.__renderEvent(bitmap);
                bitmap.__renderDirty = false;
            }
        }
    }

    static function writeVertex(data:Dynamic, position:Int, x:Float, y:Float, u:Float, v:Float,
            alpha:Float, color:ColorTransform, textureSlot:Int):Void {
        data[position] = x; data[position + 1] = y;
        data[position + 2] = u; data[position + 3] = v;
        data[position + 4] = alpha;
        data[position + 5] = color.redMultiplier;
        data[position + 6] = color.greenMultiplier;
        data[position + 7] = color.blueMultiplier;
        data[position + 8] = color.alphaMultiplier;
        data[position + 9] = color.redOffset;
        data[position + 10] = color.greenOffset;
        data[position + 11] = color.blueOffset;
        data[position + 12] = color.alphaOffset;
        data[position + 13] = textureSlot;
    }

    static function ensureContext(renderer:OpenGLRenderer):Void {
        if (context == renderer.__context3D && shader != null) return;
        context = renderer.__context3D;
        buffer = null;
        var hardwareLimit = Std.int(renderer.__gl.getParameter(renderer.__gl.MAX_TEXTURE_IMAGE_UNITS));
        // Every sampler a shader declares counts against the unit limit, so the 16-sampler variant
        // is only linked where the GPU has 16 units (most desktop GPUs; WebGL1 guarantees 8).
        if (hardwareLimit >= 16) {
            shader = new RoomMultiTextureShader16();
            shaderTextureLimit = 16;
        } else {
            shader = new RoomMultiTextureShader();
            shaderTextureLimit = 8;
        }
        textureLimit = Std.int(Math.max(1, Math.min(shaderTextureLimit, hardwareLimit)));
    }

    static function drawRun(renderer:OpenGLRenderer, operation:Dynamic):Void {
        renderer.__setBlendMode(operation.blend);
        renderer.setShader(shader);
        var textures:Array<BitmapData> = operation.textures;
        for (index in 0...shaderTextureLimit) {
            var input:Dynamic = Reflect.field(shader.data, "room_Texture" + index);
            input.input = index < textures.length ? textures[index] : null;
            input.filter = operation.smoothing ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST;
        }
        // Vertices are already in device space; undo the world transform __getMatrix appends.
        deviceToStage.copyFrom(renderer.__worldTransform);
        deviceToStage.invert();
        renderer.applyMatrix(renderer.__getMatrix(deviceToStage, PixelSnapping.NEVER));
        renderer.useAlphaArray();
        renderer.applyHasColorTransform(true);
        renderer.useColorTransformArray();
        renderer.updateShader();

        var start:Int = operation.start;
        var remaining:Int = operation.length;
        while (remaining > 0) {
            var length = Std.int(Math.min(remaining, context.__quadIndexBufferElements));
            var vertexOffset = start * STRIDE * 4;
            if (shader.__position != null)
                context.setVertexBufferAt(shader.__position.index, buffer.vertexBuffer, vertexOffset, Context3DVertexBufferFormat.FLOAT_2);
            if (shader.__textureCoord != null)
                context.setVertexBufferAt(shader.__textureCoord.index, buffer.vertexBuffer, vertexOffset + 2, Context3DVertexBufferFormat.FLOAT_2);
            if (shader.__alpha != null)
                context.setVertexBufferAt(shader.__alpha.index, buffer.vertexBuffer, vertexOffset + 4, Context3DVertexBufferFormat.FLOAT_1);
            if (shader.__colorMultiplier != null)
                context.setVertexBufferAt(shader.__colorMultiplier.index, buffer.vertexBuffer, vertexOffset + 5, Context3DVertexBufferFormat.FLOAT_4);
            if (shader.__colorOffset != null)
                context.setVertexBufferAt(shader.__colorOffset.index, buffer.vertexBuffer, vertexOffset + 9, Context3DVertexBufferFormat.FLOAT_4);
            var textureId:Dynamic = Reflect.field(shader.data, "room_TextureId");
            if (textureId != null)
                context.setVertexBufferAt(textureId.index, buffer.vertexBuffer, vertexOffset + 13, Context3DVertexBufferFormat.FLOAT_1);
            context.drawTriangles(context.__quadIndexBuffer, 0, length * 2);
            start += length;
            remaining -= length;
        }
        renderer.__clearShader();
    }
}
#end
