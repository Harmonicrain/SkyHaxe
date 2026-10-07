package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserSongDisksInventoryMessageParser implements IMessageParser
    {
        var _Str_3449:Map;

        public function new()
        {
            this._Str_3449 = new Map();
        }

        public var _Str_22284(get,never):Int;
public function  get__Str_22284():Int
        {
            return ASCompat.toInt(this._Str_3449.length);
        }

        public function _Str_23874(k:Int):Int
        {
            if (((k >= 0) && ((k : UInt) < this._Str_3449.length)))
            {
                return ASCompat.toInt(this._Str_3449.getKey(k));
            }
            return -1;
        }

        public function _Str_24056(k:Int):Int
        {
            if (((k >= 0) && ((k : UInt) < this._Str_3449.length)))
            {
                return ASCompat.toInt(this._Str_3449.getWithIndex(k));
            }
            return -1;
        }

        public function flush():Bool
        {
            this._Str_3449.reset();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                this._Str_3449.add(_local_4, _local_5);
                _local_3++;
            }
            return true;
        }
    }

