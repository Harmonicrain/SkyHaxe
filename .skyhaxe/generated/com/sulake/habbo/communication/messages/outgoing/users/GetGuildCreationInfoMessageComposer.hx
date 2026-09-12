package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetGuildCreationInfoMessageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new()
        {
            this._array = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }
    }

