package com.sulake.core.utils;

import com.sulake.core.assets.swf.SwfBitmap;
import com.sulake.core.assets.swf.SwfByteCache;
import com.sulake.core.assets.swf.SwfCharacter;
import com.sulake.core.assets.swf.SwfCharacter.SwfCharacterKind;
import com.sulake.core.assets.swf.SwfFile;
import com.sulake.core.assets.swf.SwfLoadMetrics;
import com.sulake.core.runtime.IDisposable;
import com.sulake.core.runtime.events.EventDispatcherWrapper;
import com.sulake.core.utils.xml.XML;
import deng.fzip.FZip;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import haxe.io.Bytes;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import js.Browser;
import lime.app.Future;
import openfl.display.BitmapData;
import skyhaxe.assets.SwfEmbedFactory;
import skyhaxe.assets.LazySwfBitmap;

/**
 * HTML5 implementation of Flash's executable-SWF LibraryLoader boundary.
 *
 * It preserves LibraryLoader's event/resource contract. Only the platform operation differs:
 * downloaded SWF SymbolClass exports are decoded into equivalent constructor functions instead
 * of asking a Flash VM to execute the file.
 */
class LibraryLoader extends EventDispatcherWrapper implements IDisposable {
    public static inline final DEFAULT_MAX_RETRIES = 5;
    public static inline final LIBRARY_LOADER_FINALIZE = "LIBRARY_LOADER_FINALIZE";
    public static inline final USE_DOWNLOAD_THROTTLING = true;
    public static inline final MAX_SIMULTANEOUS_DOWNLOADS = 6;

    var _context:LoaderContext;
    var _request:URLRequest;
    var _manifest:XML;
    var _resource:Class<Dynamic>;
    /**
     * True while `materialize` is still adding assets.
     *
     * A bitmap that finishes decoding mid-scan would otherwise drive `pending` to zero and
     * dispatch COMPLETE while the resource is still half-populated, so a consumer reading a
     * symbol added later -- an effect library's `animation` -- gets null.
     */
    var _scanning:Bool = false;
    var _name:String;
    var _ready = false;
    var _paused = false;
    var _status = 0;
    var _bytesTotal:UInt = 0;
    var _bytesLoaded:UInt = 0;
    var _start:Int = 0;
    var _end:Int = 0;
    var _errorMsg = "";
    var _debugMsg = "";

    public function new(context:LoaderContext = null, paused:Bool = false, debug:Bool = false) {
        super();
        _context = context == null ? new LoaderContext(false, ApplicationDomain.currentDomain) : context;
        _paused = paused;
    }

    public var url(get, never):String;
    function get_url():String return _request == null ? null : _request.url;
    public var name(get, never):String;
    function get_name():String return _name;
    public var ready(get, never):Bool;
    function get_ready():Bool return _ready;
    public var status(get, never):Int;
    function get_status():Int return _status;
    public var domain(get, never):ApplicationDomain;
    function get_domain():ApplicationDomain return ApplicationDomain.currentDomain;
    public var request(get, never):URLRequest;
    function get_request():URLRequest return _request;
    public var resource(get, never):Class<Dynamic>;
    function get_resource():Class<Dynamic> return _resource;
    public var manifest(get, never):XML;
    function get_manifest():XML return _manifest;
    public var bytesTotal(get, never):UInt;
    function get_bytesTotal():UInt return _bytesTotal;
    public var bytesLoaded(get, never):UInt;
    function get_bytesLoaded():UInt return _bytesLoaded;
    public var elapsedTime(get, never):UInt;
    function get_elapsedTime():UInt return cast ((_ready ? _end : flash.Lib.getTimer()) - _start);
    public var paused(get, never):Bool;
    function get_paused():Bool return _paused;
    public var zipLoader(get, never):FZip;
    function get_zipLoader():FZip return null;
    var content(get, never):DisplayObject;
    function get_content():DisplayObject return null;

