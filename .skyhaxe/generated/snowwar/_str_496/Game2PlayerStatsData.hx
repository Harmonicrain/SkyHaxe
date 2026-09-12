package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2PlayerStatsData 
    {
        var _SafeStr_10146:Int = 0;
        var _SafeStr_23369:Int = 0;
        var _SafeStr_23370:Int = 0;
        var _SafeStr_23371:Int = 0;
        var _SafeStr_23372:Int = 0;
        var _SafeStr_23373:Int = 0;
        var _SafeStr_23374:Int = 0;
        var _SafeStr_23375:Int = 0;
        var _SafeStr_23376:Int = 0;
        var _SafeStr_23377:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_10146 = k.readInteger();
            this._SafeStr_23369 = k.readInteger();
            this._SafeStr_23370 = k.readInteger();
            this._SafeStr_23371 = k.readInteger();
            this._SafeStr_23372 = k.readInteger();
            this._SafeStr_23373 = k.readInteger();
            this._SafeStr_23374 = k.readInteger();
            this._SafeStr_23375 = k.readInteger();
            this._SafeStr_23376 = k.readInteger();
            this._SafeStr_23377 = k.readInteger();
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._SafeStr_10146;
        }

        public var _SafeStr_18909(get,never):Int;
public function  get__SafeStr_18909():Int
        {
            return this._SafeStr_23369;
        }

        public var _SafeStr_23378(get,never):Int;
public function  get__SafeStr_23378():Int
        {
            return this._SafeStr_23370;
        }

        public var _SafeStr_18908(get,never):Int;
public function  get__SafeStr_18908():Int
        {
            return this._SafeStr_23371;
        }

        public var _SafeStr_23379(get,never):Int;
public function  get__SafeStr_23379():Int
        {
            return this._SafeStr_23372;
        }

        public var _SafeStr_23380(get,never):Int;
public function  get__SafeStr_23380():Int
        {
            return this._SafeStr_23373;
        }

        public var _SafeStr_23381(get,never):Int;
public function  get__SafeStr_23381():Int
        {
            return this._SafeStr_23374;
        }

        public var _SafeStr_23382(get,never):Int;
public function  get__SafeStr_23382():Int
        {
            return this._SafeStr_23375;
        }

        public var _SafeStr_23383(get,never):Int;
public function  get__SafeStr_23383():Int
        {
            return this._SafeStr_23376;
        }

        public var _SafeStr_23384(get,never):Int;
public function  get__SafeStr_23384():Int
        {
            return this._SafeStr_23377;
        }
    }




















