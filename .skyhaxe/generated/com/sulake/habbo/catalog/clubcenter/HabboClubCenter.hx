package com.sulake.habbo.catalog.clubcenter
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.catalog.offers.IOfferExtension;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.toolbar.IHabboToolbar;
    import com.sulake.habbo.catalog.offers.IOfferCenter;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrKickbackData;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboCatalog;
    import com.sulake.iid.IIDHabboToolbar;
    import com.sulake.habbo.communication.messages.incoming.catalog.ClubGiftInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrSendKickbackInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.BadgesEvent;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.habbo.catalog.clubcenter.util.BadgeResolver;
    import com.sulake.habbo.communication.messages.outgoing.inventory.badges.GetBadgesComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.GetClubGiftInfo;
    import com.sulake.habbo.communication.messages.outgoing.users.ScrGetKickbackInfoMessageComposer;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.catalog.clubcenter.util.ClubStatus;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import flash.display.Stage;
    import com.sulake.habbo.catalog._enum.ClubOfferRequestSource;

     class HabboClubCenter extends Component implements ILinkEventTracker implements  IOfferExtension 
    {
        static inline final USE_FAKE_DATA= false;
        static inline final DATA_UPDATE_INTERVAL_MSEC= 10000;

        var _communicationManager:IHabboCommunicationManager;
        var _localizationManager:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _avatarRenderManager:IAvatarRenderManager;
        var _windowManager:IHabboWindowManager;
        var _catalog:IHabboCatalog;
        var _toolbar:IHabboToolbar;
        var _offerCenter:IOfferCenter;
        var _videoAvailable:Bool = false;
        var _messageEvents:Vector<IMessageEvent>;
        var _view:ClubCenterView;
        var _breakdownView:ClubSpecialInfoBubbleView;
        var _data:ScrKickbackData;
        var _dataTimestamp:Int = 0;
        var _dataPending:Bool = false;
        var _badgeId:String;
        var _giftsAvailable:Int = 0;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null)
        {
            this._dataTimestamp = -DATA_UPDATE_INTERVAL_MSEC;
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            }, true), new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarRenderManager = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboCatalog(), function (k:IHabboCatalog)
            {
                _catalog = k;
            }), new ComponentDependency(new IIDHabboToolbar(), function (k:IHabboToolbar)
            {
                _toolbar = k;
            })]));
        }

        override function initComponent()
        {
            this._messageEvents = new Vector<IMessageEvent>(0);
            this.addMessageEvent(new ClubGiftInfoEvent(this.onClubGiftInfo));
            this.addMessageEvent(new ScrSendKickbackInfoMessageEvent(this._Str_22489));
            this.addMessageEvent(new BadgesEvent(this.onBadges));
            context.addLinkEventTracker(this);
            if ((getBoolean("offers.enabled") && getBoolean("offers.habboclub.enabled")))
            {
                this._offerCenter = this.catalog.getOfferCenter(this);
            }
        }

        override public function dispose()
        {
            var k:IMessageEvent = null;
            if (((!(this._messageEvents == null)) && (!(this._communicationManager == null))))
            {
                final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this._communicationManager.removeHabboConnectionMessageEvent(k);
                }
            }
            if (((!(this._sessionDataManager == null)) && (this._sessionDataManager.events != null)))
            {
                this._sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this._Str_18469);
            }
            if (this._offerCenter != null)
            {
                this._offerCenter = null;
            }
            this.removeView();
            this._data = null;
            this._messageEvents = null;
            super.dispose();
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "habboUI/";
        }

        public function linkReceived(k:String)
        {
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 3)
            {
                return;
            }
            if (_local_2[1] == "open")
            {
                switch (_local_2[2])
                {
                    case "hccenter":
                        this._Str_23317();
                        return;
                }
            }
        }

        function _Str_23317()
        {
            if (this._view == null)
            {
                this._view = new ClubCenterView(this, this._windowManager, this._sessionDataManager.figure);
            }
            if (this._Str_25344())
            {
                this.updateData();
            }
            else
            {
                this.populate();
            }
            if ((((this._offerCenter != null) && (this._view != null)) && this._videoAvailable))
            {
                this._videoAvailable = false;
                this._Str_14237(true);
            }
        }

        public function removeView()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.removeBreakdown();
            this._dataPending = false;
        }

        public function removeBreakdown()
        {
            if (this._breakdownView != null)
            {
                this._breakdownView.dispose();
                this._breakdownView = null;
            }
        }

        function addMessageEvent(k:IMessageEvent)
        {
            if (this._communicationManager == null)
            {
                return;
            }
            this._messageEvents.push(this._communicationManager.addHabboConnectionMessageEvent(k));
        }

        function _Str_22489(k:ScrSendKickbackInfoMessageEvent)
        {
            var _local_2= k.getParser();
            this._data = _local_2.data;
            this._dataPending = false;
            this._dataTimestamp = flash.Lib.getTimer();
            this.populate();
        }

        function onClubGiftInfo(k:ClubGiftInfoEvent)
        {
            this._giftsAvailable = k.getParser()._Str_7574;
            this.populate();
        }

        function _Str_18469(k:BadgeImageReadyEvent)
        {
            if (((!(k.badgeId == this._badgeId)) || (!(this._sessionDataManager != null))))
            {
                return;
            }
            this._sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this._Str_18469);
            this.populate();
        }

        public function onBadges(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , BadgesEvent).getParser();
            this._badgeId = ASCompat.thisOrDefault(BadgeResolver._Str_25437(_local_2.getAllBadgeCodes()) , BadgeResolver._Str_16636);
        }

        function _Str_25344():Bool
        {
            return (!this._dataPending) && ((flash.Lib.getTimer() - this._dataTimestamp) > DATA_UPDATE_INTERVAL_MSEC);
        }

        function updateData()
        {
            this._dataPending = true;
            this._communicationManager.connection.send(new GetBadgesComposer());
            this._communicationManager.connection.send(new GetClubGiftInfo());
            if (!USE_FAKE_DATA)
            {
                this._communicationManager.connection.send(new ScrGetKickbackInfoMessageComposer());
            }
            else
            {
                this._data = new ScrKickbackData();
                this.populate();
            }
        }

        function populate()
        {
            if (this._view != null)
            {
                this._view._Str_22518(this._data, this.getPurse(), this._Str_22760(), BadgeResolver._Str_24209(this._badgeId, this._Str_18469, this._sessionDataManager));
            }
        }

        var catalog(get,never):IHabboCatalog;
