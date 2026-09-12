package com.sulake.habbo.catalog.event
;
     class CatalogUserEvent extends CatalogEvent 
    {
        var _userId:Int = 0;
        var _userName:String;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._userId = _arg_2;
            this._userName = _arg_3;
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
    }

