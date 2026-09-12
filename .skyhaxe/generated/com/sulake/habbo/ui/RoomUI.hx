package com.sulake.habbo.ui
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
	import com.sulake.habbo.ui.IRoomWidgetFactory;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.groups.IHabboGroupsManager;
    import com.sulake.habbo.avatar.IHabboAvatarEditor;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.advertisement.IAdManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.messenger.IHabboMessenger;
    import com.sulake.habbo.moderation.IHabboModeration;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.game.IHabboGameManager;
    import com.sulake.habbo.friendbar.IHabboFriendBar;
    import com.sulake.habbo.friendbar.view.IHabboFriendBarView;
    import com.sulake.habbo.friendbar.IHabboLandingView;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.habbo.roomevents.IHabboUserDefinedRoomEvents;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.RoomWidgetFactory;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import com.sulake.habbo.room.events.RoomEngineDimmerStateEvent;
    import com.sulake.habbo.room.events.RoomBackgroundColorEvent;
    import com.sulake.habbo.room.events.RoomZoomEvent;
    import com.sulake.habbo.room.events.RoomObjectHSLColorEnabledEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineAreaHideStateWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineGamehallEvent;
    import com.sulake.habbo.room.events.RoomEngineLeaderboardEvent;
    import com.sulake.habbo.room.events.RoomEngineRoomAdEvent;
    import com.sulake.habbo.room.events.RoomEngineUseProductEvent;
    import com.sulake.habbo.room.events.RoomObjectSoundMachineEvent;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import com.sulake.habbo.session.events.RoomSessionUserBadgesEvent;
    import com.sulake.habbo.session.events.RoomSessionDoorbellEvent;
    import com.sulake.habbo.session.events.RoomSessionPresentEvent;
    import com.sulake.habbo.session.events.RoomSessionPetPackageEvent;
    import com.sulake.habbo.session.events.RoomSessionErrorMessageEvent;
    import com.sulake.habbo.session.events.RoomSessionQueueEvent;
    import com.sulake.habbo.session.events.RoomSessionPollEvent;
    import com.sulake.habbo.session.events.RoomSessionWordQuizEvent;
    import com.sulake.habbo.session.events.RoomSessionDimmerPresetsEvent;
    import com.sulake.habbo.session.events.RoomSessionFriendRequestEvent;
    import com.sulake.habbo.session.events.RoomSessionUserDataUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionDanceEvent;
    import com.sulake.habbo.session.events.SessionDataToWidgetEvent;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboNewNavigator;
    import com.sulake.iid.IIDHabboGroupsManager;
    import com.sulake.iid.IIDHabboAvatarEditor;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboAdManager;
    import com.sulake.habbo.advertisement.events.InterstitialEvent;
    import com.sulake.habbo.advertisement.events.AdEvent;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.iid.IIDHabboModeration;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboUserDefinedRoomEvents;
    import com.sulake.iid.IIDHabboTracking;
    import com.sulake.iid.IIDHabboGameManager;
    import com.sulake.habbo.game.events.GameChatEvent;
    import com.sulake.iid.IIDHabboFriendBar;
    import com.sulake.iid.IIDHabboFriendBarView;
    import com.sulake.habbo.friendbar.events.FriendBarResizeEvent;
    import com.sulake.iid.IIDHabboLandingView;
    import com.sulake.iid.IIDHabboQuestEngine;
    import com.sulake.iid.IIDHabboMessenger;
    import com.sulake.iid.IIDHabboFreeFlowChat;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.habbo.toolbar.HabboToolbarEnum;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomSettingsData;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.advertisement.InterstitialShownMessageComposer;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetChangePostureMessage;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.widget.events._Str_9973;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.ui.widget.enums.AvatarExpressionEnum;
    import com.sulake.room.utils.RoomId;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import flash.events.Event;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.habbo.ui.widget.events.HideRoomWidgetEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;
	import com.sulake.habbo.session.events.RoomSessionVoteEvent;

     class RoomUI extends Component implements IRoomUI implements  IUpdateReceiver 
    {
        var _windowManager:IHabboWindowManager;
        var _roomEngine:IRoomEngine;
        var _roomSessionManager:IRoomSessionManager;
        var _roomWidgetFactory:IRoomWidgetFactory;
        var _sessionDataManager:ISessionDataManager;
        var _friendList:IHabboFriendsList;
        var _avatarRenderManager:IAvatarRenderManager;
        var _inventory:IHabboInventory;
        var _toolbar:IHabboToolbar;
        var _navigator:IHabboNavigator;
        var _newNavigator:IHabboNewNavigator;
        var _habboGroupsManager:IHabboGroupsManager;
        var _avatarEditor:IHabboAvatarEditor;
        var _catalog:IHabboCatalog;
        var _adManager:IAdManager;
        var _localization:IHabboLocalizationManager;
        var _habboHelp:IHabboHelp;
        var _messenger:IHabboMessenger;
        var _moderation:IHabboModeration;
        var _soundManager:IHabboSoundManager;
        var _gameManager:IHabboGameManager;
        var _friendBar:IHabboFriendBar;
        var _friendBarView:IHabboFriendBarView;
        var _landingView:IHabboLandingView;
        var _questEngine:IHabboQuestEngine;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _communication:IHabboCommunicationManager;
        var _desktops:Map;
        var _userChooserState:Int = 0;
        var _interstitialActive:Bool = false;
        var _interstitialRoomId:Int = 0;
        var _habboTracking:IHabboTracking;
        var _userDefinedRoomEvents:IHabboUserDefinedRoomEvents;
        var _wasFreeFlowChatPerkAllowedAtInitialize:Bool = false;
        var _isInRoom:Bool = false;
        var _perkAllowancesMessageEvent:IMessageEvent;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._userChooserState = RoomDesktop.STATE_UNDEFINED;
            super(k, _arg_2, _arg_3);
            this._roomWidgetFactory = new RoomWidgetFactory(this);
            this._desktops = new Map();
            registerUpdateReceiver(this, 0);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, true, [{
                "type":RoomEngineEvent.ENGINE_INITIALIZED,
                "callback":this.roomEngineEventHandler
            }, {
                "type":RoomEngineEvent.INITIALIZED,
                "callback":this.roomEventHandler
            }, {
                "type":RoomEngineEvent.OBJECTS_INITIALIZED,
                "callback":this.roomEngineEventHandler
            }, {
                "type":RoomEngineEvent.DISPOSED,
                "callback":this.roomEventHandler
            }, {
                "type":RoomEngineEvent.NORMAL_MODE,
                "callback":this.roomEngineEventHandler
            }, {
                "type":RoomEngineEvent.GAME_MODE,
                "callback":this.roomEngineEventHandler
            }, {
                "type":RoomEngineDimmerStateEvent.REDSE_ROOM_COLOR,
                "callback":this.roomEventHandler
            }, {
                "type":RoomBackgroundColorEvent.ROOM_COLOR,
                "callback":this.roomEventHandler
            }, {
                "type":RoomZoomEvent.ROOM_ZOOM,
                "callback":this.roomEventHandler
            }, {
                "type":RoomObjectHSLColorEnabledEvent.ROOM_BACKGROUND_COLOR,
                "callback":this.roomEventHandler
            }, {
                "type":RoomEngineObjectEvent.SELECTED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.DESELECTED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.ADDED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.REMOVED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.PLACED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.REQUEST_MOVE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.REQUEST_ROTATE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.MOUSE_ENTER,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineObjectEvent.MOUSE_LEAVE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.OPEN_WIDGET,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.CLOSE_WIDGET,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_OPEN_FURNI_CONTEXT_MENU,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_CLOSE_FURNI_CONTEXT_MENU,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_CREDITFURNI,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_STICKIE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PRESENT,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_TROPHY,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_TEASER,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ECOTRONBOX,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PLACEHOLDER,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_DIMMER,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineRoomAdEvent.FURNI_CLICK,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineRoomAdEvent.FURNI_DOUBLE_CLICK,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineRoomAdEvent.TOOLTIP_SHOW,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineRoomAdEvent.TOOLTIP_HIDE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REMOVE_DIMMER,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_CLOTHING_CHANGE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_PLAYLIST_EDITOR,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MANNEQUIN,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BACKGROUND_COLOR,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_ROOM,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomObjectSoundMachineEvent.JUKEBOX_DISPOSE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_ENGRAVING,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BADGE_DISPLAY_ENGRAVING,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ACHIEVEMENT_RESOLUTION_FAILED,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIGH_SCORE_DISPLAY,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_HIDE_HIGH_SCORE_DISPLAY,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineGamehallEvent.OPEN,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineGamehallEvent.UPDATE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineGamehallEvent.CLOSE,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineLeaderboardEvent.OPEN,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_INTERNAL_LINK,
                "callback":this.roomObjectEventHandler
            }, {
                "type":RoomEngineTriggerWidgetEvent.RETWE_REQUEST_ROOM_LINK,
                "callback":this.roomObjectEventHandler
            }]), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, true, [{
                "type":RoomSessionEvent.CREATED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.STARTED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionEvent.ROOM_DATA,
                "callback":this.roomSessionStateEventHandler
            }, {
                "type":RoomSessionChatEvent.RSCE_CHAT_EVENT,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionChatEvent.RSCE_FLOOD_EVENT,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionUserBadgesEvent.RSUBE_BADGES,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionDoorbellEvent.RSDE_DOORBELL,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionDoorbellEvent.REJECTED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionDoorbellEvent.RSDE_ACCEPTED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPresentEvent.RSPE_PRESENT_OPENED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_REQUESTED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_RESULT,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_KICKED,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_PETS_FORBIDDEN_IN_HOTEL,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_PETS_FORBIDDEN_IN_FLAT,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_MAX_PETS,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_MAX_NUMBER_OF_OWN_PETS,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_NO_FREE_TILES_FOR_PET,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_SELECTED_TILE_NOT_FREE_FOR_PET,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_BOTS_FORBIDDEN_IN_HOTEL,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_BOTS_FORBIDDEN_IN_FLAT,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_BOT_LIMIT_REACHED,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_SELECTED_TILE_NOT_FREE_FOR_BOT,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionErrorMessageEvent.RSEME_BOT_NAME_NOT_ACCEPTED,
                "callback":this.roomSessionDialogEventHandler
            }, {
                "type":RoomSessionQueueEvent.RSQE_QUEUE_STATUS,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPollEvent.RSPE_POLL_CONTENT,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPollEvent.ERROR,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionPollEvent.RSPE_POLL_OFFER,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionWordQuizEvent.RWPUW_QUESTION_ANSWERED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionWordQuizEvent.RWPUW_QUESION_FINSIHED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionWordQuizEvent.RWPUW_NEW_QUESTION,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionDimmerPresetsEvent.RSDPE_PRESETS,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionFriendRequestEvent.RSFRE_FRIEND_REQUEST,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionVoteEvent.VOTE_QUESTION,
                "callback":this.roomSessionEventHandler
            },  {
                "type":RoomSessionVoteEvent.VOTE_RESULT,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionUserDataUpdateEvent.RSUDUE_USER_DATA_UPDATED,
                "callback":this.roomSessionEventHandler
            }, {
                "type":RoomSessionDanceEvent.RSDE_DANCE,
                "callback":this.roomSessionEventHandler
            }]), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }, true, [{
                "type":SessionDataToWidgetEvent.PURCHASABLE_STYLES_UPDATED,
                "callback":this.sessionDataEventHandler
            }]), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendList = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }), new ComponentDependency(new IIDHabboInventory(), function (k:IHabboInventory)
            {
                _inventory = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboNewNavigator(), function (k:IHabboNewNavigator)
            {
                _newNavigator = k;
            }), new ComponentDependency(new IIDHabboGroupsManager(), function (k:IHabboGroupsManager)
            {
                _habboGroupsManager = k;
            }), new ComponentDependency(new IIDHabboAvatarEditor(), function (k:IHabboAvatarEditor)
            {
                _avatarEditor = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDHabboAdManager(), function (k:IAdManager)
            {
                _adManager = k;
            }, true, [{
                "type":InterstitialEvent.INTERSTITIAL_NOT_SHOWN,
                "callback":this.interstitialNotAvailableEventHandler
            }, {
                "type":InterstitialEvent.INTERSTITIAL_COMPLETE,
                "callback":this.interstitialCompleteEventHandler
            }, {
                "type":InterstitialEvent.INTERSTITIAL_SHOW,
                "callback":this.interstitialShowEventHandler
            }, {
                "type":AdEvent.ROOM_AD_SHOW,
                "callback":this.adEventHandler
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            }), new ComponentDependency(new IIDHabboModeration(), function (k:IHabboModeration)
            {
                _moderation = k;
            }), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDHabboUserDefinedRoomEvents(), function (k:IHabboUserDefinedRoomEvents)
            {
                _userDefinedRoomEvents = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _habboTracking = k;
            }), new ComponentDependency(new IIDHabboGameManager(), function (k:IHabboGameManager)
            {
                _gameManager = k;
            }, true, [{
                "type":GameChatEvent.GCE_GAME_CHAT,
                "callback":this.gameEventHandler
            }]), new ComponentDependency(new IIDHabboFriendBar(), function (k:IHabboFriendBar)
            {
                _friendBar = k;
            }), new ComponentDependency(new IIDHabboFriendBarView(), function (k:IHabboFriendBarView)
            {
                _friendBarView = k;
            }, true, [{
                "type":FriendBarResizeEvent.FBE_BAR_RESIZE_EVENT,
                "callback":this.bottomBarResizeHandler
            }]), new ComponentDependency(new IIDHabboLandingView(), function (k:IHabboLandingView)
            {
                _landingView = k;
            }), new ComponentDependency(new IIDHabboQuestEngine(), function (k:IHabboQuestEngine)
            {
                _questEngine = k;
            }), new ComponentDependency(new IIDHabboMessenger(), function (k:IHabboMessenger)
            {
                _messenger = k;
            }), new ComponentDependency(new IIDHabboFreeFlowChat(), function (k:IHabboFreeFlowChat)
            {
                _freeFlowChat = k;
            })]));
        }

        override function initComponent()
        {
            this._perkAllowancesMessageEvent = this._communication.addHabboConnectionMessageEvent(new PerkAllowancesEvent(this.onPerkAllowances));
        }

        override public function dispose()
        {
            var k:String = null;
            var _local_2:RoomDesktop = null;
            if (disposed)
            {
                return;
            }
            if (this._roomWidgetFactory != null)
            {
                this._roomWidgetFactory.dispose();
                this._roomWidgetFactory = null;
            }
            if (this._communication != null)
            {
                this._communication.removeHabboConnectionMessageEvent(this._perkAllowancesMessageEvent);
                this._perkAllowancesMessageEvent = null;
            }
            if (this._desktops != null)
            {
                while (this._desktops.length > 0)
                {
                    k = ASCompat.asString(this._desktops.getKey(0) );
                    _local_2 = ASCompat.dynamicAs(this._desktops.remove(k) , RoomDesktop);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                }
                this._desktops.dispose();
                this._desktops = null;
            }
            removeUpdateReceiver(this);
            super.dispose();
        }

        function roomSessionStateEventHandler(k:RoomSessionEvent)
        {
            if (this._roomEngine == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionEvent.CREATED:
                    this.createDesktop(k.session);
                    if (k.session.isGameSession)
                    {
                        if (this._toolbar != null)
                        {
                            this._toolbar.updateVisibility(HabboToolbarEnum.HTE_STATE_HIDDEN);
                        }
                        if (this._friendBar != null)
                        {
                            this._friendBar.visible = false;
                        }
                        if (this._landingView != null)
                        {
                            this._landingView.disable();
                        }
                        if (this._gameManager != null)
                        {
                            this._gameManager._Str_15814();
                        }
                    }
                    return;
                case RoomSessionEvent.STARTED:
                    if (this._toolbar != null)
                    {
                        this.defineToolbarState(k.session);
                    }
                    if (this._landingView != null)
                    {
                        this._landingView.disable();
                    }
                    if (this._gameManager != null)
                    {
                        this._gameManager._Str_15814();
                    }
                    return;
                case RoomSessionEvent.ROOM_DATA:
                    this.defineToolbarState(k.session);
                    return;
                case RoomSessionEvent.ENDED:
                    if (k.session != null)
                    {
                        this.disposeDesktop(this.getRoomIdentifier(k.session.roomId));
                        if (k.session.isGameSession)
                        {
                            this._friendBar.visible = true;
                            if (this._gameManager != null)
                            {
                                this._gameManager._SafeStr_7621();
                            }
                        }
                        else
                        {
                            if (k.openLandingPage)
                            {
                                if ((getBoolean("nux.lobbies.enabled") && this._sessionDataManager.isRealNoob))
                                {
                                    if (((this._navigator.enteredGuestRoomData != null) && (this._navigator.enteredGuestRoomData.doorMode == RoomSettingsData.DOORMODE_NOOBS_ONLY)))
                                    {
                                        this._navigator.goToHomeRoom();
                                    }
                                    else
                                    {
                                        context.createLinkEvent("navigator/goto/predefined_noob_lobby");
                                    }
                                }
                                else
                                {
                                    if (this._landingView != null)
                                    {
                                        this._landingView.activate();
                                    }
                                }
                            }
                        }
                    }
                    return;
            }
        }

        function defineToolbarState(k:IRoomSession)
        {
            if ((getBoolean("nux.lobbies.enabled") && this._sessionDataManager.isRealNoob))
            {
                if (((k != null) && k.isNoobRoom))
                {
                    this._toolbar.updateVisibility(HabboToolbarEnum.HTE_STATE_NOOB_NOT_HOME);
                }
                else
                {
                    this._toolbar.updateVisibility(HabboToolbarEnum.HETE_STATE_NOOB_HOME);
                }
            }
            else
            {
                this._toolbar.updateVisibility(HabboToolbarEnum.HTE_STATE_ROOM_VIEW);
            }
        }

        function roomSessionEventHandler(k:RoomSessionEvent)
        {
            var _local_2:String = null;
            var _local_3:IRoomDesktop = null;
            if (this._roomEngine == null)
            {
                return;
            }
            if (k.session != null)
            {
                _local_2 = this.getRoomIdentifier(k.session.roomId);
                _local_3 = this.getDesktop(_local_2);
                if (_local_3 != null)
                {
                    _local_3.processEvent(k);
                }
            }
        }

        function sessionDataEventHandler(k:Event)
        {
            var _local_2:RoomDesktop = null;
            if (((this._roomEngine == null) || (this._desktops == null)))
            {
                return;
            }
            _local_2 = ASCompat.dynamicAs(this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            if (_local_2 != null)
            {
                _local_2.processEvent(k);
            }
        }

        function roomSessionDialogEventHandler(event:RoomSessionEvent)
        {
            var errorMessage:String = null;
            var errorTitle= "${error.title}";
            switch (event.type)
            {
                case RoomSessionErrorMessageEvent.RSEME_MAX_PETS:
                    errorMessage = "${room.error.max_pets}";
                    
                case RoomSessionErrorMessageEvent.RSEME_MAX_NUMBER_OF_OWN_PETS:
                    errorMessage = "${room.error.max_own_pets}";
                    
                case RoomSessionErrorMessageEvent.RSEME_KICKED:
                    errorMessage = "${room.error.kicked}";
                    errorTitle = "${generic.alert.title}";
                    
                case RoomSessionErrorMessageEvent.RSEME_PETS_FORBIDDEN_IN_HOTEL:
                    errorMessage = "${room.error.pets.forbidden_in_hotel}";
                    
                case RoomSessionErrorMessageEvent.RSEME_PETS_FORBIDDEN_IN_FLAT:
                    errorMessage = "${room.error.pets.forbidden_in_flat}";
                    
                case RoomSessionErrorMessageEvent.RSEME_NO_FREE_TILES_FOR_PET:
                    errorMessage = "${room.error.pets.no_free_tiles}";
                    
                case RoomSessionErrorMessageEvent.RSEME_SELECTED_TILE_NOT_FREE_FOR_PET:
                    errorMessage = "${room.error.pets.selected_tile_not_free}";
                    
                case RoomSessionErrorMessageEvent.RSEME_BOTS_FORBIDDEN_IN_HOTEL:
                    errorMessage = "${room.error.bots.forbidden_in_hotel}";
                    
                case RoomSessionErrorMessageEvent.RSEME_BOTS_FORBIDDEN_IN_FLAT:
                    errorMessage = "${room.error.bots.forbidden_in_flat}";
                    
                case RoomSessionErrorMessageEvent.RSEME_BOT_LIMIT_REACHED:
                    errorMessage = "${room.error.max_bots}";
                    
                case RoomSessionErrorMessageEvent.RSEME_SELECTED_TILE_NOT_FREE_FOR_BOT:
                    errorMessage = "${room.error.bots.selected_tile_not_free}";
                    
                case RoomSessionErrorMessageEvent.RSEME_BOT_NAME_NOT_ACCEPTED:
                    errorMessage = "${room.error.bots.name.not.accepted}";
                    
                default:
                    return;
            }
            this._windowManager.alert(errorTitle, errorMessage, 0, function (k:com.sulake.habbo.window.utils.IAlertDialog, _arg_2:com.sulake.core.window.events.WindowEvent)
            {
                k.dispose();
            });
        }

        function interstitialShowEventHandler(k:InterstitialEvent)
        {
            var _local_2= this.getRoomIdentifier(this._interstitialRoomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                _local_3.processEvent(k);
            }
            this._interstitialActive = true;
        }

        public function triggerbottomBarResize()
        {
            this.bottomBarResizeHandler(new FriendBarResizeEvent());
        }

        function bottomBarResizeHandler(k:FriendBarResizeEvent)
        {
            var _local_2= this.getRoomIdentifier(this._roomEngine.activeRoomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                _local_3.processEvent(k);
            }
        }

        function interstitialNotAvailableEventHandler(k:InterstitialEvent)
        {
            this._interstitialActive = false;
        }

        function interstitialCompleteEventHandler(k:InterstitialEvent)
        {
            var _local_4:IRoomSession = null;
            this._interstitialActive = false;
            if (k.status == "complete")
            {
                this._communication.connection.send(new InterstitialShownMessageComposer());
            }
            var _local_2= this.getRoomIdentifier(this._interstitialRoomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                _local_3.processEvent(k);
                _local_4 = this._roomSessionManager.getSession(this._roomEngine.activeRoomId);
                if (_local_4 != null)
                {
                    _local_4.sendChangePostureMessage(RoomWidgetChangePostureMessage._Str_1553);
                }
            }
        }

        function adEventHandler(k:AdEvent)
        {
            var _local_2= this.getRoomIdentifier(k.roomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                _local_3.processEvent(k);
            }
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2:Timer = null;
            var _local_3:String = null;
            var _local_4:RoomDesktop = null;
            if (((((this._freeFlowChat != null) && (!this._freeFlowChat.isDisabledInPreferences)) && this._isInRoom) && (!this._wasFreeFlowChatPerkAllowedAtInitialize)))
            {
                _local_2 = new Timer(250, 1);
                _local_2.addEventListener(TimerEvent.TIMER_COMPLETE, (this.delayedAddToStageFreeFlowChat : ASAny));
                _local_2.start();
            }
            if (this._isInRoom)
            {
                _local_3 = this.getRoomIdentifier(this._roomEngine.activeRoomId);
                _local_4 = Std.downcast(this.getDesktop(_local_3) , RoomDesktop);
                if (_local_4 != null)
                {
                    _local_4.processEvent(new _Str_9973(k.getParser().isPerkAllowed(PerkEnum.MOUSE_ZOOM)));
                }
            }
        }

        function delayedAddToStageFreeFlowChat(k:TimerEvent)
        {
            var _local_2= Std.downcast(this.getDesktop(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            if (((_local_2 != null) && (this._freeFlowChat.displayObject != null)))
            {
                _local_2.layoutManager.getChatContainer().setDisplayObject(this._freeFlowChat.displayObject);
                this._wasFreeFlowChatPerkAllowedAtInitialize = true;
            }
        }

        function roomEngineEventHandler(k:RoomEngineEvent)
        {
            var _local_2:String = null;
            var _local_3:RoomDesktop = null;
            var _local_4:IRoomSession = null;
            if (((k.type == RoomEngineEvent.GAME_MODE) || (k.type == RoomEngineEvent.NORMAL_MODE)))
            {
                _local_2 = this.getRoomIdentifier(k.roomId);
                _local_3 = Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
                if (_local_3 != null)
                {
                    _local_3.roomEngineEventHandler(k);
                }
            }
            if (k.roomId == this._interstitialRoomId)
            {
                if (k.type == RoomEngineEvent.OBJECTS_INITIALIZED)
                {
                    if (this._interstitialActive == true)
                    {
                        _local_4 = this._roomSessionManager.getSession(this._interstitialRoomId);
                        if (_local_4 != null)
                        {
                            _local_4.sendAvatarExpressionMessage(AvatarExpressionEnum.IDLE.ordinal);
                        }
                    }
                    this._interstitialActive = false;
                }
                else
                {
                    if (k.type == RoomEngineEvent.DISPOSED)
                    {
                        this._interstitialActive = false;
                    }
                }
            }
        }

        function roomEventHandler(k:RoomEngineEvent)
        {
            var _local_4:IRoomSession = null;
            var _local_5:RoomBackgroundColorEvent = null;
            var _local_6:RoomZoomEvent = null;
            var _local_7:RoomObjectHSLColorEnabledEvent = null;
            var _local_8 = Math.NaN;
            if (this._roomEngine == null)
            {
                return;
            }
            var _local_2= this.getRoomIdentifier(k.roomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 == null)
            {
                if (this._roomSessionManager == null)
                {
                    return;
                }
                _local_4 = this._roomSessionManager.getSession(k.roomId);
                if (_local_4 != null)
                {
                    _local_3 = Std.downcast(this.createDesktop(_local_4) , RoomDesktop);
                }
            }
            if (_local_3 == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineEvent.INITIALIZED:
                    _local_3.createRoomView(this.getActiveCanvasId(k.roomId));
                    if (((!(this._roomEngine == null)) && (!RoomId.isRoomPreviewerId(k.roomId))))
                    {
                        this._roomEngine.setActiveRoom(k.roomId);
                        _local_3.initCameraLocation(this.getActiveCanvasId(k.roomId));
                    }
                    _local_3.disposeWidget(RoomWidgetEnum.ROOM_QUEUE);
                    _local_3.createWidget(RoomWidgetEnum.CHAT_WIDGET);
                    if (((this._freeFlowChat != null) && (!this._freeFlowChat.isDisabledInPreferences)))
                    {
                        this._wasFreeFlowChatPerkAllowedAtInitialize = true;
                        if (this._freeFlowChat.displayObject != null)
                        {
                            _local_3.layoutManager.getChatContainer().setDisplayObject(this._freeFlowChat.displayObject);
                        }
                    }
                    _local_3.createWidget(RoomWidgetEnum.INFOSTAND);
                    _local_3.createWidget(RoomWidgetEnum.LOCATION_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_TOOLS);
                    if (!_local_3.session.isSpectatorMode)
                    {
                        _local_3.createWidget(RoomWidgetEnum.ME_MENU);
                        _local_3.createWidget(RoomWidgetEnum.CHAT_INPUT_WIDGET);
                        _local_3.createWidget(RoomWidgetEnum.FRIEND_REQUEST);
                        if (getBoolean("avatar.widget.enabled"))
                        {
                            _local_3.createWidget(RoomWidgetEnum.AVATAR_INFO);
                        }
                    }
                    _local_3.createWidget(RoomWidgetEnum.FURNI_PLACEHOLDER);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_CREDIT_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_STICKIE_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_PRESENT_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_TROPHY_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_ECOTRONBOX_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_PET_PACKAGE_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.DOORBELL);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_POLL);
					_local_3.createWidget(RoomWidgetEnum.ROOM_VOTE);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_DIMMER);
                    _local_3.createWidget(RoomWidgetEnum.CLOTHING_CHANGE);
                    _local_3.createWidget(RoomWidgetEnum.CONVERSION_TRACKING);
                    if (getBoolean("welcome.gift.feature.enabled"))
                    {
                        _local_3.createWidget(RoomWidgetEnum.WELCOME_GIFT);
                    }
                    if (!getBoolean("memenu.effects.widget.disabled"))
                    {
                        _local_3.createWidget(RoomWidgetEnum.EFFECTS);
                    }
                    _local_3.createWidget(RoomWidgetEnum.MANNEQUIN);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_BACKGROUND_COLOR);
                    _local_3.createWidget(RoomWidgetEnum.AREA_HIDE);
                    _local_3.createWidget(RoomWidgetEnum.CUSTOM_USER_NOTIFICATION);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_CHOOSER);
                    _local_3.createWidget(RoomWidgetEnum.USER_CHOOSER);
                    if (this._userChooserState != RoomDesktop.STATE_UNDEFINED)
                    {
                        _local_3.initializeWidget(RoomWidgetEnum.USER_CHOOSER, this._userChooserState);
                    }
                    _local_3.createWidget(RoomWidgetEnum.PLAYLIST_EDITOR_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.SPAMWALL_POSTIT_WIDGET);
                    _local_3.createWidget(RoomWidgetEnum.FURNITURE_CONTEXT_MENU);
                    _local_3.createWidget(RoomWidgetEnum.CAMERA);
                    _local_3.createWidget(RoomWidgetEnum.FURNI_ACHIEVEMENT_RESOLUTION_ENGRAVING);
                    _local_3.createWidget(RoomWidgetEnum.FRIEND_FURNI_CONFIRM);
                    _local_3.createWidget(RoomWidgetEnum.FRIEND_FURNI_ENGRAVING);
                    _local_3.createWidget(RoomWidgetEnum.HIGH_SCORE_DISPLAY);
                    _local_3.createWidget(RoomWidgetEnum.GAMEHALL_BOARD);
                    _local_3.createWidget(RoomWidgetEnum.LEADERBOARD);
                    _local_3.createWidget(RoomWidgetEnum.INTERNAL_LINK);
                    _local_3.createWidget(RoomWidgetEnum.CUSTOM_STACK_HEIGHT);
                    _local_3.createWidget(RoomWidgetEnum.YOUTUBE);
                    _local_3.createWidget(RoomWidgetEnum.RENTABLESPACE);
                    _local_3.createWidget(RoomWidgetEnum.VIMEO);
                    _local_3.createWidget(RoomWidgetEnum.EXTERNAL_IMAGE);
                    _local_3.createWidget(RoomWidgetEnum.UI_HELP_BUBBLE);
                    _local_3.createWidget(RoomWidgetEnum.WORD_QUIZZ);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_THUMBNAIL_CAMERA);
                    _local_3.createWidget(RoomWidgetEnum.ROOM_LINK);
                    _local_3.createWidget(RoomWidgetEnum.CRAFTING);
                    this._isInRoom = true;
                    return;
                case RoomEngineEvent.DISPOSED:
                    this.disposeDesktop(_local_2);
                    this._isInRoom = false;
                    return;
                case RoomBackgroundColorEvent.ROOM_COLOR:
                    _local_5 = Std.downcast(k , RoomBackgroundColorEvent);
                    if (_local_5 == null)
                    {
                        return;
                    }
                    if (_local_5.bgOnly)
                    {
                        _local_3.setRoomViewColor(0x000000, 0xFF);
                    }
                    else
                    {
                        _local_3.setRoomViewColor(_local_5.color, ASCompat.toInt(_local_5.brightness));
                    }
                    return;
                case RoomZoomEvent.ROOM_ZOOM:
                    _local_6 = Std.downcast(k , RoomZoomEvent);
                    if (_local_6 == null)
                    {
                        return;
                    }
                    _local_8 = ((_local_6.level < 1) ? 0.5 : (1 << Std.int(Math.min(5, Math.ffloor(_local_6.level)) - 1)));
                    if (((!(_local_3 == null)) && (!_local_6.isFlipForced)))
                    {
                        _local_3.animateRoomCanvasScale(_local_8);
                    }
                    else
                    {
                        this._roomEngine.setRoomCanvasScale(this._roomEngine.activeRoomId, this.getActiveCanvasId(this._roomEngine.activeRoomId), _local_8, null, null, _local_6.isFlipForced);
                    }
                    return;
                case RoomEngineDimmerStateEvent.REDSE_ROOM_COLOR:
                    _local_3.processEvent(k);
                    return;
                case RoomObjectHSLColorEnabledEvent.ROOM_BACKGROUND_COLOR:
                    _local_7 = cast(k, RoomObjectHSLColorEnabledEvent);
                    if (!_local_7.enable)
                    {
                        _local_3.setRoomBackgroundColor(0, 0, 0);
                    }
                    else
                    {
                        _local_3.setRoomBackgroundColor(_local_7.hue, _local_7.saturation, _local_7.lightness);
                    }
                    return;
            }
        }

        function roomObjectEventHandler(k:RoomEngineObjectEvent)
        {
            if (this._roomEngine == null)
            {
                return;
            }
            var _local_2= this.getRoomIdentifier(k.roomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                _local_3.roomObjectEventHandler(k);
            }
        }

        function gameEventHandler(k:Event)
        {
            var _local_2= Std.downcast(this.getDesktop(this.getRoomIdentifier(0)) , RoomDesktop);
            if (_local_2 != null)
            {
                _local_2.processEvent(k);
            }
        }

        public function createDesktop(k:IRoomSession):IRoomDesktop
        {
            if (k == null)
            {
                return null;
            }
            if (this._roomEngine == null)
            {
                return null;
            }
            var _local_2= this.getRoomIdentifier(k.roomId);
            var _local_3= Std.downcast(this.getDesktop(_local_2) , RoomDesktop);
            if (_local_3 != null)
            {
                return _local_3;
            }
            _local_3 = new RoomDesktop(k, assets, this._communication.connection);
            _local_3.roomEngine = this._roomEngine;
            _local_3.windowManager = this._windowManager;
            _local_3.roomWidgetFactory = this._roomWidgetFactory;
            _local_3.sessionDataManager = this._sessionDataManager;
            _local_3.roomSessionManager = this._roomSessionManager;
            _local_3.communicationManager = this._communication;
            _local_3.friendList = this._friendList;
            _local_3.avatarRenderManager = this._avatarRenderManager;
            _local_3.inventory = this._inventory;
            _local_3.messenger = this._messenger;
            _local_3.toolbar = this._toolbar;
            if (((this._newNavigator != null) && this._sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014)))
            {
                _local_3.navigator = this._newNavigator.legacyNavigator;
            }
            else
            {
                _local_3.navigator = this._navigator;
            }
            _local_3.habboGroupsManager = this._habboGroupsManager;
            _local_3.avatarEditor = this._avatarEditor;
            _local_3.catalog = this._catalog;
            _local_3.adManager = this._adManager;
            _local_3.localization = this._localization;
            _local_3.habboHelp = this._habboHelp;
            _local_3.moderation = this._moderation;
            _local_3.config = this;
            _local_3.soundManager = this._soundManager;
            _local_3.habboTracking = this._habboTracking;
            _local_3.userDefinedRoomEvents = this._userDefinedRoomEvents;
            _local_3.gameManager = this._gameManager;
            _local_3.questEngine = this._questEngine;
            _local_3.freeFlowChat = this._freeFlowChat;
            var _local_4= Std.downcast(assets.getAssetByName("room_desktop_layout_xml") , XmlAsset);
            if (_local_4 != null)
            {
                _local_3.layout = ((_local_4.content : com.sulake.core.utils.xml.XML) );
            }
            _local_3.createWidget(RoomWidgetEnum.LOADINGBAR);
            _local_3.createWidget(RoomWidgetEnum.ROOM_QUEUE);
            _local_3.init();
            _local_3.requestInterstitial();
            this._interstitialActive = false;
            this._interstitialRoomId = k.roomId;
            this._desktops.add(_local_2, _local_3);
            return _local_3;
        }

        public var chatContainer(get,never):IDisplayObjectWrapper;
