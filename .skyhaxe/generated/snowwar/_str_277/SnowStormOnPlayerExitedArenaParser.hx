package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormOnPlayerExitedArenaParser implements IMessageParser 
    {
        var _SafeStr_9687:Int = 0;
        var _SafeStr_21883:Int = 0;

        public function flush():Bool
        {
            this._SafeStr_9687 = Std.int(Math.NaN);
            this._SafeStr_21883 = Std.int(Math.NaN);
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_9687 = k.readInteger();
            this._SafeStr_21883 = k.readInteger();
            return true;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._SafeStr_9687;
        }

        public var _SafeStr_18967(get,never):Int;
public function  get__SafeStr_18967():Int
        {
            return this._SafeStr_21883;
        }

	public function new() {}
    }

