package com.sulake.habbo.advertisement
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import flash.display.BitmapData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboCatalog;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.habbo.communication.messages.incoming.advertisement.InterstitialMessageEvent;
    import flash.system.Security;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.communication.messages.outgoing.advertisement.GetInterstitialMessageComposer;
    import com.sulake.habbo.advertisement.events.InterstitialEvent;
    import flash.display.Bitmap;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.advertisement.events.AdEvent;

     class AdManager extends Component implements IAdManager 
    {
        static inline final INTERSTITIALCOMPLETED= "interstitialCompleted";

        var _communicationManager:IHabboCommunicationManager;
        var _sessionDataManager:ISessionDataManager;
        var _catalog:IHabboCatalog;
        var _roomAdWarningImageLeft:BitmapData = null;
        var _roomAdWarningImageRight:BitmapData = null;
        var _billboardImageLoaders:Map;
        var _interstitialMessageEvent:IMessageEvent;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), null), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, false), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, false)]));
        }

        override function initComponent()
        {
            var urlRequest:URLRequest = null;
            var asset:AssetLoaderStruct = null;
            this._billboardImageLoaders = new Map();
            this._interstitialMessageEvent = this._communicationManager.addHabboConnectionMessageEvent(new InterstitialMessageEvent(this._Str_24116));
            var k= getProperty("ads.domain");
            if (k != "")
            {
                Security.loadPolicyFile((("https://" + k) + "/crossdomain.xml"));
            }
            var adwarningLeftURL= getProperty("billboard.adwarning.left.url");
            var adwarningRightURL= getProperty("billboard.adwarning.right.url");
            var imageLibraryURL= getProperty("image.library.url");
            if (((!(adwarningLeftURL == "")) && (!(adwarningRightURL == ""))))
            {
                adwarningLeftURL = (imageLibraryURL + adwarningLeftURL);
                adwarningRightURL = (imageLibraryURL + adwarningRightURL);
                urlRequest = new URLRequest(adwarningLeftURL);
                asset = assets.loadAssetFromFile("adWarningL", urlRequest, "image/png");
                asset.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.interstitialLoaderEventHandler);
                urlRequest = new URLRequest(adwarningRightURL);
                asset = assets.loadAssetFromFile("adWarningRight", urlRequest, "image/png");
                asset.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.adWarningLeftReady);
            }
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback(INTERSTITIALCOMPLETED, this.disposeAsset);
            }
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._billboardImageLoaders != null)
            {
                this._billboardImageLoaders.dispose();
                this._billboardImageLoaders = null;
            }
            if (this._communicationManager != null)
            {
                this._communicationManager.removeHabboConnectionMessageEvent(this._interstitialMessageEvent);
                this._interstitialMessageEvent = null;
            }
            if (this._roomAdWarningImageLeft != null)
            {
                this._roomAdWarningImageLeft.dispose();
                this._roomAdWarningImageLeft = null;
            }
            if (this._roomAdWarningImageRight != null)
            {
                this._roomAdWarningImageRight.dispose();
                this._roomAdWarningImageRight = null;
            }
            super.dispose();
        }

        public function showInterstitial()
        {
            if (!getBoolean("interstitials.2016.enabled"))
            {
                this._Str_17549();
                return;
            }
            this._communicationManager.connection.send(new GetInterstitialMessageComposer());
        }

        function _Str_24116(k:InterstitialMessageEvent)
        {
            var _local_2= k.getParser();
            if (((_local_2 != null) && _local_2.canShowInterstitial))
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.showInterstitial");
                    events.dispatchEvent(new InterstitialEvent(InterstitialEvent.INTERSTITIAL_SHOW));
                }
                else
                {
                    this._Str_17549();
                }
            }
            else
            {
                this._Str_17549();
            }
        }

        function _Str_17549()
        {
            if (events != null)
            {
                events.dispatchEvent(new InterstitialEvent(InterstitialEvent.INTERSTITIAL_NOT_SHOWN));
            }
        }

        function disposeAsset(k:String)
        {
            events.dispatchEvent(new InterstitialEvent(InterstitialEvent.INTERSTITIAL_COMPLETE, k));
        }

        function interstitialLoaderEventHandler(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3= ASCompat.dynamicAs(_local_2.assetLoader.content , Bitmap);
            if (_local_3 != null)
            {
                this._roomAdWarningImageLeft = this.emulateBackgroundTransparency(_local_3.bitmapData);
            }
        }

        function adWarningLeftReady(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3= ASCompat.dynamicAs(_local_2.assetLoader.content , Bitmap);
            if (_local_3 != null)
            {
                this._roomAdWarningImageRight = this.emulateBackgroundTransparency(_local_3.bitmapData);
            }
        }

        function emulateBackgroundTransparency(k:BitmapData):BitmapData
        {
            var _local_4 = 0;
            var _local_5:UInt = 0;
            if (k == null)
            {
                return null;
            }
            var _local_2= new BitmapData(k.width, k.height, true, 0);
            var _local_3 = 0;
            while (_local_3 < _local_2.height)
            {
                _local_4 = 0;
                while (_local_4 < _local_2.width)
                {
                    _local_5 = k.getPixel32(_local_4, _local_3);
                    if (_local_5 != 0xFFFFFFFF)
                    {
                        _local_2.setPixel32(_local_4, _local_3, _local_5);
                    }
                    _local_4++;
                }
                _local_3++;
            }
            return _local_2;
        }

        function isValidAdImage(k:Bitmap):Bool
        {
            if ((((!(k == null)) && (!(k.bitmapData == null))) && ((k.width > 1) || (k.height > 1))))
            {
                return true;
            }
            return false;
        }

        public function loadRoomAdImage(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:String)
        {
            var _local_9:IAsset = null;
            var _local_10:BitmapData = null;
            var _local_11:AdImageRequest = null;
            if (((_arg_4 == null) || (_arg_4.length == 0)))
            {
                return;
            }
            if (assets.hasAsset(_arg_4))
            {
                _local_9 = assets.getAssetByName(_arg_4);
                if (_local_9 != null)
                {
                    _local_10 = ASCompat.dynamicAs(_local_9.content , BitmapData);
                    if (_local_10 != null)
                    {
                        this.dispatchImageAsset(_local_10.clone(), k, _arg_2, _arg_3, _arg_4, _arg_5);
                    }
                }
                return;
            }
            var _local_6:Array<ASAny> = this._billboardImageLoaders.getValue(_arg_4);
            if (_local_6 == null)
            {
                _local_6 = [];
                this._billboardImageLoaders.add(_arg_4, _local_6);
            }
            if (_local_6.length > 0)
            {
                if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
                {
_local_11  = _tmp_;
                    if ((((_local_11.roomId == k) && (_local_11.objectId == _arg_2)) && (_local_11.objectCategory == _arg_3)))
                    {
                        return;
                    }
                }
            }
            _local_6.push(new AdImageRequest(k, _arg_4, _arg_5, _arg_2, _arg_3));
            var _local_7= new URLRequest(_arg_4);
            var _local_8= assets.loadAssetFromFile(_arg_4, _local_7, "image/png");
            _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.adWarningRightReady);
            _local_8.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onBillboardImageReady);
        }

        function adWarningRightReady(k:AssetLoaderEvent)
        {
            var _local_5:BitmapData = null;
            var _local_6:AdImageRequest = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3= ASCompat.dynamicAs(_local_2.assetLoader.content , Bitmap);
            var _local_4:Array<ASAny> = this._billboardImageLoaders.remove(_local_2.assetName);
            if (((_local_4 == null) || (_local_4.length == 0)))
            {
                return;
            }
            if (this.isValidAdImage(_local_3))
            {
                _local_5 = _local_3.bitmapData;
                if (_local_5 != null)
                {
                    if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                    {
_local_6  = _tmp_;
                        this.dispatchImageAsset(_local_5.clone(), _local_6.roomId, _local_6.objectId, _local_6.objectCategory, _local_6.imageURL, _local_6.clickURL);
                    }
                }
            }
        }

        function dispatchImageAsset(k:BitmapData, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:String)
        {
            if (events != null)
            {
                events.dispatchEvent(new AdEvent(AdEvent.ROOM_AD_IMAGE_LOADED, _arg_2, k, _arg_5, _arg_6, null, null, _arg_3, _arg_4));
            }
        }

        function onBillboardImageReady(k:AssetLoaderEvent)
        {
            var _local_4:AdImageRequest = null;
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            var _local_3:Array<ASAny> = this._billboardImageLoaders.remove(_local_2.assetName);
            if (((_local_3 == null) || (_local_3.length == 0)))
            {
                return;
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_4  = _tmp_;
                this.dispatchImageAsset(null, _local_4.roomId, _local_4.objectId, _local_4.objectCategory, _local_4.imageURL, _local_4.clickURL);
            }
        }
    }

