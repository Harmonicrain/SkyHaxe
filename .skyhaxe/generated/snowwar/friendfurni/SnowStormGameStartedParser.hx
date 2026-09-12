package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_4018;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGameStartedParser implements IMessageParser 
    {
        var _SafeStr_18794:_SafeStr_4018;

        public var _SafeStr_18971(get,never):_SafeStr_4018;
public function  get__SafeStr_18971():_SafeStr_4018
        {
            return this._SafeStr_18794;
        }

        public function flush():Bool
        {
            this._SafeStr_18794 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_18794 = new _SafeStr_4018(k);
            return true;
        }

	public function new() {}
    }

