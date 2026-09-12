package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarEffectUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _effect:Int = 0;
        var _delayMilliSeconds:Int = 0;

        public function new(k:Int=0, _arg_2:Int=0)
        {
            super();
            this._effect = k;
            this._delayMilliSeconds = _arg_2;
        }

        public var effect(get,never):Int;
public function  get_effect():Int
        {
            return this._effect;
        }

        public var delayMilliSeconds(get,never):Int;
public function  get_delayMilliSeconds():Int
        {
            return this._delayMilliSeconds;
        }
    }

