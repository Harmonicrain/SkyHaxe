package skyhaxe.assets;

#if (js && html5)
import haxe.io.Bytes;
import js.Browser;
import js.html.Blob;
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import openfl.display.BitmapData;

private typedef NativeImageJob = {
    var bytes:Bytes;
    var mime:String;
    var promise:Promise<BitmapData>;
}

/**
 * A bounded queue for SWF-embedded PNG/JPEG symbols.
 *
 * Lime routes blob images through the same 17-slot queue as HTTP. A component SWF burst can add
 * two thousand images to that queue, delaying unrelated client traffic. This keeps native browser
 * decoding but isolates it from networking and supplies enough work for Chromium's decoders.
 */
class NativeImageDecodeQueue {
    static inline final LIMIT = 64;
    static final queue:Array<NativeImageJob> = [];
    static var active = 0;

    public static function decode(bytes:Bytes, mime:String):Future<BitmapData> {
        var promise = new Promise<BitmapData>();
        queue.push({bytes: bytes, mime: mime, promise: promise});
        pump();
        return promise.future;
    }

    static function pump():Void {
        while (active < LIMIT && queue.length > 0) {
            active++;
            start(queue.shift());
        }
    }

    static function start(job:NativeImageJob):Void {
        var blob = new Blob([job.bytes.getData()], {type: job.mime});
        var settled = false;
        function finish():Void {
            if (settled) return;
            settled = true;
            active--;
            pump();
        }
        Browser.window.createImageBitmap(blob).then(function(bitmap) {
            try {
                // Lime's ImageBuffer cannot retain an ImageBitmap directly. A canvas keeps the
                // decoded native surface without the old byte-by-byte colour conversion.
                var canvas = Browser.document.createCanvasElement();
                canvas.width = bitmap.width;
                canvas.height = bitmap.height;
                var context = canvas.getContext2d();
                context.drawImage(bitmap, 0, 0);
                bitmap.close();
                var buffer = new ImageBuffer(null, canvas.width, canvas.height);
                buffer.src = canvas;
                job.promise.complete(BitmapData.fromImage(new Image(buffer), true));
            } catch (error:Dynamic) {
                job.promise.error(error);
            }
            finish();
            return null;
        }, function(error) {
            job.promise.error(error);
            finish();
            return null;
        });
    }
}
#end
