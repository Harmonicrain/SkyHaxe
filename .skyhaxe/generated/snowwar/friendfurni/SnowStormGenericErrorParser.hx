package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGenericErrorParser implements IMessageParser 
    {
        public static inline final _SafeStr_21887= 1;
        public static inline final _SafeStr_13125= 2;
        public static inline final _SafeStr_21888= 3;
        public static inline final _SafeStr_21889= 4;
        public static inline final _SafeStr_21890= 5;
        public static inline final _SafeStr_18973= 6;
        public static inline final _SafeStr_18974= 7;
        public static inline final _SafeStr_18975= 8;

        var _reason:Int = 0;

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._reason;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            return true;
        }

	public function new() {}
    }

