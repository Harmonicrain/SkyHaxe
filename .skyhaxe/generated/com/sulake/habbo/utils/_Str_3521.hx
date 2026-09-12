package com.sulake.habbo.utils
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.events.WindowEvent;

     class _Str_3521 
    {


        public static function setup(k:IWindowContainer, _arg_2:ASFunction)
        {
            var _local_3= k.findChildByName("user_info_region");
            _local_3.addEventListener(WindowMouseEvent.OVER, _Str_22763);
            _local_3.addEventListener(WindowMouseEvent.OUT, _Str_25615);
            _local_3.addEventListener(WindowMouseEvent.CLICK, _arg_2);
        }

        static function _Str_22763(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            _Str_3927(true, _local_2);
        }

        static function _Str_25615(k:WindowEvent)
        {
            var _local_2= cast(k.target, IRegionWindow);
            _Str_3927(false, _local_2);
        }

        public static function _Str_3927(k:Bool, _arg_2:IWindowContainer)
        {
            _arg_2.findChildByName("icon_eye_off").visible = (!k);
            _arg_2.findChildByName("icon_eye_over").visible = k;
        }

        public static function _Str_6514(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.OVER)
            {
                _Str_3521._Str_3927(true, cast(_arg_2.parent, IWindowContainer));
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    _Str_3521._Str_3927(false, cast(_arg_2.parent, IWindowContainer));
                }
            }
        }

	public function new() {}
    }

