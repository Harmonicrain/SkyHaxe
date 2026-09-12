package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.utils.LibraryLoader;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Matrix;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;

    /**
     * Owns the four independently converted r26 SnowStorm libraries.
     *
     * The three game casts provide the original sounds, UI, HUD, uniforms and arena members. The
     * fourth library is the RoomEngine-compatible world wrapper generated from the same room cast.
     * Keeping these libraries private prevents SnowStorm teardown from unloading hotel or avatar
     * assets that it does not own.
     */
     final class SnowStormAssets extends EventDispatcher
    {
        public static inline final READY= "SNOWSTORM_ASSETS_READY";
        public static inline final ERROR= "SNOWSTORM_ASSETS_ERROR";

        static final LIBRARY_FILES:Array<ASAny> = [
            {name:"snowstorm_core", file:"hh_game_snowwar.swf"},
            {name:"snowstorm_room", file:"hh_game_snowwar_room.swf"},
            {name:"snowstorm_ui", file:"hh_game_snowwar_ui.swf"},
            {name:"snowstorm_world", file:"hh_room_snowwar_arena.swf"}
        ];
        static inline final MAX_RETRIES= 1;
        static inline final RETRY_DELAY_MS= 1000;

        var _libraries:Array<ASAny> = [];
        var _loaders:Array<ASAny> = [];
        var _bitmapCache:ASObject = {};
        var _ownedBitmaps:Array<ASAny> = [];
        var _readyCount:Int = 0;
        var _baseUrl:String;
        var _retryCount:Int = 0;
        var _retryTimeout:UInt = 0;
        var _failed:Bool = false;
        var _disposed:Bool = false;

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._readyCount == LIBRARY_FILES.length && !this._failed && !this._disposed;
        }

        public function load(baseUrl:String)
        {
            if (this._disposed || this._libraries.length > 0 || this._retryTimeout != 0) return;
            if (baseUrl == null || baseUrl == "")
            {
                this.fail("asset base URL is empty");
                return;
            }
            if (baseUrl.charAt(baseUrl.length - 1) != "/") baseUrl += "/";
            this._baseUrl = baseUrl;
            this._failed = false;
            this.startLibraries();
        }

        public function display(name:String):DisplayObject
        {
var instance:ASObject  = null;            var value:ASObject = this.content(name);
            if (Std.is(value , BitmapData)) return new Bitmap(ASCompat.dynamicAs(value , BitmapData));
            if (Std.is(value , Class))
            {
instance= Type.createInstance(((value : Class<Dynamic>) ), []);
                if (Std.is(instance , BitmapData)) return new Bitmap(ASCompat.dynamicAs(instance , BitmapData));
                return ASCompat.dynamicAs(instance , DisplayObject);
            }
            return ASCompat.dynamicAs(value , DisplayObject);
        }

        /** Returns a shared, read-only bitmap owned by this asset façade. */
        public function bitmapData(name:String):BitmapData
        {
var instance:ASObject  = null;            if (Std.is(ASCompat.getDynamicProperty(this._bitmapCache, name), BitmapData)) return ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._bitmapCache, name), BitmapData);
            var value:ASObject = this.content(name);
            var data:BitmapData = null;
            if (Std.is(value , BitmapData))
                data = ASCompat.dynamicAs(value , BitmapData);
            else if (Std.is(value , Bitmap))
                data = cast(value, Bitmap).bitmapData;
            else if (Std.is(value , DisplayObject))
                data = this.rasterize(ASCompat.dynamicAs(value , DisplayObject));
            else if (Std.is(value , Class))
            {
instance= Type.createInstance(((value : Class<Dynamic>) ), []);
                if (Std.is(instance , BitmapData))
                {
                    data = ASCompat.dynamicAs(instance , BitmapData);
                    this._ownedBitmaps.push(data);
                }
                else if (Std.is(instance , Bitmap))
                {
                    data = cast(instance, Bitmap).bitmapData;
                    this._ownedBitmaps.push(data);
                }
                else if (Std.is(instance , DisplayObject))
                    data = this.rasterize(ASCompat.dynamicAs(instance , DisplayObject));
            }
            if (data != null) ASCompat.setDynamicProperty(this._bitmapCache, name, data);
            return data;
        }

        /** Creates a caller-owned copy suitable for tinting or composition. */
        public function cloneBitmapData(name:String):BitmapData
        {
            var source= this.bitmapData(name);
            return source == null ? null : source.clone();
        }

        public function play(name:String, loops:Int=0):SoundChannel
        {
            var value:ASObject = this.content(name);
            if (Std.is(value , Class)) value = Type.createInstance(((value : Class<Dynamic>) ), []);
            return Std.is(value , Sound) ? cast(value, Sound).play(0, loops) : null;
        }

        public function hasAsset(name:String):Bool
        {
            return this.content(name) != null;
        }

        public function dispose()
        {
var bitmap:BitmapData  = null;            if (this._disposed) return;
            this._disposed = true;
            if (this._retryTimeout != 0)
            {
                ASCompat.clearTimeout(this._retryTimeout);
                this._retryTimeout = 0;
            }
            final _iter_ = this._ownedBitmaps; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{bitmap = _tmp_;
                if (bitmap != null) bitmap.dispose();
};
            this.releaseLibraries();
            this._ownedBitmaps = [];
            this._bitmapCache = {};
            this._baseUrl = null;
        }

        function rasterize(display:DisplayObject):BitmapData
        {
            if (display == null) return null;
            var bounds= display.getBounds(display);
            var width= Std.int(Math.max(1, Math.fceil(bounds.width)));
            var height= Std.int(Math.max(1, Math.fceil(bounds.height)));
            var data= new BitmapData(width, height, true, 0);
            data.draw(display, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
            this._ownedBitmaps.push(data);
            return data;
        }

        function loadLibrary(name:String, url:String)
        {
            var library= new AssetLibrary(name);
            var loader= new LibraryLoader();
            library.addEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onLibraryReady);
            library.addEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onLibraryError);
            library.loadFromFile(loader, true);
            this._libraries.push(library);
            this._loaders.push(loader);
            loader.load(new URLRequest(url));
        }

        function startLibraries()
        {
var descriptor:ASObject  = null;            if (this._disposed || this._baseUrl == null || this._baseUrl == "") return;
            this._readyCount = 0;
            final _iter_ = LIBRARY_FILES; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{descriptor = _tmp_;
                this.loadLibrary(ASCompat.toString(descriptor.name), this._baseUrl + ASCompat.toString(descriptor.file));
};
        }

        function content(name:String):ASObject
        {
var library:AssetLibrary  = null, asset:IAsset  = null;            if (!this.isReady || name == null || name == "") return null;
            final _iter_ = this._libraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
asset= library.getAssetByName(name);
                if (asset != null) return asset.content;
            }
            return null;
        }

        function onLibraryReady(event:Event)
        {
            if (this._disposed || this._failed) return;
            this.detachLibrary(ASCompat.dynamicAs(event.currentTarget , AssetLibrary));
            this._readyCount++;
            if (this.isReady) dispatchEvent(new Event(READY));
        }

        function onLibraryError(event:Event)
        {
            if (this._disposed || this._failed) return;
            var library= ASCompat.dynamicAs(event.currentTarget , AssetLibrary);
            var identity= library == null ? "unknown library"
                : library.name + (library.url == null || library.url == "" ? "" : " at " + library.url);
            HabboWebTools.airDebug("[SnowStorm Assets] failed to load " + identity);
            this.releaseLibraries();
            if (this._retryCount < MAX_RETRIES)
            {
                this._retryCount++;
                this._retryTimeout = ASCompat.setTimeout(this.retryLibraries, RETRY_DELAY_MS);
                return;
            }
            this.fail("failed to load " + identity + " after " + Std.string(this._retryCount + 1) + " attempts");
        }

        function retryLibraries()
        {
            this._retryTimeout = 0;
            this.startLibraries();
        }

        function detachLibrary(library:AssetLibrary)
        {
            if (library == null) return;
            library.removeEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onLibraryReady);
            library.removeEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onLibraryError);
        }

        function releaseLibraries()
        {
var library:AssetLibrary  = null, loader:LibraryLoader  = null;            final _iter_ = this._libraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
library = _tmp_;
                this.detachLibrary(library);
                if (library != null && !library.disposed) library.dispose();
            }
            final _iter_ = this._loaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{loader = _tmp_;
                if (loader != null && !loader.disposed) loader.dispose();
};
            this._libraries = [];
            this._loaders = [];
            this._readyCount = 0;
        }

        function fail(reason:String)
        {
            if (this._disposed || this._failed) return;
            this._failed = true;
            HabboWebTools.airDebug("[SnowStorm Assets] " + reason);
            dispatchEvent(new Event(ERROR));
        }

	public function new() { super(); }
    }

