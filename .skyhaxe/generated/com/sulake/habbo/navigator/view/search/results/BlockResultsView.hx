package com.sulake.habbo.navigator.view.search.results
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultSet;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultList;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.navigator.view.search.ViewMode;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;

     class BlockResultsView 
    {
        var _navigator:HabboNewNavigator;
        var _itemList:IItemListWindow;
        var _categoryElementFactory:CategoryElementFactory;
        var _searchCodeShowMore:ASDictionary<ASAny,ASAny>;
        var _currentWindowsInItemList:ASDictionary<ASAny,ASAny>;
        var _searchCodeViewMode:ASDictionary<ASAny,ASAny>;

        public function new(k:HabboNewNavigator)
        {
            this._searchCodeShowMore = new ASDictionary<ASAny,ASAny>();
            this._currentWindowsInItemList = new ASDictionary<ASAny,ASAny>();
            this._searchCodeViewMode = new ASDictionary<ASAny,ASAny>();
            this._navigator = k;
        }

        
        public var itemList(get,set):IItemListWindow;
public function  get_itemList():IItemListWindow
        {
            return this._itemList;
        }
public function  set_itemList(k:IItemListWindow):IItemListWindow        {
            this._itemList = k;
            this._itemList.disableAutodrag = true;
return k;
        }

        public var _Str_24528(never,set):CategoryElementFactory;
public function  set__Str_24528(k:CategoryElementFactory):CategoryElementFactory        {
            return this._categoryElementFactory = k;
        }

        public function _Str_22947()
        {
            var k:IWindow = null;
            var _local_2:SearchResultSet = null;
            var _local_3 = 0;
            var _local_4:SearchResultList = null;
            if (this._navigator._Str_3440 == null)
            {
                return;
            }
            this._currentWindowsInItemList = new ASDictionary<ASAny,ASAny>();
            this._searchCodeShowMore = new ASDictionary<ASAny,ASAny>();
            this._searchCodeViewMode = new ASDictionary<ASAny,ASAny>();
            this._itemList.destroyListItems();
            if (this._navigator._Str_3440.resultSet.blocks.length == 0)
            {
                this._itemList.addListItem(this._categoryElementFactory._Str_24646());
            }
            else
            {
                _local_2 = this._navigator._Str_3440.resultSet;
                _local_3 = 0;
                while (_local_3 < _local_2.blocks.length)
                {
                    _local_4 = _local_2.blocks[_local_3];
                    k = this._Str_20272(_local_3, (((!this._Str_23804(_local_4.searchCode)) || this._Str_25088(_local_2)) && (!_local_4._Str_25561)));
                    k.id = _local_3;
                    this._itemList.addListItem(k);
                    this._currentWindowsInItemList[_local_3] = k;
                    this._searchCodeShowMore[_local_3] = _local_4.searchCode;
                    this._searchCodeViewMode[_local_3] = _local_4.viewMode;
                    _local_3++;
                }
            }
            this._itemList.arrangeListItems();
        }

        public function _Str_19195(k:WindowEvent)
        {
            this._navigator.performSearch(this._searchCodeShowMore[k.window.id], this._navigator._Str_3440.filteringData);
            this._navigator.trackEventLog("browse.expandsearch", "Results", HabboNewNavigator._Str_6560(this._searchCodeShowMore[k.window.id], this._navigator._Str_3440.filteringData));
        }

        public function _Str_23002(k:WindowEvent)
        {
            this._navigator._Str_25434();
        }

        public function _Str_19418(k:WindowEvent)
        {
            this._navigator.sendAddCollapsedCategory(this._searchCodeShowMore[k.window.id]);
            this._navigator._Str_8273.push(this._searchCodeShowMore[k.window.id]);
            this._Str_18512(k.window.id, false);
            this._navigator.trackEventLog("browse.collapsecategory", "Results", HabboNewNavigator._Str_6560(this._searchCodeShowMore[k.window.id], this._navigator._Str_3440.filteringData));
        }

        public function _Str_21896(k:WindowEvent)
        {
            this._navigator.sendRemoveCollapsedCategory(this._searchCodeShowMore[k.window.id]);
            this._navigator._Str_8273.splice(this._navigator._Str_8273.indexOf(this._searchCodeShowMore[k.window.id]), 1);
            this._Str_18512(k.window.id, true);
            this._navigator.trackEventLog("browse.uncollapsecategory", "Results", HabboNewNavigator._Str_6560(this._searchCodeShowMore[k.window.id], this._navigator._Str_3440.filteringData));
        }

        public function _Str_21650(k:WindowEvent)
        {
            this._navigator._Str_25074(this._searchCodeShowMore[k.window.id], this._navigator._Str_3440.filteringData);
        }

        public function _Str_20474(k:WindowEvent)
        {
            var _local_2= this._Str_25538(ASCompat.toInt(this._searchCodeViewMode[k.window.id]));
            this._navigator._Str_25231(this._searchCodeShowMore[k.window.id], _local_2);
            this._navigator._Str_3440.resultSet.blocks[k.window.id].viewMode = _local_2;
            this._Str_18512(k.window.id, true);
            this._searchCodeViewMode[k.window.id] = _local_2;
        }

        function _Str_25538(k:Int):Int
        {
            if (k == ResultsModeEnum._Str_6023)
            {
                return ResultsModeEnum._Str_13822;
            }
            return ResultsModeEnum._Str_6023;
        }

        public var _Str_20093(get,never):Int;
public function  get__Str_20093():Int
        {
            return this._itemList.width;
        }

        function _Str_23804(k:String):Bool
        {
            return !(this._navigator._Str_8273.indexOf(k) == -1);
        }

        function _Str_25088(k:SearchResultSet):Bool
        {
            return k.blocks.length == 1;
        }

        function _Str_20272(k:Int, _arg_2:Bool):IWindow
        {
            var _local_5 = 0;
            var _local_3= this._navigator._Str_3440.resultSet.blocks[k];
            var _local_4= ((_local_3.text == "") ? (("${navigator.searchcode.title." + _local_3.searchCode) + "}") : _local_3.text);
            if (_arg_2)
            {
                _local_5 = (((!this._navigator.sessionData.isPerkAllowed(PerkEnum.NAVIGATOR_ROOM_THUMBNAIL_CAMERA)) && (!(this._navigator._Str_3440.searchCodeOriginal == ViewMode.OFFICIAL_VIEW))) ? ResultsModeEnum._Str_6023 : _local_3.viewMode);
                return this._categoryElementFactory._Str_22713(_local_3.guestRooms, _local_4, k, _local_3.actionAllowed, _local_5);
            }
            return this._categoryElementFactory._Str_24067(_local_4, k, _local_3.actionAllowed);
        }

        function _Str_18512(k:Int, _arg_2:Bool)
        {
            var _local_3= this._itemList.getListItemIndex(this._currentWindowsInItemList[k]);
            this._itemList.removeListItemAt(_local_3);
            var _local_4= this._Str_20272(k, _arg_2);
            _local_4.id = k;
            this._itemList.addListItemAt(_local_4, _local_3);
            this._currentWindowsInItemList[k] = _local_4;
        }
    }

