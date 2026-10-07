package com.sulake.habbo.catalog.navigation
;
     class RequestedPage 
    {
        public static inline final REQUEST_TYPE_NONE= 0;
        public static inline final REQUEST_TYPE_ID= 1;
        public static inline final REQUEST_TYPE_NAME= 2;

        var _requestType:Int = 0;
        var _requestId:Int = 0;
        var _requestedOfferId:Int = 0;
        var _requestName:String;

        public function new()
        {
            this._requestType = REQUEST_TYPE_NONE;
        }

        public var requestById(never,set):Int;
public function  set_requestById(k:Int):Int        {
            this._requestType = REQUEST_TYPE_ID;
            return this._requestId = k;
        }

        public var requestByName(never,set):String;
public function  set_requestByName(k:String):String        {
            this._requestType = REQUEST_TYPE_NAME;
            return this._requestName = k;
        }

        public function resetRequest()
        {
            this._requestType = REQUEST_TYPE_NONE;
            this._requestedOfferId = -1;
        }

        public var requestType(get,never):Int;
public function  get_requestType():Int
        {
            return this._requestType;
        }

        public var requestId(get,never):Int;
public function  get_requestId():Int
        {
            return this._requestId;
        }

        
        public var requestedOfferId(get,set):Int;
public function  get_requestedOfferId():Int
        {
            return this._requestedOfferId;
        }
public function  set_requestedOfferId(k:Int):Int        {
            return this._requestedOfferId = k;
        }

        public var requestName(get,never):String;
public function  get_requestName():String
        {
            return this._requestName;
        }
    }

