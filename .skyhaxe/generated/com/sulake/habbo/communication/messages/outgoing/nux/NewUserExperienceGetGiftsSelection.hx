package com.sulake.habbo.communication.messages.outgoing.nux
;
     class NewUserExperienceGetGiftsSelection
    {
        var _dayIndex:Int = 0;
        var _stepIndex:Int = 0;
        var _giftIndex:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._dayIndex = k;
            this._stepIndex = _arg_2;
            this._giftIndex = _arg_3;
        }

        public var dayIndex(get,never):Int;
public function  get_dayIndex():Int
        {
            return this._dayIndex;
        }

        public var stepIndex(get,never):Int;
public function  get_stepIndex():Int
        {
            return this._stepIndex;
        }

        public var giftIndex(get,never):Int;
public function  get_giftIndex():Int
        {
            return this._giftIndex;
        }
    }

