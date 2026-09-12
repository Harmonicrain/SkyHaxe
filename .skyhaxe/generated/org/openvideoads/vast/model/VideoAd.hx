package org.openvideoads.vast.model
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.vast.server.config.AdServerConfig;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.regions.view._Str_4027;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.events._Str_3019;
    import org.openvideoads.util.ArrayUtils;

     class VideoAd extends Debuggable 
    {
        public static inline final LINEAR= "linear";
        public static inline final _Str_6723= "non-linear";
        public static inline final COMPANION= "companion";
        public static inline final UNKNOWN= "unknown";
        public static inline final _Str_16569= "linear-vpaid";
        public static inline final _Str_16642= "non-linear-vpaid";

        var _id:String;
        var _Str_9985:String = null;
        var _Str_7451:String = null;
        var _Str_14340:String;
        var _Str_14487:String;
        var _Str_6606:String;
        var _Str_15105:String;
        var _Str_1858:String;
        var _Str_10070:String;
        var _error:String;
        var _Str_3519:Array<ASAny>;
        var _Str_3053:Array<ASAny>;
        var _Str_2815:LinearVideoAd = null;
        var _Str_2587:Array<ASAny>;
        var _Str_3336:Array<ASAny>;
        var _Str_10143:Bool = false;
        var _Str_3517:Array<ASAny>;
        var _Str_7809:Array<ASAny>;
        var _Str_17197:WrappedVideoAdV1 = null;
        var _Str_3562:ASObject = null;

        public function new()
        {
            this._Str_3519 = new Array<ASAny>();
            this._Str_3053 = new Array<ASAny>();
            this._Str_2587 = new Array<ASAny>();
            this._Str_3336 = new Array<ASAny>();
            this._Str_3517 = new Array<ASAny>();
            this._Str_7809 = new Array<ASAny>();
            super();
        }

        public function unload()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            if (this.hasAds())
            {
                if (this.hasLinearAd())
                {
                    this._Str_2815.unload();
                }
                if (this.hasNonLinearAds())
                {
                    k = 0;
                    while (k < this._Str_2587.length)
                    {
                        this._Str_2587[k].unload();
                        k++;
                    }
                }
            }
            if (this._Str_16075())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3519.length)
                {
                    this._Str_3519[_local_2].unload();
                    _local_2++;
                }
            }
            if (this.hasTrackingEvents())
            {
                _local_3 = 0;
                while (_local_3 < this._Str_3053.length)
                {
                    this._Str_3053[_local_3].unload();
                    _local_3++;
                }
            }
            if (this.hasCompanionAds())
            {
                _local_4 = 0;
                while (_local_4 < this._Str_3336.length)
                {
                    this._Str_3336[_local_4].unload();
                    _local_4++;
                }
            }
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        public function setPreferredSelectionCriteria(k:ASObject)
        {
            this._Str_3562 = k;
        }

        public function _Str_13087():Bool
        {
            return !(this._Str_3562 == null);
        }

        public function _Str_15642():ASAny
        {
            if (this._Str_3562 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_3562, "bitrate"))
                {
                    return this._Str_3562.bitrate;
                }
            }
            return -1;
        }

        public function _Str_14891():ASAny
        {
            if (this._Str_3562 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_3562, "mimeType"))
                {
                    return this._Str_3562.mimeType;
                }
            }
            return "any";
        }

        public function _Str_13161():String
        {
            if (this._Str_3562 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_3562, "deliveryType"))
                {
                    return this._Str_3562.deliveryType;
                }
            }
            return "any";
        }

        public function _Str_14847():ASAny
        {
            if (this._Str_3562 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_3562, "width"))
                {
                    return this._Str_3562.width;
                }
            }
            return -1;
        }

        public function _Str_14760():ASAny
        {
            if (this._Str_3562 != null)
            {
                if (ASCompat.hasOwnProperty(this._Str_3562, "height"))
                {
                    return this._Str_3562.height;
                }
            }
            return -1;
        }

        public function hasAds(k:Bool=false):Bool
        {
            if (k)
            {
                return (this.hasLinearAd() || this.hasNonLinearAds()) || this._Str_16075();
            }
            return (this._Str_15398() == false) || (this.hasNonLinearAds() && (this._Str_13487() == false));
        }

        public function _Str_23787():Bool
        {
            return this.hasLinearAd() && this.hasNonLinearAds();
        }

        public function _Str_25585(k:String):Bool
        {
            return StringUtils._Str_2576(this._Str_6606, "OPENX");
        }

        public function filterLinearAdMediaFileByMimeType(k:Array<ASAny>)
        {
            if (this._Str_2815 != null)
            {
                this._Str_2815.filterLinearAdMediaFileByMimeType(k);
            }
        }

        function _Str_12713(k:String, _arg_2:AdServerConfig):Bool
        {
            if (_arg_2 != null)
            {
                return _arg_2.isAcceptedLinearAdMimeType(k);
            }
            return true;
        }

        public function hasWrapper():Bool
        {
            return !(this._Str_17197 == null);
        }

        
        public var wrapper(get,set):WrappedVideoAdV1;
public function  set_wrapper(k:WrappedVideoAdV1):WrappedVideoAdV1        {
            return this._Str_17197 = k;
        }
public function  get_wrapper():WrappedVideoAdV1
        {
            return this._Str_17197;
        }

        public function _Str_26388(k:Bool)
        {
        }

        public function canFireAPICalls():Bool
        {
            return false;
        }

        public function _Str_26436(k:Bool)
        {
        }

        public function canFireEventAPICalls():Bool
        {
            return false;
        }

        
        public var useV2APICalls(get,set):Bool;
