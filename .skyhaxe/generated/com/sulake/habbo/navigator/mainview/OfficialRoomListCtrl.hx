package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.navigator.IViewCtrl;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.OfficialRoomEntryData;
    import com.sulake.core.window.components.*;
    import com.sulake.habbo.navigator.*;

     class OfficialRoomListCtrl implements IViewCtrl 
    {
        var _navigator:HabboNavigator;
        var _content:IWindowContainer;
        var _list:IItemListWindow;
        var _promotedRoomsListCtrl:PromotedRoomsListCtrl;

        public function new(k:HabboNavigator)        {
            this._navigator = k;
            this._promotedRoomsListCtrl = new PromotedRoomsListCtrl(this._navigator);
        }

        public function dispose()
        {
            if (this._promotedRoomsListCtrl != null)
            {
                this._promotedRoomsListCtrl.dispose();
                this._promotedRoomsListCtrl = null;
            }
        }

        
        public var content(get,set):IWindowContainer;
public function  set_content(k:IWindowContainer):IWindowContainer        {
            this._content = k;
            this._list = ((this._content != null) ? cast(this._content.findChildByName("item_list_official"), IItemListWindow) : null);
return k;
        }
public function  get_content():IWindowContainer
        {
            return this._content;
        }

        public function refresh()
        {
            var _local_3 = false;
            var _local_4:IWindowContainer = null;
            var _local_5 = false;
            var k= this._Str_24906();
            this._list.autoArrangeItems = false;
            this._Str_25113();
            var _local_2 = 0;
            while (true)
            {
                _local_3 = (!((_local_2 % 2) == 0));
                _local_4 = cast(this._list.getListItemAt((_local_2 + 1)), IWindowContainer);
                if (_local_2 < k.length)
                {
                    this.refreshEntry(true, _local_3, _local_4, k[_local_2]);
                }
                else
                {
                    _local_5 = this.refreshEntry(false, _local_3, _local_4, null);
                    if (_local_5)
                    {
                        break;
                    }
                }
                _local_2++;
            }
            this._list.autoArrangeItems = true;
        }

        function _Str_24906():Array<ASAny>
        {
            var _local_4:OfficialRoomEntryData = null;
            var k= this._navigator.data._Str_5645.entries;
            var _local_2= new Array<ASAny>();
            var _local_3 = 0;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                if (_local_4._Str_22186 > 0)
                {
                    if (_local_4._Str_22186 == _local_3)
                    {
                        _local_2.push(_local_4);
                    }
                }
                else
                {
                    _local_3 = (_local_4.open ? _local_4.index : 0);
                    _local_2.push(_local_4);
                }
            }
            return _local_2;
        }

        function refreshEntry(k:Bool, _arg_2:Bool, _arg_3:IWindowContainer, _arg_4:OfficialRoomEntryData):Bool
        {
            if (_arg_3 == null)
            {
                if (!k)
                {
                    return true;
                }
                _arg_3 = this._navigator.officialRoomEntryManager._Str_9034(_arg_2);
                this._list.addListItem(_arg_3);
            }
            _arg_3.width = this._list.width;
            this._navigator.officialRoomEntryManager.refreshEntry(_arg_3, k, _arg_4);
            return false;
        }

        function _Str_25113()
        {
            var k= cast(this._list.getListItemAt(0), IWindowContainer);
            this._promotedRoomsListCtrl.refresh(k, this._navigator.data.promotedRooms.entries);
        }
    }

