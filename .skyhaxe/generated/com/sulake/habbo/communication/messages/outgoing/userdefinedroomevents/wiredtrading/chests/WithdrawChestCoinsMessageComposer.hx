package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class WithdrawChestCoinsMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, amount:Int)
        {
            super([chestId, amount]);
        }
    }

