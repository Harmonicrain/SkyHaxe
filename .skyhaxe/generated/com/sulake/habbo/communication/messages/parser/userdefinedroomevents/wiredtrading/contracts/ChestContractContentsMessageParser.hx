package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;

    /** Exact July contract-contents parser. */
     class ChestContractContentsMessageParser implements IMessageParser
    {
        var _contractId:Int = 0;
        var _contractType:Int = 0;
        var _definition:TradeRequirementRulesDefinition;
        var _paymentMode:Int = 0;
        var _receiveText:String;
        var _layoutType:String;
        var _rewardCategory:Int = 0;
        var _showDialog:Bool = false;
        var _rewardText:String;

        public function flush():Bool
        {
            this._contractId = 0;
            this._contractType = 0;
            this._definition = null;
            this._paymentMode = 0;
            this._receiveText = null;
            this._layoutType = null;
            this._rewardCategory = 0;
            this._showDialog = false;
            this._rewardText = null;
            return true;
        }

        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable < 8) return false;
            this._contractId = data.readInteger();
            this._contractType = data.readShort();
            if (this._contractType < 0 || this._contractType > 2) return false;
            this._definition = TradeRequirementRulesDefinition.readFromMessage(data);
            if (this._contractType == 0)
            {
                this._paymentMode = data.readShort();
                this._receiveText = data.readString();
                this._layoutType = data.readString();
            }
            else if (this._contractType == 2)
            {
                this._rewardCategory = data.readShort();
                this._showDialog = data.readBoolean();
                this._rewardText = data.readString();
            }
            return data.bytesAvailable == 0;
        }

        public var contractId(get,never):Int;
public function  get_contractId():Int { return this._contractId; }
        public var contractType(get,never):Int;
public function  get_contractType():Int { return this._contractType; }
        public var definition(get,never):TradeRequirementRulesDefinition;
public function  get_definition():TradeRequirementRulesDefinition { return this._definition; }
        public var paymentMode(get,never):Int;
public function  get_paymentMode():Int { return this._paymentMode; }
        public var receiveText(get,never):String;
public function  get_receiveText():String { return this._receiveText; }
        public var layoutType(get,never):String;
public function  get_layoutType():String { return this._layoutType; }
        public var rewardCategory(get,never):Int;
public function  get_rewardCategory():Int { return this._rewardCategory; }
        public var showDialog(get,never):Bool;
public function  get_showDialog():Bool { return this._showDialog; }
        public var rewardText(get,never):String;
public function  get_rewardText():String { return this._rewardText; }

	public function new() {}
    }

