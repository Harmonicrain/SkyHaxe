package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class SaveChestSafetyMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, locked:Bool,
            autoLock:Bool, capacity:Int)
        {
            super([chestId, locked, autoLock, capacity]);
        }
    }

