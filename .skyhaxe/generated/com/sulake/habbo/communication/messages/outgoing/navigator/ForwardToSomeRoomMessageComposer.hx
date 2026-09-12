package com.sulake.habbo.communication.messages.outgoing.navigator
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ForwardToSomeRoomMessageComposer implements IMessageComposer
    {
        var _type:String;

        public function new(k:String)        {
            this._type = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._type];
        }

        public function dispose()
        {
            this._type = null;
        }
    }