public function  set_useV2APICalls(k:Bool):Bool        {
return k;
        }
public function  get_useV2APICalls():Bool
        {
            return false;
        }

        
        public var jsCallbackScopingPrefix(get,set):String;
public function  set_jsCallbackScopingPrefix(k:String):String        {
return k;
        }
public function  get_jsCallbackScopingPrefix():String
        {
            return "";
        }

        function _Str_24949()
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

        public function injectAllTrackingData(k:VideoAd):VideoAd
        {
            return k;
        }

        public function _Str_16323(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XMLList = null;
            var _local_3 = 0;
            if (((!(k.child("Impression" )== null)) && (!(k.child("Impression").children() == null))))
            {
                _local_2 = k.child("Impression").children();
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    this._Str_22638(new Impression(_local_2.at(_local_3).attribute("id").toString(), ASCompat.xmlToString(_local_2.at(_local_3))));
                    _local_3++;
                }
            }
        }

        public function _Str_18315(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XMLList = null;
            var _local_3 = 0;
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:TrackingEvent = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7 = 0;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            if (((!(k.child("TrackingEvents" )== null)) && (!(k.child("TrackingEvents").children() == null))))
            {
                _local_2 = k.child("TrackingEvents").children();
                _local_3 = 0;
                while (_local_3 < _local_2.length())
                {
                    _local_4 = _local_2.at(_local_3);
                    _local_5 = new TrackingEvent(_local_4.attribute("event").toString());
                    _local_6 = _local_4.children();
                    _local_7 = 0;
                    while (_local_7 < _local_6.length())
                    {
                        _local_8 = _local_6.at(_local_7);
                        _local_5._Str_9951(new NetworkResource(_local_8.attribute("id").toString(), ASCompat.xmlListToString(_local_8.text())));
                        _local_7++;
                    }
                    this._Str_10620(_local_5);
                    _local_3++;
                }
            }
        }

        public function _Str_24028(k:com.sulake.core.utils.xml.XML, _arg_2:Int=-1, _arg_3:AdServerConfig=null)
        {
            var _local_8:com.sulake.core.utils.xml.XMLList = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10 = 0;
            var _local_11:com.sulake.core.utils.xml.XMLList = null;
            var _local_12:com.sulake.core.utils.xml.XML = null;
            var _local_13:MediaFile = null;
            var _local_14:com.sulake.core.utils.xml.XML = null;
            var _local_4= new LinearVideoAd();
            var _local_5= "";
            var _local_6= "";
            _local_4._Str_18431 = ASCompat.xmlListToString(k.child("Video").child("AdID"));
            _local_4.index = _arg_2;
            var _local_7:String = null;
            if (k.child("Video").child("VideoLength" )!= /*undefined*/null)
            {
                _local_7 = ASCompat.xmlListToString(k.child("Video").child("VideoLength"));
            }
            else
            {
                if (k.child("Video").child("Duration" )!= /*undefined*/null)
                {
                    _local_7 = ASCompat.xmlListToString(k.child("Video").child("Duration"));
                }
            }
            if (_local_7 != null)
            {
                if (Timestamp.validate(_local_7))
                {
                    _local_4.duration = _local_7;
                }
                else
                {
                    _local_4.duration = Timestamp._Str_16820(_local_7);
                }
            }
            if (k.child("Video").child("AdParameters" )!= /*undefined*/null)
            {
                if (!StringUtils.isEmpty(k.child("Video").child("AdParameters").attribute("apiFramework").toString()))
                {
                    _local_5 = k.child("Video").child("AdParameters").attribute("apiFramework").toString();
                    _local_6 = ASCompat.xmlListToString(k.child("Video").child("AdParameters").text());
                }
            }
            if (k.child("Video").child("VideoClicks" )!= /*undefined*/null)
            {
                _local_10 = 0;
                if (k.child("Video").child("VideoClicks").child("ClickThrough").children().length() > 0)
                {
                    _local_8 = k.child("Video").child("VideoClicks").child("ClickThrough").children();
                    _local_10 = 0;
                    while (_local_10 < _local_8.length())
                    {
                        _local_9 = _local_8.at(_local_10);
                        if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_9.text())))
                        {
                            _local_4._Str_7230(new NetworkResource(_local_9.attribute("id").toString(), ASCompat.xmlListToString(_local_9.text())));
                        }
                        _local_10++;
                    }
                }
                if (k.child("Video").child("VideoClicks").child("ClickTracking").children().length() > 0)
                {
                    _local_8 = k.child("Video").child("VideoClicks").child("ClickTracking").children();
                    _local_10 = 0;
                    while (_local_10 < _local_8.length())
                    {
                        _local_9 = _local_8.at(_local_10);
                        if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_9.text())))
                        {
                            _local_4._Str_10053(new NetworkResource(_local_9.attribute("id").toString(), ASCompat.xmlListToString(_local_9.text())));
                        }
                        _local_10++;
                    }
                }
                if (k.child("Video").child("VideoClicks").child("CustomClick").children().length() > 0)
                {
                    _local_8 = k.child("Video").child("CustomClick").child("ClickTracking").children();
                    _local_10 = 0;
                    while (_local_10 < _local_8.length())
                    {
                        _local_9 = _local_8.at(_local_10);
                        if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_9.text())))
                        {
                            _local_4._Str_10085(new NetworkResource(_local_9.attribute("id").toString(), ASCompat.xmlListToString(_local_9.text())));
                        }
                        _local_10++;
                    }
                }
            }
            if (k.child("Video").child("MediaFiles" )!= /*undefined*/null)
            {
                _local_11 = k.child("Video").child("MediaFiles").children();
                _local_10 = 0;
                while (_local_10 < _local_11.length())
                {
                    _local_12 = _local_11.at(_local_10);
                    if (_local_12.children().length() > 0)
                    {
                        if (this._Str_12713(_local_12.attribute("type").toString(), _arg_3))
                        {
                            _local_13 = (StringUtils._Str_2576(_local_5, "VPAID") ? new VPAIDMediaFile() : new MediaFile());
                            _local_13.id = _local_12.attribute("id").toString();
                            _local_13.bandwidth = _local_12.attribute("bandwidth").toString();
                            _local_13.delivery = _local_12.attribute("delivery").toString();
                            _local_13.mimeType = _local_12.attribute("type").toString();
                            _local_13.bitRate = ASCompat.toInt(ASCompat.xmlListToString(_local_12.attribute("bitrate")));
                            _local_13.width = _local_12.attribute("width").toString();
                            _local_13.height = _local_12.attribute("height").toString();
                            _local_13.scale = _local_12.attribute("scalable");
                            _local_13.maintainAspectRatio = _local_12.attribute("maintainAspectRatio");
                            _local_13.apiFramework = _local_5;
                            _local_13.adParameters = _local_6;
                            _local_13._Str_19024 = _local_4;
                            _local_14 = _local_12.children().at(0);
                            _local_13.url = new AdNetworkResource(_local_14.attribute("id").toString(), ASCompat.xmlListToString(_local_14.text()), _local_12.attribute("type").toString());
                            _local_4._Str_19374(_local_13);
                        }
                    }
                    _local_10++;
                }
            }
            this.linearVideoAd = _local_4;
        }

        public function _Str_24780(k:com.sulake.core.utils.xml.XML, _arg_2:Int=-1)
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:NonLinearVideoAd = null;
            var _local_7:com.sulake.core.utils.xml.XMLList = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9 = 0;
            var _local_3= k.child("NonLinearAds").children();
            var _local_4 = 0;
            _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                _local_6 = null;
                switch (ASCompat.toString(_local_5.attribute("resourceType")).toUpperCase())
                {
                    case "HTML":
                        _local_6 = new _Str_6389();
                        
                    case "TEXT":
                        _local_6 = new NonLinearTextAd();
                        
                    case "SCRIPT":
                        _local_6 = new _Str_4867();
                        
                    case "IFRAME":
                        _local_6 = new _Str_6437();
                        
                    case "STATIC":
                        if (((!(_local_5.attribute("creativeType") == /*undefined*/null)) && (!(_local_5.attribute("creativeType") == null))))
                        {
                            switch (ASCompat.toString(_local_5.attribute("creativeType")).toUpperCase())
                            {
                                case "IMAGE/JPEG"
                                   | "JPEG"
                                   | "IMAGE/GIF"
                                   | "GIF"
                                   | "IMAGE/PNG"
                                   | "PNG":
                                    _local_6 = new _Str_5606();
                                    
                                case "APPLICATION/X-SHOCKWAVE-FLASH"
                                   | "SWF":
                                    if (StringUtils._Str_2576(_local_5.attribute("apiFramework").toString(), "VPAID"))
                                    {
                                        _local_6 = new VPAIDNonLinearAd();
                                    }
                                    else
                                    {
                                        _local_6 = new _Str_4713();
                                    }
                                    
                                case "SCRIPT"
                                   | "JAVASCRIPT"
                                   | "TEXT/JAVASCRIPT"
                                   | "TEXT/SCRIPT":
                                    _local_6 = new _Str_4867();
                                    
                                default:
                                    _local_6 = new NonLinearVideoAd();
                            }
                        }
                        else
                        {
                            _local_6 = new NonLinearVideoAd();
                        }
                        
                    default:
                        _local_6 = new NonLinearVideoAd();
                }
                _local_6.index = _arg_2;
                _local_6.id = _local_5.attribute("id").toString();
                _local_6.width = _local_5.attribute("width");
                _local_6.height = _local_5.attribute("height");
                if (_local_5.attribute("expandedWidth") != /*undefined*/null)
                {
                    _local_6.expandedWidth = _local_5.attribute("expandedWidth");
                }
                if (_local_5.attribute("expandedHeight") != /*undefined*/null)
                {
                    _local_6.expandedHeight = _local_5.attribute("expandedHeight");
                }
                _local_6.resourceType = _local_5.attribute("resourceType").toString();
                _local_6.creativeType = _local_5.attribute("creativeType").toString();
                _local_6.apiFramework = _local_5.attribute("apiFramework").toString();
                _local_6.maintainAspectRatio = _local_5.attribute("maintainAspectRatio");
                _local_6.scale = _local_5.attribute("scalable");
                if (_local_5.child("URL" )!= /*undefined*/null)
                {
                    _local_6.url = new NetworkResource(null, ASCompat.xmlListToString(_local_5.child("URL").text()));
                }
                if (_local_5.child("Code" )!= /*undefined*/null)
                {
                    _local_6.codeBlock = ASCompat.xmlListToString(_local_5.child("Code").text());
                }
                if (_local_5.child("NonLinearClickThrough" )!= /*undefined*/null)
                {
                    _local_7 = _local_5.child("NonLinearClickThrough").children();
                    _local_9 = 0;
                    while (_local_9 < _local_7.length())
                    {
                        _local_8 = _local_7.at(_local_9);
                        _local_6._Str_7230(new NetworkResource(_local_8.attribute("id").toString(), ASCompat.xmlListToString(_local_8.text())));
                        _local_9++;
                    }
                }
                this._Str_19277(_local_6);
                _local_4++;
            }
        }

        public function _Str_24076(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:CompanionAd = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8 = 0;
            var _local_2= k.child("CompanionAds").children();
            var _local_3 = 0;
            this._Str_24949();
            _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                _local_5 = new CompanionAd(this);
                _local_5.id = _local_4.attribute("id").toString();
                _local_5.width = _local_4.attribute("width");
                _local_5.height = _local_4.attribute("height");
                _local_5.index = this._Str_17110(ASCompat.toInt(_local_5.width), ASCompat.toInt(_local_5.height));
                if (_local_4.attribute("resourceType") != /*undefined*/null)
                {
                    _local_5.resourceType = _local_4.attribute("resourceType").toString();
                }
                else
                {
                    _local_5.resourceType = "static";
                }
                if (_local_4.attribute("creativeType") != /*undefined*/null)
                {
                    _local_5.creativeType = _local_4.attribute("creativeType").toString();
                }
                if (_local_4.child("URL" )!= /*undefined*/null)
                {
                    _local_5.url = new NetworkResource(null, ASCompat.xmlListToString(_local_4.child("URL").text()));
                }
                if (_local_4.child("Code" )!= /*undefined*/null)
                {
                    _local_5.codeBlock = ASCompat.xmlListToString(_local_4.child("Code").text());
                }
                if (_local_4.child("AltText" )!= /*undefined*/null)
                {
                    _local_5.altText = ASCompat.xmlListToString(_local_4.child("AltText").text());
                }
                if (_local_4.child("AdParameters" )!= /*undefined*/null)
                {
                    _local_5.adParameters = ASCompat.xmlListToString(_local_4.child("AdParameters").text());
                }
                if (_local_4.child("CompanionClickThrough" )!= /*undefined*/null)
                {
                    _local_6 = _local_4.child("CompanionClickThrough");
                    _local_8 = 0;
                    while (_local_8 < _local_6.length())
                    {
                        _local_7 = _local_6.at(_local_8);
                        if (_local_7.child("URL" )!= /*undefined*/null)
                        {
                            _local_5._Str_7230(new NetworkResource(_local_7.attribute("id").toString(), ASCompat.xmlListToString(_local_7.child("URL").text())));
                        }
                        _local_8++;
                    }
                }
                this._Str_24117(_local_5);
                _local_3++;
            }
        }

        public function _Str_25118(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:com.sulake.core.utils.xml.XML = null;
            var _local_5:com.sulake.core.utils.xml.XMLList = null;
            var _local_6:Array<ASAny> = null;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_2= k.child("Extensions").children();
            var _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                if (com.sulake.core.utils.xml.XML.equalsStringOperands(_local_4.attribute("type") , "NonLinearClickTracking"))
                {
                    if (_local_4.child("ClickTracking" )!= /*undefined*/null)
                    {
                        _local_5 = _local_4.child("ClickTracking").children();
                        _local_6 = new Array<ASAny>();
                        _local_7 = 0;
                        while (_local_7 < _local_5.length())
                        {
                            if (!StringUtils.isEmpty(ASCompat.xmlListToString(_local_5.at(_local_7).text())))
                            {
                                _local_6.push(new NetworkResource(_local_5.at(_local_7).attribute("id").toString(), ASCompat.xmlListToString(_local_5.at(_local_7).text())));
                            }
                            _local_7++;
                        }
                        _local_8 = 0;
                        while (_local_8 < this._Str_2587.length)
                        {
                            cast(this._Str_2587[_local_8], NonLinearVideoAd)._Str_21348(_local_6);
                            _local_8++;
                        }
                    }
                }
                _local_3++;
            }
        }

        public function addClickTrackingItems(k:Array<ASAny>)
        {
            if (this._Str_2815 != null)
            {
                this._Str_2815.addClickTrackingItems(k);
            }
        }

        public function addCustomClickTrackingItems(k:Array<ASAny>)
        {
            if (this._Str_2815 != null)
            {
                this._Str_2815.addCustomClickTrackingItems(k);
            }
        }

        
        public var adId(get,set):String;
