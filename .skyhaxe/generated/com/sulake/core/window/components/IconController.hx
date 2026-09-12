package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window.graphics.renderer.BitmapSkinRenderer;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class IconController extends WindowController implements IIconWindow
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public function fitToSize()
        {
            if (_context == null)
            {
                return;
            }
            var renderer= _context.getWindowFactory().getRendererByTypeAndStyle(WindowType.WINDOW_TYPE_ICON, style);
            var bitmapRenderer= Std.downcast(renderer , BitmapSkinRenderer);
            if (bitmapRenderer == null)
            {
                return;
            }
            var layout= bitmapRenderer._Str_22661(state);
            if (layout == null)
            {
                layout = bitmapRenderer._Str_22661(WindowState.DEFAULT);
            }
            if (layout == null)
            {
                return;
            }
            var layoutWidth:Int = layout.width;
            var layoutHeight:Int = layout.height;
            if (((!(layoutWidth == _w)) || (!(layoutHeight == _h))))
            {
                this.setRectangle(_x, _y, layoutWidth, layoutHeight);
            }
        }
    }

