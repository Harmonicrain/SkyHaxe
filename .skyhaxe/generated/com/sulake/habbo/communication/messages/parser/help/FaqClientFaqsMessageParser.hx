package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FaqClientFaqsMessageParser implements IMessageParser
    {
        var _urgentData:Map;
        var _normalData:Map;


        public var _Str_26124(get,never):Map;
public function  get__Str_26124():Map
        {
            return this._urgentData;
        }

        public var _Str_26404(get,never):Map;
public function  get__Str_26404():Map
        {
            return this._normalData;
        }

        public function flush():Bool
        {
            if (this._urgentData != null)
            {
                this._urgentData.dispose();
            }
            this._urgentData = null;
            if (this._normalData != null)
            {
                this._normalData.dispose();
            }
            this._normalData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            var _local_3:String = null;
            var _local_4 = 0;
            var _local_5 = 0;
            this._urgentData = new Map();
            this._normalData = new Map();
            _local_5 = k.readInteger();
            _local_4 = 0;
            while (_local_4 < _local_5)
            {
                _local_2 = k.readInteger();
                _local_3 = k.readString();
                this._urgentData.add(_local_2, _local_3);
                _local_4++;
            }
            _local_5 = k.readInteger();
            _local_4 = 0;
            while (_local_4 < _local_5)
            {
                _local_2 = k.readInteger();
                _local_3 = k.readString();
                this._normalData.add(_local_2, _local_3);
                _local_4++;
            }
            return true;
        }

	public function new() {}
    }

