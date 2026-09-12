package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class ProvidersConfigGroup extends Debuggable 
    {
        var _Str_16603:String = "http";
        var _Str_21342:String = null;
        var _Str_17754:String = "rtmp";
        var _Str_21726:String = null;
        var _Str_26468:Bool = false;
        var _Str_21699:Bool = false;

        public function new(k:ASObject=null)
        {
            super();
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
                if (k.enforceSettingSubscribeRTMP != /*undefined*/null)
                {
                    if (Std.is(k.enforceSettingSubscribeRTMP , String))
                    {
                        this.enforceSettingSubscribeRTMP = ((k.enforceSettingSubscribeRTMP.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.enforceSettingSubscribeRTMP = k.enforceSettingSubscribeRTMP;
                    }
                }
                if (k.rtmpSubscribe != /*undefined*/null)
                {
                    if (Std.is(k.rtmpSubscribe , String))
                    {
                        this.rtmpSubscribe = ((k.rtmpSubscribe.toUpperCase() == "TRUE") ? true : false);
                    }
                    else
                    {
                        this.rtmpSubscribe = k.rtmpSubscribe;
                    }
                }
            }
        }

        public function getProvider(k:String):String
        {
            switch (k.toUpperCase())
            {
                case "RTMP":
                    return this.rtmpProvider;
                case "HTTP":
                    return this.httpProvider;
            }
            return null;
        }

        public function _Str_21970(k:String):String
        {
            switch (k.toUpperCase())
            {
                case "RTMP":
                    return this._Str_10294;
                case "HTTP":
                    return this._Str_10463;
            }
            return null;
        }

        
        public var httpProvider(get,set):String;
public function  set_httpProvider(k:ASAny):String        {
            if (Std.is(k , String))
            {
                this._Str_16603 = k;
            }
            else
            {
                if (k.type != /*undefined*/null)
                {
                    this._Str_16603 = k.type;
                    if (k.streamer != /*undefined*/null)
                    {
                        this._Str_10463 = k.streamer;
                    }
                }
            }
return k;
        }
public function  get_httpProvider():String
        {
            return this._Str_16603;
        }

        
        public var rtmpProvider(get,set):String;
public function  set_rtmpProvider(k:ASAny):String        {
            if (Std.is(k , String))
            {
                this._Str_17754 = k;
            }
            else
            {
                if (k.type != /*undefined*/null)
                {
                    this._Str_17754 = k.type;
                    if (k.streamer != /*undefined*/null)
                    {
                        this._Str_10294 = k.streamer;
                    }
                }
            }
return k;
        }
public function  get_rtmpProvider():String
        {
            return this._Str_17754;
        }

        
        public var _Str_10463(get,set):String;
public function  set__Str_10463(k:String):String        {
            return this._Str_21342 = k;
        }
public function  get__Str_10463():String
        {
            return this._Str_21342;
        }

        
        public var _Str_10294(get,set):String;
public function  set__Str_10294(k:String):String        {
            return this._Str_21726 = k;
        }
public function  get__Str_10294():String
        {
            return this._Str_21726;
        }

        
        public var rtmpSubscribe(get,set):Bool;
public function  set_rtmpSubscribe(k:Bool):Bool        {
            return this._Str_26468 = k;
        }
public function  get_rtmpSubscribe():Bool
        {
            return this._Str_26468;
        }

        
        public var enforceSettingSubscribeRTMP(get,set):Bool;
public function  set_enforceSettingSubscribeRTMP(k:Bool):Bool        {
            return this._Str_21699 = k;
        }
public function  get_enforceSettingSubscribeRTMP():Bool
        {
            return this._Str_21699;
        }
    }

