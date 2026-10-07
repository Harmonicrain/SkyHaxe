package com.sulake.habbo.communication.messages.outgoing.room.bots
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetBotCommandConfigurationDataComposer implements IMessageComposer
    {
        var _botId:Int = 0;
        var _Str_12385:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._botId = k;
            this._Str_12385 = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._botId, this._Str_12385];
        }
    }

