package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormOnStageRunningParser implements IMessageParser 
    {
        var _time:Int = 0;

        public function flush():Bool
        {
            this._time = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._time = k.readInteger();
            return true;
        }

        public var time(get,never):Int;
public function  get_time():Int
        {
            return this._time;
        }

	public function new() {}
    }

