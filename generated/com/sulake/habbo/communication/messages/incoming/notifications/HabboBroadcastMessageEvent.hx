package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.HabboBroadcastMessageParser;

     class HabboBroadcastMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboBroadcastMessageParser);
        }

        public var messageText(get,never):String;
function  get_messageText():String
        {
            return Std.downcast(_parser , HabboBroadcastMessageParser).messageText;
        }

        public function getParser():HabboBroadcastMessageParser
        {
            return Std.downcast(_parser , HabboBroadcastMessageParser);
        }
    }

