package com.sulake.habbo.ui.widget.loadingbar
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import com.apdevblog.ui.video.ApdevVideoPlayer;
    import flash.utils.Timer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import flash.events.MouseEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetLoadingBarUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.events.SecurityErrorEvent;
    import com.apdevblog.ui.video._Str_2872;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.assets.AssetLoaderStruct;
    import org.openvideoads.vast.model.VideoAdServingTemplate;
    import com.apdevblog.ui.video.controls.VideoControlsEvent;
    import org.openvideoads.vast.model.TrackingEvent;
    import org.openvideoads.vast.model.VideoAdV2;
    import org.openvideoads.vast.model.MediaFile;
    import org.openvideoads.util.NetworkResource;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import com.sulake.habbo.utils.HabboWebTools;

     class LoadingBarWidget extends RoomWidgetBase
    {
        static inline final CLOSE= "close";
        static inline final COMPLETE= "complete";
        static inline final FIRSTQUARTILE= "firstQuartile";
        static inline final MIDPOINT= "midpoint";
        static inline final MUTE= "mute";
        static inline final PAUSE= "pause";
        static inline final RESUME= "resume";
        static inline final THIRDQUARTILE= "thirdQuartile";
        static inline final UNMUTE= "unmute";
        static inline final START= "start";

        var _window:IBorderWindow;
        var _config:IHabboConfigurationManager;
        var _image:BitmapData;
        var _clickUrl:String = "";
        var _adSprite:Sprite = null;
        var _videoPlayer:ApdevVideoPlayer;
        var _videoUrl:String = "";
        var _videoList:Array<ASAny>;
        var _videoMute:Bool = false;
        var _adTrackingEvents:ASDictionary<ASAny,ASAny>;
        var _interstitialVideoTimer:Timer;
        var _PreviousPosition:Float = Math.NaN;
        var _clickTrackingUrl:String;
        var _adPageOpened:Bool = false;
        var _videoState:String;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager)
        {
            this._videoList = [];
            super(k, _arg_2, _arg_3, _arg_4);
            this._config = _arg_5;
        }

        override public function dispose()
        {
            if (this._adSprite != null)
            {
                this._adSprite.removeEventListener(MouseEvent.CLICK, (this.clickHandler : ASAny));
                this._adSprite = null;
            }
            if (this._image != null)
            {
                this._image.dispose();
                this._image = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._config = null;
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR, this._Str_16768);
            k.addEventListener(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR, this._Str_18442);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR, this._Str_16768);
            k.removeEventListener(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR, this._Str_16768);
            k.removeEventListener(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR, this._Str_18442);
        }

        function _Str_25958(k:AssetLoaderEvent)
        {
            Logger.log([((("Error loading xml: " + this._videoUrl) + ", ") + k)]);
        }

        function onSecurityError(k:SecurityErrorEvent)
        {
        }

        function _Str_16768(k:RoomWidgetLoadingBarUpdateEvent)
        {
            if (((k == null) || (!(k.type == RoomWidgetLoadingBarUpdateEvent.RWLBUE_SHOW_LOADING_BAR))))
            {
                return;
            }
            if (!this.createWindow())
            {
                return;
            }
            this._window.visible = true;
            this._window.center();
        }

        function _Str_18442(k:RoomWidgetLoadingBarUpdateEvent)
        {
            if (((k == null) || (!(k.type == RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR))))
            {
                return;
            }
            if (((this._videoPlayer != null) && ((this._videoPlayer._Str_3404 == _Str_2872.VIDEOSTATEPLAYING) || (this._videoPlayer._Str_3404 == _Str_2872.VIDEOSTATEPAUSED))))
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function createWindow():Bool
        {
            var _local_4 = 0;
            if (this._window != null)
            {
                return true;
            }
            var k= Std.downcast(assets.getAssetByName("room_loading_bar") , XmlAsset);
            if (k == null)
            {
                return false;
            }
            this._window = Std.downcast(windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IBorderWindow);
            if (this._window == null)
            {
                return false;
            }
            this._window.visible = false;
            var _local_2= Std.downcast(this._window.findChildByName("region") , IRegionWindow);
            if (_local_2 != null)
            {
            }
            var _local_3= Std.downcast(this._window.findChildByName("image") , IDisplayObjectWrapper);
            if (_local_3 != null)
            {
                _local_4 = _local_3.height;
                this._window.scale(0, -_local_4);
            }
            return true;
        }

        function _Str_19456(k:AssetLoaderEvent)
        {
            var _local_2:AssetLoaderStruct = null;
            var _local_3:XmlAsset = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:VideoAdServingTemplate = null;
            _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            _local_2.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_19456);
            _local_2.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_19456);
            if (k.type == AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE)
            {
                _local_3 = Std.downcast(_assets.getAssetByName(_local_2.assetName) , XmlAsset);
                _local_4 = ((_local_3.content : com.sulake.core.utils.xml.XML) );
                if (_local_4 != null)
                {
                    _local_5 = new VideoAdServingTemplate();
                    _local_5._Str_15022(_local_4);
                    this._videoList = _local_5.ads;
                    this.playVideo();
                }
            }
        }

        function _Str_22287(k:Int=760, _arg_2:Int=480)
        {
            this._videoPlayer = new ApdevVideoPlayer(k, _arg_2);
            this._videoPlayer._Str_14540 = false;
            this._videoPlayer._Str_11762 = false;
            this._videoPlayer._Str_20925 = this._image;
            this._videoPlayer.autoPlay = false;
            this._videoPlayer._Str_17422.mute.visible = true;
            this._videoPlayer._Str_17422.fullscreen.visible = false;
            this._videoPlayer._Str_17422.bar._Str_18989 = false;
            this._videoPlayer.addEventListener(VideoControlsEvent.STATEUPDATE, (this._Str_25250 : ASAny), false, 0, true);
            this._Str_18970();
            this._videoPlayer.addEventListener(VideoControlsEvent.TOGGLESOUND, (this._Str_20632 : ASAny));
            this._videoPlayer.addEventListener(VideoControlsEvent.SETVOLUME, (this._Str_20632 : ASAny));
            this._videoPlayer.addEventListener(MouseEvent.CLICK, (this._Str_25072 : ASAny));
        }

        function _Str_23195(k:Array<ASAny>, _arg_2:String)
        {
            var _local_3:TrackingEvent = null;
            if (k != null)
            {
                this._adTrackingEvents = new ASDictionary<ASAny,ASAny>();
                this._adTrackingEvents[START] = _arg_2;
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    this._adTrackingEvents[_local_3.eventType] = _local_3;
                }
            }
        }

        function _Str_18970()
        {
            if (((this._videoPlayer == null) || (this._window == null)))
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("image") , IDisplayObjectWrapper);
            if (k == null)
            {
                return;
            }
            var _local_2= Std.int(Math.max(0, (this._videoPlayer.width - k.width)));
            var _local_3= Std.int(Math.max(0, (this._videoPlayer.height - k.height)));
            this._window.scale(_local_2, _local_3);
            k.setDisplayObject(this._videoPlayer);
            this._videoPlayer.autoPlay = true;
            this._window.visible = true;
            this._window.center();
        }

        function playVideo()
        {
            var _local_2:VideoAdV2 = null;
            var _local_5:MediaFile = null;
            var _local_6:String = null;
            var _local_7:NetworkResource = null;
            var k= this._videoList.length;
            if (k == 0)
            {
                return;
            }
            if (k > 0)
            {
                _local_2 = ASCompat.dynamicAs(this._videoList[0] , VideoAdV2);
            }
            var _local_3= "";
            var _local_4= _local_2.getImpressionList();
            if (_local_4.length > 0)
            {
                _local_3 = ASCompat.toString(_local_4[0]);
            }
            if (((_local_2 != null) && _local_2.hasAds(false)))
            {
                _local_5 = ASCompat.dynamicAs(_local_2.linearVideoAd.mediaFiles[0] , MediaFile);
                if (_local_5 == null)
                {
                    return;
                }
                _local_6 = _local_5.url.url;
                this._Str_23195(_local_2.trackingEvents, _local_3);
                if (_local_2.linearVideoAd.clickThroughs.length > 0)
                {
                    _local_7 = ASCompat.dynamicAs(_local_2.linearVideoAd.clickThroughs[0] , NetworkResource);
                    if (_local_7 != null)
                    {
                        this._clickTrackingUrl = _local_7.url;
                    }
                }
                this._Str_22287(ASCompat.toInt(_local_5.width), ASCompat.toInt(_local_5.height));
                this._videoPlayer.load(_local_6);
                this._videoPlayer.play();
                this._Str_5407(START);
                if (this._interstitialVideoTimer == null)
                {
                    this._interstitialVideoTimer = new Timer(500);
                    this._interstitialVideoTimer.addEventListener(TimerEvent.TIMER, (this._Str_25552 : ASAny));
                }
                if (this._interstitialVideoTimer.running)
                {
                    this._interstitialVideoTimer.reset();
                }
                this._interstitialVideoTimer.start();
            }
        }

        function _Str_5407(k:String)
        {
            var _local_2:TrackingEvent = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:URLLoader = null;
            _local_2 = ASCompat.dynamicAs(this._adTrackingEvents[k] , TrackingEvent);
            if (((!(_local_2 == null)) || (k == START)))
            {
                if (k == START)
                {
                    _local_3 = [this._adTrackingEvents[START]];
                }
                else
                {
                    _local_3 = _local_2.getURLList();
                }
                if (((_local_3 != null) && (_local_3.length > 0)))
                {
                    _local_4 = new URLLoader();
                    _local_4.addEventListener(Event.COMPLETE, (this._Str_25284 : ASAny));
                    _local_4.addEventListener(IOErrorEvent.IO_ERROR, (this._Str_24634 : ASAny));
                    _local_4.load(new URLRequest(_local_3[0]));
                }
            }
        }

        function _Str_25552(k:TimerEvent)
        {
            var _local_2 = Math.NaN;
            if (this._videoPlayer != null)
            {
                _local_2 = this._videoPlayer.getPosition();
                if (this._videoPlayer._Str_3404 == _Str_2872.VIDEOSTATEPLAYING)
                {
                    if (((this._PreviousPosition < 0.25) && (_local_2 >= 0.25)))
                    {
                        this._Str_5407(FIRSTQUARTILE);
                    }
                    else
                    {
                        if (((this._PreviousPosition < 0.5) && (_local_2 >= 0.5)))
                        {
                            this._Str_5407(MIDPOINT);
                        }
                        else
                        {
                            if (((this._PreviousPosition < 0.75) && (_local_2 >= 0.75)))
                            {
                                this._Str_5407(THIRDQUARTILE);
                            }
                        }
                    }
                }
                this._PreviousPosition = _local_2;
            }
        }

        function _Str_25250(k:VideoControlsEvent)
        {
            if (k.data == _Str_2872.VIDEOSTATESTOPPED)
            {
                this._interstitialVideoTimer.reset();
                this._Str_5407(COMPLETE);
                this._Str_5407(CLOSE);
                this._Str_18442(new RoomWidgetLoadingBarUpdateEvent(RoomWidgetLoadingBarUpdateEvent.RWLBUW_HIDE_LOADING_BAR));
            }
            else
            {
                if (((k.data == _Str_2872.VIDEOSTATEPLAYING) && (this._videoState == _Str_2872.VIDEOSTATEPAUSED)))
                {
                    this._Str_5407(RESUME);
                }
                else
                {
                    if (((k.data == _Str_2872.VIDEOSTATEPAUSED) && (!(this._videoState == _Str_2872.VIDEOSTATEPAUSED))))
                    {
                        this._Str_5407(PAUSE);
                    }
                }
            }
            this._videoState = k.data;
        }

        function clickHandler(k:Event)
        {
            if (this._clickUrl != "")
            {
                HabboWebTools.openWebPage(this._clickUrl);
            }
        }

        function _Str_25072(k:Event)
        {
            if ((((!(this._videoUrl == "")) && (!(this._clickTrackingUrl == ""))) && (!this._adPageOpened)))
            {
                HabboWebTools.openWebPage(this._clickTrackingUrl);
                this._adPageOpened = true;
            }
        }

        function _Str_24634(k:IOErrorEvent)
        {
        }

        function _Str_25284(k:Event)
        {
        }

        function _Str_24150()
        {
            this._Str_5407(MUTE);
        }

        function _Str_23440()
        {
            this._Str_5407(UNMUTE);
        }

        function _Str_20632(k:VideoControlsEvent)
        {
            if (this._videoPlayer.volume == 0)
            {
                this._videoMute = true;
                this._Str_24150();
            }
            else
            {
                if (this._videoMute)
                {
                    this._Str_23440();
                }
                this._videoMute = false;
            }
        }
    }

