package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredmenu
;
     final class MutatePermanentVariableComposer extends WiredMenuComposer
    {
        public function new(type:Int, id:Int,
            variableId:String, value:Int, operation:Int)
        {
            super([type, id, variableId, value, operation]);
        }
    }

