package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.IIterable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowEvent;

     class TabContextController extends WindowController implements ITabContextWindow implements  IIterable 
    {
        static inline final _SELECTOR= "_SELECTOR";
        static inline final _CONTENT= "_CONTENT";

        var _Str_9660:ISelectorListWindow;
        var _Str_17833:IWindowContainer;
        var _repositioning:Bool = false;
        var _initialized:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            var _local_13:IWindow = null;
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            var _local_12= new Array<ASAny>();
            groupChildrenWithTag(WindowController.TAG_INTERNAL, _local_12, -1);
            if (checkNullIteratee(_local_12)) for (_tmp_ in _local_12)
            {
_local_13  = _tmp_;
                _local_13.style = _style;
                _local_13.procedure = this._Str_20308;
            }
            this._initialized = true;
        }

        public var selector(get,never):ISelectorListWindow;
public function  get_selector():ISelectorListWindow
        {
            if (this._Str_9660 == null)
            {
                this._Str_9660 = Std.downcast(findChildByTag(_SELECTOR) , ISelectorListWindow);
                if (this._Str_9660 != null)
                {
                    this._Str_9660.procedure = this._Str_20308;
                }
            }
            return this._Str_9660;
        }

        public var container(get,never):IWindowContainer;
public function  get_container():IWindowContainer
        {
            if (this._Str_17833 == null)
            {
                this._Str_17833 = Std.downcast(findChildByTag(_CONTENT) , IWindowContainer);
            }
            return this._Str_17833;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return this._initialized ? this.selector.iterator : null;
        }

        public var numTabs(get,never):UInt;
public function  get_numTabs():UInt
        {
            return this._Str_9660.numSelectables;
        }

        public function _Str_5377(k:ITabButtonWindow):ITabButtonWindow
        {
            return Std.downcast(this.selector.addSelectable(k) , ITabButtonWindow);
        }

        public function _Str_25454(k:ITabButtonWindow, _arg_2:UInt):ITabButtonWindow
        {
            return Std.downcast(this.selector.addSelectableAt(k, ASCompat.toInt(_arg_2)) , ITabButtonWindow);
        }

        public function _Str_5897(k:ITabButtonWindow)
        {
            this.selector.removeSelectable(k);
        }

        public function getTabButtonAt(k:UInt):ITabButtonWindow
        {
            return Std.downcast(this.selector.getSelectableAt(ASCompat.toInt(k)) , ITabButtonWindow);
        }

        public function _Str_19493(k:String):ITabButtonWindow
        {
            return Std.downcast(this.selector.getSelectableByName(k) , ITabButtonWindow);
        }

        public function _Str_20824(k:UInt):ITabButtonWindow
        {
            return Std.downcast(this.selector.getSelectableByID(k) , ITabButtonWindow);
        }

        public function _Str_23344(k:ITabButtonWindow):UInt
        {
            return this.selector.getSelectableIndex(k);
        }

        function _Str_20308(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowEvent.WINDOW_EVENT_SELECTED)
            {
                notifyEventListeners(k);
            }
        }
    }

