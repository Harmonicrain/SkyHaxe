package com.sulake.core.window.services
;
    import flash.display.DisplayObject;
    import com.sulake.core.window._enum.WindowParam;

     class WindowMouseScaler extends WindowMouseOperator implements IMouseScalingService 
    {
        public function new(k:DisplayObject)
        {
            super(k);
        }

        override public function operate(k:Int, _arg_2:Int)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            if (!window.disposed)
            {
                _local_3 = Std.int(((ASCompat.toInt(_Str_829 )& ASCompat.toInt(WindowParam.WINDOW_PARAM_HORIZONTAL_MOUSE_SCALING_TRIGGER)) != 0) ? Std.int(k - _Str_3282.x) : 0);
                _local_4 = Std.int(((ASCompat.toInt(_Str_829 )& ASCompat.toInt(WindowParam.WINDOW_PARAM_VERTICAL_MOUSE_SCALING_TRIGGER)) != 0) ? Std.int(_arg_2 - _Str_3282.y) : 0);
                window.scale(_local_3, _local_4);
            }
        }
    }

