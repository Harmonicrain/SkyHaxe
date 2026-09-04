package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** July transaction-success contents. Type 2 carries the reward notification rule. */
     class WiredTransactionSuccessContents
    {
        public static inline final TYPE_REWARD_CONTENTS= 2;

        var _internalId:Int = 0;
        var _type:Int = 0;
        var _rewardContents:TradeRequirementRule;
        var _rewardText:String = "";
        var _openByDefault:Bool = false;

        public function new(
            internalId:Int, data:IMessageDataWrapper)
        {
            this._internalId = internalId;
            this._type = data.readInteger();
            if (this._type == TYPE_REWARD_CONTENTS && data.bytesAvailable > 0)
            {
                this._rewardContents = TradeRequirementRule.readFromMessage(data);
                this._rewardText = data.readString();
                this._openByDefault = data.readBoolean();
            }
        }

        public var internalId(get,never):Int;
function  get_internalId():Int { return this._internalId; }
        public var transactionSuccessTypeId(get,never):Int;
function  get_transactionSuccessTypeId():Int { return this._type; }
        public var rewardContents(get,never):TradeRequirementRule;
function  get_rewardContents():TradeRequirementRule
        {
            return this._rewardContents;
        }
        public var rewardText(get,never):String;
function  get_rewardText():String { return this._rewardText; }
        public var openByDefault(get,never):Bool;
function  get_openByDefault():Bool { return this._openByDefault; }
    }

