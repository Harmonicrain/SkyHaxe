package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.graphics.GraphicContext;
    import com.sulake.core.window.graphics.IGraphicContext;
    import flash.display.DisplayObject;

     class DisplayObjectWrapperController extends WindowController implements IDisplayObjectWrapper 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )& (~ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = false;
        }

        override public function getGraphicContext(k:Bool):IGraphicContext
        {
            if ((k && (!(_graphics != null))))
            {
                _graphics = new GraphicContext((("GC {" + _name) + "}"), GraphicContext.GC_TYPE_CONTAINER, rectangle);
            }
            return _graphics;
        }

        public function getDisplayObject():DisplayObject
        {
            return this.getGraphicContext(true).getDisplayObject();
        }

        public function setDisplayObject(k:DisplayObject)
        {
            this.getGraphicContext(true).setDisplayObject(k);
        }
    }

