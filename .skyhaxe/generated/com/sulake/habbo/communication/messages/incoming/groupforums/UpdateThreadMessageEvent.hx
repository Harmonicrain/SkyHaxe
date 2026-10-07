package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.UpdateThreadMessageParser;

     class UpdateThreadMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UpdateThreadMessageParser);
        }

        public function getParser():UpdateThreadMessageParser
        {
            return Std.downcast(this._parser , UpdateThreadMessageParser);
        }
    }

