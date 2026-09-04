package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomModerationSettings
    {
        public static inline final MODERATION_LEVEL_NONE= 0;
        public static inline final MODERATION_LEVEL_USER_WITH_RIGHTS= 1;
        public static inline final MODERATION_LEVEL_ALL= 2;

        var _whoCanMute:Int = 0;
        var _whoCanKick:Int = 0;
        var _whoCanBan:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._whoCanMute = k.readInteger();
            this._whoCanKick = k.readInteger();
            this._whoCanBan = k.readInteger();
        }

        public var whoCanMute(get,never):Int;
function  get_whoCanMute():Int
        {
            return this._whoCanMute;
        }

        public var whoCanKick(get,never):Int;
function  get_whoCanKick():Int
        {
            return this._whoCanKick;
        }

        public var whoCanBan(get,never):Int;
function  get_whoCanBan():Int
        {
            return this._whoCanBan;
        }
    }

