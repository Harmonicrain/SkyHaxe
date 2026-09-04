package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class IdentityAccountsParser implements IMessageParser 
    {
        var _Str_8999:Map;


        public function flush():Bool
        {
            if (this._Str_8999 != null)
            {
                this._Str_8999.dispose();
                this._Str_8999 = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8999 = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_8999.add(k.readInteger(), k.readString());
                _local_3++;
            }
            return true;
        }

        public var _Str_20644(get,never):Map;
function  get__Str_20644():Map
        {
            return this._Str_8999;
        }

	public function new() {}
    }

