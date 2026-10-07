package com.sulake.core.assets.loaders;

import com.sulake.core.runtime.events.EventDispatcherWrapper;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.ProgressEvent;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.display.BitmapData;

/** Individual browser file transport; deliberately does not load Flash library SWFs/FZip. */
class Html5AssetLoader extends EventDispatcherWrapper implements IAssetLoader {
    public var url(get, never):String;
    public var content(get, never):ASObject;
    public var mimeType(get, never):String;
    public var bytesLoaded(get, never):UInt;
    public var bytesTotal(get, never):UInt;
    public var errorCode(get, never):UInt;
    public var cacheKey(get, never):String;
    public var cacheRevision(get, never):Int;
    public var fromCache(get, never):Bool;
    public var id(get, never):Int;
    static var nextId = 0;
    final identifier = ++nextId;
    final type:String;
    var address:String = "";
    var data:Dynamic;
    var loaded:UInt = 0;
    var total:UInt = 0;
    var status:UInt = 0;
    var transport:URLLoader;
    var generation = 0;

    public function new(type:String) { super(); this.type = type; }
    function get_url():String return address;
    function get_content():ASObject return data;
    function get_mimeType():String return type;
    function get_bytesLoaded():UInt return loaded;
    function get_bytesTotal():UInt return total;
    function get_errorCode():UInt return status;
    function get_cacheKey():String return null;
    function get_cacheRevision():Int return -1;
    function get_fromCache():Bool return false;
    function get_id():Int return identifier;

    public function load(request:URLRequest):Void {
        if (disposed || transport != null) throw new haxe.Exception("Asset loader is disposed or already started");
        address = request.url;
        var ticket = ++generation;
        transport = new URLLoader();
        transport.dataFormat = StringTools.startsWith(type, "image/") ? URLLoaderDataFormat.BINARY : URLLoaderDataFormat.TEXT;
        transport.addEventListener(Event.OPEN, function(_) { if (active(ticket)) emit(AssetLoaderEvent.ASSETLOADEREVENTOPEN); });
        transport.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(event:HTTPStatusEvent) {
            if (active(ticket)) { status = event.status; emit(AssetLoaderEvent.ASSETLOADEREVENTSTATUS); }
        });
        transport.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent) {
            if (active(ticket)) { loaded = Std.int(event.bytesLoaded); total = Std.int(event.bytesTotal); emit(AssetLoaderEvent.ASSETLOADEREVENTPROGRESS); }
        });
        transport.addEventListener(IOErrorEvent.IO_ERROR, function(_) { if (active(ticket)) emit(AssetLoaderEvent.ASSETLOADEREVENTERROR); });
        transport.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(_) { if (active(ticket)) emit(AssetLoaderEvent.ASSETLOADEREVENTERROR); });
        transport.addEventListener(Event.COMPLETE, function(_) {
            if (!active(ticket)) return;
            loaded = transport.bytesLoaded;
            total = transport.bytesTotal;
            if (StringTools.startsWith(type, "image/")) {
                BitmapData.loadFromBytes(cast transport.data).onComplete(function(bitmap) {
                    if (!active(ticket)) { bitmap.dispose(); return; }
                    data = bitmap;
                    emit(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE);
                }).onError(function(_) { if (active(ticket)) emit(AssetLoaderEvent.ASSETLOADEREVENTERROR); });
            } else {
                data = transport.data;
                emit(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE);
            }
        });
        var actual = skyhaxe.compat.BrowserAssetUrl.normalizeRequest(request);
        transport.load(actual);
    }
    inline function active(ticket:Int):Bool return !disposed && ticket == generation;
    function emit(type:String):Void { dispatchEvent(new AssetLoaderEvent(type, status)); }
    override public function dispose():Void {
        if (disposed) return;
        generation++;
        if (transport != null) { try { transport.close(); } catch (_:Dynamic) {} transport = null; }
        // Successfully published content belongs to the library, not the loader ticket.
        data = null;
        super.dispose();
    }
}
