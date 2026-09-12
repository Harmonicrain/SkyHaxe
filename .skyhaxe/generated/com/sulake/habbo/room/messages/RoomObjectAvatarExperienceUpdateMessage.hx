package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarExperienceUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _gainedExperience:Int = 0;

        public function new(k:Int)
        {
            super();
            this._gainedExperience = k;
        }

        public var _Str_18578(get,never):Int;
public function  get__Str_18578():Int
        {
            return this._gainedExperience;
        }
    }

