package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetGuildFurniContextMenuInfoMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _guildId:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._objectId = k;
            this._guildId = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._guildId];
        }
    }

