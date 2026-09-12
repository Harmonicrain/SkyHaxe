package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests
;
     class SaveChestSettingsMessageComposer extends AbstractChestMessageComposer
    {
        public function new(chestId:Int, name:String,
            description:String, everyoneCanOpen:Bool, everyoneCanDonate:Bool,
            stateControlMode:Int, previewMode:Int, previewAmount:Int, wiredEnabled:Bool)
        {
            super([chestId, name, description, everyoneCanOpen, everyoneCanDonate,
                stateControlMode, previewMode, previewAmount, wiredEnabled]);
        }
    }

