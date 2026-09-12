package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarMutedUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _isMuted:Bool = false;

        public function new(k:Bool=false)
        {
            super();
            this._isMuted = k;
        }

        public var isMuted(get,never):Bool;
public function  get_isMuted():Bool
        {
            return this._isMuted;
        }
    }

