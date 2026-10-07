package org.openvideoads.vast.events
;
    import flash.events.Event;

     class _Str_6977 extends Event 
    {
        public static inline final _Str_16488= "ova-control-bar-enable";
        public static inline final _Str_18397= "ova-control-bar-disable";
        public static inline final _Str_3824= "ova-control-bar-show";
        public static inline final _Str_2703= "ova-control-bar-hide";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function clone():Event
        {
            return new _Str_6977(type, bubbles, cancelable);
        }
    }

