package com.sulake.habbo.communication.messages.parser.game.score
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LeaderboardEntry
    {
        var _userId:Int = 0;
        var _score:Int = 0;
        var _rank:Int = 0;
        var _name:String;
        var _figure:String;
        var _gender:String;

        public function new(k:IMessageDataWrapper)
        {
            this._userId = k.readInteger();
            this._score = k.readInteger();
            this._rank = k.readInteger();
            this._name = k.readString();
            this._figure = k.readString();
            this._gender = k.readString();
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

        public var rank(get,never):Int;
public function  get_rank():Int
        {
            return this._rank;
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

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }
    }

