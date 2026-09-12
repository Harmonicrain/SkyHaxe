package com.sulake.habbo.toolbar
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.toolbar.extensions.PurseAreaExtension;
    import com.sulake.habbo.toolbar.extensions.GamehallLeaderboardPromptExtension;
    import com.sulake.habbo.toolbar.extensions.SettingsExtension;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.toolbar.extensions.purse.indicators.SeasonalCurrencyIndicator;
    import com.sulake.habbo.toolbar.extensions.ClubDiscountPromoExtension;
    import com.sulake.habbo.toolbar.extensions.CitizenshipVipQuestsPromoExtension;
    import com.sulake.habbo.toolbar.extensions.CitizenshipVipDiscountPromoExtension;
    import com.sulake.habbo.toolbar.extensions.VideoOfferExtension;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.toolbar.offers.OfferExtension;
    import flash.utils.Timer;
    import com.sulake.habbo.phonenumber.HabboPhoneNumber;
    import com.sulake.iid.IIDHabboPhoneNumber;
    import com.sulake.habbo.nux.HabboNuxDialogs;
    import com.sulake.iid.IIDHabboNuxDialogs;
    import com.sulake.habbo.campaign.HabboCampaigns;
    import com.sulake.iid.IIDHabboCampaigns;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import flash.events.Event;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.iid.IIDCoreLocalizationManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.habbo.inventory.events.HabboUnseenItemsUpdatedEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboFreeFlowChat;
    import com.sulake.iid.IIDHabboRoomUI;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboQuestEngine;
    import com.sulake.habbo.quest.events.UnseenAchievementsCountUpdateEvent;
    import com.sulake.habbo.quest.events.UnseenRewardTrackRewardsCountUpdateEvent;
    import com.sulake.iid.IIDHabboMessenger;
    import com.sulake.habbo.messenger.events.MiniMailMessageEvent;
    import com.sulake.iid.IIDHabboGroupForumController;
    import com.sulake.habbo.friendbar.groupforums.UnseenForumsCountUpdatedEvent;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboNewNavigator;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.help._enum.WelcomeNotificationAlignment;
    import com.sulake.room.utils.RoomEnterEffect;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.purse.PurseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;

     class HabboToolbar extends Component implements IHabboToolbar 
    {
        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _view:BottomBarLeft;
        var _bottomBarBackground:BottomBackgroundBorder;
        var _isInitialized:Bool = false;
        var _purseExtension:PurseAreaExtension;
        var _settingsExtension:SettingsExtension;
        var _connection:IConnection;
        var _catalog:IHabboCatalog;
        var _messenger:IHabboMessenger;
        var _navigator:IHabboNavigator;
        var _newNavigator:IHabboNewNavigator;
        var _seasonalCurrencyExtension:SeasonalCurrencyIndicator;
        var _clubDiscountPromoExtension:ClubDiscountPromoExtension;
        var _citizenShipVipQuestsPromo:CitizenshipVipQuestsPromoExtension;
        var _citizenshipVipExtendPromo:CitizenshipVipDiscountPromoExtension;
        var _videoOfferExtension:VideoOfferExtension;
        var _localization:ICoreLocalizationManager;
        var _inventory:IHabboInventory;
        var _extensionView:ExtensionView;
        var _gamehallLeaderboardPromptExtension:GamehallLeaderboardPromptExtension;
        var _soundManager:IHabboSoundManager;
        var _sessionDataManager:ISessionDataManager;
        var _habboHelp:IHabboHelp;
        var _avatarRenderManager:IAvatarRenderManager;
        var _questEngine:IHabboQuestEngine;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _roomUI:IRoomUI;
        var _offerExtension:OfferExtension;
        var _removeDimmerTimer:Timer;
        var _clientPromoTimer:Timer;
        var _ownRoomPromoTimer:Timer;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            k.attachComponent(new HabboPhoneNumber(k, 0, _arg_3), [new IIDHabboPhoneNumber()]);
            k.attachComponent(new HabboNuxDialogs(k, 0, _arg_3), [new IIDHabboNuxDialogs()]);
            k.attachComponent(new HabboCampaigns(k, 0, _arg_3), [new IIDHabboCampaigns()]);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboConfigurationManager(), null, true, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }]), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }, true), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, true, [{
                "type":CatalogEvent.CATALOG_INITIALIZED,
                "callback":this.onCatalogEvent
            }, {
                "type":CatalogEvent.CATALOG_NOT_READY,
                "callback":this.onCatalogEvent
            }, {
                "type":CatalogEvent.CATALOG_NEW_ITEMS_SHOW,
                "callback":this.onCatalogEvent
            }, {
                "type":CatalogEvent.CATALOG_NEW_ITEMS_HIDE,
                "callback":this.onCatalogEvent
            }]), new ComponentDependency(new IIDCoreLocalizationManager(), function (k:ICoreLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboInventory(), function (k:IHabboInventory)
            {
                _inventory = k;
            }, false, [{
                "type":HabboUnseenItemsUpdatedEvent.HUIUE_UNSEEN_ITEMS_CHANGED,
                "callback":this._Str_19761
            }, {
                "type":HabboInventoryHabboClubEvent.HIHCE_HABBO_CLUB_CHANGED,
                "callback":this._Str_5219
            }]), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, true, [{
                "type":PerksUpdatedEvent.PERKS_UPDATED,
                "callback":this.onPerksUpdated
            }]), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            }, false), new ComponentDependency(new IIDHabboFreeFlowChat(), function (k:IHabboFreeFlowChat)
            {
                _freeFlowChat = k;
            }, false), new ComponentDependency(new IIDHabboRoomUI(), function (k:IRoomUI)
            {
                _roomUI = k;
            }, false), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }, false), new ComponentDependency(new IIDHabboQuestEngine(), function (k:IHabboQuestEngine)
            {
                _questEngine = k;
            }, false, [{
                "type":UnseenAchievementsCountUpdateEvent.QE_UACUE,
                "callback":this._Str_22354
            }, {
                "type":UnseenRewardTrackRewardsCountUpdateEvent.UNSEEN_REWARD_TRACK_REWARDS_COUNT_UPDATE,
                "callback":this.onUnseenRewardTrackRewardsCount
            }]), new ComponentDependency(new IIDHabboMessenger(), function (k:IHabboMessenger)
            {
                _messenger = k;
            }, false, [{
                "type":MiniMailMessageEvent.MMME_NEW,
                "callback":this._Str_7885
            }, {
                "type":MiniMailMessageEvent.MMME_UNREAD,
                "callback":this._Str_7885
            }, {
                "type":HabboUnseenItemsUpdatedEvent.HUIUE_UNSEEN_ITEMS_CHANGED,
                "callback":this._Str_19761
            }]), new ComponentDependency(new IIDHabboGroupForumController(), null, false, [{
                "type":UnseenForumsCountUpdatedEvent.UNSEEN_FORUMS_COUNT,
                "callback":this._Str_25396
            }]), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }, false), new ComponentDependency(new IIDHabboNewNavigator(), function (k:IHabboNewNavigator)
            {
                _newNavigator = k;
            }, false)]));
        }

        override public function dispose()
        {
            this._isInitialized = false;
            this._connection = null;
            this._Str_19382();
            this._Str_20582();
            this._Str_21196();
            if (this._extensionView != null)
            {
                if (this._gamehallLeaderboardPromptExtension != null)
                {
                    this._gamehallLeaderboardPromptExtension.dispose();
                    this._gamehallLeaderboardPromptExtension = null;
                }
                this._extensionView.dispose();
                this._extensionView = null;
            }
            if (this._purseExtension != null)
            {
                this._purseExtension.dispose();
                this._purseExtension = null;
            }
            if (this._settingsExtension != null)
            {
                this._settingsExtension.dispose();
                this._settingsExtension = null;
            }
            if (this._offerExtension != null)
            {
                this._offerExtension.dispose();
                this._offerExtension = null;
            }
            if (this._clubDiscountPromoExtension != null)
            {
                this._clubDiscountPromoExtension.dispose();
                this._clubDiscountPromoExtension = null;
            }
            if (this._citizenShipVipQuestsPromo != null)
            {
                this._citizenShipVipQuestsPromo.dispose();
                this._citizenShipVipQuestsPromo = null;
            }
            if (this._citizenshipVipExtendPromo != null)
            {
                this._citizenshipVipExtendPromo.dispose();
                this._citizenshipVipExtendPromo = null;
            }
            if (this._videoOfferExtension != null)
            {
                this._videoOfferExtension.dispose();
                this._videoOfferExtension = null;
            }
            if (this._messenger != null)
            {
                if (this._messenger.events != null)
                {
                    this._messenger.events.removeEventListener(MiniMailMessageEvent.MMME_NEW, this._Str_7885);
                    this._messenger.events.removeEventListener(MiniMailMessageEvent.MMME_UNREAD, this._Str_7885);
                }
                this._messenger = null;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            super.dispose();
        }

        function onConfigurationComplete(k:Event)
        {
        }

        override function initComponent()
        {
            var _local_2 = 0;
            var _local_3 = 0;
            this._connection = this._communicationManager.connection;
            this._communicationManager.addHabboConnectionMessageEvent(new UserRightsMessageEvent(this.onUserRights));
            this._bottomBarBackground = new BottomBackgroundBorder(this);
            this._view = new BottomBarLeft(this, this._windowManager, assets, events);
            this._view.window.visible = false;
            this.initRoomEnterEffect();
            this._extensionView = new ExtensionView(this._windowManager, assets, this);
            this._gamehallLeaderboardPromptExtension = new GamehallLeaderboardPromptExtension(this);
            if (this._view == null)
            {
                Logger.log(["Error, toolbar view was not available"]);
                return;
            }
            var k= getProperty("new.user.wing");
            if (k != "")
            {
                _local_2 = (getInteger("new.user.promo.delay", 10) * 1000);
                if (((_local_2 > 0) && (this._clientPromoTimer == null)))
                {
                    this._clientPromoTimer = new Timer(_local_2, 1);
                    this._clientPromoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowClientPromo : ASAny));
                    this._clientPromoTimer.start();
                }
                if (((((k == WingCodeEnum.SOCIAL) || (k == WingCodeEnum.QUEST)) || (k == WingCodeEnum.GROUP)) || (k == WingCodeEnum.GAME)))
                {
                    _local_3 = (getInteger("new.user.promo.room.delay", 180) * 1000);
                    if (((_local_3 > 0) && (this._ownRoomPromoTimer == null)))
                    {
                        this._ownRoomPromoTimer = new Timer(_local_3, 1);
                        this._ownRoomPromoTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowOwnRoomPromo : ASAny));
                        this._ownRoomPromoTimer.start();
                    }
                }
            }
        }

        function onPerksUpdated(k:PerksUpdatedEvent)
        {
            if (((this._extensionView != null) && (!this._isInitialized)))
            {
                this._Str_24103();
                this._Str_23508();
                this._Str_23365();
                this._Str_23455();
                this._Str_23061();
                this._Str_19309();
                this._Str_25525();
                this._Str_23362();
                this._isInitialized = true;
            }
        }

        function onCatalogEvent(k:CatalogEvent)
        {
            if (this._view != null)
            {
                this._view.onCatalogEvent(k);
            }
        }

        function onUserRights(k:IMessageEvent)
        {
            if (this._videoOfferExtension == null)
            {
                this._Str_19309();
            }
        }

        function onShowClientPromo(k:TimerEvent)
        {
            var _local_3:String = null;
            var _local_4:String = null;
            this._Str_19382();
            var _local_2= getProperty("new.user.wing");
            var _local_5= WelcomeNotificationAlignment.LEFT;
            var _local_6:String = null;
            switch (_local_2)
            {
                case WingCodeEnum.SOCIAL:
                    _local_3 = "new.user.promo.social";
                    _local_4 = HabboToolbarIconEnum.NAVIGATOR;
                    _local_6 = "NAVIGATOR";
                    
                case WingCodeEnum.GROUP:
                    _local_3 = "new.user.promo.group";
                    _local_4 = HabboToolbarIconEnum.EXT_GROUP;
                    _local_5 = WelcomeNotificationAlignment.RIGHT;
                    
                case WingCodeEnum.QUEST:
                    _local_3 = "new.user.promo.quest";
                    _local_4 = HabboToolbarIconEnum.QUESTS;
                    _local_6 = "QUESTS";
                    
                case WingCodeEnum.GAME:
                    _local_3 = "new.user.promo.game";
                    _local_4 = HabboToolbarIconEnum.GAMES;
                    _local_6 = "GAMES";
                    
                default:
                    return;
            }
            if (this.getIconLocation(_local_4) != null)
            {
                this._habboHelp.showWelcomeScreen(_local_4, _local_3, _local_5, _local_6);
            }
        }

        function onShowOwnRoomPromo(k:TimerEvent)
        {
            this._Str_21196();
            this._habboHelp.showWelcomeScreen(HabboToolbarIconEnum.NAVIGATOR, "new.user.promo.room", WelcomeNotificationAlignment.LEFT, "NAVIGATOR_ME_TAB");
        }

        function initRoomEnterEffect()
        {
            var k = 0;
            var _local_2 = 0;
            if (!this.isNewIdentity())
            {
                return;
            }
            if (getBoolean("room.enter.effect.enabled"))
            {
                k = getInteger("room.enter.effect.delay", 4000);
                _local_2 = getInteger("room.enter.effect.duration", 2000);
                RoomEnterEffect.init(k, _local_2);
                this.createAndAttachDimmerWindow(cast(this._view.window, IWindowContainer));
                if (this._removeDimmerTimer == null)
                {
                    this._removeDimmerTimer = new Timer((k + _local_2), 1);
                    this._removeDimmerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                    this._removeDimmerTimer.start();
                }
            }
        }

        function _Str_24103()
        {
            this._purseExtension = new PurseAreaExtension(this, this._catalog);
            this._purseExtension._Str_20225()._Str_5219();
        }

        function _Str_23362()
        {
            this._settingsExtension = new SettingsExtension(this);
        }

        function _Str_23508()
        {
var i = 0;            var k:PurseEvent = null;
			if (getBoolean("seasonalcurrencyindicator.enabled"))
			{
i= getInteger("seasonalcurrencyindicator.currency", 1);
				this._seasonalCurrencyExtension = new SeasonalCurrencyIndicator(this, this._windowManager, assets, this._catalog, this._localization, i);
				k = new PurseEvent(PurseEvent.CATALOG_PURSE_ACTIVITY_POINT_BALANCE, this._catalog.getPurse().getActivityPointsForType(i), i);
				this._seasonalCurrencyExtension._Str_21326(k);
			}
        }

        function _Str_23365()
        {
            if (getBoolean("club.membership.extend.vip.promotion.enabled"))
            {
                this._clubDiscountPromoExtension = new ClubDiscountPromoExtension(this);
            }
        }

        function _Str_23061()
        {
            if (getBoolean("citizenship.vip.quest.promotion.enabled"))
            {
                this._citizenShipVipQuestsPromo = new CitizenshipVipQuestsPromoExtension(this, this._windowManager, assets, events, this._localization, this._connection);
            }
        }

        function _Str_23455()
        {
            if (getBoolean("club.membership.extend.vip.promotion.enabled"))
            {
                this._citizenshipVipExtendPromo = new CitizenshipVipDiscountPromoExtension(this);
            }
        }

        function _Str_19309()
        {
            var k= ((!this.isNewIdentity()) || (!getBoolean("new.identity.hide.ui")));
            if (((this._catalog.videoOffers.enabled && getBoolean("toolbar.extension.video.promo.enabled")) && k))
            {
                this._videoOfferExtension = new VideoOfferExtension(this);
            }
        }

        function _Str_25525()
        {
            var k= ((!this.isNewIdentity()) || (!getBoolean("new.identity.hide.ui")));
            if (((getBoolean("offers.enabled") && k) && (!getBoolean("offers.habboclub.enabled"))))
            {
                this._offerExtension = new OfferExtension(this, this._windowManager, assets, this._catalog);
            }
        }

        public function _Str_14261()
        {
            if (((this._settingsExtension != null) && (this._settingsExtension.window != null)))
            {
                this._settingsExtension.window.visible = (!this._settingsExtension.window.visible);
            }
            this.extensionView.refreshItemWindow();
        }

        function onRemoveDimmer(k:TimerEvent)
        {
            this._Str_20582();
            if (this._view != null)
            {
                this.removeDimmer(Std.downcast(this._view.window , IWindowContainer));
            }
            if (this._extensionView != null)
            {
                this._extensionView._Str_22962();
            }
        }

        public function createAndAttachDimmerWindow(k:IWindowContainer)
        {
            var _local_2:IWindow = null;
            if (RoomEnterEffect.isRunning())
            {
                if (k == null)
                {
                    return;
                }
                _local_2 = this._windowManager.createWindow(ToolbarDisplayExtensionIds.TOOLBAR_DIMMER, "", WindowType.WINDOW_TYPE_BORDER, HabboWindowStyle.BLACK, ((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_STRETCH )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_STRETCH)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(0, 0, k.width, k.height), null, 0);
                _local_2.color = 0;
                _local_2.blend = 0.3;
                k.addChild(_local_2);
                k.invalidate();
            }
        }

        public function removeDimmer(k:IWindowContainer)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= k.findChildByName("toolbar_dimmer");
            if (_local_2 != null)
            {
                k.removeChild(_local_2);
                k.invalidate();
                this._windowManager.destroy(_local_2);
            }
        }

        public function toggleWindowVisibility(k:String)
        {
            var _local_4:HabboToolbarEvent = null;
            var _local_5:HabboToolbarEvent = null;
            var _local_2:String = (HabboToolbarIconEnum : ASAny)[k];
            if (_local_2 == HabboToolbarIconEnum.CAMERA)
            {
                _local_4 = new HabboToolbarEvent(HabboToolbarEvent.HTE_ICON_CAMERA);
                _local_4.iconName = HabboToolbarEvent.TOOLBARCAMERAICON;
                events.dispatchEvent(_local_4);
            }
			else if (_local_2 == HabboToolbarIconEnum.MODTOOL)
			{
                _local_4 = new HabboToolbarEvent(HabboToolbarEvent.ICON_MODTOOL);
                events.dispatchEvent(_local_4);
			}
            else
            {
                _local_5 = new HabboToolbarEvent(HabboToolbarEvent.HTE_TOOLBAR_CLICK);
                _local_5.iconId = _local_2;
                _local_5.iconName = k;
                events.dispatchEvent(_local_5);
            }
            var _local_3= new EventLogMessageComposer("Toolbar", k, "client.toolbar.clicked");
            if (this._connection != null)
            {
                this._connection.send(_local_3);
            }
        }

        public function getIconLocation(k:String):Rectangle
        {
            var _local_2:Rectangle = null;
            if (k == HabboToolbarIconEnum.EXT_GROUP)
            {
                _local_2 = this._extensionView.getIconLocation(k);
            }
            else
            {
                if (this._view != null)
                {
                    _local_2 = this._view.getIconLocation(k);
                }
            }
            if (((!(_local_2 != null)) && (this._purseExtension != null)))
            {
                _local_2 = this._purseExtension.getIconLocation(k);
            }
            return _local_2;
        }

        public function _Str_6621(k:String):IWindow
        {
            var _local_2:IWindow = null;
            if (k == HabboToolbarIconEnum.EXT_GROUP)
            {
                _local_2 = this._extensionView._Str_6621(k);
            }
            else
            {
                if (this._view != null)
                {
                    _local_2 = this._view._Str_24110(k);
                    if ((Std.downcast(_local_2 , IStaticBitmapWrapperWindow) != null))
                    {
                        _local_2 = _local_2.parent;
                    }
                }
            }
            if (((!(_local_2 != null)) && (this._purseExtension != null)))
            {
                _local_2 = this._purseExtension._Str_6621(k);
            }
            return _local_2;
        }

        public function _Str_4168(k:String, _arg_2:Int)
        {
            if (this._view != null)
            {
                this._view._Str_4168(k, _arg_2);
            }
        }

        public function updateVisibility(k:String)
        {
            switch (k)
            {
                case HabboToolbarEnum.HTE_STATE_HOTEL_VIEW
                   | HabboToolbarEnum.HTE_STATE_GAME_CENTER_VIEW:
                    this.visible(true);
                    
                case HabboToolbarEnum.HTE_STATE_ROOM_VIEW:
                    this.visible(true);
                    
                case HabboToolbarEnum.HTE_STATE_HIDDEN:
                    this.visible(false);
                    
            }
            if (this._extensionView != null)
            {
                this._extensionView.landingView = (k == HabboToolbarEnum.HTE_STATE_HOTEL_VIEW);
            }
            if (this._view != null)
            {
                this._view.updateVisibility(k);
                this._view.window.visible = true;
            }
            if (this._habboHelp != null)
            {
                this._habboHelp.outsideRoom = (!(k == HabboToolbarEnum.HTE_STATE_ROOM_VIEW));
            }
            var _local_2= new HabboToolbarEvent(HabboToolbarEvent.HTE_RESIZED);
            events.dispatchEvent(_local_2);
        }

        function visible(k:Bool)
        {
            if (this._extensionView != null)
            {
                this._extensionView.visible = k;
            }
        }

        public function setAssetUri(k:String, _arg_2:BitmapData)
        {
            /*var _local_3:BitmapData;
            if (_arg_2 != null)
            {
                _local_3 = _arg_2.clone();
            };*/
            if (this._view != null)
            {
                this._view.setAssetUri(k, _arg_2);
            }
        }

        public function getRect():Rectangle
        {
            if (this._view != null)
            {
                return this._view.window.rectangle;
            }
            return new Rectangle();
        }

        public var extensionView(get,never):IExtensionView;
