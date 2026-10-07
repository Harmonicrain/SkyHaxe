package com.sulake.core.runtime.events
;
    import flash.events.Event;
    import com.sulake.core.runtime.IUnknown;

     class UnknownEvent extends Event 
    {
        public var unknown:IUnknown;

        public function new(type:String, unknown:IUnknown)
        {
            this.unknown = unknown;
            super(type);
        }
    }

