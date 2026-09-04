package com.sulake.habbo.communication.messages.parser.session
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class FurniDataReloadMessageParser implements IMessageParser
    {
        var _reloadToken:String;

        public function flush():Bool
        {
            this._reloadToken = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reloadToken = k.readString();
            return true;
        }

        public var reloadToken(get,never):String;
function  get_reloadToken():String
        {
            return this._reloadToken;
        }

	public function new() {}
    }

