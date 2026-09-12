package com.sulake.habbo.communication.messages.outgoing.room.bots
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class CommandBotComposer implements IMessageComposer
    {
        var _botId:Int = 0;
        var _Str_12385:Int = 0;
        var _Str_21366:String;

        public function new(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._botId = k;
            this._Str_12385 = _arg_2;
            this._Str_21366 = _arg_3;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._botId, this._Str_12385, this._Str_21366];
        }
    }

