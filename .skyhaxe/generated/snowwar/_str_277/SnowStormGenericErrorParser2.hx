package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGenericErrorParser2 implements IMessageParser 
    {
        public static inline final _SafeStr_18959= 1;
        public static inline final _SafeStr_21884= 2;
        public static inline final _SafeStr_21885= 3;
        public static inline final _SafeStr_21886= 4;

        var _SafeStr_15636:Int = 0;

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._SafeStr_15636;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_15636 = k.readInteger();
            return true;
        }

	public function new() {}
    }

