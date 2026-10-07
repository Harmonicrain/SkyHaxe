package com.sulake.habbo.communication.messages.incoming.game.directory
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.directory.Game2GameDirectoryStatusMessageParser;

     class Game2GameDirectoryStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, Game2GameDirectoryStatusMessageParser);
        }

        public function getParser():Game2GameDirectoryStatusMessageParser
        {
            return Std.downcast(this._parser , Game2GameDirectoryStatusMessageParser);
        }
    }

