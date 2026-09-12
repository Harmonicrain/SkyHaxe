package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniRentOrBuyoutOfferMessageParser implements IMessageParser
    {
        var _Str_4167:Bool = false;
        var _Str_6880:String;
        var _buyout:Bool = false;
        var _priceInCredits:Int = 0;
        var _priceInActivityPoints:Int = 0;
        var _activityPointType:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_4167 = k.readBoolean();
            this._Str_6880 = k.readString();
            this._buyout = k.readBoolean();
            this._priceInCredits = k.readInteger();
            this._priceInActivityPoints = k.readInteger();
            this._activityPointType = k.readInteger();
            return true;
        }

        public var isWallItem(get,never):Bool;
public function  get_isWallItem():Bool
        {
            return this._Str_4167;
        }

        public var _Str_17878(get,never):String;
public function  get__Str_17878():String
        {
            return this._Str_6880;
        }

        public var buyout(get,never):Bool;
public function  get_buyout():Bool
        {
            return this._buyout;
        }

        public var priceInCredits(get,never):Int;
public function  get_priceInCredits():Int
        {
            return this._priceInCredits;
        }

        public var priceInActivityPoints(get,never):Int;
public function  get_priceInActivityPoints():Int
        {
            return this._priceInActivityPoints;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return this._activityPointType;
        }

	public function new() {}
    }

