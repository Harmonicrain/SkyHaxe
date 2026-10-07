package com.sulake.habbo.communication.messages.incoming.groupforums
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThreadsParser;

     class GuildForumThreadsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GuildForumThreadsParser);
        }

        public function getParser():GuildForumThreadsParser
        {
            return Std.downcast(this._parser , GuildForumThreadsParser);
        }
    }

