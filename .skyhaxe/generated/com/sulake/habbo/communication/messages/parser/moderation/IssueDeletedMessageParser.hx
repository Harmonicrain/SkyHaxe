package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IssueDeletedMessageParser implements IMessageParser
    {
        var _issueId:Int = 0;


        public var _Str_2869(get,never):Int;
public function  get__Str_2869():Int
        {
            return this._issueId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._issueId = ASCompat.parseInt(k.readString());
            return true;
        }

	public function new() {}
    }

