package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
;
     final class UpdateWiredRoomSettingsComposer extends WiredMenuComposer
    {
        public function new(modify:Int, read:Int, timezone:String)
        {
            super([modify, read, timezone]);
        }
    }

