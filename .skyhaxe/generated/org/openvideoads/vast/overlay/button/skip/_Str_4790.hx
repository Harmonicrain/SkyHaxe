package org.openvideoads.vast.overlay.button.skip
;
    import flash.events.Event;

     class _Str_4790 extends Event 
    {
        public static inline final _Str_3831= "display-skip-button";
        public static inline final _Str_2703= "hide-skip-button";

        var _Str_2442:String = null;
        var _Str_668:String = null;
        var _Str_7282:ASFunction = null;

        public function new(k:String, _arg_2:String, _arg_3:String=null, _arg_4:ASFunction=null, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_5, _arg_6);
            this._Str_2442 = _arg_2;
            this._Str_668 = _arg_3;
            this._Str_7282 = _arg_4;
        }

        public var region(get,never):String;
public function  get_region():String
        {
            return this._Str_2442;
        }

        public var resource(get,never):String;
public function  get_resource():String
        {
            return this._Str_668;
        }

        public var _Str_25545(get,never):ASFunction;
public function  get__Str_25545():ASFunction
        {
            return this._Str_7282;
        }

        public function _Str_26221():Bool
        {
            return true;
        }

        public function _Str_19315():Bool
        {
            return false;
        }

        override public function clone():Event
        {
            return new _Str_4790(type, this._Str_2442, this._Str_668, this._Str_7282, bubbles, cancelable);
        }
    }

