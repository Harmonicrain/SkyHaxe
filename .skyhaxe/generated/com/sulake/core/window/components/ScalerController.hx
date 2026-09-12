package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class ScalerController extends InteractiveController implements IScalerWindow 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }
    }

