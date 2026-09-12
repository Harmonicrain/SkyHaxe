package com.sulake.habbo.ui.widget.roomtools
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.communication.messages.incoming.navigator.GuestRoomData;
    import com.sulake.habbo.ui.IRoomDesktop;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import flash.utils.Timer;
    import org.openvideoads.util.StringUtils;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.session.UIFlags;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.ui.RoomUI;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.handler.RoomToolsWidgetHandler;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputWidget;

     class RoomToolsWidget extends RoomWidgetBase
    {
        static inline final ROOM_HISTORY_MAX_LENGTH= 10;
        static var _visitedRooms:Vector<GuestRoomData> = new Vector();
        static var _currentRoomIndex:Int = 0;

        var _currentRoomName:String = "";
        var _toolbarView:RoomToolsToolbarCtrl;
        var _roomToolsInfoCtrl:RoomToolsInfoCtrl;
        var _desktop:IRoomDesktop;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _roomButtonTimer:Timer;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:RoomUI)
        {
            super(k, _arg_2, _arg_3, _arg_4.localization);
            this.handler.widget = this;
            this._desktop = _arg_4.getDesktop("hard_coded_room_id");
            this._freeFlowChat = _arg_4.freeFlowChat;
            this._roomToolsInfoCtrl = new RoomToolsInfoCtrl(this, _arg_2, _arg_3);
            this._toolbarView = new RoomToolsToolbarCtrl(this, _arg_2, _arg_3);
            this._toolbarView._Str_20713();
            this._toolbarView._Str_24545(((!(this._freeFlowChat != null)) || (!this._freeFlowChat.isDisabledInPreferences)));
            var _local_5= _arg_4.getProperty("camera.launch.ui.position");
            this._toolbarView._Str_23347((this.handler.container.sessionDataManager.isPerkAllowed(PerkEnum.CAMERA) && (StringUtils.isEmpty(_local_5) || (_local_5 == "room-menu"))));
            this._toolbarView._Str_21132(this.handler._Str_5090);
            this._toolbarView.setCollapsed((this.handler.sessionDataManager.isNoob || (!((this.handler.sessionDataManager.uiFlags & UIFlags.ROOM_TOOLS_OPEN) != 0))));
        }

        override public function dispose()
        {
            if (this._roomButtonTimer != null)
            {
                this._roomButtonTimer.stop();
                this._roomButtonTimer = null;
            }
            if (this._toolbarView != null)
            {
                this._toolbarView.dispose();
                this._toolbarView = null;
            }
            if (this._roomToolsInfoCtrl != null)
            {
                this._roomToolsInfoCtrl.dispose();
                this._roomToolsInfoCtrl = null;
            }
            this._freeFlowChat = null;
            this._desktop = null;
            super.dispose();
        }

        public function updateRoomData(k:GuestRoomData)
        {
            var _local_2:GuestRoomData = null;
            final _iter_ = _visitedRooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.flatId == k.flatId)
                {
                    _local_2.roomName = k.roomName;
                }
            }
        }

        public function storeRoomData(k:GuestRoomData)
        {
            var _local_2:GuestRoomData = null;
            final _iter_ = _visitedRooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.flatId == k.flatId)
                {
                    return;
                }
            }
            _visitedRooms.push(k);
            if (_visitedRooms.length > ROOM_HISTORY_MAX_LENGTH)
            {
                _visitedRooms.shift();
            }
            _currentRoomIndex = (_visitedRooms.length - 1);
            if (this._toolbarView != null)
            {
                this._toolbarView._Str_21132(this.handler._Str_5090);
            }
        }

        public function showRoomInfo(k:Bool, _arg_2:String, _arg_3:String, _arg_4:Array<ASAny>)
        {
            if (this._roomToolsInfoCtrl == null)
            {
                return;
            }
            this._currentRoomName = _arg_2;
            this._roomToolsInfoCtrl.showRoomInfo(k, _arg_2, _arg_3, _arg_4);
        }

        public function enterNewRoom(k:Int)
        {
            var _local_3:GuestRoomData = null;
            if (((!(this._toolbarView != null)) || (!(this._roomToolsInfoCtrl != null))))
            {
                return;
            }
            var _local_2 = 0;
            final _iter_ = _visitedRooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.flatId == k)
                {
                    _currentRoomIndex = _local_2;
                }
                _local_2++;
            }
            this._toolbarView._Str_18755();
            if (this._roomButtonTimer != null)
            {
                this._roomButtonTimer.stop();
            }
            this._roomButtonTimer = new Timer(2000, 1);
            this._roomButtonTimer.addEventListener(TimerEvent.TIMER, (this.roomButtonTimerEventHandler : ASAny));
            this._roomButtonTimer.start();
            this._roomToolsInfoCtrl.setElementVisible("tags", true);
        }

        function roomButtonTimerEventHandler(k:TimerEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , Timer);
            if (_local_2 != null)
            {
                _local_2.stop();
                _local_2.removeEventListener(TimerEvent.TIMER, (this.roomButtonTimerEventHandler : ASAny));
            }
            if (this._toolbarView != null)
            {
                this._toolbarView._Str_20713();
            }
        }

        public function setCollapsed(k:Bool)
        {
            if (this._toolbarView != null)
            {
                this._toolbarView.setCollapsed(k);
            }
            if (this._roomToolsInfoCtrl != null)
            {
                this._roomToolsInfoCtrl.setToolbarCollapsed(k);
            }
        }

        public var handler(get,never):RoomToolsWidgetHandler;
