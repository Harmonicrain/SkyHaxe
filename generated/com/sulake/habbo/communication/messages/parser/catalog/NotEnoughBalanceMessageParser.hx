package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NotEnoughBalanceMessageParser implements IMessageParser
    {
        var _Str_17433:Bool = false;
        var _Str_19031:Bool = false;
        var _activityPointType:Int = 0;


        public var notEnoughCredits(get,never):Bool;
function  get_notEnoughCredits():Bool
        {
            return this._Str_17433;
        }

        public var _Str_24352(get,never):Bool;
function  get__Str_24352():Bool
        {
            return this._Str_19031;
        }

        public var activityPointType(get,never):Int;
function  get_activityPointType():Int
        {
            return this._activityPointType;
        }

        public function flush():Bool
        {
            this._Str_17433 = false;
            this._Str_19031 = false;
            this._activityPointType = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_17433 = k.readBoolean();
            this._Str_19031 = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._activityPointType = k.readInteger();
            }
            return true;
        }

	public function new() {}
    }

