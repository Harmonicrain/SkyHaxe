package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetFaqTextMessageComposer implements IMessageComposer
    {
        var _questionId:Int = 0;

        public function new(k:Int)
        {
            this._questionId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._questionId];
        }

        public function dispose()
        {
        }
    }

