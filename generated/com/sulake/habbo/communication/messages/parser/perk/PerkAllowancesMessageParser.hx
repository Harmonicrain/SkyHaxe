package com.sulake.habbo.communication.messages.parser.perk
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PerkAllowancesMessageParser implements IMessageParser 
    {
        var _perks:Vector<Perk>;


        public function flush():Bool
        {
            this._perks = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:Perk;
            this._perks = new Vector<Perk>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new Perk();
                _local_4.code = k.readString();
                _local_4.errorMessage = k.readString();
                _local_4.isAllowed = k.readBoolean();
                this._perks.push(_local_4);
                _local_3++;
            }
            return true;
        }

        public function _Str_23301():Vector<Perk>
        {
            return this._perks;
        }

        public function isPerkAllowed(k:String):Bool
        {
            var _local_2= this._Str_23560(k);
            return (!(_local_2 == null)) && _local_2.isAllowed;
        }

        public function _Str_23560(k:String):Perk
        {
            var _local_2:Perk;
            for (_tmp_ in this._perks)
            {
_local_2  = _tmp_;
                if (_local_2.code == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

	public function new() {}
    }

