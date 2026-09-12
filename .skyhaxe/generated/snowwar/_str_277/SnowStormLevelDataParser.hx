package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496.SnowWarGameStageMessageParser;
    import snowwar._str_496.Game2PlayerData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormLevelDataParser implements IMessageParser 
    {
        var _SafeStr_12655:Int = 0;
        var _SafeStr_18595:Int = 0;
        var _SafeStr_18581:Int = 0;
        var _SafeStr_13149:Array<ASAny>;
        var _SafeStr_18702:SnowWarGameStageMessageParser;

        public function new()
        {
            this._SafeStr_13149 = [];
        }

        public function flush():Bool
        {
            var k:Game2PlayerData = null;
            this._SafeStr_12655 = -1;
            this._SafeStr_18595 = -1;
            this._SafeStr_18581 = -1;
            final _iter_ = this._SafeStr_13149; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._SafeStr_13149 = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:Game2PlayerData = null;
            this._SafeStr_12655 = k.readInteger();
            this._SafeStr_18595 = k.readInteger();
            this._SafeStr_18581 = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new Game2PlayerData();
                _local_4.parse(k);
                this._SafeStr_13149.push(_local_4);
                _local_3++;
            }
            this._SafeStr_18702 = new SnowWarGameStageMessageParser(k);
            return true;
        }

        public var _SafeStr_12658(get,never):Int;
public function  get__SafeStr_12658():Int
        {
            return this._SafeStr_12655;
        }

        public var fieldName(get,never):Int;
public function  get_fieldName():Int
        {
            return this._SafeStr_18595;
        }

        public var _SafeStr_13274(get,never):Int;
public function  get__SafeStr_13274():Int
        {
            return this._SafeStr_18581;
        }

        public var _SafeStr_13266(get,never):Array<ASAny>;
public function  get__SafeStr_13266():Array<ASAny>
        {
            return this._SafeStr_13149;
        }

        public var _SafeStr_18958(get,never):SnowWarGameStageMessageParser;
public function  get__SafeStr_18958():SnowWarGameStageMessageParser
        {
            return this._SafeStr_18702;
        }
    }

