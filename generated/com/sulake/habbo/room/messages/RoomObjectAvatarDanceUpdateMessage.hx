package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarDanceUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _danceStyle:Int = 0;

        public function new(k:Int=0)
        {
            super();
            this._danceStyle = k;
        }

        public var _Str_8263(get,never):Int;
function  get__Str_8263():Int
        {
            return this._danceStyle;
        }
    }

