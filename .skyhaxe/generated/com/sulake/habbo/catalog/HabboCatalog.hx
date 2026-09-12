package com.sulake.habbo.catalog
;
	import com.sulake.habbo.catalog.purchase.FireworksChargeConfirmationDialog;
    import com.sulake.core.runtime.Component;
	import com.sulake.habbo.communication.messages.incoming.catalog.FireworkChargeDataEvent;
    import com.sulake.habbo.session.product.IProductDataListener;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.session.furniture.IFurniDataListener;
    import flash.geom.Point;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSessionManager;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.freeflowchat.IHabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.style.IChatStyle;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.inventory.IHabboInventory;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.navigator.IHabboNewNavigator;
    import com.sulake.habbo.avatar.IHabboAvatarEditor;
    import com.sulake.habbo.quest.IHabboQuestEngine;
    import com.sulake.habbo.catalog.viewer.CatalogViewer;
    import com.sulake.habbo.catalog.purse.Purse;
    import com.sulake.habbo.catalog.recycler.RecyclerLogic;
    import com.sulake.habbo.catalog.marketplace.IMarketPlace;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.purchase.PurchaseConfirmationDialog;
    import com.sulake.habbo.catalog.purchase.GiftWrappingConfiguration;
    import com.sulake.habbo.catalog.club.ClubGiftController;
    import com.sulake.habbo.catalog.club.ClubOfferHandler;
    import com.sulake.habbo.catalog.club.ClubExtendController;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.catalog.viewer.IDragAndDropDoneReceiver;
    import com.sulake.habbo.catalog.purchase.PlacedObjectPurchaseData;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import com.sulake.habbo.catalog.guilds.GuildMembershipsController;
    import com.sulake.habbo.catalog.targetedoffers.OfferController;
    import com.sulake.habbo.communication.messages.incoming.catalog.BundleDiscountRuleset;
    import com.sulake.habbo.catalog.navigation.RequestedPage;
    import com.sulake.habbo.catalog.purchase.RoomAdPurchaseData;
    import com.sulake.habbo.catalog.purchase.RentConfirmationWindow;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.communication.messages.incoming.catalog.FrontPageItem;
    import flash.utils.Timer;
    import com.sulake.habbo.catalog.offers.OfferCenter;
    import com.sulake.habbo.catalog.clubcenter.HabboClubCenter;
    import com.sulake.iid.IIDHabboClubCenter;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.navigator.IHabboNavigator;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboInventory;
    import com.sulake.habbo.inventory.events.HabboInventoryItemAddedEvent;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboSoundManager;
    import com.sulake.iid.IIDHabboRoomSessionManager;
    import com.sulake.iid.IIDHabboFreeFlowChat;
    import com.sulake.habbo.session.events.RoomSessionEvent;
    import com.sulake.iid.IIDHabboFriendList;
    import com.sulake.iid.IIDHabboNewNavigator;
    import com.sulake.iid.IIDHabboFriendBar;
    import com.sulake.habbo.friendbar.events.FriendBarSelectionEvent;
    import com.sulake.iid.IIDHabboGroupsManager;
    import com.sulake.habbo.groups.events.GuildSettingsChangedInManageEvent;
    import com.sulake.iid.IIDHabboAvatarEditor;
    import com.sulake.iid.IIDHabboQuestEngine;
    import com.sulake.habbo.communication.messages.incoming.users.ApproveNameMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseOKMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboActivityPointNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.VoucherRedeemOkMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerFinishedEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.GiftReceiverNotFoundEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.LimitedEditionSoldOutEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseNotAllowedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.GiftWrappingConfigurationEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.PurchaseErrorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.BundleDiscountRulesetMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPagesListEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketPlaceOffersEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceConfigurationEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.SellablePetPalettesMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketPlaceOwnOffersEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.BuildersClubSubscriptionStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceBuyOfferResultEvent;
    import com.sulake.habbo.communication.messages.incoming.notifications.ActivityPointsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPublishedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.CreditBalanceEvent;
    import com.sulake.habbo.communication.messages.incoming.users.GuildMembershipsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.HabboClubOffersMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrSendUserInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceMakeOfferResult;
    import com.sulake.habbo.communication.messages.incoming.catalog.ProductOfferEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceCancelOfferResultEvent;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerStatusEvent;
    import com.sulake.habbo.communication.messages.incoming.recycler.RecyclerPrizesEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceItemStatsEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.NotEnoughBalanceMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.HabboClubExtendOfferMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.BuildersClubFurniCountMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.VoucherRedeemErrorMessageEvent;
    import com.sulake.habbo.catalog.event.CatalogEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubQueryFurniCountMessageComposer;
    import com.sulake.habbo.catalog.navigation.ICatalogNavigator;
    import com.sulake.core.Core;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetCatalogPageComposer;
    import com.sulake.habbo.catalog.navigation.ICatalogNode;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseFromCatalogComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseRoomAdMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseVipMembershipExtensionComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseBasicMembershipExtensionComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.PurchaseFromCatalogAsGiftComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.ApproveNameMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.recycler.GetRecyclerStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.recycler.GetRecyclerPrizesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.recycler.RecycleItemsMessageComposer;
    import com.sulake.habbo.catalog.navigation.CatalogNavigator;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.club.ClubBuyOfferData;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habboclient.ExternalVariables;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.catalog.recycler.IRecycler;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceOffersMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetRoomAdPurchaseInfoComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.RoomAdPurchaseInitiatedComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceOwnOffersMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.BuyMarketplaceOfferMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.RedeemMarketplaceOfferCreditsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.CancelMarketplaceOfferMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.marketplace.GetMarketplaceItemStatsComposer;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetSellablePetPalettesComposer;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.window._enum._Str_8057;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.habbo.utils._Str_3942;
    import com.sulake.habbo.tracking.HabboTracking;
    import flash.events.Event;
    import com.sulake.habbo.catalog._enum.HabboCatalogTrackingEvent;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetCatalogIndexComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.MarkCatalogNewAdditionsPageOpenedComposer;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import com.sulake.habbo.catalog.viewer.PageLocalization;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetRoomChangedEvent;
    import com.sulake.habbo.catalog.marketplace.MarketPlaceLogic;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetGiftWrappingConfigurationComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetClubOffersMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageProductData;
    import com.sulake.habbo.catalog.viewer.IPageLocalization;
    import com.sulake.habbo.catalog.viewer.Product;
    import com.sulake.habbo.catalog.navigation.events.CatalogFurniPurchaseEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetApproveNameResultEvent;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import com.sulake.habbo.catalog.purse.PurseEvent;
    import com.sulake.habbo.catalog.purse.PurseUpdateEvent;
    import com.sulake.habbo.communication.messages.parser.users.ScrSendUserInfoMessageParser;
    import flash.external.ExternalInterface;
    import com.sulake.habbo.catalog.marketplace.MarketplaceItemStats;
    import com.sulake.habbo.catalog._enum.ClubOfferRequestSource;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetSellablePetPalettesEvent;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.habbo.communication.messages.outgoing.catalog.RedeemVoucherMessageComposer;
    import com.sulake.habbo.catalog._enum.BuilderFurniPlaceableStatus;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;
    import com.sulake.habbo.catalog.event.CatalogUserEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectPlacedOnUserEvent;
    import com.sulake.room.object.IRoomObjectController;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.room.object.data.LegacyStuffData;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceRoomItemMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceWallItemMessageComposer;
    import com.sulake.habbo.room.events.RoomEngineObjectPlacedEvent;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestRoomPropertySet;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.PlaceObjectMessageComposer;
    import flash.net.URLRequest;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetIsOfferGiftableComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetBundleDiscountRulesetComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetProductOfferComposer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetBuilderSubscriptionUpdatedEvent;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.habbo.utils._Str_6093;
    import com.sulake.habbo.catalog.offers.IOfferExtension;
    import com.sulake.habbo.catalog.offers.IOfferCenter;
    import com.sulake.habbo.catalog.habbicons.HabbiconController;
    import com.sulake.iid.*;

     class HabboCatalog extends Component implements IHabboCatalog implements  IProductDataListener implements  IUpdateReceiver implements  ILinkEventTracker implements  IFurniDataListener 
    {
        static inline final DESKTOP_WINDOW_LAYER:UInt = 1;
        static final DEFAULT_VIEW_LOCATION:Point = new Point(100, 20);
        static final DEFAULT_VIEW_LOCATION_LARGE:Point = new Point(100, 5);
        static inline final MAX_SEARCH_RESULTS_LENGTH:UInt = 200;
        static inline final NO_KNOWN_OFFER= -1;

        var _windowManager:IHabboWindowManager;
        var _communicationManager:IHabboCommunicationManager;
        var _toolbar:IHabboToolbar;
        var _roomEngine:IRoomEngine;
        var _roomSessionManager:IRoomSessionManager;
        var _roomSession:IRoomSession;
        var _freeFlowChat:IHabboFreeFlowChat;
        var _localization:IHabboLocalizationManager;
        var _inventory:IHabboInventory;
        var _sessionDataManager:ISessionDataManager;
        var _avatarRenderManager:IAvatarRenderManager;
        var _soundManager:IHabboSoundManager;
        var _friendsList:IHabboFriendsList;
        var _newNavigator:IHabboNewNavigator;
        var _avatarEditor:IHabboAvatarEditor;
        var _questEngine:IHabboQuestEngine;
        var _videoOfferManager:VideoOfferManager;
        var _initialized:Bool = false;
        var _productDataReady:Bool = false;
        var _catalogViewer:CatalogViewer;
        var _catalogNavigators:ASDictionary<ASAny,ASAny>;
        var _purse:Purse;
        var _recyclerLogic:RecyclerLogic;
        var _marketplace:IMarketPlace;
        var _mainContainer:IWindowContainer;
        var _purchaseConfirmationDialog:PurchaseConfirmationDialog;
        var _giftReceiver:String;
        var _skipToGifting:Bool = false;
        var _firstBalanceCredits:Bool = true;
        var _privateRoomSessionActive:Bool = false;
        var _giftWrappingConfiguration:GiftWrappingConfiguration;
        var _clubGiftController:ClubGiftController;
        var _clubOfferHandler:ClubOfferHandler;
        var _clubExtendController:ClubExtendController;
        var _sellablePetPalettes:Map;
        var _isObjectMoverRequested:Bool = false;
        var _purchasableOffer:IPurchasableOffer;
        var _Str_8970:IDragAndDropDoneReceiver;
        var _placedObjectPurchaseData:PlacedObjectPurchaseData;
        var _Str_7793:Bool = false;
        var _Str_19190:Bool = false;
        var _roomPreviewer:RoomPreviewer;
        var _guildMembershipsController:GuildMembershipsController;
        var _offerController:OfferController;
        var _utils:HabboCatalogUtils;
        var _doNotCloseAfterVipPurchase:Bool = false;
        var _pageToOpenAfterVipPurchase:String = null;
        var _bundleDiscountRuleset:BundleDiscountRuleset = null;
        var _requestedPage:RequestedPage;
        var _pageId:Int = 0;
        var _roomAdPurchaseData:RoomAdPurchaseData;
        var _rentConfirmationWindow:RentConfirmationWindow;
        var _messageEvents:Vector<IMessageEvent>;
        var _catalogType:String = "NORMAL";
        var _furnitureData:Vector<IFurnitureData>;
        var _frontPageItems:Vector<FrontPageItem>;
        var _keyUpSearchTimer:Timer;
        var _pagesVisibleInBuilderMode:ASDictionary<ASAny,ASAny>;
        var _placeMultipleObjects:Bool = false;
        var _builderFurniCount:Int = -1;
        var _builderFurniLimit:Int = 0;
        var _builderMaxFurniLimit:Int = 0;
        var _builderMembershipSecondsLeft:Int = 0;
        var _builderMembershipSecondsLeftWithGrace:Int = 0;
        var _builderMembershipUpdateTime:Int = 0;
        var _builderMembershipDisplayUpdateTime:Int = 0;
        var _builderMembershipActiveSoFar:Bool = false;
        var _builderMembershipActiveWithGrace:Bool = false;
        var _offerCenter:OfferCenter;
		var _fireworkChargeDialog:FireworksChargeConfirmationDialog;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._sellablePetPalettes = new Map();
            super(k, _arg_2, _arg_3);
            this._purse = new Purse();
            this._utils = new HabboCatalogUtils(this);
            registerUpdateReceiver(this, 1);
            this._requestedPage = new RequestedPage();
            k.attachComponent(new HabboClubCenter(k, 0, _arg_3), [new IIDHabboClubCenter()]);
            k.attachComponent(new HabbiconController(k, 0, _arg_3), [new IIDHabbiconController()]);
        }

        public static function setElementImageCentered(k:IWindow, _arg_2:BitmapData, _arg_3:Int=0)
        {
            var _local_7:IBitmapWrapperWindow = null;
            var _local_8:IDisplayObjectWrapper = null;
            if (_arg_2 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (k.disposed)
            {
                return;
            }
            var _local_4= ((_arg_3 > 0) ? _arg_3 : k.height);
            var _local_5= Std.int((k.width - _arg_2.width) / 2);
            var _local_6= Std.int((_local_4 - _arg_2.height) / 2);
            if (Std.downcast(k , IBitmapWrapperWindow) != null)
            {
                _local_7 = cast(k, IBitmapWrapperWindow);
                if (((_local_7.bitmap == null) || (_arg_3 > 0)))
                {
                    _local_7.bitmap = new BitmapData(k.width, _local_4, true, 0xFFFFFF);
                }
                _local_7.bitmap.fillRect(_local_7.bitmap.rect, 0xFFFFFF);
                _local_7.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(_local_5, _local_6), null, null, false);
                k.invalidate();
            }
            else
            {
                if (Std.downcast(k , IDisplayObjectWrapper) != null)
                {
                    _local_8 = cast(k, IDisplayObjectWrapper);
                    _local_8.setDisplayObject(new Bitmap(_arg_2));
                    k.invalidate();
                }
            }
        }


        public var sessionDataManager(get,never):ISessionDataManager;
public function  get_sessionDataManager():ISessionDataManager
        {
            return this._sessionDataManager;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return this._localization;
        }

        public var windowManager(get,never):IHabboWindowManager;
