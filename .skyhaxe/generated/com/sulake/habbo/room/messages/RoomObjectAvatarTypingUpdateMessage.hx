package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarTypingUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _isTyping:Bool = false;

        public function new(k:Bool=false)
        {
            super();
            this._isTyping = k;
        }

        public var isTyping(get,never):Bool;
public function  get_isTyping():Bool
        {
            return this._isTyping;
        }
    }

