package com.sulake.habbo.ui.widget.roomtools
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.geom.Point;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetZoomToggleMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.system.System;

     class RoomToolsToolbarCtrl extends RoomToolsCtrlBase implements IUpdateReceiver
    {
        static inline final _Str_18592= 1;
        static inline final _Str_12959= -130;
        static inline final ANIMATION_DURATION_MS= 140;

        var _roomToolsHistory:RoomToolsHistory;
        var _disposed:Bool = false;
        var _isAnimating:Bool = false;
        var _isRegisteredForUpdates:Bool = false;
        var _expandedBranchOffset:Float = 0;
        var _animationStartOffset:Float = 0;
        var _animationTargetOffset:Int = 0;
        var _animationElapsed:Int = 0;
        var _lastZoomText:String = "";
        var _lastCanZoomIn:Bool = false;
        var _lastCanZoomOut:Bool = false;

        public function new(k:RoomToolsWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
            _window = Std.downcast(_arg_2.buildFromXML(((_arg_3.getAssetByName("room_tools_toolbar_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            _window.procedure = this.onWindowEvent;
            _window.addEventListener(WindowMouseEvent.OVER, this.onWindowEvent);
            _window.addEventListener(WindowMouseEvent.OUT, this.onWindowEvent);
            this._expandedBranchOffset = this.getCollapsedExpandedOffsetX();
            this._Str_17459();
            this.ensureUpdateRegistration();
        }

        override public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.removeUpdateRegistration();
            if (this._roomToolsHistory != null)
            {
                this._roomToolsHistory.dispose();
                this._roomToolsHistory = null;
            }
            var k= Std.downcast(_widget.windowManager.getWindowByName("share_room_link") , IWindowContainer);
            if (k != null)
            {
                k.dispose();
            }
            super.dispose();
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function update(k:UInt)
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            if (this._isAnimating)
            {
                this._animationElapsed = ASCompat.toInt(this._animationElapsed + k);
                _local_2 = Math.min(1, (this._animationElapsed / ANIMATION_DURATION_MS));
                _local_3 = (1 - Math.pow((1 - _local_2), 3));
                this.applyExpandedBranchOffset((this._animationStartOffset + ((this._animationTargetOffset - this._animationStartOffset) * _local_3)));
                this.updatePosition();
                if (_local_2 >= 1)
                {
                    this._isAnimating = false;
                    this.applyExpandedBranchOffset(this._animationTargetOffset);
                    this._Str_17459();
                }
            }
            this.updateZoomControls();
        }

        public function _Str_20713()
        {
            if (_widget.currentRoomIndex >= (_widget.visitedRooms.length - 1))
            {
                _window.findChildByName("button_history_forward").disable();
            }
            else
            {
                _window.findChildByName("button_history_forward").enable();
            }
            if (_widget.currentRoomIndex == 0)
            {
                _window.findChildByName("button_history_back").disable();
            }
            else
            {
                _window.findChildByName("button_history_back").enable();
            }
            if (_widget.visitedRooms.length <= 1)
            {
                _window.findChildByName("button_history").disable();
            }
            else
            {
                _window.findChildByName("button_history").enable();
            }
        }

        public function _Str_18755()
        {
            _window.findChildByName("button_history_forward").disable();
            _window.findChildByName("button_history_back").disable();
        }

        function _Str_24287()
        {
            if (this._roomToolsHistory != null)
            {
                this._roomToolsHistory.dispose();
                this._roomToolsHistory = null;
            }
            else
            {
                this._roomToolsHistory = new RoomToolsHistory(_windowManager, _assets, handler);
                this._roomToolsHistory.populate(_widget.visitedRooms);
                this.updatePosition();
            }
        }

        public function _Str_24545(k:Bool)
        {
            this.setElementVisible("button_chat_history", k);
        }

        public function _Str_23347(k:Bool)
        {
            this.setElementVisible("button_camera", k);
        }

        public function _Str_21132(k:Bool)
        {
            this.setElementVisible("button_like", k);
        }

        override public function setElementVisible(k:String, _arg_2:Bool)
        {
            if (window == null)
            {
                return;
            }
            window.visible = true;
            super.setElementVisible(k, _arg_2);
            this.updatePosition();
        }

        function ensureUpdateRegistration()
        {
            var k= this.getUpdateComponent();
            if (((!this._isRegisteredForUpdates) && (!(k == null))))
            {
                k.registerUpdateReceiver(this, 1);
                this._isRegisteredForUpdates = true;
            }
        }

        function removeUpdateRegistration()
        {
            var k= this.getUpdateComponent();
            if ((this._isRegisteredForUpdates && (!(k == null))))
            {
                k.removeUpdateReceiver(this);
            }
            this._isRegisteredForUpdates = false;
        }

        function getUpdateComponent():Component
        {
            if ((((!(_widget != null)) || (!(_widget.handler != null))) || (!(_widget.handler.container != null))))
            {
                return null;
            }
            return ASCompat.reinterpretAs(_widget.handler.container.roomEngine , Component);
        }

        function updateZoomControls()
        {
            var k:ITextWindow = null;
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            if (window == null)
            {
                return;
            }
            var _local_4= _widget.canZoomRoom(1);
            var _local_5= _widget.canZoomRoom(-1);
            var _local_6= _widget.getCurrentRoomZoomText();
            if (((((this._lastZoomText == _local_6) && (this._lastCanZoomIn == _local_4)) && (this._lastCanZoomOut == _local_5)) && (!(this._lastZoomText == ""))))
            {
                return;
            }
            k = Std.downcast(window.findChildByName("zoom_text") , ITextWindow);
            if (k != null)
            {
                k.caption = _widget.localizations.registerParameter("room.zoom.text", "zoom_level", _local_6);
            }
            _local_2 = window.findChildByName("zoom_in_btn");
            if (_local_2 != null)
            {
                if (_local_4)
                {
                    _local_2.enable();
                }
                else
                {
                    _local_2.disable();
                }
            }
            _local_3 = window.findChildByName("zoom_out_btn");
            if (_local_3 != null)
            {
                if (_local_5)
                {
                    _local_3.enable();
                }
                else
                {
                    _local_3.disable();
                }
            }
            this._lastZoomText = _local_6;
            this._lastCanZoomIn = _local_4;
            this._lastCanZoomOut = _local_5;
        }

        public function updatePosition()
        {
            var k:IWindow = null;
            var _local_2:IWindow = null;
            var _local_3:IItemListWindow = null;
            var _local_4:IWindow = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:IWindow = null;
            var _local_8:IWindow = null;
            var _local_9:IWindow = null;
            var _local_10:IWindow = null;
            if (window == null)
            {
                return;
            }
            _local_3 = Std.downcast(window.findChildByName("itemlist_buttons") , IItemListWindow);
            _local_2 = window.findChildByName("window_bg");
            _local_4 = window.findChildByName("side_bar_collapse");
            k = window.findChildByName("side_bar_expand");
            _local_8 = window.findChildByName("button_collapse");
            _local_9 = window.findChildByName("button_expand");
            _local_10 = window.findChildByName("arrow_collapse");
            if ((((!(_local_3 == null)) && (!(_local_2 == null))) && (!(_local_4 == null))))
            {
                _local_5 = 0;
                _local_6 = 0;
                while (_local_6 < _local_3.numListItems)
                {
                    _local_7 = _local_3.getListItemAt(_local_6);
                    if (_local_7.visible)
                    {
                        _local_5 = (_local_5 + _local_7.height);
                    }
                    _local_6++;
                }
                _local_4.height = _local_5;
                _local_4.x = 0;
                if (k != null)
                {
                    k.height = _local_5;
                    k.x = 0;
                    k.y = 0;
                }
                window.height = (_local_3.height = (_local_2.height = _local_5));
                if (_local_8 != null)
                {
                    _local_8.height = _local_5;
                }
                if (_local_9 != null)
                {
                    _local_9.height = _local_5;
                }
                if (_local_10 != null)
                {
                    _local_10.y = Std.int((_local_5 * 0.5) - (_local_10.height * 0.5));
                }
                _local_7 = window.findChildByName("arrow_expand");
                if (_local_7 != null)
                {
                    _local_7.y = Std.int((_local_5 * 0.5) - (_local_7.height * 0.5));
                }
            }
            window.position = new Point(RoomToolsCtrlBase.TOOLBAR_X, ((window.desktop.height - RoomToolsCtrlBase.DISTANCE_FROM_BOTTOM) - window.height));
            if (this._roomToolsHistory != null)
            {
                this._roomToolsHistory.window.position = new Point((this.right - this._roomToolsHistory.window.width), (window.position.y - this._roomToolsHistory.window.height));
            }
        }

        override public function setCollapsed(k:Bool)
        {
            if (((_isCollapsed == k) || (!(window != null))))
            {
                return;
            }
            _isCollapsed = k;
            this.beginAnimation(_isCollapsed ? this.getCollapsedExpandedOffsetX() : 0);
        }

        function _Str_17459()
        {
            if (((!(window != null)) || (!(window.findChildByName("window_bg") != null))))
            {
                return;
            }
            window.findChildByName("window_bg").visible = ((!_isCollapsed) || this._isAnimating);
            window.findChildByName("side_bar_collapse").visible = (!_isCollapsed);
            window.findChildByName("side_bar_expand").visible = _isCollapsed;
            this.applyExpandedBranchOffset(this._expandedBranchOffset);
            this.updatePosition();
            this.updateZoomControls();
        }

        function beginAnimation(k:Int)
        {
            this._animationStartOffset = this._expandedBranchOffset;
            this._animationTargetOffset = k;
            this._animationElapsed = 0;
            this._isAnimating = (this._animationStartOffset != this._animationTargetOffset);
            this._Str_17459();
            if (!this._isAnimating)
            {
                return;
            }
            this.ensureUpdateRegistration();
            if (!this._isRegisteredForUpdates)
            {
                this._isAnimating = false;
                this.applyExpandedBranchOffset(k);
                this._Str_17459();
            }
        }

        function applyExpandedBranchOffset(k:Float)
        {
            var _local_2:IWindow = null;
            if (window == null)
            {
                return;
            }
            _local_2 = window.findChildByName("window_bg");
            if (_local_2 == null)
            {
                return;
            }
            this._expandedBranchOffset = k;
            _local_2.x = Std.int(1 + k);
        }

        function getCollapsedExpandedOffsetX():Int
        {
            var k:IWindow = null;
            var _local_2:IWindow = null;
            if (window == null)
            {
                return 0;
            }
            k = window.findChildByName("window_bg");
            _local_2 = window.findChildByName("side_bar_expand");
            if (((k == null) || (_local_2 == null)))
            {
                return 0;
            }
            return ((_local_2.width - k.width) - 1);
        }

        function onWindowEvent(event:WindowEvent, target:IWindow)
        {
            var link:String = null;
            var shareWindow:IWindowContainer = null;
            var openCameraEvent:HabboToolbarEvent = null;
            var message:RoomWidgetZoomToggleMessage = null;
            var asset:com.sulake.core.utils.xml.XML = null;
            if (((((event.type == WindowEvent.WINDOW_EVENT_PARENT_RESIZED) && (this.window != null)) && (this.window.parent != null)) && (event.target == this.window.parent)))
            {
                return this.updatePosition();
            }
            switch (event.type)
            {
                case WindowMouseEvent.CLICK:
                    clearCollapseTimer();
                    switch (target.name)
                    {
                        case "button_settings":
                            handler.toggleRoomInfoWindow();
                            
                        case "button_zoom":
                            if (_widget.messageListener != null)
                            {
                                message = new RoomWidgetZoomToggleMessage();
                                _widget.messageListener.processWidgetMessage(message);
                            }
                            
                        case "zoom_in_btn":
                            _widget.zoomRoom(1);
                            this.updateZoomControls();
                            
                        case "zoom_out_btn":
                            _widget.zoomRoom(-1);
                            this.updateZoomControls();
                            
                        case "button_collapse"
                           | "button_expand":
                            _widget.setCollapsed((!_isCollapsed));
                            handler.sessionDataManager.setRoomToolsState((!_isCollapsed));
                            
                        case "button_history_back":
                            _widget.goToPreviousRoom();
                            
                        case "button_history_forward":
                            _widget.goToNextRoom();
                            
                        case "button_history":
                            this._Str_24287();
                            
                        case "button_chat_history":
                            if (_widget.freeFlowChat != null)
                            {
                                _widget.freeFlowChat.toggleVisibility();
                                _widget.setCollapsed(true);
                            }
                            
                        case "button_like":
                            handler.rateRoom();
                            window.findChildByName("button_like").disable();
                            
                        case "button_share":
                            link = this.getEmbedData();
                            shareWindow = Std.downcast(_widget.windowManager.getWindowByName("share_room_link") , IWindowContainer);
                            if (shareWindow == null)
                            {
                                asset = ((_assets.getAssetByName("share_room_xml").content : com.sulake.core.utils.xml.XML) );
                                if (asset != null)
                                {
                                    shareWindow = Std.downcast(_widget.windowManager.buildFromXML(asset) , IWindowContainer);
                                }
                            }
                            if (shareWindow != null)
                            {
                                HabboTracking.getInstance().trackEventLog("RoomLink", "click", "client.room_link.clicked");
                                shareWindow.name = "share_room_link";
                                shareWindow.center();
                                shareWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, function (k:WindowMouseEvent, _arg_2:IWindow=null)
                                {
                                    shareWindow.dispose();
                                });
                                shareWindow.findChildByName("embed_src_txt").caption = this.getEmbedData();
                                shareWindow.findChildByName("embed_src_direct_txt").caption = this.getEmbedData("embed_src_direct_txt", "${url.prefix}/room/%roomId%");
                                cast(shareWindow.findChildByName("thumbnail_image"), IStaticBitmapWrapperWindow).assetUri = this._Str_24878();
                            }
                            try
                            {
                                System.setClipboard(this.getEmbedData());
                            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                             {
                            }
                            
 }                        case "button_camera":
                            openCameraEvent = new HabboToolbarEvent(HabboToolbarEvent.HTE_ICON_CAMERA);
                            openCameraEvent.iconName = HabboToolbarEvent.ROOMTOOLSMENU;
                            handler.container.toolbar.events.dispatchEvent(openCameraEvent);
                            
                    }
                    return;
            }
        }

        function getEmbedData(k:String="navigator.embed.src", _arg_2:String=""):String
        {
            var _local_3:String = null;
            var _local_4:String = null;
            if (_widget.handler.navigator.enteredGuestRoomData != null)
            {
                _local_3 = "private";
                _local_4 = ("" + Std.string(_widget.handler.navigator.enteredGuestRoomData.flatId));
            }
            var _local_5= _widget.handler.container.config.getProperty("user.hash");
            if (_widget.localizations.hasLocalization(k))
            {
                _widget.localizations.registerParameter(k, "roomType", _local_3);
                _widget.localizations.registerParameter(k, "embedCode", _local_5);
                _widget.localizations.registerParameter(k, "roomId", _local_4);
            }
            else
            {
                if (_arg_2 != "")
                {
                    _arg_2 = ASCompat.stringReplace(_arg_2, "${url.prefix}", _widget.handler.container.config.getProperty("url.prefix"));
                    _arg_2 = ASCompat.stringReplace(_arg_2, "%roomId%", _local_4);
                    return _arg_2;
                }
            }
            return _widget.localizations.getLocalization(k, _arg_2);
        }

        function _Str_24878():String
        {
            var _local_2:String = null;
            var k= "";
            if (_widget.handler.navigator.enteredGuestRoomData.officialRoomPicRef != null)
            {
                if (_widget.handler.container.config.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))
                {
                    _local_2 = _widget.handler.container.config.getProperty("navigator.thumbnail.url_base");
                    k = ((_local_2 + Std.string(_widget.handler.navigator.enteredGuestRoomData.flatId)) + ".png");
                }
                else
                {
                    k = (_widget.handler.container.config.getProperty("image.library.url") + _widget.handler.navigator.enteredGuestRoomData.officialRoomPicRef);
                }
            }
            else
            {
                _local_2 = _widget.handler.container.config.getProperty("navigator.thumbnail.url_base");
                k = ((_local_2 + Std.string(_widget.handler.navigator.enteredGuestRoomData.flatId)) + ".png");
            }
            return k;
        }

        public var right(get,never):Int;
public function  get_right():Int
        {
            var k:IWindow = null;
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            var _local_4 = 0;
            if (window == null)
            {
                return 0;
            }
            if ((_isCollapsed && (!this._isAnimating)))
            {
                k = window.findChildByName("side_bar_expand");
                return (k != null) ? (k.width + RoomToolsCtrlBase.TOOLBAR_X) : 0;
            }
            k = window.findChildByName("window_bg");
            _local_2 = window.findChildByName("side_bar_expand");
            _local_3 = window.findChildByName("side_bar_collapse");
            if (((k != null) && k.visible))
            {
                _local_4 = Std.int(Math.max(_local_4, Math.fround((k.x + k.width))));
            }
            if (((_local_2 != null) && _local_2.visible))
            {
                _local_4 = Std.int(Math.max(_local_4, Math.fround((_local_2.x + _local_2.width))));
            }
            if (((_local_3 != null) && _local_3.visible))
            {
                _local_4 = Std.int(Math.max(_local_4, Math.fround((_local_3.x + _local_3.width))));
            }
            return (_local_4 + RoomToolsCtrlBase.TOOLBAR_X);
        }

        public var collapsedRight(get,never):Int;
public function  get_collapsedRight():Int
        {
            var k:IWindow = null;
            if (window == null)
            {
                return 0;
            }
            k = window.findChildByName("side_bar_expand");
            return (k != null) ? (k.width + RoomToolsCtrlBase.TOOLBAR_X) : 0;
        }

        public var top(get,never):Int;
public function  get_top():Int
        {
            // Computed desktop-anchored resting top (same formula as updatePosition's window.position),
            // NOT the live window.y. The room info box positions itself relative to this on window
            // resize; its WINDOW_EVENT_PARENT_RESIZED handler can run before this toolbar's own
            // updatePosition repositions window.y, so returning the stale live y jumped the info box
            // to the top-left. Deriving it from the current desktop height makes it resize-order safe.
            return (window != null) ? ((window.desktop.height - RoomToolsCtrlBase.DISTANCE_FROM_BOTTOM) - window.height) : 0;
        }
    }

