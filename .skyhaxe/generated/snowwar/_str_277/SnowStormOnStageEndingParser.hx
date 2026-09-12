package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormOnStageEndingParser implements IMessageParser 
    {
        var _SafeStr_21840:Int = 0;

        public function flush():Bool
        {
            this._SafeStr_21840 = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21840 = k.readInteger();
            return true;
        }

        public var _SafeStr_18963(get,never):Int;
public function  get__SafeStr_18963():Int
        {
            return this._SafeStr_21840;
        }

	public function new() {}
    }

