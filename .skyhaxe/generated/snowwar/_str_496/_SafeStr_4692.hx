package snowwar._str_496
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import snowwar._str_377._SafeStr_4677;

     class _SafeStr_4692 
    {
        var _turn:Int = 0;
        var _checksum:Int = 0;
        var _SafeStr_22203:Map;

        public function new(k:IMessageDataWrapper)
        {
            this.parse(k);
        }

        public var turn(get,never):Int;
public function  get_turn():Int
        {
            return this._turn;
        }

        public var checksum(get,never):Int;
public function  get_checksum():Int
        {
            return this._checksum;
        }

        public var events(get,never):Map;
public function  get_events():Map
        {
            return this._SafeStr_22203;
        }

        public function parse(k:IMessageDataWrapper)
        {
            var _local_4 = 0;
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:_SafeStr_4677 = null;
            this._turn = k.readInteger();
            this._checksum = k.readInteger();
            this._SafeStr_22203 = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = [];
                _local_6 = 0;
                while (_local_6 < _local_4)
                {
                    _local_7 = k.readInteger();
                    _local_8 = _SafeStr_4677.create(_local_7);
                    if (_local_8 != null)
                    {
                        _local_8.parse(k);
                        _local_5.push(_local_8);
                    }
                    _local_6++;
                }
                this._SafeStr_22203.add(_local_3, _local_5);
                _local_3++;
            }
        }
    }

