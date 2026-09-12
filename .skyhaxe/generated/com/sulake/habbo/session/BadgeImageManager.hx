package com.sulake.habbo.session
;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.assets.AssetLibrary;
    import flash.display.BitmapData;
    import flash.net.URLRequest;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.habbo.gamecenter.GameConfigurations;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.display.Bitmap;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import flash.geom.Matrix;

     class BadgeImageManager 
    {
        public static inline final GROUP_BADGE= "group_badge";
        public static inline final NORMAL_BADGE= "normal_badge";

        static inline final _Str_9663= "badge_";
        static inline final _Str_23071= "_32";

        var _assets:IAssetLibrary;
        var _events:IEventDispatcher;
        var _configuration:IHabboConfigurationManager;
        var _requestedGroupBadges:ASDictionary<ASAny,ASAny>;

        public function new(k:IAssetLibrary, _arg_2:IEventDispatcher, _arg_3:IHabboConfigurationManager)
        {
            this._requestedGroupBadges = new ASDictionary<ASAny,ASAny>();
            if (k == null)
            {
                k = new AssetLibrary("badge_images");
            }
            this._assets = k;
            this._events = _arg_2;
            this._configuration = _arg_3;
        }

        public function dispose()
        {
            this._assets = null;
        }

        public function getBadgeImage(k:String, _arg_2:String="normal_badge", _arg_3:Bool=true, _arg_4:Bool=false):BitmapData
        {
            var _local_5= this.getBadgeImageInternal(k, _arg_2, _arg_4);
            if (((!(_local_5 != null)) && _arg_3))
            {
                _local_5 = this.getPlaceholder();
            }
            return _local_5;
        }

        public function getSmallBadgeImage(k:String, _arg_2:String="normal_badge"):BitmapData
        {
            if (((this.getBadgeImageInternal(k, _arg_2, true) == null) && (!(this.getBadgeImageInternal(k) == null))))
            {
                this.createSmallBadgeBitmap((BadgeImageManager._Str_9663 + k), k);
            }
            return this.getBadgeImage(k, _arg_2, false, true);
        }

        public function getBadgeImageWithInfo(k:String):BadgeInfo
        {
            var _local_2= this.getBadgeImageInternal(k);
            return (_local_2 != null) ? new BadgeInfo(_local_2, false) : new BadgeInfo(this.getPlaceholder(), true);
        }

        public function getBadgeImageAssetName(k:String, _arg_2:String="normal_badge", _arg_3:Bool=false):String
        {
            var _local_4= ((BadgeImageManager._Str_9663 + k) + (_arg_3 ? "_32" : ""));
            if (this._assets.hasAsset(_local_4))
            {
                return _local_4;
            }
            this.getBadgeImageInternal(k, _arg_2, _arg_3);
            return null;
        }

        public function getSmallScaleBadgeAssetName(k:String, _arg_2:String="normal_badge"):String
        {
            var _local_3= this.getBadgeImageAssetName(k, _arg_2, true);
            if (_local_3 == null)
            {
                this.createSmallBadgeBitmap((BadgeImageManager._Str_9663 + k), k);
            }
            else
            {
                return _local_3;
            }
            return this.getBadgeImageAssetName(k, _arg_2, true);
        }

        function getBadgeImageInternal(k:String, _arg_2:String="normal_badge", _arg_3:Bool=false):BitmapData
        {
            var _local_5:URLRequest = null;
            var _local_6:String = null;
            var _local_7:BitmapDataAsset = null;
            var _local_8:AssetLoaderStruct = null;
            var _local_4= ((BadgeImageManager._Str_9663 + k) + (_arg_3 ? "_32" : ""));
            if (this._assets.hasAsset(_local_4))
            {
                _local_7 = Std.downcast(this._assets.getAssetByName(_local_4) , BitmapDataAsset);
                return ASCompat.dynamicAs(_local_7.content , BitmapData).clone();
            }
            if (_arg_3)
            {
                return null;
            }
            Logger.log([("Request badge: " + k)]);
            switch (_arg_2)
            {
                case NORMAL_BADGE:
                    if (this._configuration != null)
                    {
                        if (GameConfigurations.isGameBadge(k))
                        {
                            _local_6 = GameConfigurations.getBadgeImageUri(k);
                        }
                        else
                        {
                            _local_6 = this._configuration.getProperty("image.library.url");
                            _local_6 = (_local_6 + (("album1584/" + k) + ".gif"));
                        }
                        _local_5 = new URLRequest(_local_6);
                    }
                    
                case GROUP_BADGE:
                    if (((!(this._configuration == null)) && (!this._requestedGroupBadges[_local_4])))
                    {
                        _local_6 = this._configuration.getProperty("group.badge.url");
                        _local_6 = ASCompat.stringReplace(_local_6, "%imagerdata%", k);
                        _local_5 = new URLRequest(_local_6);
                        this._requestedGroupBadges[_local_4] = true;
                    }
                    
            }
            if (_local_5 != null)
            {
                _local_8 = this._assets.loadAssetFromFile(_local_4, _local_5, "image/gif");
                _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onBadgeImageReady);
            }
            return null;
        }

        function getPlaceholder():BitmapData
        {
            return cast(this._assets.getAssetByName("loading_icon").content, BitmapData).clone();
        }

        function onBadgeImageReady(k:AssetLoaderEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:Bitmap = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                if (((!(_local_2.assetLoader == null)) && (!(_local_2.assetLoader.content == null))))
                {
                    _local_3 = _local_2.assetName;
                    _local_4 = ASCompat.stringReplace(_local_3, BadgeImageManager._Str_9663, "");
                    _local_5 = ASCompat.dynamicAs(_local_2.assetLoader.content , Bitmap);
                    if (_local_5 == null)
                    {
                        return;
                    }
                    this._events.dispatchEvent(new BadgeImageReadyEvent(_local_4, _local_5.bitmapData.clone()));
                }
            }
        }

        function createSmallBadgeBitmap(k:String, _arg_2:String)
        {
            var _local_4:BitmapDataAsset = null;
            var _local_3= this.renderSmallScaleBadgeBitmap(k);
            if (_local_3 != null)
            {
                _local_4 = new BitmapDataAsset(this._assets.getAssetTypeDeclarationByClass(BitmapDataAsset));
                if (_local_4 != null)
                {
                    this._assets.setAsset(((BadgeImageManager._Str_9663 + _arg_2) + BadgeImageManager._Str_23071), _local_4);
                    _local_4.setUnknownContent(_local_3);
                }
            }
        }

        function renderSmallScaleBadgeBitmap(k:String):BitmapData
        {
            var _local_3:BitmapData = null;
            var _local_4:BitmapData = null;
            var _local_5:Matrix = null;
            var _local_2= this._assets.getAssetByName(k);
            if (_local_2 != null)
            {
                _local_3 = ASCompat.dynamicAs(_local_2.content , BitmapData);
                _local_4 = new BitmapData(Std.int(_local_3.width / 2), Std.int(_local_3.height / 2), true, 0);
                _local_5 = new Matrix(0.5, 0, 0, 0.5);
                _local_4.draw(_local_3, _local_5, null, null, null, true);
                return _local_4;
            }
            return null;
        }
    }

