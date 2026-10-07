package org.openvideoads.base
;
    import org.openvideoads.util.ObjectUtils;
    import org.openvideoads.util.StringUtils;

     class Debuggable 
    {
        public static var _Str_17390:Int = -1;
        public static var _Str_15476:Int = 0;
        public static var _Str_11519:Int = 1;
        public static var _Str_17922:Int = 2;
        public static var _Str_17928:Int = 4;
        public static var _Str_15983:Int = 8;
        public static var _Str_18879:Int = 16;
        public static var _Str_17292:Int = 32;
        public static var _Str_16607:Int = 64;
        public static var _Str_17262:Int = 128;
        public static var _Str_18937:Int = 0x0100;
        public static var _Str_16003:Int = 0x0200;
        public static var _Str_16591:Int = 0x0400;
        public static var _Str_12852:Int = 0x0800;
        public static var _Str_22030:Int = 0x0800;
        public static var _Str_16580:Int = 0x1000;
        public static var _Str_17920:Int = 0x2000;
        public static var _Str_18777:Int = 0x4000;
        public static var _Str_17322:Int = 0x8000;
        public static var _Str_16103:Int = 65536;
        public static var _Str_17063:Int = 131072;
        public static var _Str_18509:Int = 262144;
        public static var _Str_16704:Int = 524288;
        static var _Str_2456:Int = 0;
        static var _Str_14737:String = "firebug";
        public static var _Str_1229:Debuggable;

        var _uid:String = null;

        public function new()
        {
            this._uid = ObjectUtils._Str_22043();
        }

        public static function getInstance():Debuggable
        {
            if (_Str_1229 == null)
            {
                _Str_1229 = Type.createInstance(Debuggable, []);
            }
            return _Str_1229;
        }


        public function _Str_26207(k:ASObject)
        {
            if (((!(k == null)) && (Std.is(k , String) == false)))
            {
                if (k.levels != /*undefined*/null)
                {
                    this.setLevelFromString(k.levels);
                }
                if (k.debugger != /*undefined*/null)
                {
                    this.activeDebuggers = k.debugger;
                }
            }
        }

        
public var uid(get,set):String;
public function  get_uid():String
        {
            return this._uid;
        }

        public var level(never,set):Int;
public function  set_level(k:Int):Int        {
            return _Str_2456 = k;
        }

        public function _Str_26279(k:Int=1):Bool
        {
            return (k == Debuggable._Str_17390) || ((!(_Str_2456 == Debuggable._Str_15476)) && (((_Str_2456 == Debuggable._Str_11519) || (k == Debuggable._Str_11519)) || ((_Str_2456 & k) != 0)));
        }

        public var activeDebuggers(never,set):String;
public function  set_activeDebuggers(k:String):String        {
            return _Str_14737 = k;
        }

        public function setLevelFromString(k:String)
        {
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            var _local_4 = 0;
            if (this.setLevelFromString != null)
            {
                _local_2 = (cast new compat.RegExp(",").split(k));
                if (_local_2.length > 0)
                {
                    _local_3 = 0;
                    _local_4 = 0;
                    while (_local_4 < _local_2.length)
                    {
                        switch (StringUtils.trim(_local_2[_local_4]).toUpperCase())
                        {
                            case "NONE":
                                _local_3 = (_local_3 | _Str_15476);
                                
                            case "ALL":
                                _local_3 = (_local_3 | _Str_11519);
                                
                            case "VAST_TEMPLATE":
                                _local_3 = (_local_3 | _Str_17922);
                                
                            case "CUEPOINT_EVENTS":
                                _local_3 = (_local_3 | _Str_17928);
                                
                            case "SEGMENT_FORMATION":
                                _local_3 = (_local_3 | _Str_15983);
                                
                            case "REGION_FORMATION":
                                _local_3 = (_local_3 | _Str_18879);
                                
                            case "CUEPOINT_FORMATION":
                                _local_3 = (_local_3 | _Str_17292);
                                
                            case "CONFIG":
                                _local_3 = (_local_3 | _Str_16607);
                                
                            case "CLICKTHROUGH_EVENTS":
                                _local_3 = (_local_3 | _Str_17262);
                                
                            case "DATA_ERROR":
                                _local_3 = (_local_3 | _Str_18937);
                                
                            case "HTTP_CALLS":
                                _local_3 = (_local_3 | _Str_16003);
                                
                            case "FATAL":
                                _local_3 = (_local_3 | _Str_16591);
                                
                            case "VPAID":
                                _local_3 = (_local_3 | _Str_12852);
                                
                            case "MOUSE_EVENTS":
                                _local_3 = (_local_3 | _Str_16580);
                                
                            case "PLAYLIST":
                                _local_3 = (_local_3 | _Str_17920);
                                
                            case "JAVASCRIPT":
                                _local_3 = (_local_3 | _Str_18777);
                                
                            case "API":
                                _local_3 = (_local_3 | _Str_17322);
                                
                            case "TRACKING_TABLE":
                                _local_3 = (_local_3 | _Str_16103);
                                
                            case "DISPLAY_EVENTS":
                                _local_3 = (_local_3 | _Str_17063);
                                
                            case "ANALYTICS":
                                _local_3 = (_local_3 | _Str_18509);
                                
                            case "TRACKING_EVENTS":
                                _local_3 = (_local_3 | _Str_16704);
                                
                        }
                        _local_4++;
                    }
                    this.level = _local_3;
                }
            }
        }

        public function _Str_25882(k:Int=1)
        {
        }

        public function _Str_16801(k:String, _arg_2:Int=1)
        {
        }

        public function _Str_19580(k:ASObject, _arg_2:Int=1)
        {
        }

        public function toJSObject():ASObject
        {
            return new ASObject();
        }
public 
function  set_uid(k:String):String{throw "Accessor unavailable on base instance: uid"; return k;
}    }

