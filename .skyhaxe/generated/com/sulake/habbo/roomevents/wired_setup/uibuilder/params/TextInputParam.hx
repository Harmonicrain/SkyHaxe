package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class TextInputParam
    {
        public static var DEFAULT:TextInputParam = new TextInputParam();

        var _initialText:String;
        var _maxCharacters:Int = 0;
        var _placeholder:String;
        var _width:Int = 0;
        var _restrict:String;
        var _editable:Bool = false;
        var _tooltip:String;

        public function new(_arg_1:String = "", _arg_2:Int = 1000, _arg_3:String = null, _arg_4:Int = -1, _arg_5:String = null, _arg_6:Bool = true, _arg_7:String = null)
        {
            this._initialText = _arg_1;
            this._maxCharacters = _arg_2;
            this._placeholder = _arg_3;
            this._width = _arg_4;
            this._restrict = _arg_5;
            this._editable = _arg_6;
            this._tooltip = _arg_7;
        }

        public var initialText(get,never):String;
public function  get_initialText():String { return this._initialText; }
        public var maxCharacters(get,never):Int;
public function  get_maxCharacters():Int { return this._maxCharacters; }
        public var placeholder(get,never):String;
public function  get_placeholder():String { return this._placeholder; }
        public var width(get,never):Int;
public function  get_width():Int { return this._width; }
        public var restrict(get,never):String;
public function  get_restrict():String { return this._restrict; }
        public var editable(get,never):Bool;
public function  get_editable():Bool { return this._editable; }
        public var tooltip(get,never):String;
public function  get_tooltip():String { return this._tooltip; }
    }

