package com.sulake.habbo.communication.messages.outgoing.room.chat
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class WhisperMessageComposer implements IMessageComposer
    {
        var _text:String;
        var _Str_10061:String;
        var _styleId:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:Int=0)
        {
            this._Str_10061 = k;
            this._text = _arg_2;
            this._styleId = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [((this._Str_10061 + " ") + this._text), this._styleId];
        }
    }

