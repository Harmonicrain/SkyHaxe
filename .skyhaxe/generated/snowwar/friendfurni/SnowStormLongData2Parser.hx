package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_4018;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormLongData2Parser implements IMessageParser 
    {
        var _SafeStr_21881:_SafeStr_4018;

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21881 = new _SafeStr_4018(k);
            return true;
        }

        public var _SafeStr_18970(get,never):_SafeStr_4018;
public function  get__SafeStr_18970():_SafeStr_4018
        {
            return this._SafeStr_21881;
        }

	public function new() {}
    }

