package com.sulake.habbo.navigator.mainview
;
    import com.sulake.habbo.navigator.HabboNavigator;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.habbo.communication.messages.incoming.navigator.RoomSettingsFlatInfo;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.communication.messages.outgoing.navigator.RoomAdEventTabAdClickedComposer;
    import com.sulake.core.window.events.WindowEvent;

     class RoomAdListCtrl extends GuestRoomListCtrl 
    {
        public function new(k:HabboNavigator, _arg_2:Int, _arg_3:Bool)
        {
            super(k, _arg_2, _arg_3);
        }

        override function getListEntry(k:Int):IWindowContainer
        {
            var _local_2= cast(_navigator.getXmlWindow("grs_room_ads_details_phase_one"), IWindowContainer);
            _local_2.background = true;
            _local_2.addEventListener(WindowMouseEvent.MOVE, onMouseMove);
            _local_2.addEventListener(WindowMouseEvent.OVER, onMouseOver);
            _local_2.addEventListener(WindowMouseEvent.OUT, onMouseOut);
            _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            _local_2.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            _local_2.setParamFlag(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH, true);
            _local_2.color = getBgColor(k);
            _local_2.tags.push(k);
            return _local_2;
        }

        override function refreshEntryDetails(k:IWindowContainer, _arg_2:GuestRoomData)
        {
            k.visible = true;
            var _local_3= cast(k.getChildByName("adname"), ITextWindow);
            _local_3.visible = true;
            Util._Str_21212(_local_3, _arg_2.roomAdName, k.width);
            _navigator.refreshButton(k, "doormode_doorbell_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_CLOSED), null, 0);
            _navigator.refreshButton(k, "doormode_password_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_PASSWORD), null, 0);
            _navigator.refreshButton(k, "doormode_invisible_small", (_arg_2.doorMode == RoomSettingsFlatInfo.DOORMODE_INVISIBLE), null, 0);
            _userCountRenderer.refreshUserCount(_arg_2.maxUserCount, k, _arg_2.userCount, "${navigator.usercounttooltip.users}", 308, 2);
        }

        function getRoomAt__com_sulake_habbo_navigator_mainview_RoomAdListCtrl/*redefined private*/(k:Int):GuestRoomData
        {
            return getRooms()[k];
        }

        override function onMouseClick(k:WindowEvent)
        {
            var _local_2= k.target;
            var _local_3= ASCompat.toInt(_local_2.tags[0]);
            var _local_4= this.getRoomAt__com_sulake_habbo_navigator_mainview_RoomAdListCtrl(_local_3);
            if (_navigator != null)
            {
                _navigator.send(new RoomAdEventTabAdClickedComposer(_local_4.flatId, _local_4.roomAdName, _local_4.roomAdExpiresInMin));
            }
            super.onMouseClick(k);
        }
    }