    public function load(request:URLRequest, retries:Int = DEFAULT_MAX_RETRIES):Void {
        _request = request;
        _request.url = browserUrl(request.url);
        _name = parseName(_request.url);
        _ready = false;
        if (!_paused) start();
    }

    public function resume():Void {
        if (_paused && !disposed) {
            _paused = false;
            start();
        }
    }

    function start():Void {
        if (_request == null || disposed) return;
        _start = flash.Lib.getTimer();
        var target = _request.url;
        SwfByteCache.fetch(target).then(function(bytes) {
            _status = 200;
            _bytesLoaded = _bytesTotal = bytes.length;
            dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_PROGRESS,
                _status, _bytesTotal, _bytesLoaded, elapsedTime));
            var parseStarted = Browser.window.performance.now();
            SwfFile.readAsync(bytes).onComplete(function(file) {
                SwfLoadMetrics.add("parseWallMs", Browser.window.performance.now() - parseStarted);
                SwfLoadMetrics.count("filesParsed");
                materialize(file);
            }).onError(function(error) {
                fail('Could not read $target as a SWF: $error');
            });
            return null;
        }).catchError(function(error) {
            fail(Std.string(error));
        });
    }

    function materialize(file:SwfFile):Void {
        var manifestCharacter = file.symbols.get(_name + "_manifest");
        if (manifestCharacter == null) {
            fail('Failed to find embedded manifest.xml in $url');
            return;
        }
        _manifest = new XML(manifestCharacter.payload.toString());
        var resource:Dynamic = {};
        Reflect.setField(resource, "manifest", SwfEmbedFactory.bytes(manifestCharacter.payload));

        var assets = _manifest.child("library").at(0);
        if (assets == null) {
            fail('Provided manifest in $url contains no library node');
            return;
        }
        var pending = 0;
        var failed:Array<String> = [];
        var decoded = new IntMap<Future<BitmapData>>();
        var lazyLossless = new IntMap<LazySwfBitmap>();
        var planned = new StringMap<Bool>();
        function schedule(assetName:String, character:SwfCharacter, source:String):Void {
            if (planned.exists(assetName)) return;
            planned.set(assetName, true);
            if (character.encoding() == "zlib") {
                var lazy = lazyLossless.get(character.id);
                if (lazy == null) {
                    lazy = new LazySwfBitmap(character);
                    lazyLossless.set(character.id, lazy);
                    SwfLoadMetrics.count("lazyLosslessSymbols");
                }
                Reflect.setField(resource, assetName, SwfEmbedFactory.lazyBitmap(lazy));
                return;
            }
            pending++;
            var future = decoded.get(character.id);
            if (future == null) {
                SwfLoadMetrics.count("bitmapDecodes");
                SwfLoadMetrics.count(source + "BitmapDecodes");
                if (source == "extra") SwfLoadMetrics.count("extraBitmapDecodes." + _name);
                future = SwfBitmap.decodeBitmapAsync(character);
                decoded.set(character.id, future);
            } else {
                SwfLoadMetrics.count("decodeJoins");
            }
            future.onComplete(function(bitmap) {
                // The exported constructor clones on instantiation, matching Flash's separate
                // BitmapData ownership while aliases safely share this immutable source surface.
                Reflect.setField(resource, assetName, SwfEmbedFactory.bitmap(bitmap));
                if (--pending == 0 && !_scanning) finish(resource, failed);
            }).onError(function(error) {
                failed.push(assetName + ": " + Std.string(error));
                if (--pending == 0 && !_scanning) finish(resource, failed);
            });
        }
        _scanning = true;
        for (asset in assets.child("assets").at(0).child("asset")) {
            var assetName = asset.attribute("name").toString();
            var character = findCharacter(file, assetName);
            if (character == null) continue;
            switch (character.kind) {
                case Bitmap:
                    SwfLoadMetrics.count("manifestBitmapRefs");
                    schedule(assetName, character, "manifest");
                case Binary:
                    Reflect.setField(resource, assetName, SwfEmbedFactory.bytes(character.payload));
                case Sound:
                    failed.push(assetName + ": embedded SWF sound constructor is not implemented");
            }
        }

        // Flash hands back the SWF's document class, so every exported symbol is a property of it
        // whether or not the manifest mentions it. Effect libraries depend on binary exports and
        // public-room shells also use bitmap exports which are absent from their asset manifest.
        //
        // Names are exported both bare and prefixed with the library name; the bare form is what
        // the AS3 refers to. Anything the manifest already named keeps the name it was given.
        for (exported in file.exportedNames()) {
            var character = file.symbols.get(exported);
            if (character == null) continue;
            var fieldName = StringTools.startsWith(exported, _name + "_")
                ? exported.substr(_name.length + 1)
                : exported;
            if (fieldName == "" || Reflect.hasField(resource, fieldName)) continue;
            switch (character.kind) {
                case Bitmap:
                    SwfLoadMetrics.count("extraBitmapExports");
                    schedule(fieldName, character, "extra");
                case Binary:
                    Reflect.setField(resource, fieldName, SwfEmbedFactory.bytes(character.payload));
                case Sound:
                    // Not reported: these are symbols nothing asked for, unlike the manifest path.
            }
        }

        _scanning = false;
        if (pending == 0) finish(resource, failed);
    }

    function findCharacter(file:SwfFile, assetName:String):SwfCharacter {
        var result = file.symbols.get(assetName);
        if (result == null) result = file.symbols.get(_name + "_" + assetName);
        return result;
    }

    function finish(resource:Dynamic, failed:Array<String>):Void {
        if (disposed || _ready) return;
        if (failed.length > 0)
            Browser.console.warn("SKYHAXE_SWF_LIBRARY_PARTIAL " + _name + " " + failed.slice(0, 8).join(" | "));
        var registerStarted = Browser.window.performance.now();
        _resource = cast resource;
        _ready = true;
        _end = flash.Lib.getTimer();
        dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_COMPLETE,
            _status, _bytesTotal, _bytesLoaded, elapsedTime));
        dispatchEvent(new Event(LIBRARY_LOADER_FINALIZE));
        SwfLoadMetrics.add("registrationMs", Browser.window.performance.now() - registerStarted);
        SwfLoadMetrics.count("librariesReady");
    }

    function fail(message:String):Void {
        if (disposed) return;
        _end = flash.Lib.getTimer();
        _errorMsg = message;
        dispatchEvent(new LibraryLoaderEvent(LibraryLoaderEvent.LIBRARY_LOADER_EVENT_ERROR,
            _status, _bytesTotal, _bytesLoaded, elapsedTime));
        dispatchEvent(new Event(LIBRARY_LOADER_FINALIZE));
    }

    public function hasDefinition(key:String):Bool return _resource != null && Reflect.hasField(_resource, key);
    public function getDefinition(key:String):ASObject return cast (_resource == null ? null : Reflect.field(_resource, key));
    public function getLastDebugMessage():String return _debugMsg;
    public function getLastErrorMessage():String return _errorMsg;

    override public function dispose():Void {
        if (disposed) return;
        _context = null;
        _request = null;
        _manifest = null;
        _resource = null;
        super.dispose();
    }

    static function parseName(value:String):String {
        var clean = value.split("?")[0];
        clean = clean.substr(clean.lastIndexOf("/") + 1);
        var dot = clean.lastIndexOf(".");
        return dot < 0 ? clean : clean.substr(0, dot);
    }

    static function browserUrl(value:String):String {
        var parsed = new js.html.URL(value, Browser.location.href);
        if ((parsed.hostname == "localhost" || parsed.hostname == "127.0.0.1")
                && parsed.port == "") {
            parsed.protocol = Browser.location.protocol;
            parsed.host = Browser.location.host;
        }
        return parsed.href;
    }
}
