package com.sulake.habbo.friendbar.landingview
;
    import com.sulake.habbo.friendbar.view.AbstractView;
    import com.sulake.habbo.friendbar.IHabboLandingView;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetContainerLayout;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.avatar.IHabboAvatarEditor;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboQuestEngine;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboGameManager;
    import com.sulake.iid.IIDHabboAvatarEditor;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.toolbar.HabboToolbarEnum;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.gamecenter.GameCenterEvent;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.NavigatorSettingsEvent;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.communication.messages.outgoing.navigator.ForwardToARandomPromotedRoomMessageComposer;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.RequestABadgeComposer;
    import com.sulake.habbo.communication.messages.outgoing.landingview.votes.CommunityGoalVoteMessageComposer;
    import com.sulake.habbo.session.ISessionDataManager;

     class HabboLandingView extends AbstractView implements IHabboLandingView 
    {
        var _landingViewLayout:WidgetContainerLayout;
        var _communicationManager:IHabboCommunicationManager;
        var _roomSessionManager:IRoomSessionManager;
        var _catalog:IHabboCatalog;
        var _navigator:IHabboNavigator;
        var _questEngine:IHabboQuestEngine;
        var _toolbar:IHabboToolbar;
        var _habboHelp:IHabboHelp;
        var _avatarEditor:IHabboAvatarEditor;
        var _gameManager:IHabboGameManager;
        var _gameCenterOK:Bool = false;
        var _errorLayout:IWindow;
        var _roomEngine:IRoomEngine;
        var _isInitialized:Bool = false;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        public static function _Str_9079(k:IWindowContainer, _arg_2:String, _arg_3:String)
        {
            var _local_4= k.findChildByName(_arg_2);
            var _local_5= k.findChildByName(_arg_3);
            var _local_6= _local_5.x;
            _local_5.x = ((_local_4.x + _local_4.width) + 5);
            _local_5.width = (_local_5.width + (_local_6 - _local_5.x));
        }

        public static function _Str_14396(k:IBitmapWrapperWindow, _arg_2:BitmapData, _arg_3:Rectangle=null)
        {
            if (k.bitmap == null)
            {
                k.bitmap = new BitmapData(k.width, k.height, true, 0);
            }
            else
            {
                k.bitmap.fillRect(k.bitmap.rect, 0);
            }
            var _local_4= k.bitmap;
            var _local_5= ((_arg_3 != null) ? _arg_3 : _arg_2.rect);
            _local_4.copyPixels(_arg_2, _local_5, new Point(((_local_4.width - _local_5.width) / 2), ((_local_4.height - _local_5.height) / 2)), null, null, true);
            k.invalidate();
        }


        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._navigator;
        }

        public var questEngine(get,never):IHabboQuestEngine;
public function  get_questEngine():IHabboQuestEngine
        {
            return this._questEngine;
        }

        public var tracking(get,never):IHabboTracking;