public function  get_windowManager():IHabboWindowManager
        {
            return this._windowManager;
        }

        public var connection(get,never):IConnection;
public function  get_connection():IConnection
        {
            return this._communicationManager.connection;
        }

        public var toolbar(get,never):IHabboToolbar;
public function  get_toolbar():IHabboToolbar
        {
            return this._toolbar;
        }

        public var giftWrappingConfiguration(get,never):GiftWrappingConfiguration;
public function  get_giftWrappingConfiguration():GiftWrappingConfiguration
        {
            return this._giftWrappingConfiguration;
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

        public var roomPreviewer(get,never):RoomPreviewer;
public function  get_roomPreviewer():RoomPreviewer
        {
            if (this._roomPreviewer == null)
            {
                this.initializeRoomPreviewer();
            }
            return this._roomPreviewer;
        }

        public var navigator(get,never):IHabboNavigator;
public function  get_navigator():IHabboNavigator
        {
            return this._newNavigator.legacyNavigator;
        }

        public var utils(get,never):HabboCatalogUtils;
public function  get_utils():HabboCatalogUtils
        {
            return this._utils;
        }

        public var questEngine(get,never):IHabboQuestEngine;
public function  get_questEngine():IHabboQuestEngine
        {
            return this._questEngine;
        }

        public var videoOffers(get,never):IVideoOfferManager;
public function  get_videoOffers():IVideoOfferManager
        {
            return this._videoOfferManager;
        }

        public var frontPageItems(get,never):Vector<FrontPageItem>;
public function  get_frontPageItems():Vector<FrontPageItem>
        {
            return this._frontPageItems;
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            }, false, [{
                "type":HabboToolbarEvent.HTE_TOOLBAR_CLICK,
                "callback":this.onHabboToolbarEvent
            }]), new ComponentDependency(new IIDRoomEngine(), function (k:IRoomEngine)
            {
                _roomEngine = k;
            }, false, [{
                "type":RoomEngineObjectEvent.PLACED,
                "callback":this.onObjectPlacedInRoom
            }, {
                "type":RoomEngineObjectEvent.PLACED_ON_USER,
                "callback":this.onObjectPlaceOnUser
            }, {
                "type":RoomEngineObjectEvent.SELECTED,
                "callback":this.onObjectSelected
            }]), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localization = k;
            }, false), new ComponentDependency(new IIDHabboInventory(), function (k:IHabboInventory)
            {
                _inventory = k;
            }, false, [{
                "type":HabboInventoryItemAddedEvent.HABBO_INVENTORY_ITEM_ADDED,
                "callback":this.onItemAddedToInventory
            }]), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }, false), new ComponentDependency(new IIDHabboSoundManager(), function (k:IHabboSoundManager)
            {
                _soundManager = k;
            }, false), new ComponentDependency(new IIDHabboRoomSessionManager(), function (k:IRoomSessionManager)
            {
                _roomSessionManager = k;
            }, false, [{
                "type":RoomSessionEvent.STARTED,
                "callback":this.onRoomSessionEvent
            }, {
                "type":RoomSessionEvent.ENDED,
                "callback":this.onRoomSessionEvent
            }]), new ComponentDependency(new IIDHabboFreeFlowChat(), function (k:IHabboFreeFlowChat)
            {
                _freeFlowChat = k;
            }, false), new ComponentDependency(new IIDHabboFriendList(), function (k:IHabboFriendsList)
            {
                _friendsList = k;
            }, false), new ComponentDependency(new IIDHabboNewNavigator(), function (k:IHabboNewNavigator)
            {
                _newNavigator = k;
            }, false), new ComponentDependency(new IIDHabboFriendBar(), null, false, [{
                "type":FriendBarSelectionEvent.FBVE_FRIEND_SELECTED,
                "callback":this.onFriendBarSelectionEvent
            }]), new ComponentDependency(new IIDHabboGroupsManager(), null, false, [{
                "type":GuildSettingsChangedInManageEvent.GSCIME_GUILD_VISUAL_SETTINGS_CHANGED,
                "callback":this.onGuildVisualSettingsChanged
            }]), new ComponentDependency(new IIDHabboAvatarEditor(), function (k:IHabboAvatarEditor)
            {
                _avatarEditor = k;
            }, false), new ComponentDependency(new IIDHabboQuestEngine(), function (k:IHabboQuestEngine)
            {
                _questEngine = k;
            }, false)]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new ApproveNameMessageEvent(this.onApproveNameResult));
            this.addMessageEvent(new PurchaseOKMessageEvent(this.onPurchaseOK));
            this.addMessageEvent(new HabboActivityPointNotificationMessageEvent(this.onActivityPointNotification));
            this.addMessageEvent(new VoucherRedeemOkMessageEvent(this.onVoucherRedeemOk));
            this.addMessageEvent(new RecyclerFinishedEvent(this.onRecyclerFinished));
            this.addMessageEvent(new GiftReceiverNotFoundEvent(this.onGiftReceiverNotFound));
            this.addMessageEvent(new LimitedEditionSoldOutEvent(this.onLimitedEditionSoldOut));
            this.addMessageEvent(new PurchaseNotAllowedMessageEvent(this.onPurchaseNotAllowed));
            this.addMessageEvent(new GiftWrappingConfigurationEvent(this.onGiftWrappingConfiguration));
            this.addMessageEvent(new PurchaseErrorMessageEvent(this.onPurchaseError));
            this.addMessageEvent(new BundleDiscountRulesetMessageEvent(this.onBundleDiscountRulesetMessageEvent));
            this.addMessageEvent(new CatalogPagesListEvent(this.onCatalogIndex));
            this.addMessageEvent(new MarketPlaceOffersEvent(this.onMarketPlaceOffers));
            this.addMessageEvent(new CatalogPageMessageEvent(this.onCatalogPage));
            this.addMessageEvent(new MarketplaceConfigurationEvent(this.onMarketplaceConfiguration));
            this.addMessageEvent(new CloseConnectionMessageEvent(this.onRoomExit));
            this.addMessageEvent(new SellablePetPalettesMessageEvent(this.onSellablePalettes));
            this.addMessageEvent(new MarketPlaceOwnOffersEvent(this.onMarketPlaceOwnOffers));
            this.addMessageEvent(new BuildersClubSubscriptionStatusMessageEvent(this.onBuildersClubSubscriptionStatus));
            this.addMessageEvent(new MarketplaceBuyOfferResultEvent(this.onMarketPlaceBuyResult));
            this.addMessageEvent(new ActivityPointsMessageEvent(this.onActivityPoints));
            this.addMessageEvent(new CatalogPublishedMessageEvent(this.onCatalogPublished));
            this.addMessageEvent(new CreditBalanceEvent(this.onCreditBalance));
            this.addMessageEvent(new GuildMembershipsMessageEvent(this.onGuildMemberships));
            this.addMessageEvent(new ClubGiftInfoEvent(this.onClubGiftInfo));
            this.addMessageEvent(new HabboClubOffersMessageEvent(this.onHabboClubOffers));
            this.addMessageEvent(new ScrSendUserInfoEvent(this.onSubscriptionInfo));
            this.addMessageEvent(new MarketplaceMakeOfferResult(this.onMarketplaceMakeOfferResult));
            this.addMessageEvent(new ProductOfferEvent(this.onProductOffer));
            this.addMessageEvent(new MarketplaceCancelOfferResultEvent(this.onMarketPlaceCancelResult));
            this.addMessageEvent(new RecyclerStatusEvent(this._Str_24950));
            this.addMessageEvent(new RecyclerPrizesEvent(this._Str_23749));
            this.addMessageEvent(new MarketplaceItemStatsEvent(this.onMarketplaceItemStats));
            this.addMessageEvent(new NotEnoughBalanceMessageEvent(this.onNotEnoughBalance));
            this.addMessageEvent(new HabboClubExtendOfferMessageEvent(this.onHabboClubExtendOffer));
            this.addMessageEvent(new BuildersClubFurniCountMessageEvent(this.onBuildersClubFurniCount));
            this.addMessageEvent(new VoucherRedeemErrorMessageEvent(this.onVoucherRedeemError));
			this.addMessageEvent(new FireworkChargeDataEvent(this.onFireworkChargeHandler));
            context.addLinkEventTracker(this);
            this._sessionDataManager.loadProductData(this);
            this._Str_19190 = this.isNewItemsNotificationEnabled();
            this._videoOfferManager = new VideoOfferManager(this);
            this._offerController = new OfferController(this);
            this._furnitureData = this._sessionDataManager.getFurniData(this);
            this._pagesVisibleInBuilderMode = null;
        }

        function addMessageEvent(k:IMessageEvent)
        {
            this._messageEvents.push(this._communicationManager.addHabboConnectionMessageEvent(k));
        }

        override public function dispose()
        {
            var k:IMessageEvent = null;
            if (disposed)
            {
                return;
            }
            removeUpdateReceiver(this);
            if (((!(this._messageEvents == null)) && (!(this._communicationManager == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communicationManager.removeHabboConnectionMessageEvent(k);
                }
            }
            if (this._videoOfferManager != null)
            {
                this._videoOfferManager.dispose();
                this._videoOfferManager = null;
            }
            if (this._offerCenter != null)
            {
                this._offerCenter.dispose();
                this._offerCenter = null;
            }
            this.reset(true);
            context.removeLinkEventTracker(this);
            if (this._purchaseConfirmationDialog != null)
            {
                this._purchaseConfirmationDialog.dispose();
                this._purchaseConfirmationDialog = null;
            }
            if (this._recyclerLogic != null)
            {
                this._recyclerLogic.dispose();
                this._recyclerLogic = null;
            }
            this._purse = null;
            this._marketplace = null;
            if (this._clubOfferHandler != null)
            {
                this._clubOfferHandler.dispose();
                this._clubOfferHandler = null;
            }
            if (this._clubExtendController != null)
            {
                this._clubExtendController.dispose();
                this._clubExtendController = null;
            }
            if (this._sellablePetPalettes != null)
            {
                this._sellablePetPalettes.dispose();
                this._sellablePetPalettes = null;
            }
            this._roomSession = null;
            if (this._rentConfirmationWindow != null)
            {
                this._rentConfirmationWindow.dispose();
                this._rentConfirmationWindow = null;
            }
            this.resetPlacedOfferData();
            this._isObjectMoverRequested = false;
            this._Str_8970 = null;
            if (this._roomPreviewer != null)
            {
                this._roomPreviewer.dispose();
                this._roomPreviewer = null;
            }
            if (this._guildMembershipsController != null)
            {
                this._guildMembershipsController.dispose();
                this._guildMembershipsController = null;
            }
            if (this._utils != null)
            {
                this._utils.dispose();
                this._utils = null;
            }
            if (this._requestedPage != null)
            {
                this._requestedPage = null;
            }
            if (this._offerController != null)
            {
                this._offerController.dispose();
                this._offerController = null;
            }
            super.dispose();
        }

        function init():Bool
        {
            if (((!this._initialized) && this._productDataReady))
            {
                this.createMainWindow();
                this.createCatalogNavigators();
                this.createCatalogViewer();
                this._initialized = true;
                this.updatePurse();
                this._Str_24043();
                this.createMarketPlace();
                this.createClubGiftController();
                this.getGiftWrappingConfiguration();
                this.createClubBuyController();
                this.createClubExtendController();
                this.createGroupMembershipsController();
                this.initBundleDiscounts();
                events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_INITIALIZED));
                this.send(new BuildersClubQueryFurniCountMessageComposer());
                return true;
            }
            return false;
        }

        function reset(k:Bool=false)
        {
            var _local_2:ICatalogNavigator = null;
            var _local_3 = false;
            this._initialized = false;
            if (this._catalogViewer != null)
            {
                this._catalogViewer.dispose();
                this._catalogViewer = null;
            }
            if (this._catalogNavigators != null)
            {
                final _iter_ = this._catalogNavigators; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                }
                this._catalogNavigators = null;
            }
            if (this._mainContainer != null)
            {
                this._mainContainer.dispose();
                this._mainContainer = null;
            }
            if (!k)
            {
                if (this._sessionDataManager == null)
                {
                    Core.crash("Could not reload product data after reset() because _sessionDataManager was null", Core.ERROR_CATEGORY_PRODUCT_DATA);
                    return;
                }
                _local_3 = this._sessionDataManager.loadProductData(this);
                if (_local_3)
                {
                    this.init();
                }
                else
                {
                    events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_NOT_READY));
                }
            }
        }

        function send(k:IMessageComposer)
        {
            if (this.connection == null)
            {
                return;
            }
            this.connection.send(k);
        }

        public function loadCatalogPage(k:Int, _arg_2:Int, _arg_3:String)
        {
            this.isBusy = true;
            this._pageId = k;
            this.send(new GetCatalogPageComposer(k, _arg_2, _arg_3));
        }

        public function purchaseOffer(k:Int, _arg_2:String="", _arg_3:Int=1)
        {
            var _local_5:Vector<ICatalogNode> = null;
            var _local_4= this.getCatalogNavigator(CatalogType.NORMAL);
            if (_local_4 != null)
            {
                _local_5 = _local_4.getNodesByOfferId(k, true);
                if (_local_5 != null)
                {
                    this.purchaseProduct(_local_5[0].pageId, k, _arg_2, _arg_3);
                }
            }
        }

        public function purchaseProduct(k:Int, _arg_2:Int, _arg_3:String="", _arg_4:Int=1)
        {
            if (((this.roomAdPurchaseData == null) || (!(this.roomAdPurchaseData.offerId == _arg_2))))
            {
                this.send(new PurchaseFromCatalogComposer(k, _arg_2, _arg_3, _arg_4));
            }
            else
            {
                if ((this._roomAdPurchaseData._Str_8314 && (this._roomAdPurchaseData.expirationTime.getTime() < Date.now().getTime())))
                {
                    this._roomAdPurchaseData._Str_8314 = false;
                }
                this.send(new PurchaseRoomAdMessageComposer(k, _arg_2, this.roomAdPurchaseData.flatId, this.roomAdPurchaseData.name, this.roomAdPurchaseData._Str_8314, this.roomAdPurchaseData.description, this.roomAdPurchaseData.categoryId));
            }
        }

        public function purchaseVipMembershipExtension(k:Int)
        {
            this.send(new PurchaseVipMembershipExtensionComposer(k));
        }

        public function purchaseBasicMembershipExtension(k:Int)
        {
            this.send(new PurchaseBasicMembershipExtensionComposer(k));
        }

        public function purchaseProductAsGift(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Bool=false)
        {
            this.send(new PurchaseFromCatalogAsGiftComposer(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9));
        }

        
        public var roomAdPurchaseData(get,set):RoomAdPurchaseData;
