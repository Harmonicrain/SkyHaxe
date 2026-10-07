package org.openvideoads.vast.model
;
    import org.openvideoads.vast.server.response.AdServerTemplate;
    import org.openvideoads.vast.server.response._Str_3802;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import org.openvideoads.vast.server.request.injected._Str_9148;
    import org.openvideoads.util._Str_9615;
    import flash.events.Event;
    import org.openvideoads.vast.analytics._Str_2408;
    import org.openvideoads.util.ObjectUtils;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.util.Timestamp;
    import flash.utils.ByteArray;
    import flash.events.*;
    import flash.net.*;
    import flash.xml.*;

     class VideoAdServingTemplate extends AdServerTemplate implements _Str_3802 
    {
        public static inline final ALL= "ALL";
        public static inline final LINEAR= "LINEAR";
        public static inline final _Str_15460= "NON-LINEAR";

        var _Str_3517:Array<ASAny>;

        public function new(k:_Str_3802=null, _arg_2:AdServerRequest=null, _arg_3:Bool=false, _arg_4:Array<ASAny>=null)
        {
            this._Str_3517 = new Array<ASAny>();
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function load(k:AdServerRequest, _arg_2:Bool=false)
        {
            if (k != null)
            {
                if (!_arg_2)
                {
                    _Str_17208 = k;
                    _Str_15107(_uid);
                }
                if (Std.is(k , _Str_9148))
                {
                    _Str_3081 = new _Str_9615();
                    _Str_3081.addEventListener(Event.COMPLETE, (this.templateLoaded : ASAny));
                    cast(_Str_3081, _Str_9615).process(k.formRequest());
                }
                else
                {
                    this.loadTemplateData(k);
                }
            }
        }

        override function loadTemplateData(k:AdServerRequest)
        {
            if (k != null)
            {
                super.loadTemplateData(k);
            }
        }

        public function canFireAPICalls():Bool
        {
            return false;
        }

        public function canFireEventAPICalls():Bool
        {
            return false;
        }

        public var useV2APICalls(get,never):Bool;
public function  get_useV2APICalls():Bool
        {
            return false;
        }

        public var jsCallbackScopingPrefix(get,never):String;
public function  get_jsCallbackScopingPrefix():String
        {
            return "";
        }

        public var analyticsProcessor(get,never):_Str_2408;
public function  get_analyticsProcessor():_Str_2408
        {
            if (_Str_2459 != null)
            {
                return _Str_2459.analyticsProcessor;
            }
            return null;
        }

        override function getReplacementAdId(k:String):String
        {
            var _local_2:ASObject = null;
            if (_Str_5528 != null)
            {
                final _iter_ = _Str_5528; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if ((((_local_2.slotType == k) || ((_local_2.slotType + "-vpaid") == k)) && (_local_2.assigned == false)))
                    {
                        _local_2.assigned = true;
                        return _local_2.id;
                    }
                }
            }
            return k + ":not-scheduled";
        }

        function _Str_22874(k:Int):ASObject
        {
            if (_Str_5528 != null)
            {
                if (k < _Str_5528.length)
                {
                    return _Str_5528[k];
                }
            }
            return ({
                "id":"no-id-found",
                "slotType":"unknown",
                "assigned":false
            });
        }

        function _Str_22853(k:String):String
        {
            var _local_2:ASObject = null;
            if (_Str_5528 != null)
            {
                final _iter_ = _Str_5528; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (_local_2.id == k)
                    {
                        return _local_2.slotType;
                    }
                }
            }
            return null;
        }

        override function templateLoaded(k:Event)
        {
            _Str_6188 = _Str_3081.transformedData;
            this._Str_15022(_Str_6188);
            if (this.hasAds())
            {
                _Str_8445 = true;
                super.templateLoaded(k);
                return;
            }
            _Str_8445 = true;
            super.templateLoaded(k);
        }

        override function errorHandler(k:Event)
        {
            _Str_6067(_uid, k);
        }

        override function timeoutHandler(k:Event)
        {
            _Str_8677(_uid, k);
        }

        override public function filterLinearAdMediaFileByMimeType(k:Array<ASAny>)
        {
            var _local_2 = 0;
            while (_local_2 < _Str_2518.length)
            {
                if (cast(_Str_2518[_local_2], VideoAd).isLinear())
                {
                    cast(_Str_2518[_local_2], VideoAd).filterLinearAdMediaFileByMimeType(k);
                }
                _local_2++;
            }
        }

        public function _Str_15022(rawData:ASAny)
        {
            var xmlData:com.sulake.core.utils.xml.XML = null;
            var tagName:String = null;
            if (rawData != null)
            {
                com.sulake.core.utils.xml.XML.ignoreWhitespace = true;
                try
                {
                    xmlData = new com.sulake.core.utils.xml.XML(rawData);
                    if (xmlData != null)
                    {
                        if (xmlData.length() > 0)
                        {
                            tagName = xmlData.name();
                            if (tagName != null)
                            {
                                if (tagName.indexOf("VAST") > -1)
                                {
                                    if (((com.sulake.core.utils.xml.XML.equalsStringOperands(xmlData.attribute("version") , "2.0") || com.sulake.core.utils.xml.XML.equalsStringOperands(xmlData.attribute("version") , "2.0.0")) || com.sulake.core.utils.xml.XML.equalsStringOperands(xmlData.attribute("version") , "2.0.1")))
                                    {
                                        this.parseAdSpecs_V2(xmlData.child("Ad"));
                                    }
                                }
                                else
                                {
                                    if (tagName.indexOf("VideoAdServingWrapper") <= -1)
                                    {
                                        if (((!(xmlData.child("Video" )== /*undefined*/null)) || (!(xmlData.child("NonLinearAds" )== /*undefined*/null))))
                                        {
                                            this._Str_23460(xmlData);
                                        }
                                        else
                                        {
                                            this.parseAdSpecs_V1_X(xmlData.children());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
catch (__as3Caught:Dynamic) { var errObject:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        function _Str_23460(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2= this.parseInlineAd_V1_X(0, "no-id", k, LINEAR);
            if (_local_2 != null)
            {
                _Str_3462(_local_2);
            }
            _local_2 = this.parseInlineAd_V1_X(1, "no-id", k, _Str_15460);
            if (_local_2 != null)
            {
                _Str_3462(_local_2);
            }
        }

        function parseAdSpecs_V1_X(k:com.sulake.core.utils.xml.XMLList)
        {
            var _local_3:com.sulake.core.utils.xml.XMLList = null;
            var _local_4:VideoAd = null;
            var _local_5:Array<ASAny> = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:VideoAd = null;
            var _local_2 = 0;
            while (_local_2 < k.length())
            {
                _local_3 = k.at(_local_2).attribute("id");
                if (k.at(_local_2).children().length() == 1)
                {
                    _local_4 = this.parseAdResponse_V1_X(_local_2, ASCompat.xmlToString(_local_3.at(0)), k.at(_local_2));
                    if (_local_4 != null)
                    {
                        if (_local_4._Str_25585("OpenX"))
                        {
                            _Str_3462(_local_4);
                        }
                        else
                        {
                            if (_Str_14997() == false)
                            {
                                _Str_3462(_local_4);
                            }
                            else
                            {
                                if (_local_4._Str_23787())
                                {
                                    _local_5 = _local_4.split();
                                    _local_6 = _local_4.id;
                                    _local_7 = this._Str_22853(_local_6);
                                    if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                                    {
_local_8  = _tmp_;
                                        if (((_local_7 == "linear") && _local_8.isLinear()))
                                        {
                                            _local_8.id = _local_6;
                                            _local_7 = null;
                                        }
                                        else
                                        {
                                            if (((_local_7 == "non-linear") && _local_8.isNonLinear()))
                                            {
                                                _local_8.id = _local_6;
                                                _local_7 = null;
                                            }
                                            else
                                            {
                                                _local_8.id = this.getReplacementAdId((_local_8.isNonLinear() ? "non-linear" : "linear"));
                                            }
                                        }
                                        _Str_3462(_local_8);
                                    }
                                }
                                else
                                {
                                    _Str_3462(_local_4);
                                }
                            }
                        }
                    }
                }
                _local_2++;
            }
        }

        function parseAdResponse_V1_X(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML):VideoAd
        {
            if (_arg_3.child("InLine" )!= /*undefined*/null)
            {
                return this.parseInlineAd_V1_X(k, _arg_2, _arg_3.children().at(0), ALL);
            }
            if (_arg_3.child("Wrapper" )!= /*undefined*/null)
            {
                return this.parseWrappedAd_V1_X(k, _arg_2, _arg_3.children().at(0));
            }
            return null;
        }

        function parseWrappedAd_V1_X(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML):WrappedVideoAdV1
        {
            if (_arg_3.children().length() > 0)
            {
                return new WrappedVideoAdV1(this._Str_22874(k), _arg_3, this, _Str_18666());
            }
            return null;
        }

        function parseInlineAd_V1_X(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML, _arg_4:String="ALL"):VideoAd
        {
            var _local_5:VideoAd = null;
            if (_arg_3.children().length() > 0)
            {
                _local_5 = new VideoAd();
                _local_5.adSystem = ASCompat.xmlListToString(_arg_3.child("AdSystem"));
                _local_5.adTitle = ASCompat.xmlListToString(_arg_3.child("AdTitle"));
                _local_5.adId = _arg_2;
                _local_5.description = ASCompat.xmlListToString(_arg_3.child("Description"));
                if (_arg_3.child("Survey" )!= null)
                {
                    if (_arg_3.child("Survey").child("URL" )!= /*undefined*/null)
                    {
                        _local_5.survey = ASCompat.xmlListToString(_arg_3.child("Survey").child("URL"));
                    }
                    else
                    {
                        _local_5.survey = ASCompat.xmlListToString(_arg_3.child("Survey"));
                    }
                }
                _local_5.error = ASCompat.xmlListToString(_arg_3.child("Error"));
                _local_5._Str_16323(_arg_3);
                _local_5._Str_18315(_arg_3);
                if ((((_arg_4 == LINEAR) || (_arg_4 == ALL)) && (!(_arg_3.child("Video" )== /*undefined*/null))))
                {
                    _local_5._Str_24028(_arg_3, -1, _Str_5664());
                }
                if ((((_arg_4 == _Str_15460) || (_arg_4 == ALL)) && (!(_arg_3.child("NonLinearAds" )== /*undefined*/null))))
                {
                    _local_5._Str_24780(_arg_3);
                }
                if (_arg_3.child("CompanionAds" )!= /*undefined*/null)
                {
                    _local_5._Str_24076(_arg_3);
                }
                _local_5._Str_25118(_arg_3);
                if (_Str_13492())
                {
                    _local_5.id = this.getReplacementAdId((_local_5.isNonLinear() ? "non-linear" : "linear"));
                }
                else
                {
                    _local_5.id = _arg_2;
                }
                return _local_5;
            }
            return null;
        }

        public function onTemplateLoaded(k:AdServerTemplate)
        {
            if (Std.is(k , WrappedVideoAdServingTemplateV2))
            {
                _Str_11882(k, true, true);
            }
            else
            {
                _Str_11882(k);
            }
            _Str_6919(k.uid);
        }

        public function onTemplateLoadError(k:Event)
        {
            _Str_6067(uid, k);
        }

        public function _Str_5807(k:Event)
        {
            _Str_8677(uid, k);
        }

        public function _Str_5916(k:Event)
        {
            _Str_16343(uid, k);
        }

        public function onAdCallStarted(k:AdServerRequest)
        {
            if (_Str_2459 != null)
            {
                _Str_2459.onAdCallStarted(k);
            }
        }

        public function onAdCallFailover(k:AdServerRequest, _arg_2:AdServerRequest)
        {
            if (_Str_2459 != null)
            {
                _Str_2459.onAdCallFailover(k, _arg_2);
            }
        }

        public function onAdCallComplete(k:AdServerRequest, _arg_2:Bool)
        {
            if (_Str_2459 != null)
            {
                _Str_2459.onAdCallComplete(k, _arg_2);
            }
        }

        function parseAdSpecs_V2(k:com.sulake.core.utils.xml.XMLList)
        {
            var _local_3:com.sulake.core.utils.xml.XMLList = null;
            var _local_2 = 0;
            while (_local_2 < k.length())
            {
                _local_3 = k.at(_local_2).attribute("id");
                if (k.at(_local_2).children().length() == 1)
                {
                    this.parseAdResponse_V2(_local_2, ASCompat.xmlToString(_local_3.at(0)), k.at(_local_2));
                }
                _local_2++;
            }
        }

        function parseAdResponse_V2(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML)
        {
            if (_arg_3 != null)
            {
                if (_arg_3.child("InLine" )!= /*undefined*/null)
                {
                    this.parseInlineAd_V2(k, _arg_2, _arg_3.children().at(0));
                }
                else
                {
                    if (_arg_3.child("Wrapper" )!= /*undefined*/null)
                    {
                        this.parseWrappedAd_V2(k, _arg_2, _arg_3.children().at(0));
                    }
                }
            }
        }

        function parseWrappedAd_V2(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML):WrappedVideoAdServingTemplateV2
        {
            if (_arg_3.children().length() > 0)
            {
                return new WrappedVideoAdServingTemplateV2(k, _arg_2, _arg_3, this);
            }
            return null;
        }

        function _Str_24753(k:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            var _local_3:com.sulake.core.utils.xml.XMLList = null;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_2= new Array<ASAny>();
            if (k.child("Impression" )!= null)
            {
                _local_3 = k.child("Impression");
                if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
                {
_local_4  = _tmp_;
                    _local_2.push(new Impression(_local_4.attribute("id").toString(), ASCompat.xmlListToString(_local_4.text())));
                }
            }
            return _local_2;
        }

        function _Str_23240(k:com.sulake.core.utils.xml.XML):ASObject
        {
            var _local_5:com.sulake.core.utils.xml.XMLList = null;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7:ASObject = null;
            var _local_2= new Array<ASAny>();
            var _local_3= new Array<ASAny>();
            if (k.child("Extensions" )!= null)
            {
                _local_5 = k.child("Extensions").children();
                if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                {
_local_6  = _tmp_;
                    if (com.sulake.core.utils.xml.XML.equalsStringOperands(_local_6.attribute("type") , "ad_playtype"))
                    {
                        _local_3.push(new Impression("ad_playtype", _local_6.children().toXMLString()));
                    }
                    else
                    {
                        _local_7 = new ASObject();
                        _local_7.label = ((_local_6.attribute("type") != null) ? _local_6.attribute("type").toString() : "undefined");
                        _local_7.text = _local_6.children().toXMLString();
                        _local_2.push(_local_7);
                    }
                }
            }
            var _local_4:ASObject = {
                "extensions":_local_2,
                "impressions":_local_3
            }
;            return _local_4;
        }

        function createVideoAd_V2(k:String, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:String):VideoAd
        {
            var _local_8= new VideoAdV2();
            if (_Str_13492())
            {
                _local_8.id = this.getReplacementAdId(_arg_5);
            }
            else
            {
                _local_8.id = k;
            }
            _local_8._Str_22008 = _arg_7;
            _local_8.inlineAdId = _arg_6;
            _local_8.adId = k;
            _local_8.creativeId = _arg_3;
            _local_8.sequenceId = _arg_4;
            _local_8.adSystem = ASCompat.xmlListToString(_arg_2.child("AdSystem"));
            _local_8.adTitle = ASCompat.xmlListToString(_arg_2.child("AdTitle"));
            _local_8.description = ASCompat.xmlListToString(_arg_2.child("Description"));
            _local_8.survey = ASCompat.xmlListToString(_arg_2.child("Survey"));
            _local_8.error = ASCompat.xmlListToString(_arg_2.child("Error"));
            return _local_8;
        }

        function _Str_14144(k:Array<ASAny>, _arg_2:VideoAd):Array<ASAny>
        {
            var _local_4:CompanionAd = null;
            var _local_5:CompanionAd = null;
            var _local_3= new Array<ASAny>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_5  = _tmp_;
                _local_4 = _local_5.clone();
                _local_4.parentAdContainer = _arg_2;
                _local_3.push(_local_4);
            }
            return _local_3;
        }

        function _Str_20182(k:Array<ASAny>, _arg_2:Array<ASAny>):Array<ASAny>
        {
            if (k == null)
            {
                k = new Array<ASAny>();
            }
            if (_arg_2 == null)
            {
                return k;
            }
            return k.concat(_arg_2);
        }

        function parseInlineAd_V2(k:Int, _arg_2:String, _arg_3:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            var _local_7:ASObject = null;
            var _local_8:com.sulake.core.utils.xml.XMLList = null;
            var _local_9:Array<ASAny> = null;
            var _local_10 = 0;
            var _local_11:ASObject = null;
            var _local_12:VideoAd = null;
            var _local_13:com.sulake.core.utils.xml.XMLList = null;
            var _local_14 = 0;
            var _local_15:Array<ASAny> = null;
            var _local_16:Array<ASAny> = null;
            var _local_17:Array<ASAny> = null;
            var _local_18:com.sulake.core.utils.xml.XML = null;
            var _local_19:String = null;
            var _local_20:String = null;
            var _local_21:String = null;
            var _local_22:VideoAd = null;
            var _local_23:LinearVideoAd = null;
            var _local_4= new Array<ASAny>();
            var _local_5= new Array<ASAny>();
            var _local_6= ObjectUtils._Str_22043();
            if (_arg_3.children().length() > 0)
            {
                _local_7 = this._Str_23240(_arg_3);
                _local_5 = _local_7.extensions;
                _local_4 = this._Str_24753(_arg_3);
                if (_local_7.impressions.length > 0)
                {
                    _local_4 = ASCompat.arrayConcat(_local_4, _local_7.impressions);
                }
                _local_8 = _arg_3.child("Creatives");
                if (_local_8 != null)
                {
                    _local_9 = new Array<ASAny>();
                    _local_10 = 0;
                    while (_local_10 < _local_8.length())
                    {
                        _local_13 = _local_8.at(_local_10).child("Creative");
                        if (_local_13 != null)
                        {
                            _local_14 = 1;
                            _local_15 = new Array<ASAny>();
                            _local_16 = new Array<ASAny>();
                            _local_17 = new Array<ASAny>();
                            if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13)
                            {
_local_18  = _tmp_;
                                _local_19 = ASCompat.xmlListToString(_local_18.attribute("AdID"));
                                _local_20 = ASCompat.xmlListToString(_local_18.attribute("id"));
                                _local_21 = ASCompat.xmlListToString(_local_18.attribute("sequence"));
                                this._Str_22765();
                                _local_15 = this._Str_24274(_local_18.child("Linear"));
                                _local_16 = this._Str_25355(_local_18.child("NonLinearAds"));
                                _local_17 = this._Str_25848(_local_18.child("CompanionAds"));
                                _local_22 = null;
                                if (checkNullIteratee(_local_15)) for (_tmp_ in _local_15)
                                {
_local_23  = _tmp_;
                                    _local_22 = this.createVideoAd_V2(_local_19, _arg_3, _local_20, _local_21, VideoAd.LINEAR, _local_6, _arg_2);
                                    if (_local_4.length > 0)
                                    {
                                        _local_22.impressions = _local_4;
                                    }
                                    if (_local_5.length > 0)
                                    {
                                        _local_22.extensions = _local_5;
                                    }
                                    _local_22.linearVideoAd = _local_23;
                                    if (_local_17.length > 0)
                                    {
                                        _local_22.companionAds = this._Str_14144(_local_17, _local_22);
                                    }
                                    _Str_3462(_local_22);
                                }
                                if (_local_16.length > 0)
                                {
                                    _local_22 = this.createVideoAd_V2(_local_19, _arg_3, _local_20, _local_21, VideoAd._Str_6723, _local_6, _arg_2);
                                    if (_local_4.length > 0)
                                    {
                                        _local_22.impressions = _local_4;
                                    }
                                    if (_local_5.length > 0)
                                    {
                                        _local_22.extensions = _local_5;
                                    }
                                    _local_22.nonLinearVideoAds = _local_16;
                                    if (_local_17.length > 0)
                                    {
                                        _local_22.companionAds = this._Str_14144(_local_17, _local_22);
                                    }
                                    _Str_3462(_local_22);
                                }
                                if (((((_local_15.length == 0) && (_local_16.length == 0)) && (_local_17.length > 0)) || false))
                                {
                                    _local_22 = this.createVideoAd_V2(_local_19, _arg_3, _local_20, _local_21, VideoAd.COMPANION, _local_6, _arg_2);
                                    if (_local_4.length > 0)
                                    {
                                        _local_22.impressions = _local_4;
                                    }
                                    if (_local_5.length > 0)
                                    {
                                        _local_22.extensions = _local_5;
                                    }
                                    _local_22.companionAds = _local_17;
                                    _Str_3462(_local_22);
                                    _local_9.push({
                                        "adId":_local_19,
                                        "creativeId":_local_20,
                                        "sequenceId":_local_21,
                                        "companions":_local_17
                                    });
                                }
                                if ((((((_local_15.length == 0) && (_local_16.length == 0)) && (_local_17.length == 0)) && (hasAds(true) == false)) && (_local_4.length > 0)))
                                {
                                    _local_22 = this.createVideoAd_V2(_local_19, _arg_3, _local_20, _local_21, VideoAd.LINEAR, _local_6, _arg_2);
                                    _local_22.impressions = _local_4;
                                    _Str_3462(_local_22);
                                }
                                _local_14++;
                            }
                        }
                        _local_10++;
                    }
                    if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                    {
_local_11  = _tmp_;
                        final _iter_ = _Str_2518; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_12  = _tmp_;
                            if (_local_12._Str_19109(_local_6))
                            {
                                if (((!(_local_12.adType == VideoAd.COMPANION)) && (!_local_12.hasCompanionAds())))
                                {
                                    if ((StringUtils.isEmpty(_local_11.creativeId) && StringUtils.isEmpty(_local_11.sequenceId)))
                                    {
                                        _local_12.companionAds = this._Str_20182(_local_12.companionAds, this._Str_14144(_local_11.companions, _local_12));
                                    }
                                }
                            }
                        }
                    }
                    if (checkNullIteratee(_local_9)) for (_tmp_ in _local_9)
                    {
_local_11  = _tmp_;
                        final _iter_ = _Str_2518; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_12  = _tmp_;
                            if (_local_12._Str_19109(_local_6))
                            {
                                if (_local_12.adType != VideoAd.COMPANION)
                                {
                                    if ((((!(_local_12.sequenceId == null)) && (_local_12.sequenceId == _local_11.sequenceId)) || ((!(_local_12.creativeId == null)) && (_local_12.creativeId == _local_11.creativeId))))
                                    {
                                        _local_12.companionAds = this._Str_20182(_local_12.companionAds, this._Str_14144(_local_11.companions, _local_12));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return _local_4;
        }

        function _Str_22765()
        {
            this._Str_3517 = new Array<ASAny>();
        }

        function _Str_17110(k:Int, _arg_2:Int):Int
        {
            var _local_3 = 0;
            while (_local_3 < this._Str_3517.length)
            {
                if (((this._Str_3517[_local_3].width == k) && (this._Str_3517[_local_3].height == _arg_2)))
                {
                    this._Str_3517[_local_3].index = (this._Str_3517[_local_3].index + 1);
                    return ASCompat.toInt(this._Str_3517[_local_3].index);
                }
                _local_3++;
            }
            this._Str_3517.push({
                "width":k,
                "height":_arg_2,
                "index":0
            });
            return 0;
        }

        function _Str_24274(k:com.sulake.core.utils.xml.XMLList):Array<ASAny>
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:LinearVideoAd = null;
            var _local_5:String = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:com.sulake.core.utils.xml.XMLList = null;
            var _local_11:MediaFile = null;
            var _local_12 = 0;
            var _local_13:com.sulake.core.utils.xml.XML = null;
            var _local_14:String = null;
            var _local_15:NetworkResource = null;
            var _local_16:com.sulake.core.utils.xml.XMLList = null;
            var _local_17 = 0;
            var _local_18:com.sulake.core.utils.xml.XML = null;
            var _local_19:TrackingEvent = null;
            var _local_20:com.sulake.core.utils.xml.XMLList = null;
            var _local_2= new Array<ASAny>();
            if (k.length() > 0)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    _local_4 = new LinearVideoAd();
                    _local_5 = null;
                    _local_4.index = k.length();
                    if (Timestamp.validate(ASCompat.xmlListToString(_local_3.child("Duration"))))
                    {
                        _local_4.duration = ASCompat.xmlListToString(_local_3.child("Duration"));
                    }
                    else
                    {
                        _local_4.duration = Timestamp._Str_16820(ASCompat.xmlListToString(_local_3.child("Duration")));
                    }
                    if (_local_3.child("AdParameters" )!= /*undefined*/null)
                    {
                        _local_5 = ASCompat.xmlListToString(_local_3.child("AdParameters"));
                    }
                    else
                    {
                        _local_5 = null;
                    }
                    if (_local_3.child("VideoClicks" )!= /*undefined*/null)
                    {
                        if (_local_3.child("VideoClicks").child("ClickThrough" )!= /*undefined*/null)
                        {
                            final _iter_ = _local_3.child("VideoClicks").child("ClickThrough"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_7  = _tmp_;
                                if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_7.text())))
                                {
                                    _local_4._Str_7230(new NetworkResource(_local_7.attribute("id").toString(), ASCompat.xmlListToString(_local_7.text())));
                                }
                            }
                        }
                        if (_local_3.child("VideoClicks").child("ClickTracking" )!= /*undefined*/null)
                        {
                            final _iter_ = _local_3.child("VideoClicks").child("ClickTracking"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_8  = _tmp_;
                                if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_8.text())))
                                {
                                    _local_4._Str_10053(new NetworkResource(_local_8.attribute("id").toString(), ASCompat.xmlListToString(_local_8.text())));
                                }
                            }
                        }
                        if (_local_3.child("VideoClicks").child("CustomClick" )!= /*undefined*/null)
                        {
                            final _iter_ = _local_3.child("VideoClicks").child("CustomClick"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                            {
_local_9  = _tmp_;
                                if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_9.text())))
                                {
                                    _local_4._Str_10085(new NetworkResource(_local_9.attribute("id").toString(), ASCompat.xmlListToString(_local_9.text())));
                                }
                            }
                        }
                    }
                    if (_local_3.child("MediaFiles" )!= /*undefined*/null)
                    {
                        _local_10 = _local_3.child("MediaFiles").children();
                        _local_12 = 0;
                        while (_local_12 < _local_10.length())
                        {
                            _local_11 = null;
                            _local_13 = _local_10.at(_local_12);
                            if (StringUtils.isEmpty(ASCompat.xmlListToString(_local_13.text())) == false)
                            {
                                if (_Str_12713(_local_13.attribute("type").toString()))
                                {
                                    if (StringUtils._Str_2576(_local_13.attribute("apiFramework").toString(), "VPAID"))
                                    {
                                        if (_local_13.attribute("type") != /*undefined*/null)
                                        {
                                            _local_14 = _local_13.attribute("type").toString();
                                            if ((StringUtils._Str_2576(_local_14, "APPLICATION/X-SHOCKWAVE-FLASH") || StringUtils._Str_2576(_local_14, "SWF")))
                                            {
                                                _local_11 = new VPAIDMediaFile();
                                            }
                                        }
                                        else
                                        {
                                            _local_15 = new NetworkResource(_local_13.attribute("id").toString(), ASCompat.xmlListToString(_local_13.text()));
                                            if (!_local_15.isStream())
                                            {
                                                _local_11 = new VPAIDMediaFile();
                                            }
                                        }
                                    }
                                    if (_local_11 == null)
                                    {
                                        _local_11 = new MediaFile();
                                    }
                                    _local_11.id = _local_13.attribute("id").toString();
                                    _local_11.bandwidth = _local_13.attribute("bandwidth").toString();
                                    _local_11.delivery = _local_13.attribute("delivery").toString();
                                    _local_11.mimeType = _local_13.attribute("type").toString();
                                    _local_11.bitRate = ASCompat.toInt(ASCompat.xmlListToString(_local_13.attribute("bitrate")));
                                    _local_11.width = _local_13.attribute("width").toString();
                                    _local_11.height = _local_13.attribute("height").toString();
                                    _local_11.scale = _local_13.attribute("scalable");
                                    _local_11.maintainAspectRatio = _local_13.attribute("maintainAspectRatio");
                                    _local_11.apiFramework = _local_13.attribute("apiFramework").toString();
                                    if (_local_5 != null)
                                    {
                                        _local_11.adParameters = _local_5;
                                    }
                                    _local_11.url = new AdNetworkResource(_local_13.attribute("id").toString(), ASCompat.xmlListToString(_local_13.text()), _local_13.attribute("type").toString());
                                    _local_11._Str_19024 = _local_4;
                                    _local_4._Str_19374(_local_11);
                                }
                            }
                            _local_12++;
                        }
                    }
                    if (((!(_local_3.child("TrackingEvents" )== /*undefined*/null)) && (!(_local_3.child("TrackingEvents").children() == null))))
                    {
                        _local_16 = _local_3.child("TrackingEvents").children();
                        _local_17 = 0;
                        while (_local_17 < _local_16.length())
                        {
                            _local_18 = _local_16.at(_local_17);
                            _local_19 = new TrackingEvent(_local_18.attribute("event").toString());
                            _local_20 = _local_18.children();
                            _local_19._Str_9951(new NetworkResource(_local_16.at(_local_17).attribute("event").toString(), ASCompat.xmlListToString(_local_16.at(_local_17).text())));
                            _local_4._Str_10620(_local_19);
                            _local_17++;
                        }
                    }
                    _local_2.push(_local_4);
                }
            }
            return _local_2;
        }

        function _Str_25355(k:com.sulake.core.utils.xml.XMLList):Array<ASAny>
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:com.sulake.core.utils.xml.XMLList = null;
            var _local_5 = 0;
            var _local_6:Array<ASAny> = null;
            var _local_7:String = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:NonLinearVideoAd = null;
            var _local_10:String = null;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12:com.sulake.core.utils.xml.XMLList = null;
            var _local_13 = 0;
            var _local_14:com.sulake.core.utils.xml.XML = null;
            var _local_15:TrackingEvent = null;
            var _local_16:com.sulake.core.utils.xml.XMLList = null;
            var _local_17:NonLinearVideoAd = null;
            var _local_2= new Array<ASAny>();
            if (k.length() > 0)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    _local_4 = _local_3.children();
                    _local_5 = 0;
                    _local_6 = null;
                    _local_7 = null;
                    _local_5 = 0;
                    while (_local_5 < _local_4.length())
                    {
                        if (_local_4.at(_local_5).name() == "NonLinear")
                        {
                            _local_8 = _local_4.at(_local_5);
                            _local_9 = null;
                            _local_10 = ((_local_8.attribute("id") != /*undefined*/null) ? _local_8.attribute("id") .toString(): ("" + Std.string(_local_5)));
                            if (((!(_local_8.child("StaticResource" )== /*undefined*/null)) && (!(_local_8.child("StaticResource" )== null))))
                            {
                                if (((!(_local_8.child("StaticResource").attribute("creativeType") == /*undefined*/null)) && (!(_local_8.child("StaticResource").attribute("creativeType") == null))))
                                {
                                    switch (ASCompat.toString(_local_8.child("StaticResource").attribute("creativeType")).toUpperCase())
                                    {
                                        case "IMAGE/JPEG"
                                           | "JPEG"
                                           | "IMAGE/GIF"
                                           | "GIF"
                                           | "IMAGE/PNG"
                                           | "PNG":
                                            _local_9 = new _Str_5606();
                                            
                                        case "APPLICATION/X-SHOCKWAVE-FLASH"
                                           | "SWF":
                                            if (StringUtils._Str_2576(_local_8.attribute("apiFramework").toString(), "VPAID"))
                                            {
                                                _local_9 = new VPAIDNonLinearAd();
                                            }
                                            else
                                            {
                                                _local_9 = new _Str_4713();
                                            }
                                            
                                        case "SCRIPT"
                                           | "JAVASCRIPT"
                                           | "TEXT/JAVASCRIPT"
                                           | "TEXT/SCRIPT":
                                            _local_9 = new _Str_4867();
                                            
                                        default:
                                            _local_9 = new NonLinearVideoAd();
                                    }
                                    _local_9.resourceType = "static";
                                    _local_9.creativeType = _local_8.child("StaticResource").attribute("creativeType").toString();
                                }
                                else
                                {
                                    _local_9 = new NonLinearVideoAd();
                                }
                            }
                            else
                            {
                                if (((!(_local_8.child("HTMLResource" )== /*undefined*/null)) && (!(_local_8.child("HTMLResource" )== null))))
                                {
                                    if (StringUtils._Str_4861(ASCompat.xmlListToString(_local_8.child("HTMLResource").text()), "<script "))
                                    {
                                        _local_9 = new _Str_4867();
                                    }
                                    else
                                    {
                                        _local_9 = new _Str_6389();
                                        _local_9.resourceType = "static";
                                        _local_9.creativeType = "html";
                                    }
                                }
                                else
                                {
                                    if (_local_8.child("IFrameResource" )!= /*undefined*/null)
                                    {
                                        _local_9 = new _Str_6437();
                                        _local_9.resourceType = "iframe";
                                        _local_9.creativeType = "html";
                                    }
                                    else
                                    {
                                        _local_9 = new NonLinearVideoAd();
                                    }
                                }
                            }
                            _local_9.index = _local_5;
                            _local_9.id = _local_10;
                            _local_9.width = _local_8.attribute("width");
                            _local_9.height = _local_8.attribute("height");
                            _local_9.apiFramework = _local_8.attribute("apiFramework").toString();
                            if (_local_8.attribute("expandedWidth") != /*undefined*/null)
                            {
                                _local_9.expandedWidth = _local_8.attribute("expandedWidth");
                            }
                            if (_local_8.attribute("expandedHeight") != /*undefined*/null)
                            {
                                _local_9.expandedHeight = _local_8.attribute("expandedHeight");
                            }
                            _local_9.scale = _local_8.attribute("scalable");
                            _local_9.maintainAspectRatio = _local_8.attribute("maintainAspectRatio");
                            if (_local_8.child("AdParameters" )!= /*undefined*/null)
                            {
                                _local_9.adParameters = ASCompat.xmlListToString(_local_8.child("AdParameters"));
                            }
                            if (_local_8.attribute("minSuggestedDuration") != /*undefined*/null)
                            {
                                if (Timestamp.validate(_local_8.attribute("minSuggestedDuration").toString()))
                                {
                                    _local_9.recommendedMinDuration = Timestamp.timestampToSeconds(_local_8.attribute("minSuggestedDuration").toString());
                                }
                                else
                                {
                                    _local_9.recommendedMinDuration = ASCompat.toInt(_local_8.attribute("minSuggestedDuration"));
                                }
                            }
                            if (Std.is(_local_9 , _Str_6437))
                            {
                                if (_local_8.child("IFrameResource" )!= /*undefined*/null)
                                {
                                    _local_9.url = new NetworkResource(null, ASCompat.xmlListToString(_local_8.child("IFrameResource").text()));
                                }
                            }
                            if (Std.is(_local_9 , _Str_6389))
                            {
                                if (_local_8.child("HTMLResource" )!= /*undefined*/null)
                                {
                                    _local_9.codeBlock = ASCompat.xmlListToString(_local_8.child("HTMLResource").text());
                                }
                            }
                            if (Std.is(_local_9 , _Str_4867))
                            {
                                if (_local_8.child("HTMLResource" )!= /*undefined*/null)
                                {
                                    _local_9.codeBlock = ASCompat.xmlListToString(_local_8.child("HTMLResource").text());
                                }
                                else
                                {
                                    if (_local_8.child("StaticResource" )!= /*undefined*/null)
                                    {
                                        _local_9.url = new NetworkResource(null, ASCompat.xmlListToString(_local_8.child("StaticResource").text()));
                                    }
                                }
                            }
                            else
                            {
                                if (_local_8.child("StaticResource" )!= /*undefined*/null)
                                {
                                    _local_9.url = new NetworkResource(null, ASCompat.xmlListToString(_local_8.child("StaticResource").text()));
                                }
                            }
                            if (_local_8.child("NonLinearClickThrough" )!= /*undefined*/null)
                            {
                                final _iter_ = _local_8.child("NonLinearClickThrough"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                                {
_local_11  = _tmp_;
                                    if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_11.text())))
                                    {
                                        _local_9._Str_7230(new NetworkResource(null, ASCompat.xmlListToString(_local_11.text())));
                                    }
                                }
                            }
                            _local_2.push(_local_9);
                        }
                        else
                        {
                            if (_local_4.at(_local_5).name() == "TrackingEvents")
                            {
                                _local_12 = _local_4.at(_local_5).children();
                                _local_6 = new Array<ASAny>();
                                _local_13 = 0;
                                while (_local_13 < _local_12.length())
                                {
                                    _local_14 = _local_12.at(_local_13);
                                    _local_15 = new TrackingEvent(_local_14.attribute("event").toString());
                                    _local_16 = _local_14.children();
                                    _local_15._Str_9951(new NetworkResource(_local_12.at(_local_13).attribute("event").toString(), ASCompat.xmlListToString(_local_12.at(_local_13).text())));
                                    _local_6.push(_local_15);
                                    _local_13++;
                                }
                            }
                            else
                            {
                                if (_local_4.at(_local_5).name() == "AdParameters")
                                {
                                    _local_7 = ASCompat.xmlToString(_local_4.at(_local_5));
                                }
                            }
                        }
                        _local_5++;
                    }
                    if (((!(_local_6 == null)) || (!(_local_7 == null))))
                    {
                        if (_local_6 != null)
                        {
                        }
                        if (_local_7 != null)
                        {
                        }
                        if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                        {
_local_17  = _tmp_;
                            if (_local_6 != null)
                            {
                                _local_17.trackingEvents = this.clone(_local_6);
                            }
                            if (_local_7 != null)
                            {
                                _local_17.adParameters = _local_7;
                            }
                        }
                    }
                }
            }
            return _local_2;
        }

        function _Str_25848(k:com.sulake.core.utils.xml.XMLList):Array<ASAny>
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_4:CompanionAd = null;
            var _local_5:com.sulake.core.utils.xml.XMLList = null;
            var _local_6:com.sulake.core.utils.xml.XML = null;
            var _local_7 = 0;
            var _local_8:com.sulake.core.utils.xml.XMLList = null;
            var _local_9 = 0;
            var _local_10:com.sulake.core.utils.xml.XML = null;
            var _local_11:TrackingEvent = null;
            var _local_12:com.sulake.core.utils.xml.XMLList = null;
            var _local_2= new Array<ASAny>();
            if (k.length() > 0)
            {
                final _iter_ = k.children(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_4 = new CompanionAd();
                    _local_4.isVAST2 = true;
                    _local_4.id = _local_3.attribute("id").toString();
                    _local_4.width = _local_3.attribute("width");
                    _local_4.height = _local_3.attribute("height");
                    _local_4.index = this._Str_17110(ASCompat.toInt(_local_4.width), ASCompat.toInt(_local_4.height));
                    if (_local_3.child("StaticResource" )!= /*undefined*/null)
                    {
                        _local_4.creativeType = _local_3.child("StaticResource").attribute("creativeType").toString();
                        _local_4.resourceType = "STATIC";
                        _local_4.url = new NetworkResource(null, ASCompat.xmlListToString(_local_3.child("StaticResource").text()));
                    }
                    else
                    {
                        if (_local_3.child("IFrameResource" )!= /*undefined*/null)
                        {
                            _local_4.creativeType = "STATIC";
                            _local_4.resourceType = "IFRAME";
                            _local_4.url = new NetworkResource(null, ASCompat.xmlListToString(_local_3.child("IFrameResource").text()));
                        }
                        else
                        {
                            if (_local_3.child("HTMLResource" )!= /*undefined*/null)
                            {
                                _local_4.creativeType = "TEXT";
                                _local_4.resourceType = "HTML";
                                _local_4.codeBlock = ASCompat.xmlListToString(_local_3.child("HTMLResource").text());
                            }
                        }
                    }
                    if (_local_3.child("CompanionClickThrough" )!= /*undefined*/null)
                    {
                        _local_5 = _local_3.child("CompanionClickThrough");
                        _local_7 = 0;
                        while (_local_7 < _local_5.length())
                        {
                            _local_6 = _local_5.at(_local_7);
                            _local_4._Str_7230(new NetworkResource(_local_6.attribute("id").toString(), ASCompat.xmlListToString(_local_6.text())));
                            _local_7++;
                        }
                    }
                    if (_local_3.child("AltText" )!= /*undefined*/null)
                    {
                        _local_4.altText = ASCompat.xmlListToString(_local_3.child("AltText").text());
                    }
                    if (_local_3.child("AdParameters" )!= /*undefined*/null)
                    {
                        _local_4.adParameters = ASCompat.xmlListToString(_local_3.child("AdParameters").text());
                    }
                    if (_local_3.child("TrackingEvents" )!= /*undefined*/null)
                    {
                        _local_8 = _local_3.child("TrackingEvents").children();
                        _local_9 = 0;
                        while (_local_9 < _local_8.length())
                        {
                            _local_10 = _local_8.at(_local_9);
                            _local_11 = new TrackingEvent(_local_10.attribute("event").toString());
                            _local_12 = _local_10.children();
                            _local_11._Str_9951(new NetworkResource(_local_8.at(_local_9).attribute("event").toString(), ASCompat.xmlListToString(_local_8.at(_local_9).text())));
                            _local_4._Str_10620(_local_11);
                            _local_9++;
                        }
                    }
                    _local_2.push(_local_4);
                }
            }
            return _local_2;
        }

        function clone(k:ASObject):ASAny
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:ASAny = null;
            var _local_4:com.sulake.core.utils.ByteArray = null;
            if (k != null)
            {
                if (Std.is(k , Array))
                {
                    _local_2 = new Array<ASAny>();
                    if (checkNullIteratee(k)) for (_tmp_ in k)
                    {
_local_3  = _tmp_;
                        _local_2.push(_local_3.clone());
                    }
                    return _local_2;
                }
                _local_4 = new com.sulake.core.utils.ByteArray();
                _local_4.writeObject(k);
                _local_4.position = 0;
                return _local_4.readObject();
            }
            return null;
        }

        public function _Str_24138():VideoAd
        {
            if (_Str_2518 != null)
            {
                if (_Str_2518.length > 0)
                {
                    return _Str_2518[0];
                }
            }
            return null;
        }

        public function toString():String
        {
            var k:String = null;
            var _local_2 = 0;
            if (hasAds())
            {
                k = "[";
                _local_2 = 0;
                while (_local_2 < _Str_2518.length)
                {
                    k = (k + (Std.string(_Str_2518[_local_2]) + ","));
                    _local_2++;
                }
                return k + "]";
            }
            return "VideoAdServingTemplate.toString(): No ads to print out";
        }
    }

