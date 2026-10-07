package com.sulake.habbo.communication.messages.incoming.room.pets
;
     class PetBreedingResultData
    {
        var _stuffId:Int = 0;
        var _classId:Int = 0;
        var _productCode:String;
        var _userId:Int = 0;
        var _userName:String;
        var _rarityLevel:Int = 0;
        var _Str_19401:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:String, _arg_6:Int, _arg_7:Bool)
        {
            this._stuffId = k;
            this._classId = _arg_2;
            this._productCode = _arg_3;
            this._userId = _arg_4;
            this._userName = _arg_5;
            this._rarityLevel = _arg_6;
            this._Str_19401 = _arg_7;
        }

        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var rarityLevel(get,never):Int;
public function  get_rarityLevel():Int
        {
            return this._rarityLevel;
        }

        public var _Str_4788(get,never):Bool;
public function  get__Str_4788():Bool
        {
            return this._Str_19401;
        }
    }

