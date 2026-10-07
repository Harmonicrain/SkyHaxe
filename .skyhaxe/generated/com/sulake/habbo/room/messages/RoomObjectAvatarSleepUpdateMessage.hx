package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarSleepUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _isSleeping:Bool = false;

        public function new(k:Bool=false)
        {
            super();
            this._isSleeping = k;
        }

        public var isSleeping(get,never):Bool;
public function  get_isSleeping():Bool
        {
            return this._isSleeping;
        }
    }

