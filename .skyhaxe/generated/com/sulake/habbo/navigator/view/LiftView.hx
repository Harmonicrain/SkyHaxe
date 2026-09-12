package com.sulake.habbo.navigator.view
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class LiftView implements IUpdateReceiver 
    {
        static inline final _Str_17661:UInt = 8000;

        var _navigator:HabboNewNavigator;
        var _borderWindow:IBorderWindow;
        var _pagerItemList:IItemListWindow;
        var _pagerIconTemplate:IRegionWindow;
        var _selectedPage:Int = -1;
        var _lastCycleMs:UInt = 0;

        public function new(k:HabboNewNavigator)
        {
            this._lastCycleMs = flash.Lib.getTimer();
            this._navigator = k;
            this._navigator.registerUpdateReceiver(this, 1000);
        }

        public function dispose()
        {
            this._navigator.removeUpdateReceiver(this);
            this._navigator = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }

        public var _Str_26399(never,set):IRegionWindow;
public function  set__Str_26399(k:IRegionWindow):IRegionWindow        {
            return this._pagerIconTemplate = k;
        }

        public var _Str_25913(never,set):IBorderWindow;
public function  set__Str_25913(k:IBorderWindow):IBorderWindow        {
            this._borderWindow = k;
            this._pagerItemList = cast(this._borderWindow.findChildByName("pager_itemlist"), IItemListWindow);
            cast(this._borderWindow.findChildByName("room_image_click_region"), IRegionWindow).procedure = this._Str_24573;
return k;
        }

        public function refresh(k:Bool=true)
        {
            this._pagerItemList.destroyListItems();
            this._selectedPage = (k ? 0 : this._selectedPage);
            var _local_2 = 0;
            while (_local_2 < this._navigator._Str_7977.liftedRooms.length)
            {
                this._pagerItemList.addListItem(this._pagerIconTemplate.clone());
                _local_2++;
            }
            this._Str_21803();
            this._Str_21713();
        }

        function _Str_21803()
        {
            var _local_2:IRegionWindow = null;
            var k = 0;
            while (k < this._pagerItemList.numListItems)
            {
                _local_2 = cast(this._pagerItemList.getListItemAt(k), IRegionWindow);
                cast(_local_2.findChildByName("icon"), IStaticBitmapWrapperWindow).assetUri = ((k == this._selectedPage) ? "progress_disk_flat_on" : "progress_disk_flat_off");
                _local_2.id = k;
                _local_2.procedure = this._Str_23941;
                k++;
            }
        }

        function _Str_21713()
        {
            this._Str_21803();
            cast(this._borderWindow.findChildByName("room_image"), IStaticBitmapWrapperWindow).assetUri = this._navigator._Str_7977.getUrlForLiftImageAtIndex(this._selectedPage);
            if (this._selectedPage < this._navigator._Str_7977.liftedRooms.length)
            {
                this._borderWindow.findChildByName("caption_text").caption = this._navigator._Str_7977.liftedRooms[this._selectedPage].caption;
            }
        }

        function _Str_23757()
        {
            this._selectedPage++;
            if (this._selectedPage > (this._navigator._Str_7977.liftedRooms.length - 1))
            {
                this._selectedPage = 0;
            }
            this.refresh(false);
        }

        public function update(k:UInt)
        {
            var _local_2:UInt = flash.Lib.getTimer();
            if ((this._lastCycleMs + _Str_17661) < _local_2)
            {
                this._Str_23757();
                this._lastCycleMs = _local_2;
            }
        }

        function _Str_23941(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (_arg_2.id != this._selectedPage)
                {
                    this._selectedPage = _arg_2.id;
                    this._Str_21713();
                    this._lastCycleMs = flash.Lib.getTimer();
                    this._navigator.trackEventLog("browse.promotion", "Promotion", "", this._selectedPage);
                }
            }
        }

        function _Str_24573(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._navigator._Str_7977.liftedRooms.length > this._selectedPage)
                {
                    this._navigator.goToRoom(this._navigator._Str_7977.liftedRooms[this._selectedPage].flatId, "promotion");
                }
            }
        }
    }

