package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarChatUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _numberOfWords:Int = 0;

        public function new(k:Int)
        {
            super();
            this._numberOfWords = k;
        }

        public var numberOfWords(get,never):Int;
public function  get_numberOfWords():Int
        {
            return this._numberOfWords;
        }
    }

