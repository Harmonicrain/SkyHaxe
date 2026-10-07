package snowwar._str_377
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4687 extends _SafeStr_4677 
    {
        var _SafeStr_22195:Int = 0;
        var _SafeStr_22189:Int = 0;
        var _SafeStr_20901:Int = 0;
        var _SafeStr_20902:Int = 0;
        var _SafeStr_19035:Int = 0;

        public function new(k:Int)
        {
            super(k);
        }

        public var _SafeStr_18994(get,never):Int;
public function  get__SafeStr_18994():Int
        {
            return this._SafeStr_22195;
        }

        public var _SafeStr_18991(get,never):Int;
public function  get__SafeStr_18991():Int
        {
            return this._SafeStr_22189;
        }

        public var targetX(get,never):Int;
public function  get_targetX():Int
        {
            return this._SafeStr_20901;
        }

        public var _SafeStr_16005(get,never):Int;
public function  get__SafeStr_16005():Int
        {
            return this._SafeStr_20902;
        }

        public var _SafeStr_18038(get,never):Int;
public function  get__SafeStr_18038():Int
        {
            return this._SafeStr_19035;
        }

        override public function parse(k:IMessageDataWrapper)
        {
            this._SafeStr_22195 = k.readInteger();
            this._SafeStr_22189 = k.readInteger();
            this._SafeStr_20901 = k.readInteger();
            this._SafeStr_20902 = k.readInteger();
            this._SafeStr_19035 = k.readInteger();
        }
    }

