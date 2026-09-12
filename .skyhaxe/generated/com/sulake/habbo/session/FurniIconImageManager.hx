package com.sulake.habbo.session
;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.session.events.FurniIconImageReadyEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;

     class FurniIconImageManager
    {
        static inline final ASSET_PREFIX= "furni_icon_";
        static inline final LOADING_ICON_PLACEHOLDER= "loading_icon";

        var _assets:IAssetLibrary;
        var _events:IEventDispatcher;
        var _configuration:IHabboConfigurationManager;
        var _sessionDataManager:ISessionDataManager;
        var _loadingInfo:Map;
        var _ownsAssets:Bool = false;
        var _disposed:Bool = false;

        public function new(assets:IAssetLibrary, events:IEventDispatcher, configuration:IHabboConfigurationManager, sessionDataManager:ISessionDataManager)
        {
            if (assets == null)
            {
                assets = new AssetLibrary("furni_icon_images");
                this._ownsAssets = true;
            }
            this._loadingInfo = new Map();
            this._assets = assets;
            this._events = events;
            this._configuration = configuration;
            this._sessionDataManager = sessionDataManager;
        }

        public function dispose()
        {
var entry:Array<ASAny>  = null;            if (this._disposed)
            {
                return;
            }
            this._disposed = true;

            if (this._loadingInfo != null)
            {
                final _iter_ = this._loadingInfo.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
entry = _tmp_;
                    this.detachLoader(entry == null ? null : ASCompat.dynamicAs(entry[3] , AssetLoaderStruct), true);
                }
                this._loadingInfo.dispose();
                this._loadingInfo = null;
            }
            if (this._ownsAssets && this._assets != null)
            {
                this._assets.dispose();
            }
            this._assets = null;
            this._events = null;
            this._configuration = null;
            this._sessionDataManager = null;
        }

        function getData(wallItem:Bool, typeId:Int):IFurnitureData
        {
            if (this._sessionDataManager == null)
            {
                return null;
            }
            return wallItem ? this._sessionDataManager.getWallItemData(typeId) : this._sessionDataManager.getFloorItemData(typeId);
        }

        function getClassName(wallItem:Bool, typeId:Int, extra:String):String
        {
            var data= this.getData(wallItem, typeId);
            return data == null ? ASCompat.toString(wallItem) + "_" + Std.string(typeId) + "_" + extra : data.className + extra;
        }

        function getAssetName(wallItem:Bool, typeId:Int, extra:String):String
        {
            var assetName= ASSET_PREFIX + this.getClassName(wallItem, typeId, extra);
            var data= this.getData(wallItem, typeId);
            if (data != null && data.hasIndexedColor)
            {
                assetName += "_" + Std.string(data.colourIndex);
            }
            return assetName;
        }

        public function getFurniIconImage(wallItem:Bool, typeId:Int, extra:String, usePlaceholder:Bool=true):BitmapData
        {
            var image= this.getFurniIconImageInternal(wallItem, typeId, extra == null ? "" : extra);
            if (image == null && usePlaceholder)
            {
                image = this.getPlaceholder();
            }
            return image;
        }

        public function getFurniIconImageAssetName(wallItem:Bool, typeId:Int, extra:String):String
        {
            extra = extra == null ? "" : extra;
            var assetName= this.getAssetName(wallItem, typeId, extra);
            if (this._loadingInfo != null && this._loadingInfo.hasKey(assetName))
            {
                this.addLoadingRequest(assetName, wallItem, typeId, extra);
                return null;
            }
            if (this.getLoadedImage(assetName) != null)
            {
                return assetName;
            }
            this.removeInvalidAsset(assetName);
            return this.beginLoad(wallItem, typeId, extra, assetName) ? null : LOADING_ICON_PLACEHOLDER;
        }

        function getFurniIconImageInternal(wallItem:Bool, typeId:Int, extra:String):BitmapData
        {
            if (this._disposed || this._assets == null)
            {
                return null;
            }

            var assetName= this.getAssetName(wallItem, typeId, extra);
            if (this._loadingInfo != null && this._loadingInfo.hasKey(assetName))
            {
                return null;
            }
            var content= this.getLoadedImage(assetName);
            if (content != null)
            {
                return content.clone();
            }
            this.removeInvalidAsset(assetName);
            this.beginLoad(wallItem, typeId, extra, assetName);
            return null;
        }

        function getLoadedImage(assetName:String):BitmapData
        {
            if (this._assets == null || !this._assets.hasAsset(assetName))
            {
                return null;
            }
            var asset= Std.downcast(this._assets.getAssetByName(assetName) , BitmapDataAsset);
            return asset == null ? null : ASCompat.dynamicAs(asset.content , BitmapData);
        }

        function removeInvalidAsset(assetName:String)
        {
            if (this._assets == null || !this._assets.hasAsset(assetName) || this.getLoadedImage(assetName) != null)
            {
                return;
            }
            var asset= this._assets.getAssetByName(assetName);
            if (asset != null)
            {
                this._assets.removeAsset(asset);
                asset.dispose();
            }
        }

        function beginLoad(wallItem:Bool, typeId:Int, extra:String, assetName:String):Bool
        {
            if (this._disposed || this._assets == null || this._configuration == null)
            {
                return false;
            }
            if (this._loadingInfo.hasKey(assetName))
            {
                this.addLoadingRequest(assetName, wallItem, typeId, extra);
                return true;
            }

            var data= this.getData(wallItem, typeId);
            if (data == null)
            {
                return false;
            }

            var urlBase= this._configuration.getProperty("flash.dynamic.download.url");
            var urlTemplate= this._configuration.getProperty("flash.dynamic.icon.download.name.template");
            if (urlBase == null || urlTemplate == null || urlTemplate.length == 0)
            {
                return false;
            }

            var className= this.getClassName(wallItem, typeId, extra);
            var url= urlBase + urlTemplate;
            url = ASCompat.stringReplace(url, "%revision%", Std.string(data.revision));
            url = ASCompat.stringReplace(url, "%typeid%", className);
            url = ASCompat.stringReplace(url, "%param%", data.hasIndexedColor ? "_" + Std.string(data.colourIndex) : "");

            var loader:AssetLoaderStruct = null;
            try
            {
                loader = this._assets.loadAssetFromFile(assetName, new URLRequest(url), "image/png");
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                return false;
            }
 }            if (loader == null)
            {
                return false;
            }

            this._loadingInfo.add(assetName, ([wallItem, typeId, extra, loader, ([([wallItem, typeId, extra] : Array<Dynamic>)] : Array<Dynamic>)] : Array<Dynamic>));
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onFurniIconImageReady);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onFurniIconImageError);
            return true;
        }

        function addLoadingRequest(assetName:String, wallItem:Bool, typeId:Int, extra:String)
        {
var request:Array<ASAny>  = null;            if (this._loadingInfo == null)
            {
                return;
            }
            var entry:Array<ASAny> = ASCompat.dynamicAs(this._loadingInfo.getValue(assetName) , Array);
            if (entry == null)
            {
                return;
            }
            var requests:Array<ASAny> = ASCompat.dynamicAs(entry[4] , Array);
            if (requests == null)
            {
                requests = [([entry[0], entry[1], entry[2]] : Array<Dynamic>)];
                entry[4] = requests;
            }
            if (checkNullIteratee(requests)) for (_tmp_ in requests)
            {
request = _tmp_;
                if (ASCompat.toBool(request[0]) == wallItem && ASCompat.toInt(request[1]) == typeId && ASCompat.toString(request[2]) == extra)
                {
                    return;
                }
            }
            requests.push(([wallItem, typeId, extra] : Array<Dynamic>));
        }

        function onFurniIconImageReady(event:AssetLoaderEvent)
        {
var bitmap:Bitmap  = null;            var loader= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            var entry= this.takeLoadingEntry(loader);
            if (entry == null || this._disposed)
            {
                return;
            }

            var image:BitmapData = null;
            if (loader.assetLoader != null)
            {
bitmap= ASCompat.dynamicAs(loader.assetLoader.content , Bitmap);
                if (bitmap != null)
                {
                    image = bitmap.bitmapData;
                }
                else
                {
                    image = ASCompat.dynamicAs(loader.assetLoader.content , BitmapData);
                }
            }
            if (image == null)
            {
                this.removeInvalidAsset(loader.assetName);
                this.dispatchRequests(loader.assetName, entry, null, false);
                return;
            }
            this.dispatchRequests(loader.assetName, entry, image, true);
        }

        function onFurniIconImageError(event:AssetLoaderEvent)
        {
            var loader= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            var entry= this.takeLoadingEntry(loader);
            if (entry != null && !this._disposed)
            {
                this.removeInvalidAsset(loader.assetName);
                this.dispatchRequests(loader.assetName, entry, null, false);
            }
        }

        function takeLoadingEntry(loader:AssetLoaderStruct):Array<ASAny>
        {
            if (loader == null || this._loadingInfo == null)
            {
                return null;
            }
            var entry:Array<ASAny> = ASCompat.dynamicAs(this._loadingInfo.remove(loader.assetName) , Array);
            this.detachLoader(loader, false);
            return entry;
        }

        function detachLoader(loader:AssetLoaderStruct, disposeLoader:Bool)
        {
            if (loader == null)
            {
                return;
            }
            loader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onFurniIconImageReady);
            loader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onFurniIconImageError);
            if (disposeLoader)
            {
                loader.dispose();
            }
        }

        function dispatchRequests(assetName:String, entry:Array<ASAny>, image:BitmapData, success:Bool)
        {
var request:Array<ASAny>  = null;            var requests:Array<ASAny> = ASCompat.dynamicAs(entry[4] , Array);
            if (requests == null)
            {
                requests = [([entry[0], entry[1], entry[2]] : Array<Dynamic>)];
            }
            if (checkNullIteratee(requests)) for (_tmp_ in requests)
            {
request = _tmp_;
                this.dispatchResult(assetName, request, success && image != null ? image.clone() : null, success);
            }
        }

        function dispatchResult(assetName:String, request:Array<ASAny>, image:BitmapData, success:Bool)
        {
            try
            {
                if (this._events != null)
                {
                    this._events.dispatchEvent(new FurniIconImageReadyEvent(assetName, ASCompat.toBool(request[0]), ASCompat.toInt(request[1]), ASCompat.toString(request[2]), image, success));
                }
            }
            catch (_m2_finally_error:ASAny)
            {
                if (image != null)
                {
                    image.dispose();
                }

                throw _m2_finally_error;
            }
                if (image != null)
                {
                    image.dispose();
                }

        }

        function getPlaceholder():BitmapData
        {
            if (this._assets == null)
            {
                return null;
            }
            var asset= Std.downcast(this._assets.getAssetByName("loading_icon") , BitmapDataAsset);
            var image:BitmapData = asset == null ? null : ASCompat.dynamicAs(asset.content , BitmapData);
            return image == null ? null : image.clone();
        }
    }

