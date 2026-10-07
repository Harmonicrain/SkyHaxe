package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.tablet.ITouchAwareWindow;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

     class DropMenuItemController extends ButtonController implements IDropListItemWindow implements  ITouchAwareWindow 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public var menu(get,never):IDropMenuWindow;
public function  get_menu():IDropMenuWindow
        {
            var k= parent;
            while (k != null)
            {
                if (Std.is(k , IDropMenuWindow))
                {
                    break;
                }
                k = k.parent;
            }
            return Std.downcast(k , IDropMenuWindow);
        }

        
        public var value(get,set):IWindow;
public function  get_value():IWindow
        {
            return this;
        }
public function  set_value(k:IWindow):IWindow        {
return k;
        }
    }

