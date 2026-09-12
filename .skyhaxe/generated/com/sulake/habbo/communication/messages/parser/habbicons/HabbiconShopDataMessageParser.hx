package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class HabbiconShopDataMessageParser implements IMessageParser
    {
        var _collections:Array<ASAny> = [];

        public var collections(get,never):Array<ASAny>;
public function  get_collections():Array<ASAny>
        {
            return this._collections;
        }

        public function flush():Bool
        {
            this._collections = [];
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
var index = 0;            var count= wrapper.readInteger();
            this._collections = [];
            for (_tmp_ in 0...count)
            {
index= _tmp_;
                this._collections.push(HabbiconWireParsers.readCollection(wrapper));
            }
            return true;
        }

	public function new() {}
    }

