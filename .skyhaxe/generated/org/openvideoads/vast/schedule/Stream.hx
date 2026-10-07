package org.openvideoads.vast.schedule
;
    import org.openvideoads.base._Str_4989;
    import org.openvideoads.vast.tracking.TrackingTable;
    import org.openvideoads.vast.VASTController;
    import org.openvideoads.vast.schedule.ads.AdSlot;
    import org.openvideoads.vast.playlist._Str_3480;
    import org.openvideoads.vast.config.Config;
    import org.openvideoads.util.NetworkResource;
    import org.openvideoads.util.StringUtils;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.vast.tracking._Str_2460;
    import org.openvideoads.vast.tracking._Str_4278;

     class Stream extends _Str_4989 
    {
        public static inline final _Str_24267= "video/x-flv";
        public static inline final _Str_24815= "video/x-mp4";
        public static inline final _Str_26086= "streaming";
        public static inline final _Str_26113= "progressive";

        var _id:String = null;
        var _Str_2987:Int = 0;
        var _Str_14603:String;
        var _Str_990:String = "00:00:00";
        var _Str_17895:Int = 0;
        var _Str_10178:String = null;
        var _Str_2467:String = null;
        var _Str_8087:Bool = false;
        var _Str_4718:String = "any";
        var _Str_2230:String = null;
        var _Str_4980:ASAny = -1;
        var _width:Int = -1;
        var _height:Int = -1;
        var _Str_8898:Bool = false;
        var _Str_2846:String = null;
        var _Str_3649:TrackingTable = null;
        var _parent:StreamSequence = null;
        var _Str_2335:VASTController = null;
        var _Str_4101:String = "streaming";
        var _Str_4538:Bool = false;
        var _Str_3744:Bool = true;
        var _Str_3869:Bool = true;
        var _Str_4904:String = null;
        var _Str_4797:ASObject;
        var _previewImage:String = null;
        var _index:Int = -1;
        var _Str_7240:Int = 0;
        var _Str_8737:Int = 0;
        var _Str_20639:Bool = false;
        var _title:String = null;
        var _Str_3753:ASObject = null;
        var _Str_6195:Bool = false;
        var _Str_18584:Bool = false;
        var _Str_17968:Bool = false;
        var _Str_12564:AdSlot = null;
        var _Str_19898:_Str_3480 = null;
        var _Str_19364:Bool = false;

        public function new(k:StreamSequence, _arg_2:VASTController, _arg_3:Int=0, _arg_4:String=null, _arg_5:String=null, _arg_6:String="00:00:00", _arg_7:String=null, _arg_8:String=null, _arg_9:Bool=false, _arg_10:String=null, _arg_11:String="any", _arg_12:String="streaming", _arg_13:ASAny=-1, _arg_14:Bool=false, _arg_15:Bool=true, _arg_16:Bool=true, _arg_17:String=null, _arg_18:ASObject=null, _arg_19:String=null, _arg_20:Int=0, _arg_21:Bool=false, _arg_22:ASObject=null, _arg_23:Bool=false, _arg_24:Bool=false, _arg_25:AdSlot=null)
        {
            this._Str_4797 = new ASObject();
            super();
            this._parent = k;
            this._Str_2335 = _arg_2;
            this._Str_2987 = _arg_3;
            this._Str_3649 = new TrackingTable(_arg_4, _arg_3, _arg_20);
            this._id = _arg_4;
            this._Str_14603 = _arg_5;
            this.startTime = _arg_6;
            this._Str_2467 = _arg_7;
            this._Str_10178 = _arg_8;
            this._Str_8087 = _arg_9;
            this._Str_4718 = _arg_11;
            this._Str_4980 = _arg_13;
            this._Str_19161();
            this._Str_2846 = _arg_10;
            this._Str_4101 = _arg_12;
            this._Str_4538 = _arg_14;
            this._Str_3744 = _arg_15;
            this._Str_3869 = _arg_16;
            this._Str_4904 = _arg_17;
            this._Str_12564 = _arg_25;
            if (_arg_18 != null)
            {
                this._Str_4797 = _arg_18;
            }
            if (_arg_22 != null)
            {
                this._Str_3753 = _arg_22;
            }
            this._previewImage = _arg_19;
            this._Str_8737 = _arg_20;
            this._Str_20639 = _arg_21;
            this._Str_6195 = _arg_23;
            this._Str_17968 = _arg_24;
        }

        public function unload()
        {
        }

        
        public var key(get,set):Int;
public function  set_key(k:Int):Int        {
            return this._Str_2987 = k;
        }
public function  get_key():Int
        {
            return this._Str_2987;
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        public var _Str_26434(never,set):Bool;
public function  set__Str_26434(k:Bool):Bool        {
            return this._Str_19364 = k;
        }

        public var _Str_26303(get,never):Bool;
public function  get__Str_26303():Bool
        {
            return this._Str_19364;
        }

        
        public var title(get,set):String;
public function  set_title(k:String):String        {
            return this._title = k;
        }
public function  get_title():String
        {
            return this._title;
        }

        public var config(get,never):Config;
public function  get_config():Config
        {
            if (this._Str_2335 != null)
            {
                return this._Str_2335.config;
            }
            return new Config();
        }

        
        public var hasOffsetStartTime(get,set):Bool;
public function  set_hasOffsetStartTime(k:Bool):Bool        {
            return this._Str_17968 = k;
        }
public function  get_hasOffsetStartTime():Bool
        {
            return this._Str_17968;
        }

        public function isSlice():Bool
        {
            return this._Str_20639;
        }

        
        public var originatingStreamIndex(get,set):Int;
public function  set_originatingStreamIndex(k:Int):Int        {
            return this._Str_8737 = k;
        }
public function  get_originatingStreamIndex():Int
        {
            return this._Str_8737;
        }

        
        public var associatedStreamIndex(get,set):Int;
public function  set_associatedStreamIndex(k:Int):Int        {
            return this._Str_7240 = k;
        }
public function  get_associatedStreamIndex():Int
        {
            return this._Str_7240;
        }

        
        public var _Str_17460(get,set):Bool;
public function  set__Str_17460(k:Bool):Bool        {
            return this._Str_18584 = k;
        }
public function  get__Str_17460():Bool
        {
            return this._Str_18584;
        }

        public function _Str_25920():Bool
        {
            return this._Str_18584;
        }

        
        public var index(get,set):Int;
public function  set_index(k:Int):Int        {
            return this._index = k;
        }
public function  get_index():Int
        {
            return this._index;
        }

        public function _Str_26140():Bool
        {
            return !(this._Str_12564 == null);
        }

        
        public var _Str_21235(get,set):AdSlot;
public function  set__Str_21235(k:AdSlot):AdSlot        {
            return this._Str_12564 = k;
        }
public function  get__Str_21235():AdSlot
        {
            return this._Str_12564;
        }

        
        public var provider(get,set):String;
public function  set_provider(k:String):String        {
            return this._Str_4904 = k;
        }
public function  get_provider():String
        {
            return this._Str_4904;
        }

        public var _Str_4565(get,never):ASObject;
public function  get__Str_4565():ASObject
        {
            return this._Str_4797;
        }

        
        public var previewImage(get,set):String;
public function  set_previewImage(k:String):String        {
            return this._previewImage = k;
        }
public function  get_previewImage():String
        {
            return this._previewImage;
        }

        
        public var autoPlay(get,set):Bool;
public function  set_autoPlay(k:Bool):Bool        {
            return this._Str_3869 = k;
        }
public function  get_autoPlay():Bool
        {
            return this._Str_3869;
        }

        public var _Str_25927(get,never):String;
public function  get__Str_25927():String
        {
            return "";
        }

        public function isInteractive():Bool
        {
            return false;
        }

        public var playOnce(get,never):Bool;
public function  get_playOnce():Bool
        {
            return this._Str_4538;
        }

        
        public var deliveryType(get,set):String;
public function  set_deliveryType(k:String):String        {
            return this._Str_4101 = k;
        }
public function  get_deliveryType():String
        {
            return this._Str_4101;
        }

        public var metaData(get,never):Bool;
public function  get_metaData():Bool
        {
            return this._Str_3744;
        }

        
        public var bitrate(get,set):ASAny;
public function  set_bitrate(k:ASAny):ASAny        {
            return this._Str_4980 = k;
        }
public function  get_bitrate():ASAny
        {
            return this._Str_4980;
        }

        
        public var width(get,set):Int;
public function  set_width(k:Int):Int        {
            return this._width = k;
        }
public function  get_width():Int
        {
            return this._width;
        }

        
        public var height(get,set):Int;
public function  set_height(k:Int):Int        {
            return this._height = k;
        }
public function  get_height():Int
        {
            return this._height;
        }

        public var fireTrackingEvents(get,never):Bool;
public function  get_fireTrackingEvents():Bool
        {
            return this._Str_6195;
        }

        public function _Str_24709():Bool
        {
            return !(this._Str_3753 == null);
        }

        public function _Str_26369(k:String):Bool
        {
            if (this._Str_24709())
            {
                return ASCompat.hasOwnProperty(this._Str_3753, k);
            }
            return false;
        }

        
        public var customProperties(get,set):ASObject;
public function  set_customProperties(k:ASObject):ASObject        {
            return this._Str_3753 = k;
        }
public function  get_customProperties():ASObject
        {
            return this._Str_3753;
        }

        public function getQualifiedStreamAddress():String
        {
            var k= this.getStreamToPlay();
            return k.getQualifiedStreamAddress(this._Str_2846);
        }

        
        public var parent(get,set):StreamSequence;
public function  set_parent(k:StreamSequence):StreamSequence        {
            return this._parent = k;
        }
public function  get_parent():StreamSequence
        {
            return this._parent;
        }

        
        public var streamID(get,set):String;
public function  set_streamID(k:String):String        {
            return this._Str_14603 = k;
        }
public function  get_streamID():String
        {
            return this._Str_14603;
        }

        
        public var streamType(get,set):String;
public function  set_streamType(k:String):String        {
            this._Str_4718 = k;
            this._Str_19161();
return k;
        }
public function  get_streamType():String
        {
            return this._Str_4718;
        }

        
        public var _Str_21333(get,set):_Str_3480;
public function  set__Str_21333(k:_Str_3480):_Str_3480        {
            return this._Str_19898 = k;
        }
public function  get__Str_21333():_Str_3480
        {
            return this._Str_19898;
        }

        public function _Str_23330():Bool
        {
            var _local_2:compat.RegExp = null;
            var k= this.streamName;
            if (k != null)
            {
                _local_2 = new compat.RegExp("(?i).*\\.(jpg|png|gif|bmp)");
                return !(ASCompat.stringMatch(k, _local_2)== null);
            }
            return false;
        }

        public function _Str_26375():Bool
        {
            return !StringUtils.isEmpty(this.streamName);
        }

        public function isLoaded():Bool
        {
            return true;
        }

        public function isStream():Bool
        {
            var k:String = null;
            var _local_2:compat.RegExp = null;
            if (this.streamName != null)
            {
                if (this.streamName.indexOf("?") > 0)
                {
                    k = this.streamName.substr(0, this.streamName.indexOf("?"));
                }
                else
                {
                    k = this.streamName;
                }
                _local_2 = new compat.RegExp("(?i).*\\.(mp4|flv|wmv|mp3|3g2|3gp|aac|f4b|f4p|f4v|m4a|m4v|mov|sdp)$");
                return !(ASCompat.stringMatch(k, _local_2)== null);
            }
            return true;
        }

        public function _Str_26312(k:String):Bool
        {
            if (this._id != null)
            {
                return StringUtils._Str_4861(this._id, k);
            }
            return false;
        }

        public function _Str_26347(k:String):Bool
        {
            return StringUtils._Str_4861(this.streamName, k);
        }

        public function _Str_26021(k:String):String
        {
            if (this.streamName != null)
            {
                if (this.streamName.length > k.length)
                {
                    return this.streamName.substr(k.length);
                }
            }
            return null;
        }

        function _Str_19161()
        {
            if (this._Str_4718.toUpperCase() == "MP4")
            {
                this._Str_2230 = Stream._Str_24815;
            }
            else
            {
                if (this._Str_4718.toUpperCase() == "FLV")
                {
                    this._Str_2230 = Stream._Str_24267;
                }
                else
                {
                    this._Str_2230 = null;
                }
            }
        }

        public var mimeType(get,never):String;
public function  get_mimeType():String
        {
            return this._Str_2230;
        }

        
        public var startTime(get,set):String;
public function  set_startTime(k:String):String        {
            this._Str_990 = k;
            this._Str_17895 = this.getStartTimeAsSeconds();
return k;
        }
public function  get_startTime():String
        {
            return this._Str_990;
        }

        public function getStartTimeAsSeconds():Int
        {
            if (this._Str_990 != null)
            {
                if (Timestamp.validate(this._Str_990))
                {
                    return Timestamp.timestampToSeconds(this._Str_990);
                }
                return ASCompat.parseInt(this._Str_990);
            }
            return 0;
        }

        public function _Str_26266():String
        {
            return Std.string(this.getStartTimeAsSeconds());
        }

        
        public var streamStartTime(get,set):Int;
public function  set_streamStartTime(k:Int):Int        {
            return this._Str_17895 = k;
        }
public function  get_streamStartTime():Int
        {
            return this._Str_17895;
        }

        public function hasDuration():Bool
        {
            if (this.duration != null)
            {
                return (!(this.duration == "00:00:00")) && (!(this.duration == "0"));
            }
            return false;
        }

        public function _Str_22487():Bool
        {
            if (this.duration != null)
            {
                return this.getDurationAsInt() > 0;
            }
            return false;
        }

        public function _Str_20238():Bool
        {
            return !this._Str_22487();
        }

        public function isSlicedStream():Bool
        {
            return this.isSlice();
        }

        public function _Str_23955():Bool
        {
            var k= this.getStartTimeAsSeconds();
            return (k == 0) || ((k > 0) && this.hasOffsetStartTime);
        }

        
        public var _Str_19355(get,set):String;
public function  set__Str_19355(k:String):String        {
            return this._Str_10178 = k;
        }
public function  get__Str_19355():String
        {
            return this._Str_10178;
        }

        public function _Str_21832():Int
        {
            return ASCompat.parseInt(this._Str_10178);
        }

        
        public var duration(get,set):String;
public function  set_duration(k:ASAny):String        {
            var _local_2= (Std.is(k , String) ? k : (Std.is(k , Float) ? Std.string(k) : "0"));
            this._Str_2467 = _local_2;
            this._Str_8898 = false;
            this.declareTrackingPoints(0, true);
return k;
        }
public function  get_duration():String
        {
            return (this._Str_2467 == null) ? "0" : this._Str_2467;
        }

        public function getDurationAsInt():Int
        {
            return ASCompat.parseInt(this.duration);
        }

        public function _Str_24960():String
        {
            return Timestamp._Str_4110(ASCompat.parseInt(this._Str_2467));
        }

        
        public var reduceLength(get,set):Bool;
public function  set_reduceLength(k:Bool):Bool        {
            return this._Str_8087 = k;
        }
public function  get_reduceLength():Bool
        {
            return this._Str_8087;
        }

        public function isRTMP():Bool
        {
            var _local_2:NetworkResource = null;
            var k= this.getStreamToPlay();
            if (k != null)
            {
                if (k._Str_11386())
                {
                    return k.isRTMP();
                }
                if (this.hasBaseURL())
                {
                    _local_2 = new NetworkResource(null, this.baseURL);
                    return _local_2.isRTMP();
                }
            }
            return false;
        }

        public function getStreamToPlay():NetworkResource
        {
            return new NetworkResource(null, this._Str_14603);
        }

        function _Str_22449(k:String):String
        {
            var _local_2= StringUtils.trim(k);
            if (_local_2.lastIndexOf("/") == (_local_2.length - 1))
            {
                return _local_2;
            }
            return _local_2 + "/";
        }

        public var url(get,never):String;
public function  get_url():String
        {
            var k= this.getStreamToPlay();
            if (k != null)
            {
                if (k._Str_11386())
                {
                    return k.url;
                }
                if (this.hasBaseURL())
                {
                    return this._Str_22449(this._Str_2846) + this._Str_21497(k.url);
                }
                return k.url;
            }
            return null;
        }

        
        public var baseURL(get,set):String;
public function  set_baseURL(k:String):String        {
            return this._Str_2846 = k;
        }
public function  get_baseURL():String
        {
            var k= this.getStreamToPlay();
            if (k != null)
            {
                if (k._Str_11386())
                {
                    return k.netConnectionAddress;
                }
                if (this.hasBaseURL())
                {
                    return this._Str_2846;
                }
            }
            return null;
        }

        public function hasBaseURL():Bool
        {
            return !(this._Str_2846 == null);
        }

        public function _Str_26214():Bool
        {
            var k= this.streamName;
            if (k != null)
            {
                return StringUtils._Str_22149(k, ".smil");
            }
            return false;
        }

        public function isLinear():Bool
        {
            return true;
        }

        public function canScale():Bool
        {
            return false;
        }

        public function shouldMaintainAspectRatio():Bool
        {
            return false;
        }

        function _Str_21497(k:String):String
        {
            if (k != null)
            {
                if (k.indexOf("mp4:") >= 0)
                {
                    return k.substr((k.indexOf("mp4:") + 4));
                }
                if (k.indexOf("flv:") >= 0)
                {
                    return k.substr((k.indexOf("flv:") + 4));
                }
                return k;
            }
            return null;
        }

        public var streamName(get,never):String;
public function  get_streamName():String
        {
            var k= this.getStreamToPlay();
            return this.cleanseStreamName(k._Str_5059((this.streamType + ":")));
        }

        public var _Str_24252(get,never):String;
public function  get__Str_24252():String
        {
            return this._Str_21497(this.streamName);
        }

        function cleanseStreamName(k:String):String
        {
            var _local_2:compat.RegExp = null;
            if (k != null)
            {
                if (((!(k.indexOf("mp4:") == 0)) || (!(k.indexOf("flv:") == 0))))
                {
                    if (k.indexOf("mp4:") > 0)
                    {
                        k = k.substr(k.indexOf("mp4:"));
                    }
                    else
                    {
                        if (k.indexOf("flv:") > 0)
                        {
                            k = k.substr(k.indexOf("flv:"));
                        }
                    }
                }
                if (k.indexOf("flv:") > -1)
                {
                    _local_2 = new compat.RegExp("flv:", "g");
                    return _local_2.replace(k, "");
                }
                return k;
            }
            return null;
        }

        function _Str_18576()
        {
            this._Str_8898 = true;
        }

        public function _Str_21236()
        {
            this._Str_8898 = false;
        }

        function clearTrackingTable(k:Bool=false)
        {
            this._Str_3649 = new TrackingTable(this.id, this.key, this.originatingStreamIndex);
        }

        public function _Str_2606(k:_Str_2460, _arg_2:Bool=false, _arg_3:Bool=true, _arg_4:Bool=false)
        {
            if ((_arg_2 || (this._Str_8898 == false)))
            {
                this._Str_3649._Str_24378(k, _arg_4);
                if (_arg_3)
                {
                    if (this._Str_2335 != null)
                    {
                        this._Str_2335._Str_23658(k);
                    }
                }
            }
        }

        public function declareTrackingPoints(k:Int=0, _arg_2:Bool=false)
        {
            var _local_3 = 0;
            if (this._Str_8898 == false)
            {
                this.clearTrackingTable(_arg_2);
                _local_3 = 1000;
                if (this.getDurationAsInt() > 0)
                {
                    this._Str_2606(new _Str_2460(((k * _local_3) + this._Str_2335.startStreamSafetyMargin), "BS"));
                    if (((!this._Str_2335._Str_17402) && this.isSlicedStream()))
                    {
                        this._Str_2606(new _Str_2460((((k + this._Str_21832()) * _local_3) - this._Str_2335.endStreamSafetyMargin), "ES"));
                    }
                    else
                    {
                        this._Str_2606(new _Str_2460((((k + this.getDurationAsInt()) * _local_3) - this._Str_2335.endStreamSafetyMargin), "ES"));
                    }
                }
                this._Str_18576();
            }
        }

        public function _Str_22706():TrackingTable
        {
            return this._Str_3649;
        }

        public function resetAllTrackingPoints()
        {
            if (this._Str_3649 != null)
            {
                this._Str_3649.resetAllTrackingPoints();
            }
        }

        public function resetRepeatableTrackingPoints()
        {
            if (this._Str_3649 != null)
            {
                this._Str_3649.resetRepeatableTrackingPoints();
            }
        }

        public function processTimeEvent(k:_Str_4278, _arg_2:Bool=true, _arg_3:Bool=false)
        {
            var _local_6:_Str_2460 = null;
            var _local_4= this._Str_3649.activeTrackingPoints(k, _arg_2);
            var _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = _local_4[_local_5];
                if (_local_6 != null)
                {
                    switch (_local_6.label)
                    {
                        case "BS":
                            this.processStartStream();
                            this._Str_2335.onProcessTrackingPoint(_local_6);
                            
                        case "ES":
                            this.processStreamComplete();
                            this._Str_2335.onProcessTrackingPoint(_local_6);
                            
                    }
                }
                _local_5++;
            }
        }

        public function processStartStream()
        {
        }

        public function processStopStream()
        {
        }

        public function processStreamComplete()
        {
        }

        public function processPauseStream()
        {
        }

        public function processResumeStream()
        {
        }

        public function processFullScreenEvent()
        {
        }

        public function processFullScreenExitEvent()
        {
        }

        public function processMuteEvent()
        {
        }

        public function processUnmuteEvent()
        {
        }

        function _Str_19894()
        {
            if (this._Str_2335 != null)
            {
                this._Str_2335._Str_20056(true);
            }
        }

        function _Str_21885()
        {
            if (this._Str_2335 != null)
            {
                this._Str_2335._Str_20056(false);
            }
        }

        public function toShortString():String
        {
            return (((((("streamName: " + this.streamName) + ", baseURL: ") + this.baseURL) + ", duration: ") + this.duration) + ", startTime: ") + this.startTime;
        }

        public function toString():String
        {
            return (((((((((((((((((((((((((((((((((((("key: " + Std.string(this.key)) + ", id: ") + this.id) + ", originatingStreamIndex: ") + Std.string(this.originatingStreamIndex)) + ", baseURL: ") + this.baseURL) + ", streamName: ") + this.streamName) + ", startTime: ") + this.startTime) + ", duration: ") + this.duration) + ", originalDuration: ") + this._Str_19355) + ", reduceLength: ") + Std.string(this.reduceLength)) + ", hasOffsetStartTime: ") + Std.string(this.hasOffsetStartTime)) + ", isSlice: ") + Std.string(this.isSlice())) + ", streamType: ") + this.streamType) + ", bitrate: ") + this.bitrate) + ", mimeType: ") + this.mimeType) + ", deliveryType: ") + this.deliveryType) + ", playOnce: ") + Std.string(this.playOnce)) + ", metaData: ") + Std.string(this.metaData)) + ", previewImage: ") + this.previewImage) + ", fireTrackingEvents: ") + Std.string(this.fireTrackingEvents);
        }
    }

