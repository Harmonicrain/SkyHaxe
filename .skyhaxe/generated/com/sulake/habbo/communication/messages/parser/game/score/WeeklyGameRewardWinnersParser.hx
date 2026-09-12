package com.sulake.habbo.communication.messages.parser.game.score
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class WeeklyGameRewardWinnersParser implements IMessageParser
    {
        var _gameTypeId:Int = 0;
        var _Str_15876:Array<ASAny>;

        public function new()
        {
            this._Str_15876 = [];
        }

        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var _Str_24920(get,never):Array<ASAny>;
public function  get__Str_24920():Array<ASAny>
        {
            return this._Str_15876;
        }

        public function flush():Bool
        {
            this._gameTypeId = -1;
            this._Str_15876 = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_15876.push(new GameRewardWinnerEntry(k));
                _local_3++;
            }
            return true;
        }
    }

