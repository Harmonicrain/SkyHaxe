package com.sulake.habbo.ui.widget.memenu
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.ui.handler.MeMenuWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.ui.widget.memenu.soundsettings.MeMenuSoundSettingsView;
    import com.sulake.habbo.ui.widget.memenu.chatsettings.MeMenuChatSettingsView;
    import flash.geom.Rectangle;
    import com.sulake.habbo.ui.widget.events._Str_4677;
    import com.sulake.habbo.ui.widget.events._Str_8449;
    import com.sulake.habbo.ui.widget.events._Str_9658;
    import com.sulake.habbo.ui.widget.events._Str_5638;
    import com.sulake.habbo.ui.widget.events._Str_9531;
    import com.sulake.habbo.ui.widget.events._Str_6051;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_5907;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_3963;
    import com.sulake.habbo.ui.widget.events._Str_3950;
    import com.sulake.habbo.ui.widget.events._Str_4656;
    import com.sulake.habbo.ui.widget.events._Str_3345;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMeMenuMessage;
    import com.sulake.habbo.utils._Str_3942;
    import flash.events.Event;

     class MeMenuWidget extends RoomWidgetBase
    {
        public static inline final ME_MENU_TOP_VIEW= "me_menu_top_view";
        public static inline final ME_MENU_MY_CLOTHES_VIEW= "me_menu_my_clothes_view";
        public static inline final ME_MENU_DANCE_MOVES_VIEW= "me_menu_dance_moves_view";
        public static inline final ME_MENU_SETTINGS_VIEW= "me_menu_settings_view";
        public static inline final ME_MENU_SOUND_SETTINGS= "me_menu_sound_settings";
        public static inline final ME_MENU_CHAT_SETTINGS= "me_menu_chat_settings";
        static final _Str_13955:Point = new Point(95, 440);

        var _currentView:IMeMenuView;
        var _mainWindow:IWindowContainer;
        var _habboClubDays:Int = 0;
        var _habboClubPeriods:Int = 0;
        var _habboClubPastPeriods:Int = 0;
        var _allowHabboClubDances:Bool = false;
        var _habboClubLevel:Int = 0;
        var _hasEffectOn:Bool = false;
        var _isDancing:Bool = false;
        var _isActive:Bool = false;
        var _isMinimailEnabled:Bool = false;
        var _creditBalance:Int = 0;
        var _isGameMode:Bool = false;
        var _config:IHabboConfigurationManager;
        var _userId:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._config = _arg_5;
            if (ExternalInterface.available)
            {
                this._isMinimailEnabled = _arg_5.getBoolean("client.minimail.embed.enabled");
            }
            Std.downcast(k , MeMenuWidgetHandler).widget = this;
            this._Str_4568(ME_MENU_TOP_VIEW);
            this.hide();
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this.hide();
            if (this._currentView != null)
            {
                this._currentView.dispose();
                this._currentView = null;
            }
            this._mainWindow = null;
            this._config = null;
            super.dispose();
        }

        public var handler(get,never):MeMenuWidgetHandler;
public function  get_handler():MeMenuWidgetHandler
        {
            return Std.downcast(_handler , MeMenuWidgetHandler);
        }

        override public function  get_mainWindow():IWindow
        {
            return this._mainWindow;
        }

        var mainContainer(get,never):IWindowContainer;
