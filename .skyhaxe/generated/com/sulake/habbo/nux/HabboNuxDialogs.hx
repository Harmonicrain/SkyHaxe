package com.sulake.habbo.nux
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.core.communication.connection.IConnection;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboNavigator;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceNotCompleteEvent;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGiftOfferEvent;
    import com.sulake.habbo.communication.messages.outgoing.gifts.SetPhoneNumberVerificationStatusMessageComposer;
    import com.sulake.habbo.phonenumber.ClientPhoneVerificationStatusEnum;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.communication.messages.outgoing.nux.NewUserExperienceGetGiftsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.nux.NewUserExperienceGetGiftsSelection;
    import flash.events.TimerEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.communication.messages.incoming.nux.NewUserExperienceGiftOptions;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;

     class HabboNuxDialogs extends Component implements ILinkEventTracker 
    {
        var _communicationManager:IHabboCommunicationManager;
        var _navigator:IHabboNavigator;
        var _windowManager:IHabboWindowManager;
        var _localizationManager:IHabboLocalizationManager;
        var _catalog:IHabboCatalog;
        var _sessionDataManager:ISessionDataManager;
        var _roomSessionManager:IRoomSessionManager;
        var _connection:IConnection;
        var _Str_14050:NuxOfferOldUserView;
        var _Str_13375:NuxGiftSelectionView;
        var _Str_13625:NuxNoobRoomOfferView;
        var _Str_4439:Timer;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, true), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboNavigator(), function (k:IHabboNavigator)
            {
                _navigator = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false, [{
                "type":RoomSessionEvent.STARTED,
                "callback":this.onRoomSessionEvent
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.onRoomSessionEvent
            }])]));
        }

        override public function dispose()
        {
            context.removeLinkEventTracker(this);
            if (this._windowManager != null)
            {
                this._windowManager = null;
            }
            this.destroyGiftSelectionView();
            this.destroyNoobRoomOfferView();
            this.destroyNuxOfferView();
            super.dispose();
        }

        override function initComponent()
        {
            this._connection = this._communicationManager.connection;
            if (this._connection != null)
            {
                this._connection.addMessageEvent(new NewUserExperienceNotCompleteEvent(this.onNewUserExperienceNotCompleteMessage));
                this._connection.addMessageEvent(new NewUserExperienceGiftOfferEvent(this.onNewUserExperienceGiftOfferMessage));
            }
            context.addLinkEventTracker(this);
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "nux/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "lobbyoffer":
                    if (((_local_2.length > 2) && (_local_2[2] == "show")))
                    {
                        this.createNoobRoomOfferView();
                    }
                    else
                    {
                        this.destroyNoobRoomOfferView();
                    }
                    return;
                default:
                    Logger.log([("HabboNuxDialogs unknown link-type received: " + _local_2[1])]);
            }
        }

        public function onVerify()
        {
            this._connection.send(new SetPhoneNumberVerificationStatusMessageComposer(ClientPhoneVerificationStatusEnum.NON_EXISTING));
        }

        public function onReject()
        {
            this._windowManager.confirm("${phone.number.never.again.confirm.title}", "${phone.number.never.again.confirm.text}", 0, this.onNeverAgainConfirmClose);
        }

        function onNeverAgainConfirmClose(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            if (((_arg_2.type == WindowEvent.WINDOW_EVENT_OK) && (this._connection != null)))
            {
                this.destroyNuxOfferView();
                this._connection.send(new SetPhoneNumberVerificationStatusMessageComposer(ClientPhoneVerificationStatusEnum.NEVER_AGAIN));
            }
        }

        public function onSendGetGifts(k:Vector<NewUserExperienceGetGiftsSelection>)
        {
            this.destroyGiftSelectionView();
            this._connection.send(new NewUserExperienceGetGiftsMessageComposer(k));
        }

        function onNewUserExperienceNotCompleteMessage(k:NewUserExperienceNotCompleteEvent)
        {
            this.createNuxOfferView();
        }

        function onNewUserExperienceGiftOfferMessage(k:NewUserExperienceGiftOfferEvent)
        {
            var _local_2= k.getParser();
            this.createGiftSelectionView(_local_2.giftOptions);
        }

        function onRoomSessionEvent(k:RoomSessionEvent)
        {
            var _local_2:UInt = 0;
            if (((!getBoolean("nux.lobbies.enabled")) || (!this._sessionDataManager.isRealNoob)))
            {
                return;
            }
            if ((((k.type == RoomSessionEvent.STARTED) && (k.session != null)) && (k.session.roomId == this._navigator.homeRoomId)))
            {
                _local_2 = (getInteger("nux.noob.lobby.popup.delay", 70) * 1000);
                this._Str_4439 = new Timer(_local_2, 1);
                this._Str_4439.addEventListener(TimerEvent.TIMER, (this.createNoobRoomOfferView : ASAny));
                this._Str_4439.start();
            }
            else
            {
                this.destroyNoobRoomOfferView();
            }
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var localizationManager(get,never):IHabboLocalizationManager;
public function  get_localizationManager():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        function createNuxOfferView()
        {
            this.destroyNuxOfferView();
            this._Str_14050 = new NuxOfferOldUserView(this);
        }

        public function destroyNuxOfferView()
        {
            if (this._Str_14050 != null)
            {
                this._Str_14050.dispose();
                this._Str_14050 = null;
            }
        }

        function createGiftSelectionView(k:Vector<NewUserExperienceGiftOptions>)
        {
            this.destroyGiftSelectionView();
            this._Str_13375 = new NuxGiftSelectionView(this, k);
        }

        function destroyGiftSelectionView()
        {
            if (this._Str_13375 != null)
            {
                this._Str_13375.dispose();
                this._Str_13375 = null;
            }
        }

        function startNoobRoomOfferTimer()
        {
        }

        function createNoobRoomOfferView(k:TimerEvent=null)
        {
            if (((!getBoolean("nux.lobbies.enabled")) || (!this._sessionDataManager.isRealNoob)))
            {
                return;
            }
            this.destroyNoobRoomOfferView();
            this._Str_13625 = new NuxNoobRoomOfferView(this);
            this._connection.send(new EventLogMessageComposer("NewNavigator", "nux.offer.lobby", "nux.offer.lobby"));
        }

        public function destroyNoobRoomOfferView()
        {
            if (this._Str_4439 != null)
            {
                this._Str_4439.reset();
                this._Str_4439 = null;
            }
            if (this._Str_13625 != null)
            {
                this._Str_13625.dispose();
                this._Str_13625 = null;
            }
        }
    }

