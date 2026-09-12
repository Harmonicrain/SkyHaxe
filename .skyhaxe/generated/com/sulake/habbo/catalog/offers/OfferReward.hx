package com.sulake.habbo.catalog.offers
;
     class OfferReward 
    {
        var _name:String;
        var _contentType:String;
        var _classId:Int = 0;

        public function new(k:String, _arg_2:String, _arg_3:Int)
        {
            this._name = k;
            this._contentType = _arg_2;
            this._classId = _arg_3;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var contentType(get,never):String;
public function  get_contentType():String
        {
            return this._contentType;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }
    }

