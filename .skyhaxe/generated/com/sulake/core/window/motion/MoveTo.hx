package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class MoveTo extends Interval 
    {
        var _startX:Float = Math.NaN;
        var _startY:Float = Math.NaN;
        var _endX:Float = Math.NaN;
        var _endY:Float = Math.NaN;
        var _deltaX:Float = Math.NaN;
        var _deltaY:Float = Math.NaN;

        public function new(k:IWindow, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super(k, _arg_2);
            this._endX = _arg_3;
            this._endY = _arg_4;
        }

        public override function start()
        {
            super.start();
            this._startX = target.x;
            this._startY = target.y;
            this._deltaX = (this._endX - this._startX);
            this._deltaY = (this._endY - this._startY);
        }

        public override function update(k:Float)
        {
            target.x = Std.int(this._startX + (this._deltaX * k));
            target.y = Std.int(this._startY + (this._deltaY * k));
        }
    }

