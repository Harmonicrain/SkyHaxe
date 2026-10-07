package com.sulake.habbo.communication.messages.parser.competition
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication._enum.CompetitionVotingInfoResult;

     class CompetitionVotingInfoMessageParser implements IMessageParser
    {
        var _goalId:Int = 0;
        var _goalCode:String;
        var _resultCode:Int = 0;
        var _votesRemaining:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._goalId = k.readInteger();
            this._goalCode = k.readString();
            this._resultCode = k.readInteger();
            this._votesRemaining = k.readInteger();
            return true;
        }

        public var goalId(get,never):Int;
public function  get_goalId():Int
        {
            return this._goalId;
        }

        public var goalCode(get,never):String;
public function  get_goalCode():String
        {
            return this._goalCode;
        }

        public var isVotingAllowedForUser(get,never):Bool;
public function  get_isVotingAllowedForUser():Bool
        {
            return this._resultCode == CompetitionVotingInfoResult.ALLOWED;
        }

        public var votesRemaining(get,never):Int;
public function  get_votesRemaining():Int
        {
            return this._votesRemaining;
        }

        public var resultCode(get,never):Int;
public function  get_resultCode():Int
        {
            return this._resultCode;
        }

	public function new() {}
    }

