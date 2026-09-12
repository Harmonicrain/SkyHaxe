package com.sulake.habbo.communication.messages.parser.game.lobby
;
     class GameConfigurationData
    {
        var _Str_11002:Int = 0;
        var _Str_9763:String;
        var _bgColor:UInt = 0;
        var _textColor:UInt = 0;
        var _Str_5746:String;
        var _Str_11032:String;

        public function new(k:Int, _arg_2:String, _arg_3:UInt, _arg_4:UInt, _arg_5:String, _arg_6:String)
        {
            this._Str_11002 = k;
            this._Str_9763 = _arg_2;
            this._bgColor = _arg_3;
            this._textColor = _arg_4;
            this._Str_5746 = _arg_5;
            this._Str_11032 = _arg_6;
        }

        public var gameId(get,never):Int;
public function  get_gameId():Int
        {
            return this._Str_11002;
        }

        public var gameNameId(get,never):String;
public function  get_gameNameId():String
        {
            return this._Str_9763;
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
            return this._Str_5746;
        }

        public var supportUrl(get,never):String;
public function  get_supportUrl():String
        {
            return this._Str_11032;
        }
    }

