package snowwar._str_377
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4689 extends _SafeStr_4677 
    {
        var _SafeStr_22189:Int = 0;
        var _SafeStr_6268:Int = 0;
        var _SafeStr_6269:Int = 0;

        public function new(k:Int)
        {
            super(k);
        }

        public var _SafeStr_18991(get,never):Int;
public function  get__SafeStr_18991():Int
        {
            return this._SafeStr_22189;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._SafeStr_6268;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._SafeStr_6269;
        }

        override public function parse(k:IMessageDataWrapper)
        {
            this._SafeStr_22189 = k.readInteger();
            this._SafeStr_6268 = k.readInteger();
            this._SafeStr_6269 = k.readInteger();
        }
    }

