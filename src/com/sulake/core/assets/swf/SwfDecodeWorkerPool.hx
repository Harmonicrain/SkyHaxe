package com.sulake.core.assets.swf;

#if (js && html5)
import haxe.ds.IntMap;
import lime.app.Future;
import lime.app.Promise;
import com.sulake.core.assets.swf.SwfBitmap.SwfPixels;
import js.Browser;
import js.html.MessageEvent;
import js.lib.Uint8Array;
import js.html.Worker;

private typedef SwfWorkerJob = {
    var id:Int;
    var character:SwfCharacter;
    var promise:Promise<SwfPixels>;
    var bytes:Int;
}

/** Two-worker pool for the CPU-heavy zlib and lossless-pixel path. */
class SwfDecodeWorkerPool {
    static inline final MAX_WORKERS = 4;
    static inline final QUEUE_BUDGET = 64 * 1024 * 1024;
    static final queue:Array<SwfWorkerJob> = [];
    static final jobs = new IntMap<SwfWorkerJob>();
    static final idle:Array<Worker> = [];
    static var initialized = false;
    static var supported = true;
    static var queuedBytes = 0;
    static var nextId = 1;

    public static function decode(character:SwfCharacter):Future<SwfPixels> {
        initialize();
        if (!supported || queuedBytes + character.payload.length > QUEUE_BUDGET) {
            SwfLoadMetrics.count("workerFallbacks");
            return Future.withValue(SwfBitmap.decode(character));
        }
        var promise = new Promise<SwfPixels>();
        var job = {id: nextId++, character: character, promise: promise,
            bytes: character.payload.length};
        queue.push(job);
        queuedBytes += job.bytes;
        pump();
        return promise.future;
    }

    static function initialize():Void {
        if (initialized) return;
        initialized = true;
        supported = untyped js.Syntax.code("typeof Worker !== 'undefined' && typeof DecompressionStream !== 'undefined'");
        if (!supported) return;
        try {
            var hardware:Int = untyped js.Syntax.code("navigator.hardwareConcurrency || 2");
            var count = Std.int(Math.max(2, Math.min(MAX_WORKERS, hardware - 1)));
            for (_ in 0...count) addWorker();
            SwfLoadMetrics.add("workerCount", count);
        } catch (_:Dynamic) {
            supported = false;
            idle.resize(0);
        }
    }

    static function addWorker():Void {
        var worker = new Worker("/swf-decode-worker.js");
        worker.onmessage = function(event:MessageEvent) complete(worker, event.data);
        worker.onerror = function(event) {
            failWorker(worker, Std.string(event.message));
            return true;
        };
        idle.push(worker);
    }

    static function pump():Void {
        while (supported && idle.length > 0 && queue.length > 0) {
            var worker = idle.pop();
            var job = queue.shift();
            jobs.set(job.id, job);
            var source = new Uint8Array(job.character.payload.getData());
            var payload = new Uint8Array(source.length);
            payload.set(source);
            worker.postMessage({id: job.id, tag: job.character.tag, payload: payload.buffer},
                [payload.buffer]);
            Reflect.setField(worker, "__skyhaxeJob", job.id);
        }
    }

    static function complete(worker:Worker, data:Dynamic):Void {
        var id:Int = data.id;
        var job = jobs.get(id);
        jobs.remove(id);
        Reflect.deleteField(worker, "__skyhaxeJob");
        if (job != null) {
            queuedBytes -= job.bytes;
            if (data.error != null) {
                // Browser codec support varies. Preserve correctness with the proven decoder.
                SwfLoadMetrics.count("workerFallbacks");
                try job.promise.complete(SwfBitmap.decode(job.character))
                catch (error:Dynamic) job.promise.error(error);
            } else {
                var array = new Uint8Array(data.rgba);
                job.promise.complete({width: data.width, height: data.height,
                    rgba: haxe.io.Bytes.ofData(array.buffer)});
                SwfLoadMetrics.count("workerDecodes");
                SwfLoadMetrics.add("workerCpuMs", data.decodeMs);
            }
        }
        idle.push(worker);
        pump();
    }

    static function failWorker(worker:Worker, message:String):Void {
        var id:Null<Int> = Reflect.field(worker, "__skyhaxeJob");
        if (id != null) {
            var job = jobs.get(id);
            jobs.remove(id);
            if (job != null) {
                queuedBytes -= job.bytes;
                try job.promise.complete(SwfBitmap.decode(job.character))
                catch (error:Dynamic) job.promise.error(error);
            }
        }
        worker.terminate();
        try addWorker() catch (_:Dynamic) supported = false;
        pump();
    }
}
#end
