package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.iterators.ContainerIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.graphics.GraphicContext;
    import com.sulake.core.window.graphics.IGraphicContext;

     class ContainerController extends WindowController implements IWindowContainer 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = ((_background || testParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)) || (!testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return new ContainerIterator(this);
        }

        override public function getGraphicContext(k:Bool):IGraphicContext
        {
            if ((k && (!(_graphics != null))))
            {
                _graphics = new GraphicContext((("GC {" + _name) + "}"), (testParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT) ? GraphicContext.GC_TYPE_CONTAINER : GraphicContext.GC_TYPE_BITMAP), rectangle);
                _graphics.visible = _visible;
            }
            return _graphics;
        }
    }

