package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.visualization.data.ExtraDataManager;
    import adobe.serialization.json.JSONDecoder;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     class FurnitureExternalImageVisualization extends ExternalIsometricImageFurniVisualization
    {
        var _batchesEnabled:Bool = false;
        var _baseUrl:String;
        var _extraDataUrl:String;
        var _url:String;
        var _extraDataLoading:Bool = false;
        var _typePrefix:String = "";
        var _externalImageUUID:String;

        public function new()        {
            super();
            hasOutline = true;
        }

        override public function setExternalBaseUrls(k:String, _arg_2:String, _arg_3:Bool)
        {
            this._baseUrl = k;
            this._extraDataUrl = _arg_2;
            this._batchesEnabled = _arg_3;
        }

        override function getThumbnailURL():String
        {
            var uuid:String = null;
            var url:String = null;
            if ((((!(object != null)) || (this._baseUrl == "disabled")) || (this._url == ExtraDataManager.REJECTED)))
            {
                return null;
            }
            if (ASCompat.stringAsBool(this._url))
            {
                return this._url;
            }
            var jsonString= object.getModel().getString("furniture_data");
            if (jsonString == null)
            {
                return null;
            }
            try
            {
                if (object.getType().indexOf("external_image_wallitem_poster") != -1)
                {
                    this._typePrefix = "";
                }
                else
                {
                    this._typePrefix = "postcards/selfie/";
                }
                uuid = this.getJsonValue(jsonString, "id", null);
                if ((ASCompat.stringAsBool(uuid) && (uuid.length > 0)))
                {
                    if (!this._extraDataLoading)
                    {
                        this._externalImageUUID = uuid;
                        this._extraDataLoading = true;
                        if (this._batchesEnabled)
                        {
                            ExtraDataManager.requestExtraDataUrl(this);
                        }
                        else
                        {
                            this.loadExtraData(uuid);
                        }
                    }
                    return null;
                }
                url = this.getJsonValue(jsonString, "w", "url");
                url = this.buildThumbnailUrl(url, this._typePrefix);
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                return null;
            }
 }            this._url = url;
            return url;
        }

        public function getExternalImageUUID():String
        {
            return this._externalImageUUID;
        }

        function buildThumbnailUrl(k:String, _arg_2:String):String
        {
            if (k == ExtraDataManager.REJECTED)
            {
                return k;
            }
            if (k.indexOf("http") != 0)
            {
                k = ((this._baseUrl + _arg_2) + k);
            }
            k = ASCompat.stringReplace(k, ".png", "_small.png");
            if (k.indexOf(".png") == -1)
            {
                k = (k + "_small.png");
            }
            return k;
        }

        function getJsonValue(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4:ASObject = new JSONDecoder(k, false).getValue();
            var _local_5:String = ASCompat.getDynamicProperty(_local_4, _arg_2);
            if (((_local_5 == null) && (!(_arg_3 == null))))
            {
                _local_5 = ASCompat.getDynamicProperty(_local_4, _arg_3);
            }
            return _local_5;
        }

        function loadExtraData(k:String)
        {
            var _local_2= (this._extraDataUrl + k);
            var _local_3= new URLLoader(new URLRequest(_local_2));
            _local_3.addEventListener(Event.COMPLETE, (this.onExtraDataLoaded : ASAny));
            _local_3.addEventListener(IOErrorEvent.IO_ERROR, (this.onExternalDataError : ASAny));
            this._extraDataLoading = true;
        }

        function onExternalDataError(k:Event)
        {
            Logger.log([("Extra data failed to load " + k.toString())]);
        }

        function onExtraDataLoaded(k:Event)
        {
            var _local_2:String = cast(k.target, URLLoader).data;
            if (_local_2.length == 0)
            {
                return;
            }
            var _local_3= this.getJsonValue(_local_2, "w", "url");
            this._url = this.buildThumbnailUrl(_local_3, this._typePrefix);
        }

        public function onUrlFromExtraDataService(k:String)
        {
            this._url = this.buildThumbnailUrl(k, this._typePrefix);
        }

        public function getExtraDataUrl():String
        {
            return this._extraDataUrl;
        }

        override public function dispose()
        {
            ExtraDataManager.furnitureDisposed(this);
            super.dispose();
        }

        override public function getImage(k:Int, _arg_2:Int):BitmapData
        {
            if (assetCollection == null)
            {
                return new BitmapData(1, 1, true, 0);
            }
            var _local_3= getFullThumbnailAssetName(_arg_2, 32);
            if (((assetCollection.getAsset(_local_3) == null) && (object != null)))
            {
                _local_3 = (object.getType() + "_icon_a");
            }
            if (assetCollection.getAsset(_local_3) == null)
            {
                return new BitmapData(1, 1, true, 0);
            }
            var _local_4:ASObject = assetCollection.getAsset(_local_3).asset.content;
            if (!_local_4)
            {
                return new BitmapData(1, 1, true, 0);
            }
            return ASCompat.dynamicAs(_local_4 , BitmapData).clone();
        }

        override function getLibraryAssetNameForSprite(k:IGraphicAsset, _arg_2:IRoomObjectSprite):String
        {
            return this._url;
        }
    }

