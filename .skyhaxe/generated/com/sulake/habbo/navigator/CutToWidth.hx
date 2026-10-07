package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.ITextWindow;

     class CutToWidth implements BinarySearchTest 
    {
        var _value:String;
        var _text:ITextWindow;
        var _maxWidth:Int = 0;


        public function test(k:Int):Bool
        {
            this._text.text = (this._value.substring(0, k) + "...");
            return this._text.textWidth > this._maxWidth;
        }

        public function _Str_20578(k:String, _arg_2:ITextWindow, _arg_3:Int)
        {
            this._value = k;
            this._text = _arg_2;
            this._maxWidth = _arg_3;
        }
public function new(){}
    }

