package com.sulake.habbo.communication.messages.incoming.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.ThumbnailStatusMessageParser;

     class ThumbnailStatusMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ThumbnailStatusMessageParser);
        }

        public function getParser():ThumbnailStatusMessageParser
        {
            return Std.downcast(this._parser , ThumbnailStatusMessageParser);
        }
    }

