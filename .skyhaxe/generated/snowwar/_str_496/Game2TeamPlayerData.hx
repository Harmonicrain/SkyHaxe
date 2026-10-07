package snowwar._str_496
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2TeamPlayerData 
    {
        var _userId:Int = 0;
        var _userName:String;
        var _score:Int = 0;
        var _figure:String;
        var _gender:String;
        var _playerStats:Game2PlayerStatsData;
        var _final:Int = 0;
        var _SafeStr_22181:Bool = false;

        public function new(k:Int, _arg_2:IMessageDataWrapper)        {
            this._final = k;
            this._userName = _arg_2.readString();
            this._userId = _arg_2.readInteger();
            this._figure = _arg_2.readString();
            this._gender = _arg_2.readString();
            this._score = _arg_2.readInteger();
            this._playerStats = new Game2PlayerStatsData(_arg_2);
            this._SafeStr_22181 = false;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._score;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public var playerStats(get,never):Game2PlayerStatsData;
public function  get_playerStats():Game2PlayerStatsData
        {
            return this._playerStats;
        }

        public var __as3_final(get,never):Int;
public function  get___as3_final():Int
        {
            return this._final;
        }

        
        public var _SafeStr_18910(get,set):Bool;
public function  get__SafeStr_18910():Bool
        {
            return this._SafeStr_22181;
        }
public function  set__SafeStr_18910(k:Bool):Bool        {
            return this._SafeStr_22181 = k;
        }
    }

