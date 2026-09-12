package com.sulake.habbo.communication.messages.outgoing.room.action
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class UnbanUserFromRoomMessageComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k);
            this.messageArray.push(_arg_2);
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

