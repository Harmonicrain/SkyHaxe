package com.sulake.habbo.navigator.view.search.results
;
    import com.sulake.habbo.navigator.HabboNewNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.navigator.view.search.ViewMode;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.utils._Str_18430;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Rectangle;
    import com.sulake.habbo.communication.messages.outgoing.navigator.DeleteFavouriteRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.AddFavouriteRoomMessageComposer;
    import com.sulake.core.window.components.IRegionWindow;

     class RoomEntryElementFactory 
    {
        public static inline final _Str_17291= 3;

        var _navigator:HabboNewNavigator;
        var _rowEntryTemplate:IWindowContainer;
        var _tileEntryTemplate:IWindowContainer;
        var _tileContainerTemplate:IItemListWindow;
        var _viewMode:Int = 0;

        public function new(k:HabboNewNavigator)
        {
            this._navigator = k;
            this._viewMode = ViewMode._Str_20005(ViewMode.HOTEL_VIEW);
        }

        public var viewMode(never,set):Int;
public function  set_viewMode(k:Int):Int        {
            return this._viewMode = k;
        }

        public var _Str_23915(never,set):IWindowContainer;
public function  set__Str_23915(k:IWindowContainer):IWindowContainer        {
            return this._rowEntryTemplate = k;
        }

        public var _Str_24632(never,set):IWindowContainer;
public function  set__Str_24632(k:IWindowContainer):IWindowContainer        {
            return this._tileEntryTemplate = k;
        }

        public var _Str_25029(never,set):IItemListWindow;
public function  set__Str_25029(k:IItemListWindow):IItemListWindow        {
            return this._tileContainerTemplate = k;
        }

        public var _Str_19124(get,never):Int;
public function  get__Str_19124():Int
        {
            return this._rowEntryTemplate.height;
        }

        public function _Str_24858(k:GuestRoomData, _arg_2:Int, _arg_3:Int=-1):IWindowContainer
        {
            var _local_4= cast(this._rowEntryTemplate.clone(), IWindowContainer);
            if (_arg_3 != -1)
            {
                _local_4.width = _arg_3;
            }
            cast(_local_4, IBorderWindow).color = RoomEntryUtils._Str_24293(_arg_2, cast(_local_4, IBorderWindow).color);
            this._Str_20769(_local_4, k, false);
            _local_4.findChildByName("grouphome_icon").visible = (!(k.groupBadgeCode == ""));
            return _local_4;
        }

        public function _Str_22789(k:GuestRoomData, _arg_2:Int):IWindowContainer
        {
            var _local_3= cast(this._tileEntryTemplate.clone(), IWindowContainer);
            var _local_4= cast(_local_3.findChildByName("room_pic_placeholder"), IStaticBitmapWrapperWindow);
            var _local_5:String = null;
            var _local_6:String = null;
            this._Str_20769(_local_3, k, true);
            if (k.groupBadgeCode != "")
            {
                _local_3.findChildByName("room_group_badge").visible = true;
                cast(cast(_local_3.findChildByName("room_group_badge"), IWidgetWindow).widget, IBadgeImageWidget).badgeId = k.groupBadgeCode;
            }
            if (k.officialRoomPicRef != null)
            {
                if (this._navigator.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))
                {
                    _local_5 = (this._navigator.getProperty("navigator.thumbnail.url_base") + k.officialRoomPicRef);
                }
                else
                {
                    _local_5 = (this._navigator.getProperty("image.library.url") + k.officialRoomPicRef);
                }
            }
            else
            {
                _local_5 = ((this._navigator.getProperty("navigator.thumbnail.url_base") + Std.string(k.flatId)) + ".png");
            }
            _local_6 = this._navigator.data.getRoomThumbnailRefreshKey(k.flatId);
            if (((!(_local_6 == null)) && (!(_local_6 == ""))))
            {
                _local_5 = (_local_5 + ("?v=" + _local_6));
            }
            if (_local_4.assetUri == _local_5)
            {
                _local_4.assetUri = null;
            }
            _local_4.assetUri = _local_5;
            return _local_3;
        }

        function _Str_20769(k:IWindowContainer, _arg_2:GuestRoomData, _arg_3:Bool)
        {
            k.findChildByName("room_usercount").caption = Std.string(_arg_2.userCount);
            k.findChildByName("room_name").caption = (ViewMode._Str_25096(this._viewMode) ? _arg_2.roomAdName : _arg_2.roomName);
            k.findChildByName("go_to_room_region").id = _arg_2.flatId;
            k.findChildByName("go_to_room_region").addEventListener(WindowMouseEvent.CLICK, this._Str_23456);
            k.findChildByName("go_to_room_region").addEventListener(WindowMouseEvent.OVER, (_arg_3 ? this._Str_25608 : this._Str_24397));
            k.findChildByName("info_popup_click_region").id = _arg_2.flatId;
            k.findChildByName("info_popup_click_region").addEventListener(WindowMouseEvent.CLICK, this._Str_24506);
            k.findChildByName("info_popup_click_region").addEventListener(WindowMouseEvent.OVER, this._Str_25237);
            cast(k.findChildByName("room_info_usercount_border"), IBorderWindow).color = _Str_18430._Str_25426(_arg_2.userCount, _arg_2.maxUserCount);
            cast(k.findChildByName("doormode_icon"), IStaticBitmapWrapperWindow).assetUri = RoomEntryUtils._Str_25339(_arg_2.doorMode);
        }

        public function _Str_25258():IItemListWindow
        {
            return Std.downcast(this._tileContainerTemplate.clone() , IItemListWindow);
        }

        function _Str_23456(k:WindowEvent)
        {
            this._navigator.goToRoom(k.window.id);
        }

        function _Str_24506(k:WindowEvent)
        {
            var _local_2= new Rectangle();
            k.window.getGlobalRectangle(_local_2);
            this._navigator.view._Str_15353(this._navigator._Str_3440.findGuestRoom(k.window.id), Std.int(_local_2.right), Std.int(((_local_2.bottom - _local_2.top) / 2) + _local_2.top));
        }

        function _Str_25237(k:WindowEvent)
        {
            var _local_2:Rectangle = null;
            if (this._navigator.view._Str_15872)
            {
                _local_2 = new Rectangle();
                k.window.getGlobalRectangle(_local_2);
                this._navigator.view._Str_15353(this._navigator._Str_3440.findGuestRoom(k.window.id), Std.int(_local_2.right), Std.int(((_local_2.bottom - _local_2.top) / 2) + _local_2.top), true);
            }
        }

        function _Str_25608(k:WindowEvent)
        {
            var _local_2:Rectangle = null;
            if (this._navigator.view._Str_15872)
            {
                _local_2 = new Rectangle();
                k.window.getGlobalRectangle(_local_2);
                this._navigator.view._Str_15353(this._navigator._Str_3440.findGuestRoom(k.window.id), Std.int(_local_2.right - 6), Std.int((((_local_2.bottom - _local_2.top) / 2) + _local_2.top) + 56), true);
            }
        }

        function _Str_24397(k:WindowEvent)
        {
            var _local_2:Rectangle = null;
            if (this._navigator.view._Str_15872)
            {
                _local_2 = new Rectangle();
                k.window.getGlobalRectangle(_local_2);
                this._navigator.view._Str_15353(this._navigator._Str_3440.findGuestRoom(k.window.id), Std.int(_local_2.right + 20), Std.int(((_local_2.bottom - _local_2.top) / 2) + _local_2.top), true);
            }
        }

        function _Str_26273(k:WindowEvent)
        {
            this._navigator._Str_12024(k.window.id);
        }

        function _Str_26401(k:WindowEvent)
        {
            this._navigator.getGuildInfo(k.window.id);
        }

        function _Str_26403(k:WindowEvent)
        {
            var _local_2= this._navigator.legacyNavigator._Str_12281(k.window.id);
            if (_local_2)
            {
                this._navigator.communication.connection.send(new DeleteFavouriteRoomMessageComposer(k.window.id));
            }
            else
            {
                this._navigator.communication.connection.send(new AddFavouriteRoomMessageComposer(k.window.id));
            }
            cast(cast(k.window, IRegionWindow).findChildByName("favourite_icon"), IStaticBitmapWrapperWindow).assetUri = RoomEntryUtils._Str_25708((!_local_2));
        }
    }




