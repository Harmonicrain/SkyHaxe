package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarSignUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _signType:Int = 0;

        public function new(k:Int)
        {
            super();
            this._signType = k;
        }

        public var signType(get,never):Int;
public function  get_signType():Int
        {
            return this._signType;
        }
    }

