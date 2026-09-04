package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;

     class ChestContractContentsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, ChestContractContentsMessageParser);
        }
        public function getParser():ChestContractContentsMessageParser
        {
            return Std.downcast(this._parser , ChestContractContentsMessageParser);
        }
    }

