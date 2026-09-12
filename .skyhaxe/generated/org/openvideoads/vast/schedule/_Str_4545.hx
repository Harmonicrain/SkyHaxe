package org.openvideoads.vast.schedule
;
    import org.openvideoads.base.Debuggable;
    import org.openvideoads.vast.playlist._Str_6835;
    import org.openvideoads.vast.config._Str_2741;
    import org.openvideoads.vast.playlist._Str_4575;
    import org.openvideoads.vast.playlist._Str_7812;
    import org.openvideoads.vast.playlist._Str_3480;
    import org.openvideoads.util.Timestamp;

     class _Str_4545 extends Debuggable implements _Str_6835 implements  _Str_2741 
    {
        var _id:String = null;
        var _filename:String;
        var _baseURL:String = null;
        var _Str_22547:String = null;
        var _duration:String = "00:00:00";
        var _reduceLength:Bool = false;
        var _Str_20270:Bool = false;
        var _deliveryType:String = "any";
        var _playOnce:Bool = false;
        var _metaData:Bool = true;
        var _autoPlay:Bool = true;
        var _provider:String = null;
        var _player:ASObject;
        var _customProperties:ASObject;
        var _type:String = null;
        var _Str_16632:_Str_2741 = null;
        var _Str_20259:Bool = false;
        var _startTime:String = "00:00:00";
        var _fireTrackingEvents:Bool = false;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:Bool=false, _arg_5:String="any", _arg_6:Bool=false, _arg_7:Bool=true, _arg_8:Bool=true, _arg_9:String=null, _arg_10:ASObject=null, _arg_11:ASObject=null, _arg_12:String=null, _arg_13:String=null, _arg_14:Bool=false)
        {
            this._player = new ASObject();
            this._customProperties = new ASObject();
            super();
            this._id = k;
            if (_arg_2 != null)
            {
                if (_arg_2.indexOf("(live)") > -1)
                {
                    this._filename = _arg_2.substr((_arg_2.lastIndexOf("(live)") + 6));
                    this._Str_20270 = true;
                }
                else
                {
                    this._filename = _arg_2;
                }
            }
            this.duration = _arg_3;
            this._reduceLength = _arg_4;
            this._deliveryType = _arg_5;
            this._playOnce = _arg_6;
            this._metaData = _arg_7;
            this._autoPlay = _arg_8;
            this._provider = _arg_9;
            if (_arg_10 != null)
            {
                this._player = _arg_10;
            }
            if (_arg_11 != null)
            {
                this._customProperties = _arg_11;
            }
            this.type = _arg_12;
            if (_arg_13 != null)
            {
                this._startTime = _arg_13;
            }
            else
            {
                this._startTime = "00:00:00";
            }
            this._fireTrackingEvents = _arg_14;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var player(get,never):ASObject;
public function  get_player():ASObject
        {
            return this._player;
        }

        
        public var provider(get,set):String;
public function  set_provider(k:String):String        {
            return this._provider = k;
        }
public function  get_provider():String
        {
            return this._provider;
        }

        
        public var fireTrackingEvents(get,set):Bool;
public function  set_fireTrackingEvents(k:Bool):Bool        {
            return this._fireTrackingEvents = k;
        }
public function  get_fireTrackingEvents():Bool
        {
            return this._fireTrackingEvents;
        }

        
        public var autoPlay(get,set):Bool;
public function  set_autoPlay(k:Bool):Bool        {
            return this._autoPlay = k;
        }
public function  get_autoPlay():Bool
        {
            return this._autoPlay;
        }

        
        public var deliveryType(get,set):String;
public function  set_deliveryType(k:String):String        {
            return this._deliveryType = k;
        }
public function  get_deliveryType():String
        {
            return this._deliveryType;
        }

        
        public var metaData(get,set):Bool;
public function  set_metaData(k:Bool):Bool        {
            return this._metaData = k;
        }
public function  get_metaData():Bool
        {
            return this._metaData;
        }

        
        public var customProperties(get,set):ASObject;
public function  set_customProperties(k:ASObject):ASObject        {
            return this._customProperties = k;
        }
public function  get_customProperties():ASObject
        {
            return this._customProperties;
        }

        
        public var filename(get,set):String;
public function  set_filename(k:String):String        {
            return this._filename = k;
        }
public function  get_filename():String
        {
            return this._filename;
        }

        
        public var baseURL(get,set):String;
public function  get_baseURL():String
        {
            return this._baseURL;
        }
public function  set_baseURL(k:String):String        {
            return this._baseURL = k;
        }

        public function hasBaseURL():Bool
        {
            return !(this._baseURL == null);
        }

        public function _Str_24069():Bool
        {
            if (this._type != null)
            {
                return this._type.toUpperCase() == "SMIL";
            }
            return false;
        }

        public function resolveFilename(k:_Str_2741)
        {
            var _local_2:_Str_4575 = null;
            this._Str_16632 = k;
            if (this._Str_24069())
            {
                _local_2 = _Str_7812._Str_19936(_Str_7812.getType(this._type.toUpperCase()));
                _local_2._Str_16925(this._filename, this);
            }
            else
            {
                this.onOVAConfigLoaded();
            }
        }

        public function isOVAConfigLoading():Bool
        {
            return !(this._type == null);
        }

        public function onOVAConfigLoaded()
        {
            if (this._type == null)
            {
                if (this._Str_16632 != null)
                {
                    this._Str_16632.onOVAConfigLoaded();
                }
            }
        }

        public function _Str_16701(k:_Str_4575)
        {
            var _local_2:_Str_3480 = null;
            if (k.length > 0)
            {
                _local_2 = k._Str_11606(0);
                this._type = null;
                this._Str_22547 = this._filename;
                this._Str_20259 = true;
                if (_local_2.isRTMP())
                {
                    this._filename = _local_2.filename;
                    this._baseURL = _local_2.url;
                }
                else
                {
                    this._filename = _local_2.getQualifiedStreamAddress();
                }
                this._id = this._filename;
            }
            this.onOVAConfigLoaded();
        }

        public var file(get,never):String;
public function  get_file():String
        {
            return this.filename;
        }

        public function _Str_26216():Bool
        {
            return this._Str_20259;
        }

        
        public var type(get,set):String;
public function  set_type(k:String):String        {
            return this._type = k;
        }
public function  get_type():String
        {
            return this._type;
        }

        public function isStream():Bool
        {
            var k:compat.RegExp = null;
            if (this._filename != null)
            {
                k = new compat.RegExp("(?i).*\\.(jpg|png|gif|bmp)");
                return ASCompat.stringMatch(this._filename, k)== null;
            }
            return true;
        }

        
        public var duration(get,set):String;
public function  set_duration(k:String):String        {
            if (Timestamp.validate(k))
            {
                this._duration = k;
            }
            else
            {
                this._duration = Timestamp._Str_16820(k);
            }
return k;
        }
public function  get_duration():String
        {
            return this._duration;
        }

        public function hasDuration():Bool
        {
            return (!(this._duration == null)) && (this.getDurationAsInt() > 0);
        }

        public function getDurationAsInt():Int
        {
            return Timestamp.timestampToSeconds(this.duration);
        }

        
        public var reduceLength(get,set):Bool;
public function  set_reduceLength(k:Bool):Bool        {
            return this._reduceLength = k;
        }
public function  get_reduceLength():Bool
        {
            return this._reduceLength;
        }

        
        public var startTime(get,set):String;
public function  set_startTime(k:String):String        {
            if (k != null)
            {
                if (k.indexOf(":") == 2)
                {
                    this._startTime = k;
                }
                else
                {
                    this._startTime = Timestamp._Str_4110(ASCompat.toInt(k));
                }
            }
return k;
        }
public function  get_startTime():String
        {
            return this._startTime;
        }

        public function isLive():Bool
        {
            return this._Str_20270;
        }

        
        public var playOnce(get,set):Bool;
public function  set_playOnce(k:Bool):Bool        {
            return this._playOnce = k;
        }
public function  get_playOnce():Bool
        {
            return this._playOnce;
        }
    }

