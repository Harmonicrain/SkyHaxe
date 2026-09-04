package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GameListMessageParser implements IMessageParser 
    {
        var _games:Vector<GameConfigurationData>;


        public function flush():Bool
        {
            return true;
        }

        public var games(get,never):Vector<GameConfigurationData>;
function  get_games():Vector<GameConfigurationData>
        {
            return this._games;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:Int;
            var _local_5:String;
            var _local_6:String;
            var _local_7:UInt;
            var _local_8:String;
            var _local_9:UInt;
            var _local_10:String;
            var _local_11:String;
            this._games = new Vector<GameConfigurationData>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readString();
                _local_6 = k.readString();
                _local_7 = ASCompat.parseInt(_local_6, 16);
                _local_7 = (_local_7 | 0xFF000000);
                _local_8 = k.readString();
                _local_9 = ASCompat.parseInt(_local_8, 16);
                _local_9 = (_local_9 | 0xFF000000);
                _local_10 = k.readString();
                _local_11 = k.readString();
                this._games.push(new GameConfigurationData(_local_4, _local_5, _local_7, _local_9, _local_10, _local_11));
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

