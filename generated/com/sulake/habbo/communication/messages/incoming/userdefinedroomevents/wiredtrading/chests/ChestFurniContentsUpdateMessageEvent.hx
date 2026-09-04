package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsUpdateMessageParser;

     class ChestFurniContentsUpdateMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, ChestFurniContentsUpdateMessageParser);
        }
        public function getParser():ChestFurniContentsUpdateMessageParser
        {
            return Std.downcast(this._parser , ChestFurniContentsUpdateMessageParser);
        }
    }

