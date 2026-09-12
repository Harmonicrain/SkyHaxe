package com.sulake.habbo.navigator.view
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.navigator.context.SearchContext;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SavedSearch;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class QuickLinksView 
    {
        var _navigator:HabboNewNavigator;
        var _template:IRegionWindow;
        var _itemList:IItemListWindow;
        var _linkSearches:Array<ASAny>;
        var _searchIds:Array<ASAny>;

        public function new(k:HabboNewNavigator)
        {
            this._linkSearches = [];
            this._searchIds = [];
            this._navigator = k;
        }

        public var itemList(never,set):IItemListWindow;
public function  set_itemList(k:IItemListWindow):IItemListWindow        {
            return this._itemList = k;
        }

        public var template(never,set):IRegionWindow;
public function  set_template(k:IRegionWindow):IRegionWindow        {
            return this._template = k;
        }

        public function _Str_22170(k:Vector<SavedSearch>)
        {
            var _local_3:IRegionWindow = null;
            var _local_4:ITextWindow = null;
            this._itemList.removeListItems();
            this._linkSearches = [];
            this._searchIds = [];
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                _local_3 = cast(this._template.clone(), IRegionWindow);
                _local_3.id = _local_2;
                _local_4 = cast(_local_3.findChildByName("quick_link_text"), ITextWindow);
                _local_4.caption = (this._navigator.localization.getLocalization(("navigator.searchcode.title." + k[_local_2].searchCode), k[_local_2].searchCode) + ((k[_local_2].filter != "") ? (" - " + k[_local_2].filter) : ""));
                if (k[_local_2].searchCode.indexOf("category__") == 0)
                {
                    _local_4.caption = (k[_local_2].searchCode.substr("category__".length) + ((k[_local_2].filter != "") ? (" - " + k[_local_2].filter) : ""));
                }
                _local_3.procedure = this._Str_25005;
                this._linkSearches.push(new SearchContext(k[_local_2].searchCode, k[_local_2].filter));
                this._searchIds.push(k[_local_2].id);
                this._itemList.addListItem(_local_3);
                _local_2++;
            }
        }

        function _Str_25005(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (Std.is(_arg_2 , IRegionWindow))
                {
                    if (this._linkSearches.length > _arg_2.id)
                    {
                        this._navigator._Str_21272(this._linkSearches[_arg_2.id]);
                        this._navigator.trackEventLog("savedsearch.execute", "SavedSearch", HabboNewNavigator._Str_6560(this._linkSearches[_arg_2.id].searchCode, this._linkSearches[_arg_2.id].filtering));
                    }
                }
                else
                {
                    if (Std.is(_arg_2 , IContainerButtonWindow))
                    {
                        this._navigator._Str_25285(ASCompat.toInt(this._searchIds[_arg_2.parent.id]));
                    }
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    if (Std.is(_arg_2 , IRegionWindow))
                    {
                        cast(cast(_arg_2, IRegionWindow).getChildAt(1), IContainerButtonWindow).visible = true;
                    }
                    else
                    {
                        if (Std.is(_arg_2 , IContainerButtonWindow))
                        {
                            _arg_2.visible = true;
                        }
                    }
                }
                else
                {
                    if (((k.type == WindowMouseEvent.OUT) && Std.is(_arg_2 , IRegionWindow)))
                    {
                        cast(cast(_arg_2, IRegionWindow).getChildAt(1), IContainerButtonWindow).visible = false;
                    }
                }
            }
        }
    }


