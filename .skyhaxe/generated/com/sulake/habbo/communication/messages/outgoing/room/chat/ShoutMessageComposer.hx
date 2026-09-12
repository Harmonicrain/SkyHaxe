package com.sulake.habbo.communication.messages.outgoing.room.chat
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ShoutMessageComposer implements IMessageComposer
    {
        var _text:String;
        var _styleId:Int = 0;

        public function new(k:String, _arg_2:Int=0)
        {
            this._text = k;
            this._styleId = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._text, this._styleId];
        }
    }

