package com.sulake.core.window.utils
;
    import com.sulake.core.runtime.IDisposable;

     class TextMargins implements IMargins implements  IDisposable 
    {
        var _left:Int = 0;
        var _right:Int = 0;
        var _top:Int = 0;
        var _bottom:Int = 0;
        var _callback:ASFunction;
        var _disposed:Bool = false;

        public function new(left:Int, top:Int, right:Int, bottom:Int, callback:ASFunction)
        {
            this._left = left;
            this._top = top;
            this._right = right;
            this._bottom = bottom;
            this._callback = ((callback != null) ? callback : this.nullCallback);
        }

        
        public var left(get,set):Int;
public function  get_left():Int
        {
            return this._left;
        }

        
        public var right(get,set):Int;
public function  get_right():Int
        {
            return this._right;
        }

        
        public var top(get,set):Int;
public function  get_top():Int
        {
            return this._top;
        }

        
        public var bottom(get,set):Int;
public function  get_bottom():Int
        {
            return this._bottom;
        }
public function  set_left(left:Int):Int        {
            this._left = left;
            this._callback(this);
return left;
        }
public function  set_right(right:Int):Int        {
            this._right = right;
            this._callback(this);
return right;
        }
public function  set_top(top:Int):Int        {
            this._top = top;
            this._callback(this);
return top;
        }
public function  set_bottom(bottom:Int):Int        {
            this._bottom = bottom;
            this._callback(this);
return bottom;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isZeroes(get,never):Bool;
public function  get_isZeroes():Bool
        {
            return (((this._left == 0) && (this._right == 0)) && (this._top == 0)) && (this._bottom == 0);
        }

        public function assign(left:Int, top:Int, right:Int, bottom:Int, callback:ASFunction)
        {
            this._left = left;
            this._top = top;
            this._right = right;
            this._bottom = bottom;
            this._callback = ((callback != null) ? callback : this.nullCallback);
        }

        public function clone(callback:ASFunction):TextMargins
        {
            return new TextMargins(this._left, this._top, this._right, this._bottom, callback);
        }

        public function dispose()
        {
            this._callback = null;
            this._disposed = true;
        }

        function nullCallback(k:IMargins)
        {
        }
    }

