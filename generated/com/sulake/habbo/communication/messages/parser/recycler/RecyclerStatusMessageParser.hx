package com.sulake.habbo.communication.messages.parser.recycler
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RecyclerStatusMessageParser implements IMessageParser 
    {
        var _recyclerStatus:Int = -1;
        var _recyclerTimeoutSeconds:Int = 0;


        public var recyclerStatus(get,never):Int;
function  get_recyclerStatus():Int
        {
            return this._recyclerStatus;
        }

        public var recyclerTimeoutSeconds(get,never):Int;
function  get_recyclerTimeoutSeconds():Int
        {
            return this._recyclerTimeoutSeconds;
        }

        public function flush():Bool
        {
            this._recyclerStatus = -1;
            this._recyclerTimeoutSeconds = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._recyclerStatus = k.readInteger();
            this._recyclerTimeoutSeconds = k.readInteger();
            return true;
        }

	public function new() {}
    }

