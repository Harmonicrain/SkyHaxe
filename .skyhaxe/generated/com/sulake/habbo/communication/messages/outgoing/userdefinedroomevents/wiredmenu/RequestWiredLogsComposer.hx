package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
;
     final class RequestWiredLogsComposer extends WiredMenuComposer
    {
        public function new(page:Int, amount:Int,
            level:Int = -1, source:Int = -1, query:String = "")
        {
            super([page, amount, level, source, query]);
        }
    }

