package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.navigator.IViewCtrl;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.navigator.RoomPopupCtrl;
    import com.sulake.core.window.components.IScrollbarWindow;
    import com.sulake.habbo.navigator.UserCountRenderer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomSettingsFlatInfo;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.geom.Point;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.outgoing.navigator.DeleteFavouriteRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.navigator.AddFavouriteRoomMessageComposer;
    import com.sulake.core.window.*;
    import com.sulake.core.window.components.*;
    import com.sulake.core.window.events.*;
    import com.sulake.habbo.navigator.*;

     class GuestRoomListCtrl implements IViewCtrl 
    {
        var _navigator:HabboNavigator;
        var _content:IWindowContainer;
        var _list:IItemListWindow;
        var _roomPopupCtrl:RoomPopupCtrl;
        var _scrollV:IScrollbarWindow;
        var _userCountRenderer:UserCountRenderer;
        var _lastHilite:IWindowContainer;
        var _lastMouseX:Int = 0;
        var _fastHorizontalMove:Bool = false;
        var _entryWidthAdjustment:Int = 0;
        var _showRoomNumbers:Bool = false;

        public function new(k:HabboNavigator, _arg_2:Int, _arg_3:Bool)        {
            this._navigator = k;
            this._entryWidthAdjustment = _arg_2;
            this._showRoomNumbers = _arg_3;
            this._roomPopupCtrl = new RoomPopupCtrl(this._navigator, 5, -5);
            this._userCountRenderer = new UserCountRenderer(this._navigator);
        }

        public function dispose()
        {
            if (this._roomPopupCtrl != null)
            {
                this._roomPopupCtrl.dispose();
                this._roomPopupCtrl = null;
            }
            if (this._userCountRenderer != null)
            {
                this._userCountRenderer.dispose();
                this._userCountRenderer = null;
            }
        }

        
        public var content(get,set):IWindowContainer;
public function  set_content(k:IWindowContainer):IWindowContainer        {
            this._content = k;
            this._list = ((this._content != null) ? cast(this._content.findChildByName("item_list"), IItemListWindow) : null);
            this._scrollV = ((this._content != null) ? cast(this._content.findChildByName("scroller"), IScrollbarWindow) : null);
            if (((k == null) && (this._roomPopupCtrl != null)))
            {
                this._roomPopupCtrl._Str_17240();
            }
return k;
        }
public function  get_content():IWindowContainer
        {
            return this._content;
        }

        public function refresh()
        {
            var _local_4 = false;
            var k= this.getRooms();
            var _local_2= this.getVisibleEntryCount();
            this._list.autoArrangeItems = false;
            var _local_3 = 0;
            while (true)
            {
                if (_local_3 < k.length)
                {
                    this.refreshEntry(true, _local_3, k[_local_3]);
                }
                else
                {
                    _local_4 = this.refreshEntry(false, _local_3, null);
                    if (_local_4)
                    {
                        break;
                    }
                }
                _local_3++;
            }
            this._list.autoArrangeItems = true;
            if (((!(this._scrollV == null)) && (!(this.getVisibleEntryCount() == _local_2))))
            {
                this._scrollV.scrollV = 0;
            }
            if (this._content.findChildByName("no_rooms_found") != null)
            {
                this._content.findChildByName("no_rooms_found").visible = (k.length < 1);
            }
        }

        function getVisibleEntryCount():Int
        {
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._list.numListItems)
            {
                if (this._list.getListItemAt(_local_2).visible)
                {
                    k++;
                }
                _local_2++;
            }
            return k;
        }

        function getListEntry(k:Int):IWindowContainer
        {
            var _local_3 = 0;
            var _local_2= cast(this._navigator.getXmlWindow("grs_guest_room_details_phase_one"), IWindowContainer);
            _local_2.background = true;
            _local_2.addEventListener(WindowMouseEvent.MOVE, this.onMouseMove);
            _local_2.addEventListener(WindowMouseEvent.OVER, this.onMouseOver);
            _local_2.addEventListener(WindowMouseEvent.OUT, this.onMouseOut);
            _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            _local_2.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            _local_2.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH, true);
            _local_2.color = this.getBgColor(k);
            _local_2.tags.push(k);
            if (this._showRoomNumbers)
            {
                _local_3 = 20;
                _local_2.findChildByName("roomname").x = (_local_2.findChildByName("roomname").x + _local_3);
                _local_2.findChildByName("roomname").width = (_local_2.findChildByName("roomname").width - _local_3);
            }
            return _local_2;
        }

        function getBgColor(k:Int):UInt
        {
            return ((k % 2) != 0) ? 0xFFFFFFFF : 0xFFDEE4F2;
        }

        function refreshEntry(k:Bool, _arg_2:Int, _arg_3:GuestRoomData):Bool
        {
            var _local_4= cast(this._list.getListItemAt(_arg_2), IWindowContainer);
            var _local_5 = false;
            if (_local_4 == null)
            {
                if (!k)
                {
                    return true;
                }
                _local_4 = this.getListEntry(_arg_2);
                this._list.addListItem(_local_4);
                _local_5 = true;
            }
            Util.hideChildren(_local_4);
            if (k)
            {
                this.refreshEntryDetails(_local_4, _arg_3);
                _local_4.visible = true;
                _local_4.height = 17;
            }
            else
            {
                _local_4.height = 0;
                _local_4.visible = false;
            }
            if (_local_5)
            {
                _local_4.width = (_local_4.width + this._entryWidthAdjustment);
                MainViewCtrl._Str_24055(this, _local_4);
            }
            return false;
        }

        function refreshEntryDetails(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            k.visible = true;
            Util.hideChildren(k);
            this.refreshFavouriteIcon(k, _arg_2);
            var _local_3= ((((_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_CLOSED) || (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_PASSWORD)) || (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_INVISIBLE)) ? "group_base_icon" : "group_base_icon_no_doormode");
            this._navigator.refreshButton(k, _local_3, (_arg_2.habboGroupId > 0), null, 0, "group_base_icon");
            this._navigator.refreshButton(k, "home", this.isHome(_arg_2), null, 0);
            this._navigator.refreshButton(k, "doormode_doorbell_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_CLOSED), null, 0);
            this._navigator.refreshButton(k, "doormode_password_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_PASSWORD), null, 0);
            this._navigator.refreshButton(k, "doormode_invisible_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_INVISIBLE), null, 0);
            if (this._showRoomNumbers)
            {
                k.findChildByName("room_number").visible = true;
                k.findChildByName("room_number").caption = ((k.tags[0] + 2) + ".");
            }
            this.refreshRoomName(k, _arg_2);
            this._userCountRenderer.refreshUserCount(_arg_2.maxUserCount, k, _arg_2.userCount, "${navigator.usercounttooltip.users}", 308, 2);
            k.name = ((("guestroom_" + _arg_2.ownerName) + "_") + _arg_2.roomName);
        }

        function refreshRoomName(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            var _local_3= cast(k.getChildByName("roomname"), ITextWindow);
            _local_3.visible = true;
            var _local_4= ((k.findChildByName("home").visible || k.findChildByName("favourite").visible) || k.findChildByName("make_favourite").visible);
            Util._Str_21212(_local_3, _arg_2.roomName, (_local_4 ? (_local_3.width - 20) : _local_3.width));
        }

        function onMouseMove(k:WindowEvent)
        {
            this.checkFastHorizontalMove(k);
        }

        function onMouseOver(k:WindowEvent)
        {
            var _local_2= k.target;
            if ((this._roomPopupCtrl.visible && this._fastHorizontalMove))
            {
                return;
            }
            this.hilite(cast(_local_2, IWindowContainer));
            var _local_3= ASCompat.toInt(_local_2.tags[0]);
            var _local_4= this.getRoomAt(_local_3);
            if (_local_4 == null)
            {
                return;
            }
            this._roomPopupCtrl.room = _local_4;
            this._roomPopupCtrl._Str_8168(_local_2);
        }

        public function getRooms():Array<ASAny>
        {
            return ((((this._navigator == null) || (this._navigator.data == null)) || (this._navigator.data.guestRoomSearchResults == null)) || (this._navigator.data.guestRoomSearchResults.rooms == null)) ? new Array<ASAny>() : this._navigator.data.guestRoomSearchResults.rooms;
        }

        function getRoomAt(k:Int):GuestRoomData
        {
            return this.getRooms()[k];
        }

        function onMouseOut(k:WindowEvent)
        {
            var _local_2= k.target;
            if (Util._Str_21690(_local_2))
            {
                return;
            }
            var _local_3= ASCompat.toInt(_local_2.tags[0]);
            _local_2.color = this.getBgColor(_local_3);
            this._roomPopupCtrl._Str_17240();
        }

        function onMouseClick(k:WindowEvent)
        {
            var _local_5:Point = null;
            var _local_2= k.target;
            var _local_3= ASCompat.toInt(_local_2.tags[0]);
            var _local_4= this.getRoomAt(_local_3);
            if (_local_4 == null)
            {
                return;
            }
            if (_local_4.ownerName != this._navigator.sessionData.userName)
            {
                if (_local_4.habboGroupId != 0)
                {
                    this._navigator.goToPrivateRoom(_local_4.flatId);
                    return;
                }
                _local_5 = new Point(Std.downcast(k , WindowMouseEvent).stageX, Std.downcast(k , WindowMouseEvent).stageY);
                switch (_local_4.doorMode)
                {
                    case RoomSettingsFlatInfo.DOORMODE_PASSWORD:
                        this._navigator.passwordInput.show(_local_4, _local_5);
                        return;
                    case RoomSettingsFlatInfo.DOORMODE_CLOSED:
                        this._navigator.doorbell.show(_local_4, _local_5);
                        return;
                }
            }
            this.beforeEnterRoom(_local_3);
            this._navigator.goToRoom(_local_4.flatId, true, "", _local_3);
            this._roomPopupCtrl._Str_14696();
        }

        public function beforeEnterRoom(k:Int)
        {
        }

        function refreshFavouriteIcon(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            var _local_3= this._navigator.data._Str_20543(_arg_2.flatId);
            var _local_4= this.isHome(_arg_2);
            this.refreshRegion(k, "make_favourite", ((!_local_3) && (!_local_4)), this.onAddFavouriteClick);
            this.refreshRegion(k, "favourite", (_local_3 && (!_local_4)), this.onRemoveFavouriteClick);
        }

        function isHome(k:GuestRoomData):Bool
        {
            return k.flatId == this._navigator.data.homeRoomId;
        }

        function refreshRegion(k:IWindowContainer, _arg_2:String, _arg_3:Bool, _arg_4:ASFunction)
        {
            var _local_5= Std.downcast(k.findChildByName(_arg_2) , IRegionWindow);
            if (_local_5 == null)
            {
                return;
            }
            if (!_arg_3)
            {
                _local_5.visible = false;
                if (_local_5.hasEventListener(WindowMouseEvent.CLICK))
                {
                    _local_5.removeEventListener(WindowMouseEvent.CLICK, _arg_4);
                }
            }
            else
            {
                _local_5.addEventListener(WindowMouseEvent.CLICK, _arg_4);
                _local_5.visible = true;
                this._navigator.refreshButton(_local_5, _arg_2, _arg_3, null, 0);
            }
        }

        function onRemoveFavouriteClick(k:WindowMouseEvent)
        {
            var _local_2= k.target;
            if (((_local_2 == null) || (_local_2.parent == null)))
            {
                return;
            }
            var _local_3= this.getRoomAt(ASCompat.toInt(_local_2.parent.tags[0]));
            if (_local_3 == null)
            {
                return;
            }
            this._navigator.send(new DeleteFavouriteRoomMessageComposer(_local_3.flatId));
        }

        function onAddFavouriteClick(k:WindowMouseEvent)
        {
            var _local_2= k.target;
            if (((_local_2 == null) || (_local_2.parent == null)))
            {
                return;
            }
            var _local_3= this.getRoomAt(ASCompat.toInt(_local_2.parent.tags[0]));
            if (_local_3 == null)
            {
                return;
            }
            this._navigator.send(new AddFavouriteRoomMessageComposer(_local_3.flatId));
        }

        function hilite(k:IWindowContainer)
        {
            var _local_2 = 0;
            if (((!(this._lastHilite == null)) && (!this._lastHilite.disposed)))
            {
                _local_2 = ASCompat.toInt(this._lastHilite.tags[0]);
                this._lastHilite.color = this.getBgColor(_local_2);
            }
            this._lastHilite = k;
            k.color = 0xFFA2D6EA;
        }

        function checkFastHorizontalMove(k:WindowEvent)
        {
            var _local_2= cast(k, WindowMouseEvent);
            var _local_3= Std.int(Math.abs((this._lastMouseX - _local_2.stageX)));
            this._lastMouseX = Std.int(_local_2.stageX);
            this._fastHorizontalMove = (_local_3 > 2);
        }

        public var roomPopupCtrl(get,never):RoomPopupCtrl;
public function  get_roomPopupCtrl():RoomPopupCtrl
        {
            return this._roomPopupCtrl;
        }

        public var navigator(get,never):HabboNavigator;
public function  get_navigator():HabboNavigator
        {
            return this._navigator;
        }
    }

