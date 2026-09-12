package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomChatSettingsMessageParser implements IMessageParser 
    {
        var _chatSettings:RoomChatSettings;


        public function flush():Bool
        {
            this._chatSettings = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._chatSettings = new RoomChatSettings(k);
            return true;
        }

        public var chatSettings(get,never):RoomChatSettings;
public function  get_chatSettings():RoomChatSettings
        {
            return this._chatSettings;
        }

	public function new() {}
    }

