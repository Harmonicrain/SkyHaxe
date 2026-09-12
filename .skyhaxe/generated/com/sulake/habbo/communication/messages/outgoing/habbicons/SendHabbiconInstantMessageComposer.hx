package com.sulake.habbo.communication.messages.outgoing.habbicons
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SendHabbiconInstantMessageComposer implements IMessageComposer
    {
        var _chatId:Int = 0;
        var _habbiconId:Int = 0;
        var _confirmationId:Int = 0;

        public function new(chatId:Int, habbiconId:Int, confirmationId:Int)
        {
            this._chatId = chatId;
            this._habbiconId = habbiconId;
            this._confirmationId = confirmationId;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._chatId, this._habbiconId, this._confirmationId];
        }

        public function dispose()
        {
        }
    }

