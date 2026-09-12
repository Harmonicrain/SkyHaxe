package com.sulake.core.window.components
;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class HeaderController extends ContainerController implements IHeaderWindow 
    {
        static inline final _TITLE= "_TITLE";
        static inline final _CONTROLS= "_CONTROLS";

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public var title(get,never):ILabelWindow;
public function  get_title():ILabelWindow
        {
            return Std.downcast(findChildByTag(_TITLE) , ILabelWindow);
        }

        public var controls(get,never):IItemListWindow;
public function  get_controls():IItemListWindow
        {
            return Std.downcast(findChildByTag(_CONTROLS) , IItemListWindow);
        }

        override public function  set_caption(value:String):String        {
            super.caption = value;
            try
            {
                this.title.text = value;
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }return value;
        }

        override public function  set_color(k:UInt):UInt        {
            var _local_3:IWindow = null;
            super.color = k;
            var _local_2= new Array<ASAny>();
            groupChildrenWithTag(com.sulake.core.window.WindowController._COLORIZE, _local_2, -1);
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                _local_3.color = k;
            }
return k;
        }
    }