public function  set_adId(k:String):String        {
            return this._Str_7451 = k;
        }
public function  get_adId():String
        {
            return this._Str_7451;
        }

        
        public var inlineAdId(get,set):String;
public function  set_inlineAdId(k:String):String        {
            return this._Str_9985 = k;
        }
public function  get_inlineAdId():String
        {
            return this._Str_9985;
        }

        public function _Str_19109(k:String):Bool
        {
            return this._Str_9985 == k;
        }

        
        public var creativeId(get,set):String;
public function  set_creativeId(k:String):String        {
            return this._Str_14487 = k;
        }
public function  get_creativeId():String
        {
            return this._Str_14487;
        }

        
        public var sequenceId(get,set):String;
public function  set_sequenceId(k:String):String        {
            return this._Str_14340 = k;
        }
public function  get_sequenceId():String
        {
            return this._Str_14340;
        }

        
        public var adSystem(get,set):String;
public function  set_adSystem(k:String):String        {
            return this._Str_6606 = k;
        }
public function  get_adSystem():String
        {
            return this._Str_6606;
        }

        public var duration(get,never):Int;
public function  get_duration():Int
        {
            if (this._Str_2815 != null)
            {
                return Timestamp.timestampToSeconds(this._Str_2815.duration);
            }
            if (this.hasNonLinearAds())
            {
                if (this._Str_2587[0].hasRecommendedMinDuration())
                {
                    return ASCompat.toInt(this._Str_2587[0].recommendedMinDuration);
                }
            }
            return 0;
        }

        public function _Str_25515(k:Int):Int
        {
            var _local_2= this.duration;
            if (((_local_2 == 0) && (k > 0)))
            {
                return k;
            }
            return _local_2;
        }

        
        public var adTitle(get,set):String;
