package org.openvideoads.events
;
    import flash.events.Event;

     class _Str_5692 extends Event 
    {
        public static inline final _Str_5406= "timed-out";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function clone():Event
        {
            return new _Str_5692(type, bubbles, cancelable);
        }
    }

