package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.AssetLoaderStruct;
    import flash.utils.Timer;
    import com.sulake.core.assets.XmlAsset;
    import flash.net.URLRequest;
    import flash.events.TimerEvent;
    import com.sulake.habbo.avatar._enum.AvatarRenderEvent;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.events.Event;
    import com.sulake.habbo.avatar.structure.figure.ISetType;
    import com.sulake.habbo.avatar.structure.figure.IFigurePartSet;
    import com.sulake.habbo.avatar.structure.figure.FigurePart;

     class AvatarAssetDownloadManager extends EventDispatcherWrapper 
    {
        public static inline final LIBRARY_LOADED= "LIBRARY_LOADED";

        static inline final _Str_704= 100;
        static inline final _Str_589= 2;

        var _figureMap:ASDictionary<ASAny,ASAny>;
        var _assets:IAssetLibrary;
        var _incompleteFigures:ASDictionary<ASAny,ASAny>;
        var _listeners:ASDictionary<ASAny,ASAny>;
        var _structure:AvatarStructure;
        var _assetDownloadUrl:String;
        var _configurationURL:String;
        var _isInitReady:Bool = false;
        var _mapDownloadTriesLeft:Int = 3;
        var _mapLoader:AssetLoaderStruct;
        var _downloadShiftTimer:Timer;
        var _initDownloadBuffer:Array<ASAny>;
        var _pendingDownloadQueue:Array<ASAny>;
        var _currentDownloads:Array<ASAny>;
        var _assetLibraryNameTemplate:String;

        public function new(k:IAssetLibrary, _arg_2:String, _arg_3:String, _arg_4:AvatarStructure, _arg_5:String)
        {
            var _local_8:XmlAsset = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            super();
            this._figureMap = new ASDictionary<ASAny,ASAny>();
            this._assets = k;
            this._structure = _arg_4;
            this._incompleteFigures = new ASDictionary<ASAny,ASAny>();
            this._assetDownloadUrl = _arg_3;
            this._configurationURL = _arg_2;
            this._assetLibraryNameTemplate = _arg_5;
            this._listeners = new ASDictionary<ASAny,ASAny>();
            this._initDownloadBuffer = [];
            this._pendingDownloadQueue = [];
            this._currentDownloads = [];
            var _local_6= new URLRequest(_arg_2);
            var _local_7= this._assets.getAssetByName("figuremap");
            if (_local_7 == null)
            {
                this._mapLoader = this._assets.loadAssetFromFile("figuremap", _local_6, "text/xml");
                this._Str_725();
            }
            else
            {
                _local_8 = Std.downcast(this._assets.getAssetByName("figuremap") , XmlAsset);
                _local_9 = ((_local_8.content : com.sulake.core.utils.xml.XML) ).copy();
                this._Str_1556(_local_9);
            }
            this._downloadShiftTimer = new Timer(AvatarAssetDownloadManager._Str_704, 1);
            this._downloadShiftTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
            this._structure.avatarRenderManager.events.addEventListener(AvatarRenderEvent.AVATAR_RENDER_READY, this._Str_794);
        }

        override public function dispose()
        {
            super.dispose();
            this._figureMap = null;
            this._assets = null;
            this._incompleteFigures = null;
            this._listeners = null;
            if (this._structure.avatarRenderManager != null)
            {
                this._structure.avatarRenderManager.events.addEventListener(AvatarRenderEvent.AVATAR_RENDER_READY, this._Str_794);
            }
            this._structure = null;
            this._pendingDownloadQueue = null;
            this._initDownloadBuffer = null;
            if (this._downloadShiftTimer != null)
            {
                this._downloadShiftTimer.stop();
                this._downloadShiftTimer = null;
            }
            if (this._mapLoader != null)
            {
                this._Str_835();
                this._mapLoader = null;
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
                HabboWebTools.logEventLog(("Figuremap download error " + this._configurationURL));
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
                this._mapLoader = this._assets.loadAssetFromFile("figuremap", _local_3, "text/xml");
                this._Str_725();
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
 }            this._Str_1556(data);
        }

        function _Str_1556(k:com.sulake.core.utils.xml.XML)
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
            this._isInitReady = true;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        function _Str_794(k:Event)
        {
            var _local_2:Array<ASAny> = null;
            final _iter_ = this._initDownloadBuffer; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._Str_1320(_local_2[0], _local_2[1]);
            }
            this._initDownloadBuffer = [];
        }

        function _Str_709(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:AvatarAssetDownloadLibrary = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:String = null;
            var _local_6:Array<ASAny> = null;
            final _iter_ = k.child("lib"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_3 = new AvatarAssetDownloadLibrary(_local_2.attribute("id").toString(), _local_2.attribute("revision").toString(), this._assetDownloadUrl, this._assets, this._assetLibraryNameTemplate);
                _local_3.addEventListener(Event.COMPLETE, this._Str_807);
                final _iter_ = _local_2.child("part"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    _local_5 = ((ASCompat.xmlListToString(_local_4.attribute("type")) + ":") + ASCompat.xmlListToString(_local_4.attribute("id")));
                    _local_6 = this._figureMap[_local_5];
                    if (_local_6 == null)
                    {
                        _local_6 = [];
                    }
                    _local_6.push(_local_3);
                    this._figureMap[_local_5] = _local_6;
                }
            }
        }

        public function isReady(k:IAvatarFigureContainer):Bool
        {
            if (((!this._isInitReady) || (!this._structure.avatarRenderManager.isReady)))
            {
                return false;
            }
            var _local_2= this._Str_708(k);
            return _local_2.length == 0;
        }

        public function _Str_1320(k:IAvatarFigureContainer, _arg_2:IAvatarImageListener)
        {
            var _local_5:AvatarAssetDownloadLibrary = null;
            var _local_6:Array<ASAny> = null;
            if (((!this._isInitReady) || (!this._structure.avatarRenderManager.isReady)))
            {
                this._initDownloadBuffer.push(([k, _arg_2] : Array<Dynamic>));
                return;
            }
            var _local_3= k.getFigureString();
            var _local_4= this._Str_708(k);
            if (_local_4.length > 0)
            {
                if (((_arg_2 != null) && (!_arg_2.disposed)))
                {
                    _local_6 = this._listeners[_local_3];
                    if (_local_6 == null)
                    {
                        _local_6 = [];
                    }
                    _local_6.push(_arg_2);
                    this._listeners[_local_3] = _local_6;
                }
                this._incompleteFigures[_local_3] = _local_4;
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    this._Str_682(_local_5);
                }
            }
            else
            {
                if (((!(_arg_2 == null)) && (!_arg_2.disposed)))
                {
                    _arg_2.avatarImageReady(_local_3);
                }
            }
        }

        function _Str_807(k:Event)
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4:Array<ASAny> = null;
            var _local_5:AvatarAssetDownloadLibrary = null;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8:AvatarAssetDownloadLibrary = null;
            var _local_9:Array<ASAny> = null;
            var _local_10:IAvatarImageListener = null;
            if (disposed)
            {
                return;
            }
            var _local_2:Array<ASAny> = [];
            final _iter_ = this._incompleteFigures; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
                _local_7 = true;
                _local_4 = this._incompleteFigures[_local_3];
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_8  = _tmp_;
                    if (!_local_8.isReady)
                    {
                        _local_7 = false;
                        break;
                    }
                }
                if (_local_7)
                {
                    _local_2.push(_local_3);
                    _local_9 = this._listeners[_local_3];
                    if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                    {
_local_10  = _tmp_;
                        if (((!(_local_10 == null)) && (!_local_10.disposed)))
                        {
                            _local_10.avatarImageReady(_local_3);
                        }
                    }
                    this._listeners.remove(_local_3);
                    dispatchEvent(new Event(LIBRARY_LOADED));
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                this._incompleteFigures.remove(_local_3);
            }
            while (_local_6 < this._currentDownloads.length)
            {
                _local_5 = this._currentDownloads[_local_6];
                if (_local_5.libraryName == ASCompat.dynamicAs(k.target , AvatarAssetDownloadLibrary).libraryName)
                {
                    this._currentDownloads.splice(_local_6, 1);
                }
                _local_6++;
            }
            this._downloadShiftTimer.start();
        }

        function _Str_708(k:IAvatarFigureContainer):Array<ASAny>
        {
            var _local_5:String = null;
            var _local_6:ISetType = null;
            var _local_7 = 0;
            var _local_8:IFigurePartSet = null;
            var _local_9:FigurePart = null;
            var _local_10:String = null;
            var _local_11:Array<ASAny> = null;
            var _local_12:AvatarAssetDownloadLibrary = null;
            var _local_2:Array<ASAny> = [];
            if (this._structure == null)
            {
                return _local_2;
            }
            if (k == null)
            {
                return _local_2;
            }
            var _local_3= this._structure.figureData;
            if (_local_3 == null)
            {
                return _local_2;
            }
            var _local_4= k._Str_1016();
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                _local_6 = _local_3._Str_740(_local_5);
                if (_local_6 != null)
                {
                    _local_7 = k.getPartSetId(_local_5);
                    _local_8 = _local_6._Str_1020(_local_7);
                    if (_local_8 != null)
                    {
                        final _iter_ = _local_8.parts; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_9  = _tmp_;
                            _local_10 = ((_local_9.type + ":") + Std.string(_local_9.id));
                            _local_11 = this._figureMap[_local_10];
                            if (_local_11 != null)
                            {
                                if (checkNullIteratee(_local_11)) for (_tmp_ in _local_11)
                                {
_local_12  = _tmp_;
                                    if (_local_12 != null)
                                    {
                                        if (!_local_12.isReady)
                                        {
                                            if (_local_2.indexOf(_local_12) == -1)
                                            {
                                                _local_2.push(_local_12);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return _local_2;
        }

        function _Str_866()
        {
            var k:AvatarAssetDownloadLibrary = null;
            while (((this._pendingDownloadQueue.length > 0) && (this._currentDownloads.length < AvatarAssetDownloadManager._Str_589)))
            {
                k = this._pendingDownloadQueue[0];
                k.startDownloading();
                this._currentDownloads.push(this._pendingDownloadQueue.shift());
            }
        }

        function _Str_682(k:AvatarAssetDownloadLibrary)
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
    }




