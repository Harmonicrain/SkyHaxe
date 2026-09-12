package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestOpenInstructionMessageParser;

     class ChestOpenInstructionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, ChestOpenInstructionMessageParser);
        }
        public function getParser():ChestOpenInstructionMessageParser
        {
            return Std.downcast(this._parser , ChestOpenInstructionMessageParser);
        }
    }

