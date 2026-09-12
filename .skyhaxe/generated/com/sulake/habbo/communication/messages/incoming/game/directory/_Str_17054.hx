package com.sulake.habbo.communication.messages.incoming.game.directory
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.directory._Str_8981;

     class _Str_17054 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_8981);
        }

        public function getParser():_Str_8981
        {
            return Std.downcast(this._parser , _Str_8981);
        }
    }

