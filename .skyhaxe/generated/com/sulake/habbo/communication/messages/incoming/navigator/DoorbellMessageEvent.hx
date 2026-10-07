package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.DoorbellMessageParser;

     class DoorbellMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, DoorbellMessageParser);
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return Std.downcast(this._parser , DoorbellMessageParser).userName;
        }
    }

