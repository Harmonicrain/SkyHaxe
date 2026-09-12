package com.sulake.habbo.ui.widget.contextmenu
;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ButtonMenuView extends ContextInfoView 
    {
        static inline final ICON_MARGIN= 8;
        static inline final LINK_COLOR_MODERATE_DEFAULT:UInt = 16744755;
        static inline final LINK_COLOR_MODERATE_HOVER:UInt = 16756591;
        static inline final ICON_VIP= "icon_vip";
        static inline final ARROW_LEFT= "arrow_left";
        static inline final ARROW_RIGHT= "arrow_right";

        var _buttons:IItemListWindow;

        public function new(k:IContextMenuParentWidget)
        {
            super(k);
        }

        function ensureTextButton(name:String,
                                            caption:String)
        {
var             i = 0;            if (this._buttons == null ||
                this._buttons.getListItemByName(name) != null ||
                this._buttons.numListItems == 0)
            {
                return;
            }
            var source:IWindowContainer = null;
            i= 0;while (i < this._buttons.numListItems)
            {
                source = Std.downcast(this._buttons.getListItemAt(i) , IWindowContainer);
                if (source != null &&
                    source.getChildByName("button") != null)
                {
                    break;
                }
                source = null;
i++;
            }
            if (source == null) { return; }
            var item= Std.downcast(source.clone() , IWindowContainer);
            item.name = name;
            item.visible = false;
            var label=
                Std.downcast(item.findChildByName("label") , ITextWindow);
            if (label != null) { label.caption = caption; }
            this._buttons.addListItem(item);
        }

        override public function dispose()
        {
            this._buttons = null;
            super.dispose();
        }

        function showButtonGrid(k:String, _arg_2:Bool=true)
        {
            var _local_6 = 0;
            var _local_7:IWindowContainer = null;
            var _local_8:IBitmapWrapperWindow = null;
            if (this._buttons == null)
            {
                return;
            }
            var _local_3= Std.downcast(this._buttons.getListItemByName(k) , IItemGridWindow);
            if (_local_3 == null)
            {
                return;
            }
            _local_3.visible = _arg_2;
            var _local_4= _local_3.iterator;
            var _local_5= ASCompat.toInt(_local_4.length);
            if (_local_5 > 0)
            {
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_7 = ASCompat.dynamicAs(com.sulake.core.utils.ASProxy.get(_local_4, _local_6), IWindowContainer);
                    _local_8 = Std.downcast(_local_7.findChildByTag("icon") , IBitmapWrapperWindow);
                    if (_local_8 != null)
                    {
                        _Str_16818(_local_8, _local_8.name, true);
                    }
                    _local_6++;
                }
            }
        }

        function showButton(k:String, _arg_2:Bool=true, _arg_3:Bool=true, _arg_4:Bool=false)
        {
            if (this._buttons == null)
            {
                return;
            }
            var _local_5= Std.downcast(this._buttons.getListItemByName(k) , IWindowContainer);
            if (_local_5 == null)
            {
                return;
            }
            _local_5.visible = _arg_2;
            var _local_6= Std.downcast(_local_5.getChildByName("button") , IWindowContainer);
            _arg_3 = (_arg_3 || _arg_4);
            if (_arg_3)
            {
                _local_6.enable();
            }
            else
            {
                _local_6.disable();
            }
            var _local_7= Std.downcast(_local_6.getChildByName("label") , ITextWindow);
            _local_7.textColor = ((_arg_3 && (!_arg_4)) ? ContextInfoView._Str_17354 : ContextInfoView._Str_17165);
            var _local_8= Std.downcast(_local_6.getChildByName("icon") , IIconWindow);
            if (_local_8 != null)
            {
                _local_8.color = (_arg_3 ? ContextInfoView._Str_16357 : ContextInfoView._Str_17248);
                if (_local_8.tags.indexOf(ARROW_LEFT) != -1)
                {
                    _local_8.x = Std.int(((_local_7.x + ((_local_7.width - _local_7.textWidth) / 2)) - _local_8.width) - ICON_MARGIN);
                }
                if (_local_8.tags.indexOf(ARROW_RIGHT) != -1)
                {
                    _local_8.x = Std.int((_local_7.x + ((_local_7.width + _local_7.textWidth) / 2)) + ICON_MARGIN);
                }
                _local_8.visible = (_local_8.visible && (!_arg_4));
            }
            var _local_9= Std.downcast(_local_6.getChildByName(ICON_VIP) , IIconWindow);
            if (_local_9 != null)
            {
                _local_9.visible = _arg_4;
            }
        }

        function buttonEventProc(k:WindowEvent, _arg_2:IWindow)
        {
            if (disposed)
            {
                return;
            }
            if (((!(window != null)) || window.disposed))
            {
                return;
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                if (_arg_2.name == "button")
                {
                    _arg_2.color = ((_arg_2.tags.indexOf("moderate") > -1) ? ContextInfoView._Str_18586 : ContextInfoView._Str_13825);
                }
                else
                {
                    if (_arg_2.tags.indexOf("link") > -1)
                    {
                        if (_arg_2.tags.indexOf("actions") > -1)
                        {
                            cast(cast(_arg_2, IWindowContainer).getChildAt(0), ITextWindow).textColor = ContextInfoView._Str_6801;
                        }
                        else
                        {
                            if (_arg_2.tags.indexOf("moderate") > -1)
                            {
                                cast(cast(_arg_2, IWindowContainer).getChildAt(0), ITextWindow).textColor = LINK_COLOR_MODERATE_HOVER;
                            }
                        }
                    }
                }
                if (_arg_2.name == "profile_link")
                {
                    cast(cast(_arg_2, IWindowContainer).findChildByName("name"), ITextWindow).textColor = ContextInfoView._Str_6801;
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    if (_arg_2.name == "button")
                    {
                        _arg_2.color = ContextInfoView._Str_16565;
                    }
                    else
                    {
                        if (_arg_2.tags.indexOf("link") > -1)
                        {
                            if (_arg_2.tags.indexOf("actions") > -1)
                            {
                                cast(cast(_arg_2, IWindowContainer).getChildAt(0), ITextWindow).textColor = ContextInfoView._Str_6292;
                            }
                            else
                            {
                                if (_arg_2.tags.indexOf("moderate") > -1)
                                {
                                    cast(cast(_arg_2, IWindowContainer).getChildAt(0), ITextWindow).textColor = LINK_COLOR_MODERATE_DEFAULT;
                                }
                            }
                        }
                    }
                    if (_arg_2.name == "profile_link")
                    {
                        cast(cast(_arg_2, IWindowContainer).findChildByName("name"), ITextWindow).textColor = ContextInfoView._Str_6292;
                    }
                }
            }
        }
    }