public function  set_adTitle(k:String):String        {
            return this._Str_15105 = k;
        }
public function  get_adTitle():String
        {
            return this._Str_15105;
        }

        
        public var description(get,set):String;
public function  set_description(k:String):String        {
            return this._Str_1858 = k;
        }
public function  get_description():String
        {
            return this._Str_1858;
        }

        public function _Str_20690():Bool
        {
            return !(this._Str_10070 == null);
        }

        
        public var survey(get,set):String;
public function  set_survey(k:String):String        {
            return this._Str_10070 = k;
        }
public function  get_survey():String
        {
            return this._Str_10070;
        }

        public function _Str_25033():Bool
        {
            return !(this._error == null);
        }

        
        public var error(get,set):String;
public function  set_error(k:String):String        {
            return this._error = k;
        }
public function  get_error():String
        {
            return this._error;
        }

        public function _Str_23092():NetworkResource
        {
            return new NetworkResource("error", this.error);
        }

        
        public var impressions(get,set):Array<ASAny>;
public function  set_impressions(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3519 = k;
        }
public function  get_impressions():Array<ASAny>
        {
            return this._Str_3519;
        }

        public var _Str_26057(get,never):Array<ASAny>;
public function  get__Str_26057():Array<ASAny>
        {
            return this._Str_3519;
        }

        public function _Str_22638(k:NetworkResource)
        {
            this._Str_3519.push(k);
        }

        public function addImpressions(k:Array<ASAny>)
        {
            this._Str_3519 = this._Str_3519.concat(k);
        }

        public function _Str_16075():Bool
        {
            return this._Str_3519.length > 0;
        }

        public function getImpressionList():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this._Str_16075())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3519.length)
                {
                    k.push(cast(this._Str_3519[_local_2], NetworkResource).url);
                    _local_2++;
                }
            }
            return k;
        }

        public function _Str_26162():Bool
        {
            return this._Str_7809.length > 0;
        }

        
        public var extensions(get,set):Array<ASAny>;
