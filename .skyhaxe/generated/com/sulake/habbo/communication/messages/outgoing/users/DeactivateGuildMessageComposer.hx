package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class DeactivateGuildMessageComposer implements IMessageComposer
    {
        var _guildId:Int = 0;

        public function new(k:Int)
        {
            this._guildId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._guildId];
        }

        public function dispose()
        {
        }
    }

