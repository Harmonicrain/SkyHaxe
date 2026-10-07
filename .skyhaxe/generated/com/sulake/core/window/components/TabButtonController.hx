package com.sulake.core.window.components
;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;

     class TabButtonController extends SelectableController implements ITabButtonWindow 
    {
        static inline final TAB_BUTTON_CONTENT= "TAB_BUTTON_CONTENT";
        static inline final TAB_BUTTON_TITLE= "TAB_BUTTON_TITLE";
        static inline final TAB_BUTTON_ICON= "TAB_BUTTON_ICON";

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function  set_caption(k:String):String        {
            super.caption = k;
            var _local_2= findChildByTag(TAB_BUTTON_TITLE);
            if (_local_2 != null)
            {
                _local_2.caption = k;
            }
return k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_CHILD_RESIZED)
            {
                WindowController.resizeToAccommodateChildren(this);
            }
            return super.update(k, _arg_2);
        }
    }

