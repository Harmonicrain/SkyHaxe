package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * July AIR's contract shown when a Wired Trading session starts.
     * The rule payload exists only for TYPE_RULES.
     */
     class TradeRequirement
    {
        public static inline final TYPE_CREDIT_FURNI= 0;
        public static inline final TYPE_NORMAL_FURNI= 1;
        public static inline final TYPE_ANY_FURNI= 2;
        public static inline final TYPE_RULES= 4;

        // Kept as source aliases for code written before the July discriminator
        // meanings were recovered.
        public static final TYPE_NONE:Int = TYPE_CREDIT_FURNI;
        public static final TYPE_TEXT:Int = TYPE_NORMAL_FURNI;
        public static final TYPE_PAYMENT:Int = TYPE_ANY_FURNI;

        var _type:Int = 0;
        var _youGetText:String;
        var _layoutType:String;
        var _rules:TradeRequirementRules;

        public function new(data:IMessageDataWrapper)
        {
            this._type = data.readInteger();
            this._youGetText = data.readString();
            this._layoutType = data.readString();
            if (this._type == TYPE_RULES)
            {
                this._rules = new TradeRequirementRules(data);
            }
        }

        public var type(get,never):Int;
function  get_type():Int { return this._type; }
        public var youGetText(get,never):String;
function  get_youGetText():String { return this._youGetText; }
        public var layoutType(get,never):String;
function  get_layoutType():String { return this._layoutType; }
        public var rules(get,never):TradeRequirementRules;
function  get_rules():TradeRequirementRules { return this._rules; }

        public function isPaymentOnly():Bool
        {
            return this._type != TYPE_RULES || this._rules.youGetRule == null
                || this._rules.youGetRule.nodes.length == 0;
        }
    }

