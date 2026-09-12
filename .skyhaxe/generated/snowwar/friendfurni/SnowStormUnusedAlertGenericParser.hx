package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormUnusedAlertGenericParser implements IMessageParser 
    {
        public static inline final _SafeStr_21851= 1;
        public static inline final _SafeStr_21852= 2;

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

