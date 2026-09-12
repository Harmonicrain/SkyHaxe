package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class StartLobbyCounterParser implements IMessageParser 
    {
        var _SafeStr_21848:Int = 0;

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._SafeStr_21848 = k.readInteger();
            return true;
        }

        public var _SafeStr_18972(get,never):Int;
public function  get__SafeStr_18972():Int
        {
            return this._SafeStr_21848;
        }

	public function new() {}
    }

