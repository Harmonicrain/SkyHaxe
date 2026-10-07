package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.events.WindowEvent;

     class SelectableController extends InteractiveController implements ISelectableWindow 
    {
        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public var selector(get,never):ISelectorWindow;
public function  get_selector():ISelectorWindow
        {
            var k:IWindow = null;
            if (_parent != null)
            {
                k = _parent ;
                while (k != null)
                {
                    if (Std.is(k , ISelectorWindow))
                    {
                        return Std.downcast(k , ISelectorWindow);
                    }
                    k = k.parent;
                }
            }
            return null;
        }

        
        public var Selected(get,set):Bool;
public function  get_Selected():Bool
        {
            return testStateFlag(WindowState.SELECTED);
        }
public function  set_Selected(k:Bool):Bool        {
            setStateFlag(WindowState.SELECTED, k);
return k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3:WindowController = null;
            var _local_4:WindowEvent = null;
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_ACTIVATED)
            {
                if (_parent != null)
                {
                    if (!Std.is(_parent , ISelectorWindow))
                    {
                        _local_3 = Std.downcast(_parent.parent , WindowController);
                        while (_local_3 != null)
                        {
                            if (Std.is(_local_3 , ISelectorWindow))
                            {
                                _local_4 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHILD_ACTIVATED, this, null);
                                _local_3.update(this, _local_4);
                                _local_4.recycle();
                                break;
                            }
                            _local_3 = Std.downcast(_local_3.parent , WindowController);
                        }
                    }
                }
            }
            return super.update(k, _arg_2);
        }

        public function select():Bool
        {
            if (getStateFlag(WindowState.SELECTED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SELECT, this, null, true);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            setStateFlag(WindowState.SELECTED, true);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SELECTED, this, null);
            this.update(this, k);
            k.recycle();
            activate();
            return true;
        }

        public function unselect():Bool
        {
            if (!getStateFlag(WindowState.SELECTED))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNSELECT, this, null, true);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            setStateFlag(WindowState.SELECTED, false);
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_UNSELECTED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }
    }