public function  get_extensionView():IExtensionView
        {
            return this._extensionView;
        }

        public var soundManager(get,never):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }

        public function createTransitionToIcon(k:String, _arg_2:BitmapData, _arg_3:Int, _arg_4:Int):Motion
        {
            if (((this._view != null) && (!this._view.disposed)))
            {
                return this._view._Str_21423(k, _arg_2, _arg_3, _arg_4);
            }
            _arg_2.dispose();
            return null;
        }

        public function _Str_24996():Bool
        {
            return getBoolean("xmas11.enabled");
        }

        public function _Str_23298():Bool
        {
            return getBoolean("valentines.enabled");
        }

        public function isNewIdentity():Bool
        {
            return getInteger("new.identity", 0) > 0;
        }

        public function setIconVisibility(k:String, _arg_2:Bool)
        {
            if (this._view != null)
            {
                this._view._Str_4600(k, _arg_2);
            }
        }

        function _Str_20582()
        {
            if (this._removeDimmerTimer != null)
            {
                this._removeDimmerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRemoveDimmer : ASAny));
                this._removeDimmerTimer.stop();
                this._removeDimmerTimer = null;
            }
        }

        function _Str_19382()
        {
            if (this._clientPromoTimer != null)
            {
                this._clientPromoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowClientPromo : ASAny));
                this._clientPromoTimer.stop();
                this._clientPromoTimer = null;
            }
        }

        function _Str_21196()
        {
            if (this._ownRoomPromoTimer != null)
            {
                this._ownRoomPromoTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onShowOwnRoomPromo : ASAny));
                this._ownRoomPromoTimer.stop();
                this._ownRoomPromoTimer = null;
            }
        }

        function _Str_7885(k:MiniMailMessageEvent)
        {
            if (((!(this._messenger != null)) || (!(this._view != null))))
            {
                return;
            }
            if (this._view != null)
            {
                this._view._Str_16525 = this._messenger.getUnseenMiniMailMessageCount();
                this._view.memenu._Str_25841 = this._messenger.getUnseenMiniMailMessageCount();
                this._Str_4168(HabboToolbarIconEnum.MEMENU, this._view._Str_16152);
            }
        }

        function _Str_22354(k:UnseenAchievementsCountUpdateEvent)
        {
            if (this._view != null)
            {
                this._view._Str_17961 = k.count;
                this._view.memenu._Str_23581 = k.count;
                this._Str_4168(HabboToolbarIconEnum.MEMENU, this._view._Str_16152);
            }
        }

        function onUnseenRewardTrackRewardsCount(k:UnseenRewardTrackRewardsCountUpdateEvent)
        {
            if (this._view != null)
            {
                this._Str_4168(HabboToolbarIconEnum.PROGRESSION, k.count);
            }
        }

        function _Str_25396(k:UnseenForumsCountUpdatedEvent)
        {
            if (this._view != null)
            {
                this._view._Str_9691 = k._Str_9691;
                this._view.memenu._Str_9691 = k._Str_9691;
                this._Str_4168(HabboToolbarIconEnum.MEMENU, this._view._Str_16152);
            }
        }

        public var onDuty(never,set):Bool;