public function  get_roomAdPurchaseData():RoomAdPurchaseData
        {
            return this._roomAdPurchaseData;
        }
public function  set_roomAdPurchaseData(k:RoomAdPurchaseData):RoomAdPurchaseData        {
            return this._roomAdPurchaseData = k;
        }

        public function approveName(k:String, _arg_2:Int)
        {
            this.send(new ApproveNameMessageComposer(k, _arg_2));
        }

        public function getRecyclerStatus()
        {
            this.send(new GetRecyclerStatusMessageComposer());
        }

        public function getRecyclerPrizes()
        {
            this.send(new GetRecyclerPrizesMessageComposer());
        }

        public function sendRecycleItems(k:Array<ASAny>)
        {
            this.send(new RecycleItemsMessageComposer(k));
        }

        public var giftReceiver(never,set):String;
public function  set_giftReceiver(k:String):String        {
            return this._giftReceiver = k;
        }

        public function getSeasonalCurrencyActivityPointType():Int
        {
            return getInteger("seasonalcurrencyindicator.currency", 1);
        }
		
		public function buySnowWarTokensOffer()
        {
            /*if (this._SafeStr_6561 != null)
            {
                this._SafeStr_6635(this._SafeStr_6561, -1, "");
            }
            else
            {
                this._SafeStr_6307.connection.send(new _SafeStr_2201());
            };*/
			//TODO: Snowstorm. Possibly related to buying game tokens.
        }

        public function showPurchaseConfirmation(k:IPurchasableOffer, _arg_2:Int, _arg_3:String="", _arg_4:Int=1, _arg_5:IStuffData=null, _arg_6:String=null, _arg_7:Bool=true, _arg_8:BitmapData=null)
        {
            var _local_11:Vector<ICatalogNode> = null;
            var _local_12:Array<ASAny> = null;
            var _local_13:String = null;
            var _local_14:ICatalogNode = null;
            if (_arg_2 == CatalogNavigator.DUMMY_PAGE_ID_FOR_OFFER_SEARCH)
            {
                _local_11 = this.currentCatalogNavigator.getNodesByOfferId(k.offerId, true);
                if (_local_11 != null)
                {
                    _arg_2 = _local_11[0].pageId;
                }
            }
            Logger.log([("buy: " + ASCompat.toString([_arg_4, k.offerId, _arg_3]))]);
            var _local_9= k.priceInCredits;
            var _local_10= k.priceInActivityPoints;
            if (this.multiplePurchaseEnabled)
            {
                _local_9 = this._utils._Str_4488(true, k.priceInCredits, _arg_4);
                _local_10 = this._utils._Str_4488(true, k.priceInActivityPoints, _arg_4);
            }
            if (((_local_9 > 0) && (_local_9 > this._purse.credits)))
            {
                this.showNotEnoughCreditsAlert();
                return;
            }
            if (((_local_10 > 0) && (_local_10 > this._purse.getActivityPointsForType(k.activityPointType))))
            {
                this.showNotEnoughActivityPointsAlert(k.activityPointType);
                return;
            }
            if ((Std.is(k , Offer) || this._skipToGifting))
            {
                if (((this._purchaseConfirmationDialog == null) || this._purchaseConfirmationDialog.disposed))
                {
                    this._purchaseConfirmationDialog = new PurchaseConfirmationDialog(this._localization, assets);
                }
                _local_12 = [];
                if (this._friendsList != null)
                {
                    _local_12 = this._friendsList.getFriendNames();
                }
                _local_13 = _arg_6;
                if (_local_13 == null)
                {
                    if (this._giftReceiver != null)
                    {
                        _local_13 = this._giftReceiver;
                    }
                }
                this._purchaseConfirmationDialog._Str_6059(this, this._roomEngine, k, _arg_2, _arg_3, _arg_4, _arg_5, _local_12, _local_13, _arg_8);
            }
            else
            {
                if (Std.is(k , ClubBuyOfferData))
                {
                    if (_arg_2 == -1)
                    {
                        _local_14 = this.currentCatalogNavigator.getNodeByName(CatalogPageName.HC_MEMBERSHIP);
                        if (_local_14 != null)
                        {
                            _arg_2 = _local_14.pageId;
                        }
                    }
                    if (_arg_2 >= 0)
                    {
                        this._clubOfferHandler.showConfirmation(Std.downcast(k , ClubBuyOfferData), _arg_2);
                    }
                }
            }
            if (this._skipToGifting)
            {
                this._skipToGifting = false;
                this._purchaseConfirmationDialog.turnIntoGifting();
            }
        }

        public function purchaseWillBeGift(k:Bool)
        {
            this._skipToGifting = k;
        }

        function initializeRoomPreviewer()
        {
            if ((((!(this._roomEngine == null)) && this._roomEngine.isInitialized) && getBoolean("catalog.furniture.animation")))
            {
                if (this._roomPreviewer == null)
                {
                    this._roomPreviewer = new RoomPreviewer(this._roomEngine);
                }
            }
        }

        function isNewItemsNotificationEnabled():Bool
        {
            return getBoolean("toolbar.new_additions.notification.enabled");
        }

        public function openCatalog()
        {
            this.cancelFurniInMover();
            this.toggleCatalog(CatalogType.NORMAL, true);
        }

        public function openCatalogPage(k:String, _arg_2:String=null)
        {
            this.cancelFurniInMover();
            this.toggleCatalog(((_arg_2 == null) ? CatalogType.NORMAL : _arg_2), true, false);
            if ((((!this._initialized) || (this._catalogNavigators == null)) || (!this.currentCatalogNavigator.initialized)))
            {
                this._requestedPage.requestByName = k;
                return;
            }
            this.currentCatalogNavigator.openPage(k);
        }

        public function openRoomAdCatalogPageInExtendedMode(k:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Date, _arg_6:Int)
        {
            var _local_7= this._pageId;
            this._roomAdPurchaseData = new RoomAdPurchaseData();
            this._roomAdPurchaseData.name = _arg_2;
            this._roomAdPurchaseData._Str_8314 = true;
            this._roomAdPurchaseData._Str_16649 = this._roomEngine.activeRoomId;
            this._roomAdPurchaseData.description = _arg_3;
            this._roomAdPurchaseData.flatId = this._roomEngine.activeRoomId;
            this._roomAdPurchaseData.roomName = _arg_4;
            this._roomAdPurchaseData.expirationTime = _arg_5;
            this._roomAdPurchaseData.categoryId = _arg_6;
            this.openCatalogPage(k);
            var _local_8= this.currentCatalogNavigator.getNodeByName(k);
            if (((!(_local_8 == null)) && (_local_8.pageId == _local_7)))
            {
                this.getRoomAdsPurchaseInfo();
            }
        }

        public function openCatalogPageByOfferId(k:Int, _arg_2:String)
        {
            this.openCatalogPageById(CatalogNavigator.DUMMY_PAGE_ID_FOR_OFFER_SEARCH, k, _arg_2);
        }

        public function openCatalogPageById(k:Int, _arg_2:Int, _arg_3:String)
        {
            if (((this._initialized && (!(this._catalogNavigators == null))) && this.getCatalogNavigator(_arg_3).initialized))
            {
                this.toggleCatalog(_arg_3, true, false);
                this._catalogViewer._Str_21608();
                this.currentCatalogNavigator.openPageById(k, _arg_2);
            }
            else
            {
                this.toggleCatalog(_arg_3);
                this._requestedPage.requestById = k;
                this._requestedPage.requestedOfferId = _arg_2;
            }
        }

        public function openInventoryCategory(k:String)
        {
            if (this._inventory == null)
            {
                return;
            }
            this._inventory.toggleInventoryPage(k);
        }

        public function openCreditsHabblet()
        {
            HabboWebTools.openWebPageAndMinimizeClient(getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
        }

        public function setupInventoryForRecycler(k:Bool)
        {
            if (this._inventory == null)
            {
                return;
            }
            this._inventory._Str_20251(k);
        }

        public var privateRoomSessionActive(get,never):Bool;
public function  get_privateRoomSessionActive():Bool
        {
            return this._privateRoomSessionActive;
        }

        public var tradingActive(get,never):Bool;
public function  get_tradingActive():Bool
        {
            if (this._inventory == null)
            {
                return false;
            }
            return this._inventory.tradingActive;
        }

        public function requestInventoryFurniToRecycler():Int
        {
            if (this._inventory == null)
            {
                return 0;
            }
            return this._inventory._Str_15313();
        }

        public function returnInventoryFurniFromRecycler(k:Int):Bool
        {
            if (this._inventory == null)
            {
                return false;
            }
            return this._inventory.returnInventoryFurniFromRecycler(k);
        }

        public function getProductData(k:String):IProductData
        {
            return this._sessionDataManager.getProductData(k);
        }

        public function getFurnitureData(k:Int, _arg_2:String):IFurnitureData
        {
            var _local_3:IFurnitureData = null;
            if (_arg_2 == ProductTypeEnum.FLOOR)
            {
                _local_3 = this._sessionDataManager.getFloorItemData(k);
            }
            if (_arg_2 == ProductTypeEnum.WALL)
            {
                _local_3 = this._sessionDataManager.getWallItemData(k);
            }
            return _local_3;
        }

        public function getFurnitureDataByName(k:String, _arg_2:String, _arg_3:Int=0):IFurnitureData
        {
            var _local_4:IFurnitureData = null;
            if (this._sessionDataManager == null)
            {
                return null;
            }
            if (_arg_2 == ProductTypeEnum.FLOOR)
            {
                _local_4 = this._sessionDataManager.getFloorItemDataByName(k);
            }
            if (_arg_2 == ProductTypeEnum.WALL)
            {
                _local_4 = this._sessionDataManager.getWallItemDataByName(k);
            }
            return _local_4;
        }

        public function getPurse():IPurse
        {
            return this._purse;
        }

        public function getRecycler():IRecycler
        {
            return this._recyclerLogic;
        }

        public function getMarketPlace():IMarketPlace
        {
            return this._marketplace;
        }

        public function getClubGiftController():ClubGiftController
        {
            return this._clubGiftController;
        }

        public function getClubBuyController():ClubOfferHandler
        {
            return this._clubOfferHandler;
        }

        public function getClubExtendController():ClubExtendController
        {
            return this._clubExtendController;
        }

        public function getPublicMarketPlaceOffers(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            this.send(new GetMarketplaceOffersMessageComposer(k, _arg_2, _arg_3, _arg_4));
        }

        public function getRoomAdsPurchaseInfo()
        {
            this.send(new GetRoomAdPurchaseInfoComposer());
        }

        public function sendRoomAdPurchaseInitiatedEvent()
        {
            this.send(new RoomAdPurchaseInitiatedComposer());
        }

        public function getOwnMarketPlaceOffers()
        {
            this.send(new GetMarketplaceOwnOffersMessageComposer());
        }

        public function buyMarketPlaceOffer(k:Int)
        {
            this.send(new BuyMarketplaceOfferMessageComposer(k));
        }

        public function redeemSoldMarketPlaceOffers()
        {
            this.send(new RedeemMarketplaceOfferCreditsMessageComposer());
        }

        public function redeemExpiredMarketPlaceOffer(k:Int)
        {
            this.send(new CancelMarketplaceOfferMessageComposer(k));
        }

        public function getMarketplaceItemStats(k:Int, _arg_2:Int)
        {
            if (this._communicationManager == null)
            {
                return;
            }
            this.send(new GetMarketplaceItemStatsComposer(k, _arg_2));
        }

        public function getGroupMembershipsController():GuildMembershipsController
        {
            return this._guildMembershipsController;
        }

        public function getPixelEffectIcon(k:Int):BitmapData
        {
            var _local_2= Std.downcast(ASCompat.reinterpretAs(this._inventory , Component).assets.getAssetByName((("fx_icon_" + Std.string(k)) + "_png")) , BitmapDataAsset);
            if (((!(_local_2 == null)) && (!(_local_2.content == null))))
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData).clone();
            }
            return new BitmapData(1, 1, true, 0xFFFFFF);
        }

        public function createChatStylePreview(k:Int):BitmapData
        {
            var _local_2:IChatStyle = null;
            if (((this._freeFlowChat == null) || (this._freeFlowChat.chatStyleLibrary == null)))
            {
                return new BitmapData(1, 1, true, 0);
            }
            _local_2 = this._freeFlowChat.chatStyleLibrary.getStyle(k);
            if (((_local_2 == null) || (_local_2.selectorPreview == null)))
            {
                return new BitmapData(1, 1, true, 0);
            }
            return _local_2.selectorPreview.clone();
        }

        public function createChatStyleBubblePreview(k:Int):BitmapData
        {
            if (this._freeFlowChat == null)
            {
                return new BitmapData(1, 1, true, 0);
            }
            var _local_2= this._freeFlowChat.createChatStylePreviewBitmap(k, this._sessionDataManager.userName, this._sessionDataManager.figure, "");
            return ((_local_2 == null) ? new BitmapData(1, 1, true, 0) : _local_2);
        }

        public function getSubscriptionProductIcon(k:Int):BitmapData
        {
            var _local_2= Std.downcast(assets.getAssetByName("icon_hc") , BitmapDataAsset);
            if (_local_2 != null)
            {
                return ASCompat.dynamicAs(_local_2.content , BitmapData).clone();
            }
            return new BitmapData(1, 1, true, 0xFFFFFF);
        }

        public function getSellablePetPalettes(k:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = this._sellablePetPalettes.getValue(k);
            if (_local_2 != null)
            {
                return _local_2.slice(0);
            }
            this.send(new GetSellablePetPalettesComposer(k));
            return null;
        }

        function updatePurse()
        {
            var _local_2:String = null;
            if (this._mainContainer == null)
            {
                return;
            }
            this._localization.registerParameter("catalog.purse.creditbalance", "balance", Std.string(this._purse.credits));
            this._localization.registerParameter("catalog.purse.pixelbalance", "balance", Std.string(this._purse.getActivityPointsForType(ActivityPointTypeEnum.DUCKET)));
            var k= _Str_8057._Str_17515;
            if (!this._purse.hasClubLeft)
            {
                _local_2 = "catalog.purse.club.join";
            }
            else
            {
                if (this._purse.isVIP)
                {
                    _local_2 = "catalog.purse.vipdays";
                    k = _Str_8057._Str_16032;
                }
                else
                {
                    _local_2 = "catalog.purse.clubdays";
                }
                this._localization.registerParameter(_local_2, "days", Std.string(this._purse.clubDays));
                this._localization.registerParameter(_local_2, "months", Std.string(this._purse.clubPeriods));
            }
            var _local_3= Std.downcast(this._mainContainer.findChildByName("clubIcon") , IIconWindow);
            if (_local_3 != null)
            {
                _local_3.style = k;
            }
            var _local_4= Std.downcast(this._mainContainer.findChildByName("clubText") , ITextWindow);
            if (_local_4 != null)
            {
                _local_4.caption = this._localization.getLocalization(_local_2);
            }
        }

        function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type != HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                return;
            }
            switch (k.iconId)
            {
                case HabboToolbarIconEnum.CATALOGUE:
                    this.toggleCatalog(CatalogType.NORMAL);
                    return;
                case HabboToolbarIconEnum.BUILDER:
                    this.toggleCatalog(CatalogType.BUILDER);
                    return;
            }
        }

        function setElementColour(k:String, _arg_2:Int)
        {
            if (this._mainContainer == null)
            {
                return;
            }
            var _local_3= this._mainContainer.findChildByName(k);
            if (_local_3 != null)
            {
                _local_3.color = _arg_2;
            }
        }

        public var buildersClubEnabled(get,never):Bool;
