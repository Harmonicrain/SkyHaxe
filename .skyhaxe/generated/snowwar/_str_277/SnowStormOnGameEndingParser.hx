package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496.Game2SnowWarGameStats;
    import snowwar._str_496.Game2GameResult;
    import snowwar._str_496.Game2TeamScoreData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormOnGameEndingParser implements IMessageParser 
    {
        var _SafeStr_21840:Int = 0;
        var _SafeStr_18880:Array<ASAny>;
        var _SafeStr_19006:Array<ASAny>;
        var _SafeStr_21841:Game2SnowWarGameStats;
        var _SafeStr_18872:Game2GameResult;

        public function flush():Bool
        {
            this._SafeStr_21840 = -1;
            this._SafeStr_18880 = [];
            this._SafeStr_19006 = [];
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            this._SafeStr_21840 = k.readInteger();
            this._SafeStr_18872 = new Game2GameResult(k);
            var _local_3= k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._SafeStr_18880.push(new Game2TeamScoreData(k));
                _local_2++;
            }
            this._SafeStr_21841 = new Game2SnowWarGameStats(k);
            return true;
        }

        public var _SafeStr_18963(get,never):Int;
public function  get__SafeStr_18963():Int
        {
            return this._SafeStr_21840;
        }

        public var _SafeStr_18964(get,never):Array<ASAny>;
public function  get__SafeStr_18964():Array<ASAny>
        {
            return this._SafeStr_18880;
        }

        public var _SafeStr_21842(get,never):Array<ASAny>;
public function  get__SafeStr_21842():Array<ASAny>
        {
            return this._SafeStr_19006;
        }

        public var _SafeStr_18966(get,never):Game2GameResult;
public function  get__SafeStr_18966():Game2GameResult
        {
            return this._SafeStr_18872;
        }

        public var _SafeStr_18965(get,never):Game2SnowWarGameStats;
public function  get__SafeStr_18965():Game2SnowWarGameStats
        {
            return this._SafeStr_21841;
        }

	public function new() {}
    }

