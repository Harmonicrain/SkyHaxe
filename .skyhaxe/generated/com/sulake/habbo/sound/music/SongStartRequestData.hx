package com.sulake.habbo.sound.music
;

     class SongStartRequestData 
    {
        var _songId:Int = 0;
        var _startPos:Float = Math.NaN;
        var _playLength:Float = Math.NaN;
        var _playRequestTime:Int = 0;
        var _fadeInSeconds:Float = Math.NaN;
        var _fadeOutSeconds:Float = Math.NaN;

        public function new(k:Int, _arg_2:Float, _arg_3:Float, _arg_4:Float=2, _arg_5:Float=1)
        {
            this._songId = k;
            this._startPos = _arg_2;
            this._playLength = _arg_3;
            this._fadeInSeconds = _arg_4;
            this._fadeOutSeconds = _arg_5;
            this._playRequestTime = flash.Lib.getTimer();
        }

        public var songId(get,never):Int;
public function  get_songId():Int
        {
            return this._songId;
        }

        public var startPos(get,never):Float;
public function  get_startPos():Float
        {
            if (this._startPos < 0)
            {
                return 0;
            }
            return this._startPos + ((flash.Lib.getTimer() - this._playRequestTime) / 1000);
        }

        public var playLength(get,never):Float;
public function  get_playLength():Float
        {
            return this._playLength;
        }

        public var fadeInSeconds(get,never):Float;
public function  get_fadeInSeconds():Float
        {
            return this._fadeInSeconds;
        }

        public var fadeOutSeconds(get,never):Float;
public function  get_fadeOutSeconds():Float
        {
            return this._fadeOutSeconds;
        }
    }

