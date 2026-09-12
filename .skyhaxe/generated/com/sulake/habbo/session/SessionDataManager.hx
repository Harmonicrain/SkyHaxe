package com.sulake.habbo.session
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.session.product.ProductDataParser;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.session.furniture.FurnitureDataParser;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import flash.events.Event;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPublishedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.FigureUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserChangeMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.UserNameChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.avatar.ChangeUserNameResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.availability.AvailabilityStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.pets.PetRespectFailedEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.AccountSafetyLockStatusChangeMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.mysterybox.MysteryBoxKeysMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.UserTagsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.NoobnessLevelMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.InClientLinkMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.PurchasableChatStyleChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.PurchasableChatStylesMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import com.sulake.habbo.communication.messages.incoming.users.EmailStatusResultEvent;
    import com.sulake.habbo.communication.messages.incoming.session.FurniDataReloadMessageEvent;
    import com.sulake.habbo.session.furniture.IFurniDataListener;
    import com.sulake.habbo.communication._enum.NoobnessLevelEnum;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.session.events.UserNameUpdateEvent;
    import com.sulake.habbo.session.events.MysteryBoxKeysUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionUserTagsEvent;
    import com.sulake.habbo.session.events.SessionDataPreferencesEvent;
    import com.sulake.habbo.session.events.SessionDataToWidgetEvent;
    import com.sulake.habbo.communication.messages.parser.users.AccountSafetyLockStatusChangeMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetUIFlagsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.WhiperGroupComposer;
    import flash.display.BitmapData;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.RespectUserMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.pets.RespectPetMessageComposer;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.habbo.communication.messages.outgoing.room.chat.ChatMessageComposer;
    import flash.events.TimerEvent;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.habbo.session.talent.TalentEnum;
    import com.sulake.iid.*;

     class SessionDataManager extends Component implements ISessionDataManager 
    {
        public static inline final SETUP_WITHOUT_COMMUNICATION:UInt = 1;

        var _communicationManager:IHabboCommunicationManager;
        var _windowManager:IHabboWindowManager;
        var _roomSessionManager:IRoomSessionManager;
        var _perkManager:PerkManager;
        var _userId:Int = 0;
        var _name:String;
        var _figure:String;
        var _gender:String;
        var _realName:String;
        var _respectTotal:Int = 0;
        var _respectLeft:Int = 0;
        var _petRespectLeft:Int = 0;
        var _nameChangeAllowed:Bool = true;
        var _rights:Array<ASAny>;
        var _systemOpen:Bool = false;
        var _systemShutDown:Bool = false;
        var _isAuthenticHabbo:Bool = false;
        var _products:ASDictionary<ASAny,ASAny>;
        var _productParser:ProductDataParser;
        var _floorItems:Map;
        var _wallItems:Map;
        var _furnitureIds:Map;
        var _furnitureParser:FurnitureDataParser;
        var _Str_7432:_Str_8883;
        var _badgeImageManager:BadgeImageManager;
        var _furniIconImageManager:FurniIconImageManager;
        var _habboGroupInfoManager:HabboGroupInfoManager;
        var _ignoredUsersManager:IgnoredUsersManager;
        var _localizationManager:IHabboLocalizationManager;
        var _productDataReady:Bool = false;
        var _Str_8233:Array<ASAny>;
        var _Str_6042:Array<ASAny>;
        var _furniReloadListeners:Array<ASAny>;
        var _clubLevel:Int = 0;
        var _securityLevel:Int = 0;
        var _topSecurityLevel:Int = 0;
        var _noobnessLevel:Int = -1;
        var _isAmbassador:Bool = false;
        var _isEmailVerified:Bool = false;
        var _isRoomCameraFollowDisabled:Bool = false;
        var _uiFlags:Int = 0;
        var _uiFlagsReady:Bool = false;
        var _accountSafetyLocked:Bool = false;
        var _mysteryBoxColor:String;
        var _mysteryKeyColor:String;
        var _Str_20020:Bool = false;
        var _Str_12845:Bool = false;
        var _Str_8108:Timer = null;
        var _Str_8546:String = null;
        var _furniReloadToken:String = null;
        var _furniReloadInProgress:Bool = false;
        var _purchasableChatStyles:ASDictionary<ASAny,ASAny>;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }, false), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, ((ASCompat.toInt(flags )& ASCompat.toInt(SETUP_WITHOUT_COMMUNICATION)) == 0)), new ComponentDependency(new IIDHabboConfigurationManager(), null, true, [{
                "type":Event.COMPLETE,
                "callback":this.onConfigurationComplete
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false)]));
        }

        function onConfigurationComplete(k:Event)
        {
            this._products = new ASDictionary<ASAny,ASAny>();
            this._floorItems = new Map();
            this._wallItems = new Map();
            this._furnitureIds = new Map();
            this.initFurnitureData();
            this.initProductData();
            this.initBadgeImageManager();
            this.initFurniIconImageManager();
        }

        override function initComponent()
        {
            if (this._communicationManager != null)
            {
                this._communicationManager.addHabboConnectionMessageEvent(new CatalogPublishedMessageEvent(this.onCatalogPublished));
                this._communicationManager.addHabboConnectionMessageEvent(new UserRightsMessageEvent(this.onUserRights));
                this._communicationManager.addHabboConnectionMessageEvent(new UserObjectEvent(this.onUserObject));
                this._communicationManager.addHabboConnectionMessageEvent(new FigureUpdateEvent(this.onFigureUpdate));
                this._communicationManager.addHabboConnectionMessageEvent(new UserChangeMessageEvent(this.onUserChange));
                this._communicationManager.addHabboConnectionMessageEvent(new UserNameChangedMessageEvent(this.onUserNameChange));
                this._communicationManager.addHabboConnectionMessageEvent(new ChangeUserNameResultMessageEvent(this.onChangeUserNameResult));
                this._communicationManager.addHabboConnectionMessageEvent(new AvailabilityStatusMessageEvent(this.onAvailabilityStatus));
                this._communicationManager.addHabboConnectionMessageEvent(new PetRespectFailedEvent(this.onPetRespectFailed));
                this._communicationManager.addHabboConnectionMessageEvent(new RoomReadyMessageEvent(this.onRoomReady) );
                this._communicationManager.addHabboConnectionMessageEvent(new AccountSafetyLockStatusChangeMessageEvent(this.onAccountSafetyLockStatusChanged));
                this._communicationManager.addHabboConnectionMessageEvent(new MysteryBoxKeysMessageEvent(this.onMysteryBoxKeys));
                this._communicationManager.addHabboConnectionMessageEvent(new UserTagsMessageEvent(this._Str_7983));
                this._communicationManager.addHabboConnectionMessageEvent(new NoobnessLevelMessageEvent(this.onNoobnessLevelEvent));
                this._communicationManager.addHabboConnectionMessageEvent(new InClientLinkMessageEvent(this.onInClientLink));
                this._communicationManager.addHabboConnectionMessageEvent(new AccountPreferencesEvent(this.onAccountPreferences));
                this._communicationManager.addHabboConnectionMessageEvent(new EmailStatusResultEvent(this.onEmailStatus));
                this._communicationManager.addHabboConnectionMessageEvent(new FurniDataReloadMessageEvent(this.onFurniDataReload));
                this._communicationManager.addHabboConnectionMessageEvent(new PurchasableChatStylesMessageEvent(this.onPurchasableChatStyles));
                this._communicationManager.addHabboConnectionMessageEvent(new PurchasableChatStyleChangedMessageEvent(this.onPurchasableChatStyleChanged));
            }
            this._rights = [];
            this._Str_7432 = new _Str_8883(this);
            this._habboGroupInfoManager = new HabboGroupInfoManager(this);
            this._ignoredUsersManager = new IgnoredUsersManager(this);
            this._perkManager = new PerkManager(this);
            this._Str_8233 = [];
            this._Str_6042 = [];
            this._furniReloadListeners = [];
            this._purchasableChatStyles = new ASDictionary<ASAny,ASAny>();
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._Str_7432 != null)
            {
                this._Str_7432.dispose();
                this._Str_7432 = null;
            }
            if (this._floorItems != null)
            {
                this._floorItems.dispose();
                this._floorItems = null;
            }
            if (this._furnitureIds != null)
            {
                this._furnitureIds.dispose();
                this._furnitureIds = null;
            }
            if (this._perkManager != null)
            {
                this._perkManager.dispose();
                this._perkManager = null;
            }
            this._Str_6042 = null;
            if (this._furnitureParser != null)
            {
                this._furnitureParser.removeEventListener(FurnitureDataParser.FDP_FURNITURE_DATA_READY, this.onFurnitureReady);
                this._furnitureParser.dispose();
                this._furnitureParser = null;
            }
            if (this._productParser != null)
            {
                this._productParser.removeEventListener(ProductDataParser.PDP_PRODUCT_DATA_READY, this._Str_18413);
                this._productParser.dispose();
                this._productParser = null;
            }
            if (this._furniIconImageManager != null)
            {
                this._furniIconImageManager.dispose();
                this._furniIconImageManager = null;
            }
            super.dispose();
        }

        function initBadgeImageManager()
        {
            if (this._badgeImageManager != null)
            {
                return;
            }
            this._badgeImageManager = new BadgeImageManager(assets, events, this);
        }

        function initFurniIconImageManager()
        {
            if (this._furniIconImageManager == null)
            {
                this._furniIconImageManager = new FurniIconImageManager(assets, events, this, this);
            }
        }

        function initFurnitureData()
        {
            var k:String = null;
            var _local_2 = 0;
            var _local_3:String = null;
            if (this._furnitureParser != null)
            {
                this._furnitureParser.dispose();
                this._furnitureParser = null;
            }
            this._furnitureParser = new FurnitureDataParser(this._floorItems, this._wallItems, this._furnitureIds, this._localizationManager);
            this._furnitureParser.addEventListener(FurnitureDataParser.FDP_FURNITURE_DATA_READY, this.onFurnitureReady);
            if (propertyExists("furnidata.load.url"))
            {
                k = getProperty("furnidata.load.url");
                if (this._Str_8546 != null)
                {
                    _local_2 = k.lastIndexOf("/");
                    _local_3 = k.substring(0, _local_2);
                    this._furnitureParser.loadData(this.appendFurniReloadToken(((_local_3 + "/") + this._Str_8546)));
                }
                else
                {
                    this._furnitureParser.loadData(this.appendFurniReloadToken(k));
                }
            }
        }

        function appendFurniReloadToken(k:String):String
        {
            if (((this._furniReloadToken == null) || (this._furniReloadToken.length == 0)))
            {
                return k;
            }
            return (k + ((k.indexOf("?") == -1) ? "?" : "&") + "furni_reload=" + ASCompat.encodeURIComponent(this._furniReloadToken));
        }

        function initProductData()
        {
            if (this._productParser != null)
            {
                this._productParser.dispose();
                this._productParser = null;
            }
            var k= getProperty("productdata.load.url");
            this._productParser = new ProductDataParser(k, this._products);
            this._productParser.addEventListener(ProductDataParser.PDP_PRODUCT_DATA_READY, this._Str_18413);
        }

        function onFurnitureReady(k:Event=null)
        {
            var _local_2:IFurniDataListener = null;
            var _local_3= this._furniReloadInProgress;
            this._furnitureParser.removeEventListener(FurnitureDataParser.FDP_FURNITURE_DATA_READY, this.onFurnitureReady);
            this._Str_20020 = true;
            if ((this.isAuthenticHabbo && _local_3))
            {
                final _iter_ = this._furniReloadListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (((!(_local_2 == null)) && (!_local_2.disposed)))
                    {
                        _local_2.furniDataReady();
                    }
                }
            }
            else if ((this.isAuthenticHabbo && (!this._Str_12845)))
            {
                this._Str_12845 = true;
                final _iter_ = this._Str_6042; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (((!(_local_2 == null)) && (!_local_2.disposed)))
                    {
                        _local_2.furniDataReady();
                    }
                }
            }
            if (_local_3)
            {
                this._furniReloadInProgress = false;
            }
        }

        function onFurniDataReload(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FurniDataReloadMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            this._furniReloadToken = _local_3.reloadToken;
            this._furniReloadInProgress = true;
            this._Str_18167(null);
        }

        function onUserRights(k:IMessageEvent)
        {
            var _local_2= cast(k, UserRightsMessageEvent);
            this._clubLevel = _local_2.clubLevel;
            this._securityLevel = _local_2.securityLevel;
            this._topSecurityLevel = Std.int(Math.max(this._topSecurityLevel, _local_2.securityLevel));
            this._isAmbassador = _local_2.isAmbassador;
        }

        function onNoobnessLevelEvent(k:NoobnessLevelMessageEvent)
        {
            this._noobnessLevel = k.noobnessLevel;
            if (this._noobnessLevel != NoobnessLevelEnum.OLD_IDENTITY)
            {
                context.configuration.setProperty("new.identity", "1");
            }
        }

        function onUserObject(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserObjectEvent);
            var _local_3= _local_2.getParser();
            this._userId = _local_3.id;
            this._name = _local_3.name;
            if (HabboWebTools.isAirApplication)
            {
                HabboWebTools.setAirWindowTitleForUser(this._name);
            }
            this._respectTotal = _local_3.respectTotal;
            this._respectLeft = _local_3.respectLeft;
            this._petRespectLeft = _local_3.petRespectLeft;
            this._figure = _local_3.figure;
            this._gender = _local_3.sex;
            this._realName = _local_3.realName;
            this._nameChangeAllowed = _local_3.nameChangeAllowed;
            this._accountSafetyLocked = _local_3.accountSafetyLocked;
            this._ignoredUsersManager.initIgnoreList();
        }

        function onUserChange(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserChangeMessageEvent);
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.id == -1)
            {
                this._figure = _local_2.figure;
                this._gender = _local_2.sex;
            }
        }

        function onFigureUpdate(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FigureUpdateEvent);
            if (_local_2 == null)
            {
                return;
            }
            this._figure = _local_2.figure;
            this._gender = _local_2.gender;
            HabboWebTools.updateFigure(this._figure);
        }

        function onUserNameChange(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , UserNameChangedMessageEvent);
            if (((_local_2 == null) || (_local_2.getParser() == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            if (_local_3.webId == this._userId)
            {
                this._name = _local_3.newName;
                if (HabboWebTools.isAirApplication)
                {
                    HabboWebTools.setAirWindowTitleForUser(this._name);
                }
                this._nameChangeAllowed = false;
                events.dispatchEvent(new UserNameUpdateEvent(this._name));
            }
        }

        function onChangeUserNameResult(k:ChangeUserNameResultMessageEvent)
        {
            var _local_2= k.getParser();
            if (_local_2.resultCode == ChangeUserNameResultMessageEvent.NAME_OK)
            {
                this._nameChangeAllowed = false;
                if (HabboWebTools.isAirApplication)
                {
                    HabboWebTools.setAirWindowTitleForUser(_local_2.name);
                }
                events.dispatchEvent(new UserNameUpdateEvent(_local_2.name));
            }
        }

        function onMysteryBoxKeys(k:MysteryBoxKeysMessageEvent)
        {
            var _local_2= k.getParser();
            this._mysteryBoxColor = _local_2.boxColor;
            this._mysteryKeyColor = _local_2.keyColor;
            events.dispatchEvent(new MysteryBoxKeysUpdateEvent(this._mysteryBoxColor, this._mysteryKeyColor));
        }

        function _Str_7983(k:UserTagsMessageEvent)
        {
            if (this._Str_7432 != null)
            {
                this._Str_7432._Str_25163(k.userId, k.tags);
            }
            events.dispatchEvent(new RoomSessionUserTagsEvent(this.userId, k.tags.slice(0)));
        }

        function onInClientLink(k:InClientLinkMessageEvent)
        {
            context.createLinkEvent(k.link);
        }

        function onAccountPreferences(k:AccountPreferencesEvent)
        {
            var _local_2= k.getParser() ;
            this._isRoomCameraFollowDisabled = _local_2.roomCameraFollowDisabled;
            this._uiFlags = _local_2.uiFlags;
            this._uiFlagsReady = true;
            events.dispatchEvent(new SessionDataPreferencesEvent(this._uiFlags));
        }

        function onEmailStatus(k:EmailStatusResultEvent)
        {
            var _local_2= k.getParser() ;
            this._isEmailVerified = _local_2.isVerified;
        }

        function onAvailabilityStatus(k:IMessageEvent)
        {
            var _local_3:IFurniDataListener = null;
            var _local_2= Std.downcast(k , AvailabilityStatusMessageEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            this._systemOpen = _local_2.isOpen;
            this._systemShutDown = _local_2.onShutDown;
            this._isAuthenticHabbo = _local_2.isAuthenticHabbo;
            if (((this.isAuthenticHabbo && this._Str_20020) && (!this._Str_12845)))
            {
                this._Str_12845 = true;
                final _iter_ = this._Str_6042; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    _local_3.furniDataReady();
                }
            }
        }

        function onPetRespectFailed(k:PetRespectFailedEvent)
        {
            if (k == null)
            {
                return;
            }
            this._petRespectLeft++;
        }

        function onAccountSafetyLockStatusChanged(k:AccountSafetyLockStatusChangeMessageEvent)
        {
            var _local_2= k.getParser();
            this._accountSafetyLocked = (_local_2.status == AccountSafetyLockStatusChangeMessageParser.SAFETY_LOCK_STATUS_LOCKED);
        }

        public var systemOpen(get,never):Bool;
public function  get_systemOpen():Bool
        {
            return this._systemOpen;
        }

        public var systemShutDown(get,never):Bool;
public function  get_systemShutDown():Bool
        {
            return this._systemShutDown;
        }

        public var isAuthenticHabbo(get,never):Bool;
public function  get_isAuthenticHabbo():Bool
        {
            if ((((false || false) || false) || false))
            {
                return true;
            }
            return this._isAuthenticHabbo;
        }

        public function hasSecurity(k:Int):Bool
        {
            return this._securityLevel >= k;
        }

        public var topSecurityLevel(get,never):Int;
public function  get_topSecurityLevel():Int
        {
            return this._topSecurityLevel;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        public var isNoob(get,never):Bool;
public function  get_isNoob():Bool
        {
            return !(this._noobnessLevel == NoobnessLevelEnum.OLD_IDENTITY);
        }

        public var isRealNoob(get,never):Bool;
public function  get_isRealNoob():Bool
        {
            return this._noobnessLevel == NoobnessLevelEnum.REAL_NOOB;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._name;
        }

        public var realName(get,never):String;
public function  get_realName():String
        {
            return this._realName;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var isAnyRoomController(get,never):Bool;
public function  get_isAnyRoomController():Bool
        {
            return this._securityLevel >= SecurityLevelEnum.MODERATOR;
        }

        public var isAmbassador(get,never):Bool;
public function  get_isAmbassador():Bool
        {
            return this._isAmbassador;
        }

        public var isEmailVerified(get,never):Bool;
public function  get_isEmailVerified():Bool
        {
            return this._isEmailVerified;
        }

        public function setRoomCameraFollowDisabled(k:Bool)
        {
            this._isRoomCameraFollowDisabled = k;
        }

        public var isRoomCameraFollowDisabled(get,never):Bool;
public function  get_isRoomCameraFollowDisabled():Bool
        {
            return this._isRoomCameraFollowDisabled;
        }

        public function setNavigatorPhaseTwo(k:Bool):Bool
        {
            return this.setUIFlag(UIFlags.NAVIGATOR_PHASE_TWO, k);
        }

        public var isNavigatorPhaseTwo(get,never):Bool;
public function  get_isNavigatorPhaseTwo():Bool
        {
            if ((this._Str_25841() && (!this._uiFlagsReady)))
            {
                return true;
            }
            return (this._uiFlags & UIFlags.NAVIGATOR_PHASE_TWO) != 0;
        }

        public function setFriendBarState(k:Bool)
        {
            this.setUIFlag(UIFlags.FRIEND_BAR_OPEN, k);
        }

        public function setRoomToolsState(k:Bool)
        {
            this.setUIFlag(UIFlags.ROOM_TOOLS_OPEN, k);
        }

        public var uiFlags(get,never):Int;
public function  get_uiFlags():Int
        {
            return this._uiFlags;
        }

        function setUIFlag(k:Int, _arg_2:Bool):Bool
        {
            if (_arg_2)
            {
                if (((this._uiFlags & k) != 0))
                {
                    return false;
                }
                this._uiFlags = (this._uiFlags | k);
            }
            else
            {
                if (!((this._uiFlags & k) != 0))
                {
                    return false;
                }
                this._uiFlags = (this._uiFlags & (~k));
            }
            this._communicationManager.connection.send(new SetUIFlagsMessageComposer(this._uiFlags));
            return true;
        }

        public function getUserTags(k:Int):Array<ASAny>
        {
            return this._Str_7432._Str_24368(k);
        }

        public function getBadgeImage(k:String):BitmapData
        {
            return this._badgeImageManager.getBadgeImage(k);
        }

        public function getBadgeSmallImage(k:String):BitmapData
        {
            return this._badgeImageManager.getSmallBadgeImage(k);
        }

        public function getBadgeImageAssetName(k:String):String
        {
            return this._badgeImageManager.getBadgeImageAssetName(k);
        }

        public function getBadgeImageSmallAssetName(k:String):String
        {
            return this._badgeImageManager.getSmallScaleBadgeAssetName(k);
        }

        public function requestBadgeImage(k:String):BitmapData
        {
            return this._badgeImageManager.getBadgeImage(k, BadgeImageManager.NORMAL_BADGE, false);
        }

        public function getBadgeImageWithInfo(k:String):BadgeInfo
        {
            return this._badgeImageManager.getBadgeImageWithInfo(k);
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        public function getGroupBadgeId(k:Int):String
        {
            return this._habboGroupInfoManager.getBadgeId(k);
        }

        public function send(k:IMessageComposer)
        {
            this._communicationManager.connection.send(k);
        }

        public function getGroupBadgeImage(k:String):BitmapData
        {
            return this._badgeImageManager.getBadgeImage(k, BadgeImageManager.GROUP_BADGE);
        }

        public function getGroupBadgeSmallImage(k:String):BitmapData
        {
            return this._badgeImageManager.getSmallBadgeImage(k, BadgeImageManager.GROUP_BADGE);
        }

        public function getGroupBadgeAssetName(k:String):String
        {
            return this._badgeImageManager.getBadgeImageAssetName(k, BadgeImageManager.GROUP_BADGE);
        }

        public function getGroupBadgeSmallAssetName(k:String):String
        {
            return this._badgeImageManager.getSmallScaleBadgeAssetName(k, BadgeImageManager.GROUP_BADGE);
        }

        public function getFurniIconImage(wallItem:Bool, typeId:Int, extra:String):BitmapData
        {
            return this._furniIconImageManager == null ? null : this._furniIconImageManager.getFurniIconImage(wallItem, typeId, extra);
        }

        public function getFurniIconImageAssetName(wallItem:Bool, typeId:Int, extra:String):String
        {
            return this._furniIconImageManager == null ? "" : this._furniIconImageManager.getFurniIconImageAssetName(wallItem, typeId, extra);
        }

        public function hasPurchasableChatStyle(k:Int):Bool
        {
            return ASCompat.toBool(this._purchasableChatStyles[k]);
        }

        function onPurchasableChatStyles(k:IMessageEvent)
        {
            var _local_3 = 0;
            var _local_2= Std.downcast(k , PurchasableChatStylesMessageEvent).getParser();
            this._purchasableChatStyles = new ASDictionary<ASAny,ASAny>();
            final _iter_ = _local_2.styleIds; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = ASCompat.toInt(_tmp_);
                this._purchasableChatStyles[_local_3] = true;
            }
            events.dispatchEvent(new SessionDataToWidgetEvent(SessionDataToWidgetEvent.PURCHASABLE_STYLES_UPDATED));
        }

        function onPurchasableChatStyleChanged(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PurchasableChatStyleChangedMessageEvent).getParser();
            if (_local_2.owned)
            {
                this._purchasableChatStyles[_local_2.styleId] = true;
            }
            else
            {
                this._purchasableChatStyles.remove(_local_2.styleId);
            }
            events.dispatchEvent(new SessionDataToWidgetEvent(SessionDataToWidgetEvent.PURCHASABLE_STYLES_UPDATED));
        }

        public function isAccountSafetyLocked():Bool
        {
            return this._accountSafetyLocked;
        }

        public var communication(get,never):IHabboCommunicationManager;
public function  get_communication():IHabboCommunicationManager
        {
            return this._communicationManager;
        }

        public function whiperGroup(name:String)
        {
            this.send(new WhiperGroupComposer(name));
        }

        public function isIgnored(k:String):Bool
        {
            return this._ignoredUsersManager.isIgnored(k);
        }

        public function ignoreUser(k:String)
        {
            this._ignoredUsersManager.ignoreUser(k);
        }

        public function unignoreUser(k:String)
        {
            this._ignoredUsersManager.unignoreUser(k);
        }

        public var respectLeft(get,never):Int;
public function  get_respectLeft():Int
        {
            return this._respectLeft;
        }

        public var petRespectLeft(get,never):Int;
public function  get_petRespectLeft():Int
        {
            return this._petRespectLeft;
        }

        public function giveRespect(k:Int)
        {
            if (((k >= 0) && (this._respectLeft > 0)))
            {
                this.send(new RespectUserMessageComposer(k));
                this._respectLeft = (this._respectLeft - 1);
            }
        }

        public function giveRespectFailed()
        {
            this._respectLeft = (this._respectLeft + 1);
        }

        public function givePetRespect(k:Int)
        {
            if (((k >= 0) && (this._petRespectLeft > 0)))
            {
                this.send(new RespectPetMessageComposer(k));
                this._petRespectLeft = (this._petRespectLeft - 1);
            }
        }

        public function getProductData(k:String):IProductData
        {
            if (!this._productDataReady)
            {
                this.loadProductData();
            }
            return this._products[k];
        }

        public function getFloorItemData(k:Int):IFurnitureData
        {
            if (this._floorItems == null)
            {
                return null;
            }
            return this._floorItems.getValue(Std.string(k));
        }

        public function getAllFloorItemDatas():Array<ASAny>
        {
            return this._floorItems == null ? [] : this._floorItems.getValues();
        }

        public function getFloorItemsDataByCategory(k:Int):Array<ASAny>
        {
            var _local_3:IFurnitureData = null;
            var _local_2:Array<ASAny> = [];
            if (this._floorItems != null)
            {
                final _iter_ = this._floorItems; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_3  = _tmp_;
                    if (_local_3.category == k)
                    {
                        _local_2.push(_local_3);
                    }
                }
            }
            return _local_2;
        }

        public function getWallItemData(k:Int):IFurnitureData
        {
            if (this._wallItems == null)
            {
                return null;
            }
            return this._wallItems.getValue(Std.string(k));
        }

        public function getAllWallItemDatas():Array<ASAny>
        {
            return this._wallItems == null ? [] : this._wallItems.getValues();
        }

        public function getFloorItemDataByName(k:String, _arg_2:Int=0):IFurnitureData
        {
            var _local_4 = 0;
            if (this._furnitureIds == null)
            {
                return null;
            }
            var _local_3:Array<ASAny> = this._furnitureIds.getValue(k);
            if (((!(_local_3 == null)) && (_arg_2 <= (_local_3.length - 1))))
            {
                _local_4 = ASCompat.toInt(_local_3[_arg_2]);
                return this.getFloorItemData(_local_4);
            }
            return null;
        }

        public function getWallItemDataByName(k:String, _arg_2:Int=0):IFurnitureData
        {
            var _local_4 = 0;
            if (this._furnitureIds == null)
            {
                return null;
            }
            var _local_3:Array<ASAny> = this._furnitureIds.getValue(k);
            if (((!(_local_3 == null)) && (_arg_2 <= (_local_3.length - 1))))
            {
                _local_4 = ASCompat.toInt(_local_3[_arg_2]);
                return this.getWallItemData(_local_4);
            }
            return null;
        }

        public function openHabboHomePage(userId:Int, userName:String)
        {
            var urlString:String = null;
            if (propertyExists("link.format.userpage"))
            {
                urlString = getProperty("link.format.userpage");
                urlString = ASCompat.stringReplace(urlString, "%ID%", Std.string(userId));
                urlString = ASCompat.stringReplace(urlString, "%username%", userName);
                try
                {
                    HabboWebTools.navigateToURL(urlString, "habboMain");
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    Logger.log(["Error occurred!"]);
                }
 }            }
        }

        public function pickAllFurniture(roomId:Int)
        {
            if (((this._roomSessionManager == null) || (this._windowManager == null)))
            {
                return;
            }
            var session= this._roomSessionManager.getSession(roomId);
            if (session == null)
            {
                return;
            }
            if (((session.isRoomOwner || this.isAnyRoomController) || (session.roomControllerLevel >= RoomControllerLevel.GUEST)))
            {
                this._windowManager.confirm("${generic.alert.title}", "${room.confirm.pick_all}", 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        sendSpecialCommandMessage(":pickall");
                    }
                });
            }
        }

        public function ejectAllFurniture(roomId:Int, message:String)
        {
            if (((this._roomSessionManager == null) || (this._windowManager == null)))
            {
                return;
            }
            var session= this._roomSessionManager.getSession(roomId);
            if (session == null)
            {
                return;
            }
            if (((session.isRoomOwner || this.isAnyRoomController) || (session.roomControllerLevel >= RoomControllerLevel.GUEST)))
            {
                this._windowManager.confirm("${generic.alert.title}", "${room.confirm.eject_all}", 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        sendSpecialCommandMessage(message);
                    }
                });
            }
        }

        public function ejectPets(k:Int)
        {
            if (((this._roomSessionManager == null) || (this._windowManager == null)))
            {
                return;
            }
            var _local_2= this._roomSessionManager.getSession(k);
            if (_local_2 == null)
            {
                return;
            }
            if ((_local_2.isRoomOwner || this.isAnyRoomController))
            {
                this.sendSpecialCommandMessage(":ejectpets");
            }
        }

        public function pickAllBuilderFurniture(roomId:Int)
        {
            if (((this._roomSessionManager == null) || (this._windowManager == null)))
            {
                return;
            }
            var session= this._roomSessionManager.getSession(roomId);
            if (session == null)
            {
                return;
            }
            if (((session.isRoomOwner || this.isAnyRoomController) || (session.roomControllerLevel >= RoomControllerLevel.GUEST)))
            {
                this._windowManager.confirm("${generic.alert.title}", "${room.confirm.pick_all_bc}", 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        sendSpecialCommandMessage(":pickallbc");
                    }
                });
            }
        }

        public function loadProductData(k:IProductDataListener=null):Bool
        {
            if (this._productDataReady)
            {
                return true;
            }
            if (((k != null) && (this._Str_8233.indexOf(k) == -1)))
            {
                this._Str_8233.push(k);
            }
            return false;
        }

        public function addProductsReadyEventListener(k:IProductDataListener)
        {
            if (this._productDataReady)
            {
                k.productDataReady();
                return;
            }
            if (((k != null) && (this._Str_8233.indexOf(k) == -1)))
            {
                this._Str_8233.push(k);
            }
        }

        function _Str_18413(k:Event)
        {
            var _local_2:IProductDataListener = null;
            this._productParser.removeEventListener(ProductDataParser.PDP_PRODUCT_DATA_READY, this._Str_18413);
            this._productDataReady = true;
            final _iter_ = this._Str_8233; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (((!(_local_2 == null)) && (!_local_2.disposed)))
                {
                    _local_2.productDataReady();
                }
            }
            this._Str_8233 = [];
        }

        function onRoomReady(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RoomReadyMessageEvent);
            if ((((_local_2 == null) || (_local_2.getParser() == null)) || (k.connection == null)))
            {
                return;
            }
            var _local_3= _local_2.getParser();
            HabboWebTools.roomVisited(_local_3.roomId);
        }

        public function sendSpecialCommandMessage(k:String)
        {
            this.send(new ChatMessageComposer(k));
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        function onCatalogPublished(k:IMessageEvent)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_2= Std.downcast(k , CatalogPublishedMessageEvent);
            if (_local_2._Str_12669 != null)
            {
                this._Str_8546 = _local_2._Str_12669;
            }
            if (_local_2._Str_17070)
            {
                this._Str_18167(null);
            }
            else
            {
                _local_3 = getInteger("catalogue.published.min.refresh.interval", 5);
                _local_4 = getInteger("catalogue.published.max.refresh.interval", 20);
                _local_5 = Std.int(Math.ffloor((Math.random() * ((_local_4 - _local_3) + 1))) + _local_3);
                if (this._Str_8108 == null)
                {
                    this._Str_8108 = new Timer((_local_5 * 3000));
                    this._Str_8108.addEventListener(TimerEvent.TIMER, (this._Str_18167 : ASAny));
                    this._Str_8108.start();
                }
            }
        }

        function _Str_18167(k:TimerEvent)
        {
            if (this._Str_8108 != null)
            {
                this._Str_8108.removeEventListener(TimerEvent.TIMER, (this._Str_18167 : ASAny));
                this._Str_8108 = null;
            }
            this._floorItems = new Map();
            this._wallItems = new Map();
            this._furnitureIds = new Map();
            this.initFurnitureData();
        }

        public function removeFurniDataListener(k:IFurniDataListener)
        {
            if (this._Str_6042 == null)
            {
                return;
            }
            var _local_2= this._Str_6042.indexOf(k);
            if (_local_2 > -1)
            {
                this._Str_6042.splice(_local_2, 1);
            }
        }

        public function getFurniData(k:IFurniDataListener):Vector<IFurnitureData>
        {
            if (this._furniReloadListeners == null)
            {
                this._furniReloadListeners = [];
            }
            if (((k != null) && (this._furniReloadListeners.indexOf(k) == -1)))
            {
                this._furniReloadListeners.push(k);
            }
            if (((this._floorItems == null) || (this._floorItems.length == 0)))
            {
                if (this._Str_6042.indexOf(k) == -1)
                {
                    this._Str_6042.push(k);
                }
                return null;
            }
            return Vector.ofArray(((cast this._floorItems.getValues().concat(this._wallItems.getValues())) : Array<IFurnitureData>));
        }

        public var furniDataReloadToken(get,never):String;
