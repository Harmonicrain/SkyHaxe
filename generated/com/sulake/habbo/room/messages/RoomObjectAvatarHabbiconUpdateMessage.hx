package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarHabbiconUpdateMessage extends RoomObjectUpdateStateMessage
    {
        var _habbiconId:Int = 0;

        public function new(habbiconId:Int)
        {
            super();
            this._habbiconId = habbiconId;
        }

        public var habbiconId(get,never):Int;
function  get_habbiconId():Int
        {
            return this._habbiconId;
        }
    }

