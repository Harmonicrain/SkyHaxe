package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormUserRematchedParser implements IMessageParser 
    {
        var _SafeStr_9687:Int = 0;

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._SafeStr_9687;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_9687 = k.readInteger();
            return true;
        }

	public function new() {}
    }