public function  set_extensions(k:Array<ASAny>):Array<ASAny>        {
            if (k != null)
            {
                this._Str_7809 = k;
            }
            else
            {
                this._Str_7809 = new Array<ASAny>();
            }
return k;
        }
public function  get_extensions():Array<ASAny>
        {
            return this._Str_7809;
        }

        public function setLinearAdDurationFromSeconds(k:Int)
        {
            if (this._Str_2815 != null)
            {
                this._Str_2815._Str_24711(k);
            }
        }

        
        public var trackingEvents(get,set):Array<ASAny>;
public function  set_trackingEvents(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3053 = k;
        }
public function  get_trackingEvents():Array<ASAny>
        {
            return this._Str_3053;
        }

        public function _Str_10620(k:TrackingEvent)
        {
            this._Str_3053.push(k);
        }

        public function addTrackingEventItems(k:Array<ASAny>)
        {
            this._Str_3053 = this._Str_3053.concat(k);
        }

        public function hasTrackingEvents():Bool
        {
            return this._Str_3053.length > 0;
        }

        public function _Str_18876():Bool
        {
            if (this.hasLinearAd())
            {
                return this._Str_2815._Str_18876();
            }
            return false;
        }

        
        public var linearVideoAd(get,set):LinearVideoAd;
public function  set_linearVideoAd(k:LinearVideoAd):LinearVideoAd        {
            k.parentAdContainer = this;
            return this._Str_2815 = k;
        }
public function  get_linearVideoAd():LinearVideoAd
        {
            return this._Str_2815;
        }

        
        public var nonLinearVideoAds(get,set):Array<ASAny>;
public function  set_nonLinearVideoAds(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:NonLinearVideoAd = null;
            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_2  = _tmp_;
                    this._Str_19277(_local_2);
                }
            }
            return this._Str_2587 = k;
        }
public function  get_nonLinearVideoAds():Array<ASAny>
        {
            return this._Str_2587;
        }

        public var firstNonLinearVideoAd(get,never):NonLinearVideoAd;
public function  get_firstNonLinearVideoAd():NonLinearVideoAd
        {
            if (this.hasNonLinearAds())
            {
                return this._Str_2587[0];
            }
            return null;
        }

        public function _Str_19277(k:NonLinearVideoAd)
        {
            k.parentAdContainer = this;
            this._Str_2587.push(k);
        }

        public function hasNonLinearAds():Bool
        {
            return this._Str_2587.length > 0;
        }

        public function hasLinearAd():Bool
        {
            if (this._Str_2815 != null)
            {
                return this._Str_2815.isEmpty() == false;
            }
            return false;
        }

        public function _Str_15398():Bool
        {
            if (this.linearVideoAd != null)
            {
                return this.linearVideoAd.isEmpty();
            }
            return true;
        }

        public function _Str_13487():Bool
        {
            var k = false;
            var _local_2 = 0;
            if (this.hasNonLinearAds())
            {
                k = true;
                _local_2 = 0;
                while (_local_2 < this._Str_2587.length)
                {
                    if (this._Str_2587[_local_2].isEmpty() == false)
                    {
                        k = false;
                    }
                    _local_2++;
                }
                return k;
            }
            return false;
        }

        
        public var companionAds(get,set):Array<ASAny>;
public function  set_companionAds(k:Array<ASAny>):Array<ASAny>        {
            return this._Str_3336 = k;
        }