public function  get_furniDataReloadToken():String
        {
            return this._furniReloadToken;
        }

        public function getXmlWindow(k:String):IWindow
        {
            var _local_3:IAsset = null;
            var _local_4:XmlAsset = null;
            var _local_2:IWindow = null;
            try
            {
                _local_3 = assets.getAssetByName(k);
                _local_4 = cast(_local_3, XmlAsset);
                _local_2 = this._windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(_local_4.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            return _local_2;
        }

        public function getButtonImage(k:String):BitmapData
        {
            var _local_2= k;
            var _local_3= assets.getAssetByName(_local_2);
            var _local_4= cast(_local_3, BitmapDataAsset);
            var _local_5= cast(_local_4.content, BitmapData);
            var _local_6= new BitmapData(_local_5.width, _local_5.height, true, 0);
            _local_6.draw(_local_5);
            return _local_6;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localizationManager;
        }

        public var nameChangeAllowed(get,never):Bool;
public function  get_nameChangeAllowed():Bool
        {
            return this._nameChangeAllowed;
        }

        public var perksReady(get,never):Bool;
public function  get_perksReady():Bool
        {
            return (!(this._perkManager == null)) && this._perkManager.isReady;
        }

        public function isPerkAllowed(k:String):Bool
        {
            if (k == PerkEnum.NAVIGATOR_PHASE_TWO_2014)
            {
                return this.isNavigatorPhaseTwo;
            }
            if (k == PerkEnum.NAVIGATOR_PHASE_ONE_2014)
            {
                return !this.isNavigatorPhaseTwo;
            }
            return this._perkManager.isPerkAllowed(k);
        }

        function _Str_25841():Bool
        {
            return (((this._perkManager == null) || (!this._perkManager.isReady)) || (!this._perkManager.hasPerk(PerkEnum.NAVIGATOR_PHASE_ONE_2014) && !this._perkManager.hasPerk(PerkEnum.NAVIGATOR_PHASE_TWO_2014)));
        }

        public function getPerkErrorMessage(k:String):String
        {
            return this._perkManager.getPerkErrorMessage(k);
        }

        public var currentTalentTrack(get,never):String;
public function  get_currentTalentTrack():String
        {
            return (getBoolean("talent.track.citizenship.enabled") && (!this.isPerkAllowed(PerkEnum.CITIZEN))) ? TalentEnum.CITIZENSHIP : TalentEnum.HELPER;
        }

        public var mysteryBoxColor(get,never):String;
public function  get_mysteryBoxColor():String
        {
            return this._mysteryBoxColor;
        }

        public var mysteryKeyColor(get,never):String;
public function  get_mysteryKeyColor():String
        {
            return this._mysteryKeyColor;
        }
    }

