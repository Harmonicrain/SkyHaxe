package snowwar._str_512
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_4690;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormFullGameStatusParser implements IMessageParser 
    {
        var _SafeStr_21831:_SafeStr_4690;

        public var _SafeStr_18977(get,never):_SafeStr_4690;
public function  get__SafeStr_18977():_SafeStr_4690
        {
            return this._SafeStr_21831;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21831 = new _SafeStr_4690(k);
            return true;
        }

	public function new() {}
    }

