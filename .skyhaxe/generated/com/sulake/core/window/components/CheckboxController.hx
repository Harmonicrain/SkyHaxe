package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.events.WindowEvent;

     class CheckboxController extends SelectableController implements ICheckBoxWindow 
    {
        static inline final _CAPTION_TEXT= "_CAPTION_TEXT";

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
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

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if ((k : ASAny) == (this : ASAny))
            {
                switch (_arg_2.type)
                {
                    case WindowMouseEvent.UP:
                        if (Selected)
                        {
                            unselect();
                        }
                        else
                        {
                            select();
                        }
                        
                }
            }
            return super.update(k, _arg_2);
        }
    }

