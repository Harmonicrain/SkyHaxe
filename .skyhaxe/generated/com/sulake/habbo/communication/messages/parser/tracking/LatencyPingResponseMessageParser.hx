package com.sulake.habbo.communication.messages.parser.tracking
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LatencyPingResponseMessageParser implements IMessageParser 
    {
        var _requestId:Int = 0;


        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }

        public function flush():Bool
        {
            this._requestId = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._requestId = k.readInteger();
            return true;
        }

	public function new() {}
    }

