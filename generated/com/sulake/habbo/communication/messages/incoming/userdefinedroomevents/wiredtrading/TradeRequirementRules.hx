package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July wrapped contract rule definition plus its optional multiplier field. */
     class TradeRequirementRules
    {
        var _definition:TradeRequirementRulesDefinition;
        var _type:Int = 0;
        var _multiplier:Int = 1;
        var _autoMultiplierMax:Int = 1;

        public function new(data:IMessageDataWrapper)
        {
            this._definition = TradeRequirementRulesDefinition.readFromMessage(data);
            this._type = data.readInteger();
            if (this._type == TradeRequirementTypes.FIXED_MULTIPLIER)
            {
                this._multiplier = data.readInteger();
            }
            else if (this._type == TradeRequirementTypes.AUTO_MULTIPLIER)
            {
                this._autoMultiplierMax = data.readInteger();
            }
        }

        public var youGiveRule(get,never):Vector<TradeRequirementRule>;
function  get_youGiveRule():Vector<TradeRequirementRule> { return this._definition.youGiveRule; }
        public var youGetRule(get,never):TradeRequirementRule;
function  get_youGetRule():TradeRequirementRule { return this._definition.youGetRule; }
        public var type(get,never):Int;
function  get_type():Int { return this._type; }
        public var multiplier(get,never):Int;
function  get_multiplier():Int { return this._multiplier; }
        public var autoMultiplierMax(get,never):Int;
function  get_autoMultiplierMax():Int { return this._autoMultiplierMax; }
    }

