package com.sulake.habbo.communication.messages.parser.recycler
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RecyclerFinishedMessageParser implements IMessageParser 
    {
        var _recyclerFinishedStatus:Int = -1;
        var _prizeId:Int = 0;


        public var recyclerFinishedStatus(get,never):Int;
public function  get_recyclerFinishedStatus():Int
        {
            return this._recyclerFinishedStatus;
        }

        public var prizeId(get,never):Int;
public function  get_prizeId():Int
        {
            return this._prizeId;
        }

        public function flush():Bool
        {
            this._recyclerFinishedStatus = -1;
            this._prizeId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._recyclerFinishedStatus = k.readInteger();
            this._prizeId = k.readInteger();
            return true;
        }

	public function new() {}
    }

