package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurnitureAliasesMessageParser implements IMessageParser
    {
        var _aliases:Map = null;

        public function new()
        {
            this._aliases = new Map();
        }

        public var aliasCount(get,never):Int;
public function  get_aliasCount():Int
        {
            return ASCompat.toInt(this._aliases.length);
        }

        public function getName(k:Int):String
        {
            if (((k < 0) || (k >= this.aliasCount)))
            {
                return null;
            }
            return this._aliases.getKey(k);
        }

        public function getAlias(k:Int):String
        {
            if (((k < 0) || (k >= this.aliasCount)))
            {
                return null;
            }
            return this._aliases.getWithIndex(k);
        }

        public function flush():Bool
        {
            this._aliases.reset();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:String = null;
            var _local_5:String = null;
            this._aliases.reset();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readString();
                _local_5 = k.readString();
                this._aliases.remove(_local_4);
                this._aliases.add(_local_4, _local_5);
                _local_3++;
            }
            return true;
        }
    }

