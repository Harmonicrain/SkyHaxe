package com.sulake.habbo.communication.messages.parser.marketplace
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MarketplaceConfigurationMessageParser implements IMessageParser 
    {
        var _enabled:Bool = false;
        var _commission:Int = 0;
        var _credits:Int = 0;
        var _advertisements:Int = 0;
        var _maximumPrice:Int = 0;
        var _minimumPrice:Int = 0;
        var _offerTime:Int = 0;
        var _displayTime:Int = 0;


        public var enabled(get,never):Bool;
public function  get_enabled():Bool
        {
            return this._enabled;
        }

        public var commission(get,never):Int;
public function  get_commission():Int
        {
            return this._commission;
        }

        public var credits(get,never):Int;
public function  get_credits():Int
        {
            return this._credits;
        }

        public var advertisements(get,never):Int;
public function  get_advertisements():Int
        {
            return this._advertisements;
        }

        public var minimumPrice(get,never):Int;
public function  get_minimumPrice():Int
        {
            return this._minimumPrice;
        }

        public var maximumPrice(get,never):Int;
public function  get_maximumPrice():Int
        {
            return this._maximumPrice;
        }

        public var offerTime(get,never):Int;
public function  get_offerTime():Int
        {
            return this._offerTime;
        }

        public var displayTime(get,never):Int;
public function  get_displayTime():Int
        {
            return this._displayTime;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._enabled = k.readBoolean();
            this._commission = k.readInteger();
            this._credits = k.readInteger();
            this._advertisements = k.readInteger();
            this._minimumPrice = k.readInteger();
            this._maximumPrice = k.readInteger();
            this._offerTime = k.readInteger();
            this._displayTime = k.readInteger();
            return true;
        }

	public function new() {}
    }

