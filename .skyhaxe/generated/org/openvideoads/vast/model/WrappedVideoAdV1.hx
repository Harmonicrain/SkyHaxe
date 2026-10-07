package org.openvideoads.vast.model
;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.vast.server.request.wrapped._Str_6140;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import flash.events.Event;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.regions.view._Str_4027;
    import org.openvideoads.vast.events._Str_3019;

     class WrappedVideoAdV1 extends VideoAd implements _Str_3802 
    {
        var _Str_5185:String = null;
        var _Str_2620:VideoAdServingTemplate = null;
        var _Str_8143:ASObject = null;
        var _Str_4845:VideoAdServingTemplate = null;
        var _Str_2611:VideoAd = null;
        var _Str_15129:Array<ASAny>;
        var _Str_17653:Array<ASAny>;
        var _Str_19298:AdServerConfig = null;

        public function new(k:ASObject, _arg_2:com.sulake.core.utils.xml.XML=null, _arg_3:VideoAdServingTemplate=null, _arg_4:AdServerConfig=null)
        {
            this._Str_15129 = new Array<ASAny>();
            this._Str_17653 = new Array<ASAny>();
            super();
            this._Str_8143 = k;
            this._Str_4845 = _arg_3;
            this._Str_19298 = _arg_4;
            if (_arg_2 != null)
            {
                this.initialise(_arg_2);
            }
        }

        function initialise(k:com.sulake.core.utils.xml.XML)
        {
            this.id = ASCompat.xmlListToString(k.child("adId"));
            adSystem = ASCompat.xmlListToString(k.child("AdSystem"));
            if (k.child("VASTAdTagURL").child("URL" )!= /*undefined*/null)
            {
                this._Str_6281 = ASCompat.xmlListToString(k.child("VASTAdTagURL").child("URL").text());
            }
            _Str_16323(k);
            _Str_18315(k);
            this._Str_22331(k);
            if (this._Str_17688())
            {
                this._Str_24923();
            }
        }

        override public function setPreferredSelectionCriteria(k:ASObject)
        {
            _Str_3562 = k;
            if (this._Str_2611 != null)
            {
                this._Str_2611.setPreferredSelectionCriteria(k);
            }
        }

        public function _Str_22331(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XMLList = null;
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4 = 0;
            if (k.child("VideoClicks" )!= /*undefined*/null)
            {
                if (k.child("VideoClicks").child("ClickTracking" )!= /*undefined*/null)
                {
                    _local_4 = 0;
                    if (k.child("VideoClicks").child("ClickTracking").children().length() > 0)
                    {
                        _local_2 = k.child("VideoClicks").child("ClickTracking").children();
                        _local_4 = 0;
                        while (_local_4 < _local_2.length())
                        {
                            _local_3 = _local_2.at(_local_4);
                            if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_3.text())))
                            {
                                this._Str_10053(new NetworkResource(_local_3.attribute("id").toString(), ASCompat.xmlListToString(_local_3.text())));
                            }
                            _local_4++;
                        }
                    }
                }
                if (k.child("VideoClicks").child("CustomClick" )!= /*undefined*/null)
                {
                    if (k.child("VideoClicks").child("CustomClick").children().length() > 0)
                    {
                        _local_2 = k.child("CustomClick").child("ClickTracking").children();
                        _local_4 = 0;
                        while (_local_4 < _local_2.length())
                        {
                            _local_3 = _local_2.at(_local_4);
                            if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_3.text())))
                            {
                                this._Str_10085(new NetworkResource(_local_3.attribute("id").toString(), ASCompat.xmlListToString(_local_3.text())));
                            }
                            _local_4++;
                        }
                    }
                }
            }
        }

        public function _Str_10053(k:NetworkResource)
        {
            this._Str_15129.push(k);
        }

        public function _Str_26348():Array<ASAny>
        {
            return this._Str_15129;
        }

        override public function addClickTrackingItems(k:Array<ASAny>)
        {
            if (this._Str_2717())
            {
                return this._Str_2611.addClickTrackingItems(k);
            }
        }

        public function _Str_10085(k:NetworkResource)
        {
            this._Str_17653.push(k);
        }

        override public function addCustomClickTrackingItems(k:Array<ASAny>)
        {
            if (this._Str_2717())
            {
                return this._Str_2611.addCustomClickTrackingItems(k);
            }
        }

        override public function getImpressionList():Array<ASAny>
        {
            if (this._Str_2717())
            {
                return this._Str_2611.getImpressionList();
            }
            return new Array<ASAny>();
        }

        override public function canFireAPICalls():Bool
        {
            return false;
        }

        override public function canFireEventAPICalls():Bool
        {
            return false;
        }

        override public function  get_useV2APICalls():Bool
        {
            return false;
        }

        override public function  get_jsCallbackScopingPrefix():String
        {
            return "";
        }

        public var analyticsProcessor(get,never):_Str_2408;
