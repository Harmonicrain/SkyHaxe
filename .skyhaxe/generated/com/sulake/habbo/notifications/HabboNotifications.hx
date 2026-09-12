package com.sulake.habbo.notifications
;
    import com.sulake.core.runtime.Component;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
	import com.sulake.habbo.notifications.singular.MOTDNotification;
	import com.sulake.habbo.notifications.singular.DiscordActivityDialog;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.notifications.utils.ProductImageUtility;
    import com.sulake.habbo.notifications.utils.PetImageUtility;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.help.IHabboHelp;
    import com.sulake.habbo.notifications.feed.NotificationController;
    import com.sulake.habbo.notifications.singular.SingularNotificationController;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboHelp;
    import com.sulake.habbo.communication.messages.outgoing.users.GetMOTDMessageComposer;
    import com.sulake.core.utils.Map;
    import adobe.serialization.json.JSONDecoder;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;

     class HabboNotifications extends Component implements IHabboNotifications 
    {
        var _communication:IHabboCommunicationManager;
        var _sessionDataManager:ISessionDataManager;
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _inventory:IHabboInventory;
        var _friendList:IHabboFriendsList;
        var _roomEngine:IRoomEngine;
        var _catalog:IHabboCatalog;
        var _toolBar:IHabboToolbar;
        var _productImageUtility:ProductImageUtility;
        var _petImageUtility:PetImageUtility;
        var _roomSessionManager:IRoomSessionManager;
        var _habboHelp:IHabboHelp;
        var _feedController:NotificationController;
        var _singularController:SingularNotificationController;
        var _incoming:IncomingMessages;
        var _disabled:Bool = false;
        var _discordActivityDialog:DiscordActivityDialog;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            super(k, _arg_2, _arg_3);
            this._disabled = false;
        }

        public var assetLibrary(get,never):IAssetLibrary;
