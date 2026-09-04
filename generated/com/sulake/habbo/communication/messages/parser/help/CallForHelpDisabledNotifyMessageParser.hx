package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CallForHelpDisabledNotifyMessageParser implements IMessageParser
    {
        var _infoUrl:String;


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._infoUrl = k.readString();
            return true;
        }

        public var _Str_23798(get,never):String;
function  get__Str_23798():String
        {
            return this._infoUrl;
        }

	public function new() {}
    }

