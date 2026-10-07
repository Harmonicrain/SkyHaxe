package com.sulake.habbo.communication.messages.outgoing.userclassification
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RoomUsersClassificationMessageComposer implements IMessageComposer
    {
        var userClassType:String;

        public function new(k:String)
        {
            this.userClassType = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this.userClassType];
        }

        public function dispose()
        {
            this.userClassType = null;
        }
    }

