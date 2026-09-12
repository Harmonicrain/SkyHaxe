package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2SnowWarGameStats 
    {
        var _SafeStr_18912:Int = 0;
        var _SafeStr_18913:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._SafeStr_18912 = k.readInteger();
            this._SafeStr_18913 = k.readInteger();
        }

        public var _SafeStr_18906(get,never):Int;
public function  get__SafeStr_18906():Int
        {
            return this._SafeStr_18912;
        }

        public var _SafeStr_18905(get,never):Int;
public function  get__SafeStr_18905():Int
        {
            return this._SafeStr_18913;
        }
    }





