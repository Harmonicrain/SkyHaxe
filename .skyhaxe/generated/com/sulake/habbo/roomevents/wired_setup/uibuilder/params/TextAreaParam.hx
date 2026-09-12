package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class TextAreaParam
    {
        var _height:Int = 0;
        var _width:Int = 0;
        var _maxLines:Int = 0;
        var _maxCharactersPerLine:Int = 0;
        var _maxCharacters:Int = 0;
        var _initialText:String;
        var _placeholder:String;
        var _restrict:String;
        var _editable:Bool = false;
        var _wordwrap:Bool = false;
        var _tooltip:String;

        public function new(_arg_1:Int, _arg_2:Int = -1, _arg_3:Int = -1, _arg_4:Int = -1, _arg_5:Int = 1000, _arg_6:String = "", _arg_7:String = null, _arg_8:String = null, _arg_9:Bool = true, _arg_10:Bool = false, _arg_11:String = null)
        {
            this._height = _arg_1;
            this._width = _arg_2;
            this._maxLines = _arg_3;
            this._maxCharactersPerLine = _arg_4;
            this._maxCharacters = _arg_5;
            this._initialText = _arg_6;
            this._placeholder = _arg_7;
            this._restrict = _arg_8;
            this._editable = _arg_9;
            this._wordwrap = _arg_10;
            this._tooltip = _arg_11;
        }

        public var height(get,never):Int;
public function  get_height():Int { return this._height; }
        public var width(get,never):Int;
public function  get_width():Int { return this._width; }
        public var maxLines(get,never):Int;
public function  get_maxLines():Int { return this._maxLines; }
        public var maxCharactersPerLine(get,never):Int;
public function  get_maxCharactersPerLine():Int { return this._maxCharactersPerLine; }
        public var maxCharacters(get,never):Int;
public function  get_maxCharacters():Int { return this._maxCharacters; }
        public var initialText(get,never):String;
public function  get_initialText():String { return this._initialText; }
        public var placeholder(get,never):String;
public function  get_placeholder():String { return this._placeholder; }
        public var editable(get,never):Bool;
public function  get_editable():Bool { return this._editable; }
        public var restrict(get,never):String;
public function  get_restrict():String { return this._restrict; }
        public var wordwrap(get,never):Bool;
public function  get_wordwrap():Bool { return this._wordwrap; }
        public var tooltip(get,never):String;
public function  get_tooltip():String { return this._tooltip; }
    }

