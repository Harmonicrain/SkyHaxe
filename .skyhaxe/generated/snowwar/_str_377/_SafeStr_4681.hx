package snowwar._str_377
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _SafeStr_4681 extends _SafeStr_4677 
    {
        var _SafeStr_22189:Int = 0;

        public function new(k:Int)
        {
            super(k);
        }

        public var _SafeStr_18991(get,never):Int;
public function  get__SafeStr_18991():Int
        {
            return this._SafeStr_22189;
        }

        override public function parse(k:IMessageDataWrapper)
        {
            this._SafeStr_22189 = k.readInteger();
        }
    }

