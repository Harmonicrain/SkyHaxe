package com.sulake.habbo.messenger.events
;
    import flash.events.Event;

     class NewMessageEvent extends Event 
    {
        public static inline final FBE_MESSAGE= "FBE_MESSAGE";

        public var notify:Bool = false;
        public var senderId:Int = 0;

        public function new(k:Bool, _arg_2:Int)
        {
            super(FBE_MESSAGE, false, false);
            this.notify = k;
            this.senderId = _arg_2;
        }
    }

