package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HallOfFameEntryData implements ILandingPageUserEntry
    {
        var _userId:Int = 0;
        var _userName:String;
        var _figure:String;
        var _rank:Int = 0;
        var _currentScore:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._userId = k.readInteger();
            this._userName = k.readString();
            this._figure = k.readString();
            this._rank = k.readInteger();
            this._currentScore = k.readInteger();
        }

        public var userId(get,never):Int;
function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
function  get_userName():String
        {
            return this._userName;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return this._figure;
        }

        public var rank(get,never):Int;
function  get_rank():Int
        {
            return this._rank;
        }

        public var _Str_7605(get,never):Int;
function  get__Str_7605():Int
        {
            return this._currentScore;
        }
    }

