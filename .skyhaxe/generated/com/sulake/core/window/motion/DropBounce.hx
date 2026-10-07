package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class DropBounce extends Interval 
    {
        var _height:Int = 0;
        var _offset:Int = 0;

        public function new(k:IWindow, _arg_2:Int, _arg_3:Int)
        {
            super(k, _arg_2);
            this._height = _arg_3;
        }

        public override final function start()
        {
            super.start();
            this._offset = target.y;
            target.y = (this._offset - this._height);
        }

        public override final function update(k:Float)
        {
            super.update(k);
            target.y = Std.int((this._offset - this._height) + (this.getBounceOffset(k) * this._height));
        }

        function getBounceOffset(k:Float):Float
        {
            if (k < 0.364)
            {
                return (7.5625 * k) * k;
            }
            if (k < 0.727)
            {
                k = (k - 0.545);
                return ((7.5625 * k) * k) + 0.75;
            }
            if (k < 0.909)
            {
                k = (k - 0.9091);
                return ((7.5625 * k) * k) + 0.9375;
            }
            k = (k - 0.955);
            return ((7.5625 * k) * k) + 0.984375;
        }

        public override final function stop()
        {
            target.y = this._offset;
            super.stop();
        }
    }

