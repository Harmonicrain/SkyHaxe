package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class JumpBy extends Interval 
    {
        var _startX:Int = 0;
        var _startY:Int = 0;
        var _deltaX:Float = Math.NaN;
        var _deltaY:Float = Math.NaN;
        var _height:Float = Math.NaN;
        var _numJumps:Int = 0;

        public function new(k:IWindow, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            super(k, _arg_2);
            this._deltaX = _arg_3;
            this._deltaY = _arg_4;
            this._height = -_arg_5;
            this._numJumps = _arg_6;
        }

        public override function start()
        {
            super.start();
            this._startX = target.x;
            this._startY = target.y;
        }

        public override function update(k:Float)
        {
            super.update(k);
            target.x = Std.int(this._startX + (this._deltaX * k));
            target.y = Std.int((this._startY + (this._height * Math.abs(Math.sin(((k * Math.PI) * this._numJumps))))) + (this._deltaY * k));
        }
    }

