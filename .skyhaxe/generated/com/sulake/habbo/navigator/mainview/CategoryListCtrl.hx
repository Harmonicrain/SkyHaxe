package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.navigator.IViewCtrl;
    import com.sulake.habbo.navigator.UserCountRenderer;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatCategory;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.domain.Tabs;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class CategoryListCtrl implements IViewCtrl 
    {
        static inline final _Str_7717= 5;

        var _userCountRenderer:UserCountRenderer;
        var _navigator:HabboNavigator;
        var _content:IWindowContainer;
        var _list:IItemListWindow;
        var _scrollV:IScrollbarWindow;

        public function new(k:HabboNavigator)
        {
            this._navigator = k;
            this._userCountRenderer = new UserCountRenderer(this._navigator);
        }

        public function dispose()
        {
            if (this._userCountRenderer != null)
            {
                this._userCountRenderer.dispose();
                this._userCountRenderer = null;
            }
        }

        public function refresh()
        {
            var _local_7:FlatCategory = null;
            var _local_8:IWindowContainer = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var k = 0;
            var _local_2= this._navigator.data.allCategories;
            var _local_3= this._navigator.data._Str_7267.categoryToCurrentUserCountMap;
            var _local_4= this._navigator.data._Str_7267.categoryToMaxUserCountMap;
            var _local_5= cast(this._list.getListItemAt(0), IWindowContainer);
            var _local_6 = 0;
            while (_local_6 < _local_2.length)
            {
                _local_7 = _local_2[_local_6];
                if (_local_7.visible)
                {
                    _local_8 = this.getCategoryContainer(_local_5, _local_6);
                    if (_local_8 == null)
                    {
                        _local_8 = this._Str_9034(_local_6);
                        _local_8.id = _local_6;
                        _local_5.addChild(_local_8);
                    }
                    _local_9 = ASCompat.toInt(_local_3.getValue(_local_7.nodeId));
                    _local_10 = ASCompat.toInt(_local_4.getValue(_local_7.nodeId));
                    this.refreshEntry(_local_8, _local_7, _local_9, _local_10);
                    _local_8.y = k;
                    k = (k + (_local_8.height + _Str_7717));
                    _local_8.visible = true;
                    _local_5.height = ((Util.getLowestPoint(_local_5) > 0) ? (Util.getLowestPoint(_local_5) + 5) : 0);
                }
                _local_6++;
            }
            if (this._scrollV != null)
            {
                this._scrollV.scrollV = 0;
                this._scrollV.visible = true;
            }
        }

        public function refreshEntry(k:IWindowContainer, _arg_2:FlatCategory, _arg_3:Int, _arg_4:Int)
        {
            k.findChildByName("category_name_txt").caption = _arg_2._Str_14718;
            k.findChildByName("arrow_right_icon").visible = true;
            this._userCountRenderer.refreshUserCount(_arg_4, cast(k.findChildByName("enter_category_button"), IWindowContainer), _arg_3, "${navigator.usercounttooltip.users}", 297, 35);
        }

        public function _Str_9034(k:Int):IWindowContainer
        {
            var _local_2= cast(this._navigator.getXmlWindow("grs_category_selector"), IWindowContainer);
            this._Str_11971(_local_2, k, "enter_category_button", this._Str_16433);
            this._navigator.refreshButton(_local_2, "navi_room_icon", true, null, 0);
            return _local_2;
        }

        function _Str_16433(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:FlatCategory = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._navigator.data.allCategories[_arg_2.id];
                this._navigator.mainViewCtrl.startSearch(Tabs.TAB_ROOMS, Tabs.SEARCHTYPE_POPULAR_ROOMS, ("" + Std.string(_local_3.nodeId)));
            }
        }

        function getCategoryContainer(k:IWindowContainer, _arg_2:Int):IWindowContainer
        {
            return cast(k.getChildByID(_arg_2), IWindowContainer);
        }

        function _Str_11971(k:IWindowContainer, _arg_2:Int, _arg_3:String, _arg_4:ASFunction)
        {
            k.findChildByName(_arg_3).procedure = _arg_4;
            k.findChildByName(_arg_3).id = _arg_2;
        }

        
        public var content(get,set):IWindowContainer;
public function  set_content(k:IWindowContainer):IWindowContainer        {
            this._content = k;
            this._list = ((this._content != null) ? cast(this._content.findChildByName("item_list_category"), IItemListWindow) : null);
            this._scrollV = ((this._content != null) ? cast(this._content.findChildByName("scroller"), IScrollbarWindow) : null);
return k;
        }
public function  get_content():IWindowContainer
        {
            return this._content;
        }
    }

