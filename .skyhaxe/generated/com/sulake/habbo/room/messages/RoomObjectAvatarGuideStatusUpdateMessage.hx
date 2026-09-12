package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarGuideStatusUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _guideStatus:Int = 0;

        public function new(k:Int)
        {
            super();
            this._guideStatus = k;
        }

        public var guideStatus(get,never):Int;
public function  get_guideStatus():Int
        {
            return this._guideStatus;
        }
    }

