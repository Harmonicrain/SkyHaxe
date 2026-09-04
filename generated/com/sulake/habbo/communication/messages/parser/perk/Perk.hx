package com.sulake.habbo.communication.messages.parser.perk
;
     class Perk
    {
        var _code:String;
        var _isAllowed:Bool = false;
        var _errorMessage:String = "";


        
        public var code(get,set):String;
function  get_code():String
        {
            return this._code;
        }
function  set_code(k:String):String        {
            return this._code = k;
        }

        
        public var isAllowed(get,set):Bool;
function  get_isAllowed():Bool
        {
            return this._isAllowed;
        }
function  set_isAllowed(k:Bool):Bool        {
            return this._isAllowed = k;
        }

        
        public var errorMessage(get,set):String;
function  get_errorMessage():String
        {
            return this._errorMessage;
        }
function  set_errorMessage(k:String):String        {
            return this._errorMessage = k;
        }
public function new(){}
    }

