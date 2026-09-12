package com.sulake.habbo.inventory
;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingYouAreNotAllowedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingYouAreNotAllowedParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingConfirmationEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingConfirmationParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingCompletedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingCompletedParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingItemListEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingItemListParser;
    import com.sulake.habbo.communication.messages.incoming.bots.BotRemovedFromInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListInvalidateEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.clothes.FigureSetIdsEvent;
    import com.sulake.habbo.communication.messages.incoming.navigator.FlatAccessDeniedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.bots.BotInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.BadgesEvent;
    import com.sulake.habbo.communication.messages.incoming.users.UserBadgesEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceConfigurationEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.OpenConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceCanMakeOfferResult;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOtherNotAllowedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingOtherNotAllowedParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingAcceptEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingAcceptParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementsScoreEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.pets.PetAddedToInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.users.ScrSendUserInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingNotOpenEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingNotOpenParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListRemoveEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectActivatedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingCloseEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingCloseParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.NotEnoughBalanceMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.bots.BotAddedToInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.PostItPlacedEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOpenFailedEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingOpenFailedEventParser;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.TradingOpenEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.trading.TradingOpenParser;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserRightsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.BadgeReceivedEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceItemStatsEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.pets.PetInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListAddOrUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.marketplace.MarketplaceMakeOfferResult;
    import com.sulake.habbo.communication.messages.incoming.notifications.HabboAchievementNotificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.pets.GoToBreedingNestFailureEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectExpiredMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffectAddedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.pets.PetRemovedFromInventoryEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.badges.BadgePointLimitsEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryFurniListParsedEvent;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniData;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.avatareffect.AvatarEffect;
    import com.sulake.habbo.inventory.effects.Effect;
    import com.sulake.habbo.communication.messages.parser.users.ScrSendUserInfoMessageParser;
    import com.sulake.habbo.inventory.events.HabboInventoryHabboClubEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.BadgeAndPointLimit;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.inventory._enum.InventorySubCategory;
    import com.sulake.habbo.inventory.trading.TradingModel;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTradeInitiateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTradeCancelledMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTradeCompletedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTradeItemUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.trading.ItemDataStructure;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.GoToBreedingNestFailureParser;
    import com.sulake.habbo.inventory.marketplace.MarketplaceModel;

     class IncomingMessages 
    {
        static inline final CREDIT_GROUPITEM_TYPE_ID= "credit_groupitem_type_id";

        var _inventory:HabboInventory;
        var _com:IHabboCommunicationManager;
        var _petMsgFragments:Vector<Map>;
        var _furniMsgFragments:Vector<Map>;
        var _rentedFurniMsgFragments:Vector<Map>;

        public function new(k:HabboInventory)
        {
            this._inventory = k;
            this._com = this._inventory.communication;
            this._com.addHabboConnectionMessageEvent(new TradingYouAreNotAllowedEvent(this._Str_24409, TradingYouAreNotAllowedParser));
            this._com.addHabboConnectionMessageEvent(new TradingConfirmationEvent(this._Str_25011, TradingConfirmationParser));
            this._com.addHabboConnectionMessageEvent(new TradingCompletedEvent(this._Str_23780, TradingCompletedParser));
            this._com.addHabboConnectionMessageEvent(new TradingItemListEvent(this._Str_25320, TradingItemListParser));
            this._com.addHabboConnectionMessageEvent(
                new WiredTradeInitiateMessageEvent(this.onWiredTradeInitiate));
            this._com.addHabboConnectionMessageEvent(
                new WiredTradeCancelledMessageEvent(this.onWiredTradeCancelled));
            this._com.addHabboConnectionMessageEvent(
                new WiredTradeCompletedMessageEvent(this.onWiredTradeCompleted));
            this._com.addHabboConnectionMessageEvent(
                new WiredTradeItemUpdateMessageEvent(this.onWiredTradeItemUpdate));
            this._com.addHabboConnectionMessageEvent(new BotRemovedFromInventoryEvent(this._Str_24595));
            this._com.addHabboConnectionMessageEvent(new FurniListInvalidateEvent(this._Str_18656));
            this._com.addHabboConnectionMessageEvent(new FigureSetIdsEvent(this._Str_25862));
            this._com.addHabboConnectionMessageEvent(new FlatAccessDeniedMessageEvent(this._Str_15910));
            this._com.addHabboConnectionMessageEvent(new BotInventoryEvent(this._Str_23613));
            this._com.addHabboConnectionMessageEvent(new BadgesEvent(this.onBadges));
            this._com.addHabboConnectionMessageEvent(new UserBadgesEvent(this.onUserBadges));
            this._com.addHabboConnectionMessageEvent(new MarketplaceConfigurationEvent(this.onMarketplaceConfiguration));
            this._com.addHabboConnectionMessageEvent(new OpenConnectionMessageEvent(this._Str_15910));
            this._com.addHabboConnectionMessageEvent(new MarketplaceCanMakeOfferResult(this._Str_25747));
            this._com.addHabboConnectionMessageEvent(new TradingOtherNotAllowedEvent(this._Str_22530, TradingOtherNotAllowedParser));
            this._com.addHabboConnectionMessageEvent(new FurniListEvent(this.onFurniList));
            this._com.addHabboConnectionMessageEvent(new TradingAcceptEvent(this._Str_23770, TradingAcceptParser));
            this._com.addHabboConnectionMessageEvent(new AchievementsScoreEvent(this._Str_18065));
            this._com.addHabboConnectionMessageEvent(new PetAddedToInventoryEvent(this._Str_23427));
            this._com.addHabboConnectionMessageEvent(new ScrSendUserInfoEvent(this.onClubStatus));
            this._com.addHabboConnectionMessageEvent(new TradingNotOpenEvent(this._Str_23644, TradingNotOpenParser));
            this._com.addHabboConnectionMessageEvent(new FurniListRemoveEvent(this._Str_25700));
            this._com.addHabboConnectionMessageEvent(new AvatarEffectActivatedMessageEvent(this._Str_17365));
            this._com.addHabboConnectionMessageEvent(new TradingCloseEvent(this._Str_25275, TradingCloseParser));
            this._com.addHabboConnectionMessageEvent(new NotEnoughBalanceMessageEvent(this.onNotEnoughCredits));
            this._com.addHabboConnectionMessageEvent(new BotAddedToInventoryEvent(this._Str_23929));
            this._com.addHabboConnectionMessageEvent(new PostItPlacedEvent(this._Str_23887));
            this._com.addHabboConnectionMessageEvent(new TradingOpenFailedEvent(this._Str_23502, TradingOpenFailedEventParser));
            this._com.addHabboConnectionMessageEvent(new CloseConnectionMessageEvent(this._Str_15910));
            this._com.addHabboConnectionMessageEvent(new TradingOpenEvent(this._Str_22556, TradingOpenParser));
            this._com.addHabboConnectionMessageEvent(new UserRightsMessageEvent(this.onUserRights));
            this._com.addHabboConnectionMessageEvent(new BadgeReceivedEvent(this._Str_23620));
            this._com.addHabboConnectionMessageEvent(new MarketplaceItemStatsEvent(this.onMarketplaceItemStats));
            this._com.addHabboConnectionMessageEvent(new AvatarEffectsMessageEvent(this.onAvatarEffects));
            this._com.addHabboConnectionMessageEvent(new PetInventoryEvent(this._Str_24135));
            this._com.addHabboConnectionMessageEvent(new FurniListAddOrUpdateEvent(this._Str_23121));
            this._com.addHabboConnectionMessageEvent(new MarketplaceMakeOfferResult(this.onMarketplaceMakeOfferResult));
            this._com.addHabboConnectionMessageEvent(new HabboAchievementNotificationMessageEvent(this._Str_25294));
            this._com.addHabboConnectionMessageEvent(new GoToBreedingNestFailureEvent(this._Str_25173));
            this._com.addHabboConnectionMessageEvent(new AvatarEffectExpiredMessageEvent(this.onAvatarEffectExpired));
            this._com.addHabboConnectionMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            this._com.addHabboConnectionMessageEvent(new AvatarEffectAddedMessageEvent(this._Str_18461));
            this._com.addHabboConnectionMessageEvent(new PetRemovedFromInventoryEvent(this._Str_22306));
            this._com.addHabboConnectionMessageEvent(new BadgePointLimitsEvent(this.onBadgePointLimits));
        }

        public function dispose()
        {
            this._inventory = null;
            this._com = null;
        }

        public function onFurniList(k:FurniListEvent)
        {
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            if (!this._inventory._Str_23047)
            {
                this._inventory._Str_22707();
            }
            var _local_3= this._inventory.furniModel;
            if (_local_3 == null)
            {
                return;
            }
            if (this._furniMsgFragments == null)
            {
                this._furniMsgFragments = new Vector<Map>(_local_2.totalFragments, true);
            }
            var _local_4= new Map();
            _local_4.concatenate(_local_2.furniFragment);
            var _local_5= this._Str_19767(_local_4, _local_2.totalFragments, _local_2.fragmentNo, this._furniMsgFragments);
            if (_local_5 == null)
            {
                return;
            }
            _local_3.insertFurniture(_local_5);
            this._furniMsgFragments = null;
            this._inventory.events.dispatchEvent(new HabboInventoryFurniListParsedEvent(InventoryCategory.FURNI));
        }

        public function _Str_23121(k:IMessageEvent)
        {
            var _local_5:FurnitureItem = null;
            var _local_6:FurniData = null;
            var _local_7:GroupItem = null;
            var _local_2= Std.downcast(k , FurniListAddOrUpdateEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._inventory.furniModel;
            if (((_local_3 == null) || (!_local_3._Str_21873())))
            {
                return;
            }
            var _local_4= _local_2.getFurni();
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                _local_7 = _local_3._Str_25496(_local_6.itemId);
                if (_local_7 != null)
                {
                    _local_5 = _local_7.getItem(_local_6.itemId);
                    if (_local_5 != null)
                    {
                        _local_5.update(_local_6);
                        _local_7._Str_6126 = true;
                    }
                }
                else
                {
                    _local_5 = new FurnitureItem(_local_6);
                    _local_3._Str_20455(_local_5, false);
                }
            }
            _local_3._Str_7636();
            _local_3.updateView();
        }

        public function _Str_25700(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , FurniListRemoveEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._inventory.furniModel;
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_2.stripId;
            var _local_5= _local_3._Str_17979(_local_4);
            if (_local_5 != null)
            {
                _local_3._Str_4409();
            }
        }

        public function _Str_18656(k:IMessageEvent)
        {
            this._inventory._Str_5943(InventoryCategory.FURNI, false);
            this._inventory._Str_5943(InventoryCategory.RENTABLES, false);
        }

        public function _Str_23887(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PostItPlacedEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._inventory.furniModel;
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_2.id;
            var _local_5= _local_2.itemsLeft;
            _local_3._Str_22816(_local_4, _local_5);
        }

        public function onAvatarEffects(k:IMessageEvent)
        {
            var _local_6:AvatarEffect = null;
            var _local_7:Effect = null;
            if (this._inventory == null)
            {
                return;
            }
            var _local_2= this._inventory._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(k , AvatarEffectsMessageEvent).getParser();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.effects;
            var _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = ASCompat.dynamicAs(_local_4[_local_5] , AvatarEffect);
                _local_7 = new Effect();
                _local_7.type = _local_6.type;
                _local_7.subType = _local_6.subType;
                _local_7.duration = _local_6.duration;
                _local_7.isPermanent = _local_6.isPermanent;
                _local_7.amount = _local_6.amount;
                if (_local_6.secondsRemaining >= 0)
                {
                    _local_7.isActive = true;
                    _local_7.secondsRemaining = _local_6.secondsRemaining;
                    _local_7.amount++;
                }
                else
                {
                    if (_local_6.secondsRemaining == -1)
                    {
                        _local_7.isActive = false;
                        _local_7.secondsRemaining = _local_6.duration;
                    }
                }
                _local_2._Str_2428(_local_7, false);
                _local_5++;
            }
            this._inventory._Str_5943(InventoryCategory.EFFECTS);
            _local_2._Str_4879();
            this._inventory._Str_7796();
        }

        public function _Str_18461(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(k , AvatarEffectAddedMessageEvent).getParser();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.type;
            var _local_5= _local_3.subType;
            var _local_6= _local_3.duration;
            var _local_7= _local_3.isPermanent;
            var _local_8= new Effect();
            _local_8.type = _local_4;
            _local_8.subType = _local_5;
            _local_8.duration = _local_6;
            _local_8.isPermanent = _local_7;
            _local_8.secondsRemaining = _local_6;
            _local_2._Str_2428(_local_8);
            this._inventory._Str_7796();
        }

        public function _Str_17365(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(k , AvatarEffectActivatedMessageEvent).getParser();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.type;
            _local_2._Str_22417(_local_4);
            this._inventory._Str_7796();
        }

        public function onAvatarEffectExpired(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3994;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(k , AvatarEffectExpiredMessageEvent).getParser();
            if (_local_3 == null)
            {
                return;
            }
            var _local_4= _local_3.type;
            _local_2._Str_24134(_local_4);
            this._inventory._Str_7796();
        }

        public function onClubStatus(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , ScrSendUserInfoEvent).getParser();
            if (((_local_2.productName == "habbo_club") || (_local_2.productName == "club_habbo")))
            {
                this._inventory._Str_23808(_local_2.periodsSubscribedAhead, _local_2.daysToPeriodEnd, _local_2.hasEverBeenMember, _local_2.isVIP, (_local_2.responseType == ScrSendUserInfoMessageParser.RESPONSE_TYPE_DISCOUNT_AVAILABLE), (_local_2.responseType == ScrSendUserInfoMessageParser.RESPONSE_TYPE_CITIZENSHIP_DISCOUNT), _local_2.minutesUntilExpiration, _local_2.minutesSinceLastModified);
                this._inventory.events.dispatchEvent(new HabboInventoryHabboClubEvent());
            }
        }

        public function onBadges(k:IMessageEvent)
        {
            var _local_4 = 0;
            var _local_5:String = null;
            var _local_8 = false;
            var _local_9 = 0;
            var _local_2= Std.downcast(k , BadgesEvent).getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._inventory.badgesModel;
            if (_local_3 == null)
            {
                return;
            }
            var _local_6= _local_2.getAllBadgeCodes();
            var _local_7= _local_2.getActiveBadgeCodes();
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_5  = _tmp_;
                _local_8 = (_local_7.indexOf(_local_5) > -1);
                _local_9 = _local_2.getBadgeId(_local_5);
                _local_3.updateBadge(_local_5, _local_8, _local_9);
            }
            _local_3._Str_22395();
            _local_3.updateView();
            this._inventory._Str_5943(InventoryCategory.BADGES);
        }

        public function onBadgePointLimits(k:IMessageEvent)
        {
            var _local_3:BadgeAndPointLimit = null;
            var _local_2= Std.downcast(k , BadgePointLimitsEvent).getParser();
            final _iter_ = _local_2.data; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                this._inventory.localization.setBadgePointLimit(_local_3.badgeId, _local_3.limit);
            }
        }

        public function onUserBadges(k:IMessageEvent)
        {
            var _local_4:String = null;
            var _local_2= Std.downcast(k , UserBadgesEvent);
            if (_local_2.userId != this._inventory.sessionData.userId)
            {
                return;
            }
            var _local_3= this._inventory.badgesModel;
            if (_local_3 == null)
            {
                return;
            }
            final _iter_ = _local_2.badges; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_3.updateBadge(_local_4, true);
            }
            _local_3.updateView();
        }

        public function _Str_25294(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , HabboAchievementNotificationMessageEvent);
            var _local_3= _local_2.getParser();
            var _local_4= this._inventory.badgesModel;
            if (_local_4 != null)
            {
                _local_4.updateBadge(_local_3.data.badgeCode, false, _local_3.data.badgeId);
                _local_4._Str_24079(_local_3.data._Str_24720);
                _local_4.updateView();
            }
        }

        public function _Str_23620(k:IMessageEvent)
        {
            var _local_2= cast(k, BadgeReceivedEvent).getParser();
            var _local_3= this._inventory.badgesModel;
            if (_local_3 != null)
            {
                _local_3.updateBadge(_local_2.badgeCode, false, _local_2.badgeId);
                _local_3.updateView();
            }
        }

        public function _Str_18065(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AchievementsScoreEvent);
            var _local_3= _local_2.getParser() ;
            if (_local_3 == null)
            {
                return;
            }
            this._inventory.localization.registerParameter("achievements_score_description", "score", new compat.RegExp("\\B(?=(\\d{3})+(?!\\d))", "g").replace(Std.string(_local_3.score), " "));
        }

        function _Str_22556(k:IMessageEvent)
        {
            var _local_14 = 0;
            var _local_15:String = null;
            var _local_16 = false;
            if (this._inventory == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", "Trading open - inventory is null!");
                return;
            }
            var _local_2= this._inventory.sessionData;
            var _local_3= this._inventory.roomSession;
            if (_local_2 == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", "Trading open - sessionData not available!");
                return;
            }
            if (_local_3 == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", "Trading open - roomSession not available!");
                return;
            }
            this._inventory.toggleInventorySubPage(InventorySubCategory.TRADING);
            var _local_4= Std.downcast(k , TradingOpenEvent);
            if (_local_4 == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", (("event is of unknown type:" + k) + "!"));
                return;
            }
            var _local_5= _local_4.userID;
            var _local_6= _local_3.userDataManager.getUserData(_local_5);
            if (_local_6 == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", "Trading open - failed to retrieve own user data!");
                return;
            }
            var _local_7= _local_6.name;
            var _local_8:ASAny = (ASCompat.toNumber(_local_4._Str_16764 )> 0);
            var _local_9= _local_4._Str_17613;
            var _local_10= _local_3.userDataManager.getUserData(_local_9);
            if (_local_10 == null)
            {
                ErrorReportStorage.addDebugData("IncomingEvent", "Trading open - failed to retrieve other user data!");
                return;
            }
            var _local_11= _local_10.name;
            var _local_12:ASAny = (ASCompat.toNumber(_local_4._Str_13374 )> 0);
            if (_local_9 == _local_2.userId)
            {
                _local_14 = _local_5;
                _local_15 = _local_7;
                _local_16 = _local_8;
                _local_5 = _local_9;
                _local_7 = _local_11;
                _local_8 = _local_12;
                _local_9 = _local_14;
                _local_11 = _local_15;
                _local_12 = _local_16;
            }
            var _local_13= this._inventory._Str_3957;
            if (_local_13 != null)
            {
                _local_13._Str_23457(_local_5, _local_7, _local_8, _local_9, _local_11, _local_12);
            }
        }

        function _Str_23502(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_25275(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_23780(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_23770(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_25011(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_25320(k:IMessageEvent)
        {
            var _local_8:GroupItem = null;
            var _local_2= Std.downcast(k , TradingItemListEvent);
            var _local_3= new Map();
            var _local_4= new Map();
            var _local_5= this._inventory.sessionData.userId;
            var _local_6= this._inventory.furniModel;
            if (_local_6 == null)
            {
                return;
            }
            if ((this._inventory.getBoolean("trading.warning.enabled") && (_local_2.secondUserNumCredits > 0)))
            {
            _local_8 = this._inventory.furniModel.createCreditGroupItem(_local_2.secondUserNumCredits);
                _local_4.add(CREDIT_GROUPITEM_TYPE_ID, _local_8);
            }
            this._Str_21714(_local_2.firstUserItemArray, _local_3, (_local_2.firstUserID == _local_5));
            this._Str_21714(_local_2.secondUserItemArray, _local_4, (_local_2.secondUserID == _local_5));
            var _local_7= this._inventory._Str_3957;
            if (_local_7 != null)
            {
                _local_7._Str_25000(_local_2, _local_3, _local_4);
            }
        }

        function _Str_21714(k:Array<ASAny>, _arg_2:Map, _arg_3:Bool)
        {
            var _local_5:GroupItem = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9:ItemDataStructure = null;
            var _local_10 = 0;
            var _local_4:UInt = k.length;
            _local_10 = 0;
            while ((_local_10 : UInt) < _local_4)
            {
                _local_9 = ASCompat.dynamicAs(k[_local_10] , ItemDataStructure);
                _local_6 = _local_9.spriteId;
                _local_7 = _local_9.category;
                _local_8 = (_local_9.furniType + Std.string(_local_6));
                if (((!_local_9.isGroupable) || this._Str_20661(_local_9.spriteId)))
                {
                    _local_8 = ("itemid" + Std.string(_local_9.itemId));
                }
                if (_local_9.category == FurniCategory.POSTER)
                {
                    _local_8 = ((Std.string(_local_6) + "poster") + _local_9.stuffData.getLegacyString());
                }
                else
                {
                    if (_local_9.category == FurniCategory.GUILD_FURNI)
                    {
                        _local_8 = TradingModel._Str_16998(_local_6, _local_9.stuffData);
                    }
                }
                _local_5 = ((_local_9.isGroupable && (!this._Str_20661(_local_9.spriteId))) ? ASCompat.dynamicAs(_arg_2.getValue(_local_8) , GroupItem) : null);
                if (_local_5 == null)
                {
            _local_5 = this._inventory.furniModel.createGroupItem(_local_6, _local_7, _local_9.stuffData);
                    _arg_2.add(_local_8, _local_5);
                }
                _local_5.push(new FurnitureItem(_local_9));
                _local_10++;
            }
        }

        function onWiredTradeInitiate(
            event:WiredTradeInitiateMessageEvent)
        {
            if (this._inventory == null || this._inventory.sessionData == null
                || this._inventory.roomSession == null)
            {
                return;
            }
            var parser= event.getParser();
            if (parser == null || parser.requirement == null)
            {
                return;
            }
            if (parser.requirement.rules != null
                && parser.requirement.rules.youGiveRule == null)
            {
                ErrorReportStorage.addDebugData(
                    "IncomingEvent",
                    "Initiated a Wired Trade where the user gives nothing");
                return;
            }
            var model= this._inventory.wiredTradingModel;
            if (model != null)
            {
                model.onWiredTradeInitiate(
                    parser.requirement,
                    parser.showRequirementsImmediate,
                    parser.overridePreviousTrade,
                    parser.timeoutSeconds);
            }
        }

        function onWiredTradeCancelled(
            event:WiredTradeCancelledMessageEvent)
        {
            var model= this._inventory.wiredTradingModel;
            var parser= event.getParser();
            if (model != null && parser != null)
            {
                model.tradeIsCancelled(parser.transactionFailureTypeId);
            }
        }

        function onWiredTradeCompleted(
            event:WiredTradeCompletedMessageEvent)
        {
            var model= this._inventory.wiredTradingModel;
            if (model != null)
            {
                model.tradeIsCompleted();
            }
        }

        function onWiredTradeItemUpdate(
            event:WiredTradeItemUpdateMessageEvent)
        {
            var parser= event.getParser();
            if (parser == null || this._inventory.furniModel == null)
            {
                return;
            }
            var tradingItems= parser.tradingItems;
            var own= new Map();
            var wired= new Map();
            if (tradingItems.secondUserNumCredits > 0)
            {
                wired.add(
                    CREDIT_GROUPITEM_TYPE_ID,
                    this._inventory.furniModel.createCreditGroupItem(
                        tradingItems.secondUserNumCredits));
            }
            this._Str_21714(tradingItems.firstUserItemArray, own, true);
            this._Str_21714(tradingItems.secondUserItemArray, wired, false);
            var model= this._inventory.wiredTradingModel;
            if (model != null)
            {
                model.updateItemGroupMaps(
                    own,
                    tradingItems.firstUserNumItems,
                    tradingItems.firstUserNumCredits,
                    wired,
                    tradingItems.secondUserNumItems,
                    tradingItems.secondUserNumCredits,
                    parser.canAccept,
                    parser.extra);
            }
        }

        function _Str_20661(k:Int):Bool
        {
            var _local_2= this._inventory.getFurnitureData(k, ProductTypeEnum.WALL);
            return (_local_2 != null) && _local_2.isExternalImageType;
        }

        function _Str_23644(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_22530(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_24409(k:IMessageEvent)
        {
            var _local_2= this._inventory._Str_3957;
            if (_local_2 != null)
            {
                _local_2._Str_6457(k);
            }
        }

        function _Str_15910(k:IMessageEvent)
        {
            if (this._inventory.wiredTradingModel != null
                && this._inventory.wiredTradingModel.running)
            {
                this._inventory.wiredTradingModel.close(false, false);
            }
            this._inventory._Str_13252();
            this._inventory.furniModel.roomLeft();
        }

        function _Str_24135(k:PetInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_4524;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            if (this._petMsgFragments == null)
            {
                this._petMsgFragments = new Vector<Map>(_local_3.totalFragments, true);
            }
            var _local_4= new Map();
            _local_4.concatenate(_local_3._Str_24388);
            var _local_5= this._Str_19767(_local_4, _local_3.totalFragments, _local_3.fragmentNo, this._petMsgFragments);
            if (_local_5 == null)
            {
                return;
            }
            this._inventory._Str_4524._Str_25168(_local_5);
            this._petMsgFragments = null;
        }

        function _Str_23427(k:PetAddedToInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_4524;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2._Str_9947(_local_3.pet);
            if (_local_3._Str_19947())
            {
            }
        }

        function _Str_25173(k:GoToBreedingNestFailureEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= "${gotobreedingnestfailure.getnest}";
            var _local_3:ASFunction = this._Str_23001;
            if (k.getParser().reason == GoToBreedingNestFailureParser._Str_17785)
            {
                _local_2 = "${gotobreedingnestfailure.getfood}";
                _local_3 = this._Str_25255;
            }
            this._inventory.windowManager.simpleAlert("${gotobreedingnestfailure.caption}", "${gotobreedingnestfailure.subtitle}", (("${gotobreedingnestfailure.message." + Std.string(k.getParser().reason)) + "}"), _local_2, "", null, null, _local_3);
        }

        function _Str_23001()
        {
            var k= this._inventory.getProperty("gotobreedingnestfailure.catalogpage.nests");
            this._inventory.catalog.openCatalogPage(k);
        }

        function _Str_25255()
        {
            var k= this._inventory.getProperty("gotobreedingnestfailure.catalogpage.food");
            this._inventory.catalog.openCatalogPage(k);
        }

        function _Str_22306(k:PetRemovedFromInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_4524;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2._Str_12321(_local_3.petId);
        }

        function _Str_23613(k:BotInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_8302;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2._Str_23563(_local_3.items);
            this._inventory._Str_5943(InventoryCategory.BOTS);
            _local_2._Str_11524();
        }

        function _Str_24595(k:BotRemovedFromInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_8302;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.removeItem(_local_3.itemId);
        }

        function _Str_23929(k:BotAddedToInventoryEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_8302;
            if (_local_2 == null)
            {
                return;
            }
            if (_local_2.items.length >= (this._inventory._Str_24829 : UInt))
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.addItem(_local_3.item);
        }

        function onMarketplaceConfiguration(k:MarketplaceConfigurationEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_6398;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.isEnabled = _local_3.enabled;
            _local_2.commission = _local_3.commission;
            _local_2.tokenBatchPrice = _local_3.credits;
            _local_2.tokenBatchSize = _local_3.advertisements;
            _local_2.offerMinPrice = _local_3.minimumPrice;
            _local_2.offerMaxPrice = _local_3.maximumPrice;
            _local_2.expirationHours = _local_3.offerTime;
            _local_2.averagePricePeriod = _local_3.displayTime;
            this._inventory._Str_5943(InventoryCategory.MARKETPLACE);
            var _local_4= this._inventory.furniModel;
            if (_local_4 != null)
            {
                _local_4.updateView();
            }
        }

        function _Str_25747(k:MarketplaceCanMakeOfferResult)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_6398;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.proceedOfferMaking(_local_3.resultCode, _local_3._Str_24601);
        }

        function onMarketplaceMakeOfferResult(k:MarketplaceMakeOfferResult)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_6398;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.endOfferMaking(_local_3.result);
        }

        function onMarketplaceItemStats(k:MarketplaceItemStatsEvent)
        {
            if (((k == null) || (this._inventory == null)))
            {
                return;
            }
            var _local_2= this._inventory._Str_6398;
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= k.getParser();
            _local_2.setAveragePrice(_local_3.furniCategoryId, _local_3.furniTypeId, _local_3.averagePrice);
        }

        function onNotEnoughCredits(k:NotEnoughBalanceMessageEvent)
        {
            if (((!(k != null)) || (!(this._inventory != null))))
            {
                return;
            }
            var _local_2= this._inventory._Str_6398;
            if (_local_2 == null)
            {
                return;
            }
            _local_2.onNotEnoughCredits();
        }

        function onUserRights(k:IMessageEvent)
        {
            var _local_2:MarketplaceModel = null;
            if (this._inventory._Str_18826(InventoryCategory.MARKETPLACE))
            {
                _local_2 = this._inventory._Str_6398;
                if (_local_2 == null)
                {
                    return;
                }
                _local_2.onInventoryOpen();
            }
        }

        function _Str_25862(k:FigureSetIdsEvent)
        {
            this._inventory._Str_22773(k.getParser()._Str_23010, k.getParser()._parser9);
        }

        function onRoomEnter(k:IMessageEvent)
        {
            if (this._inventory.getBoolean("effects.reactivate.on.room.entry"))
            {
                this._inventory._Str_3994._Str_24964();
            }
            this._inventory.furniModel.roomEntered();
        }

        function _Str_19767(k:Map, _arg_2:Int, _arg_3:Int, _arg_4:Vector<Map>):Map
        {
            var _local_5:Map = null;
            var _local_6:Map = null;
            var _local_7:Map = null;
            if (_arg_2 == 1)
            {
                return k;
            }
            _arg_4[_arg_3] = k;
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_5  = _tmp_;
                if (_local_5 == null)
                {
                    return null;
                }
            }
            _local_6 = new Map();
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4)
            {
_local_7  = _tmp_;
                _local_6.concatenate(_local_7);
                _local_7.dispose();
            }
            _arg_4 = null;
            return _local_6;
        }
    }

