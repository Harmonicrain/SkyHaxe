package com.sulake.habbo.userclassification
;
     class UserClassificationData 
    {
        public static var PILLAR_CLASSIFICATION:UInt = 1;
        public static var NEW_USER_CLASSIFICATION:UInt = 2;
        public static var WHALE_CLASSIFICATION:UInt = 3;
        public static var PAYING_USER_CLASSIFICATION:UInt = 4;

        var _userId:Int = 0;
        var _username:String;
        var _classType:String;

        public function new(k:Int, _arg_2:String, _arg_3:String)
        {
            this._userId = k;
            this._username = _arg_2;
            this._classType = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var username(get,never):String;
public function  get_username():String
        {
            return this._username;
        }

        public var classType(get,never):String;
public function  get_classType():String
        {
            return this._classType;
        }

        public function toString():String
        {
            return ((((("[" + Std.string(this._userId)) + ", ") + this._username) + "] [") + this._classType) + "]";
        }
    }

