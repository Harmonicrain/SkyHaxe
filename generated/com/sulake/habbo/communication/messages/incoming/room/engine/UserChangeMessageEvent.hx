package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.UserChangeMessageParser;

     class UserChangeMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserChangeMessageParser);
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return Std.downcast(_parser , UserChangeMessageParser).id;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return Std.downcast(_parser , UserChangeMessageParser).figure;
        }

        public var sex(get,never):String;
function  get_sex():String
        {
            return Std.downcast(_parser , UserChangeMessageParser).sex;
        }

        public var customInfo(get,never):String;
function  get_customInfo():String
        {
            return Std.downcast(_parser , UserChangeMessageParser).customInfo;
        }

        public var activityPoints(get,never):Int;
function  get_activityPoints():Int
        {
            return Std.downcast(_parser , UserChangeMessageParser).activityPoints;
        }
    }

