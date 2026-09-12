package org.openvideoads.vast.schedule.ads.templates
;
    import org.openvideoads.base.Debuggable;
    import flash.display.DisplayObject;
    import org.openvideoads.vast.model.NonLinearVideoAd;

     class _Str_3048 extends Debuggable 
    {
        public static inline final _Str_6497= "html5";
        public static inline final FLASH= "flash";

        var _Str_2620:String = "_code_";
        var _Str_3875:DisplayObject = null;
        var _Str_4491:String = "flash";

        public function new(k:String="flash", _arg_2:String=null)
        {
            super();
            this._Str_4491 = k;
            if (_arg_2 != null)
            {
                this._Str_2620 = _arg_2;
            }
        }

        function replace(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_4= new compat.RegExp((("_" + _arg_2) + "_"), "g");
            return _local_4.replace(k, _arg_3);
        }

        public function getContent(k:NonLinearVideoAd):String
        {
            if (k != null)
            {
                if (k._Str_3937())
                {
                    return this.replace(this._Str_2620, "code", k.codeBlock);
                }
                if (k.url != null)
                {
                    return this.replace(this._Str_2620, "code", k.url.url);
                }
                return "";
            }
            return "Non-linear video ad not available";
        }

        
        public var template(get,set):String;
public function  set_template(k:String):String        {
            return this._Str_2620 = k;
        }
public function  get_template():String
        {
            return this._Str_2620;
        }
    }

