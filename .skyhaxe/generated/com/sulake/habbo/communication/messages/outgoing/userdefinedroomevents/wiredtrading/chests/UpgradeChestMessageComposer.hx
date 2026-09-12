package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class UpgradeChestMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, levels:Int)
        {
            super([chestId, levels]);
        }
    }

