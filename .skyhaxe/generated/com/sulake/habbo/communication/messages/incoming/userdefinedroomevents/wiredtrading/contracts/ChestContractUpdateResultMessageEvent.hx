package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractUpdateResultMessageParser;

     class ChestContractUpdateResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, ChestContractUpdateResultMessageParser);
        }
        public function getParser():ChestContractUpdateResultMessageParser
        {
            return Std.downcast(this._parser , ChestContractUpdateResultMessageParser);
        }
    }

