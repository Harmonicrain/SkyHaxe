package com.sulake.habbo.communication.messages.incoming.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.InitCameraMessageParser;

     class InitCameraMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, InitCameraMessageParser);
        }

        public function getParser():InitCameraMessageParser
        {
            return Std.downcast(this._parser , InitCameraMessageParser);
        }
    }

