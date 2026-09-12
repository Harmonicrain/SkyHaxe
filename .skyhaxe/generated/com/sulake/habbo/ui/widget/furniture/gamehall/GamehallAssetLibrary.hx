package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.utils.LibraryLoader;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;

     class GamehallAssetLibrary extends EventDispatcher
    {
        public static inline final READY= "GAMEHALL_ASSETS_READY";
        public static inline final ERROR= "GAMEHALL_ASSETS_ERROR";

        var _libraryLoader:LibraryLoader;
        var _assets:AssetLibrary;
        var _error:Bool = false;

        public var isReady(get,never):Bool;
public function  get_isReady():Bool
        {
            return this._assets != null && this._assets.isReady;
        }

        public var hasError(get,never):Bool;
public function  get_hasError():Bool
        {
            return this._error;
        }

        public function load(baseUrl:String)
        {
            if (this._assets != null)
            {
                return;
            }
            if (baseUrl == null || baseUrl == "")
            {
                this._error = true;
                dispatchEvent(new Event(ERROR));
                return;
            }
            if (baseUrl.charAt(baseUrl.length - 1) != "/")
            {
                baseUrl += "/";
            }
            this._libraryLoader = new LibraryLoader();
            this._assets = new AssetLibrary("gamehall_games");
            this._assets.addEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onReady);
            this._assets.addEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onError);
            this._assets.loadFromFile(this._libraryLoader, true);
            this._libraryLoader.load(new URLRequest(baseUrl + "hh_games.swf"));
        }

        public function assetDisplay(name:String):DisplayObject
        {
var instance:ASObject  = null;            if (!this.isReady)
            {
                return null;
            }
            var asset= this._assets.getAssetByName(name);
            if (asset == null)
            {
                return null;
            }
            var content:ASObject = asset.content;
            if (Std.is(content , BitmapData))
            {
                return new Bitmap(ASCompat.dynamicAs(content , BitmapData));
            }
            if (Std.is(content , Class))
            {
instance= Type.createInstance(((content : Class<Dynamic>) ), []);
                if (Std.is(instance , BitmapData))
                {
                    return new Bitmap(ASCompat.dynamicAs(instance , BitmapData));
                }
                return ASCompat.dynamicAs(instance , DisplayObject);
            }
            return ASCompat.dynamicAs(content , DisplayObject);
        }

        public function hasAsset(name:String):Bool
        {
            return this.isReady && this._assets.getAssetByName(name) != null;
        }

        public function dispose()
        {
            if (this._assets != null)
            {
                this._assets.removeEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onReady);
                this._assets.removeEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onError);
                this._assets.dispose();
                this._assets = null;
            }
            if (this._libraryLoader != null)
            {
                if (!this._libraryLoader.disposed)
                {
                    this._libraryLoader.dispose();
                }
                this._libraryLoader = null;
            }
        }

        function onReady(event:Event)
        {
            this._error = false;
            dispatchEvent(new Event(READY));
        }

        function onError(event:Event)
        {
            this._error = true;
            dispatchEvent(new Event(ERROR));
        }

	public function new() { super(); }
    }

