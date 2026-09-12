package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.tablet.ITouchAwareWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.events.WindowTouchEvent;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class DropBaseController extends InteractiveController implements ITouchAwareWindow 
    {
        static inline final _Str_5734= 0.5;
        static inline final _DROPLIST_TITLETEXT= "_DROPLIST_TITLETEXT";
        static inline final _DROPLIST_ITEMLIST= "_DROPLIST_ITEMLIST";
        static inline final _DROPLIST_REGION= "_DROPLIST_REGION";
        static inline final _Str_9883= 30;

        var _Str_16910:Bool = false;
        var _Str_14725:Bool = false;
        var _Str_3139:Vector<IWindow>;
        var _Str_3371:Int = -1;
        var _Str_3943:Bool = false;
        var _Str_3565:DropBaseController;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._Str_3139 = new Vector<IWindow>();
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            this._Str_3679().addEventListener(WindowMouseEvent.DOWN, this._Str_22124);
        }

        
        public var selection(get,set):Int;
public function  get_selection():Int
        {
            return this._Str_3371;
        }
public function  set_selection(k:Int):Int        {
            if (k > (this.numMenuItems - 1))
            {
                throw new ASError("Menu selection index out of range!");
            }
            var _local_2= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SELECT, this, null, true);
            this.update(this, _local_2);
            if (!_local_2.isWindowOperationPrevented())
            {
                _local_2.recycle();
                this._Str_3371 = k;
                this.closeExpandedMenuView();
                _local_2 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_SELECTED, this, null);
                this.update(this, _local_2);
            }
            _local_2.recycle();
