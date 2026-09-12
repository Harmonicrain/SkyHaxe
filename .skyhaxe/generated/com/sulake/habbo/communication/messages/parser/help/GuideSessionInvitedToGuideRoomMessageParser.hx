package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionInvitedToGuideRoomMessageParser implements IMessageParser 
    {
        var _roomId:Int = 0;
        var _roomName:String = "";


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            this._roomName = k.readString();
            return true;
        }

        public function getRoomId():Int
        {
            return this._roomId;
        }

        public function getRoomName():String
        {
            return this._roomName;
        }

	public function new() {}
    }