public function  get_handler():RoomToolsWidgetHandler
        {
            return Std.downcast(_handler , RoomToolsWidgetHandler);
        }

        public function getIconLocation(k:String):IWindow
        {
            var _local_2= this._toolbarView.window.findChildByName(k);
            return _local_2;
        }

        public function _Str_24850():Int
        {
            return (this._toolbarView != null) ? this._toolbarView.right : 0;
        }

        public function getChatInputY():Int
        {
            if (this._desktop == null)
            {
                return 0;
            }
            var k= Std.downcast(this._desktop.getWidget(RoomWidgetEnum.CHAT_INPUT_WIDGET) , RoomChatInputWidget);
            if (k == null)
            {
                return 0;
            }
            return k.getChatInputY();
        }

        public function getRoomToolbarRight():Int
        {
            return (this._toolbarView != null) ? this._toolbarView.right : 0;
        }

        public function getRoomToolbarCollapsedRight():Int
        {
            return (this._toolbarView != null) ? this._toolbarView.collapsedRight : 0;
        }

        public function getRoomToolbarTop():Int
        {
            return (this._toolbarView != null) ? this._toolbarView.top : 0;
        }

        public var isRoomToolbarCollapsed(get,never):Bool;
public function  get_isRoomToolbarCollapsed():Bool
        {
            return (this._toolbarView != null) ? this._toolbarView.isCollapsed : true;
        }

        public function getCurrentRoomZoomText():String
        {
            var k= ((this._desktop != null) ? this._desktop.getCurrentRoomCanvasZoomScale() : Math.NaN);
            if ((Math.isNaN(k) || (k <= 0)))
            {
                k = 1;
            }
            return Std.string((Math.fround((Math.log(k) / 0.6931471805599453)) + 1));
        }

        public function canZoomRoom(k:Int):Bool
        {
            return ((this._desktop != null) && this._desktop.canZoomRoomCanvas(k));
        }

        public function zoomRoom(k:Int)
        {
            if (this._desktop != null)
            {
                this._desktop.zoomRoomCanvas(k);
            }
        }

        public function goToNextRoom()
        {
            var k= (_currentRoomIndex + 1);
            var _local_2= _visitedRooms.length;
            if (k > _local_2)
            {
                k = _local_2;
            }
            this.handler.goToPrivateRoom(_visitedRooms[k].flatId);
            this._toolbarView._Str_18755();
        }

        public function goToPreviousRoom()
        {
            var k= (_currentRoomIndex - 1);
            if (k < 0)
            {
                k = 0;
            }
            this.handler.goToPrivateRoom(_visitedRooms[k].flatId);
            this._toolbarView._Str_18755();
        }

        public var freeFlowChat(get,never):IHabboFreeFlowChat;
public function  get_freeFlowChat():IHabboFreeFlowChat
        {
            return this._freeFlowChat;
        }

        public var visitedRooms(get,never):Vector<GuestRoomData>;
public function  get_visitedRooms():Vector<GuestRoomData>
        {
            return _visitedRooms;
        }

        public var currentRoomIndex(get,never):Int;
public function  get_currentRoomIndex():Int
        {
            return _currentRoomIndex;
        }

        public var _Str_26110(get,never):String;
public function  get__Str_26110():String
        {
            return this._currentRoomName;
        }
    }

