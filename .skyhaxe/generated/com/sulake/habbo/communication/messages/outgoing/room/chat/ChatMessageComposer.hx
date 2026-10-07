package com.sulake.habbo.communication.messages.outgoing.room.chat
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ChatMessageComposer implements IMessageComposer
    {
        var _text:String;
        var _chatTrackingId:Int = 0;
        var _styleId:Int = 0;

        public function new(k:String, _arg_2:Int=0, _arg_3:Int=-1)
        {
            this._text = k;
            this._styleId = _arg_2;
            this._chatTrackingId = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._text, this._styleId, this._chatTrackingId];
        }
    }

