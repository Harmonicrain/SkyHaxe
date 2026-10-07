package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormIntializeGameArenaViewParser implements IMessageParser 
    {
        var _SafeStr_12655:Int = 0;

        public function flush():Bool
        {
            this._SafeStr_12655 = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_12655 = k.readInteger();
            return true;
        }

        public var _SafeStr_12658(get,never):Int;
public function  get__SafeStr_12658():Int
        {
            return this._SafeStr_12655;
        }

	public function new() {}
    }

