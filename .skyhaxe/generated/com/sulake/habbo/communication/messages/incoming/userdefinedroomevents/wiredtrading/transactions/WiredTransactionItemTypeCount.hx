package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;

     class WiredTransactionItemTypeCount
    {
        var _type:ChestItemType;
        var _amount:Int = 0;

        public function new(data:IMessageDataWrapper)
        {
            this._type = ChestItemType.readFromMessage(data);
            this._amount = data.readInteger();
        }

        public var type(get,never):ChestItemType;
public function  get_type():ChestItemType { return this._type; }
        public var amount(get,never):Int;
public function  get_amount():Int { return this._amount; }
    }

