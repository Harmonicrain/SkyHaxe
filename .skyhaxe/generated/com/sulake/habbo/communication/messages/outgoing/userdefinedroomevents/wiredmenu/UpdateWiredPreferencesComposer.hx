package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
;
     final class UpdateWiredPreferencesComposer extends WiredMenuComposer
    {
        public function new(toolbar:Bool, inspect:Bool,
            playtest:Bool, whisperDisabled:Bool, allNotifications:Bool,
            style:String)
        {
            super([toolbar, inspect, playtest, 0, whisperDisabled,
                allNotifications, style]);
        }
    }