public function  get_analyticsProcessor():_Str_2408
        {
            if (this._Str_4845 != null)
            {
                return this._Str_4845.analyticsProcessor;
            }
            return null;
        }

        override public function  set_id(k:String):String        {
            if (this._Str_2717())
            {
                this._Str_2611.id = k;
            }
            return _id = k;
        }

        override public function  get_id():String
        {
            if (this._Str_2717())
            {
                return this._Str_2611.id;
            }
            if (this._Str_8143 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_8143, "id"))
                {
                    return this._Str_8143.id;
                }
            }
            return _id;
        }

        
        public var _Str_6281(get,set):String;
public function  set__Str_6281(k:String):String        {
            return this._Str_5185 = k;
        }
public function  get__Str_6281():String
        {
            return this._Str_5185;
        }

        public function _Str_17688():Bool
        {
            return (!(this._Str_5185 == null)) && (StringUtils.isEmpty(this._Str_5185) == false);
        }

        public function _Str_24923()
        {
            var k:_Str_6140 = null;
            var _local_2:Array<ASAny> = null;
            if (this._Str_5185 != null)
            {
                if (this._Str_4845 != null)
                {
                    this._Str_4845._Str_15107(_uid);
                }
                k = new _Str_6140(this._Str_5185, this._Str_19298);
                _local_2 = new Array<ASAny>();
                _local_2.push(this._Str_8143);
                this._Str_2620 = new VideoAdServingTemplate(this, k, true, _local_2);
            }
        }

        public function onTemplateLoaded(k:AdServerTemplate)
        {
            this._Str_2611 = this._Str_2620._Str_24138();
            if (this._Str_2611 != null)
            {
                this._Str_2611.addClickTrackingItems(this._Str_15129);
                this._Str_2611.addCustomClickTrackingItems(this._Str_17653);
                this._Str_2611.wrapper = this;
            }
            this._Str_4845._Str_6919(_uid);
        }

        public function onTemplateLoadError(k:Event)
        {
            this._Str_4845._Str_6067(_uid, k);
        }

        public function _Str_5807(k:Event)
        {
            this._Str_4845._Str_8677(uid, k);
        }

        public function _Str_5916(k:Event)
        {
            this._Str_4845._Str_16343(uid, k);
        }

        public function onAdCallStarted(k:AdServerRequest)
        {
            this._Str_4845.onAdCallStarted(k);
        }

        public function onAdCallFailover(k:AdServerRequest, _arg_2:AdServerRequest)
        {
            this._Str_4845.onAdCallFailover(k, _arg_2);
        }

        public function onAdCallComplete(k:AdServerRequest, _arg_2:Bool)
        {
            this._Str_4845.onAdCallComplete(k, _arg_2);
        }

        public function _Str_2717():Bool
        {
            return !(this._Str_2611 == null);
        }

        override public function setLinearAdDurationFromSeconds(k:Int)
        {
            if (this._Str_2717())
            {
                return this._Str_2611.setLinearAdDurationFromSeconds(k);
            }
            return super.setLinearAdDurationFromSeconds(k);
        }

        override public function  get_duration():Int
        {
            if (this._Str_2717())
            {
                return this._Str_2611.duration;
            }
            return super.duration;
        }

        override public function  get_error():String
        {
            if (this._Str_2717())
            {
                return this._Str_2611.error;
            }
            return super.error;
        }

        override public function  get_linearVideoAd():LinearVideoAd
        {
            if (this._Str_2717())
            {
                return this._Str_2611.linearVideoAd;
            }
            return super.linearVideoAd;
        }

        override public function  get_nonLinearVideoAds():Array<ASAny>
        {
            if (this._Str_2717())
            {
                return this._Str_2611.nonLinearVideoAds;
            }
            return super.nonLinearVideoAds;
        }

        override public function  get_firstNonLinearVideoAd():NonLinearVideoAd
        {
            if (this._Str_2717())
            {
                if (this.hasNonLinearAds())
                {
                    return this._Str_2611.firstNonLinearVideoAd;
                }
                return null;
            }
            return super.firstNonLinearVideoAd;
        }

        override public function hasNonLinearAds():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.hasNonLinearAds();
            }
            return super.hasNonLinearAds();
        }

        override public function hasLinearAd():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.hasLinearAd();
            }
            return super.hasLinearAd();
        }

        override public function isInteractive():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.isInteractive();
            }
            return super.isInteractive();
        }

        override public function canScale():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.canScale();
            }
            return super.canScale();
        }

        override public function shouldMaintainAspectRatio():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.shouldMaintainAspectRatio();
            }
            return super.shouldMaintainAspectRatio();
        }

        override public function  get_companionAds():Array<ASAny>
        {
            if (this._Str_2717())
            {
                return this._Str_2611.companionAds;
            }
            return super.companionAds;
        }

        override public function hasCompanionAds():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.hasCompanionAds();
            }
            return super.hasCompanionAds();
        }

        override public function isLinear():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.isLinear();
            }
            return super.isLinear();
        }

        override public function isNonLinear():Bool
        {
            if (this._Str_2717())
            {
                return this._Str_2611.isNonLinear();
            }
            return super.isNonLinear();
        }

        override public function getStreamToPlay():AdNetworkResource
        {
            if (this._Str_2717())
            {
                return this._Str_2611.getStreamToPlay();
            }
            return super.getStreamToPlay();
        }

        override public function getFlashMediaToPlay(k:Float, _arg_2:Float, _arg_3:Bool=false):_Str_4027
        {
            if (this._Str_2717())
            {
                return this._Str_2611.getFlashMediaToPlay(k, _arg_2, _arg_3);
            }
            return super.getFlashMediaToPlay(k, _arg_2, _arg_3);
        }

        override public function triggerTrackingEvent(k:String, _arg_2:String=null)
        {
            if (this._Str_2717())
            {
                this._Str_2611.triggerTrackingEvent(k);
            }
            super.triggerTrackingEvent(k);
        }

        override public function triggerForcedImpressionConfirmations(k:Bool=false)
        {
            if (this._Str_2717())
            {
                this._Str_2611.triggerForcedImpressionConfirmations(k);
            }
            super.triggerForcedImpressionConfirmations();
        }

        override public function processStartAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStartAdEvent();
            }
            super.processStartAdEvent();
        }

        override public function processStopAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStopAdEvent();
            }
            super.processStopAdEvent();
        }

        override public function processPauseAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processPauseAdEvent();
            }
            super.processPauseAdEvent();
        }

        override public function processResumeAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processResumeAdEvent();
            }
            super.processResumeAdEvent();
        }

        override public function processFullScreenAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processFullScreenAdEvent();
            }
            super.processFullScreenAdEvent();
        }

        override public function processMuteAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processMuteAdEvent();
            }
            super.processMuteAdEvent();
        }

        override public function processUnmuteAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processUnmuteAdEvent();
            }
            super.processUnmuteAdEvent();
        }

        override public function processReplayAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processReplayAdEvent();
            }
            super.processReplayAdEvent();
        }

        override public function processHitMidpointAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processHitMidpointAdEvent();
            }
            super.processHitMidpointAdEvent();
        }

        override public function processFirstQuartileCompleteAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processFirstQuartileCompleteAdEvent();
            }
            super.processFirstQuartileCompleteAdEvent();
        }

        override public function processThirdQuartileCompleteAdEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processThirdQuartileCompleteAdEvent();
            }
            super.processThirdQuartileCompleteAdEvent();
        }

        override public function processAdCompleteEvent()
        {
            if (this._Str_2717())
            {
                this._Str_2611.processAdCompleteEvent();
            }
            super.processAdCompleteEvent();
        }

        override public function processStartNonLinearAdEvent(k:_Str_3019)
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStartNonLinearAdEvent(k);
            }
            super.triggerImpressionConfirmations();
        }

        override public function processStopNonLinearAdEvent(k:_Str_3019)
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStopNonLinearAdEvent(k);
            }
            super.processStopNonLinearAdEvent(k);
        }

        override public function processStartCompanionAdEvent(k:_Str_3019)
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStartCompanionAdEvent(k);
            }
            super.processStartCompanionAdEvent(k);
        }

        override public function processStopCompanionAdEvent(k:_Str_3019)
        {
            if (this._Str_2717())
            {
                this._Str_2611.processStopCompanionAdEvent(k);
            }
            super.processStopCompanionAdEvent(k);
        }

        override public function toJSObject():ASObject
        {
            if (this._Str_2717())
            {
                return this._Str_2611.toJSObject();
            }
            return super.toJSObject();
        }
    }

