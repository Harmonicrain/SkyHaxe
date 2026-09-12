package com.sulake.habbo.navigator.mainview
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.habbo.navigator.UserCountRenderer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.navigator.PromotedRoomCategoryData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.domain.RoomSessionTags;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.navigator.*;

     class PromotedRoomsListCtrl implements IDisposable 
    {
        static inline final _Str_7717= 5;

        var _navigator:HabboNavigator;
        var _userCountRenderer:UserCountRenderer;
        var _guestRoomListCtrl:PromotedRoomsGuestRoomListCtrl;

        public function new(k:HabboNavigator)        {
            this._navigator = k;
            this._userCountRenderer = new UserCountRenderer(this._navigator);
            this._guestRoomListCtrl = new PromotedRoomsGuestRoomListCtrl(this._navigator);
        }

        public function dispose()
        {
            this._navigator = null;
            if (this._userCountRenderer != null)
            {
                this._userCountRenderer.dispose();
                this._userCountRenderer = null;
            }
            if (this._guestRoomListCtrl != null)
            {
                this._guestRoomListCtrl.dispose();
                this._guestRoomListCtrl = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._navigator == null;
        }

        function getCategoryContainer(k:IWindowContainer, _arg_2:Int):IWindowContainer
        {
            return cast(k.getChildByID(_arg_2), IWindowContainer);
        }

        public function refresh(k:IWindowContainer, _arg_2:Array<ASAny>)
        {
            var _local_5:IWindowContainer = null;
            Util.hideChildren(k);
            var _local_3 = 0;
            var _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_5 = this.getCategoryContainer(k, _local_4);
                if (_local_5 == null)
                {
                    _local_5 = this._Str_9034(_local_4);
                    _local_5.id = _local_4;
                    k.addChild(_local_5);
                }
                this.refreshEntry(_local_5, _arg_2[_local_4]);
                _local_5.y = _local_3;
                _local_3 = (_local_3 + (_local_5.height + _Str_7717));
                _local_5.visible = true;
                _local_4++;
            }
            k.height = ((Util.getLowestPoint(k) > 0) ? (Util.getLowestPoint(k) + 5) : 0);
        }

        public function _Str_9034(k:Int):IWindowContainer
        {
            var _local_2= cast(this._navigator.getXmlWindow("grs_promoted_room_category"), IWindowContainer);
            this._Str_11971(_local_2, k, "enter_room_button", this._Str_23764);
            this._Str_11971(_local_2, k, "leader_region", this._Str_23520);
            this._Str_11971(_local_2, k, "toggle_open_region", this._Str_23366);
            this._navigator.refreshButton(_local_2, "navi_room_icon", true, null, 0);
            return _local_2;
        }

        function _Str_17813(k:IWindowContainer, _arg_2:String, _arg_3:Int=3):Int
        {
            var _local_4= k.findChildByName(_arg_2);
            return (_local_4.x + _local_4.width) + _arg_3;
        }

        function _Str_11971(k:IWindowContainer, _arg_2:Int, _arg_3:String, _arg_4:ASFunction)
        {
            k.findChildByName(_arg_3).procedure = _arg_4;
            k.findChildByName(_arg_3).id = _arg_2;
        }

        public function refreshEntry(k:IWindowContainer, _arg_2:PromotedRoomCategoryData)
        {
            var _local_3= this._navigator.getText(("promotedroomcategory." + _arg_2.code));
            k.findChildByName("category_name_txt").caption = _local_3;
            k.findChildByName("category_header").width = (k.findChildByName("category_name_txt").width + 13);
            this._navigator.registerParameter("navigator.promotedrooms.hidetopten", "category", _local_3);
            this._navigator.registerParameter("navigator.promotedrooms.viewtopten", "category", _local_3);
            k.findChildByName("open_txt").caption = this._navigator.getText("navigator.promotedrooms.viewtopten");
            k.findChildByName("close_txt").caption = this._navigator.getText("navigator.promotedrooms.hidetopten");
            k.findChildByName("room_name_txt").caption = _arg_2._Str_7144.roomName;
            var _local_4= k.findChildByName("leader_name_txt");
            _local_4.caption = (_arg_2._Str_7144.showOwner ? _arg_2._Str_7144.ownerName : "");
            _local_4.x = this._Str_17813(k, "leader_name_caption_txt", 0);
            k.findChildByName("arrow_down_icon").visible = _arg_2.open;
            k.findChildByName("arrow_right_icon").visible = (!_arg_2.open);
            k.findChildByName("close_txt").visible = _arg_2.open;
            k.findChildByName("open_txt").visible = (!_arg_2.open);
            k.findChildByName("arrow_down_icon").x = this._Str_17813(k, "close_txt");
            k.findChildByName("arrow_right_icon").x = this._Str_17813(k, "open_txt");
            this._userCountRenderer.refreshUserCount(_arg_2._Str_7144.maxUserCount, cast(k.findChildByName("enter_room_button"), IWindowContainer), _arg_2._Str_7144.userCount, "${navigator.usercounttooltip.users}", 222, 35);
            this._Str_16592(k, _arg_2);
            k.findChildByName("item_list").visible = _arg_2.open;
            if (_arg_2.open)
            {
                k.findChildByName("item_list").height = (_arg_2.rooms.length * 17);
                this._guestRoomListCtrl.content = k;
                this._guestRoomListCtrl.category = _arg_2;
                this._guestRoomListCtrl.refresh();
            }
            k.height = (_arg_2.open ? (Util.getLowestPoint(k) + 3) : 90);
        }

        function _Str_23764(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:PromotedRoomCategoryData = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._Str_5067(_arg_2);
                this._navigator.data.roomSessionTags = new RoomSessionTags(_local_3.code, "1");
                this._navigator.goToPrivateRoom(_local_3._Str_7144.flatId);
                this._navigator.closeNavigator();
            }
        }

        function _Str_23520(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:PromotedRoomCategoryData = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._Str_5067(_arg_2);
                this._navigator.trackGoogle("extendedProfile", "navigator_promotedRoom");
                this._navigator.send(new GetExtendedProfileMessageComposer(_local_3._Str_7144.ownerId));
            }
        }

        function _Str_23366(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:PromotedRoomCategoryData = null;
            var _local_5:PromotedRoomCategoryData = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                while (_local_3 < this._navigator.data.promotedRooms.entries.length)
                {
                    _local_5 = this._navigator.data.promotedRooms.entries[_local_3];
                    if (_arg_2.id != _local_3)
                    {
                        _local_5.open = false;
                    }
                    _local_3++;
                }
                _local_4 = this._Str_5067(_arg_2);
                _local_4._Str_16147();
                this._navigator.mainViewCtrl.refresh();
            }
        }

        function _Str_5067(k:IWindow):PromotedRoomCategoryData
        {
            return this._navigator.data.promotedRooms.entries[k.id];
        }

        function _Str_16592(k:IWindowContainer, _arg_2:PromotedRoomCategoryData)
        {
            var _local_3= cast(k.findChildByName("avatar_image_widget"), IWidgetWindow);
            var _local_4= cast(_local_3.widget, IAvatarImageWidget);
            _local_4.figure = _arg_2._Str_23315;
        }
    }

