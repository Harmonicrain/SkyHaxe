package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.NoobnessLevelMessageParser;

     class NoobnessLevelMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, NoobnessLevelMessageParser);
        }

        public var noobnessLevel(get,never):Int;
public function  get_noobnessLevel():Int
        {
            return Std.downcast(this._parser , NoobnessLevelMessageParser).noobnessLevel;
        }
    }

