package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ClubGiftData
    {
        var _offerId:Int = 0;
        var _isVip:Bool = false;
        var _Str_693:Bool = false;
        var _Str_19803:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._offerId = k.readInteger();
            this._isVip = k.readBoolean();
            this._Str_19803 = k.readInteger();
            this._Str_693 = k.readBoolean();
        }

        public var offerId(get,never):Int;
function  get_offerId():Int
        {
            return this._offerId;
        }

        public var _Str_12313(get,never):Bool;
function  get__Str_12313():Bool
        {
            return this._isVip;
        }

        public var isSelectable(get,never):Bool;
function  get_isSelectable():Bool
        {
            return this._Str_693;
        }

        public var _Str_21146(get,never):Int;
function  get__Str_21146():Int
        {
            return this._Str_19803;
        }
    }

