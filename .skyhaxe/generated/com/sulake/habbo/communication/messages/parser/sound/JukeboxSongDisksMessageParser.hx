package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class JukeboxSongDisksMessageParser implements IMessageParser
    {
        var _Str_14708:Map;
        var _Str_18029:Int = 0;

        public function new()
        {
            this._Str_14708 = new Map();
        }

        public var _Str_14484(get,never):Map;
public function  get__Str_14484():Map
        {
            return this._Str_14708;
        }

        public var _Str_26156(get,never):Int;
public function  get__Str_26156():Int
        {
            return this._Str_18029;
        }

        public function flush():Bool
        {
            this._Str_14708.reset();
            this._Str_18029 = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_18029 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3= -1;
            var _local_4= -1;
            var _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = k.readInteger();
                _local_4 = k.readInteger();
                this._Str_14708.add(_local_3, _local_4);
                _local_5++;
            }
            return true;
        }
    }

