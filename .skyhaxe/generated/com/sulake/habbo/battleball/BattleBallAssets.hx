package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.utils.LibraryLoader;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.geom.Matrix;

     final class BattleBallAssets extends EventDispatcher
    {
        public static inline final READY= "BATTLEBALL_ASSETS_READY";
        public static inline final ERROR= "BATTLEBALL_ASSETS_ERROR";

        var _libraries:Array<ASAny> = [];
        var _loaders:Array<ASAny> = [];
        var _bitmapCache:ASObject = {};
        var _ownedBitmaps:Array<ASAny> = [];
        var _readyCount:Int = 0;
        var _failed:Bool = false;

        public var isReady(get,never):Bool;
public function  get_isReady():Bool { return this._readyCount == 3 && !this._failed; }

        public function load(baseUrl:String)
        {
            if (this._libraries.length > 0) return;
            if (baseUrl == null || baseUrl == "") { this.fail(); return; }
            if (baseUrl.charAt(baseUrl.length - 1) != "/") baseUrl += "/";
            this.loadLibrary("battleball_core", baseUrl + "hh_game_bb.swf");
            this.loadLibrary("battleball_room", baseUrl + "hh_game_bb_room.swf");
            this.loadLibrary("battleball_ui", baseUrl + "hh_game_bb_ui.swf");
        }

        public function display(name:String):DisplayObject
        {
var instance:ASObject  = null;            var content:ASObject = this.content(name);
            if (Std.is(content , BitmapData)) return new Bitmap(ASCompat.dynamicAs(content , BitmapData));
            if (Std.is(content , Class))
            {
instance= Type.createInstance(((content : Class<Dynamic>) ), []);
                if (Std.is(instance , BitmapData)) return new Bitmap(ASCompat.dynamicAs(instance , BitmapData));
                return ASCompat.dynamicAs(instance , DisplayObject);
            }
            return ASCompat.dynamicAs(content , DisplayObject);
        }

        /** Bitmap view of a converted Director member for native IBitmapWrapperWindow controls. */
        public function bitmapData(name:String):BitmapData
        {
var instance:ASObject  = null;            if (Std.is(ASCompat.getDynamicProperty(this._bitmapCache, name), BitmapData)) return ASCompat.dynamicAs(ASCompat.getDynamicProperty(this._bitmapCache, name), BitmapData);
            var content:ASObject = this.content(name);
            var data:BitmapData = null;
            if (Std.is(content , BitmapData))
                data = ASCompat.dynamicAs(content , BitmapData);
            else if (Std.is(content , Bitmap))
                data = cast(content, Bitmap).bitmapData;
            else if (Std.is(content , DisplayObject))
                data = this.rasterize(ASCompat.dynamicAs(content , DisplayObject));
            else if (Std.is(content , Class))
            {
instance= Type.createInstance(((content : Class<Dynamic>) ), []);
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

        public function play(name:String, loops:Int=0):SoundChannel
        {
            var value:ASObject = this.content(name);
            if (Std.is(value , Class)) value = Type.createInstance(((value : Class<Dynamic>) ), []);
            return Std.is(value , Sound) ? cast(value, Sound).play(0, loops) : null;
        }

        public function dispose()
        {
var bitmap:BitmapData  = null, library:AssetLibrary  = null, loader:LibraryLoader  = null;            final _iter_ = this._ownedBitmaps; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{bitmap = _tmp_;
                if (bitmap != null) bitmap.dispose();
};
            final _iter_ = this._libraries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {library = _tmp_;
library.dispose();
};
            final _iter_ = this._loaders; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {loader = _tmp_;
if (!loader.disposed) loader.dispose();
};
            this._libraries = []; this._loaders = []; this._ownedBitmaps = [];
            this._bitmapCache = {}; this._readyCount = 0;
        }

        function loadLibrary(name:String, url:String)
        {
            var library= new AssetLibrary(name);
            var loader= new LibraryLoader();
            library.addEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onLibraryReady);
            library.addEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onLibraryError);
            library.loadFromFile(loader, true);
            this._libraries.push(library); this._loaders.push(loader);
            loader.load(new URLRequest(url));
        }

        function content(name:String):ASObject
        {
var library:AssetLibrary  = null, asset:IAsset  = null;            if (!this.isReady) return null;
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
            this._readyCount++;
            if (this.isReady) dispatchEvent(new Event(READY));
        }

        function onLibraryError(event:Event) { this.fail(); }
        function fail() { if (!this._failed) { this._failed = true; dispatchEvent(new Event(ERROR)); } }

	public function new() { super(); }
    }

