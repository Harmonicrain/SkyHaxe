package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.RespectNotificationMessageParser;

     class RoomUserRespect extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RespectNotificationMessageParser);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return Std.downcast(_parser , RespectNotificationMessageParser).userId;
        }

        public var respectTotal(get,never):Int;
public function  get_respectTotal():Int
        {
            return Std.downcast(_parser , RespectNotificationMessageParser).respectTotal;
        }
    }

