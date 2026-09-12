package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
	import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGamesLeftParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _SafeStr_13166:Int = 0;
        var _SafeStr_18570:Int = 0;


        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var _SafeStr_13224(get,never):Int;
public function  get__SafeStr_13224():Int
        {
            return this._SafeStr_13166;
        }

        public var _SafeStr_13126(get,never):Int;
public function  get__SafeStr_13126():Int
        {
            return this._SafeStr_18570;
        }

        public var _SafeStr_13223(get,never):Bool;
public function  get__SafeStr_13223():Bool
        {
            return this._SafeStr_13166 == -1;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._SafeStr_13166 = k.readInteger();
            this._SafeStr_18570 = k.readInteger();
            return true;
        }

	public function new() {}
    }

