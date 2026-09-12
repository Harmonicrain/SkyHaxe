package com.sulake.habbo.roomevents.wired_setup.common.utils
;
     class ChronoFieldRangeFilter
    {
        var _name:String;
        var _useFilter:Bool = false;
        var _min:Int = 0;
        var _max:Int = 0;
        var _defaultValue:Int = 0;

        public function new(name:String, useFilter:Bool, min:Int, max:Int, defaultValue:Int = 0)
        {
            this._name = name;
            this._useFilter = useFilter;
            this._min = min;
            this._max = max;
            this._defaultValue = defaultValue;
        }

        public var name(get,never):String;
public function  get_name():String { return this._name; }
        public var useFilter(get,never):Bool;
public function  get_useFilter():Bool { return this._useFilter; }
        public var min(get,never):Int;
public function  get_min():Int { return this._min; }
        public var max(get,never):Int;
public function  get_max():Int { return this._max; }
        public var defaultValue(get,never):Int;
public function  get_defaultValue():Int { return this._defaultValue; }
    }

