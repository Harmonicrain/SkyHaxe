package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;

     class WiredTradeInitiateMessageParser implements IMessageParser
    {
        var _requirement:TradeRequirement;
        var _showRequirementsImmediate:Bool = false;
        var _overridePreviousTrade:Bool = false;
        var _timeoutSeconds:Int = 0;

        public function flush():Bool
        {
            this._requirement = null;
            this._showRequirementsImmediate = false;
            this._overridePreviousTrade = false;
            this._timeoutSeconds = 0;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Bool
        {
            try
            {
                this._requirement = new TradeRequirement(data);
                this._showRequirementsImmediate = data.readBoolean();
                this._overridePreviousTrade = data.readBoolean();
                this._timeoutSeconds = data.readInteger();
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                return false;
            }
 }            return this._timeoutSeconds >= 0 && this._timeoutSeconds <= 86400
                && data.bytesAvailable == 0;
        }

        public var requirement(get,never):TradeRequirement;
public function  get_requirement():TradeRequirement { return this._requirement; }
        public var showRequirementsImmediate(get,never):Bool;
public function  get_showRequirementsImmediate():Bool
        { return this._showRequirementsImmediate; }
        public var overridePreviousTrade(get,never):Bool;
public function  get_overridePreviousTrade():Bool
        { return this._overridePreviousTrade; }
        public var timeoutSeconds(get,never):Int;
public function  get_timeoutSeconds():Int { return this._timeoutSeconds; }

	public function new() {}
    }

