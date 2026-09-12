package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;

     class WithdrawChestFurniMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, type:ChestItemType,
            amount:Int)
        {
            var values:Array<ASAny> = [chestId];
            type.addToComposer(values);
            values.push(amount);
            super(values);
        }
    }