public function  get_buildersClubEnabled():Bool
        {
            return getBoolean("builders.club.enabled");
        }

        public function toggleCatalog(k:String, _arg_2:Bool=false, _arg_3:Bool=true)
        {
            var _local_5:ITextFieldWindow = null;
            if (((!this._sessionDataManager.hasSecurity(SecurityLevelEnum.MODERATOR)) && (!this.buildersClubEnabled)))
            {
                k = CatalogType.NORMAL;
            }
            var _local_4:ASAny = (!(k == this._catalogType));
            this._catalogType = k;
            this.cancelFurniInMover();
            if (this._mainContainer == null)
            {
                if (this.init() == false)
                {
                    return;
                }
            }
            if (((this.currentCatalogNavigator == null) || (!this.currentCatalogNavigator.initialized)))
            {
                this.refreshCatalogIndex(this._catalogType);
            }
            if ((((!this.mainWindowVisible()) || _arg_2) || ASCompat.toBool(_local_4)))
            {
                if (this._Str_7793)
                {
                    this._Str_7793 = false;
                    events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_NEW_ITEMS_HIDE));
                    this.markNewAdditionPageOpened();
                }
                this.showMainWindow();
            }
            else
            {
                if (!_Str_3942._Str_9211(this._mainContainer))
                {
                    this.hideMainWindow();
                }
            }
            if (this.mainWindowVisible())
            {
                if (this._mainContainer != null)
                {
                    this._mainContainer.activate();
                    _local_5 = Std.downcast(this._mainContainer.findChildByName("search.input") , ITextFieldWindow);
                    if (_local_5 != null)
                    {
                        _local_5.focus();
                        _local_5.setSelection(0, _local_5.text.length);
                    }
                }
                else
                {
                    Logger.log(["[Catalog] No main container!"]);
                }
                HabboTracking.getInstance().trackGoogle("catalogue", "open");
            }
            if (this._mainContainer != null)
            {
                this._mainContainer.color = ((k == CatalogType.NORMAL) ? 4296112 : 16758076);
                this._mainContainer.caption = ((k == CatalogType.NORMAL) ? "NextGenHabbo Shop" : "${builder.catalog.title}");
            this._mainContainer.findChildByName("catalog.header.background.border").color = ASCompat.toUInt((k == CatalogType.NORMAL) ? 0x00000000 : 0xFF4E4844);
            this._mainContainer.findChildByName("catalog.header.background.body").color = ASCompat.toUInt((k == CatalogType.NORMAL) ? 0x00000000 : 0xFF2D2724);
                this._mainContainer.findChildByName("catalog.mode.header").visible = (k == CatalogType.NORMAL);
                this._mainContainer.findChildByName("builder.mode.header").visible = (k == CatalogType.BUILDER);
                this.refreshBuilderStatus();
            }
            if (this.mainWindowVisible())
            {
                events.dispatchEvent(new Event(HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_OPEN));
                if (((!(this._recyclerLogic == null)) && (this.getCurrentLayoutCode() == "recycler")))
                {
                    this._recyclerLogic.activate();
                }
            }
            else
            {
                events.dispatchEvent(new Event(HabboCatalogTrackingEvent.HABBO_CATALOG_TRACKING_EVENT_CLOSE));
                if (((!(this._recyclerLogic == null)) && (this.getCurrentLayoutCode() == "recycler")))
                {
                    this._recyclerLogic.cancel();
                }
            }
            if (this._recyclerLogic != null)
            {
                this.setupInventoryForRecycler((this._recyclerLogic.active && this.mainWindowVisible()));
            }
            if ((ASCompat.toBool(_local_4) && (!(this.currentCatalogNavigator == null))))
            {
                if (_arg_3)
                {
                    this.currentCatalogNavigator.deactivateCurrentNode();
                    this.currentCatalogNavigator.loadFrontPage();
                }
                this.currentCatalogNavigator.showIndex();
                if (this._catalogViewer != null)
                {
                    this._catalogViewer._Str_21608();
                }
            }
        }

        function getCurrentLayoutCode():String
        {
            if (this._catalogViewer == null)
            {
                return "";
            }
            return this._catalogViewer.getCurrentLayoutCode();
        }

        function refreshCatalogIndex(k:String)
        {
            this.send(new GetCatalogIndexComposer(k));
        }

        function markNewAdditionPageOpened()
        {
            this.send(new MarkCatalogNewAdditionsPageOpenedComposer());
        }

        function createCatalogNavigators()
        {
            this._catalogNavigators = new ASDictionary<ASAny,ASAny>();
            this._catalogNavigators[CatalogType.NORMAL] = new CatalogNavigator(this, this._mainContainer, CatalogType.NORMAL);
            this._catalogNavigators[CatalogType.BUILDER] = new CatalogNavigator(this, this._mainContainer, CatalogType.BUILDER);
            var k= Std.downcast(assets.getAssetByName("purse_coins_small") , BitmapDataAsset);
            this.setElementImage("creditsIcon", ASCompat.dynamicAs(k.content , BitmapData));
            var _local_2= Std.downcast(assets.getAssetByName("purse_pixels_small") , BitmapDataAsset);
            this.setElementImage("pixelsIcon", ASCompat.dynamicAs(_local_2.content , BitmapData));
            var _local_3= Std.downcast(assets.getAssetByName("purse_club_small") , BitmapDataAsset);
            this.setElementImage("clubIcon", ASCompat.dynamicAs(_local_3.content , BitmapData));
        }

        function createCatalogViewer()
        {
            var k= Std.downcast(this._mainContainer.findChildByName("layoutContainer") , IWindowContainer);
            this._catalogViewer = new CatalogViewer(this, k);
        }

        function createMainWindow()
        {
            var k:String = null;
            var _local_5:IWindow = null;
            if (this.useNonTabbedCatalog())
            {
                k = "catalog_ubuntu";
            }
            else
            {
                k = "catalog_ubuntu_with_tabs";
            }
            var _local_2= Std.downcast(assets.getAssetByName(k) , XmlAsset);
            this._mainContainer = Std.downcast(this._windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) ), DESKTOP_WINDOW_LAYER) , IWindowContainer);
            this._mainContainer.tags.push("habbo_catalog");
            this._mainContainer.position = DEFAULT_VIEW_LOCATION_LARGE;
            this.hideMainWindow();
            var _local_3= this._mainContainer.findChildByName("titlebar_close_button");
            if (_local_3 == null)
            {
                _local_3 = this._mainContainer.findChildByTag("close");
            }
            if (_local_3 != null)
            {
                _local_3.procedure = this.onWindowClose;
            }
            var _local_4= Std.downcast(this._mainContainer.findChildByName("search.input") , ITextFieldWindow);
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.onSearchInputEvent);
                _local_4.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onSearchInputEvent);
                _local_4.setSelection(0, _local_4.text.length);
                _local_4.focus();
                _local_5 = this._mainContainer.findChildByName("clear_search_button");
                if (_local_5 != null)
                {
                    _local_5.addEventListener(WindowMouseEvent.CLICK, this.onClearSearch);
                }
            }
        }

        public var isBusy(never,set):Bool;