public function  get_tracking():IHabboTracking
        {
            return _tracking;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return _windowManager;
        }

        public var communicationManager(get,never):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return _localizationManager;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), null), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboQuestEngine(), function (k:IHabboQuestEngine)
            {
                _questEngine = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            }), new ComponentDependency(new IIDHabboGameManager(), function (k:IHabboGameManager)
            {
                _gameManager = k;
            }, false), new ComponentDependency(new IIDHabboAvatarEditor(), function (k:IHabboAvatarEditor)
            {
                _avatarEditor = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            })]));
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._isInitialized = false;
                if (this._landingViewLayout != null)
                {
                    this._landingViewLayout.dispose();
                    this._landingViewLayout = null;
                }
                if (((!(this._toolbar == null)) && (!(this._toolbar.events == null))))
                {
                    this._toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
                }
                if (this._errorLayout != null)
                {
                    this._errorLayout.dispose();
                    this._errorLayout = null;
                }
                super.dispose();
            }
        }

        public function initialize()
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5:String = null;
            this._isInitialized = true;
            var k= _windowManager.getDesktop(0);
            var _local_2= k.getChildByName("hotel_view_welcome_window");
            if (_local_2 != null)
            {
                k.removeChild(_local_2);
                _local_2.dispose();
            }
            if ((this.newIdentity && getBoolean("landing.view.new_identity_override_enabled")))
            {
                _local_3 = (cast getProperty("landing.view.new_identity_widgets").split(","));
                _local_4 = 1;
                while (_local_4 <= 6)
                {
                    _local_5 = (("landing.view.dynamic.slot." + Std.string(_local_4)) + ".");
                    if (((_local_4 == 1) || (_local_4 == 6)))
                    {
                        setProperty((_local_5 + "widget"), "");
                    }
                    else
                    {
                        setProperty((_local_5 + "widget"), "widgetcontainer");
                        setProperty((_local_5 + "conf"), ("2001-01-01 00:00," + _local_3[(_local_4 - 2)]));
                    }
                    _local_4++;
                }
                setProperty("landing.view.dynamic.leftPaneWidth", "400");
                setProperty("landing.view.dynamic.rightPaneWidth", "400");
            }
            this._landingViewLayout = new WidgetContainerLayout(this);
            this.activate();
            if (this.isForwardingToGameCenter())
            {
                this.forwardToGameCenter();
            }
        }

        public function activate()
        {
            if (!this._isInitialized)
            {
                this.tryInitialize();
            }
            if (this._toolbar != null)
            {
                this._toolbar.updateVisibility(HabboToolbarEnum.HTE_STATE_HOTEL_VIEW);
            }
            if (this._landingViewLayout != null)
            {
                this._landingViewLayout.activate();
            }
            else
            {
                Logger.log(["ERROR - Landing view layout is not initialized and cannot be activated - See caught errors in tryInitialize()"]);
            }
        }

        public function disable()
        {
            if (this._landingViewLayout != null)
            {
                this._landingViewLayout.disable();
                this.toolbarExtensionExtraMargin = false;
            }
        }

        public var isLandingViewVisible(get,never):Bool;
