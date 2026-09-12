package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class NumberInputParam
    {
        public static var DEFAULT:TextInputParam = new TextInputParam();

        var _initialValue:Int = 0;
        var _min:Int = 0;
        var _max:Int = 0;
        var _width:Int = 0;
        var _precision:Int = 0;
        var _endsWithFive:Bool = false;
        var _nonDecimalNotations:Bool = false;
        var _tooltip:String;

        public function new(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int = 45, _arg_5:Int = 0, _arg_6:Bool = false, _arg_7:Bool = false, _arg_8:String = null)
        {
            this._initialValue = _arg_1;
            this._min = _arg_2;
            this._max = _arg_3;
            this._precision = _arg_5;
            this._endsWithFive = _arg_6;
            this._width = _arg_4;
            this._nonDecimalNotations = _arg_7;
            this._tooltip = _arg_8;
        }

        public var initialValue(get,never):Int;
public function  get_initialValue():Int { return this._initialValue; }
        public var min(get,never):Int;
public function  get_min():Int { return this._min; }
        public var max(get,never):Int;
public function  get_max():Int { return this._max; }
        public var precision(get,never):Int;
public function  get_precision():Int { return this._precision; }
        public var endsWithFive(get,never):Bool;
public function  get_endsWithFive():Bool { return this._endsWithFive; }
        public var width(get,never):Int;
public function  get_width():Int { return this._width; }
        public var nonDecimalNotations(get,never):Bool;
public function  get_nonDecimalNotations():Bool { return this._nonDecimalNotations; }
        public var tooltip(get,never):String;
public function  get_tooltip():String { return this._tooltip; }
    }

