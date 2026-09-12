package com.sulake.habbo.communication.messages.incoming.handshake
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.handshake.UserRightsMessageParser;

     class UserRightsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserRightsMessageParser);
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return Std.downcast(this._parser , UserRightsMessageParser).clubLevel;
        }

        public var securityLevel(get,never):Int;
public function  get_securityLevel():Int
        {
            return Std.downcast(this._parser , UserRightsMessageParser).securityLevel;
        }

        public var isAmbassador(get,never):Bool;
public function  get_isAmbassador():Bool
        {
            return Std.downcast(this._parser , UserRightsMessageParser).isAmbassador;
        }
    }

