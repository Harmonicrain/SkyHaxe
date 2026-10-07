package com.sulake.core.window.components
;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class RadioButtonController extends SelectableController implements IRadioButtonWindow 
    {
        static inline final _CAPTION_TEXT= "_CAPTION_TEXT";

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function  set_caption(k:String):String        {
            super.caption = k;
            var _local_2= getChildByName(_CAPTION_TEXT);
            if (_local_2 != null)
            {
                _local_2.caption = caption;
            }
return k;
        }

        override public function setRectangle(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            super.setRectangle(k, _arg_2, _arg_3, _arg_4);
            var _local_5= Std.downcast(getChildByName(_CAPTION_TEXT) , ITextWindow);
            if (_local_5 != null)
            {
                _local_5.width = _arg_3;
            }
        }
    }