function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        function getPurse():IPurse
        {
            return (this.catalog != null) ? this.catalog.getPurse() : null;
        }

        function _Str_22760():Int
        {
            return this._giftsAvailable;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return (this.catalog != null) ? this.catalog.localization : null;
        }

        public var avatarRenderManager(get,never):IAvatarRenderManager;
public function  get_avatarRenderManager():IAvatarRenderManager
        {
            return this._avatarRenderManager;
        }

        public function _Str_24259():String
        {
            if (this.catalog == null)
            {
                return ClubStatus.NONE;
            }
            var k= this.getPurse();
            if (k.clubDays > 0)
            {
                return ClubStatus.ACTIVE;
            }
            if (((k.pastClubDays > 0) || (k.pastVipDays > 0)))
            {
                return ClubStatus.EXPIRED;
            }
            return ClubStatus.NONE;
        }

        public function _Str_24472()
        {
            if (this.catalog != null)
            {
                this.catalog.openCatalogPage(CatalogPageName.HC_MEMBERSHIP, CatalogType.NORMAL);
            }
        }

        public function _Str_22271()
        {
            if (this.catalog != null)
            {
                this.catalog.openCatalogPage(CatalogPageName.CLUB_GIFTS, CatalogType.NORMAL);
            }
        }

        public function _Str_23974()
        {
            if (this._breakdownView != null)
            {
                this.removeBreakdown();
                return;
            }
            this._breakdownView = new ClubSpecialInfoBubbleView(this, this._windowManager, this._data, this._view._Str_23883());
        }

        public function _Str_21087()
        {
            context.createLinkEvent("habbopages/hcpayday");
        }

        public function openHelpPage()
        {
            context.createLinkEvent("habbopages/habboclub");
        }

        public function _Str_26228(k:String)
        {
            context.createLinkEvent(k);
        }

        public function _Str_21512():Bool
        {
            var k= getProperty("hccenter.activity.enabled");
            if (((k == null) || (k == "")))
            {
                return true;
            }
            return (k == "1") || (k == "true");
        }

        public var stage(get,never):Stage;
public function  get_stage():Stage
        {
            return ((context != null) && (context.displayObjectContainer != null)) ? context.displayObjectContainer.stage : null;
        }

        public function _Str_16489()
        {
            this._catalog.getHabboClubOffers(ClubOfferRequestSource._Str_19022);
        }

        public var _Str_19407(get,never):IOfferCenter;
public function  get__Str_19407():IOfferCenter
        {
            return this._offerCenter;
        }

        public function _Str_18053()
        {
        }

        public function _Str_14237(k:Bool)
        {
            if (this._view != null)
            {
                this._view._Str_24836(k, ((!(this._offerCenter == null)) && (!this._offerCenter._Str_16243)));
            }
            else
            {
                this._videoAvailable = k;
            }
        }
    }

