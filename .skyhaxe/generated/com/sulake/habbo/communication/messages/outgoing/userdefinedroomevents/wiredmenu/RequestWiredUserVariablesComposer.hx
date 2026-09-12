package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
;
     final class RequestWiredUserVariablesComposer extends WiredMenuComposer
    {
        public function new(variableId:String, page:Int,
            amount:Int, sortFilter:Int, userFilter:Int)
        {
            super([variableId, page, amount, sortFilter, userFilter]);
        }
    }

