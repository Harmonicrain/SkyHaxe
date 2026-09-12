package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class ResizeTo extends Interval 
    {
        var _startW:Float = Math.NaN;
        var _startH:Float = Math.NaN;
        var _endW:Float = Math.NaN;
        var _endH:Float = Math.NaN;
        var _deltaW:Float = Math.NaN;
        var _deltaH:Float = Math.NaN;

        public function new(k:IWindow, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super(k, _arg_2);
            this._endW = _arg_3;
            this._endH = _arg_4;
        }

        public override final function start()
        {
            super.start();
            this._startW = target.width;
            this._startH = target.height;
            this._deltaW = (this._endW - this._startW);
            this._deltaH = (this._endH - this._startH);
        }

        public override final function update(k:Float)
        {
            target.width = Std.int(this._startW + (this._deltaW * k));
            target.height = Std.int(this._startH + (this._deltaH * k));
        }
    }

