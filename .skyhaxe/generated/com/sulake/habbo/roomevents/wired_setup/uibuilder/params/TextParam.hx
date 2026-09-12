package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
     class TextParam
    {
        public static inline final NO_COLOR_OVERRIDE:UInt = 0;
        public static inline final MODE_STRETCH= 0;
        public static inline final MODE_MULTILINE= 1;
        public static inline final MODE_OVERFLOW= 2;
        public static final DEFAULT:TextParam = new TextParam(1, false);

        var _mode:Int = 0;
        var _bold:Bool = false;
        var _maxLines:Int = 0;
        var _underline:Bool = false;
        var _alignment:String;
        var _fontSize:Int = -1;
        var _textColor:UInt = 0;

        public function new(_arg_1:Int, _arg_2:Bool = false, _arg_3:Int = 0, _arg_4:Bool = false, _arg_5:String = null)
        {
            this._mode = _arg_1;
            this._bold = _arg_2;
            this._maxLines = _arg_3;
            this._underline = _arg_4;
            this._alignment = _arg_5;
        }

        public var mode(get,never):Int;
public function  get_mode():Int { return this._mode; }
        public var bold(get,never):Bool;
public function  get_bold():Bool { return this._bold; }
        public var maxLines(get,never):Int;
public function  get_maxLines():Int { return this._maxLines; }
        public var underline(get,never):Bool;
public function  get_underline():Bool { return this._underline; }
        public var alignment(get,never):String;
public function  get_alignment():String { return this._alignment; }
                public var fontSize(get,set):Int;
public function  get_fontSize():Int { return this._fontSize; }
public function  set_fontSize(_arg_1:Int):Int{ return this._fontSize = _arg_1; }
                public var textColor(get,set):UInt;
public function  get_textColor():UInt { return this._textColor; }
public function  set_textColor(_arg_1:UInt):UInt{ return this._textColor = _arg_1; }
    }

