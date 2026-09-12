package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BuildersClubFurniCountMessageParser implements IMessageParser
    {
        var _furniCount:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniCount = k.readInteger();
            return true;
        }

        public var furniCount(get,never):Int;
public function  get_furniCount():Int
        {
            return this._furniCount;
        }

	public function new() {}
    }

