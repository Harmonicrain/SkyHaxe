package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.iterators.ContainerIterator;
    import com.sulake.core.window.utils.IIterator;

     class BackgroundController extends WindowController implements IBackgroundWindow 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            background = true;
            color = 0xFFFFFFFF;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return new ContainerIterator(this);
        }
    }

