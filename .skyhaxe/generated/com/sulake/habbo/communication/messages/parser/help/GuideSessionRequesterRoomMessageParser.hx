package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionRequesterRoomMessageParser implements IMessageParser 
    {
        var _requesterRoomId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._requesterRoomId = k.readInteger();
            return true;
        }

        public function getRequesterRoomId():Int
        {
            return this._requesterRoomId;
        }

	public function new() {}
    }

