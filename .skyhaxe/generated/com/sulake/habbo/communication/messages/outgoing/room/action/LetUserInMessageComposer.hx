package com.sulake.habbo.communication.messages.outgoing.room.action
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LetUserInMessageComposer implements IMessageComposer
    {
        var _message:Array<ASAny>;

        public function new(k:String, _arg_2:Bool)
        {
            this._message = [k, _arg_2];
        }

        public function dispose()
        {
            this._message = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._message;
        }
    }

