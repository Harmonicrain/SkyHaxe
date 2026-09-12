package snowwar._str_512
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_4692;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGameStatusParser implements IMessageParser 
    {
        var _status:_SafeStr_4692;

        public var status(get,never):_SafeStr_4692;
public function  get_status():_SafeStr_4692
        {
            return this._status;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._status = new _SafeStr_4692(k);
            return true;
        }

	public function new() {}
    }

