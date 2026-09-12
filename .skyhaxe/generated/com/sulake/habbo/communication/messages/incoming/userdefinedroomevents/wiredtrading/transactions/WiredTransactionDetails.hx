package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;

    /** Exact July transaction-details model. */
     class WiredTransactionDetails
    {
        var _info:WiredTransactionInfo;
        var _chestIds:Vector<Int>;
        var _deposited:Vector<WiredTransactionItemTypeCount>;
        var _withdrawn:Vector<WiredTransactionItemTypeCount>;
        var _incomplete:Bool = false;

        public function new(data:IMessageDataWrapper)
        {
var i = 0;            this._info = new WiredTransactionInfo(data);
            var count= WiredMessageDataValidator.readCount(
                data, 4, 1000, "Transaction chest ids");
            this._chestIds = new Vector<Int>();
            var i = 0;
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._chestIds.push(data.readInteger());
            }
            this._deposited = this.readItems(data, "Deposited transaction item types");
            this._withdrawn = this.readItems(data, "Withdrawn transaction item types");
            WiredMessageDataValidator.requireBytes(data, 1, "Transaction incomplete flag");
            this._incomplete = data.readBoolean();
        }

        function readItems(data:IMessageDataWrapper,
                                   label:String):Vector<WiredTransactionItemTypeCount>
        {
var i = 0;            var count= WiredMessageDataValidator.readCount(data, 10, 1000, label);
            var result=
                new Vector<WiredTransactionItemTypeCount>();
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                result.push(new WiredTransactionItemTypeCount(data));
            }
            return result;
        }

        public var info(get,never):WiredTransactionInfo;
public function  get_info():WiredTransactionInfo { return this._info; }
        public var chestIds(get,never):Vector<Int>;
public function  get_chestIds():Vector<Int> { return this._chestIds; }
        public var depositedFurnis(get,never):Vector<WiredTransactionItemTypeCount>;
public function  get_depositedFurnis():Vector<WiredTransactionItemTypeCount>
        {
            return this._deposited;
        }
        public var withdrawnFurnis(get,never):Vector<WiredTransactionItemTypeCount>;
public function  get_withdrawnFurnis():Vector<WiredTransactionItemTypeCount>
        {
            return this._withdrawn;
        }
        public var incompleteData(get,never):Bool;
public function  get_incompleteData():Bool { return this._incomplete; }
    }