function  get_mainContainer():IWindowContainer
        {
            var k:IAsset = null;
            if (this._mainWindow == null)
            {
                k = _assets.getAssetByName("memenu");
                if (k != null)
                {
                    this._mainWindow = Std.downcast(windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
                }
            }
            if (this._mainWindow != null)
            {
                return Std.downcast(this._mainWindow.findChildByTag("MAIN_CONTENT") , IWindowContainer);
            }
            return null;
        }

        public function _Str_4568(k:String)
        {
            var _local_2:IMeMenuView = null;
            switch (k)
            {
                case ME_MENU_TOP_VIEW:
                    _local_2 = new MeMenuMainView(this.config);
                    
                case ME_MENU_DANCE_MOVES_VIEW:
                    _local_2 = new MeMenuDanceView();
                    
                case ME_MENU_SETTINGS_VIEW:
                    _local_2 = new MeMenuSettingsMenuView();
                    
                case ME_MENU_SOUND_SETTINGS:
                    _local_2 = new MeMenuSoundSettingsView();
                    
                case ME_MENU_CHAT_SETTINGS:
                    _local_2 = new MeMenuChatSettingsView();
                    
                default:
                    Logger.log([("Me Menu Change view: unknown view: " + k)]);
            }
            if (_local_2 != null)
            {
                if (this._currentView != null)
                {
                    this._currentView.dispose();
                    this._currentView = null;
                }
                this._currentView = _local_2;
                this._currentView.init(this, k);
                this.mainContainer.removeChildAt(0);
                this.mainContainer.addChildAt(this._currentView.window, 0);
                this._mainWindow.visible = true;
                this._mainWindow.activate();
            }
            this._Str_19324();
        }

        public function _Str_19324()
        {
            var k = 0;
            var _local_2:Rectangle = null;
            if ((((this._currentView != null) && (this._currentView.window != null)) && (this._mainWindow != null)))
            {
                k = 5;
                this._currentView.window.position = new Point(k, k);
                this.mainContainer.width = (this._currentView.window.width + (k * 2));
                this.mainContainer.height = (this._currentView.window.height + (k * 2));
                if ((((this._config.getBoolean("simple.memenu.enabled") && (this.handler != null)) && (this.handler.container != null)) && (this.handler.container.toolbar != null)))
                {
                    _local_2 = this.handler.container.toolbar.getRect();
                    this._mainWindow.x = Std.int(_local_2.right + k);
                    this._mainWindow.y = Std.int(_local_2.bottom - this._mainWindow.height);
                }
                else
                {
                    this._mainWindow.x = Std.int(_Str_13955.x);
                    this._mainWindow.y = Std.int(_Str_13955.y - this.mainContainer.height);
                }
            }
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4677.RWMMUE_NEW_MINI_MAIL, this._Str_7885);
            k.addEventListener(_Str_4677.RWMMUE_UNREAD_MINI_MAIL, this._Str_7885);
            k.addEventListener(_Str_8449.RWUE_WAVE, this._Str_21778);
            k.addEventListener(_Str_9658.RWUE_DANCE, this._Str_19233);
            k.addEventListener(_Str_5638.RWUEUE_UPDATE_EFFECTS, this._Str_19429);
            k.addEventListener(_Str_9531.RWUE_REQUEST_ME_MENU_TOOLBAR_CLICKED, this.onToolbarClicked);
            k.addEventListener(_Str_6051.RWUE_AVATAR_EDITOR_CLOSED, this._Str_21383);
            k.addEventListener(_Str_6051.RWUE_HIDE_AVATAR_EDITOR, this._Str_20360);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this._Str_21703);
            k.addEventListener(_Str_5907.RWBIUE_HABBO_CLUB, this._Str_20017);
            k.addEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.onUserInfo);
            k.addEventListener(_Str_3963.RWSUE_SETTINGS, this._Str_21972);
            k.addEventListener(_Str_3950.HHTPNUFWE_AE_STARTED, this._Str_14073);
            k.addEventListener(_Str_3950.HHTPNUFWE_AE_HIGHLIGHT, this._Str_14073);
            k.addEventListener(_Str_4656.RWPUE_CREDIT_BALANCE, this.onCreditBalance);
            k.addEventListener(_Str_3345.RWREUE_NORMAL_MODE, this._Str_21253);
            k.addEventListener(_Str_3345.RWREUE_GAME_MODE, this._Str_21709);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_8449.RWUE_WAVE, this._Str_21778);
            k.removeEventListener(_Str_9658.RWUE_DANCE, this._Str_19233);
            k.removeEventListener(_Str_5638.RWUEUE_UPDATE_EFFECTS, this._Str_19429);
            k.removeEventListener(_Str_9531.RWUE_REQUEST_ME_MENU_TOOLBAR_CLICKED, this.onToolbarClicked);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this._Str_21703);
            k.removeEventListener(_Str_5907.RWBIUE_HABBO_CLUB, this._Str_20017);
            k.removeEventListener(_Str_6051.RWUE_AVATAR_EDITOR_CLOSED, this._Str_20360);
            k.removeEventListener(_Str_6051.RWUE_HIDE_AVATAR_EDITOR, this._Str_21383);
            k.removeEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.onUserInfo);
            k.removeEventListener(_Str_3963.RWSUE_SETTINGS, this._Str_21972);
            k.removeEventListener(_Str_3950.HHTPNUFWE_AE_HIGHLIGHT, this._Str_14073);
            k.removeEventListener(_Str_3950.HHTPNUFWE_AE_STARTED, this._Str_14073);
            k.removeEventListener(_Str_4656.RWPUE_CREDIT_BALANCE, this.onCreditBalance);
            k.removeEventListener(_Str_3345.RWREUE_NORMAL_MODE, this._Str_21253);
            k.removeEventListener(_Str_3345.RWREUE_NORMAL_MODE, this._Str_21709);
        }

        public function hide(k:RoomWidgetRoomObjectUpdateEvent=null)
        {
            if (this._currentView != null)
            {
                this._mainWindow.removeChild(this._currentView.window);
                this._currentView.dispose();
                this._currentView = null;
            }
            this._mainWindow.visible = false;
            this._isActive = false;
        }

        function onUserInfo(k:RoomWidgetUserInfoUpdateEvent)
        {
            this._userId = k.id;
        }

        function _Str_21972(k:_Str_3963)
        {
            if (!this._isActive)
            {
                return;
            }
            if (this._currentView.window.name == ME_MENU_SOUND_SETTINGS)
            {
                Std.downcast(this._currentView , MeMenuSoundSettingsView)._Str_7269(k);
            }
        }

        function _Str_14073(k:_Str_3950)
        {
            switch (k.type)
            {
                case _Str_3950.HHTPNUFWE_AE_HIGHLIGHT:
                    Logger.log([((("* MeMenuWidget: onHighlightClothesIcon " + Std.string(this._isActive)) + " view: ") + this._currentView.window.name)]);
                    if (((!(this._isActive == true)) || (!(this._currentView.window.name == ME_MENU_TOP_VIEW))))
                    {
                        return;
                    }
                    Std.downcast(this._currentView , MeMenuMainView)._Str_25524("clothes_icon", ME_MENU_TOP_VIEW, "clothes_highlighter_blue");
                    return;
                case _Str_3950.HHTPNUFWE_AE_STARTED:
                    this.hide();
                    return;
            }
        }

        function onToolbarClicked(k:_Str_9531)
        {
            var _local_2:RoomWidgetMeMenuMessage = null;
            if (this._isActive)
            {
                if (((!(this._mainWindow == null)) && _Str_3942._Str_9211(this._mainWindow)))
                {
                    this._mainWindow.activate();
                    return;
                }
                this._isActive = false;
            }
            else
            {
                this._isActive = true;
            }
            if (this._isActive)
            {
                _local_2 = new RoomWidgetMeMenuMessage(RoomWidgetMeMenuMessage.RWMMM_MESSAGE_ME_MENU_OPENED);
                if (messageListener != null)
                {
                    messageListener.processWidgetMessage(_local_2);
                }
                this._Str_4568(ME_MENU_TOP_VIEW);
            }
            else
            {
                this.hide();
            }
        }

        function _Str_19429(k:_Str_5638)
        {
            var _local_2:IWidgetAvatarEffect = null;
            this._hasEffectOn = false;
            final _iter_ = k.effects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.isInUse)
                {
                    this._hasEffectOn = true;
                }
            }
        }

        function _Str_21703(k:Event)
        {
            if (((!(this._currentView == null)) && (!(this._currentView.window.name == ME_MENU_MY_CLOTHES_VIEW))))
            {
                this.hide();
            }
        }

        function _Str_21383(k:_Str_6051)
        {
            if (((!(this._currentView == null)) && (this._currentView.window.name == ME_MENU_MY_CLOTHES_VIEW)))
            {
                this._Str_4568(ME_MENU_TOP_VIEW);
            }
        }

        function _Str_20360(k:_Str_6051)
        {
            if (((!(this._currentView == null)) && (this._currentView.window.name == ME_MENU_MY_CLOTHES_VIEW)))
            {
                this._Str_4568(ME_MENU_TOP_VIEW);
            }
        }

        function _Str_21778(k:_Str_8449)
        {
            Logger.log(["[MeMenuWidget] Wave Event received"]);
        }

        function _Str_7885(k:_Str_4677)
        {
            if (this._currentView != null)
            {
                this._currentView._Str_6111(MeMenuMainView.MINIMAIL, this.handler.container.messenger.getUnseenMiniMailMessageCount());
            }
        }

        function _Str_19233(k:_Str_9658)
        {
            Logger.log([("[MeMenuWidget] Dance Event received, style: " + Std.string(k.style))]);
        }

        function _Str_20017(k:_Str_5907)
        {
            var _local_2:ASAny = (!(k._Str_19392 == this._habboClubDays));
            this._habboClubDays = k._Str_19392;
            this._habboClubPeriods = k._Str_23037;
            this._habboClubPastPeriods = k._Str_24579;
            this._allowHabboClubDances = k._Str_23338;
            _local_2 = (if (_local_2) _local_2; else (!(k.clubLevel == this._habboClubLevel)));
            this._habboClubLevel = k.clubLevel;
            if (_local_2)
            {
                if (this._currentView != null)
                {
                    this._Str_4568(this._currentView.window.name);
                }
            }
        }

        function onCreditBalance(k:_Str_4656)
        {
            if (k == null)
            {
                return;
            }
            this._creditBalance = k.balance;
            localizations.registerParameter("widget.memenu.credits", "credits", Std.string(this._creditBalance));
        }

        function _Str_21253(k:_Str_3345)
        {
            this._isGameMode = false;
        }

        function _Str_21709(k:_Str_3345)
        {
            this._isGameMode = true;
        }

        public var _Str_24765(get,never):Bool;
