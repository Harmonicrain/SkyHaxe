package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumDataMessageParser;

     class ForumDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ForumDataMessageParser);
        }

        public function getParser():ForumDataMessageParser
        {
            return Std.downcast(this._parser , ForumDataMessageParser);
        }
    }

