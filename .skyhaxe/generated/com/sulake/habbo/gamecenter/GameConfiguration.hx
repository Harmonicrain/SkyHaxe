package com.sulake.habbo.gamecenter
;
     class GameConfiguration 
    {
        var _gameId:Int = 0;
        var _gameNameId:String;
        var _bgColor:UInt = 0;
        var _textColor:UInt = 0;
        var _assetUrl:String;
        var _supportUrl:String;

        public function new(k:Int, _arg_2:String, _arg_3:UInt, _arg_4:UInt, _arg_5:String, _arg_6:String)
        {
            this._gameId = k;
            this._gameNameId = _arg_2;
            this._bgColor = _arg_3;
            this._textColor = _arg_4;
            this._assetUrl = _arg_5;
            this._supportUrl = _arg_6;
            if (this._assetUrl.substr((this._assetUrl.length - 1), 1) != "/")
            {
                this._assetUrl = (this._assetUrl + "/");
            }
        }

        public var gameId(get,never):Int;
public function  get_gameId():Int
        {
            return this._gameId;
        }

        public var gameNameId(get,never):String;
public function  get_gameNameId():String
        {
            return this._gameNameId;
        }

        public var bgColor(get,never):UInt;
public function  get_bgColor():UInt
        {
            return this._bgColor;
        }

        public var textColor(get,never):UInt;
public function  get_textColor():UInt
        {
            return this._textColor;
        }

        public var assetUrl(get,never):String;
public function  get_assetUrl():String
        {
            return this._assetUrl;
        }

        public var supportUrl(get,never):String;
public function  get_supportUrl():String
        {
            return this._supportUrl;
        }
    }

