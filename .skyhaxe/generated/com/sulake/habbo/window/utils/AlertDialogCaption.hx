package com.sulake.habbo.window.utils
;
     class AlertDialogCaption implements ICaption
    {
        var _text:String;
        var _toolTip:String;
        var _visible:Bool = false;

        public function new(k:String, _arg_2:String, _arg_3:Bool)
        {
            this._text = k;
            this._toolTip = _arg_2;
            this._visible = _arg_3;
        }

        
        public var text(get,set):String;
public function  get_text():String
        {
            return this._text;
        }
public function  set_text(k:String):String        {
            return this._text = k;
        }

        
        public var toolTip(get,set):String;
public function  get_toolTip():String
        {
            return this._toolTip;
        }
public function  set_toolTip(k:String):String        {
            return this._toolTip = k;
        }

        
        public var visible(get,set):Bool;
public function  get_visible():Bool
        {
            return this._visible;
        }
public function  set_visible(k:Bool):Bool        {
            return this._visible = k;
        }
    }

