package com.sulake.habbo.navigator
;
    import com.sulake.core.window.components.ITextWindow;

     class CutToHeight implements BinarySearchTest 
    {
        var _value:String;
        var _text:ITextWindow;
        var _maxHeight:Int = 0;


        public function test(k:Int):Bool
        {
            this._text.text = (this._value.substring(0, k) + "...");
            return this._text.textHeight > this._maxHeight;
        }

        public function _Str_20578(k:String, _arg_2:ITextWindow, _arg_3:Int)
        {
            this._value = k;
            this._text = _arg_2;
            this._maxHeight = _arg_3;
        }
public function new(){}
    }