public function  set_isBusy(k:Bool):Bool        {
            var _local_2:IWindow = null;
            if (this._mainContainer != null)
            {
                this._mainContainer.caption = (k ? "${generic.loading}" : "NextGenHabbo Shop");
                _local_2 = this._mainContainer.findChildByName("search_waiting_for_results_mask");
                if (_local_2 != null)
                {
                    _local_2.visible = k;
                }
            }
return k;
        }

        function onSelectSearch(k:WindowMouseEvent)
        {
            var _local_2= Std.downcast(k.target , ITextFieldWindow);
            if (_local_2 != null)
            {
                _local_2.setSelection(0, _local_2.text.length);
                _local_2.focus();
            }
        }

        function onClearSearch(k:WindowMouseEvent=null)
        {
            var _local_2= Std.downcast(this._mainContainer.findChildByName("search.input") , ITextFieldWindow);
            _local_2.caption = "";
            _local_2.setSelection(0, _local_2.text.length);
            _local_2.focus();
            var _local_3= Std.downcast(this._mainContainer.findChildByName("search.clear.icon") , IStaticBitmapWrapperWindow);
            _local_3.assetUri = "common_small_pen";
            if (this._catalogViewer._Str_20548 > 0)
            {
                this.currentCatalogNavigator.openPageById(this._catalogViewer._Str_20548, -1);
            }
            this._mainContainer.findChildByName("search.helper").visible = true;
        }

        function onSearchInputEvent(k:WindowKeyboardEvent)
        {
            if (k.type == WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN)
            {
                if (this._keyUpSearchTimer != null)
                {
                    this._keyUpSearchTimer.stop();
                }
                return;
            }
            if (this._keyUpSearchTimer == null)
            {
                this._keyUpSearchTimer = new Timer(50, 1);
            }
            if (k.target.caption.length >= 3)
            {
                this._keyUpSearchTimer.addEventListener(TimerEvent.TIMER, (this.onKeyUpSearchTimer : ASAny));
                this._keyUpSearchTimer.start();
            }
            var _local_2= this._mainContainer.findChildByName("search.helper");
            _local_2.visible = (k.target.caption.length == 0);
            var _local_3= Std.downcast(this._mainContainer.findChildByName("search.clear.icon") , IStaticBitmapWrapperWindow);
            _local_3.assetUri = ((k.target.caption.length > 0) ? "icons_close" : "common_small_pen");
            if (k.target.caption.length == 0)
            {
                this.onClearSearch();
            }
            else
            {
                if (k.keyCode == Keyboard.ENTER)
                {
                    this.performSearch(k.target.caption);
                }
            }
        }

        function onKeyUpSearchTimer(k:TimerEvent)
        {
            var _local_2= Std.downcast(this._mainContainer.findChildByName("search.input") , ITextFieldWindow);
            this.performSearch(_local_2.caption);
        }

        function performSearch(k:String)
        {
            var _local_5:IFurnitureData = null;
            var _local_6:String = null;
            var _local_7:Vector<ICatalogNode> = null;
            var _local_8:Vector<ICatalogNode> = null;
            if (this._keyUpSearchTimer != null)
            {
                this._keyUpSearchTimer.stop();
            }
            if ((((this._furnitureData == null) || (k == null)) || (k.length == 0)))
            {
                return;
            }
            var _local_2:Array<ASAny> = [];
            var _local_3= new Vector<IFurnitureData>(0);
            var _local_4= ASCompat.stringReplace(k.toLowerCase(), " ", "");
            final _iter_ = this._furnitureData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                if (((this._catalogType == CatalogType.BUILDER) && (!_local_5.availableForBuildersClub)))
                {
                }
                else
                {
                    if (((this._catalogType == CatalogType.NORMAL) && _local_5.excludedFromDynamic))
                    {
                    }
                    else
                    {
                        _local_6 = ([_local_5.className, _local_5.localizedName, _local_5.description] : Array<Dynamic>).join(" ");
                        _local_6 = new compat.RegExp(" ", "gi").replace(_local_6, "").toLowerCase();

                        if (((this._catalogType == CatalogType.BUILDER) && (_local_5.purchaseOfferId == NO_KNOWN_OFFER)) && (_local_5.rentOfferId == NO_KNOWN_OFFER))
                        {
                            if (((!(_local_5.furniLine == "")) && (_local_2.indexOf(_local_5.furniLine) < 0)))
                            {
                                if (_local_6.indexOf(_local_4) >= 0)
                                {
                                    _local_2.push(_local_5.furniLine);
                                }
                            }
                        }
                        else
                        {
                            _local_7 = this.currentCatalogNavigator.getNodesByOfferId(_local_5.purchaseOfferId, true);
                            _local_8 = this.currentCatalogNavigator.getNodesByOfferId(_local_5.rentOfferId, true);
                            if (((!(_local_7 == null)) || ((this._catalogType == CatalogType.NORMAL) && (!(_local_8 == null)))))
                            {
                                if (_local_6.indexOf(_local_4) >= 0)
                                {
                                    _local_3.push(_local_5);
                                    if ((_local_3.length : UInt) >= MAX_SEARCH_RESULTS_LENGTH)
                                    {
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            this.localization.registerParameter("catalog.search.results", "count", Std.string(_local_3.length));
            this.localization.registerParameter("catalog.search.results", "needle", k);
            this._mainContainer.findChildByName(PageLocalization.CATALOG_HEADER_TITLE).caption = "${catalog.search.header}";
            this.currentCatalogNavigator.deactivateCurrentNode();
            this._catalogViewer._Str_22433(_local_3);
            this.currentCatalogNavigator.filter(_local_4, _local_2);
        }

        public function furniDataReady()
        {
            this._furnitureData = this._sessionDataManager.getFurniData(this);
            this._pagesVisibleInBuilderMode = null;
        }

        function onRoomSessionEvent(k:RoomSessionEvent)
        {
            switch (k.type)
            {
                case RoomSessionEvent.STARTED:
                    this._privateRoomSessionActive = k.session.isPrivateRoom;
                    this._roomSession = k.session;
                    if (this._recyclerLogic != null)
                    {
                        this._recyclerLogic._Str_19372(true);
                    }
                    
                case RoomSessionEvent.ENDED:
                    this._privateRoomSessionActive = false;
                    this._roomSession = null;
                    if (this._recyclerLogic != null)
                    {
                        this._recyclerLogic._Str_19372(false);
                    }
                    
            }
            if (this.currentPage != null)
            {
                this.currentPage.dispatchWidgetEvent(new CatalogWidgetRoomChangedEvent());
            }
        }

        function _Str_24043()
        {
            this._recyclerLogic = new RecyclerLogic(this, this._windowManager);
            this.getRecyclerPrizes();
        }

        function createMarketPlace()
        {
            if (this._marketplace == null)
            {
                this._marketplace = new MarketPlaceLogic(this, this._windowManager, this._roomEngine);
            }
        }

        function createClubGiftController()
        {
            if (this._clubGiftController == null)
            {
                this._clubGiftController = new ClubGiftController(this);
            }
        }

        function createClubBuyController()
        {
            if (this._clubOfferHandler == null)
            {
                this._clubOfferHandler = new ClubOfferHandler(this, this.connection);
            }
        }

        function createClubExtendController()
        {
            if (this._clubExtendController == null)
            {
                this._clubExtendController = new ClubExtendController(this);
            }
        }

        function createGroupMembershipsController()
        {
            if (this._guildMembershipsController == null)
            {
                this._guildMembershipsController = new GuildMembershipsController(this);
            }
        }

        function getGiftWrappingConfiguration()
        {
            this.send(new GetGiftWrappingConfigurationComposer());
        }

        public function getHabboClubOffers(k:Int)
        {
            this.send(new GetClubOffersMessageComposer(k));
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.hideMainWindow();
            if (this._catalogViewer != null)
            {
                this._catalogViewer._Str_20980();
            }
            if (((!(this._recyclerLogic == null)) && (this.getCurrentLayoutCode() == "recycler")))
            {
                this._recyclerLogic.cancel();
                this.setupInventoryForRecycler(false);
            }
        }

        function onCatalogIndex(k:CatalogPagesListEvent)
        {
            var _local_2= this.getCatalogNavigator(k.catalogType);
            if (_local_2 == null)
            {
                return;
            }
            this._Str_7793 = k._Str_16264;
            _local_2.buildCatalogIndex(k.root);
            if (k.catalogType == this._catalogType)
            {
                _local_2.showIndex();
            }
            switch (this._requestedPage.requestType)
            {
                case RequestedPage.REQUEST_TYPE_NONE:
                    if ((((this._Str_7793 && this._Str_19190) && (!this.newAdditionsPageOpenDisabled)) && (k.catalogType == CatalogType.NORMAL)))
                    {
                        events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_NEW_ITEMS_SHOW));
                        this.openCatalogPage(CatalogPageName.NEW_ADDITIONS);
                    }
                    else
                    {
                        _local_2.loadFrontPage();
                    }
                    return;
                case RequestedPage.REQUEST_TYPE_ID:
                    _local_2.openPageById(this._requestedPage.requestId, this._requestedPage.requestedOfferId);
                    this._requestedPage.resetRequest();
                    return;
                case RequestedPage.REQUEST_TYPE_NAME:
                    _local_2.openPage(this._requestedPage.requestName);
                    this._requestedPage.resetRequest();
                    return;
            }
        }

        function onCatalogPage(k:CatalogPageMessageEvent)
        {
            var _local_11:CatalogPageMessageOfferData = null;
            var _local_12:Vector<IProduct> = null;
            var _local_13:IProductData = null;
            var _local_14:CatalogPageMessageProductData = null;
            var _local_15:Offer = null;
            var _local_16:IFurnitureData = null;
            var _local_2= k.getParser();
            if (_local_2.catalogType != this._catalogType)
            {
                return;
            }
            var _local_3= _local_2.pageId;
            var _local_4= _local_2.layoutCode;
            var _local_5= _local_2.localization.images.copy();
            var _local_6= _local_2.localization.texts.copy();
            var _local_7:IPageLocalization = new PageLocalization(_local_5, _local_6);
            var _local_8= _local_2.offerId;
            var _local_9= _local_2.acceptSeasonCurrencyAsCredits;
            var _local_10= new Vector<IPurchasableOffer>(0);
            final _iter_ = _local_2.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_11  = _tmp_;
                _local_12 = new Vector<IProduct>(0);
                _local_13 = this.getProductData(_local_11.localizationId);
                final _iter_ = _local_11.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_14  = _tmp_;
                    _local_16 = this.getFurnitureData(_local_14.furniClassId, _local_14.productType);
                    _local_12.push(new Product(_local_14.productType, _local_14.furniClassId, _local_14.extraParam, _local_14.productCount, _local_13, _local_16, this, _local_14.uniqueLimitedItem, _local_14.uniqueLimitedItemSeriesSize, _local_14.uniqueLimitedItemsLeft));
                }
                if (((_local_12.length == 0) && (!HabboCatalogUtils._Str_21831(_local_11.localizationId))))
                {
                }
                else
                {
                    _local_15 = new Offer(_local_11.offerId, _local_11.localizationId, _local_11.isRent, _local_11.priceInCredits, _local_11.priceInActivityPoints, _local_11.activityPointType, _local_11.giftable, _local_11.clubLevel, _local_12, _local_11.bundlePurchaseAllowed, this);
                    if (((!(_local_15.productContainer == null)) && this.isOfferCompatibleWithCurrentMode(_local_15)))
                    {
                        _local_10.push(_local_15);
                    }
                    else
                    {
                        _local_15.dispose();
                    }
                }
            }
            if (((!(_local_2.frontPageItems == null)) && (_local_2.frontPageItems.length > 0)))
            {
                this._frontPageItems = _local_2.frontPageItems;
            }
            if (((!(this._catalogViewer == null)) && (this._pageId == _local_3)))
            {
                this._catalogViewer._Str_19388(_local_3, _local_4, _local_7, _local_10, _local_8, _local_9);
            }
            this.isBusy = false;
        }

        function isOfferCompatibleWithCurrentMode(k:Offer):Bool
        {
            return (this._catalogType == CatalogType.NORMAL) || ((!(k.pricingModel == Offer.PRICING_MODEL_BUNDLE)) && (!(k.pricingModel == Offer.PRICING_MODEL_MULTI)));
        }

        function onCatalogPublished(k:IMessageEvent)
        {
            var _local_2= this.mainWindowVisible();
            this.reset();
            if (_local_2)
            {
                this._windowManager.alert("${catalog.alert.published.title}", "${catalog.alert.published.description}", 0, this.alertDialogEventProcessor);
            }
        }

        function onPurchaseError(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PurchaseErrorMessageEvent);
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.errorCode;
            var _local_5= ((_local_4 > 0) ? (("${catalog.alert.purchaseerror.description." + Std.string(_local_4)) + "}") : "${catalog.alert.purchaseerror.description}");
            this._windowManager.alert("${catalog.alert.purchaseerror.title}", _local_5, 0, this.alertDialogEventProcessor);
            if (this._purchaseConfirmationDialog != null)
            {
                this._purchaseConfirmationDialog.dispose();
                this._purchaseConfirmationDialog = null;
            }
        }

        function onPurchaseNotAllowed(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PurchaseNotAllowedMessageEvent);
            var _local_3= _local_2.getParser();
            var _local_4= _local_3.errorCode;
            var _local_5= "";
            switch (_local_4)
            {
                case 1:
                    _local_5 = "${catalog.alert.purchasenotallowed.hc.description}";
                    
                default:
                    _local_5 = "${catalog.alert.purchasenotallowed.unknown.description}";
            }
            this._windowManager.alert("${catalog.alert.purchasenotallowed.title}", _local_5, 0, this.alertDialogEventProcessor);
        }

        function onPurchaseOK(k:IMessageEvent)
        {
            var _local_4:IBitmapWrapperWindow = null;
            var _local_5:BitmapData = null;
            var _local_6:Point = null;
            var _local_7:String = null;
            var _local_2= Std.downcast(k , PurchaseOKMessageEvent);
            var _local_3= _local_2.getParser();
            events.dispatchEvent(new CatalogFurniPurchaseEvent(_local_3.offer.localizationId));
            if (this._purchaseConfirmationDialog != null)
            {
                if (((!this._isObjectMoverRequested) && (!this._purchaseConfirmationDialog.isGiftPurchase())))
                {
                    _local_4 = this._purchaseConfirmationDialog.getIconWrapper();
                    if (_local_4 != null)
                    {
                        _local_5 = _local_4.bitmap;
                        if (_local_5 != null)
                        {
                            _local_6 = new Point();
                            _local_4.getGlobalPosition(_local_6);
                            _local_7 = HabboToolbarIconEnum.INVENTORY;
                            if (this._purchaseConfirmationDialog.productType == ProductTypeEnum.EFFECT)
                            {
                                _local_7 = HabboToolbarIconEnum.MEMENU;
                            }
                            this._toolbar.createTransitionToIcon(_local_7, _local_5.clone(), Std.int(_local_6.x), Std.int(_local_6.y));
                        }
                    }
                }
                this._purchaseConfirmationDialog.dispose();
            }
            this._purchaseConfirmationDialog = null;
        }

        function onGiftReceiverNotFound(k:GiftReceiverNotFoundEvent)
        {
            if (this._purchaseConfirmationDialog != null)
            {
                this._purchaseConfirmationDialog.receiverNotFound();
            }
        }

        function onNotEnoughBalance(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , NotEnoughBalanceMessageEvent);
            var _local_3= _local_2.getParser();
            if (_local_3.notEnoughCredits)
            {
                this.showNotEnoughCreditsAlert();
            }
            else
            {
                if (_local_3._Str_24352)
                {
                    this.showNotEnoughActivityPointsAlert(_local_3.activityPointType);
                }
            }
            if (this._purchaseConfirmationDialog != null)
            {
                this._purchaseConfirmationDialog.notEnoughCredits();
            }
        }

        public function setLeftPaneVisibility(k:Bool)
        {
            if (this._mainContainer == null)
            {
                return;
            }
            var _local_2= this._mainContainer.findChildByName("navigationContainer");
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
            _local_2 = this._mainContainer.findChildByName("searchContainer");
            if (_local_2 != null)
            {
                _local_2.visible = k;
            }
        }

        public function showNotEnoughCreditsAlert()
        {
            if (this._windowManager == null)
            {
                return;
            }
            this._windowManager.confirm("${catalog.alert.notenough.title}", "${catalog.alert.notenough.credits.description}", 0, this.noCreditsConfirmDialogEventProcessor);
        }

        public function showNotEnoughActivityPointsAlert(k:Int)
        {
            var _local_2= ("catalog.alert.notenough.activitypoints.title." + Std.string(k));
            var _local_3= ("catalog.alert.notenough.activitypoints.description." + Std.string(k));
            if (k == ActivityPointTypeEnum.DUCKET)
            {
                this._windowManager.confirm(this.localization.getLocalization(_local_2), this.localization.getLocalization(_local_3), 0, this.noDucketsConfirmDialogEventProcessor);
            }
            else
            {
                this._windowManager.alert(this.localization.getLocalization(_local_2), this.localization.getLocalization(_local_3), 0, this.alertDialogEventProcessor);
            }
        }

        function onVoucherRedeemOk(k:VoucherRedeemOkMessageEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= "${catalog.alert.voucherredeem.ok.description}";
            if (k.productName != "")
            {
                _local_2 = "catalog.alert.voucherredeem.ok.description.furni";
                this._localization.registerParameter(_local_2, "productName", k.productName);
                this._localization.registerParameter(_local_2, "productDescription", k.productDescription);
                _local_2 = (("${" + _local_2) + "}");
            }
            this._windowManager.alert("${catalog.alert.voucherredeem.ok.title}", _local_2, 0, this.alertDialogEventProcessor);
        }

        function onVoucherRedeemError(k:VoucherRedeemErrorMessageEvent)
        {
            if (k == null)
            {
                return;
            }
            var _local_2= "${catalog.alert.voucherredeem.error.title}";
            var _local_3:ASAny = (("${catalog.alert.voucherredeem.error.description." + k.errorCode) + "}");
            this._windowManager.alert(_local_2, _local_3, 0, this.alertDialogEventProcessor);
        }

        function onApproveNameResult(k:ApproveNameMessageEvent)
        {
            if (((k == null) || (this._catalogViewer == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            this._catalogViewer.dispatchWidgetEvent(new CatalogWidgetApproveNameResultEvent(_local_2.result, _local_2.nameValidationInfo));
        }

        function onCreditBalance(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , CreditBalanceEvent);
            var _local_3= _local_2.getParser();
            this._purse.credits = _local_3.balance;
            this.updatePurse();
            if (((!this._firstBalanceCredits) && (!(this._soundManager == null))))
            {
                this._soundManager.playSound(HabboSoundTypesEnum.PURCHASE);
            }
            this._firstBalanceCredits = false;
            events.dispatchEvent(new PurseEvent(PurseEvent.CATALOG_PURSE_CREDIT_BALANCE, this._purse.credits, 0));
            events.dispatchEvent(new PurseUpdateEvent());
        }

        function onActivityPointNotification(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboActivityPointNotificationMessageEvent);
            this._purse.activityPoints[_local_2.type] = _local_2.amount;
            this.updatePurse();
            if (((!(this._soundManager == null)) && (_local_2.type == ActivityPointTypeEnum.DUCKET)))
            {
                this._soundManager.playSound(HabboSoundTypesEnum.PIXELS);
            }
            events.dispatchEvent(new PurseEvent(PurseEvent.CATALOG_PURSE_ACTIVITY_POINT_BALANCE, _local_2.amount, _local_2.type));
            events.dispatchEvent(new PurseUpdateEvent());
        }

        function onActivityPoints(k:IMessageEvent)
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4 = 0;
            var _local_2= Std.downcast(k , ActivityPointsMessageEvent);
            this._purse.activityPoints = _local_2.points;
            this.updatePurse();
            final _iter_ = _local_2.points; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
                _local_4 = ASCompat.toInt(_local_3);
                events.dispatchEvent(new PurseEvent(PurseEvent.CATALOG_PURSE_ACTIVITY_POINT_BALANCE, ASCompat.toInt(_local_2.points[_local_4]), _local_4));
            }
            events.dispatchEvent(new PurseUpdateEvent());
        }

        function onSubscriptionInfo(k:IMessageEvent)
        {
            var _local_3 = false;
            var _local_2= Std.downcast(k , ScrSendUserInfoEvent).getParser();
            this._purse.clubDays = Std.int(Math.max(0, _local_2.daysToPeriodEnd));
            this._purse.clubPeriods = Std.int(Math.max(0, _local_2.periodsSubscribedAhead));
            this._purse.isVIP = _local_2.isVIP;
            this._purse.pastClubDays = _local_2.pastClubDays;
            this._purse.pastVipDays = _local_2.pastVipDays;
            this._purse.isExpiring = ((_local_2.responseType == ScrSendUserInfoMessageParser.RESPONSE_TYPE_DISCOUNT_AVAILABLE) ? true : false);
            this._purse.minutesUntilExpiration = _local_2.minutesUntilExpiration;
            this._purse.minutesSinceLastModified = _local_2.minutesSinceLastModified;
            if (ExternalInterface.available)
            {
                if (((_local_2.productName == "habbo_club") || (_local_2.productName == "club_habbo")))
                {
                    _local_3 = (_local_2.isVIP && (_local_2.minutesUntilExpiration > 0));
                    ExternalInterface.call("FlashExternalInterface.subscriptionUpdated", [_local_3]);
                }
            }
            this.updatePurse();
            if (_local_2.responseType == ScrSendUserInfoMessageParser.RESPONSE_TYPE_PURCHASE)
            {
                this.reset();
                if (this._pageToOpenAfterVipPurchase != null)
                {
                    this.openCatalogPage(this._pageToOpenAfterVipPurchase);
                    this._pageToOpenAfterVipPurchase = null;
                }
            }
        }

        function onClubGiftInfo(k:ClubGiftInfoEvent)
        {
            if (((!(k != null)) || (!(this._clubGiftController != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            this._clubGiftController._Str_24745(_local_2._Str_12860, _local_2._Str_7574, _local_2.offers, _local_2._Str_24398);
        }

        function _Str_24950(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RecyclerStatusEvent).getParser();
            if (((_local_2 == null) || (this._recyclerLogic == null)))
            {
                return;
            }
            this._recyclerLogic._Str_25018(_local_2.recyclerStatus, _local_2.recyclerTimeoutSeconds);
        }

        function onRecyclerFinished(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RecyclerFinishedEvent).getParser();
            if (((_local_2 == null) || (this._recyclerLogic == null)))
            {
                return;
            }
            this._recyclerLogic._Str_22958(_local_2.recyclerFinishedStatus, _local_2.prizeId);
        }

        function _Str_23749(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , RecyclerPrizesEvent).getParser();
            if (((_local_2 == null) || (this._recyclerLogic == null)))
            {
                return;
            }
            this._recyclerLogic._Str_22273(_local_2.prizeLevels);
        }

        function onMarketPlaceOffers(k:IMessageEvent)
        {
            if (this._marketplace != null)
            {
                this._marketplace.onOffers(k);
            }
        }

        function onMarketPlaceOwnOffers(k:IMessageEvent)
        {
            if (this._marketplace != null)
            {
                this._marketplace.onOwnOffers(k);
            }
        }

        function onMarketPlaceBuyResult(k:IMessageEvent)
        {
            if (this._marketplace != null)
            {
                this._marketplace.onBuyResult(k);
            }
        }

        function onMarketPlaceCancelResult(k:IMessageEvent)
        {
            if (this._marketplace != null)
            {
                this._marketplace.onCancelResult(k);
            }
        }

        function onGiftWrappingConfiguration(k:GiftWrappingConfigurationEvent)
        {
            if (k == null)
            {
                return;
            }
            this._giftWrappingConfiguration = new GiftWrappingConfiguration(k);
        }

        function onMarketplaceItemStats(k:MarketplaceItemStatsEvent)
        {
            if (((!(k != null)) || (!(this._marketplace != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= new MarketplaceItemStats();
            _local_3.averagePrice = _local_2.averagePrice;
            _local_3.offerCount = _local_2.offerCount;
            _local_3.historyLength = _local_2.historyLength;
            _local_3.dayOffsets = _local_2.dayOffsets;
            _local_3.averagePrices = _local_2.averagePrices;
            _local_3.soldAmounts = _local_2.soldAmounts;
            _local_3.furniCategoryId = _local_2.furniCategoryId;
            _local_3.furniTypeId = _local_2.furniTypeId;
            this._marketplace.itemStats = _local_3;
        }

        function onMarketplaceConfiguration(k:MarketplaceConfigurationEvent)
        {
            if (((!(k != null)) || (!(this._marketplace != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            this._marketplace.averagePricePeriod = _local_2.displayTime;
        }

        function onMarketplaceMakeOfferResult(k:MarketplaceMakeOfferResult)
        {
            if (((!(k != null)) || (!(this._marketplace != null))))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.result == 1)
            {
                this._marketplace.refreshOffers();
            }
        }

        function onHabboClubOffers(k:HabboClubOffersMessageEvent)
        {
            var _local_2= k.getParser();
            if (((!(this._clubOfferHandler == null)) && ((((_local_2.source == ClubOfferRequestSource._Str_15734) || (_local_2.source == ClubOfferRequestSource._Str_12589)) || (_local_2.source == ClubOfferRequestSource._Str_15001)) || (_local_2.source == ClubOfferRequestSource._Str_15727))))
            {
                this._clubOfferHandler.onOffers(_local_2);
            }
        }

        function onHabboClubExtendOffer(k:HabboClubExtendOfferMessageEvent)
        {
            if (!this._initialized)
            {
                this.init();
            }
            if (this._clubExtendController != null)
            {
                this._clubExtendController._Str_24854(k);
            }
        }

        function onRoomExit(k:IMessageEvent)
        {
        }

        function onSellablePalettes(k:SellablePetPalettesMessageEvent)
        {
            var _local_2= k.getParser();
            this._sellablePetPalettes.remove(_local_2.productCode);
            var _local_3= _local_2._Str_13588;
            if (_local_3 != null)
            {
                this._sellablePetPalettes.add(_local_2.productCode, _local_3.slice(0));
                this._catalogViewer.dispatchWidgetEvent(new CatalogWidgetSellablePetPalettesEvent(_local_2.productCode, _local_3.slice(0)));
            }
        }

        function setElementImage(k:String, _arg_2:BitmapData)
        {
            var _local_3= Std.downcast(this._mainContainer.findChildByName(k) , IBitmapWrapperWindow);
            if (_local_3 != null)
            {
                _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0);
                _local_3.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(0, 0));
            }
            else
            {
                Logger.log([("Could not find element: " + k)]);
            }
        }

        function alertDialogEventProcessor(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            this.resetPlacedOfferData();
        }

        function noCreditsConfirmDialogEventProcessor(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            this.resetPlacedOfferData();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                HabboWebTools.openWebPageAndMinimizeClient(getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
            }
        }

        function noDucketsConfirmDialogEventProcessor(k:IConfirmDialog, _arg_2:WindowEvent)
        {
            var _local_3:String = null;
            k.dispose();
            this.resetPlacedOfferData();
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                _local_3 = getProperty("link.format.duckets");
                if (_local_3 != "")
                {
                    this._windowManager.alert("${catalog.alert.external.link.title}", "${catalog.alert.external.link.desc}", 0, this.onExternalLink);
                    HabboWebTools.navigateToURL(_local_3, "habboMain");
                }
            }
        }

        function onExternalLink(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        public function redeemVoucher(k:String)
        {
            var _local_2:IMessageComposer = new RedeemVoucherMessageComposer(k);
            this.send(_local_2);
            _local_2.dispose();
            _local_2 = null;
        }

        public function productDataReady()
        {
            this._productDataReady = true;
            events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_INITIALIZED));
        }

        public function isDraggable(k:IPurchasableOffer):Bool
        {
            return (((((((getBoolean("catalog.drag_and_drop") && (!(this._roomSession == null))) && ((this._catalogViewer.currentPage == null) || this._catalogViewer.currentPage._Str_21031)) && (((this._catalogType == CatalogType.NORMAL) && (this._roomSession.isRoomOwner || (this._roomSession.isGuildRoom && (this._roomSession.roomControllerLevel >= RoomControllerLevel.GUILD_MEMBER)))) || ((this._catalogType == CatalogType.BUILDER) && (this.getBuilderFurniPlaceableStatus(k) == BuilderFurniPlaceableStatus.OKAY)))) && (!(k.pricingModel == Offer.PRICING_MODEL_BUNDLE))) && (!(k.pricingModel == Offer.PRICING_MODEL_MULTI))) && (!(k.product == null))) && (!(k.product.productType == ProductTypeEnum.EFFECT))) && (!(k.product.productType == ProductTypeEnum.HABBO_CLUB));
        }

        public function getBuilderFurniPlaceableStatus(k:IPurchasableOffer):Int
        {
            if (k == null)
            {
                return BuilderFurniPlaceableStatus.MISSING_OFFER;
            }
            if (((this.builderFurniCount < 0) || (this.builderFurniCount >= this.builderFurniLimit)))
            {
                return BuilderFurniPlaceableStatus.FURNI_LIMIT_REACHED;
            }
            return this.getBuilderPlacementStatus();
        }

        function getBuilderPlacementStatus():Int
        {
            var _local_1 = 0;
            var _local_2 = 0;
            var _local_3:IRoomObject = null;
            var _local_4:RoomUserData = null;
            if (this.roomSession == null)
            {
                return BuilderFurniPlaceableStatus.NOT_IN_ROOM;
            }
            if (!this.roomSession.isRoomOwner)
            {
                return BuilderFurniPlaceableStatus.NOT_ROOM_OWNER;
            }
            if ((this.roomSession.isGuildRoom && (!getBoolean("builders.club.furniture.placement.group.room.enabled"))))
            {
                return BuilderFurniPlaceableStatus.GUILD_ROOM;
            }
            if (this.builderSecondsLeft <= 0)
            {
                _local_1 = this.roomEngine.getRoomObjectCount(this.roomSession.roomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_2 = 0;
                while (_local_2 < _local_1)
                {
                    _local_3 = this.roomEngine.getRoomObjectWithIndex(this.roomSession.roomId, _local_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                    _local_4 = this.roomSession.userDataManager.getUserDataByIndex(_local_3.getId());
                    if (((((!(_local_4 == null)) && (_local_4.type == RoomObjectTypeEnum.HABBO)) && (!(_local_4.roomObjectId == this.roomSession.ownUserRoomId))) && (!_local_4.isModerator)))
                    {
                        return BuilderFurniPlaceableStatus.VISITORS_IN_ROOM;
                    }
                    _local_2++;
                }
            }
            return BuilderFurniPlaceableStatus.OKAY;
        }

        public function canPlaceWithBC():Bool
        {
            if (((this.builderFurniCount < 0) || (this.builderFurniCount >= this.builderFurniLimit)))
            {
                return false;
            }
            return (this.getBuilderPlacementStatus() == BuilderFurniPlaceableStatus.OKAY);
        }

        function updateRoom(k:String, _arg_2:String)
        {
            var _local_3= this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_WALL_TYPE);
            var _local_4= this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_FLOOR_TYPE);
            var _local_5= this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE);
            _local_3 = ((ASCompat.stringAsBool(_local_3) && (_local_3.length > 0)) ? _local_3 : "101");
            _local_4 = ((ASCompat.stringAsBool(_local_4) && (_local_4.length > 0)) ? _local_4 : "101");
            _local_5 = ((ASCompat.stringAsBool(_local_5) && (_local_5.length > 0)) ? _local_5 : "1.1");
            switch (k)
            {
                case "floor":
                    this._roomEngine.updateObjectRoom(this._roomEngine.activeRoomId, _arg_2, _local_3, _local_5, true);
                    return;
                case "wallpaper":
                    this._roomEngine.updateObjectRoom(this._roomEngine.activeRoomId, _local_4, _arg_2, _local_5, true);
                    return;
                case "landscape":
                    this._roomEngine.updateObjectRoom(this._roomEngine.activeRoomId, _local_4, _local_3, _arg_2, true);
                    return;
                default:
                    this._roomEngine.updateObjectRoom(this._roomEngine.activeRoomId, _local_4, _local_3, _local_5, true);
            }
        }

        public function requestSelectedItemToMover(k:IDragAndDropDoneReceiver, _arg_2:IPurchasableOffer, _arg_3:Bool=false)
        {
            var _local_5 = 0;
            if (!this.isDraggable(_arg_2))
            {
                return;
            }
            var _local_4= _arg_2.product;
            switch (_local_4.productType)
            {
                case ProductTypeEnum.FLOOR:
                    _local_5 = RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE;
                    
                case ProductTypeEnum.WALL:
                    _local_5 = RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
                    
            }
            var _local_6= this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.CATALOG, -_arg_2.offerId, _local_5, _local_4.productClassId, (ASCompat.stringAsBool(_local_4.extraParam) ? _local_4.extraParam.toString() : null));
            if (_local_6)
            {
                this._purchasableOffer = _arg_2;
                this._Str_8970 = k;
                this.hideMainWindow();
                this._isObjectMoverRequested = true;
                this._placeMultipleObjects = _arg_3;
            }
        }

        function onObjectSelected(k:RoomEngineObjectEvent)
        {
            var _local_2:RoomUserData = null;
            if (k == null)
            {
                return;
            }
            if ((this.buildersClubEnabled && ((!this._initialized) || (!this.getCatalogNavigator(CatalogType.BUILDER).initialized))))
            {
                this.init();
                this.refreshCatalogIndex(CatalogType.BUILDER);
            }
            if (((k.type == RoomEngineObjectEvent.SELECTED) && (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)))
            {
                _local_2 = this.getUserDataForEvent(k);
                if (_local_2 != null)
                {
                    events.dispatchEvent(new CatalogUserEvent(CatalogEvent.CATALOG_USER_SELECTED, _local_2.id, _local_2.name));
                }
            }
        }

        function onFriendBarSelectionEvent(k:FriendBarSelectionEvent)
        {
            var _local_2 = 0;
            var _local_3:String = null;
            var _local_4:IDragAndDropDoneReceiver = null;
            if ((this._isObjectMoverRequested && (k.type == FriendBarSelectionEvent.FBVE_FRIEND_SELECTED)))
            {
                this.resetPlacedOfferData(true);
                if (((this._purchasableOffer == null) || this._purchasableOffer.disposed))
                {
                    this.resetObjectMover();
                    return;
                }
                _local_2 = k._Str_9566;
                _local_3 = k._Str_24718;
                _local_4 = this._Str_8970;
                if (_local_4 != null)
                {
                    _local_4.onDragAndDropDone(true, _local_3);
                }
                this.resetObjectMover(false);
                this.cancelFurniInMover();
            }
        }

        function getUserDataForEvent(k:RoomEngineObjectEvent):RoomUserData
        {
            var _local_3:IRoomSession = null;
            var _local_2:RoomUserData = null;
            if (this._roomSessionManager != null)
            {
                _local_3 = this._roomSessionManager.getSession(k.roomId);
                if (_local_3 != null)
                {
                    _local_2 = _local_3.userDataManager.getUserDataByIndex(k.objectId);
                }
            }
            return _local_2;
        }

        function onObjectPlaceOnUser(k:RoomEngineObjectPlacedOnUserEvent)
        {
            var _local_2:String = null;
            var _local_3:RoomUserData = null;
            var _local_4:IDragAndDropDoneReceiver = null;
            if ((this._isObjectMoverRequested && (k.type == RoomEngineObjectEvent.PLACED_ON_USER)))
            {
                this.resetPlacedOfferData(true);
                if (((this._purchasableOffer == null) || this._purchasableOffer.disposed))
                {
                    this.resetObjectMover();
                    return;
                }
                _local_2 = null;
                _local_3 = this.getUserDataForEvent(k);
                if (_local_3 != null)
                {
                    _local_2 = _local_3.name;
                }
                _local_4 = this._Str_8970;
                if (_local_4 != null)
                {
                    _local_4.onDragAndDropDone(true, _local_2);
                }
                this.resetObjectMover(false);
                this.cancelFurniInMover();
            }
        }

        function onObjectPlacedInRoom(k:RoomEngineObjectPlacedEvent)
        {
            var _local_2 = 0;
            var _local_3:IProduct = null;
            var _local_4 = false;
            var _local_5:IDragAndDropDoneReceiver = null;
            var _local_6:IRoomObjectController = null;
            var _local_7 = 0;
            var _local_8:Vector<ICatalogNode> = null;
            if ((this._isObjectMoverRequested && (k.type == RoomEngineObjectEvent.PLACED)))
            {
                this.resetPlacedOfferData(true);
                if (((this._purchasableOffer == null) || this._purchasableOffer.disposed))
                {
                    this.resetObjectMover();
                    return;
                }
                _local_2 = k.category;
                _local_3 = this._purchasableOffer.product;
                _local_4 = false;
                if (_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                {
                    switch (_local_3.furnitureData.className)
                    {
                        case "floor"
                           | "wallpaper"
                           | "landscape":
                            _local_4 = (k.placedOnFloor || k.placedOnWall);
                            
                        default:
                             _local_4 = k.isPlacedInRoom;
                    }
                }
                else
                {
                     _local_4 = k.isPlacedInRoom;
                }
                if (!_local_4)
                {
                    this.resetObjectMover();
                    return;
                }
                this._placedObjectPurchaseData = new PlacedObjectPurchaseData(k.roomId, k.objectId, k.category, k._Str_7031, Std.int(k.x), Std.int(k.y), k.direction, this._purchasableOffer);
                _local_5 = this._Str_8970;
                if (_local_5 != null)
                {
                    _local_5.onDragAndDropDone(true, null);
                }
                switch (this._catalogType)
                {
                    case CatalogType.NORMAL:
                        if (_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                        {
                            this._roomEngine.addObjectFurniture(k.roomId, k.objectId, _local_3.productClassId, new Vector3d(k.x, k.y, k.z), new Vector3d(k.direction, 0, 0), 0, new LegacyStuffData());
                        }
                        else
                        {
                            if (_local_2 == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                            {
                                switch (_local_3.furnitureData.className)
                                {
                                    case "floor"
                                       | "wallpaper"
                                       | "landscape":
                                        this.updateRoom(_local_3.furnitureData.className, _local_3.extraParam);
                                        
                                    default:
                                        this._roomEngine.addObjectWallItem(k.roomId, k.objectId, _local_3.productClassId, new Vector3d(k.x, k.y, k.z), new Vector3d((k.direction * 45), 0, 0), 0, k._Str_4766, 0);
                                }
                            }
                        }
                        _local_6 = Std.downcast(this._roomEngine.getRoomObject(k.roomId, k.objectId, k.category) , IRoomObjectController);
                        if (_local_6 != null)
                        {
                            _local_6.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ALPHA_MULTIPLIER, 0.5);
                        }
                        return;
                    case CatalogType.BUILDER:
                        _local_7 = this._purchasableOffer.page.pageId;
                        if (_local_7 == CatalogNavigator.DUMMY_PAGE_ID_FOR_OFFER_SEARCH)
                        {
                            _local_8 = this.currentCatalogNavigator.getNodesByOfferId(this._purchasableOffer.offerId, true);
                            if (_local_8 != null)
                            {
                                _local_7 = _local_8[0].pageId;
                            }
                        }
                        switch (_local_2)
                        {
                            case RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE:
                                this.send(new BuildersClubPlaceRoomItemMessageComposer(_local_7, this._purchasableOffer.offerId, _local_3.extraParam, Std.int(k.x), Std.int(k.y), k.direction));
                                
                            case RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM:
                                this.send(new BuildersClubPlaceWallItemMessageComposer(_local_7, this._purchasableOffer.offerId, _local_3.extraParam, k._Str_7031));
                                
                        }
                        if (this._placeMultipleObjects)
                        {
                            this.requestSelectedItemToMover(_local_5, this._purchasableOffer, true);
                        }
                        else
                        {
                            this.toggleToBuildersClub();
                        }
                        return;
                }
            }
        }

        function resetObjectMover(k:Bool=true)
        {
            if ((k && this._isObjectMoverRequested))
            {
                this.showMainWindow();
            }
            this._isObjectMoverRequested = false;
            this._Str_8970 = null;
        }

        public function syncPlacedOfferWithPurchase(k:IPurchasableOffer)
        {
            if (this._placedObjectPurchaseData != null)
            {
                if (this._placedObjectPurchaseData.offerId != k.offerId)
                {
                    this.resetPlacedOfferData();
                }
            }
        }

        public function resetPlacedOfferData(k:Bool=false)
        {
            if (!k)
            {
                this.resetObjectMover();
            }
            if (this._placedObjectPurchaseData != null)
            {
                if (this._placedObjectPurchaseData.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                {
                    this._roomEngine.disposeObjectFurniture(this._placedObjectPurchaseData.roomId, this._placedObjectPurchaseData.objectId);
                }
                else
                {
                    if (this._placedObjectPurchaseData.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                    {
                        switch (this._placedObjectPurchaseData.furniData.className)
                        {
                            case "floor"
                               | "wallpaper"
                               | "landscape":
                                this.updateRoom("reset", "");
                                
                            default:
                                this._roomEngine.disposeObjectWallItem(this._placedObjectPurchaseData.roomId, this._placedObjectPurchaseData.objectId);
                        }
                    }
                    else
                    {
                        this._roomEngine.deleteRoomObject(this._placedObjectPurchaseData.objectId, this._placedObjectPurchaseData.category);
                    }
                }
                this._placedObjectPurchaseData.dispose();
                this._placedObjectPurchaseData = null;
            }
        }

        public function cancelFurniInMover()
        {
            if (this._purchasableOffer != null)
            {
                this._roomEngine.cancelRoomObjectInsert();
                this._isObjectMoverRequested = false;
                this._purchasableOffer = null;
            }
        }

        function onItemAddedToInventory(k:HabboInventoryItemAddedEvent)
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10:String = null;
            if (((!(this._placedObjectPurchaseData == null)) && (this._placedObjectPurchaseData.productClassId == k.classId)))
            {
                if (this._placedObjectPurchaseData.roomId == this._roomEngine.activeRoomId)
                {
                    _local_2 = k.stripId;
                    _local_3 = this._placedObjectPurchaseData.category;
                    _local_4 = this._placedObjectPurchaseData._Str_7031;
                    _local_5 = this._placedObjectPurchaseData.x;
                    _local_6 = this._placedObjectPurchaseData.y;
                    _local_7 = this._placedObjectPurchaseData.direction;
                    switch (k.category)
                    {
                        case FurniCategory.FLOOR:
                            _local_8 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_FLOOR_TYPE);
                            if (this._placedObjectPurchaseData.extraParameter != _local_8)
                            {
                                this.send(new RequestRoomPropertySet(_local_2));
                            }
                            
                        case FurniCategory.WALL_PAPER:
                            _local_9 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_WALL_TYPE);
                            if (this._placedObjectPurchaseData.extraParameter != _local_9)
                            {
                                this.send(new RequestRoomPropertySet(_local_2));
                            }
                            
                        case FurniCategory.LANDSCAPE:
                            _local_10 = this._roomEngine.getRoomStringValue(this._roomEngine.activeRoomId, RoomObjectVariableEnum.ROOM_LANDSCAPE_TYPE);
                            if (this._placedObjectPurchaseData.extraParameter != _local_10)
                            {
                                this.send(new RequestRoomPropertySet(_local_2));
                            }
                            
                        default:
                            this.send(new PlaceObjectMessageComposer(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7));
                    }
                    this.resetPlacedOfferData();
                }
            }
        }

        public function setImageFromAsset(k:IWindow, _arg_2:String, _arg_3:ASFunction)
        {
            if (((!ASCompat.stringAsBool(_arg_2)) || (!(assets != null))))
            {
                return;
            }
            var _local_4= Std.downcast(assets.getAssetByName(_arg_2) , BitmapDataAsset);
            if (_local_4 == null)
            {
                this.retrievePreviewAsset(_arg_2, _arg_3);
                return;
            }
            if (k != null)
            {
                HabboCatalog.setElementImageCentered(k, ASCompat.dynamicAs(_local_4.content , BitmapData));
            }
        }

        public var imageGalleryHost(get,never):String;
public function  get_imageGalleryHost():String
        {
            return getProperty("image.library.catalogue.url");
        }

        function retrievePreviewAsset(k:String, _arg_2:ASFunction)
        {
            if (((!ASCompat.stringAsBool(k)) || (!(assets != null))))
            {
                return;
            }
            var _local_3:ASAny = ((this.imageGalleryHost + k) + ".png");
            var _local_4= new URLRequest(_local_3);
            var _local_5= assets.loadAssetFromFile(k, _local_4, "image/png");
            if (_local_5 == null)
            {
                return;
            }
            if (_arg_2 != null)
            {
                _local_5.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, _arg_2);
            }
        }

        function showMainWindow()
        {
            var k:IDesktopWindow = null;
            if ((((!(this._windowManager == null)) && (!(this._mainContainer == null))) && (this._mainContainer.parent == null)))
            {
                k = this._windowManager.getDesktop(DESKTOP_WINDOW_LAYER);
                if (k != null)
                {
                    k.addChild(this._mainContainer);
                }
            }
        }

        function hideMainWindow()
        {
            var k:IDesktopWindow = null;
            if ((((!(this._windowManager == null)) && (!(this._mainContainer == null))) && (!(this._mainContainer.parent == null))))
            {
                k = this._windowManager.getDesktop(DESKTOP_WINDOW_LAYER);
                if (((!(k == null)) && (!this._doNotCloseAfterVipPurchase)))
                {
                    k.removeChild(this._mainContainer);
                    if (this._catalogViewer != null)
                    {
                        this._catalogViewer._Str_20980();
                    }
                }
                this._doNotCloseAfterVipPurchase = false;
            }
        }

        function mainWindowVisible():Bool
        {
            return ((!(this._windowManager == null)) && (!(this._mainContainer == null))) && (!(this._mainContainer.parent == null));
        }

        public function update(k:UInt)
        {
            var _local_2 = Math.NaN;
            var _local_3 = Math.NaN;
            if (this._roomPreviewer != null)
            {
                this._roomPreviewer.updatePreviewRoomView();
            }
            if ((flash.Lib.getTimer() - this._builderMembershipDisplayUpdateTime) > 500)
            {
                _local_2 = this.builderSecondsLeft;
                _local_3 = this.builderSecondsLeftWithGrace;
                if ((((_local_2 > -3) && (_local_2 < 200)) || ((_local_3 > -3) && (_local_3 < 200))))
                {
                    this.refreshBuilderStatus();
                }
            }
        }

        public function onGuildMemberships(k:GuildMembershipsMessageEvent)
        {
            if (this._guildMembershipsController != null)
            {
                this._guildMembershipsController.onGuildMembershipsMessageEvent(k);
            }
        }

        public function verifyClubLevel(k:Int=1):Bool
        {
            if (this._sessionDataManager.clubLevel >= k)
            {
                return true;
            }
            this.openClubCenter();
            return false;
        }

        public function openClubCenter()
        {
            context.createLinkEvent("habboUI/open/hccenter");
        }

        function onGuildVisualSettingsChanged(k:GuildSettingsChangedInManageEvent)
        {
            if (this._guildMembershipsController != null)
            {
                this._guildMembershipsController.onGuildVisualSettingsChanged(k.guildId);
            }
        }

        public var avatarEditor(get,never):IHabboAvatarEditor;
public function  get_avatarEditor():IHabboAvatarEditor
        {
            return this._avatarEditor;
        }

        public function checkGiftable(k:IPurchasableOffer)
        {
            this.send(new GetIsOfferGiftableComposer(k.offerId));
        }

        public function rememberPageDuringVipPurchase(k:Int)
        {
            var _local_2= this.currentCatalogNavigator.getNodeById(k);
            if (_local_2 != null)
            {
                this._pageToOpenAfterVipPurchase = _local_2.pageName;
            }
            else
            {
                this._pageToOpenAfterVipPurchase = "frontpage";
            }
        }

        public function forgetPageDuringVipPurchase()
        {
            this._pageToOpenAfterVipPurchase = null;
            this._doNotCloseAfterVipPurchase = false;
        }

        public function doNotCloseAfterVipPurchase()
        {
            this._doNotCloseAfterVipPurchase = (!(this._pageToOpenAfterVipPurchase == null));
        }

        function initBundleDiscounts()
        {
            if (getBoolean("bundle.dynamic.discounts.enabled"))
            {
                this.sendGetBundleDiscountRuleset();
            }
        }

        function sendGetBundleDiscountRuleset()
        {
            this.send(new GetBundleDiscountRulesetComposer());
        }

        public function sendGetProductOffer(k:Int)
        {
            this.send(new GetProductOfferComposer(k));
        }

        function onBundleDiscountRulesetMessageEvent(k:BundleDiscountRulesetMessageEvent)
        {
            var _local_2= k.getParser();
            this._bundleDiscountRuleset = _local_2.bundleDiscountRuleset;
            this._utils._Str_24024();
        }

        function onLimitedEditionSoldOut(k:LimitedEditionSoldOutEvent)
        {
            this._windowManager.alert("${catalog.alert.limited_edition_sold_out.title}", "${catalog.alert.limited_edition_sold_out.message}", 0, this.alertDialogEventProcessor);
            if (this._purchaseConfirmationDialog != null)
            {
                this._purchaseConfirmationDialog.dispose();
                this._purchaseConfirmationDialog = null;
            }
        }

        function onProductOffer(k:ProductOfferEvent)
        {
            var _local_7:Offer = null;
            var _local_8:IFurnitureData = null;
            var _local_2= k.getParser();
            var _local_3= _local_2._Str_17889;
            if (((!(_local_3 != null)) || (_local_3.products.length == 0)))
            {
                return;
            }
            var _local_4= _local_3.products[0];
            if (_local_4.uniqueLimitedItem)
            {
                this._catalogViewer.currentPage._Str_19621(_local_3.offerId, _local_4.uniqueLimitedItemsLeft);
            }
            var _local_5= new Vector<IProduct>(0);
            var _local_6= this.getProductData(_local_3.localizationId);
            final _iter_ = _local_3.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_8 = this.getFurnitureData(_local_4.furniClassId, _local_4.productType);
                _local_5.push(new Product(_local_4.productType, _local_4.furniClassId, _local_4.extraParam, _local_4.productCount, _local_6, _local_8, this, _local_4.uniqueLimitedItem, _local_4.uniqueLimitedItemSeriesSize, _local_4.uniqueLimitedItemsLeft));
            }
            _local_7 = new Offer(_local_3.offerId, _local_3.localizationId, _local_3.isRent, _local_3.priceInCredits, _local_3.priceInActivityPoints, _local_3.activityPointType, _local_3.giftable, _local_3.clubLevel, _local_5, _local_3.bundlePurchaseAllowed, this);
            if (!this.isOfferCompatibleWithCurrentMode(_local_7))
            {
                _local_7.dispose();
                return;
            }
            if (((this._catalogViewer != null) && (this._catalogViewer.currentPage != null)))
            {
                _local_7.page = this._catalogViewer.currentPage;
                this._catalogViewer.currentPage.dispatchWidgetEvent(new SelectProductEvent(_local_7));
                if (((_local_7.product != null) && (_local_7.product.productType == ProductTypeEnum.WALL)))
                {
                    this._catalogViewer.currentPage.dispatchWidgetEvent(new SetExtraPurchaseParameterEvent(_local_7.product.extraParam));
                }
                if ((this._isObjectMoverRequested && (this._purchasableOffer != null)))
                {
                    this._purchasableOffer = _local_7;
                }
            }
        }

        function onBuildersClubSubscriptionStatus(k:BuildersClubSubscriptionStatusMessageEvent)
        {
            var _local_2= k.getParser();
            this._builderFurniLimit = _local_2.furniLimit;
            this._builderMaxFurniLimit = _local_2.maxFurniLimit;
            this._builderMembershipSecondsLeft = _local_2.secondsRemaining;
            this._builderMembershipUpdateTime = flash.Lib.getTimer();
            this._builderMembershipSecondsLeftWithGrace = _local_2.secondsRemainingWithGrace;
            if (ExternalInterface.available)
            {
                ExternalInterface.call("FlashExternalInterface.updateBuildersClub", [(this._builderMembershipSecondsLeft > 0)]);
            }
            if (this.currentPage != null)
            {
                this.currentPage.dispatchWidgetEvent(new CatalogWidgetBuilderSubscriptionUpdatedEvent());
            }
            this.refreshBuilderStatus();
        }

        function onBuildersClubFurniCount(k:BuildersClubFurniCountMessageEvent)
        {
            this._builderFurniCount = k.getParser().furniCount;
            if (this.currentPage != null)
            {
                this.currentPage.dispatchWidgetEvent(new CatalogWidgetBuilderSubscriptionUpdatedEvent());
            }
            this.refreshBuilderStatus();
        }

        function refreshBuilderStatus()
        {
            var k= (this._builderMembershipSecondsLeft - ((flash.Lib.getTimer() - this._builderMembershipUpdateTime) / 1000));
            var _local_2= (this._builderMembershipSecondsLeftWithGrace - ((flash.Lib.getTimer() - this._builderMembershipUpdateTime) / 1000));
            if (((this._builderMembershipActiveSoFar && (k <= 0)) && (_local_2 > 0)))
            {
                events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_BUILDER_MEMBERSHIP_IN_GRACE));
            }
            else
            {
                if ((this._builderMembershipActiveWithGrace && (_local_2 <= 0)))
                {
                    events.dispatchEvent(new CatalogEvent(CatalogEvent.CATALOG_BUILDER_MEMBERSHIP_EXPIRED));
                }
            }
            this._builderMembershipActiveSoFar = (k > 0);
            this._builderMembershipActiveWithGrace = (_local_2 > 0);
            var _local_3= ("builder.header.status." + (this._builderMembershipActiveSoFar ? "member" : (this._builderMembershipActiveWithGrace ? "grace" : "trial")));
            var _local_4= this._localization.getLocalization(_local_3);
            this._localization.registerParameter("builder.header.title", "bcstatus", _local_4);
            var _local_5= (this._builderMembershipActiveSoFar ? FriendlyTime.format(this._localization, k) : (this._builderMembershipActiveWithGrace ? FriendlyTime.format(this._localization, _local_2) : _local_4));
            this._localization.registerParameter("builder.header.status.membership", "duration", (('<font color="#ff8d00"><b>' + _local_5) + "</b></font>"));
            this._localization.registerParameter("builder.header.status.limit", "count", (('<font color="#ff8d00"><b>' + Std.string(this._builderFurniCount)) + "</b></font>"));
            this._localization.registerParameter("builder.header.status.limit", "limit", (('<font color="#ff8d00"><b>' + Std.string(this._builderFurniLimit)) + "</b></font>"));
            this._builderMembershipDisplayUpdateTime = flash.Lib.getTimer();
        }

        public var discountEnabled(get,never):Bool;
