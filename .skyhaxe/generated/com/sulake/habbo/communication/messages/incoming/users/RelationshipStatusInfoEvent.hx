package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.RelationshipStatusInfoMessageParser;
    import com.sulake.core.utils.Map;

     class RelationshipStatusInfoEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RelationshipStatusInfoMessageParser);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return Std.downcast(_parser , RelationshipStatusInfoMessageParser).userId;
        }

        public var relationshipStatusMap(get,never):Map;
public function  get_relationshipStatusMap():Map
        {
            return Std.downcast(_parser , RelationshipStatusInfoMessageParser).relationshipStatusMap;
        }
    }

