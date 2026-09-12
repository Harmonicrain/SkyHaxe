package deng.fzip
;
    import flash.events.Event;

     class _Str_897 extends Event 
    {
        public static inline final PARSEERROR= "parseError";

        public var text:String;

        public function new(k:String, _arg_2:String="", _arg_3:Bool=false, _arg_4:Bool=false)
        {
            this.text = _arg_2;
            super(k, _arg_3, _arg_4);
        }

        override public function clone():Event
        {
            return new _Str_897(type, this.text, bubbles, cancelable);
        }
    }

