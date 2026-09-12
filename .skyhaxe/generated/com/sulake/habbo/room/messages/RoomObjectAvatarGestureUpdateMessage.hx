package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarGestureUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _gesture:Int = 0;

        public function new(k:Int)
        {
            super();
            this._gesture = k;
        }

        public var gesture(get,never):Int;
public function  get_gesture():Int
        {
            return this._gesture;
        }
    }

