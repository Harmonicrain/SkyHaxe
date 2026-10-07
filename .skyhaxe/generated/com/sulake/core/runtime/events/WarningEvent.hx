package com.sulake.core.runtime.events
;
    import flash.events.Event;

     class WarningEvent extends Event 
    {
        var _message:String;

        public function new(type:String, message:String)
        {
            this._message = ((message == null) ? "undefined" : message);
            super(type);
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }
    }

