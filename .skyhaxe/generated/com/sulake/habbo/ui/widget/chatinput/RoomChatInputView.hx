package com.sulake.habbo.ui.widget.chatinput
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ICloseButtonWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import com.sulake.habbo.ui.widget.chatinput.styleselector.ChatStyleSelector;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.freeflowchat.style.IChatStyle;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.room.utils.RoomEnterEffect;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatTypingMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChatMessage;
    import com.sulake.habbo.ui.widget.enums.SystemChatStyleEnum;
    import flash.display.Stage;
    import flash.display.InteractiveObject;
    import flash.display.BitmapData;
    import flash.text.TextField;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.catalog.habbicons.HabbiconCollectionData;
    import com.sulake.habbo.catalog.habbicons.HabbiconController;
    import com.sulake.habbo.catalog.habbicons.HabbiconControllerEvent;
    import com.sulake.habbo.catalog.habbicons.HabbiconShopItem;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.ui.widget.chatinput.habbiconselector.HabbiconSelector;

     class RoomChatInputView 
    {
        static inline final _Str_10663= 12;
        static inline final _Str_16188= "habbopages/chat/commands";

        var _widget:RoomChatInputWidget;
        var _window:IWindowContainer;
        var _inputField:ITextFieldWindow;
        var _inputBorder:IWindow;
        var _blockText:IWindow;
        var _helpButton:ICloseButtonWindow;
        var _helpButtonShowRegion:IRegionWindow;
        var _mouseOverHelpButton:Bool = false;
        var _chatInputContainerWindow:IWindowContainer;
        var _chatStyleSelectorMenuContainer:IWindowContainer;
        var _chatModeIdShout:String;
        var _chatModeIdWhisper:String;
        var _chatModeIdSpeak:String;
        var _isHelpTextShowing:Bool = false;
        var _helpTextFormat:TextFormat;
        var _isTyping:Bool = false;
        var _typingStartedSent:Bool = false;
        var _typingTimer:Timer;
        var _idleTimer:Timer;
        var _nuxIdleTimer:Timer;
        var _lastContent:String = "";
        var _removeDimmerTimer:Timer;
        var _isNoob:Bool = false;
        var _nuxChatReminderTimer:Timer;
        var _chatReminderAnimationCounter:Int = 0;
        var _helpButtonHideTimer:Timer;
        var _chatStyleSelector:ChatStyleSelector;
        var _habbiconSelectorMenuContainer:IWindowContainer;
        var _habbiconButton:IWindow;
        var _habbiconSelector:HabbiconSelector;
        var _habbiconAssetsListenerRegistered:Bool = false;
        var _habbiconButtonListenersRegistered:Bool = false;

        public function new(k:RoomChatInputWidget)
        {
            var _local_2:IHabboConfigurationManager = null;
            var _local_3 = 0;
            this._widget = k;
            this._chatModeIdWhisper = k.localizations.getLocalization("widgets.chatinput.mode.whisper", ":tell");
            this._chatModeIdShout = k.localizations.getLocalization("widgets.chatinput.mode.shout", ":shout");
            this._chatModeIdSpeak = k.localizations.getLocalization("widgets.chatinput.mode.speak", ":speak");
            this._typingTimer = new Timer(1000, 1);
            this._typingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20723 : ASAny));
            this._idleTimer = new Timer(10000, 1);
            this._idleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20169 : ASAny));
            this._isNoob = (this.sessionDataManager.isNoob || this.sessionDataManager.isRealNoob);
            if (this._isNoob)
            {
                _local_2 = k.handler.container.config;
                if (_local_2.getProperty("nux.chat.reminder.shown") != "1")
                {
                    _local_3 = _local_2.getInteger("nux.noob.chat.reminder.delay", 240);
                    this._nuxIdleTimer = new Timer((_local_3 * 1000), 1);
                    this._nuxIdleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onNuxIdleTimerComplete : ASAny));
                    this._nuxIdleTimer.start();
                }
            }
            this._helpTextFormat = new TextFormat(null, null, 0x999999, null, true, false);
            this.createWindow();
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }

        public function dispose()
        {
            if (this._isNoob)
            {
                this.widget.windowManager.hideHint();
                this.widget.windowManager.unregisterHintWindow("nux_chat_reminder");
            }
            this._widget = null;
            if (this._inputField != null)
            {
                this._inputField.removeEventListener(WindowMouseEvent.DOWN, this._Str_22202);
                this._inputField.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_10572);
                this._inputField.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_15516);
                this._inputField.removeEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_14673);
                this._inputField.removeEventListener(WindowMouseEvent.OVER, this._Str_6563);
                this._inputField.removeEventListener(WindowMouseEvent.OUT, this._Str_6563);
                this._inputField = null;
            }
            this._inputBorder = null;
            this._blockText = null;
            if (this._helpButton != null)
            {
                this._helpButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_8782);
                this._helpButton.removeEventListener(WindowMouseEvent.OVER, this._Str_8782);
                this._helpButton.removeEventListener(WindowMouseEvent.OUT, this._Str_8782);
                this._helpButton = null;
            }
            if (this._habbiconButton != null)
            {
                this._habbiconButton.removeEventListener(WindowMouseEvent.CLICK, this.onHabbiconButtonClicked);
                this._habbiconButton = null;
            }
            if (this._habbiconSelector != null)
            {
                this._habbiconSelector.dispose();
                this._habbiconSelector = null;
            }
            this._habbiconSelectorMenuContainer = null;
            this.unregisterHabbiconButtonListeners();
            this.unregisterHabbiconAssetsListener();
            if (this._helpButtonShowRegion != null)
            {
                this._helpButtonShowRegion.removeEventListener(WindowMouseEvent.OVER, this._Str_6563);
                this._helpButtonShowRegion.removeEventListener(WindowMouseEvent.OUT, this._Str_6563);
                this._helpButtonShowRegion = null;
            }
            if (this._chatInputContainerWindow != null)
            {
                this._chatInputContainerWindow.dispose();
                this._chatInputContainerWindow = null;
            }
            if (this._typingTimer != null)
            {
                this._typingTimer.reset();
                this._typingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20723 : ASAny));
                this._typingTimer = null;
            }
            if (this._idleTimer != null)
            {
                this._idleTimer.reset();
                this._idleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20169 : ASAny));
                this._idleTimer = null;
            }
            if (this._nuxIdleTimer != null)
            {
                this._nuxIdleTimer.reset();
                this._nuxIdleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onNuxIdleTimerComplete : ASAny));
                this._nuxIdleTimer = null;
            }
            if (this._nuxChatReminderTimer != null)
            {
                this._nuxChatReminderTimer.reset();
                this._nuxChatReminderTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this._Str_20444 : ASAny));
                this._nuxChatReminderTimer = null;
            }
            if (this._removeDimmerTimer != null)
            {
                this._removeDimmerTimer.reset();
                this._removeDimmerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                this._removeDimmerTimer = null;
            }
            if (((this._window != null) && (this._window.desktop != null)))
            {
                this._window.desktop.removeChild(this._window);
            }
        }

        function createWindow()
        {
            var _local_3:Array<ASAny> = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = false;
            var _local_6 = 0;
            var _local_7:IChatStyle = null;
            if (this._chatInputContainerWindow != null)
            {
                return;
            }
            var k= "chatinput_window_new";
            var _local_2= Std.downcast(this._widget.assets.getAssetByName(k) , XmlAsset);
            if (((_local_2 == null) || (_local_2.content == null)))
            {
                return;
            }
            this._window = Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._window.width = this._window.desktop.width;
            this._window.height = this._window.desktop.height;
            this._window.invalidate();
            this._chatStyleSelectorMenuContainer = cast(this._window.findChildByName("chatstyles_menu"), IWindowContainer);
            this._habbiconSelectorMenuContainer = cast(this._window.findChildByName("habbicon_menu"), IWindowContainer);
            this._chatInputContainerWindow = Std.downcast(this._window.findChildByName("bubblecont") , IWindowContainer);
            this._chatInputContainerWindow.tags.push("room_widget_chatinput");
            this._inputField = Std.downcast(this._chatInputContainerWindow.findChildByName("chat_input") , ITextFieldWindow);
            this._inputBorder = this._chatInputContainerWindow.findChildByName("input_border");
            this._blockText = this._chatInputContainerWindow.findChildByName("block_text");
            this._helpButtonShowRegion = cast(this._chatInputContainerWindow.findChildByName("helpbutton_show_hover_region"), IRegionWindow);
            this._helpButtonShowRegion.addEventListener(WindowMouseEvent.OVER, this._Str_6563);
            this._helpButtonShowRegion.addEventListener(WindowMouseEvent.OUT, this._Str_6563);
            this.updatePosition();
            this._inputField.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            this._inputField.addEventListener(WindowMouseEvent.DOWN, this._Str_22202);
            this._inputField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this._Str_10572);
            this._inputField.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_15516);
            this._inputField.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this._Str_14673);
            this._inputField.addEventListener(WindowMouseEvent.OVER, this._Str_6563);
            this._inputField.addEventListener(WindowMouseEvent.OUT, this._Str_6563);
            this._inputField.toolTipDelay = 0;
            this._inputField._Str_4074 = true;
            this._isHelpTextShowing = true;
            this._inputField.setTextFormat(this._helpTextFormat);
            this._lastContent = "";
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this.updatePosition);
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_ADDED, this.updatePosition);
            if ((((this._Str_20898() && (!this._widget.handler.container.roomSession.isGameSession)) && (!(this._widget.handler.container.freeFlowChat == null))) && (!(this._widget.handler.container.freeFlowChat.chatStyleLibrary == null))))
            {
                this.refreshChatStyles();
            }
            else
            {
                if (Std.is(this._chatInputContainerWindow.findChildByName("chat_input_container") , IItemListWindow))
                {
                    cast(this._chatInputContainerWindow.findChildByName("chat_input_container"), IItemListWindow).removeListItemAt(0);
                }
            }
            this.createAndAttachDimmerWindow();
            this._helpButton = cast(this._window.findChildByName("helpbutton"), ICloseButtonWindow);
            this._helpButton.addEventListener(WindowMouseEvent.CLICK, this._Str_8782);
            this._helpButton.addEventListener(WindowMouseEvent.OVER, this._Str_8782);
            this._helpButton.addEventListener(WindowMouseEvent.OUT, this._Str_8782);
            this._helpButton.visible = false;
            this.createHabbiconButton();
        }

        function createHabbiconButton()
        {
            if (this._chatInputContainerWindow == null || this._widget == null)
            {
                return;
            }
            this._habbiconButton = this._chatInputContainerWindow.findChildByName("chat_extra_button");
            if (this._habbiconButton == null)
            {
                return;
            }
            this._habbiconButton.visible = this._widget.handler.container.config.getBoolean("habbicons.enabled");
            if (!this._habbiconButton.visible)
            {
                return;
            }
            if (Std.is(this._habbiconButton , IInteractiveWindow))
            {
                cast(this._habbiconButton, IInteractiveWindow).toolTipCaption = this._widget.localizations.getLocalization("habbicons.selector.tooltip", "Habbicons");
            }
            this._habbiconButton.addEventListener(WindowMouseEvent.CLICK, this.onHabbiconButtonClicked);
            this.registerHabbiconButtonListeners();
            if (((HabbiconController.instance != null) && (!HabbiconController.instance.hasLoadedShopData)))
            {
                HabbiconController.instance.getShopData(false);
            }
            this.updateHabbiconButtonIcon();
        }

        function onHabbiconButtonClicked(event:WindowMouseEvent)
        {
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (HabbiconController.instance == null)
            {
                this._widget._Str_13265.context.createLinkEvent("habbicons/open");
                return;
            }
            try
            {
                if (this._habbiconSelector == null || this._habbiconSelector.disposed)
                {
                    this._habbiconSelector = new HabbiconSelector(this, this._habbiconButton, this._habbiconSelectorMenuContainer, HabbiconController.instance);
                }
                this._habbiconSelector.toggle();
            }
catch (__as3Caught:Dynamic) { var err:ASError = ASError.caught(__as3Caught);             {
                // Selector build/toggle failed; swallow to keep chat input responsive.
            }
 }        }

        function updateHabbiconButtonIcon()
        {
            var bitmapWindow:IBitmapWrapperWindow = null;
            var bitmap:BitmapData = null;
            var target:BitmapData = null;
            var collectionId = 0;
            if (this._chatInputContainerWindow == null)
            {
                return;
            }
            bitmapWindow = Std.downcast(this._chatInputContainerWindow.findChildByName("chat_extra_set_icon") , IBitmapWrapperWindow);
            if (bitmapWindow == null)
            {
                return;
            }
            collectionId = this.resolveHabbiconButtonCollectionId();
            if (collectionId <= 0)
            {
                bitmapWindow.visible = false;
                this.registerHabbiconAssetsListener();
                return;
            }
            bitmap = HabbiconAssetManager.getOutlinedCollectionIconBitmap(collectionId);
            if (bitmap == null)
            {
                bitmapWindow.visible = false;
                this.registerHabbiconAssetsListener();
                return;
            }
            target = new BitmapData(bitmap.width, bitmap.height, true, 0);
            target.copyPixels(bitmap, bitmap.rect, new Point(0, 0), null, null, true);
            bitmapWindow.bitmap = target;
            bitmapWindow.visible = true;
            bitmapWindow.invalidate();
        }

        function registerHabbiconButtonListeners()
        {
            if ((this._habbiconButtonListenersRegistered || (HabbiconController.instance == null)))
            {
                return;
            }
            HabbiconController.instance.addEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.addEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.addEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.addEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onHabbiconButtonDataUpdated);
            this._habbiconButtonListenersRegistered = true;
        }

        function unregisterHabbiconButtonListeners()
        {
            if (((!this._habbiconButtonListenersRegistered) || (HabbiconController.instance == null)))
            {
                this._habbiconButtonListenersRegistered = false;
                return;
            }
            HabbiconController.instance.removeEventListener(HabbiconControllerEvent.SHOP_DATA_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.removeEventListener(HabbiconControllerEvent.OWNED_HABBICONS_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.removeEventListener(HabbiconControllerEvent.RECENT_HABBICONS_UPDATED, this.onHabbiconButtonDataUpdated);
            HabbiconController.instance.removeEventListener(HabbiconControllerEvent.STATUS_CHANGED, this.onHabbiconButtonDataUpdated);
            this._habbiconButtonListenersRegistered = false;
        }

        function onHabbiconButtonDataUpdated(event:HabbiconControllerEvent)
        {
            this.updateHabbiconButtonIcon();
        }

        function resolveHabbiconButtonCollectionId():Int
        {
            var controller= HabbiconController.instance;
            var recent:Array<ASAny> = null;
            var habbiconId = 0;
            var collectionId = 0;
            if (((controller == null) || (!controller.hasLoadedShopData)))
            {
                return 0;
            }
            recent = controller.recentHabbiconIds;
            if (((recent != null) && (recent.length > 0)))
            {
                if (checkNullIteratee(recent)) for (_tmp_ in recent)
                {
habbiconId  = ASCompat.toInt(_tmp_);
                    collectionId = this.resolveCollectionIdForHabbicon(controller, habbiconId);
                    if (collectionId > 0)
                    {
                        return collectionId;
                    }
                }
            }
            return this.resolveDefaultHabbiconButtonCollectionId(controller);
        }

        function resolveCollectionIdForHabbicon(controller:HabbiconController, habbiconId:Int):Int
        {
            var item:HabbiconShopItem = null;
            var collection:HabbiconCollectionData = null;
            if (((controller == null) || (habbiconId <= 0)))
            {
                return 0;
            }
            item = controller.tryGetShopItem(habbiconId);
            if (((item != null) && (item.collectionId > 0)))
            {
                return item.collectionId;
            }
            final _iter_ = controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (((collection != null) && (collection.rewardHabbiconId == habbiconId)))
                {
                    return collection.collectionId;
                }
            }
            return 0;
        }

        function resolveDefaultHabbiconButtonCollectionId(controller:HabbiconController):Int
        {
            var collection:HabbiconCollectionData = null;
            if (controller == null)
            {
                return 0;
            }
            final _iter_ = controller.shopCollections; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
collection  = _tmp_;
                if (((collection != null) && (collection.collectionId > 0)))
                {
                    return collection.collectionId;
                }
            }
            return 0;
        }

        function registerHabbiconAssetsListener()
        {
            if (this._habbiconAssetsListenerRegistered)
            {
                return;
            }
            HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._habbiconAssetsListenerRegistered = true;
        }

        function unregisterHabbiconAssetsListener()
        {
            if (!this._habbiconAssetsListenerRegistered)
            {
                return;
            }
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._habbiconAssetsListenerRegistered = false;
        }

        function onHabbiconAssetsLoaded(event:Event)
        {
            this.unregisterHabbiconAssetsListener();
            this.updateHabbiconButtonIcon();
        }

        function _Str_23245(k:Array<ASAny>)
        {
            var _local_3 = 0;
            var _local_2 = 0;
            while (_local_2 < (k.length - 1))
            {
                _local_3 = (_local_2 + 1);
                while (_local_3 < k.length)
                {
                    if (k[_local_2] == k[_local_3])
                    {
                        k.splice(_local_3--, 1);
                    }
                    _local_3++;
                }
                _local_2++;
            }
        }

        public function refreshChatStyles()
        {
            var _local_2 = 0;
            var _local_3:IChatStyle = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = false;
            var k:Array<ASAny> = [];
            if (((((!this._Str_20898()) || this._widget.handler.container.roomSession.isGameSession) || (this._widget.handler.container.freeFlowChat == null)) || (this._widget.handler.container.freeFlowChat.chatStyleLibrary == null)))
            {
                return;
            }
            _local_4 = (cast this._widget._Str_13265.getProperty("disabled.custom.chat.styles").split(","));
            _local_5 = this._widget.handler.container.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE);
            final _iter_ = this._widget.handler.container.freeFlowChat.chatStyleLibrary.getStyleIds(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = ASCompat.toInt(_tmp_);
                _local_3 = this._widget.handler.container.freeFlowChat.chatStyleLibrary.getStyle(_local_2);
                if (((!_local_3.isSystemStyle) && (_local_4.indexOf(Std.string(_local_2)) == -1)))
                {
                    if (_local_3.purchasable)
                    {
                        if (this.sessionDataManager.hasPurchasableChatStyle(_local_2))
                        {
                            k.push(_local_2);
                        }
                    }
                    else
                    {
                        if ((_local_3.isHcOnly && (this._widget.handler.container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB)))
                        {
                            k.push(_local_2);
                        }
                        else
                        {
                            if ((((!_local_3.isHcOnly) && (!_local_3.isAmbassadorOnly)) && (!_local_3.isStaffOverrideable)))
                            {
                                k.push(_local_2);
                            }
                        }
                    }
                }
                if ((_local_3.isStaffOverrideable && _local_5))
                {
                    k.push(_local_2);
                }
                if ((_local_3.isAmbassadorOnly && (_local_5 || this._widget.handler.container.sessionDataManager.isAmbassador)))
                {
                    k.push(_local_2);
                }
            }
            this._Str_23245(k);
            var _local_6= (((this._chatStyleSelector != null) && (this._chatStyleSelectorMenuContainer != null)) && this._chatStyleSelectorMenuContainer.visible);
            if (this._chatStyleSelector != null)
            {
                this._chatStyleSelector.dispose();
                this._chatStyleSelector = null;
            }
            this._Str_24580(k);
            if ((_local_6 && (this._chatStyleSelector != null)))
            {
                this._chatStyleSelector.setMenuOpen(true);
            }
        }

        function _Str_20898():Bool
        {
            return this._widget._Str_13265.getBoolean("custom.chat.styles.enabled");
        }

        function createAndAttachDimmerWindow()
        {
            var k:IWindow = null;
            if (RoomEnterEffect.isRunning())
            {
                k = this._widget.windowManager.createWindow("chat_dimmer", "", WindowType.WINDOW_TYPE_BORDER, HabboWindowStyle.BLACK, ((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(0, 0, this._chatInputContainerWindow.width, this._chatInputContainerWindow.height), null, 0);
                k.color = 0;
                k.blend = 0.3;
                this._chatInputContainerWindow.addChild(k);
                this._chatInputContainerWindow.invalidate();
                if (this._removeDimmerTimer == null)
                {
                    this._removeDimmerTimer = new Timer(RoomEnterEffect.totalRunningTime, 1);
                    this._removeDimmerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                    this._removeDimmerTimer.start();
                }
            }
        }

        function onRemoveDimmer(k:TimerEvent)
        {
            this._removeDimmerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
            this._removeDimmerTimer = null;
            var _local_2= this._chatInputContainerWindow.findChildByName("chat_dimmer");
            if (_local_2 != null)
            {
                this._chatInputContainerWindow.removeChild(_local_2);
                this._widget.windowManager.destroy(_local_2);
            }
        }

        public function updatePosition(k:WindowEvent=null, _arg_2:Int=10000, _arg_3:Int=10000)
        {
            this._window.width = this._window.desktop.width;
            this._window.height = this._window.desktop.height;
            var _local_4= new Point();
            if (this._chatInputContainerWindow == null)
            {
                return;
            }
            var _local_5= this.widget._Str_26449();
            var _local_6= this.widget._Str_24691();
            var _local_7= Std.int((this._window.desktop.width / 2) - (this._chatInputContainerWindow.width / 2));
            var _local_8 = 0;
            var _local_9= (this._chatInputContainerWindow.width + _Str_10663);
            if (((this._window.desktop.width - _local_5) - _local_6) > _local_9)
            {
                _local_8 = (_local_5 + _Str_10663);
                this._chatInputContainerWindow.y = (this._window.desktop.height - 104);
                if ((_local_7 + this._chatInputContainerWindow.width) > (this._window.desktop.width - _local_6))
                {
                    _local_7 = 0;
                }
            }
            else
            {
                _local_8 = (this.widget._Str_22730() + _Str_10663);
                this._chatInputContainerWindow.y = (this._window.desktop.height - 160);
            }
            this._chatInputContainerWindow.x = Std.int(Math.max(_local_7, _local_8));
            if (this._chatStyleSelector != null)
            {
                this._chatStyleSelector._Str_19515();
            }
            if (this._habbiconSelector != null && !this._habbiconSelector.disposed)
            {
                this._habbiconSelector.hide();
            }
        }

        function _Str_25960(k:WindowMouseEvent)
        {
            if (!this._isHelpTextShowing)
            {
                this._Str_21815();
            }
        }

        public function _Str_22810()
        {
            this._inputField.visible = true;
            this._blockText.visible = false;
        }

        public function _Str_22358()
        {
            this._inputField.visible = false;
            this._blockText.visible = true;
        }

        public function _Str_22027(k:Int)
        {
            this._blockText.caption = this._widget.localizations.registerParameter("chat.input.alert.flood", "time", Std.string(k));
        }

        public function _Str_23022(k:String, _arg_2:String="")
        {
            if (((this._chatInputContainerWindow == null) || (this._inputField == null)))
            {
                return;
            }
            this._inputField.enable();
            this._inputField.selectable = true;
            this._inputField.text = "";
            this._Str_16838();
            this._inputField.text = (this._inputField.text + (k + " "));
            if (_arg_2.length > 0)
            {
                this._inputField.text = (this._inputField.text + (_arg_2 + " "));
            }
            this._inputField.setSelection(this._inputField.text.length, this._inputField.text.length);
            this._lastContent = this._inputField.text;
        }

        function _Str_22202(k:WindowEvent=null, _arg_2:IWindow=null)
        {
            this._Str_16838();
        }

        function _Str_10572(k:WindowEvent=null, _arg_2:IWindow=null)
        {
            var _local_3:UInt = 0;
            var _local_4 = false;
            var _local_5:WindowKeyboardEvent = null;
            var _local_6:KeyboardEvent = null;
            var _local_7:String = null;
            var _local_8:Array<ASAny> = null;
            if ((((this._chatInputContainerWindow == null) || (this._widget == null)) || this._widget._Str_21409))
            {
                return;
            }
            if (this._Str_25460())
            {
                return;
            }
            this._Str_16838();
            if (Std.is(k , WindowKeyboardEvent))
            {
                _local_5 = Std.downcast(k , WindowKeyboardEvent);
                _local_3 = _local_5.charCode;
                _local_4 = _local_5.shiftKey;
            }
            if (Std.is(k , KeyboardEvent))
            {
                _local_6 = ASCompat.reinterpretAs(k , KeyboardEvent);
                _local_3 = _local_6.charCode;
                _local_4 = _local_6.shiftKey;
            }
            if (((_local_6 == null) && (_local_5 == null)))
            {
                return;
            }
            if (_local_3 == Keyboard.SPACE)
            {
                this._Str_24578();
            }
            if (_local_3 == Keyboard.ENTER)
            {
                this._Str_21815(_local_4);
                this._Str_22035(true);
            }
            if (_local_3 == Keyboard.BACKSPACE)
            {
                if (this._inputField != null)
                {
                    _local_7 = this._inputField.text;
                    _local_8 = (cast _local_7.split(" "));
                    if ((((_local_8[0] == this._chatModeIdWhisper) && (_local_8.length == 3)) && (_local_8[2] == "")))
                    {
                        this._inputField.text = "";
                        this._lastContent = "";
                    }
                }
            }
        }

        function _Str_15516(k:WindowKeyboardEvent)
        {
            if (k.keyCode == Keyboard.ENTER)
            {
                this._Str_22035(false);
            }
        }

        function _Str_22035(k:Bool)
        {
        }

        function _Str_14673(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.window , ITextFieldWindow);
            if (_local_2 == null)
            {
                return;
            }
            this._idleTimer.reset();
            var _local_3:ASAny = (_local_2.text.length == 0);
            if (_local_3)
            {
                this._isTyping = false;
                this._typingTimer.start();
            }
            else
            {
                if (_local_2.text.length > (this._lastContent.length + 1))
                {
                    if (this._widget._Str_24849)
                    {
                        this._widget._Str_23495();
                    }
                    else
                    {
                        _local_2.text = "";
                    }
                }
                this._lastContent = _local_2.text;
                if (!this._isTyping)
                {
                    this._isTyping = true;
                    this._typingTimer.reset();
                    this._typingTimer.start();
                }
                this._idleTimer.start();
                if (this._nuxIdleTimer != null)
                {
                    this._nuxIdleTimer.reset();
                    this._nuxIdleTimer = null;
                }
            }
        }

        function _Str_24578()
        {
            if (((this._inputField == null) || (this._inputField.text == "")))
            {
                return;
            }
            var k= this._inputField.text;
            var _local_2= this._widget._Str_21568;
            if (k == this._chatModeIdWhisper)
            {
                if (_local_2.length > 0)
                {
                    this._inputField.text = (this._inputField.text + (" " + this._widget._Str_21568));
                    this._inputField.setSelection(this._inputField.text.length, this._inputField.text.length);
                    this._lastContent = this._inputField.text;
                }
            }
        }

        function _Str_20169(k:TimerEvent)
        {
            if (this._isTyping)
            {
                this._typingStartedSent = false;
            }
            this._isTyping = false;
            this._Str_17137();
        }

        function onNuxIdleTimerComplete(k:TimerEvent)
        {
            if (this._nuxIdleTimer != null)
            {
                this._nuxIdleTimer.reset();
                this._nuxIdleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onNuxIdleTimerComplete : ASAny));
                this._nuxIdleTimer = null;
            }
            this.highlightChatInput();
        }

        function _Str_20723(k:TimerEvent)
        {
            if (this._isTyping)
            {
                this._typingStartedSent = true;
            }
            this._Str_17137();
        }

        function _Str_17137()
        {
            if (this._widget == null)
            {
                return;
            }
            if (this._widget._Str_21409)
            {
                return;
            }
            var k= new RoomWidgetChatTypingMessage(this._isTyping);
            this._widget.messageListener.processWidgetMessage(k);
        }

        function highlightChatInput()
        {
            this._inputField.text = this.widget.localizations.getLocalization("widgets.chatinput.mode.remind.noobie");
            this._nuxChatReminderTimer = new Timer(500);
            this._nuxChatReminderTimer.addEventListener(TimerEvent.TIMER, (this._Str_20444 : ASAny));
            this._nuxChatReminderTimer.start();
            this.widget.windowManager.registerHintWindow("nux_chat_reminder", this._inputField);
            this.widget.windowManager.showHint("nux_chat_reminder");
        }

        function _Str_20444(k:TimerEvent)
        {
            this._chatReminderAnimationCounter++;
            if ((this._chatReminderAnimationCounter % 2) != 0)
            {
                this._widget.mainWindow.y--;
            }
            else
            {
                this._widget.mainWindow.y = (this._widget.mainWindow.y + 1);
            }
            if (this._chatReminderAnimationCounter >= 10)
            {
                this._nuxChatReminderTimer.reset();
                this._nuxChatReminderTimer = null;
                this._widget.mainWindow.y = 0;
                this._Str_21516();
            }
        }

        function _Str_21516()
        {
            this.widget.handler.container.config.setProperty("nux.chat.reminder.shown", "1");
            if (this._nuxChatReminderTimer != null)
            {
                this._nuxChatReminderTimer.reset();
            }
            this.widget.windowManager.hideHint();
            this.widget.windowManager.unregisterHintWindow("nux_chat_reminder");
        }

        function _Str_16838()
        {
            if (this._inputField == null)
            {
                return;
            }
            if (this._nuxChatReminderTimer != null)
            {
                this._Str_21516();
            }
            if (this._isHelpTextShowing)
            {
                this._inputField.text = "";
                this._inputField.textColor = 0;
                this._inputField.italic = false;
                this._isHelpTextShowing = false;
                this._lastContent = "";
            }
            this._inputField.focus();
        }

        public function _Str_24855(k:UInt)
        {
            if (this._inputField == null)
            {
                return;
            }
            this._inputField.textColor = k;
            this._inputField.defaultTextFormat.color = k;
        }

        function _Str_21815(k:Bool=false)
        {
            if (((this._inputField == null) || (this._inputField.text == "")))
            {
                return;
            }
            var _local_2= (k ? RoomWidgetChatMessage.CHAT_TYPE_SHOUT : RoomWidgetChatMessage.CHAT_TYPE_SPEAK);
            var _local_3= this._inputField.text;
            var _local_4:Array<ASAny> = (cast _local_3.split(" "));
            var _local_5= "";
            var _local_6= "";
            switch (_local_4[0])
            {
                case (_ == this._chatModeIdWhisper => true):
                    _local_2 = RoomWidgetChatMessage.CHAT_TYPE_WHISPER;
                    _local_5 = _local_4[1];
                    _local_6 = (((this._chatModeIdWhisper + " ") + _local_5) + " ");
                    _local_4.shift();
                    _local_4.shift();
                    
                case (_ == this._chatModeIdShout => true):
                    _local_2 = RoomWidgetChatMessage.CHAT_TYPE_SHOUT;
                    _local_4.shift();
                    
                case (_ == this._chatModeIdSpeak => true):
                    _local_2 = RoomWidgetChatMessage.CHAT_TYPE_SPEAK;
                    _local_4.shift();
                    

default:
            }
            _local_3 = _local_4.join(" ");
            var _local_7= SystemChatStyleEnum.NORMAL;
            if ((this._Str_20898() && (!(this._chatStyleSelector == null))))
            {
                _local_7 = this._chatStyleSelector._Str_22824;
            }
            if (this._widget != null)
            {
                if (this._typingTimer.running)
                {
                    this._typingTimer.reset();
                }
                if (this._idleTimer.running)
                {
                    this._idleTimer.reset();
                }
                this._widget._Str_25042(_local_3, _local_2, _local_5, _local_7);
                this._isTyping = false;
                if (this._typingStartedSent)
                {
                    this._Str_17137();
                }
                this._typingStartedSent = false;
            }
            if (this._inputField != null)
            {
                this._inputField.text = _local_6;
            }
            this._lastContent = _local_6;
        }

        function _Str_25460():Bool
        {
            var _local_2:Stage = null;
            var _local_3:InteractiveObject = null;
            if (this._inputField != null)
            {
                if (this._inputField.focused)
                {
                    return false;
                }
            }
            var k= this._chatInputContainerWindow.context.getDesktopWindow().getDisplayObject();
            if (k != null)
            {
                _local_2 = k.stage;
                if (_local_2 != null)
                {
                    _local_3 = _local_2.focus;
                    if (_local_3 == null)
                    {
                        return false;
                    }
                    if (Std.is(_local_3 , TextField))
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._widget.handler.container.sessionDataManager;
        }

        function _Str_24580(k:Array<ASAny>)
        {
            var _local_3 = 0;
            if (this._chatStyleSelector == null)
            {
                this._chatStyleSelector = new ChatStyleSelector(this, cast(this._chatInputContainerWindow.findChildByName("styles"), IWindowContainer), this.sessionDataManager);
                this._chatStyleSelector._Str_22746 = Std.int(Math.max(4, ((k.length / 6) + 1)));
            }
            var _local_2= (k.length - 1);
            while (_local_2 >= 0)
            {
                _local_3 = ASCompat.toInt(k[_local_2]);
                this._chatStyleSelector.addItem(_local_3, this._widget.handler.container.freeFlowChat.chatStyleLibrary.getStyle(_local_3).selectorPreview);
                _local_2--;
            }
            this._chatStyleSelector._Str_24820(this._widget.handler.container.freeFlowChat.preferedChatStyle);
        }

        public var widget(get,never):RoomChatInputWidget;
public function  get_widget():RoomChatInputWidget
        {
            return this._widget;
        }

        public var _Str_22667(get,never):IWindowContainer;
public function  get__Str_22667():IWindowContainer
        {
            return this._chatStyleSelectorMenuContainer;
        }

        public function getChatInputY():Int
        {
            if (((!(this._window != null)) || (!(this._window.findChildByName("chat_input_container") != null))))
            {
                return 0;
            }
            var k= new Point();
            this._window.findChildByName("chat_input_container").getGlobalPosition(k);
            return Std.int(k.y);
        }

        public function _Str_25675():Array<ASAny>
        {
            return [this._chatInputContainerWindow, this._inputField];
        }

        function _Str_8782(k:WindowMouseEvent)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._widget._Str_13265.context.createLinkEvent(_Str_16188);
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                this._helpButton.visible = true;
                this._mouseOverHelpButton = true;
                this._Str_13977();
            }
            else
            {
                if (k.type == WindowMouseEvent.OUT)
                {
                    this._mouseOverHelpButton = false;
                    this._Str_21882();
                }
            }
        }

        function _Str_6563(k:WindowMouseEvent)
        {
            if (k.type == WindowMouseEvent.OVER)
            {
                this._helpButton.visible = true;
                this._Str_13977();
            }
            else
            {
                if (((k.type == WindowMouseEvent.OUT) && (!this._mouseOverHelpButton)))
                {
                    this._Str_21882();
                }
            }
        }

        function _Str_21882()
        {
            if (this._helpButtonHideTimer != null)
            {
                this._Str_13977();
            }
            this._helpButtonHideTimer = new Timer(400);
            this._helpButtonHideTimer.addEventListener(TimerEvent.TIMER, (this._Str_22017 : ASAny));
            this._helpButtonHideTimer.start();
        }

        function _Str_22017(k:TimerEvent)
        {
            if (((!this._mouseOverHelpButton) && (this._helpButton != null)))
            {
                this._helpButton.visible = false;
            }
            this._Str_13977();
        }

        function _Str_13977()
        {
            if (this._helpButtonHideTimer == null)
            {
                return;
            }
            this._helpButtonHideTimer.stop();
            this._helpButtonHideTimer.removeEventListener(TimerEvent.TIMER, (this._Str_22017 : ASAny));
            this._helpButtonHideTimer = null;
        }
    }

