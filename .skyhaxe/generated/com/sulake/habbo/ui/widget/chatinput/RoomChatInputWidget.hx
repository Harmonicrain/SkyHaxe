package com.sulake.habbo.ui.widget.chatinput
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import flash.utils.Timer;
    import com.sulake.habbo.ui.RoomUI;
    import com.sulake.habbo.ui.IRoomDesktop;
    import com.sulake.habbo.ui.handler.ChatInputWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetChatInputContentUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_6300;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.roomtools.RoomToolsWidget;
    import com.sulake.core.window.IWindow;

     class RoomChatInputWidget extends RoomWidgetBase
    {
        static inline final _Str_16319= 5000;

        var _visualization:RoomChatInputView;
        var _selectedUserName:String = "";
        var _floodBlocked:Bool = false;
        var _releaseTimer:Timer = null;
        var _lastPasteTime:Int = 0;
        var _roomUi:RoomUI;
        var _desktop:IRoomDesktop;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:RoomUI, _arg_6:IRoomDesktop)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._roomUi = _arg_5;
            this._desktop = _arg_6;
            this._visualization = new RoomChatInputView(this);
            Std.downcast(k , ChatInputWidgetHandler).widget = this;
        }

        public var _Str_21409(get,never):Bool;
public function  get__Str_21409():Bool
        {
            return this._floodBlocked;
        }

        public var _Str_13265(get,never):RoomUI;
public function  get__Str_13265():RoomUI
        {
            return this._roomUi;
        }

        public var handler(get,never):ChatInputWidgetHandler;
public function  get_handler():ChatInputWidgetHandler
        {
            return Std.downcast(_handler , ChatInputWidgetHandler);
        }

        override public function dispose()
        {
            if (this._visualization != null)
            {
                this._visualization.dispose();
                this._visualization = null;
            }
            if (this._releaseTimer != null)
            {
                this._releaseTimer.stop();
                this._releaseTimer = null;
            }
            this._roomUi = null;
            super.dispose();
        }

        public var _Str_24849(get,never):Bool;
public function  get__Str_24849():Bool
        {
            return (flash.Lib.getTimer() - this._lastPasteTime) > _Str_16319;
        }

        public function _Str_23495()
        {
            this._lastPasteTime = flash.Lib.getTimer();
        }

        public function _Str_25042(k:String, _arg_2:Int, _arg_3:String="", _arg_4:Int=0)
        {
            if (this._floodBlocked)
            {
                return;
            }
            var _local_5= new RoomWidgetChatMessage(RoomWidgetChatMessage.RWCM_MESSAGE_CHAT, k, _arg_2, _arg_3, _arg_4);
            if (messageListener != null)
            {
                messageListener.processWidgetMessage(_local_5);
            }
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this._Str_20658);
            k.addEventListener(RoomWidgetChatInputContentUpdateEvent.RWWCIDE_CHAT_INPUT_CONTENT, this._Str_20741);
            k.addEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.onUserInfo);
            k.addEventListener(_Str_6300.RWFCE_FLOOD_CONTROL, this.onFloodControl);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this._Str_20658);
            k.removeEventListener(RoomWidgetChatInputContentUpdateEvent.RWWCIDE_CHAT_INPUT_CONTENT, this._Str_20741);
            k.removeEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.onUserInfo);
            k.removeEventListener(_Str_6300.RWFCE_FLOOD_CONTROL, this.onFloodControl);
        }

        function _Str_20658(k:RoomWidgetRoomObjectUpdateEvent)
        {
            this._selectedUserName = "";
        }

        function onUserInfo(k:RoomWidgetUserInfoUpdateEvent)
        {
            this._selectedUserName = k.name;
        }

        function _Str_20741(k:RoomWidgetChatInputContentUpdateEvent)
        {
            var _local_2= "";
            switch (k._Str_23621)
            {
                case RoomWidgetChatInputContentUpdateEvent.WHISPER:
                    _local_2 = localizations.getLocalization("widgets.chatinput.mode.whisper", ":tell");
                    this._visualization._Str_23022(_local_2, k.userName);
                    return;
                case RoomWidgetChatInputContentUpdateEvent.SHOUT:
                    return;
            }
        }

        function onTimerComplete(k:TimerEvent)
        {
            Logger.log(["Releasing flood blocking"]);
            this._floodBlocked = false;
            if (this._visualization != null)
            {
                this._visualization._Str_22810();
            }
            this._releaseTimer = null;
        }

        function onTimer(k:TimerEvent)
        {
            if (this._visualization != null)
            {
                this._visualization._Str_22027((this._releaseTimer.repeatCount - this._releaseTimer.currentCount));
            }
        }

        public function _Str_24485()
        {
            this._visualization.updatePosition(null);
        }

        public function refreshChatStyles()
        {
            if (this._visualization != null)
            {
                this._visualization.refreshChatStyles();
            }
        }

        public function _Str_24691():Int
        {
            if (this._roomUi.friendBarView == null)
            {
                return 1000;
            }
            return this._roomUi.friendBarView.friendBarWidth;
        }

        public function _Str_26449():Int
        {
            if (this._roomUi.toolbar == null)
            {
                return 1000;
            }
            return this._roomUi.toolbar.toolBarAreaWidth;
        }

        public function _Str_22730():Int
        {
            var k= Std.downcast(this._desktop.getWidget(RoomWidgetEnum.ROOM_TOOLS) , RoomToolsWidget);
            if (k == null)
            {
                return 0;
            }
            return k._Str_24850();
        }

        public var _Str_21568(get,never):String;
public function  get__Str_21568():String
        {
            return this._selectedUserName;
        }

        public function onFloodControl(k:_Str_6300)
        {
            this._floodBlocked = true;
            Logger.log([(("Enabling flood blocking for " + Std.string(k.seconds)) + " seconds")]);
            if (this._releaseTimer != null)
            {
                this._releaseTimer.reset();
            }
            else
            {
                this._releaseTimer = new Timer(1000, k.seconds);
                this._releaseTimer.addEventListener(TimerEvent.TIMER, (this.onTimer : ASAny));
                this._releaseTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onTimerComplete : ASAny));
            }
            this._releaseTimer.start();
            if (this._visualization != null)
            {
                this._visualization._Str_22027(k.seconds);
                this._visualization._Str_22358();
            }
        }

        override public function  get_mainWindow():IWindow
        {
            return this._visualization.window;
        }

        public function hide()
        {
            if (this.mainWindow != null)
            {
                this.mainWindow.visible = false;
            }
        }

        public function getChatInputY():Int
        {
            return (this._visualization != null) ? this._visualization.getChatInputY() : 0;
        }

        public function _Str_23678():Array<ASAny>
        {
            var k:Array<ASAny> = null;
            if (this._visualization != null)
            {
                k = this._visualization._Str_25675();
            }
            return k;
        }
    }

