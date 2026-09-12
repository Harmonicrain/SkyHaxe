package com.sulake.habbo.window
;
    import com.sulake.core.assets.IResourceManager;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.IAsset;
    import flash.display.BitmapData;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.assets.IAssetReceiver;

     class ResourceManager implements IResourceManager 
    {
        var _disposed:Bool = false;
        var _windowManager:HabboWindowManagerComponent;
        var _assetReceivers:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboWindowManagerComponent)
        {
            this._assetReceivers = new ASDictionary<ASAny,ASAny>();
            this._windowManager = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._windowManager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function retrieveAsset(k:String, _arg_2:IAssetReceiver)
        {
            var _local_5:AssetLoaderStruct = null;
            if (((k == null) || (k.length == 0)))
            {
                return;
            }
            var _local_3= this._Str_16848(k);
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= this._windowManager.assets.getAssetByName(_local_3);
            if (_local_4 == null)
            {
                if (((_local_3.substr(0, 7) == "http://") || (_local_3.substr(0, 8) == "https://")))
                {
                    try
                    {
                        _local_5 = this._windowManager.assets.loadAssetFromFile(_local_3, new URLRequest(_local_3));
                    }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                     {
                        this.receiveMissingImageFallback(_arg_2, _local_3);
                        return;
                    }
 }                    if (((!(_local_5 == null)) && (!_local_5.disposed)))
                    {
                        if (this._assetReceivers[_local_3] == null)
                        {
                            this._assetReceivers[_local_3] = ([] : Array<Dynamic>);
                        }
                        if (_arg_2 != null)
                        {
                            this._assetReceivers[_local_3].push(_arg_2);
                        }
                        _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_23200);
                        _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_23201);
                    }
                    else
                    {
                        this.receiveMissingImageFallback(_arg_2, _local_3);
                    }
                }
            }
            else
            {
                if (_arg_2 != null)
                {
                    _arg_2.receiveAsset(_local_4, _local_3);
                }
            }
        }

        function _Str_23200(k:AssetLoaderEvent=null)
        {
            var _local_4:IAssetReceiver = null;
            if (this._disposed)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (((_local_2 == null) || (this._assetReceivers[_local_2.assetName] == null)))
            {
                return;
            }
            var _local_3= this._windowManager.assets.getAssetByName(_local_2.assetName);
            if (_local_3 == null)
            {
                return;
            }
            final _iter_:ASAny = this._assetReceivers[_local_2.assetName]; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (((!(_local_4 == null)) && (!_local_4.disposed)))
                {
                    _local_4.receiveAsset(_local_3, _local_3.url);
                }
            }
            this._assetReceivers.remove(_local_2.assetName);
        }

        function _Str_23201(k:AssetLoaderEvent=null)
        {
            var _local_2:AssetLoaderStruct = ((k == null) ? null : ASCompat.dynamicAs(k.target , AssetLoaderStruct));
            if (_local_2 != null)
            {
                this.receiveMissingImageFallbackForAsset(_local_2.assetName);
                this._assetReceivers.remove(_local_2.assetName);
            }
        }

        public function isSameAsset(k:String, _arg_2:String):Bool
        {
            return _arg_2 == this._Str_16848(k);
        }

        function _Str_16848(k:String):String
        {
            return this._windowManager.interpolate(k);
        }

        function receiveMissingImageFallbackForAsset(assetName:String)
        {
            var receiver:IAssetReceiver = null;
            var receivers:Array<ASAny> = ASCompat.dynamicAs(this._assetReceivers[assetName] , Array);
            if (receivers == null)
            {
                return;
            }
            if (checkNullIteratee(receivers)) for (_tmp_ in receivers)
            {
receiver  = _tmp_;
                this.receiveMissingImageFallback(receiver, assetName);
            }
        }

        function receiveMissingImageFallback(receiver:IAssetReceiver, resolved:String):Bool
        {
            var fallback:BitmapDataAsset = null;
            var bitmap:BitmapData = null;
            var fallbackAsset:BitmapDataAsset = null;
            if (((receiver == null) || receiver.disposed) || (this._windowManager == null))
            {
                return false;
            }
            fallback = Std.downcast(this._windowManager.assets.getAssetByName("missing_image_icon") , BitmapDataAsset);
            if (fallback == null)
            {
                return false;
            }
            try
            {
                bitmap = ASCompat.dynamicAs(fallback.content , BitmapData);
                if (bitmap == null)
                {
                    return false;
                }
                fallbackAsset = new BitmapDataAsset(null, resolved);
                fallbackAsset.setUnknownContent(bitmap.clone());
                receiver.receiveAsset(fallbackAsset, resolved);
                return true;
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
            }
 }            return false;
        }

        public function createAsset(k:String, _arg_2:Class<Dynamic>, _arg_3:ASObject):IAsset
        {
            var _local_4:IAsset = Type.createInstance(_arg_2, [this._windowManager.assets.getAssetTypeDeclarationByClass(_arg_2)]);
            this._windowManager.assets.setAsset(k, _local_4);
            _local_4.setUnknownContent(_arg_3);
            return _local_4;
        }

        public function removeAsset(k:String)
        {
            var _local_2= this._Str_16848(k);
            this._windowManager.assets.removeAsset(this._windowManager.assets.getAssetByName(_local_2));
        }
    }