public function  get__Str_24765():Bool
        {
            return this._allowHabboClubDances;
        }

        public var _Str_22242(get,never):Bool;
public function  get__Str_22242():Bool
        {
            return this._habboClubDays > 0;
        }

        public var _Str_22596(get,never):Int;
public function  get__Str_22596():Int
        {
            return this._habboClubDays;
        }

        public var _Str_21813(get,never):Int;
public function  get__Str_21813():Int
        {
            return this._habboClubPeriods;
        }

        public var _Str_21502(get,never):Int;
public function  get__Str_21502():Int
        {
            return this._habboClubLevel;
        }

        public var _Str_16873(get,never):Bool;
public function  get__Str_16873():Bool
        {
            return this._isMinimailEnabled;
        }

        public var config(get,never):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._config;
        }

        public var hasEffectOn(get,never):Bool;
public function  get_hasEffectOn():Bool
        {
            return this._hasEffectOn;
        }

        
        public var isDancing(get,set):Bool;
public function  get_isDancing():Bool
        {
            return this._isDancing;
        }
public function  set_isDancing(k:Bool):Bool        {
            return this._isDancing = k;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var _Str_21527(get,never):Int;
public function  get__Str_21527():Int
        {
            return this.handler.container.messenger.getUnseenMiniMailMessageCount();
        }
    }

