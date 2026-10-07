package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import snowwar._str_496._SafeStr_4032;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormQuePlayerAddedParser implements IMessageParser 
    {
        var _user:_SafeStr_4032;
        var _SafeStr_21892:Bool = false;

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._user = new _SafeStr_4032(k);
            this._SafeStr_21892 = k.readBoolean();
            return true;
        }

        public var user(get,never):_SafeStr_4032;
public function  get_user():_SafeStr_4032
        {
            return this._user;
        }

        public var _SafeStr_21893(get,never):Bool;
public function  get__SafeStr_21893():Bool
        {
            return this._SafeStr_21892;
        }

	public function new() {}
    }