public function  get_chatContainer():IDisplayObjectWrapper
        {
            var k= Std.downcast(this.getDesktop(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            if (((!(k != null)) || (!(k.layoutManager != null))))
            {
                return null;
            }
            return k.layoutManager.getChatContainer();
        }

        public function disposeDesktop(k:String)
        {
            var _local_3 = 0;
            var _local_2= ASCompat.dynamicAs(this._desktops.remove(k) , RoomDesktop);
            if (_local_2 != null)
            {
                _local_3 = _local_2.getWidgetState(RoomWidgetEnum.USER_CHOOSER);
                if (_local_3 != RoomDesktop.STATE_UNDEFINED)
                {
                    this._userChooserState = _local_3;
                }
                _local_2.dispose();
                this._interstitialActive = false;
            }
        }

        public function getDesktop(k:String):IRoomDesktop
        {
            return ASCompat.dynamicAs(this._desktops.getValue(k) , RoomDesktop);
        }

        public function getActiveCanvasId(k:Int):Int
        {
            return 1;
        }

        public function update(k:UInt)
        {
            var _local_3:RoomDesktop = null;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._desktops.length)
            {
                _local_3 = ASCompat.dynamicAs(this._desktops.getWithIndex(_local_2) , RoomDesktop);
                if (_local_3 != null)
                {
                    _local_3.update(k);
                }
                _local_2++;
            }
        }

        function getRoomIdentifier(k:Int):String
        {
            return "hard_coded_room_id";
        }

        public var visible(never,set):Bool;
public function  set_visible(k:Bool):Bool        {
            var _local_2:RoomDesktop = this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId));
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
return k;
        }

        public function hideWidget(k:String)
        {
            var _local_2:RoomDesktop = this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId));
            if (_local_2 != null)
            {
                _local_2.processEvent(new HideRoomWidgetEvent(k));
            }
        }

        public function showGamePlayerName(k:Int, _arg_2:String, _arg_3:UInt, _arg_4:Int)
        {
            var _local_5:RoomDesktop = this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId));
            if (_local_5 != null)
            {
                _local_5.showGamePlayerName(k, _arg_2, _arg_3, _arg_4);
            }
        }

        public function hideAvatarInfo()
        {
            var desktop= ASCompat.dynamicAs(this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            if (desktop != null) desktop.hideAvatarInfo();
        }

        public function createSpectatorModeVisualization():IWindow
        {
            if (this._roomEngine == null) return null;
            var desktop= ASCompat.dynamicAs(this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            return desktop == null ? null : desktop.getSpectatorModeVisualization();
        }

        public function getRoomViewRect():Rectangle
        {
            if (this._roomEngine == null) return null;
            var desktop= ASCompat.dynamicAs(this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId)) , RoomDesktop);
            var rect:Rectangle = desktop == null ? null : desktop.getRoomViewRect();
            if (rect == null) return null;
            rect = rect.clone();
            // This client's room-view layout stretches behind the bottom toolbar. Use the toolbar's real
            // top edge as the viewport boundary so an opaque game backdrop cannot cover hotel chrome.
            var toolbarRect:Rectangle = this._toolbar == null ? null : this._toolbar.getRect();
            if (toolbarRect != null && toolbarRect.height > 0 &&
                toolbarRect.y > rect.y && toolbarRect.y < rect.bottom)
            {
                rect.height = toolbarRect.y - rect.y;
            }
            else if (rect.height > 47)
            {
                rect.height -= 47;
            }
            return rect;
        }

        public function mouseEventPositionHasContextMenu(k:MouseEvent):Bool
        {
            var _local_2:RoomDesktop = this._desktops.getValue(this.getRoomIdentifier(this._roomEngine.activeRoomId));
            if (_local_2 != null)
            {
                return _local_2.mouseEventPositionHasInputEventWindow(k, 0);
            }
            return false;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var inventory(get,never):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return this._inventory;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return this._roomEngine;
        }

        public var soundManager(get,never):IHabboSoundManager;
public function  get_soundManager():IHabboSoundManager
        {
            return this._soundManager;
        }

        public var habboTracking(get,never):IHabboTracking;
public function  get_habboTracking():IHabboTracking
        {
            return this._habboTracking;
        }

        public var habboGroupsManager(get,never):IHabboGroupsManager;
public function  get_habboGroupsManager():IHabboGroupsManager
        {
            return this._habboGroupsManager;
        }

        public var friendBarView(get,never):IHabboFriendBarView;
public function  get_friendBarView():IHabboFriendBarView
        {
            return this._friendBarView;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var chatStyleLibrary(get,never):IChatStyleLibrary;
public function  get_chatStyleLibrary():IChatStyleLibrary
        {
            if (this._freeFlowChat != null)
            {
                return this._freeFlowChat.chatStyleLibrary;
            }
            return null;
        }

        public var freeFlowChat(get,never):IHabboFreeFlowChat;
public function  get_freeFlowChat():IHabboFreeFlowChat
        {
            return this._freeFlowChat;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }
    }

