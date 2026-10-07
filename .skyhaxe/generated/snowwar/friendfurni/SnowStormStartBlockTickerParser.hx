package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormStartBlockTickerParser implements IMessageParser 
    {
        var _SafeStr_21835:Int = 0;

        public function flush():Bool
        {
            this._SafeStr_21835 = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21835 = k.readInteger();
            return true;
        }

        public var _SafeStr_18976(get,never):Int;
public function  get__SafeStr_18976():Int
        {
            return this._SafeStr_21835;
        }

	public function new() {}
    }

