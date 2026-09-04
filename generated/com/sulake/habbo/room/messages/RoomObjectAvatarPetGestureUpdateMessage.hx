package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarPetGestureUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _gesture:String;

        public function new(k:String)
        {
            super();
            this._gesture = k;
        }

        public var gesture(get,never):String;
function  get_gesture():String
        {
            return this._gesture;
        }
    }