public function  get_isLandingViewVisible():Bool
        {
            return ((!(this._landingViewLayout == null)) && (!(this._landingViewLayout.window == null))) && this._landingViewLayout.window.visible;
        }

        public function send(k:IMessageComposer)
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.connection.send(k);
            }
        }

        function onToolbarClick(k:HabboToolbarEvent)
        {
            switch (k.iconId)
            {
                case HabboToolbarIconEnum.RECEPTION:
                    if (this._roomSessionManager.getSession(-1) != null)
                    {
                        this.send(new QuitMessageComposer());
                        this._roomSessionManager.disposeSession(-1);
                    }
                    return;
                case HabboToolbarIconEnum.GAMES:
                    if (getBoolean("game.center.enabled"))
                    {
                        this.disable();
                    }
                    return;
            }
        }

        function onGameConfigurationsInitialized(k:GameCenterEvent)
        {
            if (!this._gameCenterOK)
            {
                this._gameCenterOK = true;
                this.tryInitialize();
            }
        }

        override function initComponent()
        {
            this._toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClick);
            this._catalog.events.addEventListener(CatalogEvent.CATALOG_INVISIBLE_PAGE_VISITED, this.onExpiredLinkCLick);
            if (this.isForwardingToGameCenter())
            {
                this._gameManager.events.addEventListener(GameCenterEvent.GAME_CONFIGURATIONS_INITIALIZED, this.onGameConfigurationsInitialized);
            }
            else
            {
                this._communicationManager.addHabboConnectionMessageEvent(new NavigatorSettingsEvent(this.onNavigatorSettings));
            }
        }

        function onExpiredLinkCLick(k:CatalogEvent)
        {
            if ((((this._isInitialized && (!(this._landingViewLayout == null))) && (!(this._landingViewLayout.window == null))) && this._landingViewLayout.window.visible))
            {
                this.activate();
            }
        }

        function onNavigatorSettings(k:NavigatorSettingsEvent)
        {
            if (k.getParser()._Str_17213 <= 0)
            {
                this.tryInitialize();
            }
        }

        function tryInitialize()
        {
            if (((!this.isForwardingToGameCenter()) || this._gameCenterOK))
            {
                this._errorLayout = this.getXmlWindow("initialization_error");
                this._errorLayout.visible = false;
                try
                {
                    this.initialize();
                    cast(this._errorLayout.parent, IWindowContainer).removeChild(this._errorLayout);
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    ErrorReportStorage.addDebugData("HabboLandingView", "Landing view layout initialization failed!");
                    _landingViewLayout.dispose();
                    _landingViewLayout = null;
                    windowManager.getDesktop(0).addChild(_errorLayout);
                    _errorLayout.center();
                    _errorLayout.visible = true;
                    context.root.error((e.message + " Landing view initialization failed because of a Flash Error. Landing view removed and disposed!"), false, e.errorID);
                }
 }            }
        }

        public function getXmlWindow(name:String, layer:UInt=1):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName((name + "_xml"));
                xmlAsset = cast(asset, XmlAsset);
                if (((asset == null) || (xmlAsset == null)))
                {
                    return null;
                }
                window = _windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content), layer);
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                ErrorReportStorage.addDebugData("HabboLandingView", (("Failed to build window " + name) + "_xml!"));
                throw e;
            }
 }            return window;
        }

        public function goToRoom(k:String=null)
        {
            if (k == null)
            {
                k = getProperty("landing.view.roomcategory");
            }
            if (k != null)
            {
                this.send(new ForwardToARandomPromotedRoomMessageComposer(k));
            }
        }

        public function getProductData(k:String, _arg_2:IProductDataListener):IProductData
        {
            if (_sessionDataManager.loadProductData(_arg_2))
            {
                return _sessionDataManager.getProductData(k);
            }
            return null;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public function openGameCenterByGameName(k:String)
        {
            if (this._gameManager != null)
            {
                this._gameManager.showGameCenterByGameName("showGameCenter.landingView", k);
                this.disable();
            }
        }

        public function openGameCenterByGameTypeId(k:Int)
        {
            if (this._gameManager != null)
            {
                this._gameManager.showGameCenter("showGameCenter.landingView", k);
                this.disable();
            }
        }

        public function openGameCenter()
        {
            if (this._gameManager != null)
            {
                this._gameManager.showGameCenter("showGameCenter.landingView");
                this.disable();
            }
        }

        public function requestBadge(k:String)
        {
            this.send(new RequestABadgeComposer(k));
        }

        public function communityGoalVote(k:Int)
        {
            this.send(new CommunityGoalVoteMessageComposer(k));
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return _sessionDataManager;
        }

        function isForwardingToGameCenter():Bool
        {
            return propertyExists("game.name");
        }

        function forwardToGameCenter()
        {
            var k:String = null;
            if (this._gameManager != null)
            {
                if (this.isForwardingToGameCenter())
                {
                    k = getProperty("game.name");
                    if ((ASCompat.stringAsBool(k) && (!(k == "default"))))
                    {
                        this._gameManager.showGameCenterByGameName("showGameCenter.gameCenterForward", k, (k == "elisa_habbo_stories"));
                    }
                    else
                    {
                        this._gameManager.showGameCenter("showGameCenter.gameCenterForward");
                    }
                }
            }
        }

        public var toolbarExtensionExtraMargin(never,set):Bool;
public function  set_toolbarExtensionExtraMargin(k:Bool):Bool        {
            if (((this._toolbar != null) && (this._toolbar.extensionView != null)))
            {
                this._toolbar.extensionView.extraMargin = (k ? HabboToolbarEnum._Str_18620 : 0);
            }
return k;
        }

        public var newIdentity(get,never):Bool;
public function  get_newIdentity():Bool
        {
            return getInteger("new.identity", 0) > 0;
        }

        public var dynamicLayoutLeftPaneWidth(get,never):Int;
public function  get_dynamicLayoutLeftPaneWidth():Int
        {
            return getInteger("landing.view.dynamic.leftPaneWidth", 500);
        }

        public var dynamicLayoutRightPaneWidth(get,never):Int;
public function  get_dynamicLayoutRightPaneWidth():Int
        {
            return getInteger("landing.view.dynamic.rightPaneWidth", 250);
        }

        public var avatarEditor(get,never):IHabboAvatarEditor;
public function  get_avatarEditor():IHabboAvatarEditor
        {
            return this._avatarEditor;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }
    }

