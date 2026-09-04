package com.sulake.habbo.communication.messages.incoming.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.CameraPurchaseOKMessageParser;

     class CameraPurchaseOKMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CameraPurchaseOKMessageParser);
        }

        public function getParser():CameraPurchaseOKMessageParser
        {
            return Std.downcast(this._parser , CameraPurchaseOKMessageParser);
        }
    }

