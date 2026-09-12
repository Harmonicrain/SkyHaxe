package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarPlayerValueUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _value:Int = 0;

        public function new(k:Int)
        {
            super();
            this._value = k;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            return this._value;
        }
    }

