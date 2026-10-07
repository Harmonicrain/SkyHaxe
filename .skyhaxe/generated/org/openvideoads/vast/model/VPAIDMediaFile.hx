package org.openvideoads.vast.model
;
    import org.openvideoads.regions.view._Str_4027;
    import org.openvideoads.vast.overlay.VPAIDWrapper;
    import flash.utils.Timer;
    import org.openvideoads.vast.overlay.OverlayView;
    import org.openvideoads.vpaid._Str_5844;
    import org.openvideoads.vpaid._Str_2291;
    import org.openvideoads.util.BrowserUtils;
    import flash.events.TimerEvent;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.UserAgentUtils;

     class VPAIDMediaFile extends MediaFile implements _Str_5226 implements  _Str_4027 
    {
        var _Str_2339:VPAIDWrapper = null;
        var _Str_7754:ASFunction;
        var _Str_7072:ASFunction;
        var _Str_7045:ASFunction;
        var _Str_7602:ASFunction;
        var _Str_7990:ASFunction;
        var _Str_8113:ASFunction;
        var _Str_7608:ASFunction;
        var _Str_7129:ASFunction;
        var _Str_7909:ASFunction;
        var _Str_7622:ASFunction;
        var _Str_7604:ASFunction;
        var _Str_7855:ASFunction;
        var _Str_7158:ASFunction;
        var _Str_7650:ASFunction;
        var _Str_7403:ASFunction;
        var _Str_7714:ASFunction;
        var _Str_7275:ASFunction;
        var _Str_8111:ASFunction;
        var _Str_7026:ASFunction;
        var _Str_7354:ASFunction;
        var _Str_8096:ASFunction;
        var _Str_7259:ASFunction;
        var _Str_7958:ASFunction;
        var _Str_7927:ASFunction;
        var _Str_8201:ASFunction;
        var _Str_7299:ASFunction;
        var _Str_7764:ASFunction = null;
        var _Str_2850:Timer = null;
        var _Str_12307:Int = 65;
        var _Str_9374:Bool = false;
        var _Str_4442:OverlayView = null;
        var _running:Bool = false;
        var _Str_9771:Bool = false;
        var _Str_7538:Bool = false;
        var _Str_18032:Bool = false;


        public function signalLoadError(k:String)
        {
            this._Str_4213(k);
        }

        public var recommendedWidth(get,never):Int;
public function  get_recommendedWidth():Int
        {
            if (_width != null)
            {
                return ASCompat.parseInt(_width);
            }
            return -1;
        }

        public var recommendedHeight(get,never):Int;
public function  get_recommendedHeight():Int
        {
            if (_height != null)
            {
                return ASCompat.parseInt(_height);
            }
            return -1;
        }

        
        public var enforceRecommendedSizing(get,set):Bool;
public function  set_enforceRecommendedSizing(k:Bool):Bool        {
            return this._Str_9771 = k;
        }
public function  get_enforceRecommendedSizing():Bool
        {
            return this._Str_9771;
        }

        public function _Str_3654()
        {
            this._Str_18032 = false;
        }

        public function _Str_3144()
        {
            this._Str_18032 = true;
        }

        public var loaded(get,never):Bool;
public function  get_loaded():Bool
        {
            return this._Str_18032;
        }

        public function _Str_10362(k:OverlayView)
        {
            this._Str_4442 = k;
        }

        public function _Str_4668():OverlayView
        {
            return this._Str_4442;
        }

        public function _Str_7544():Bool
        {
            return !(this._Str_4442 == null);
        }

        public function _Str_13233()
        {
            if (this._Str_7544())
            {
                this._Str_4442.hide();
                this._Str_4442 = null;
            }
        }

        override public function unload()
        {
            if (this.isRunning())
            {
                this._Str_7538 = true;
                this._Str_2339.stopAd();
            }
            this.removeListeners();
            if (this._Str_7544())
            {
                this._Str_4442._Str_13579();
                this._Str_13233();
            }
            this._Str_2339 = null;
        }

        public function getVPAID():_Str_5844
        {
            if (this._Str_2339 != null)
            {
                return this._Str_2339;
            }
            return null;
        }

        public function isRunning():Bool
        {
            return (!(this._Str_2339 == null)) && this._running;
        }

        public function _Str_25919():Bool
        {
            if (this.isRunning())
            {
                return (this._Str_2339.adLinear == false) && (this._Str_2339.adExpanded == false);
            }
            return false;
        }

        public function _Str_18023(k:ASFunction)
        {
            this._Str_7602 = k;
        }

        public function _Str_16112(k:ASFunction)
        {
            this._Str_7072 = k;
        }

        public function _Str_17667(k:ASFunction)
        {
            this._Str_7045 = k;
        }

        public function _Str_18005(k:ASFunction)
        {
            this._Str_7754 = k;
        }

        public function _Str_18994(k:ASFunction)
        {
            this._Str_8113 = k;
        }

        public function _Str_16180(k:ASFunction)
        {
            this._Str_7990 = k;
        }

        public function _Str_16053(k:ASFunction)
        {
            this._Str_7129 = k;
        }

        public function _Str_16310(k:ASFunction)
        {
            this._Str_7608 = k;
        }

        public function _Str_17326(k:ASFunction)
        {
            this._Str_7909 = k;
        }

        public function _Str_17214(k:ASFunction)
        {
            this._Str_7622 = k;
        }

        public function _Str_18109(k:ASFunction)
        {
            this._Str_7604 = k;
        }

        public function _Str_17380(k:ASFunction)
        {
            this._Str_7855 = k;
        }

        public function _Str_18263(k:ASFunction)
        {
            this._Str_7158 = k;
        }

        public function _Str_16234(k:ASFunction)
        {
            this._Str_7650 = k;
        }

        public function _Str_17367(k:ASFunction)
        {
            this._Str_7403 = k;
        }

        public function _Str_16574(k:ASFunction)
        {
            this._Str_7714 = k;
        }

        public function _Str_15911(k:ASFunction)
        {
            this._Str_7275 = k;
        }

        public function _Str_17407(k:ASFunction)
        {
            this._Str_8111 = k;
        }

        public function _Str_16669(k:ASFunction)
        {
            this._Str_7026 = k;
        }

        public function _Str_22363(k:ASFunction)
        {
            this._Str_7354 = k;
        }

        public function _Str_24124(k:ASFunction)
        {
            this._Str_8096 = k;
        }

        public function _Str_17018(k:ASFunction)
        {
            this._Str_7259 = k;
        }

        public function _Str_18631(k:ASFunction)
        {
            this._Str_7927 = k;
        }

        public function _Str_18205(k:ASFunction)
        {
            this._Str_7958 = k;
        }

        public function _Str_17427(k:ASFunction)
        {
            this._Str_8201 = k;
        }

        public function _Str_18144(k:ASFunction)
        {
            this._Str_7299 = k;
        }

        public function _Str_18688(k:ASFunction)
        {
            this._Str_7764 = k;
        }

        public function _Str_17184(k:Int)
        {
            this._Str_12307 = k;
        }

        public function enableMaxDurationTimeout()
        {
            this._Str_9374 = true;
        }

        public function _Str_18747()
        {
            this._Str_9374 = false;
        }

        function _Str_2763(k:String, _arg_2:ASObject=null)
        {
            if (this._Str_7764 != null)
            {
                this._Str_7764(new _Str_2291(k, _arg_2));
            }
        }

        function _Str_16122()
        {
            this._running = true;
            if (this._Str_7602 != null)
            {
                this._Str_7602(new _Str_2291(_Str_2291.AdStarted));
            }
        }

        function _Str_4213(k:String)
        {
            this._running = false;
            if (this._Str_7072 != null)
            {
                this._Str_7072(new _Str_2291(_Str_2291.AdError, k));
            }
        }

        function _Str_7676(k:ASAny=null)
        {
            if (this._Str_7045 != null)
            {
                this._Str_7045(new _Str_2291(_Str_2291.AdLog, k));
            }
        }

        function _Str_18050(k:String)
        {
            this._running = false;
            if (this._Str_7754 != null)
            {
                this._Str_7754(new _Str_2291(k, {"terminated":this._Str_7538}));
            }
        }

        function _Str_19655()
        {
            if (this._Str_7909 != null)
            {
                this._Str_7909(new _Str_2291(_Str_2291.AdLoaded));
            }
        }

        function _Str_17620()
        {
            if (this._Str_7622 != null)
            {
                this._Str_7622(new _Str_2291(_Str_2291.AdImpression));
            }
        }

        function _Str_18457()
        {
            if (this._Str_7604 != null)
            {
                this._Str_7604(new _Str_2291(_Str_2291.AdClickThru));
            }
        }

        function _Str_16595()
        {
            if (this._Str_7855 != null)
            {
                this._Str_7855(new _Str_2291(_Str_2291.AdUserAcceptInvitation));
            }
        }

        function _Str_16009()
        {
            if (this._Str_7608 != null)
            {
                this._Str_7608(new _Str_2291(_Str_2291.AdVolumeChange, ((this._Str_2339 != null) ? this._Str_2339.adVolume : null)));
            }
        }

        function _Str_17450()
        {
            if (this._Str_7158 != null)
            {
                this._Str_7158(new _Str_2291(_Str_2291.AdUserMinimize));
            }
        }

        function _Str_15930()
        {
            if (this._Str_7650 != null)
            {
                this._Str_7650(new _Str_2291(_Str_2291.AdUserClose));
            }
        }

        function _Str_17749()
        {
            if (this._Str_7403 != null)
            {
                this._Str_7403(new _Str_2291(_Str_2291.AdVideoStart));
            }
        }

        function _Str_17930()
        {
            if (this._Str_7714 != null)
            {
                this._Str_7714(new _Str_2291(_Str_2291.AdVideoFirstQuartile));
            }
        }

        function _Str_17794()
        {
            if (this._Str_7275 != null)
            {
                this._Str_7275(new _Str_2291(_Str_2291.AdVideoMidpoint));
            }
        }

        function _Str_17525()
        {
            if (this._Str_8111 != null)
            {
                this._Str_8111(new _Str_2291(_Str_2291.AdVideoThirdQuartile));
            }
        }

        function _Str_17016()
        {
            if (this._Str_7026 != null)
            {
                this._Str_7026(new _Str_2291(_Str_2291.AdVideoComplete));
            }
        }

        function _Str_17824()
        {
            if (this._Str_7354 != null)
            {
                this._Str_7354(new _Str_2291(_Str_2291.AdPaused));
            }
        }

        function _Str_17645()
        {
            if (this._Str_8096 != null)
            {
                this._Str_8096(new _Str_2291(_Str_2291.AdPlaying));
            }
        }

        function _Str_24742()
        {
            if (this._Str_7259 != null)
            {
                this._Str_7259(new _Str_2291(_Str_2291.AdSkipped));
            }
        }

        function _Str_25653()
        {
            if (this._Str_7958 != null)
            {
                this._Str_7958(new _Str_2291(_Str_2291.AdSizeChange));
            }
        }

        function _Str_22852()
        {
            if (this._Str_7927 != null)
            {
                this._Str_7927(new _Str_2291(_Str_2291.AdSkippableStateChange));
            }
        }

        function _Str_22369()
        {
            if (this._Str_8201 != null)
            {
                this._Str_8201(new _Str_2291(_Str_2291.AdDurationChange));
            }
        }

        function _Str_22458()
        {
            if (this._Str_7299 != null)
            {
                this._Str_7299(new _Str_2291(_Str_2291.AdInteraction));
            }
        }

        public var _Str_12737(get,never):String;
public function  get__Str_12737():String
        {
            if (_Str_577 != null)
            {
                return _Str_577.url;
            }
            return null;
        }

        function removeListeners()
        {
            if (this._Str_2339 != null)
            {
                this._Str_2339.removeEventListener(_Str_2291.AdLoaded, (this._Str_11953 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdStarted, (this._Str_11923 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdStopped, (this._Str_9919 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdLinearChange, (this._Str_11331 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdExpandedChange, (this._Str_11651 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdRemainingTimeChange, (this._Str_11403 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVolumeChange, (this._Str_11628 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdImpression, (this._Str_10917 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVideoStart, (this._Str_9960 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVideoFirstQuartile, (this._Str_12481 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVideoMidpoint, (this._Str_12116 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVideoThirdQuartile, (this._Str_10350 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdVideoComplete, (this._Str_10996 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdClickThru, (this._Str_10046 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdUserAcceptInvitation, (this._Str_11250 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdUserClose, (this._Str_10425 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdPaused, (this._Str_12292 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdPlaying, (this._Str_10670 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdLog, (this._Str_11557 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdError, (this._Str_11902 : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdSkipped, (this.onVPAIDAdSkipped : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdSkippableStateChange, (this.onVPAIDAdSkippableStateChange : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdSizeChange, (this.onVPAIDAdSizeChange : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdDurationChange, (this.onVPAIDAdDurationChange : ASAny));
                this._Str_2339.removeEventListener(_Str_2291.AdInteraction, (this.onVPAIDAdInteraction : ASAny));
            }
        }

        public function registerAsVPAID(k:VPAIDWrapper):Bool
        {
            var _local_2:String = null;
            if (k != null)
            {
                this._Str_2339 = k;
                _local_2 = null;
                if (this._Str_2339.isV100())
                {
                    _local_2 = this._Str_2339.initVPAIDVersion("1.0.0");
                }
                else
                {
                    if (this._Str_2339.isV110())
                    {
                        _local_2 = this._Str_2339.handshakeVersion("2.0");
                        this._Str_2339.addEventListener(_Str_2291.AdLoaded, (this._Str_11953 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdStarted, (this._Str_11923 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdStopped, (this._Str_9919 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdLinearChange, (this._Str_11331 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdExpandedChange, (this._Str_11651 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdRemainingTimeChange, (this._Str_11403 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVolumeChange, (this._Str_11628 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdImpression, (this._Str_10917 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVideoStart, (this._Str_9960 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVideoFirstQuartile, (this._Str_12481 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVideoMidpoint, (this._Str_12116 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVideoThirdQuartile, (this._Str_10350 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdVideoComplete, (this._Str_10996 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdClickThru, (this._Str_10046 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdUserAcceptInvitation, (this._Str_11250 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdUserClose, (this._Str_10425 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdPaused, (this._Str_12292 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdPlaying, (this._Str_10670 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdLog, (this._Str_11557 : ASAny));
                        this._Str_2339.addEventListener(_Str_2291.AdError, (this._Str_11902 : ASAny));
                        if (((_local_2 == "2.0") || (_local_2 == "2.0.0")))
                        {
                            this._Str_2339.addEventListener(_Str_2291.AdSkipped, (this.onVPAIDAdSkipped : ASAny));
                            this._Str_2339.addEventListener(_Str_2291.AdSkippableStateChange, (this.onVPAIDAdSkippableStateChange : ASAny));
                            this._Str_2339.addEventListener(_Str_2291.AdSizeChange, (this.onVPAIDAdSizeChange : ASAny));
                            this._Str_2339.addEventListener(_Str_2291.AdDurationChange, (this.onVPAIDAdDurationChange : ASAny));
                            this._Str_2339.addEventListener(_Str_2291.AdInteraction, (this.onVPAIDAdInteraction : ASAny));
                        }
                        return true;
                    }
                }
            }
            return false;
        }

        public function startVPAID(width:Float=-1, height:Float=-1, mode:String="normal", passReferrer:Bool=false, referrer:String=null)
        {
            var environmentVars:String = null;
            if (this._Str_2339 != null)
            {
                this._Str_7538 = false;
                environmentVars = "";
                if (passReferrer)
                {
                    if (referrer != null)
                    {
                        environmentVars = ("referrer=" + referrer);
                    }
                    else
                    {
                        try
                        {
                            referrer = BrowserUtils._Str_18507(true);
                            environmentVars = ("referrer=" + referrer);
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                        }
 }                    }
                }
                try
                {
                    this._Str_2339.initAd(Math.ffloor(width), Math.ffloor(height), mode, 400, ((adParameters == null) ? "" : adParameters), ((environmentVars == null) ? "" : environmentVars));
                    this._Str_8612();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    _Str_4213(("Exception generated in VPAID.initAd() - aborting - " + e.message));
                }
 }            }
        }

        public function resize(k:Float, _arg_2:Float, _arg_3:String)
        {
            if (this._Str_2339 != null)
            {
                this._Str_2339.resizeAd(k, _arg_2, _arg_3);
            }
        }

        public function pause()
        {
            if (this._Str_2339 != null)
            {
                this._Str_2339.pauseAd();
            }
        }

        public function resume()
        {
            if (this._Str_2339 != null)
            {
                this._Str_2339.resumeAd();
            }
        }

        function _Str_8612()
        {
            var k = 0;
            if (this._Str_9374)
            {
                if (this._Str_2850 == null)
                {
                    k = ((_Str_3543 != null) ? ((_Str_3543.getDurationAsInt() > 0) ? _Str_3543.getDurationAsInt() : this._Str_12307) : this._Str_12307);
                    if (k > 0)
                    {
                        if (this._Str_2850 != null)
                        {
                            this._Str_4743();
                        }
                        this._Str_2850 = new Timer((k * 1000), 2);
                        this._Str_2850.addEventListener(TimerEvent.TIMER, (this._Str_4743 : ASAny));
                        this._Str_2850.start();
                    }
                }
            }
        }

        public function _Str_4743(e:TimerEvent=null)
        {
            if (this._Str_2850 != null)
            {
                this._Str_2850.stop();
                this._Str_2850 = null;
                if (e != null)
                {
                    try
                    {
                        this._Str_2339.stopAd();
                        this._Str_4213("Timeout triggered on VPAID Ad startup - also for safety, tried to forcibly stop the VPAID ad before firing this error");
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                        _Str_4213(("Timeout timer triggered - forcing stop on exception generated from VPAID.stopAd() - " + e.message));
                    }
 }                }
            }
        }

        override public function isInteractive():Bool
        {
            return true;
        }

        function triggerTrackingEvent(k:String)
        {
            if (_Str_3543 != null)
            {
                if (_Str_3543.parentAdContainer != null)
                {
                    if (_Str_3543.parentAdContainer.hasWrapper())
                    {
                        _Str_3543.parentAdContainer.wrapper.triggerTrackingEvent(k);
                    }
                    else
                    {
                        _Str_3543.parentAdContainer.triggerTrackingEvent(k);
                    }
                }
            }
        }

        function triggerImpressionConfirmations()
        {
            if (_Str_3543 != null)
            {
                if (_Str_3543.parentAdContainer != null)
                {
                    if (_Str_3543.parentAdContainer.hasWrapper())
                    {
                        _Str_3543.parentAdContainer.wrapper.triggerImpressionConfirmations();
                    }
                    _Str_3543.parentAdContainer.triggerImpressionConfirmations();
                }
            }
        }

        function _Str_17523()
        {
            if (_Str_3543 != null)
            {
                _Str_3543.fireClickTracking();
            }
        }

        function _Str_11953(event:ASAny)
        {
            try
            {
                this._Str_2763(_Str_2291.AdLoaded);
                this._Str_2339.startAd();
                this._Str_19655();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _Str_4213(("Exception generated in VPAID.startAd() - aborting - " + e.message));
            }
 }        }

        function _Str_11923(k:ASAny)
        {
            this._Str_16122();
            this.triggerTrackingEvent(TrackingEvent.START);
            this._Str_2763(_Str_2291.AdStarted);
        }

        function _Str_9919(k:ASAny)
        {
            this._Str_4743();
            this.triggerTrackingEvent(TrackingEvent.STOP);
            this._Str_18050(_Str_2291.AdStopped);
        }

        function _Str_11331(k:ASAny)
        {
            if (this._Str_7990 != null)
            {
                this._Str_7990(new _Str_2291(_Str_2291.AdLinearChange, this._Str_2339.adLinear));
            }
        }

        function _Str_11651(k:ASAny)
        {
            if (this._Str_2339.adExpanded)
            {
                this.triggerTrackingEvent(TrackingEvent.EXPAND);
            }
            else
            {
                this.triggerTrackingEvent(TrackingEvent.COLLAPSE);
            }
            if (this._Str_8113 != null)
            {
                this._Str_8113(new _Str_2291(_Str_2291.AdExpandedChange, {
                    "expanded":this._Str_2339.adExpanded,
                    "linearPlayback":this._Str_2339.adLinear
                }));
            }
        }

        function _Str_11403(k:ASAny)
        {
            var _local_2= this._Str_2339.adRemainingTime;
            if (this._Str_7129 != null)
            {
                this._Str_7129(new _Str_2291(_Str_2291.AdRemainingTimeChange, _local_2));
            }
        }

        function _Str_11628(k:ASAny)
        {
            this._Str_16009();
        }

        function _Str_10917(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.CREATIVEVIEW);
            this.triggerImpressionConfirmations();
            this._Str_2763(_Str_2291.AdImpression);
            this._Str_17620();
        }

        function _Str_9960(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdVideoStart);
            this._Str_17749();
        }

        function _Str_12481(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.EVENT_1STQUARTILE);
            this._Str_2763(_Str_2291.AdVideoFirstQuartile);
            this._Str_17930();
        }

        function _Str_12116(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.MIDPOINT);
            this._Str_2763(_Str_2291.AdVideoMidpoint);
            this._Str_17794();
        }

        function _Str_10350(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.EVENT_3RDQUARTILE);
            this._Str_2763(_Str_2291.AdVideoThirdQuartile);
            this._Str_17525();
        }

        function _Str_10996(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.COMPLETE);
            this._Str_2763(_Str_2291.AdVideoComplete);
            this._Str_17016();
        }

        function _Str_10046(k:ASAny)
        {
            try
            {
                if (((!(k.data == /*undefined*/null)) && (!(k.data == null))))
                {
                    if ((ASCompat.toBool(k.data.playerHandles) && (!StringUtils.isEmpty(k.data.url))))
                    {
                        UserAgentUtils.openWindow(k.data.url, "_blank");
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            this._Str_17523();
            this._Str_2763(_Str_2291.AdClickThru);
            this._Str_18457();
        }

        function _Str_11250(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.ACCEPTINVITATION);
            this._Str_2763(_Str_2291.AdUserAcceptInvitation);
            this._Str_16595();
        }

        function _Str_22288(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.COLLAPSE);
            this._Str_2763(_Str_2291.AdUserMinimize);
            this._Str_17450();
        }

        function _Str_10425(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.CLOSE);
            this._Str_2763(_Str_2291.AdUserClose);
            this._Str_15930();
        }

        function _Str_12292(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.PAUSE);
            this._Str_4743();
            this._Str_2763(_Str_2291.AdPaused);
            this._Str_17824();
        }

        function _Str_10670(k:ASAny)
        {
            this.triggerTrackingEvent(TrackingEvent.RESUME);
            this._Str_8612();
            this._Str_2763(_Str_2291.AdPlaying);
            this._Str_17645();
        }

        function _Str_11557(k:ASAny)
        {
            if (k != null)
            {
                if (k.data != null)
                {
                    if (Std.is(k.data , String))
                    {
                        this._Str_7676(k.data);
                        return;
                    }
                    if ((k.data != null))
                    {
                        this._Str_7676(k.data.message);
                        return;
                    }
                }
            }
            this._Str_7676();
        }

        function _Str_11902(k:ASAny)
        {
            this._Str_4743();
            var _local_2= ((k.data != null) ? ((k.data.message != /*undefined*/null) ? k.data.message : k.data) : "no error message provided");
            this._Str_4213(_local_2);
        }

        function onVPAIDAdSkipped(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdSkipped, k.data);
        }

        function onVPAIDAdSkippableStateChange(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdSkippableStateChange, k.data);
        }

        function onVPAIDAdSizeChange(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdSizeChange, k.data);
        }

        function onVPAIDAdDurationChange(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdDurationChange, k.data);
        }

        function onVPAIDAdInteraction(k:ASAny)
        {
            this._Str_2763(_Str_2291.AdInteraction, k.data);
        }

        public function _Str_12035():ASObject
        {
            if (this._Str_2339 != null)
            {
                return this._Str_2339._Str_12035();
            }
            return new ASObject();
        }

	public function new() { super(); }
    }