public function  set_onDuty(k:Bool):Bool        {
            if (this._view != null)
            {
                this._view.onDuty = k;
            }
return k;
        }

        function _Str_19761(k:HabboUnseenItemsUpdatedEvent)
        {
            this._Str_4168(HabboToolbarIconEnum.INVENTORY, k._Str_13996);
            this._Str_4168(HabboToolbarIconEnum.GAMES, k._Str_25582(UnseenItemCategoryEnum.GAMES));
        }

        public function _Str_5219(k:HabboInventoryHabboClubEvent)
        {
            if (this._purseExtension != null)
            {
                this._purseExtension._Str_20225()._Str_5219(k);
            }
            if (this._citizenshipVipExtendPromo != null)
            {
                this._citizenshipVipExtendPromo._Str_5219(k);
            }
            if (this._videoOfferExtension != null)
            {
                this._videoOfferExtension._Str_5219(k);
            }
            if (this._clubDiscountPromoExtension != null)
            {
                this._clubDiscountPromoExtension._Str_5219(k);
            }
        }

        public var toolBarAreaWidth(get,never):Int;
public function  get_toolBarAreaWidth():Int
        {
            if (this._view != null)
            {
                return this._view._Str_22465();
            }
            return 0;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var communicationManager(get,never):IHabboCommunicationManager;
public function  get_communicationManager():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._connection;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            if (((this._newNavigator != null) && this.isNewNavigatorActive))
            {
                return this._newNavigator.legacyNavigator;
            }
            return this._navigator;
        }

        public var isNewNavigatorActive(get,never):Bool;
public function  get_isNewNavigatorActive():Bool
        {
            return ((this._sessionDataManager != null) && this._sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014));
        }

        public var questEngine(get,never):IHabboQuestEngine;
public function  get_questEngine():IHabboQuestEngine
        {
            return this._questEngine;
        }

        public var freeFlowChat(get,never):IHabboFreeFlowChat;
public function  get_freeFlowChat():IHabboFreeFlowChat
        {
            return this._freeFlowChat;
        }

        public var _Str_12052(get,never):IRoomUI;
public function  get__Str_12052():IRoomUI
        {
            return this._roomUI;
        }

        public var inventory(get,never):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return this._inventory;
        }

        public var localization(get,never):ICoreLocalizationManager;
public function  get_localization():ICoreLocalizationManager
        {
            return this._localization;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var messenger(get,never):IHabboMessenger;
public function  get_messenger():IHabboMessenger
        {
            return this._messenger;
        }

        public function openNewNavigator()
        {
            if (((this._newNavigator != null) && this.isNewNavigatorActive))
            {
                this._newNavigator.open();
            }
        }
    }

