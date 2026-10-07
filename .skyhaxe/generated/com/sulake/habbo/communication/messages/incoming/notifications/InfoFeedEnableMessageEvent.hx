package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.InfoFeedEnableMessageParser;

     class InfoFeedEnableMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, InfoFeedEnableMessageParser);
        }

        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return Std.downcast(_parser , InfoFeedEnableMessageParser).enabled;
        }
    }

