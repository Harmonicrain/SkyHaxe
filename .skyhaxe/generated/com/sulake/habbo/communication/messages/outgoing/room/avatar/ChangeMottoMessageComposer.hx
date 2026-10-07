package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ChangeMottoMessageComposer implements IMessageComposer
    {
        var _motto:String;

        public function new(k:String)
        {
            this._motto = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._motto];
        }
    }

