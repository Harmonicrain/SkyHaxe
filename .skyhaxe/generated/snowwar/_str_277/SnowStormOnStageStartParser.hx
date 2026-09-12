package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_3610;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormOnStageStartParser implements IMessageParser 
    {
        var _SafeStr_12654:_SafeStr_3610;
        var _SafeStr_12655:Int = 0;
        var _roomType:String;
        var _SafeStr_12657:Int = 0;

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_12655 = k.readInteger();
            this._roomType = k.readString();
            this._SafeStr_12657 = k.readInteger();
            this._SafeStr_12654 = new _SafeStr_3610(k);
            return true;
        }

        public var _SafeStr_7508(get,never):_SafeStr_3610;
public function  get__SafeStr_7508():_SafeStr_3610
        {
            return this._SafeStr_12654;
        }

        public var _SafeStr_12658(get,never):Int;
public function  get__SafeStr_12658():Int
        {
            return this._SafeStr_12655;
        }

        public var roomType(get,never):String;
public function  get_roomType():String
        {
            return this._roomType;
        }

        public var _SafeStr_12659(get,never):Int;
public function  get__SafeStr_12659():Int
        {
            return this._SafeStr_12657;
        }

	public function new() {}
    }

