package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;
    import flash.net.URLLoader;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.AsyncErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.events.TimerEvent;
    import flash.events.*;
    import flash.net.*;

     class NetworkResource extends Debuggable 
    {
        var _id:String = null;
        var _Str_577:String = null;
        var _Str_2230:String = null;
        var _loader:URLLoader;
        var _Str_2850:Timer = null;

        public function new(k:String=null, _arg_2:String=null, _arg_3:String=null)
        {
            this._loader = new URLLoader();
            super();
            this._id = k;
            this.url = _arg_2;
            this._Str_2230 = _arg_3;
        }

        public static function _Str_12788(k:String):String
        {
            var _local_2:Array<ASAny> = null;
            if (k != null)
            {
                if (StringUtils._Str_4861(k, "http://localhost"))
                {
                    return "localhost";
                }
                _local_2 = (cast k.split("/"));
                if (StringUtils._Str_4861(k, "http"))
                {
                    if (_local_2.length >= 3)
                    {
                        return _local_2[2];
                    }
                }
                else
                {
                    return _local_2[0];
                }
            }
            return null;
        }

        public static function _Str_26293(k:String, _arg_2:String):String
        {
            if (_arg_2 == null)
            {
                return null;
            }
            if (_Str_21455(_arg_2))
            {
                return _arg_2;
            }
            if (_arg_2.indexOf("/") == 0)
            {
                return _arg_2;
            }
            if ((((k == "") || (k == null)) || (k == "null")))
            {
                return _arg_2;
            }
            if (k != null)
            {
                if (k.lastIndexOf("/") == (k.length - 1))
                {
                    return k + _arg_2;
                }
                return (k + "/") + _arg_2;
            }
            return _arg_2;
        }

        public static function _Str_26166(k:String, _arg_2:String):String
        {
            if (StringUtils._Str_17635(k, "/"))
            {
                return k + _arg_2;
            }
            return (k + "/") + _arg_2;
        }

        public static function _Str_21455(k:String):Bool
        {
            if (!ASCompat.stringAsBool(k))
            {
                return false;
            }
            return k.indexOf("://") > 0;
        }

        public static function _Str_24693(k:String, _arg_2:String):String
        {
            if (k.indexOf("?") > 0)
            {
                return (k + "&") + _arg_2;
            }
            return (k + "?") + _arg_2;
        }


        public function close()
        {
            if (this._loader != null)
            {
                try
                {
                    this._loader.close();
                    this._loader = null;
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        
        public var id(get,set):String;
public function  set_id(k:String):String        {
            return this._id = k;
        }
public function  get_id():String
        {
            return this._id;
        }

        
        public var url(get,set):String;
public function  set_url(k:String):String        {
            this._Str_577 = StringUtils._Str_21602(StringUtils.trim(k));
return k;
        }
public function  get_url():String
        {
            return this._Str_577;
        }

        public function _Str_4309():Bool
        {
            if (this._Str_577 != null)
            {
                return StringUtils.trim(this._Str_577).length > 0;
            }
            return false;
        }

        public function _Str_17899():Bool
        {
            return !(this._Str_2230 == null);
        }

        
        public var mimeType(get,set):String;
public function  set_mimeType(k:String):String        {
            return this._Str_2230 = k;
        }
public function  get_mimeType():String
        {
            return this._Str_2230;
        }

        public function isMimeType(k:String):Bool
        {
            if (this._Str_2230 != null)
            {
                return StringUtils._Str_2576(k, this._Str_2230);
            }
            return false;
        }

        public function _Str_14494(k:String):Bool
        {
            var _local_2 = 0;
            if (this._Str_577 != null)
            {
                _local_2 = this._Str_577.lastIndexOf(".");
                return StringUtils._Str_2576(this._Str_577.substr(_local_2), k);
            }
            return false;
        }

        public var qualifiedHTTPUrl(get,never):String;
public function  get_qualifiedHTTPUrl():String
        {
            if (!this._Str_11386())
            {
                return "http://" + StringUtils.trim(this._Str_577);
            }
            return this._Str_577;
        }

        public var qualifiedUrl(get,never):String;
public function  get_qualifiedUrl():String
        {
            return this.qualifiedHTTPUrl;
        }

        public function _Str_18045():Bool
        {
            if (this._Str_577 != null)
            {
                return this._Str_577.indexOf("mp4:") > -1;
            }
            return false;
        }

        public function _Str_17691():Bool
        {
            if (this._Str_577 != null)
            {
                return this._Str_577.indexOf("flv:") > -1;
            }
            return false;
        }

        public function _Str_19279():Bool
        {
            if (this._Str_577 != null)
            {
                return this._Str_18045() || this._Str_17691();
            }
            return false;
        }

        public var data(get,never):String;
public function  get_data():String
        {
            return this._loader.data;
        }

        public function _Str_11386():Bool
        {
            if (this._Str_577 != null)
            {
                return ((this._Str_577.indexOf("http://") > -1) || (this._Str_577.indexOf("https://") > -1)) || (this._Str_577.indexOf("rtmp://") > -1);
            }
            return false;
        }

        public function getQualifiedStreamAddress(k:String=null):String
        {
            if (this._Str_11386())
            {
                return this._Str_577;
            }
            if (k != null)
            {
                return k + this._Str_577;
            }
            return this._Str_577;
        }

        public function _Str_5059(k:String=null):String
        {
            var _local_2 = 0;
            var _local_3 = 0;
            if (this._Str_577 != null)
            {
                if (k != null)
                {
                    _local_2 = this._Str_577.indexOf(k);
                    if (_local_2 == -1)
                    {
                        return this._Str_577;
                    }
                    return this._Str_577.substr(_local_2);
                }
                _local_3 = this._Str_577.lastIndexOf("/");
                if (_local_3 == -1)
                {
                    return this._Str_577;
                }
                return this._Str_577.substr((_local_3 + 1));
            }
            return null;
        }

        public var netConnectionAddress(get,never):String;
public function  get_netConnectionAddress():String
        {
            if (this._Str_577 != null)
            {
                if (this._Str_577.indexOf("mp4:") > 0)
                {
                    return this._Str_577.substr(0, this._Str_577.indexOf("mp4:"));
                }
                if (this._Str_577.indexOf("flv:") > 0)
                {
                    return this._Str_577.substr(0, this._Str_577.indexOf("flv:"));
                }
            }
            return null;
        }

        public function isRTMP():Bool
        {
            if (this._Str_577 != null)
            {
                return this._Str_577.indexOf("rtmp") > -1;
            }
            return false;
        }

        public function _Str_26427():String
        {
            var k = 0;
            if (this._Str_577 != null)
            {
                k = this._Str_577.lastIndexOf("/");
                if (k == -1)
                {
                    return null;
                }
                return this._Str_577.substr(0, (k + 1));
            }
            return null;
        }

        public function isStream():Bool
        {
            var k= this._Str_5059();
            var _local_2= new compat.RegExp("(?i).*\\.(mp4|flv|wmv|mp3|3g2|3gp|aac|f4b|f4p|f4v|m4a|m4v|mov|sdp)");
            return !(ASCompat.stringMatch(k, _local_2)== null);
        }

        public function _Str_24492():Bool
        {
            var k= this._Str_5059();
            if (k != null)
            {
                return k.indexOf("(live)") > -1;
            }
            return false;
        }

        public function _Str_23740():String
        {
            var k:String = null;
            if (this._Str_24492())
            {
                k = this._Str_5059();
                return k.substr((k.lastIndexOf("(live)") + 6));
            }
            return null;
        }

        public function call(k:Int=-1)
        {
            if (this._Str_577 != null)
            {
                if (StringUtils.trim(this._Str_577).length > 0)
                {
                    this._loader = new URLLoader();
                    this._loader.addEventListener(Event.COMPLETE, (this._Str_23054 : ASAny));
                    this._loader.addEventListener(ErrorEvent.ERROR, (this.errorHandler : ASAny));
                    this._loader.addEventListener(AsyncErrorEvent.ASYNC_ERROR, (this.errorHandler : ASAny));
                    this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, (this.errorHandler : ASAny));
                    this._loader.addEventListener(IOErrorEvent.IO_ERROR, (this.errorHandler : ASAny));
                    if (k > 0)
                    {
                        this._Str_8612((k * 1000));
                    }
                    this._loader.load(new URLRequest(this._Str_577));
                }
            }
        }

        function _Str_8612(k:Int)
        {
            if (this._Str_2850 != null)
            {
                this._Str_4743();
            }
            if (k > 0)
            {
                this._Str_2850 = new Timer(k, 1);
                this._Str_2850.addEventListener(TimerEvent.TIMER, (this._Str_17789 : ASAny));
                this._Str_2850.start();
            }
        }

        function _Str_4743()
        {
            if (this._Str_2850 != null)
            {
                this._Str_2850.stop();
                this._Str_2850 = null;
            }
        }

        function _Str_17789(k:TimerEvent)
        {
            this._Str_4743();
            this.close();
        }

        function _Str_23054(k:Event)
        {
            if (this._loader != null)
            {
                this.loadComplete(this._loader.data);
            }
        }

        function errorHandler(k:Event)
        {
            this.close();
        }

        function loadComplete(k:String)
        {
            this.close();
        }

        public function clone():NetworkResource
        {
            return new NetworkResource(this._id, this._Str_577);
        }

        override public function toJSObject():ASObject
        {
            var k:ASObject = new ASObject();
            k = {
                "id":this._id,
                "uid":_uid,
                "url":this._Str_577,
                "mimeType":this._Str_2230
            }
;            return k;
        }
    }

