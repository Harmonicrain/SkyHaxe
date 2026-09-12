package com.sulake.habbo.ui.widget.furniture.leaderboard
;
     class LeaderboardEntry
    {
        var _userId:Int = 0;
        var _rank:Int = 0;
        var _username:String;
        var _figure:String;
        var _gender:String;
        var _value:Int = 0;
        var _own:Bool = false;

        public function new(data:ASObject)
        {
            if (data == null)
            {
                data = {};
            }
            this._userId = ASCompat.toInt(data.userId);
            this._rank = ASCompat.toInt(data.rank);
            this._username = data.username == null ? "" : ASCompat.toString(data.username);
            this._figure = data.figure == null ? "" : ASCompat.toString(data.figure);
            this._gender = data.gender == null ? "" : ASCompat.toString(data.gender);
            this._value = ASCompat.toInt(data.value);
            this._own = ASCompat.toBool(data.own);
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var rank(get,never):Int;
public function  get_rank():Int
        {
            return this._rank;
        }

        public var rankCaption(get,never):String;
public function  get_rankCaption():String
        {
            return this._rank > 0 ? Std.string(this._rank) : "--";
        }

        public var username(get,never):String;
public function  get_username():String
        {
            return this._username;
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

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._value;
        }

        public var own(get,never):Bool;
public function  get_own():Bool
        {
            return this._own;
        }
    }

