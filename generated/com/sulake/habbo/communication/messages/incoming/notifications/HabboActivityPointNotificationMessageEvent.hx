package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.HabboActivityPointNotificationMessageParser;

     class HabboActivityPointNotificationMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboActivityPointNotificationMessageParser);
        }

        public var amount(get,never):Int;
function  get_amount():Int
        {
            return Std.downcast(_parser , HabboActivityPointNotificationMessageParser).amount;
        }

        public var change(get,never):Int;
function  get_change():Int
        {
            return Std.downcast(_parser , HabboActivityPointNotificationMessageParser).change;
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return Std.downcast(_parser , HabboActivityPointNotificationMessageParser).type;
        }
    }