public function  get_assetLibrary():IAssetLibrary
        {
            return assets;
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

        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var roomSessionManager(get,never):IRoomSessionManager;
public function  get_roomSessionManager():IRoomSessionManager
        {
            return this._roomSessionManager;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public var toolBar(get,never):IHabboToolbar;
public function  get_toolBar():IHabboToolbar
        {
            return this._toolBar;
        }

        public var habboHelp(get,never):IHabboHelp;
public function  get_habboHelp():IHabboHelp
        {
            return this._habboHelp;
        }

        public var singularController(get,never):SingularNotificationController;
public function  get_singularController():SingularNotificationController
        {
            return this._singularController;
        }

        public var feedController(get,never):NotificationController;
public function  get_feedController():NotificationController
        {
            return this._feedController;
        }

        
        public var disabled(get,set):Bool;
public function  get_disabled():Bool
        {
            return this._disabled;
        }
public function  set_disabled(k:Bool):Bool        {
            return this._disabled = k;
        }

        public var productImageUtility(get,never):ProductImageUtility;
public function  get_productImageUtility():ProductImageUtility
        {
            if (((this._roomEngine == null) || (this._inventory == null)))
            {
                return null;
            }
            if (this._productImageUtility == null)
            {
                this._productImageUtility = new ProductImageUtility(this._roomEngine, this._inventory);
            }
            return this._productImageUtility;
        }

        public var petImageUtility(get,never):PetImageUtility;
public function  get_petImageUtility():PetImageUtility
        {
            if (this._roomEngine == null)
            {
                return null;
            }
            if (this._petImageUtility == null)
            {
                this._petImageUtility = new PetImageUtility(this._roomEngine);
            }
            return this._petImageUtility;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboInventory(), function (k:IHabboInventory)
            {
                _inventory = k;
            }, false), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendList = k;
            }, false), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communication = k;
            }), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, false), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }, false, [{
                "type":CatalogEvent.CATALOG_BUILDER_MEMBERSHIP_EXPIRED,
                "callback":this.onBuilderMembershipExpired
            }, {
                "type":CatalogEvent.CATALOG_BUILDER_MEMBERSHIP_IN_GRACE,
                "callback":this.onBuilderMembershipInGrace
            }]), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolBar = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false), new ComponentDependency(new IIDHabboHelp(), function (k:IHabboHelp)
            {
                _habboHelp = k;
            })]));
        }

        override function initComponent()
        {
            this._singularController = new SingularNotificationController(this);
            this._incoming = new IncomingMessages(this, this._communication);
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._incoming != null)
            {
                this._incoming.dispose();
                this._incoming = null;
            }
            if (this._feedController != null)
            {
                this._feedController.dispose();
                this._feedController = null;
            }
            if (this._petImageUtility != null)
            {
                this._petImageUtility.dispose();
                this._petImageUtility = null;
            }
            if (this._productImageUtility != null)
            {
                this._productImageUtility.dispose();
                this._productImageUtility = null;
            }
            super.dispose();
        }

        public function activate()
        {
            if (this._feedController != null)
            {
                this._feedController.setFeedEnabled(true);
            }
            this._communication.connection.send(new GetMOTDMessageComposer());
        }

        public function addSongPlayingNotification(k:String, _arg_2:String)
        {
            this._singularController.addSongPlayingNotification(k, _arg_2);
        }

        public function addItem(message:String, style:String, iconAssetName:String=null, internalLink:String=null, extraData:ASObject=null)
        {
var asset:BitmapDataAsset  = null;            var icon:BitmapData = null;
            if (iconAssetName != null)
            {
asset= Std.downcast(this.assetLibrary.getAssetByName(iconAssetName) , BitmapDataAsset);
                if (asset != null && Std.is(asset.content , BitmapData))
                {
                    icon = ASCompat.dynamicAs(asset.content , BitmapData).clone();
                }
            }
            this._singularController.addItem(message, style, icon, null, null, internalLink, extraData);
        }

        public function removeNotificationById(id:String)
        {
            if (this._singularController != null)
            {
                this._singularController.removeNotificationById(id);
            }
        }

        public function showNotification(k:String, _arg_2:Map=null)
        {
var _local_5:String  = null;            var _local_4:ASObject = null;
            var _local_5:String = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8 = false;
            var _local_9:String = null;
            if (_arg_2 == null)
            {
                _arg_2 = new Map();
            }
            var _local_3= ("notification." + k);
            if (propertyExists(_local_3))
            {
                _local_4 = new JSONDecoder(getProperty(_local_3), true).getValue();
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4.___keys())
                {
_local_5 = _tmp_;
                    _arg_2.setProperty(_local_5, ASCompat.getDynamicProperty(_local_4, _local_5));
                }
            }
            if (_arg_2.getValue("display")== "BUBBLE")
            {
                _local_6 = this.getNotificationPart(_arg_2, k, "message", true);
                _local_7 = this.getNotificationPart(_arg_2, k, "linkUrl", false);
                _local_8 = ((!(_local_7 == null)) && (_local_7.substr(0, 6) == "event:"));
                _local_9 = this.getNotificationImageUrl(_arg_2, k);
                this._singularController.addItem(_local_6, NotificationType.INFO, null, _local_9, null, (_local_8 ? _local_7.substr(6) : _local_7));
            }
            else
            {
                new MOTDNotification(this, k, _arg_2);
            }
        }

        public function getNotificationPart(k:Map, _arg_2:String, _arg_3:String, _arg_4:Bool):String
        {
            var _local_5:String = null;
            if (k.hasKey(_arg_3))
            {
                return k.getValue(_arg_3);
            }
            _local_5 = (["notification", _arg_2, _arg_3] : Array<Dynamic>).join(".");
            if ((this.localization.hasLocalization(_local_5) || _arg_4))
            {
                return this.localization.getLocalizationWithParamMap(_local_5, _local_5, k);
            }
            return null;
        }

        public function getNotificationImageUrl(k:Map, _arg_2:String):String
        {
            var _local_3:String = k.getValue("image");
            if (_local_3 == null)
            {
                _local_3 = (("${image.library.url}notifications/" + new compat.RegExp("\\.", "g").replace(_arg_2, "_")) + ".png");
            }
            return _local_3;
        }

        function onBuilderMembershipInGrace(k:CatalogEvent)
        {
            this.showNotification("builders_club.membership_in_grace", null);
        }

        function onBuilderMembershipExpired(k:CatalogEvent)
        {
            this.showNotification("builders_club.membership_expired", null);
        }

        public function createLinkEvent(k:String)
        {
            context.createLinkEvent(k);
        }

        public function showDiscordActivityDialog()
        {
            if (!getBoolean("discord.enabled"))
            {
                return;
            }
            if (this._discordActivityDialog != null && !this._discordActivityDialog.disposed)
            {
                return;
            }
            this._discordActivityDialog = new DiscordActivityDialog(this);
        }
    }

