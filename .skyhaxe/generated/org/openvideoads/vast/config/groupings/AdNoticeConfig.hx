package org.openvideoads.vast.config.groupings
;
    import org.openvideoads.base.Debuggable;

     class AdNoticeConfig extends Debuggable 
    {
        public static var _Str_16878:String = "normaltext";
        public static var _Str_20733:String = "smalltext";
        public static var _Str_19027:String = "<p class='_textclass_' align='right'>This advertisement runs for _seconds_ seconds</p>";
        public static var _Str_18131:String = "<p class='_textclass_' align='right'>This advertisement runs for _countdown_ seconds</p>";

        var _Str_20745:Bool = true;
        var _message:String = null;
        var _Str_2442:String = "reserved-system-message";
        var _Str_15582:String;
        var _type:String = "STATIC";

        public function new(k:ASObject=null)
        {
            this._Str_15582 = _Str_16878;
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (ASCompat.hasOwnProperty(k, "show"))
            {
                this.show = k.show;
            }
            if (ASCompat.hasOwnProperty(k, "type"))
            {
                this.type = k.type;
            }
            if (ASCompat.hasOwnProperty(k, "region"))
            {
                this.region = k.region;
            }
            if (ASCompat.hasOwnProperty(k, "textStyle"))
            {
                this.textStyle = k.textStyle;
            }
            if (ASCompat.hasOwnProperty(k, "message"))
            {
                this.message = k.message;
            }
        }

        
        public var type(get,set):String;
public function  set_type(k:String):String        {
            if (k != null)
            {
                if (k.toUpperCase() == "STATIC")
                {
                    this._type = "STATIC";
                }
                else
                {
                    this._type = "COUNTDOWN";
                }
            }
return k;
        }
public function  get_type():String
        {
            return this._type;
        }

        public function _Str_23309():Bool
        {
            return this._message.indexOf("_countdown_") > -1;
        }

        public function isStatic():Bool
        {
            return !this._Str_23309();
        }

        
        public var show(get,set):Bool;
public function  set_show(k:Bool):Bool        {
            return this._Str_20745 = k;
        }
public function  get_show():Bool
        {
            return this._Str_20745;
        }

        
        public var message(get,set):String;
public function  set_message(k:String):String        {
            return this._message = k;
        }
public function  get_message():String
        {
            if (this._message == null)
            {
                if (this._type == "STATIC")
                {
                    this._message = _Str_19027;
                }
                else
                {
                    this._message = _Str_18131;
                }
            }
            var k= new compat.RegExp("_textclass_", "g");
            return k.replace(this._message, this._Str_15582);
        }

        
        public var textStyle(get,set):String;
public function  get_textStyle():String
        {
            return this._Str_15582;
        }
public function  set_textStyle(k:String):String        {
            return this._Str_15582 = k;
        }

        
        public var region(get,set):String;
public function  set_region(k:String):String        {
            return this._Str_2442 = k;
        }
public function  get_region():String
        {
            return this._Str_2442;
        }
    }

