package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.utils.Timer;
    import com.sulake.core.assets.XmlAsset;
    import flash.net.URLRequest;
    import flash.events.TimerEvent;
    import com.sulake.habbo.avatar._enum.AvatarRenderEvent;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.Event;
    import com.sulake.habbo.utils.HabboWebTools;

     class EffectAssetDownloadManager extends EventDispatcherWrapper 
    {
        public static inline final LIBRARY_LOADED= "LIBRARY_LOADED";

        static inline final _Str_704= 100;
        static inline final _Str_589= 2;

        var _missingMandatoryLibs:Array<ASAny>;
        var _map:ASDictionary<ASAny,ASAny>;
        var _mapDownloadTriesLeft:Int = 3;
        var _mapLoader:AssetLoaderStruct;
        var _assets:IAssetLibrary;
        var _isInitReady:Bool = false;
        var _configurationURL:String;
        var _assetDownloadUrl:String;
        var _assetLibraryNameTemplate:String;
        var _structure:AvatarStructure;
        var _listeners:ASDictionary<ASAny,ASAny>;
        var _incompleteEffects:ASDictionary<ASAny,ASAny>;
        var _downloadShiftTimer:Timer;
        var _initDownloadBuffer:Array<ASAny>;
        var _pendingDownloadQueue:Array<ASAny>;
        var _currentDownloads:Array<ASAny>;

        public function new(k:IAssetLibrary, _arg_2:String, _arg_3:String, _arg_4:AvatarStructure, _arg_5:String)
        {
            var _local_8:XmlAsset = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            this._missingMandatoryLibs = ["dance.1", "dance.2", "dance.3", "dance.4"];
            super();
            this._map = new ASDictionary<ASAny,ASAny>();
            this._assets = k;
            this._structure = _arg_4;
            this._configurationURL = _arg_2;
            this._assetDownloadUrl = _arg_3;
            this._assetLibraryNameTemplate = _arg_5;
            this._listeners = new ASDictionary<ASAny,ASAny>();
            this._incompleteEffects = new ASDictionary<ASAny,ASAny>();
            this._initDownloadBuffer = [];
            this._pendingDownloadQueue = [];
            this._currentDownloads = [];
            var _local_6= new URLRequest(this._configurationURL);
            var _local_7= this._assets.getAssetByName("effectmap");
            if (_local_7 == null)
            {
                this._mapLoader = this._assets.loadAssetFromFile("effectmap", _local_6, "text/xml");
                this._Str_725();
            }
            else
            {
                _local_8 = Std.downcast(this._assets.getAssetByName("effectmap") , XmlAsset);
                _local_9 = ((_local_8.content : com.sulake.core.utils.xml.XML) ).copy();
                this._Str_2252(_local_9);
            }
            this._downloadShiftTimer = new Timer(EffectAssetDownloadManager._Str_704, 1);
            this._downloadShiftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
            this._structure.avatarRenderManager.events.addEventListener(AvatarRenderEvent.AVATAR_RENDER_READY, this._Str_794);
        }

        public function _Str_1651()
        {
            var _local_2:String = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:EffectAssetDownloadLibrary = null;
            var k= this._missingMandatoryLibs.slice(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = this._map[_local_2];
                if (_local_3 != null)
                {
                    if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                    {
_local_4  = _tmp_;
                        this._Str_682(_local_4);
                    }
                }
            }
        }

        function _Str_725()
        {
            if (this._mapLoader != null)
            {
                this._mapLoader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onConfigurationComplete);
                this._mapLoader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onConfigurationError);
            }
        }

        function _Str_835()
        {
            if (this._mapLoader != null)
            {
                this._mapLoader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onConfigurationComplete);
                this._mapLoader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onConfigurationError);
            }
        }

        function onConfigurationComplete(event:Event)
        {
            var data:com.sulake.core.utils.xml.XML = null;
            if (disposed)
            {
                return;
            }
            var loaderStruct= ASCompat.dynamicAs(event.target , AssetLoaderStruct);
            if (loaderStruct == null)
            {
                return;
            }
            try
            {
                data = new com.sulake.core.utils.xml.XML(ASCompat.asString(loaderStruct.assetLoader.content ));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                return;
            }
 }            this._Str_2252(data);
        }

        function onConfigurationError(k:Event)
        {
            var _local_2:String = null;
            var _local_3:URLRequest = null;
            if (disposed)
            {
                return;
            }
            this._mapDownloadTriesLeft--;
            if (this._mapDownloadTriesLeft <= 0)
            {
                HabboWebTools.logEventLog(("Effect download error " + this._configurationURL));
            }
            else
            {
                if (this._configurationURL.indexOf("?") > 0)
                {
                    _local_2 = ((this._configurationURL + "&retry=") + Std.string(this._mapDownloadTriesLeft));
                }
                else
                {
                    _local_2 = ((this._configurationURL + "?retry=") + Std.string(this._mapDownloadTriesLeft));
                }
                this._Str_835();
                _local_3 = new URLRequest(_local_2);
                this._mapLoader = this._assets.loadAssetFromFile("effectmap", _local_3, "text/xml");
                this._Str_725();
            }
        }

        function _Str_2252(k:com.sulake.core.utils.xml.XML)
        {
            if (k == null)
            {
                return;
            }
            if (k.toString() == "")
            {
                return;
            }
            this._Str_709(k);
            this._Str_1651();
            this._isInitReady = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        function _Str_709(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:EffectAssetDownloadLibrary = null;
            var _local_4:String = null;
            var _local_5:Array<ASAny> = null;
            final _iter_ = k.child("effect"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = new EffectAssetDownloadLibrary(_local_2.attribute("lib").toString(), "0", this._assetDownloadUrl, this._assets, this._assetLibraryNameTemplate);
                _local_3.addEventListener(Event.COMPLETE, this._Str_807);
                _local_4 = _local_2.attribute("id").toString();
                _local_5 = this._map[_local_4];
                if (_local_5 == null)
                {
                    _local_5 = [];
                }
                _local_5.push(_local_3);
                this._map[_local_4] = _local_5;
            }
        }

        function _Str_807(k:Event)
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4:Array<ASAny> = null;
            var _local_6:EffectAssetDownloadLibrary = null;
            var _local_7 = 0;
            var _local_8 = false;
            var _local_9:EffectAssetDownloadLibrary = null;
            var _local_10:Array<ASAny> = null;
            var _local_11:_Str_936 = null;
            if (disposed)
            {
                return;
            }
            Logger.log(["Effect download complete..."]);
            var _local_2:Array<ASAny> = [];
            var _local_5= ASCompat.dynamicAs(k.target , EffectAssetDownloadLibrary);
            this._structure.registerAnimation(_local_5.animation);
            final _iter_ = this._incompleteEffects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
                _local_8 = true;
                _local_4 = this._incompleteEffects[_local_3];
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_9  = _tmp_;
                    if (!_local_9.isReady)
                    {
                        _local_8 = false;
                        break;
                    }
                }
                if (_local_8)
                {
                    _local_2.push(_local_3);
                    _local_10 = this._listeners[_local_3];
                    if (checkNullIteratee(_local_10)) for (_tmp_ in _local_10)
                    {
_local_11  = _tmp_;
                        if (((!(_local_11 == null)) && (!_local_11.disposed)))
                        {
                            _local_11.updateAnimationByFrames(ASCompat.parseInt(_local_3));
                        }
                    }
                    this._listeners.remove(_local_3);
                    dispatchEvent(new Event(LIBRARY_LOADED));
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                this._incompleteEffects.remove(_local_3);
            }
            while (_local_7 < this._currentDownloads.length)
            {
                _local_6 = this._currentDownloads[_local_7];
                if (_local_6.name == _local_5.name)
                {
                    this._currentDownloads.splice(_local_7, 1);
                }
                _local_7++;
            }
            this._downloadShiftTimer.start();
        }

        public function isReady(k:Int):Bool
        {
            if (((!this._isInitReady) || (!this._structure.avatarRenderManager.isReady)))
            {
                return false;
            }
            var _local_2= this._Str_708(k);
            return _local_2.length == 0;
        }

        public function _Str_1914(k:Int, _arg_2:_Str_936)
        {
            var _local_4:EffectAssetDownloadLibrary = null;
            var _local_5:Array<ASAny> = null;
            if (((!this._isInitReady) || (!this._structure.avatarRenderManager.isReady)))
            {
                this._initDownloadBuffer.push(([k, _arg_2] : Array<Dynamic>));
                return;
            }
            var _local_3= this._Str_708(k);
            if (_local_3.length > 0)
            {
                if (((_arg_2 != null) && (!_arg_2.disposed)))
                {
                    _local_5 = this._listeners[Std.string(k)];
                    if (_local_5 == null)
                    {
                        _local_5 = [];
                    }
                    _local_5.push(_arg_2);
                    this._listeners[Std.string(k)] = _local_5;
                }
                this._incompleteEffects[Std.string(k)] = _local_3;
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_4  = _tmp_;
                    this._Str_682(_local_4);
                }
            }
            else
            {
                if (((!(_arg_2 == null)) && (!_arg_2.disposed)))
                {
                    _arg_2.updateAnimationByFrames(k);
                    Logger.log([("Effect ready to use: " + Std.string(k))]);
                }
            }
        }

        function _Str_708(k:Int):Array<ASAny>
        {
            var _local_4:EffectAssetDownloadLibrary = null;
            var _local_2:Array<ASAny> = [];
            if (this._structure == null)
            {
                return _local_2;
            }
            var _local_3:Array<ASAny> = this._map[Std.string(k)];
            if (_local_3 != null)
            {
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_4  = _tmp_;
                    if (_local_4 != null)
                    {
                        if (!_local_4.isReady)
                        {
                            if (_local_2.indexOf(_local_4) == -1)
                            {
                                _local_2.push(_local_4);
                            }
                        }
                    }
                }
            }
            return _local_2;
        }

        function _Str_866()
        {
            var k:EffectAssetDownloadLibrary = null;
            while (((this._pendingDownloadQueue.length > 0) && (this._currentDownloads.length < EffectAssetDownloadManager._Str_589)))
            {
                k = this._pendingDownloadQueue[0];
                k.startDownloading();
                this._currentDownloads.push(this._pendingDownloadQueue.shift());
            }
        }

        function _Str_682(k:EffectAssetDownloadLibrary)
        {
            if ((((!k.isReady) && (this._pendingDownloadQueue.indexOf(k) == -1)) && (this._currentDownloads.indexOf(k) == -1)))
            {
                this._pendingDownloadQueue.push(k);
                this._Str_866();
            }
        }

        function onTimerComplete(k:Event=null)
        {
            this._Str_866();
        }

        function _Str_794(k:Event)
        {
            var _local_2:Array<ASAny> = null;
            final _iter_ = this._initDownloadBuffer; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._Str_1914(ASCompat.toInt(_local_2[0]), _local_2[1]);
            }
            this._initDownloadBuffer = [];
        }

        public var _Str_1452(get,never):ASDictionary<ASAny,ASAny>;
public function  get__Str_1452():ASDictionary<ASAny,ASAny>
        {
            return this._map;
        }
    }


