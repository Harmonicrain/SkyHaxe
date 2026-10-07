package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2TeamScoreData 
    {
        var _SafeStr_10146:Int = 0;
        var _SafeStr_22182:Int = 0;
        var _SafeStr_13149:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_22182 = k.readInteger();
            this._SafeStr_10146 = k.readInteger();
            this._SafeStr_13149 = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._SafeStr_13149.push(new Game2TeamPlayerData(this._SafeStr_22182, k));
                _local_3++;
            }
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._SafeStr_10146;
        }

        public var _SafeStr_18907(get,never):Int;
public function  get__SafeStr_18907():Int
        {
            return this._SafeStr_22182;
        }

        public var _SafeStr_13266(get,never):Array<ASAny>;
public function  get__SafeStr_13266():Array<ASAny>
        {
            return this._SafeStr_13149;
        }
    }






