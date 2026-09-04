package com.sulake.habbo.communication.messages.parser.competition
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CurrentTimingCodeMessageParser implements IMessageParser
    {
        var _schedulingStr:String;
        var _code:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._schedulingStr = k.readString();
            this._code = k.readString();
            return true;
        }

        public var schedulingStr(get,never):String;
function  get_schedulingStr():String
        {
            return this._schedulingStr;
        }

        public var code(get,never):String;
function  get_code():String
        {
            return this._code;
        }

	public function new() {}
    }

