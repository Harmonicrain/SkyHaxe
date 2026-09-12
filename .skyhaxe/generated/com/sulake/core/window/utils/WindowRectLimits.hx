package com.sulake.core.window.utils
;
    import com.sulake.core.window.IWindow;

     class WindowRectLimits implements IRectLimiter 
    {
        var _minWidth:Int = Std.int(-2147483648);
        var _maxWidth:Int = 2147483647;
        var _minHeight:Int = Std.int(-2147483648);
        var _maxHeight:Int = 2147483647;
        var _target:IWindow;

        public function new(target:IWindow)
        {
            this._target = target;
        }

        
        public var minWidth(get,set):Int;
public function  get_minWidth():Int
        {
            return this._minWidth;
        }

        
        public var maxWidth(get,set):Int;
public function  get_maxWidth():Int
        {
            return this._maxWidth;
        }

        
        public var minHeight(get,set):Int;
public function  get_minHeight():Int
        {
            return this._minHeight;
        }

        
        public var maxHeight(get,set):Int;
public function  get_maxHeight():Int
        {
            return this._maxHeight;
        }
public function  set_minWidth(minWidth:Int):Int        {
            this._minWidth = minWidth;
            if ((((this._minWidth > ASCompat.MIN_INT) && (!this._target.disposed)) && (this._target.width < this._minWidth)))
            {
                this._target.width = this._minWidth;
            }
return minWidth;
        }
public function  set_maxWidth(maxWidth:Int):Int        {
            this._maxWidth = maxWidth;
            if ((((this._maxWidth < ASCompat.MAX_INT) && (!this._target.disposed)) && (this._target.width > this._maxWidth)))
            {
                this._target.width = this._maxWidth;
            }
return maxWidth;
        }
public function  set_minHeight(minHeight:Int):Int        {
            this._minHeight = minHeight;
            if ((((this._minHeight > ASCompat.MIN_INT) && (!this._target.disposed)) && (this._target.height < this._minHeight)))
            {
                this._target.height = this._minHeight;
            }
return minHeight;
        }
public function  set_maxHeight(maxHeight:Int):Int        {
            this._maxHeight = maxHeight;
            if ((((this._maxHeight < ASCompat.MAX_INT) && (!this._target.disposed)) && (this._target.height > this._maxHeight)))
            {
                this._target.height = this._maxHeight;
            }
return maxHeight;
        }

        public var isEmpty(get,never):Bool;
public function  get_isEmpty():Bool
        {
            return (((this._minWidth == ASCompat.MIN_INT) && (this._maxWidth == ASCompat.MAX_INT)) && (this._minHeight == ASCompat.MIN_INT)) && (this._maxHeight == ASCompat.MAX_INT);
        }

        public function setEmpty()
        {
            this._minWidth = ASCompat.MIN_INT;
            this._maxWidth = ASCompat.MAX_INT;
            this._minHeight = ASCompat.MIN_INT;
            this._maxHeight = ASCompat.MAX_INT;
        }

        public function limit()
        {
            if (((!this.isEmpty) && (this._target != null)))
            {
                if (this._target.width < this._minWidth)
                {
                    this._target.width = this._minWidth;
                }
                else
                {
                    if (this._target.width > this._maxWidth)
                    {
                        this._target.width = this._maxWidth;
                    }
                }
                if (this._target.height < this._minHeight)
                {
                    this._target.height = this._minHeight;
                }
                else
                {
                    if (this._target.height > this._maxHeight)
                    {
                        this._target.height = this._maxHeight;
                    }
                }
            }
        }

        public function assign(minWidth:Int, maxWidth:Int, minHeight:Int, maxHeight:Int)
        {
            this._minWidth = minWidth;
            this._maxWidth = maxWidth;
            this._minHeight = minHeight;
            this._maxHeight = maxHeight;
            this.limit();
        }

        public function clone(k:IWindow):WindowRectLimits
        {
            var limits= new WindowRectLimits(k);
            limits._minWidth = this._minWidth;
            limits._maxWidth = this._maxWidth;
            limits._minHeight = this._minHeight;
            limits._maxHeight = this._maxHeight;
            return limits;
        }
    }

