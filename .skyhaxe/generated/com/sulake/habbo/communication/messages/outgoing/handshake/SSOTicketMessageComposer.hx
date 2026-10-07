package com.sulake.habbo.communication.messages.outgoing.handshake
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SSOTicketMessageComposer implements IMessageComposer
    {
        var _message:Array<ASAny>;

        public function new(k:String)
        {
            this._message = new Array<ASAny>();
            this._message.push(k);
            this._message.push(flash.Lib.getTimer());
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._message;
        }
    }