return k;
        }

        override public function  set_caption(k:String):String        {
            super.caption = k;
            var _local_2= this._Str_9315();
            if (_local_2 != null)
            {
                _local_2.text = k;
            }
return k;
        }

        override public function dispose()
        {
            var k:IWindow = null;
            this._Str_3679().removeEventListener(WindowMouseEvent.DOWN, this._Str_22124);
            if (((!(this._Str_3565 == null)) && (!this._Str_3565.disposed)))
            {
                this._Str_3565.destroy();
                this._Str_3565 = null;
            }
            final _iter_ = this._Str_3139; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                k.dispose();
            }
            this._Str_3139 = null;
            super.dispose();
        }

        override public function activate():Bool
        {
            if (this._Str_3943)
            {
                return true;
            }
            return super.activate();
        }

        public function _Str_9315():ILabelWindow
        {
            return Std.downcast(getChildByName(_DROPLIST_TITLETEXT) , ILabelWindow);
        }

        public function _Str_8828():IItemListWindow
        {
            return Std.downcast(getChildByName(_DROPLIST_ITEMLIST) , IItemListWindow);
        }

        public function _Str_3679():IRegionWindow
        {
            return Std.downcast(getChildByName(_DROPLIST_REGION) , IRegionWindow);
        }

        override public function populate(k:Array<ASAny>)
        {
            var _local_2:IWindow = null;
            this._Str_3943 = true;
            this.closeExpandedMenuView();
            this._Str_3371 = -1;
            while (this._Str_3139.length > 0)
            {
                _local_2 = this._Str_3139.pop();
                if (k.indexOf(_local_2) == -1)
                {
                    _local_2.dispose();
                }
            }
            var _local_3:UInt = 0;
            while (_local_3 < (k.length : UInt))
            {
                this._Str_3139.push(k[ASCompat.toInt(_local_3)]);
                _local_3++;
            }
        }

        function _Str_9561()
        {
            if (!this._Str_3943)
            {
                if (this.open())
                {
                    if (this.numMenuItems > 0)
                    {
                        this._Str_3943 = true;
                        this.populateExpandedMenu(this._Str_3139, this._Str_25760(), this._Str_26470);
                    }
                }
            }
        }

        function closeExpandedMenuView()
        {
            var k:IDropListItemWindow = null;
            var _local_2:IWindow = null;
            var _local_3:IItemListWindow = null;
            var _local_4 = 0;
            var _local_5:ILabelWindow = null;
            if (this.close())
            {
                if (this._Str_3565 != null)
                {
                    _local_3 = this._Str_3565._Str_8828();
                    _local_3.autoArrangeItems = false;
                    _local_4 = 0;
                    while (_local_4 < _local_3.numListItems)
                    {
                        k = Std.downcast(_local_3.getListItemAt(_local_4) , IDropListItemWindow);
                        if (k != null)
                        {
                            _local_2 = k.value;
                            if (this._Str_3139.indexOf(_local_2) > -1)
                            {
                                k.value = null;
                                _local_2.setParamFlag(WindowParam.WINDOW_PARAM_ROUTE_INPUT_EVENTS_TO_PARENT, false);
                            }
                        }
                        _local_4++;
                    }
                    this._Str_3565.destroy();
                    this._Str_3565 = null;
                }
                this._Str_3943 = false;
                if (!disposed)
                {
                    _local_5 = this._Str_9315();
                    _local_3 = this._Str_8828();
                    if (_local_3 != null)
                    {
                        while (_local_3.numListItems > 0)
                        {
                            _local_3.removeListItemAt(0);
                        }
                        if (((this._Str_3371 < this.numMenuItems) && (this._Str_3371 > -1)))
                        {
                            _local_2 = this._Str_3139[this._Str_3371];
                            _local_2.x = 0;
                            _local_2.y = 0;
                            _local_3.addListItem(_local_2);
                            _local_3.height = _local_2.height;
                            _local_5.visible = false;
                        }
                        else
                        {
                            _local_5.visible = true;
                        }
                    }
                }
            }
        }

        function _Str_25760():DropBaseController
        {
            var k= new Rectangle();
            getGlobalRectangle(k);
            if (((this._Str_3565 == null) || this._Str_3565.disposed))
            {
                this._Str_3565 = Std.downcast(context.create((name + "::subMenu"), "", type, _style, ((ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN )| ASCompat.toInt(ASCompat.toUInt((this._Str_16910 ? WindowParam.WINDOW_PARAM_ON_RESIZE_ALIGN_BOTTOM : 0)))) | ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), k, this._Str_26470, null, 0, null, "", [WindowController.TAG_EXCLUDE]) , DropBaseController);
            }
            else
            {
                this._Str_3565.setGlobalRectangle(k);
            }
            this._Str_3565.activate();
            return this._Str_3565;
        }

        function populateExpandedMenu(k:Vector<IWindow>, _arg_2:DropBaseController, _arg_3:ASFunction)
        {
            var _local_6:IDropListItemWindow = null;
            var _local_12:IWindow = null;
            var _local_4= _arg_2._Str_8828();
            _local_4.autoArrangeItems = false;
            _arg_2._Str_3679().visible = false;
            var _local_5:UInt = k.length;
            var _local_7= _local_4.width;
            var _local_8= _local_7;
            var _local_9 = 0;
            var _local_10:UInt = 0;
            while (_local_10 < _local_5)
            {
                _local_12 = k[ASCompat.toInt(_local_10)];
                _local_6 = Std.downcast(context.create((((name + "::menuItem[") + Std.string(_local_10)) + "]"), _local_12.caption, WindowType.WINDOW_TYPE_DROPLIST_ITEM, _style, ((((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_FIXED)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), null, _arg_3, null, _local_10, null, "", [WindowController.TAG_EXCLUDE]) , DropListItemController);
                _local_12.x = 0;
                _local_12.y = 0;
                _local_12.setParamFlag(WindowParam.WINDOW_PARAM_ROUTE_INPUT_EVENTS_TO_PARENT, true);
                _local_6.value = _local_12;
                _local_6.width = _local_6.value.width;
                _local_6.height = _local_6.value.height;
                _local_6.limits.minWidth = _local_7;
                _local_8 = Std.int(Math.max(_local_8, _local_6.width));
                _local_9 = (_local_9 + _local_6.height);
                _local_4.addListItem(_local_6);
                _local_10++;
            }
            if (_local_8 > _local_7)
            {
                _arg_2.width = (_arg_2.width + (_local_8 - _local_4.width));
                _local_10 = 0;
                while (_local_10 < _local_5)
                {
                    _local_4.getListItemAt(_local_10).limits.minWidth = _local_8;
                    _local_10++;
                }
            }
            var _local_11= context.create((name + "::padding"), "", WindowType.WINDOW_TYPE_CONTAINER, _style, (((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_FIXED )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_FIXED)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_NULL)), new Rectangle(0, 0, 1, 3), null, null, 0, null, "", [WindowController.TAG_EXCLUDE]);
            _local_4.addListItem(_local_11);
            _local_4.autoArrangeItems = true;
            _local_9 = (_local_9 + _local_11.height);
            _local_9 = (_local_9 + (_local_4.spacing * _local_4.numListItems));
            _arg_2.height = Std.int(Math.max(_arg_2.height, (_local_9 + 4)));
            if (((ASCompat.toInt(param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_BOUND_TO_PARENT_RECT)) != 0))
            {
                this._Str_22994(_arg_2);
            }
            else
            {
                this._Str_18287(_arg_2);
            }
            _arg_2.activate();
            _local_4.height = Std.int(Math.max(_local_4.height, (_arg_2.height - 4)));
            if (((this._Str_3371 > -1) && (_local_5 != 0)))
            {
                _local_4.getListItemAt(this._Str_3371).setStateFlag(WindowState.SELECTED, true);
            }
        }

        function _Str_22994(k:IWindow)
        {
            var _local_2= new Rectangle();
            k.getGlobalRectangle(_local_2);
            var _local_3= new Rectangle();
            parent.getGlobalRectangle(_local_3);
            if (_local_2.height > _local_3.height)
            {
                k.offset(0, (_local_3.top - _local_2.top));
                k.scale(0, (_local_3.height - _local_2.height));
                k.getGlobalRectangle(_local_2);
            }
            if (_local_2.bottom > _local_3.bottom)
            {
                k.offset(0, (_local_3.bottom - _local_2.bottom));
            }
            else
            {
                if (_local_2.top < _local_3.top)
                {
                    k.offset(0, (_local_2.top - _local_3.top));
                }
            }
            if (_local_2.left < _local_3.left)
            {
                k.offset((_local_2.left - _local_3.left), 0);
            }
            else
            {
                if (_local_2.right > _local_3.right)
                {
                    k.offset((_local_3.right - _local_2.right), 0);
                }
            }
        }

        function _Str_18287(k:IWindow)
        {
            var _local_2= new Rectangle();
            k.getGlobalRectangle(_local_2);
            if (_local_2.bottom > desktop.bottom)
            {
                k.offset(0, (desktop.bottom - _local_2.bottom));
            }
            else
            {
                if (_local_2.top < desktop.top)
                {
                    k.offset(0, (_local_2.top - desktop.top));
                }
            }
            if (_local_2.left < desktop.left)
            {
                k.offset((_local_2.left - desktop.left), 0);
            }
            else
            {
                if (_local_2.right > desktop.right)
                {
                    k.offset((desktop.right - _local_2.right), 0);
                }
            }
            if (_local_2.height > (desktop.height - _Str_9883))
            {
                k.height = (desktop.height - _Str_9883);
                k.y = _Str_9883;
            }
        }

        function _Str_22124(k:WindowEvent)
        {
            if (getStateFlag(WindowState.DISABLED))
            {
                return;
            }
            if (((k.type == WindowMouseEvent.DOWN) || (k.type == WindowTouchEvent.WTE_TAP)))
            {
                if (!this._Str_3943)
                {
                    this._Str_9561();
                }
            }
        }

        function _Str_26470(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowTouchEvent.WTE_END
                   | WindowMouseEvent.UP:
                    if (Std.is(_arg_2 , IDropListItemWindow))
                    {
                        if (_arg_2.testStateFlag(WindowState.HOVERING))
                        {
                            this.selection = this._Str_21900(_arg_2);
                        }
                    }
                    return;
                case WindowTouchEvent.WTE_BEGIN
                   | WindowMouseEvent.DOWN:
                    this.selection = this._Str_21900(_arg_2);
                    return;
                case WindowEvent.WINDOW_EVENT_DEACTIVATED:
                    if ((_arg_2 : ASAny) == (this._Str_3565 : ASAny))
                    {
                        if ((this._Str_14725 && this._Str_3943))
                        {
                            return;
                        }
                        this.closeExpandedMenuView();
                    }
                    return;
            }
        }

        function _Str_21900(k:IWindow):Int
        {
            var _local_2= this._Str_3139.indexOf(k);
            if (_local_2 == -1)
            {
                if (Std.is(k , IDropListItemWindow))
                {
                    _local_2 = this._Str_3139.indexOf(cast(k, IDropListItemWindow).value);
                }
            }
            if (_local_2 == -1)
            {
                return this._Str_3371;
            }
            return _local_2;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            switch (_arg_2.type)
            {
                case WindowTouchEvent.WTE_BEGIN
                   | WindowMouseEvent.DOWN:
                    if (this._Str_3943)
                    {
                        if (this._Str_14725)
                        {
                            this.closeExpandedMenuView();
                        }
                    }
                    else
                    {
                        this._Str_9561();
                    }
                    
                case WindowEvent.WINDOW_EVENT_ENABLED:
                    try
                    {
                        getChildByName(_DROPLIST_REGION).visible = true;
                        getChildByName(_DROPLIST_TITLETEXT).blend = (getChildByName(_DROPLIST_TITLETEXT).blend + _Str_5734);
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
                    
 }                case WindowEvent.WINDOW_EVENT_DISABLED:
                    try
                    {
                        getChildByName(_DROPLIST_REGION).visible = false;
                        getChildByName(_DROPLIST_TITLETEXT).blend = (getChildByName(_DROPLIST_TITLETEXT).blend - _Str_5734);
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
                    
 }            }
            return super.update(k, _arg_2);
        }

        public function open():Bool
        {
            if (getStateFlag(WindowState.DEFAULT))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_OPEN, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            visible = true;
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_OPENED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public function close():Bool
        {
            if (!getStateFlag(WindowState.DEFAULT))
            {
                return true;
            }
            var k= WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CLOSE, this, null);
            this.update(this, k);
            if (k.isDefaultPrevented())
            {
                k.recycle();
                return false;
            }
            k.recycle();
            visible = false;
            k = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CLOSED, this, null);
            this.update(this, k);
            k.recycle();
            return true;
        }

        public var numMenuItems(get,never):Int;
public function  get_numMenuItems():Int
        {
            return this._Str_3139.length;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            k.push(createProperty(PropertyKeys.OPEN_UPWARD, this._Str_16910));
            k.push(createProperty(PropertyKeys.KEEP_OPEN_ON_DEACTIVATE, this._Str_14725));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.OPEN_UPWARD:
                        this._Str_16910 = ASCompat.toBool(_local_2.value);
                        
                    case PropertyKeys.KEEP_OPEN_ON_DEACTIVATE:
                        this._Str_14725 = ASCompat.toBool(_local_2.value);
                        
                }
            }
            return super.properties = k;
        }
    }

