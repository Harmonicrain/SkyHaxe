package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.IgnoreResultMessageParser;

     class IgnoreResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IgnoreResultMessageParser);
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return Std.downcast(_parser , IgnoreResultMessageParser).result;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return Std.downcast(_parser , IgnoreResultMessageParser).name;
        }
    }

