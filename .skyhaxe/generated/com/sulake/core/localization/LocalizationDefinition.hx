package com.sulake.core.localization
;
     class LocalizationDefinition implements ILocalizationDefinition 
    {
        var _languageCode:String;
        var _countryCode:String;
        var _encoding:String;
        var _name:String;
        var _url:String;

        public function new(definition:String, name:String, url:String)
        {
            var values:Array<ASAny> = (cast definition.split("_"));
            this._languageCode = values[0];
            var lanEncode:Array<ASAny> = (cast ASCompat.toString(values[1]).split("."));
            this._countryCode = lanEncode[0];
            this._encoding = lanEncode[1];
            this._name = name;
            this._url = url;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return (((this._languageCode + "_") + this._countryCode) + ".") + this._encoding;
        }

        public var languageCode(get,never):String;
public function  get_languageCode():String
        {
            return this._languageCode;
        }

        public var countryCode(get,never):String;
public function  get_countryCode():String
        {
            return this._countryCode;
        }

        public var encoding(get,never):String;
public function  get_encoding():String
        {
            return this._encoding;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var url(get,never):String;
public function  get_url():String
        {
            return this._url;
        }
    }