public function  get_discountEnabled():Bool
        {
            return getBoolean("bundle.dynamic.discounts.enabled") && (!(this._catalogType == CatalogType.BUILDER));
        }

        public var bundleDiscountRuleset(get,never):BundleDiscountRuleset;
public function  get_bundleDiscountRuleset():BundleDiscountRuleset
        {
            return this._bundleDiscountRuleset;
        }

        public var multiplePurchaseEnabled(get,never):Bool;
public function  get_multiplePurchaseEnabled():Bool
        {
            return getBoolean("catalog.multiple.purchase.enabled") && (!(this._catalogType == CatalogType.BUILDER));
        }

        public var newAdditionsPageOpenDisabled(get,never):Bool;
public function  get_newAdditionsPageOpenDisabled():Bool
        {
            return getBoolean("catalog.new.additions.page.open.disabled");
        }

        public function showVipBenefits()
        {
            if (this._utils == null)
            {
                this.init();
            }
            if (this._utils != null)
            {
                if (!this.getCatalogNavigator(CatalogType.NORMAL).initialized)
                {
                    this.refreshCatalogIndex(CatalogType.NORMAL);
                }
                this._utils.showVipBenefits();
            }
        }

        public var currentPage(get,never):ICatalogPage;
public function  get_currentPage():ICatalogPage
        {
            return (this._catalogViewer == null) ? null : this._catalogViewer.currentPage;
        }

        public function displayProductIcon(k:String, _arg_2:Int, _arg_3:IBitmapWrapperWindow)
        {
            this._utils.displayProductIcon(k, _arg_2, _arg_3);
        }

        public function openRentConfirmationWindow(k:IFurnitureData, _arg_2:Bool, _arg_3:Int=-1, _arg_4:Int=-1, _arg_5:Bool=false)
        {
            if (this._rentConfirmationWindow == null)
            {
                this._rentConfirmationWindow = new RentConfirmationWindow(this);
            }
            this._rentConfirmationWindow.show(k, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return this._roomSession;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "catalog/";
        }

        public function linkReceived(k:String)
        {
            var link:Array<ASAny> = (cast k.split("/"));
            if (link.length < 2)
            {
                return;
            }
            switch (link[1])
            {
                case "open":
                    if (link.length > 2)
                    {
                        this.openCatalogPage(link[2]);
                    }
                    else
                    {
                        this.openCatalog();
                    }
                    return;
                case "warehouse":
                    if (link.length > 2)
                    {
                        this.openCatalogPage(link[2], CatalogType.BUILDER);
                    }
                    else
                    {
                        this.toggleCatalog(CatalogType.BUILDER, true);
                    }
                    return;
                case "club_buy":
                    this.openClubCenter();
                    return;
                default:
                    Logger.log([("Catalog unknown link-type receive: " + link[1])]);
            }
        }

        public var inventory(get,never):IHabboInventory;
public function  get_inventory():IHabboInventory
        {
            return this._inventory;
        }

        public var mainContainer(get,never):IWindowContainer;
public function  get_mainContainer():IWindowContainer
        {
            return this._mainContainer;
        }

        public function toggleToBuildersClub()
        {
            this.toggleCatalog(CatalogType.BUILDER);
        }

        public var catalogType(get,never):String;
public function  get_catalogType():String
        {
            return this._catalogType;
        }

        public function getCatalogNavigator(k:String):ICatalogNavigator
        {
            return (this._catalogNavigators != null) ? this._catalogNavigators[k] : null;
        }

        public var currentCatalogNavigator(get,never):ICatalogNavigator;
public function  get_currentCatalogNavigator():ICatalogNavigator
        {
            return this.getCatalogNavigator(this._catalogType);
        }

        public var builderFurniLimit(get,never):Int;
public function  get_builderFurniLimit():Int
        {
            return this._builderFurniLimit;
        }

        public var builderFurniCount(get,never):Int;
public function  get_builderFurniCount():Int
        {
            return this._builderFurniCount;
        }

        public var builderMaxFurniLimit(get,never):Int;
public function  get_builderMaxFurniLimit():Int
        {
            return this._builderMaxFurniLimit;
        }

        public var builderSecondsLeft(get,never):Float;
public function  get_builderSecondsLeft():Float
        {
            return this._builderMembershipSecondsLeft - ((flash.Lib.getTimer() - this._builderMembershipUpdateTime) / 1000);
        }

        public var builderSecondsLeftWithGrace(get,never):Float;
public function  get_builderSecondsLeftWithGrace():Float
        {
            return this._builderMembershipSecondsLeftWithGrace - ((flash.Lib.getTimer() - this._builderMembershipUpdateTime) / 1000);
        }

        public var isDoorModeOverriddenInCurrentRoom(get,never):Bool;
public function  get_isDoorModeOverriddenInCurrentRoom():Bool
        {
            var k = 0;
            var _local_4:IRoomObject = null;
            var _local_5:IRoomObject = null;
            if (((!this.buildersClubEnabled) || (this.builderSecondsLeft > 0)))
            {
                return false;
            }
            var _local_2= this.roomEngine.getRoomObjectCount(this.roomSession.roomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            k = 0;
            while (k < _local_2)
            {
                _local_4 = this.roomEngine.getRoomObjectWithIndex(this.roomSession.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
                if (_Str_6093._Str_7070(_local_4.getId()))
                {
                    return true;
                }
                k++;
            }
            var _local_3= this.roomEngine.getRoomObjectCount(this.roomSession.roomId, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
            k = 0;
            while (k < _local_3)
            {
                _local_5 = this.roomEngine.getRoomObjectWithIndex(this.roomSession.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
                if (_Str_6093._Str_7070(_local_5.getId()))
                {
                    return true;
                }
                k++;
            }
            return false;
        }

        public function getOfferCenter(k:IOfferExtension):IOfferCenter
        {
            if (this._offerCenter == null)
            {
                this._offerCenter = new OfferCenter(this.windowManager, assets, this);
            }
            this._offerCenter._Str_24459 = k;
            return this._offerCenter;
        }

        public function isNewIdentity():Bool
        {
            return getInteger("new.identity", 0) > 0;
        }

        public function useNonTabbedCatalog():Bool
        {
            return getBoolean("client.desktop.use.non.tabbed.catalog");
        }

		function onFireworkChargeHandler(_arg_1:FireworkChargeDataEvent)
        {
            var parser= _arg_1.getParser();
            if (((this._fireworkChargeDialog == null) || this._fireworkChargeDialog.disposed))
            {
                this._fireworkChargeDialog = new FireworksChargeConfirmationDialog(this, this._localization);
            }
            this._fireworkChargeDialog._SafeStr_8412(parser.fireworkChargeData);
        }
    }

