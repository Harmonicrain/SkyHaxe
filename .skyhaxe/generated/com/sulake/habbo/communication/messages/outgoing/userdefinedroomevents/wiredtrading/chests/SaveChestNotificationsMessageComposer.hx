package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class SaveChestNotificationsMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, notifyMode:Int,
            notifyFull:Bool, notifyDonation:Bool, notifyWithdraw:Bool,
            notifyEmpty:Bool, notifyWiredTransaction:Bool)
        {
            super([chestId, notifyMode, notifyFull, notifyDonation, notifyWithdraw,
                notifyEmpty, notifyWiredTransaction]);
        }
    }

