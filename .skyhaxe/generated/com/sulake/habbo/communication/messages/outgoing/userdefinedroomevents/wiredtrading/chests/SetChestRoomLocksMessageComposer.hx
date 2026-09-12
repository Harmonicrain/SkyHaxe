package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class SetChestRoomLocksMessageComposer extends AbstractChestMessageComposer
    {
        public function new(locked:Bool, allChests:Bool)
        {
            super([locked, allChests]);
        }
    }