public function  get_companionAds():Array<ASAny>
        {
            return this._Str_3336;
        }

        public function _Str_24117(k:CompanionAd)
        {
            this._Str_3336.push(k);
        }

        public function _Str_21998(k:Array<ASAny>)
        {
            this._Str_3336 = this._Str_3336.concat(k);
        }

        public function hasCompanionAds():Bool
        {
            return this._Str_3336.length > 0;
        }

        public function _Str_25895():Int
        {
            if (this._Str_3336 != null)
            {
                return this._Str_3336.length;
            }
            return 0;
        }

        public function isCompanionOnlyAd():Bool
        {
            if (this.hasCompanionAds())
            {
                return (this.hasLinearAd() == false) && (this.hasNonLinearAds() == false);
            }
            return false;
        }

        public function isEmpty():Bool
        {
            if (this.isLinear())
            {
                return this._Str_15398();
            }
            if (this.isNonLinear())
            {
                return this._Str_13487();
            }
            if (this.isCompanionOnlyAd())
            {
            }
            return true;
        }

        public function isLinear():Bool
        {
            return (!(this._Str_2815 == null)) && (!this.isNonLinear());
        }

        public function isNonLinear():Bool
        {
            return this.hasNonLinearAds();
        }

        public function _Str_9554():Bool
        {
            return ((!this.isLinear()) && (!this.isNonLinear())) && this.hasCompanionAds();
        }

        public function isWrapperTemplateAd():Bool
        {
            return this.isEmpty();
        }

        public var adType(get,never):String;
