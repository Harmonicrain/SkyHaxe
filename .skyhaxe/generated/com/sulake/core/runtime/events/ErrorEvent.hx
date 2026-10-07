package com.sulake.core.runtime.events
;
     class ErrorEvent extends WarningEvent 
    {
        var _category:Int = 0;
        var _critical:Bool = false;
        var _error:ASError;

        public function new(type:String, message:String, critical:Bool, category:Int, error:ASError=null)
        {
            this._critical = critical;
            this._category = category;
            this._error = error;
            super(type, message);
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }

        public var critical(get,never):Bool;
public function  get_critical():Bool
        {
            return this._critical;
        }

        public var error(get,never):ASError;
public function  get_error():ASError
        {
            return this._error;
        }
    }

