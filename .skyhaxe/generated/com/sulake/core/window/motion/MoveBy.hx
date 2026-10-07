package com.sulake.core.window.motion
;
    import com.sulake.core.window.IWindow;

     class MoveBy extends MoveTo 
    {
        public function new(k:IWindow, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        public override final function start()
        {
            _endX = (target.x + _endX);
            _endY = (target.y + _endY);
            super.start();
        }
    }

