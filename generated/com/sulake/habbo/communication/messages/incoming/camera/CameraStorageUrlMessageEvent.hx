package com.sulake.habbo.communication.messages.incoming.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.CameraStorageUrlMessageParser;

     class CameraStorageUrlMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CameraStorageUrlMessageParser);
        }

        public function getParser():CameraStorageUrlMessageParser
        {
            return Std.downcast(this._parser , CameraStorageUrlMessageParser);
        }
    }

