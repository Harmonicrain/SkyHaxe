package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormRejoinPreviousRoomParser implements IMessageParser 
    {
        var _SafeStr_13167:Int = 0;

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_13167 = k.readInteger();
            return true;
        }

        public var rejoinRoom(get,never):Int;
public function  get_rejoinRoom():Int
        {
            return this._SafeStr_13167;
        }

	public function new() {}
    }

