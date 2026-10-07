package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RentableSpaceRentMessageComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int)
        {
            this.messageArray = [k];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this.messageArray;
        }

        public function dispose()
        {
            this.messageArray = null;
        }
    }

