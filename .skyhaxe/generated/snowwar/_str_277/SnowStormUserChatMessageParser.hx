package snowwar._str_277
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormUserChatMessageParser implements IMessageParser 
    {
        var _SafeStr_9687:Int = 0;
        var _SafeStr_21819:String;

        public function flush():Bool
        {
            this._SafeStr_9687 = -1;
            this._SafeStr_21819 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_9687 = k.readInteger();
            this._SafeStr_21819 = k.readString();
            return true;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._SafeStr_9687;
        }

        public var _SafeStr_18212(get,never):String;
public function  get__SafeStr_18212():String
        {
            return this._SafeStr_21819;
        }

	public function new() {}
    }

