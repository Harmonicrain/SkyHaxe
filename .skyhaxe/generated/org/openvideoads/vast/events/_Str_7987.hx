package org.openvideoads.vast.events
;
    import flash.events.Event;

     class _Str_7987 extends Event 
    {
        public static inline final TOGGLE= "toggle";

        var _Str_17473:Bool = false;

        public function new(k:String, _arg_2:Bool, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._Str_17473 = _arg_2;
        }

        public function _Str_25126():Bool
        {
            return this._Str_17473;
        }

        public function _Str_26053():Bool
        {
            return !this._Str_25126();
        }

        override public function clone():Event
        {
            return new _Str_7987(type, this._Str_17473, bubbles, cancelable);
        }
    }

