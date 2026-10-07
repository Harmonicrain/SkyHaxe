package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.vast.config._Str_2741;

     class AbstractStreamsConfig extends _Str_3389 
    {
        static var _Str_14458:String = null;
        static var _Str_15475:String = "any";
        static var _Str_12597:String = "any";
        static var _Str_20481:String = "any";
        static var _Str_12719:Bool = false;
        static var _Str_14327:Bool = false;
        static var _Str_15650:Bool = false;

        var _Str_2846:String;
        var _Str_4718:String;
        var _Str_4101:String;
        var _Str_10343:Bool = false;
        var _Str_11903:Bool = false;
        var _Str_20248:Bool = true;
        var _Str_4538:Bool = false;
        var _Str_3744:Bool = true;
        var _Str_3869:Bool = false;
        var _Str_6195:Bool = false;
        var _Str_25937:Bool = false;
        var _Str_21723:Bool = false;
        var _Str_4797:ASObject;
        var _Str_3337:ProvidersConfigGroup = null;
        var _Str_6569:Bool = false;
        var _Str_4980:ASAny = -1;
        var _width:Int = -1;
        var _height:Int = -1;
        var _Str_20878:Bool = false;
        var _Str_15662:Bool = false;
        var _Str_13104:Bool = false;

        public function new(k:ASObject=null, _arg_2:_Str_2741=null)
        {
            this._Str_2846 = _Str_14458;
            this._Str_4718 = _Str_15475;
            this._Str_4101 = _Str_12597;
            this._Str_10343 = _Str_12719;
            this._Str_11903 = _Str_14327;
            this._Str_4538 = _Str_15650;
            this._Str_4797 = new ASObject();
            super(k, _arg_2);
        }

        override public function initialise(k:ASObject=null, _arg_2:_Str_2741=null, _arg_3:Bool=false)
        {
            var _local_4:String = null;
            super.initialise(k, _arg_2);
            if (k != null)
            {
                if (k.baseURL != /*undefined*/null)
                {
                    this.baseURL = k.baseURL;
                }
                if (k.streamType != /*undefined*/null)
                {
                    this.streamType = k.streamType;
                }
                if (k.metaData != /*undefined*/null)
                {
                    if (Std.is(k.metaData , String))
                    {
                        this.metaData = ((k.metaData.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.metaData = k.metaData;
                    }
                }
                if (k.setDurationFromMetaData != /*undefined*/null)
                {
                    if (Std.is(k.setDurationFromMetaData , String))
                    {
                        this._Str_6569 = ((k.setDurationFromMetaData.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this._Str_6569 = k.setDurationFromMetaData;
                    }
                }
                if (k.delayAdRequestUntilPlay != /*undefined*/null)
                {
                    if (Std.is(k.delayAdRequestUntilPlay , String))
                    {
                        this._Str_15662 = ((k.delayAdRequestUntilPlay.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this._Str_15662 = k.delayAdRequestUntilPlay;
                    }
                }
                if (k.enableProxies != /*undefined*/null)
                {
                    if (Std.is(k.enableProxies , String))
                    {
                        this._Str_13104 = ((k.enableProxies.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this._Str_13104 = k.enableProxies;
                    }
                }
                if (k.stripFileExtensions != /*undefined*/null)
                {
                    if (Std.is(k.stripFileExtensions , String))
                    {
                        this.stripFileExtensions = ((k.stripFileExtensions.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.stripFileExtensions = k.stripFileExtensions;
                    }
                }
                if (k.bitrate != /*undefined*/null)
                {
                    if (Std.is(k.bitrate , String))
                    {
                        _local_4 = k.bitrate.toUpperCase();
                        if ((((_local_4 == "LOW") || (_local_4 == "MEDIUM")) || (_local_4 == "HIGH")))
                        {
                            this.bitrate = _local_4;
                        }
                        else
                        {
                            this.bitrate = k.bitrate;
                        }
                    }
                    else
                    {
                        this.bitrate = k.bitrate;
                    }
                }
                if (k.width != /*undefined*/null)
                {
                    if (Std.is(k.width , String))
                    {
                        this.width = ASCompat.toInt(k.width);
                    }
                    else
                    {
                        this.width = ASCompat.toInt(k.width);
                    }
                }
                if (k.height != /*undefined*/null)
                {
                    if (Std.is(k.height , String))
                    {
                        this.height = ASCompat.toInt(k.height);
                    }
                    else
                    {
                        this.height = ASCompat.toInt(k.height);
                    }
                }
                if (k.subscribe != /*undefined*/null)
                {
                    if (Std.is(k.subscribe , String))
                    {
                        this.subscribe = ((k.subscribe.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.subscribe = k.subscribe;
                    }
                }
                if (k.fireTrackingEvents != /*undefined*/null)
                {
                    if (Std.is(k.fireTrackingEvents , String))
                    {
                        this.fireTrackingEvents = ((k.fireTrackingEvents.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.fireTrackingEvents = k.fireTrackingEvents;
                    }
                }
                if (k.turnOnCountdownTimer != /*undefined*/null)
                {
                    if (Std.is(k.turnOnCountdownTimer , String))
                    {
                        this.turnOnCountdownTimer = ((k.turnOnCountdownTimer.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.turnOnCountdownTimer = k.turnOnCountdownTimer;
                    }
                }
                if (k.deliveryType != /*undefined*/null)
                {
                    this.deliveryType = k.deliveryType;
                }
                if (k.providers != /*undefined*/null)
                {
                    this.providers = k.providers;
                }
                if (k.allowPlaylistControl != /*undefined*/null)
                {
                    if (Std.is(k.allowPlaylistControl , String))
                    {
                        this.allowPlaylistControl = ((k.allowPlaylistControl.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.allowPlaylistControl = k.allowPlaylistControl;
                    }
                }
                if (k.clearPlaylist != /*undefined*/null)
                {
                    if (Std.is(k.clearPlaylist , String))
                    {
                        this.clearPlaylist = ((k.clearPlaylist.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.clearPlaylist = k.clearPlaylist;
                    }
                }
                if (k.autoPlay != /*undefined*/null)
                {
                    if (Std.is(k.autoPlay , String))
                    {
                        this.autoPlay = ((k.autoPlay.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.autoPlay = k.autoPlay;
                    }
                }
                if (k.playOnce != /*undefined*/null)
                {
                    if (Std.is(k.playOnce , String))
                    {
                        this.playOnce = ((k.playOnce.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.playOnce = k.playOnce;
                    }
                }
                if (k.player != /*undefined*/null)
                {
                    this.player = k.player;
                }
            }
        }

        
        public var setDurationFromMetaData(get,set):Bool;
public function  set_setDurationFromMetaData(k:Bool):Bool        {
            return this._Str_6569 = k;
        }
public function  get_setDurationFromMetaData():Bool
        {
            return this._Str_6569;
        }

        
        public var delayAdRequestUntilPlay(get,set):Bool;
public function  set_delayAdRequestUntilPlay(k:Bool):Bool        {
            return this._Str_15662 = k;
        }
public function  get_delayAdRequestUntilPlay():Bool
        {
            return this._Str_15662;
        }

        
        public var enableProxies(get,set):Bool;
public function  set_enableProxies(k:Bool):Bool        {
            return this._Str_13104 = k;
        }
public function  get_enableProxies():Bool
        {
            return this._Str_13104;
        }

        public function mustOperateWithoutDuration():Bool
        {
            return this._Str_6569;
        }

        public function hasProviders():Bool
        {
            return !(this._Str_3337 == null);
        }

        public function setDefaultProviders()
        {
            this._Str_3337 = new ProvidersConfigGroup();
        }

        public var providers(never,set):ASObject;
public function  set_providers(k:ASObject):ASObject        {
            if (k != null)
            {
                if (k.http != /*undefined*/null)
                {
                    this.httpProvider = k.http;
                }
                if (k.rtmp != /*undefined*/null)
                {
                    this.rtmpProvider = k.rtmp;
                }
                this._Str_4721 = new ProvidersConfigGroup(k);
            }
return k;
        }

        
        public var _Str_4721(get,set):ProvidersConfigGroup;
public function  set__Str_4721(k:ProvidersConfigGroup):ProvidersConfigGroup        {
            return this._Str_3337 = k;
        }
public function  get__Str_4721():ProvidersConfigGroup
        {
            if (this._Str_3337 == null)
            {
                this._Str_3337 = new ProvidersConfigGroup();
            }
            return this._Str_3337;
        }

        public function getProvider(k:String):String
        {
            return this._Str_4721.getProvider(k);
        }

        
        public var rtmpProvider(get,set):String;
public function  set_rtmpProvider(k:String):String        {
            this._Str_4721.rtmpProvider = k;
return k;
        }
public function  get_rtmpProvider():String
        {
            return this._Str_4721.rtmpProvider;
        }

        
        public var httpProvider(get,set):String;
public function  set_httpProvider(k:String):String        {
            this._Str_4721.httpProvider = k;
return k;
        }
public function  get_httpProvider():String
        {
            return this._Str_4721.httpProvider;
        }

        
        public var turnOnCountdownTimer(get,set):Bool;
public function  set_turnOnCountdownTimer(k:Bool):Bool        {
            return this._Str_20878 = k;
        }
public function  get_turnOnCountdownTimer():Bool
        {
            return this._Str_20878;
        }

        
        public var player(get,set):ASObject;
public function  set_player(k:ASObject):ASObject        {
            return this._Str_4797 = k;
        }
public function  get_player():ASObject
        {
            return this._Str_4797;
        }

        
        public var stripFileExtensions(get,set):Bool;
public function  set_stripFileExtensions(k:Bool):Bool        {
            return this._Str_21723 = k;
        }
public function  get_stripFileExtensions():Bool
        {
            return this._Str_21723;
        }

        
        public var metaData(get,set):Bool;
public function  set_metaData(k:Bool):Bool        {
            return this._Str_3744 = k;
        }
public function  get_metaData():Bool
        {
            return this._Str_3744;
        }

        
        public var fireTrackingEvents(get,set):Bool;
public function  set_fireTrackingEvents(k:Bool):Bool        {
            return this._Str_6195 = k;
        }
public function  get_fireTrackingEvents():Bool
        {
            return this._Str_6195;
        }

        
        public var allowPlaylistControl(get,set):Bool;
public function  set_allowPlaylistControl(k:Bool):Bool        {
            return this._Str_11903 = k;
        }
public function  get_allowPlaylistControl():Bool
        {
            return this._Str_11903;
        }

        
        public var clearPlaylist(get,set):Bool;
public function  set_clearPlaylist(k:Bool):Bool        {
            return this._Str_20248 = k;
        }
public function  get_clearPlaylist():Bool
        {
            return this._Str_20248;
        }

        public function _Str_23304():Bool
        {
            return !(this._Str_11903 == _Str_14327);
        }

        
        public var playOnce(get,set):Bool;
public function  set_playOnce(k:Bool):Bool        {
            return this._Str_4538 = k;
        }
public function  get_playOnce():Bool
        {
            return this._Str_4538;
        }

        
        public var autoPlay(get,set):Bool;
public function  set_autoPlay(k:Bool):Bool        {
            return this._Str_3869 = k;
        }
public function  get_autoPlay():Bool
        {
            return this._Str_3869;
        }

        public function _Str_22516():Bool
        {
            return !(this._Str_4538 == _Str_15650);
        }

        
        public var deliveryType(get,set):String;
public function  set_deliveryType(k:String):String        {
            return this._Str_4101 = k;
        }
public function  get_deliveryType():String
        {
            return this._Str_4101;
        }

        public function _Str_19939():Bool
        {
            return !(this._Str_4101 == _Str_12597);
        }

        
        public var baseURL(get,set):String;
public function  get_baseURL():String
        {
            return this._Str_2846;
        }
public function  set_baseURL(k:String):String        {
            return this._Str_2846 = k;
        }

        public function _Str_20891():Bool
        {
            return !(this._Str_2846 == _Str_14458);
        }

        
        public var streamType(get,set):String;
public function  set_streamType(k:String):String        {
            return this._Str_4718 = k;
        }
public function  get_streamType():String
        {
            return this._Str_4718;
        }

        public function _Str_21706():Bool
        {
            return !(this._Str_4718 == _Str_15475);
        }

        
        public var subscribe(get,set):Bool;
public function  set_subscribe(k:Bool):Bool        {
            return this._Str_10343 = k;
        }
public function  get_subscribe():Bool
        {
            return this._Str_10343;
        }

        public function _Str_21260():Bool
        {
            return !(this._Str_10343 == _Str_12719);
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

        public function _Str_21448():Bool
        {
            if (Std.is(this._Str_4980 , String))
            {
                return true;
            }
            return ASCompat.toNumber(this._Str_4980) > -1;
        }
    }

