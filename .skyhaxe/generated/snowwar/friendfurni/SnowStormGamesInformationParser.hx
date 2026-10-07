package snowwar.friendfurni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SnowStormGamesInformationParser implements IMessageParser 
    {
        public static inline final _SafeStr_18968= 0;
        public static inline final _SafeStr_21904= 1;
        public static inline final _SafeStr_21905= 2;
        public static inline final _SafeStr_21906= 3;

        var _status:Int = 0;
        var _timeTillNextGame:Int = 0;
        var _userId:Int = 0;
        var _gamesLeft:Int = 0;

        public var status(get,never):Int;
public function  get_status():Int
        {
            return this._status;
        }

        public var timeTillNextGame(get,never):Int;
public function  get_timeTillNextGame():Int
        {
            return this._timeTillNextGame;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var gamesLeft(get,never):Int;
public function  get_gamesLeft():Int
        {
            return this._gamesLeft;
        }

        public var infiniteGames(get,never):Bool;
public function  get_infiniteGames():Bool
        {
            return this._gamesLeft == -1;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._status = k.readInteger();
            this._timeTillNextGame = k.readInteger();
            this._userId = k.readInteger();
            this._gamesLeft = k.readInteger();
            return true;
        }

	public function new() {}
    }

