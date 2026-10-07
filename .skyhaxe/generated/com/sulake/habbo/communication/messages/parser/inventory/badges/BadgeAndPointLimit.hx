package com.sulake.habbo.communication.messages.parser.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BadgeAndPointLimit
    {
        var _badgeId:String;
        var _limit:Int = 0;

        public function new(k:String, _arg_2:IMessageDataWrapper)
        {
            this._badgeId = (("ACH_" + k) + Std.string(_arg_2.readInteger()));
            this._limit = _arg_2.readInteger();
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var limit(get,never):Int;
public function  get_limit():Int
        {
            return this._limit;
        }
    }

