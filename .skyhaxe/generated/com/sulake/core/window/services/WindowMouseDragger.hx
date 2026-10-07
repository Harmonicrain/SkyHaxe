package com.sulake.core.window.services
;
    import flash.display.DisplayObject;

     class WindowMouseDragger extends WindowMouseOperator implements IMouseDraggingService 
    {
        public function new(k:DisplayObject)
        {
            super(k);
        }

        override public function operate(k:Int, _arg_2:Int)
        {
            _Str_3282.x = k;
            _Str_3282.y = _arg_2;
            getMousePositionRelativeTo(window, _Str_3282, _Str_3368);
            window.offset((_Str_3368.x - _offset.x), (_Str_3368.y - _offset.y));
        }
    }

