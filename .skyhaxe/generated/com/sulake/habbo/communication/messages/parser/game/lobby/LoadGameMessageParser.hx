package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LoadGameMessageParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _url:String;
        var _quality:String;
        var _scaleMode:String;
        var _frameRate:Int = 0;
        var _minMajorVersion:Int = 0;
        var _minMinorVersion:Int = 0;
        var _params:ASObject;
        var _gameClientId:String;


        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }

        public var quality(get,never):String;
public function  get_quality():String
        {
            return this._quality;
        }

        public var scaleMode(get,never):String;
public function  get_scaleMode():String
        {
            return this._scaleMode;
        }

        public var frameRate(get,never):Int;
public function  get_frameRate():Int
        {
            return this._frameRate;
        }

        public var minMajorVersion(get,never):Int;
public function  get_minMajorVersion():Int
        {
            return this._minMajorVersion;
        }

        public var minMinorVersion(get,never):Int;
public function  get_minMinorVersion():Int
        {
            return this._minMinorVersion;
        }

        public var params(get,never):ASObject;
public function  get_params():ASObject
        {
            return this._params;
        }

        public var _Str_12486(get,never):String;
public function  get__Str_12486():String
        {
            return this._gameClientId;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._gameClientId = k.readString();
            this._url = k.readString();
            this._quality = k.readString();
            this._scaleMode = k.readString();
            this._frameRate = k.readInteger();
            this._minMajorVersion = k.readInteger();
            this._minMinorVersion = k.readInteger();
            this._params = new ASObject();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
ASCompat.setDynamicProperty(                this.params, k.readString(), k.readString());
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

