package com.sulake.habbo.communication.messages.incoming.camera
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.camera.CompetitionStatusMessageParser;

     class CompetitionStatusMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CompetitionStatusMessageParser);
        }

        public function getParser():CompetitionStatusMessageParser
        {
            return Std.downcast(this._parser , CompetitionStatusMessageParser);
        }
    }

