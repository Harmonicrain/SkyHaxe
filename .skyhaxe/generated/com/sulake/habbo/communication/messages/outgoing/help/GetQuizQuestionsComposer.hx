package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetQuizQuestionsComposer implements IMessageComposer
    {
        var messageArray:Array<ASAny>;

        public function new(k:String)
        {
            this.messageArray = [];
            this.messageArray.push(k);
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

