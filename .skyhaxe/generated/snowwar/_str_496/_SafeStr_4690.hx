package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4690 
    {
        var _SafeStr_22196:Int = 0;
        var _SafeStr_22197:Int = 0;
        var _SafeStr_12654:_SafeStr_3610;
        var _SafeStr_18581:Int = 0;
        var _SafeStr_22198:_SafeStr_4692;

        public function new(k:IMessageDataWrapper)
        {
            this.parse(k);
        }

        public var _SafeStr_22199(get,never):Int;
public function  get__SafeStr_22199():Int
        {
            return this._SafeStr_22196;
        }

        public var _SafeStr_22200(get,never):Int;
public function  get__SafeStr_22200():Int
        {
            return this._SafeStr_22197;
        }

        public var _SafeStr_7508(get,never):_SafeStr_3610;
public function  get__SafeStr_7508():_SafeStr_3610
        {
            return this._SafeStr_12654;
        }

        public var _SafeStr_13274(get,never):Int;
public function  get__SafeStr_13274():Int
        {
            return this._SafeStr_18581;
        }

        public var _SafeStr_18978(get,never):_SafeStr_4692;
public function  get__SafeStr_18978():_SafeStr_4692
        {
            return this._SafeStr_22198;
        }

        public function parse(k:IMessageDataWrapper)
        {
            k.readInteger();
            this._SafeStr_22196 = k.readInteger();
            this._SafeStr_22197 = k.readInteger();
            this._SafeStr_12654 = new _SafeStr_3610(k);
            k.readInteger();
            this._SafeStr_18581 = k.readInteger();
            this._SafeStr_22198 = new _SafeStr_4692(k);
        }
    }














