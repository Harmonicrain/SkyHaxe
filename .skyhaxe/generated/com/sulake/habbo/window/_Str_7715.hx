package com.sulake.habbo.window
;
    import com.sulake.core.window.IWindow;

     class _Str_7715 
    {
        var _key:String;
        var _window:IWindow;
        var _style:Int = 0;

        public function new(k:IWindow, _arg_2:String, _arg_3:Int)
        {
            this._window = k;
            this._key = _arg_2;
            this._style = _arg_3;
        }

        
        public var window(get,set):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }
public function  set_window(k:IWindow):IWindow        {
            return this._window = k;
        }

        
        public var key(get,set):String;
public function  get_key():String
        {
            return this._key;
        }
public function  set_key(k:String):String        {
            return this._key = k;
        }

        
        public var style(get,set):Int;
public function  get_style():Int
        {
            return this._style;
        }
public function  set_style(k:Int):Int        {
            return this._style = k;
        }
    }