public function  get_adType():String
        {
            if (this.isLinear())
            {
                if (this.isInteractive())
                {
                    return _Str_16569;
                }
                return LINEAR;
            }
            if (this.isNonLinear())
            {
                if (this.isInteractive())
                {
                    return _Str_16642;
                }
                return _Str_6723;
            }
            if (this._Str_9554())
            {
                return COMPANION;
            }
            return LINEAR;
        }

        public function getFlashMediaToPlay(k:Float, _arg_2:Float, _arg_3:Bool=false):_Str_4027
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            if (this.isLinear())
            {
                return ASCompat.reinterpretAs(this._Str_2815._Str_10510(null, (["APPLICATION/X-SHOCKWAVE-FLASH", "SWF"] : Array<Dynamic>), -1, Std.int(k), Std.int(_arg_2), _arg_3) , _Str_4027);
            }
            if (this.hasNonLinearAds())
            {
                if (this._Str_2587.length == 1)
                {
                    if (Std.is(this._Str_2587[0] , _Str_4713))
                    {
                        return this._Str_2587[0];
                    }
                }
                else
                {
                    _local_4 = -1;
                    _local_5 = -1;
                    _local_6 = -1;
                    _local_7 = 0;
                    while (_local_7 < this._Str_2587.length)
                    {
                        if (Std.is(this._Str_2587[_local_7] , _Str_4713))
                        {
                            if (((this._Str_2587[_local_7].width == k) && (this._Str_2587[_local_7].height == _arg_2)))
                            {
                                return this._Str_2587[_local_7];
                            }
                            _local_6 = Std.int(Math.abs(ASCompat.toNumber(ASCompat.toNumber(this._Str_2587[_local_7].width) - k)) + Math.abs(ASCompat.toNumber(ASCompat.toNumber(this._Str_2587[_local_7].height) - _arg_2)));
                            if (((_local_5 == -1) || (_local_6 < _local_5)))
                            {
                                _local_4 = _local_7;
                                _local_5 = _local_6;
                            }
                        }
                        _local_7++;
                    }
                    if (_local_4 > -1)
                    {
                        return this._Str_2587[_local_4];
                    }
                }
            }
            return null;
        }

        public function getStreamToPlay():AdNetworkResource
        {
            if ((this.isLinear() || (this.isNonLinear() && (!(this._Str_2815 == null)))))
            {
                return this._Str_2815.getStreamToPlay(this._Str_13161(), this._Str_14891(), this._Str_15642(), ASCompat.toInt(this._Str_14847()), ASCompat.toInt(this._Str_14760()), this._Str_13087());
            }
            return null;
        }

        public function canScale():Bool
        {
            if (this._Str_2815 != null)
            {
                return this._Str_2815.canScale(this._Str_13161(), this._Str_14891(), this._Str_15642(), ASCompat.toInt(this._Str_14847()), ASCompat.toInt(this._Str_14760()), this._Str_13087());
            }
            return false;
        }

        public function shouldMaintainAspectRatio():Bool
        {
            if (this._Str_2815 != null)
            {
                return this._Str_2815.shouldMaintainAspectRatio(this._Str_13161(), this._Str_14891(), this._Str_15642(), ASCompat.toInt(this._Str_14847()), ASCompat.toInt(this._Str_14760()), this._Str_13087());
            }
            return false;
        }

        public function isInteractive():Bool
        {
            if (this.isLinear())
            {
                return this._Str_2815.isInteractive(this._Str_13161(), this._Str_14891(), this._Str_15642(), ASCompat.toInt(this._Str_14847()), ASCompat.toInt(this._Str_14760()), this._Str_13087());
            }
            if (this.hasNonLinearAds())
            {
                return cast(this._Str_2587[0], NonLinearVideoAd).isInteractive();
            }
            return false;
        }

        public function _Str_26223(k:Array<ASAny>):Array<ASAny>
        {
            var _local_2:Array<ASAny> = null;
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5 = 0;
            if (((!(k == null)) && this.hasCompanionAds()))
            {
                _local_2 = new Array<ASAny>();
                _local_3 = new Array<ASAny>();
                _local_4 = 0;
                while (_local_4 < k.length)
                {
                    _local_5 = 0;
                    while (_local_5 < this._Str_3336.length)
                    {
                        if (_local_3.indexOf(this._Str_3336[_local_5]) == -1)
                        {
                            if (this._Str_3336[_local_5].suitableForDisplayInDIV(k[_local_4]))
                            {
                                _local_3.push({
                                    "div":k[_local_4],
                                    "companion":this._Str_3336[_local_5]
                                });
                            }
                        }
                        _local_5++;
                    }
                    _local_4++;
                }
                return _local_3;
            }
            return new Array<ASAny>();
        }

        function _triggerTrackingEvent(k:String, _arg_2:String=null)
        {
        }

        public function triggerTrackingEvent(k:String, _arg_2:String=null)
        {
            this._triggerTrackingEvent(k, _arg_2);
        }

        public function _Str_22830()
        {
            this._triggerTrackingEvent(TrackingEvent.CREATIVEVIEW);
        }

        public function _Str_23204()
        {
            this._Str_10143 = false;
        }

        public function triggerImpressionConfirmations(k:Bool=false)
        {
            var _local_2 = 0;
            var _local_3:NetworkResource = null;
            if ((k || (!this._Str_10143)))
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3519.length)
                {
                    _local_3 = this._Str_3519[_local_2];
                    _local_3.call();
                    _local_2++;
                }
            }
            this._Str_10143 = true;
        }

        public function triggerForcedImpressionConfirmations(k:Bool=false)
        {
            var _local_2 = 0;
            var _local_3:NetworkResource = null;
            if ((k || (!this._Str_10143)))
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3519.length)
                {
                    _local_3 = this._Str_3519[_local_2];
                    _local_3.call();
                    _local_2++;
                }
                this._Str_10143 = true;
            }
        }

        function _Str_25176( k:Array<ASAny> = null):ASAny
        {
if (k == null) k = [];

return ASCompat.undefinedValue();         }

        function _Str_25265( k:Array<ASAny> = null):ASAny
        {
if (k == null) k = [];

return ASCompat.undefinedValue();         }

        public function processStartAdEvent()
        {
            if (this.hasNonLinearAds() == false)
            {
                this.triggerImpressionConfirmations();
            }
            this._Str_22830();
            this._triggerTrackingEvent(TrackingEvent.START);
        }

        public function processStopAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.STOP);
        }

        public function processPauseAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.PAUSE);
        }

        public function processResumeAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.RESUME);
        }

        public function processFullScreenAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.FULLSCREEN);
        }

        public function _Str_22336()
        {
        }

        public function processMuteAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.MUTE);
        }

        public function processUnmuteAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.UNMUTE);
        }

        public function processReplayAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.REPLAY);
        }

        public function processHitMidpointAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.MIDPOINT);
        }

        public function processFirstQuartileCompleteAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.EVENT_1STQUARTILE);
        }

        public function processThirdQuartileCompleteAdEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.EVENT_3RDQUARTILE);
        }

        public function processAdCompleteEvent()
        {
            this._triggerTrackingEvent(TrackingEvent.COMPLETE);
        }

        function _Str_23496()
        {
            var k = 0;
            while (k < this._Str_2587.length)
            {
                this._Str_2587[k].clearActiveDisplayRegion();
                k++;
            }
        }

        function _Str_19199(k:Array<ASAny>):Int
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_2587.length)
            {
                if (((this._Str_2587[_local_2].hasActiveDisplayRegion() == false) && ASCompat.toBool(this._Str_2587[_local_2].matchesAcceptedAdTypes(k))))
                {
                    return _local_2;
                }
                _local_2++;
            }
            return -1;
        }

        public function processStartNonLinearAdEvent(k:_Str_3019)
        {
            var _local_2:String = null;
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = false;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            if (k._Str_3073 != null)
            {
                if (k._Str_3073.adSlot != null)
                {
                    this._Str_23496();
                    _local_2 = k._Str_3073.adSlot.preferredDisplayMode;
                    _local_3 = 0;
                    _local_4 = 0;
                    while (_local_4 < 2)
                    {
                        if (k._Str_3073.adSlot.hasRegions(_local_2))
                        {
                            _local_5 = 0;
                            while (((_local_5 < k._Str_3073.adSlot.regions[_local_2].length) && ((cast(k._Str_3073.adSlot, AdSlot)._Str_19603() == false) || (cast(k._Str_3073.adSlot, AdSlot)._Str_19603() && (_local_3 < cast(k._Str_3073.adSlot, AdSlot).maxDisplayCount)))))
                            {
                                if (k._Str_3073.adSlot.regions[_local_2][_local_5].enable)
                                {
                                    _local_6 = false;
                                    _local_7 = 0;
                                    if (k._Str_3073.adSlot.regions[_local_2][_local_5].hasSize())
                                    {
                                        _local_7 = 0;
                                        while (((_local_7 < this._Str_2587.length) && (!_local_6)))
                                        {
                                            if (this._Str_2587[_local_7].hasActiveDisplayRegion() == false)
                                            {
                                                if (this._Str_2587[_local_7].matchesSizeAndAcceptedAdTypes(k._Str_3073.adSlot.regions[_local_2][_local_5].width, k._Str_3073.adSlot.regions[_local_2][_local_5].height, k._Str_3073.adSlot.regions[_local_2][_local_5].acceptedAdTypes))
                                                {
                                                    _local_6 = true;
                                                    _local_3++;
                                                    this._Str_2587[_local_7].start(k, k._Str_3073.adSlot.regions[_local_2][_local_5]);
                                                    this.triggerImpressionConfirmations();
                                                }
                                            }
                                            _local_7++;
                                        }
                                        if (!_local_6)
                                        {
                                            _local_8 = this._Str_19199(k._Str_3073.adSlot.regions[_local_2][_local_5].acceptedAdTypes);
                                            if (((_local_8 > -1) && ASCompat.toBool(k._Str_3073.adSlot.regions[_local_2][_local_5].alwaysMatch)))
                                            {
                                                _local_3++;
                                                this._Str_2587[_local_8].start(k, k._Str_3073.adSlot.regions[_local_2][_local_5]);
                                                this.triggerImpressionConfirmations();
                                            }
                                        }
                                    }
                                    else
                                    {
                                        _local_9 = 0;
                                        _local_10 = -1;
                                        _local_11 = -1;
                                        _local_7 = 0;
                                        while (_local_7 < this._Str_2587.length)
                                        {
                                            if (this._Str_2587[_local_7].hasActiveDisplayRegion() == false)
                                            {
                                                _local_9 = ASCompat.toInt(this._Str_2587[_local_7].deriveScoreBasedOnEstimatedSizeAndAcceptedAdTypes(k.controller.playerWidth, k.controller.playerHeight, k._Str_3073.adSlot.regions[_local_2][_local_5].acceptedAdTypes));
                                                if (_local_9 >= 0)
                                                {
                                                    if (_local_9 == 0)
                                                    {
                                                        _local_11 = _local_7;
                                                        break;
                                                    }
                                                    if (((_local_11 == -1) || (_local_9 < _local_10)))
                                                    {
                                                        _local_10 = _local_9;
                                                        _local_11 = _local_7;
                                                    }
                                                }
                                            }
                                            _local_7++;
                                        }
                                        if ((((this._Str_2587.length > 0) && (_local_11 == -1)) && ASCompat.toBool(k._Str_3073.adSlot.regions[_local_2][_local_5].alwaysMatch)))
                                        {
                                            _local_11 = this._Str_19199(k._Str_3073.adSlot.regions[_local_2][_local_5].acceptedAdTypes);
                                        }
                                        if (_local_11 > -1)
                                        {
                                            _local_3++;
                                            this._Str_2587[_local_11].start(k, k._Str_3073.adSlot.regions[_local_2][_local_5]);
                                            this.triggerImpressionConfirmations();
                                        }
                                    }
                                }
                                _local_5++;
                            }
                        }
                        _local_2 = ((_local_2 == "flash") ? "html5" : "flash");
                        _local_4++;
                    }
                }
                return;
            }
        }

        public function processStopNonLinearAdEvent(k:_Str_3019)
        {
            var _local_2 = 0;
            while (_local_2 < this._Str_2587.length)
            {
                if (this._Str_2587[_local_2].hasActiveDisplayRegion())
                {
                    this._Str_2587[_local_2].stop(k);
                }
                _local_2++;
            }
        }

        public function processStartCompanionAdEvent(k:_Str_3019)
        {
            var _local_2 = 0;
            if (k.controller.displayingCompanions())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3336.length)
                {
                    this._Str_3336[_local_2].start(k);
                    _local_2++;
                }
            }
        }

        public function processStopCompanionAdEvent(k:_Str_3019)
        {
            var _local_2 = 0;
            if (k.controller.displayingCompanions())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3336.length)
                {
                    this._Str_3336[_local_2].stop(k);
                    _local_2++;
                }
            }
        }

        public function split():Array<ASAny>
        {
            var _local_2:VideoAd = null;
            var k= new Array<ASAny>();
            if ((this.hasLinearAd() && this.hasNonLinearAds()))
            {
                _local_2 = new VideoAd();
                _local_2.inlineAdId = this._Str_9985;
                _local_2.adId = this._Str_7451;
                _local_2.sequenceId = this._Str_14340;
                _local_2.creativeId = this._Str_14487;
                _local_2.adSystem = this._Str_6606;
                _local_2.adTitle = this._Str_15105;
                _local_2.description = this._Str_1858;
                _local_2.survey = this._Str_10070;
                _local_2.error = this._error;
                _local_2.impressions = this._Str_3519;
                _local_2.trackingEvents = this._Str_3053;
                _local_2.companionAds = this._Str_3336;
                _local_2.extensions = this._Str_7809;
                _local_2.nonLinearVideoAds = this._Str_2587;
                this.nonLinearVideoAds = new Array<ASAny>();
                k.push(this);
                k.push(_local_2);
            }
            else
            {
                k.push(this);
            }
            return k;
        }

        public function _Str_23203():ASObject
        {
            if (this.hasLinearAd())
            {
                return this._Str_2815.toJSObject();
            }
            return "";
        }

        public function _Str_22275():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this.hasNonLinearAds())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_2587.length)
                {
                    k.push(this._Str_2587[_local_2].toJSObject());
                    _local_2++;
                }
            }
            return k;
        }

        public function _Str_25761():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this.hasCompanionAds())
            {
                _local_2 = 0;
                while (_local_2 < this._Str_3336.length)
                {
                    k.push(this._Str_3336[_local_2].toJSObject());
                    _local_2++;
                }
            }
            return k;
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "id":this._id,
                "uid":_uid,
                "adId":this._Str_7451,
                "inlineAdId":this._Str_9985,
                "type":this.adType,
                "adSystem":this._Str_6606,
                "adTitle":this._Str_15105,
                "description":this._Str_1858,
                "survey":this._Str_10070,
                "impressions":ArrayUtils._Str_6975(this._Str_3519),
                "trackingEvents":ArrayUtils._Str_6975(this._Str_3053),
                "linearAd":this._Str_23203(),
                "nonLinearAds":this._Str_22275(),
                "companionAds":this._Str_25761(),
                "sequenceId":this._Str_14340,
                "creativeId":this._Str_14487,
                "extensions":this._Str_7809
            }
;            return k;
        }
    }

