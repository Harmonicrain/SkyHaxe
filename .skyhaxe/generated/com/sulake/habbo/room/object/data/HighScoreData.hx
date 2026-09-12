package com.sulake.habbo.room.object.data
;
     class HighScoreData 
    {
        var _score:Int = 0;
        var _users:Array<ASAny>;

        public function new()
        {
            this._users = [];
            this._score = -1;
        }

        
        public var score(get,set):Int;
public function  get_score():Int
        {
            return this._score;
        }
public function  set_score(k:Int):Int        {
            return this._score = k;
        }

        
        public var users(get,set):Array<ASAny>;
public function  get_users():Array<ASAny>
        {
            return this._users;
        }
public function  set_users(k:Array<ASAny>):Array<ASAny>        {
            return this._users = k;
        }

        public function addUser(k:String)
        {
            this._users.push(k);
        }
    }

