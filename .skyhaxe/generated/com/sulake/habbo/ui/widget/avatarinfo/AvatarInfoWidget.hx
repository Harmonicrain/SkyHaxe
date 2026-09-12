package com.sulake.habbo.ui.widget.avatarinfo
;
	import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotChangeMottoConfiguration;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.utils.Timer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryEffectsEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.AvatarInfoWidgetHandler;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.events._Str_3858;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotSkillConfigurationViewBase;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotForceOpenContextMenuEvent;
    import com.sulake.habbo.ui.widget.events._Str_5375;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_5393;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetFurniInfostandUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetInfostandUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_7783;
    import com.sulake.habbo.ui.widget.events._Str_3345;
    import com.sulake.habbo.ui.widget.events._Str_3735;
    import com.sulake.habbo.ui.widget.events._Str_4828;
    import com.sulake.habbo.ui.widget.events._Str_4818;
    import com.sulake.habbo.ui.widget.events._Str_4736;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetBreedingEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetInventoryUpdatedMessage;
    import com.sulake.habbo.ui.widget.events._Str_4624;
    import com.sulake.habbo.ui.widget.events._Str_3962;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import com.sulake.room.utils.RoomEnterEffect;
    import com.sulake.habbo.ui.widget.contextmenu.ContextInfoView;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.widget.events._Str_3174;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetGetObjectLocationMessage;
    import com.sulake.habbo.avatar._enum.AvatarEditorInstanceId;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.habbo.ui.widget.memenu.IWidgetAvatarEffect;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetCommandsUpdateEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.ui.widget.events.ConfirmPetBreedingPetData;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.pets.BreedPetsMessageComposer;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotSkillsEnum;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotChatterMarkovConfiguration;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotChangeNameConfiguration;
    import com.sulake.habbo.ui.widget.avatarinfo.botskills.BotSkillConfigurationView;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.outgoing.inventory.pets.CancelPetBreedingComposer;
    import com.sulake.habbo.communication.messages.outgoing.inventory.pets.ConfirmPetBreedingComposer;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.roomevents.events.WiredUserClickHandledEvent;

     class AvatarInfoWidget extends RoomWidgetBase implements IUpdateReceiver implements  IContextMenuParentWidget
    {
        static inline final EFFECT_TYPE_RIDE= 77;
        static inline final EFFECT_TYPE_DEEP_WATER= 29;
        static inline final EFFECT_TYPE_SHALLOW_WATER= 30;
        static inline final EFFECT_TYPE_DEEP_WATER_DARK= 185;
        static inline final AVATAR_HIGHLIGHT_DURATION_MSEC= 5000;
        static inline final AVATAR= "avatar";
        static inline final MINIMIZED_MENU_KEY= "use_minimized_own_avatar_menu";

        var _component:Component;
        var _configuration:IHabboConfigurationManager;
        var _view:AvatarContextInfoButtonView;
        var _decoModeView:DecorateModeView;
        var _isInitialized:Bool = false;
        var _isGameMode:Bool = false;
        var _isRoomEnteredOwnAvatarHighlight:Bool = false;
        var _avatarHighlightTimer:Timer;
        var _userInfoData:AvatarInfoData;
        var _rentableBotInfoData:RentableBotInfoData;
        var _petInfoData:PetInfoData;
        var _lastRollOverId:Int = -1;
        var _recycleViews:Bool = false;
        var _cachedNameView:AvatarContextInfoButtonView;
        var _cachedOwnAvatarMenu:OwnAvatarMenuView;
        var _cachedAvatarMenuView:AvatarMenuView;
        var _cachedRentableBotMenuView:RentableBotMenuView;
        var _cachedOwnPetMenuView:OwnPetMenuView;
        var _cachedPetMenuView:PetMenuView;
        var _cachedNewUserHelpView:NewUserHelpView;
        var _avatarNameBubbles:Map;
        var _useProductBubbles:Map;
        var _breedPetBubbles:Map;
        var _useProductConfirmationView:UseProductConfirmationView;
        var _breedMonsterPlantsConfirmationView:BreedMonsterPlantsConfirmationView;
        var _confirmPetBreedingView:ConfirmPetBreedingView;
        var _breedPetsResultView:BreedPetsResultView;
        var _breedingConfirmationAlert:IAlertDialog;
        var _breedingConfirmationAlertRequestRoomObjectId:Int = -1;
        var _breedingConfirmationAlertTargetRoomObjectId:Int = -1;
        var _isDancing:Bool = false;
        var _handlePetInfo:Bool = true;
        var _catalog:IHabboCatalog;
        var _botSkillConfigurationViews:Map;
        var _botSkillsWithCommandsMap:Map;
        var _nestBreedingSuccessView:NestBreedingSuccessView;
        var _pendingWiredClickUserId:Int = -1;
        var _pendingWiredClickUserName:String;
        var _pendingWiredClickUserType:Int = 0;
        var _pendingWiredClickRoomIndex:Int = -1;
        var _pendingWiredClickAllowNameChange:Bool = false;
        var _pendingWiredClickAvatarInfoData:AvatarInfoData;
        var _openingWiredClickMenu:Bool = false;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboConfigurationManager, _arg_5:IHabboLocalizationManager, _arg_6:Component, _arg_7:IHabboCatalog)
        {
            this._botSkillConfigurationViews = new Map();
            this._botSkillsWithCommandsMap = new Map();
            super(k, _arg_2, _arg_3, _arg_5);
            this._component = _arg_6;
            this._catalog = _arg_7;
            this._configuration = _arg_4;
            this._userInfoData = new AvatarInfoData();
            this._petInfoData = new PetInfoData();
            this._rentableBotInfoData = null;
            this._avatarNameBubbles = new Map();
            this._useProductBubbles = new Map();
            this._breedPetBubbles = new Map();
            this.handler.roomEngine.events.addEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
            this.handler.roomEngine.events.addEventListener(RoomEngineObjectEvent.REMOVED, this._Str_4159);
            this.handler.container.inventory.events.addEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this._Str_10320);
            if (this.handler.container.userDefinedRoomEvents != null)
            {
                this.handler.container.userDefinedRoomEvents.events.addEventListener(WiredUserClickHandledEvent.WIRED_USER_CLICK_HANDLED, this.onUserClickHandledEvent);
            }
            this.handler.widget = this;
        }

        public var component(get,never):Component;
public function  get_component():Component
        {
            return this._component;
        }

        public var handler(get,never):AvatarInfoWidgetHandler;
public function  get_handler():AvatarInfoWidgetHandler
        {
            return Std.downcast(_handler , AvatarInfoWidgetHandler);
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this._configuration;
        }

        public var localization(get,never):IHabboLocalizationManager;
public function  get_localization():IHabboLocalizationManager
        {
            return _localizations;
        }

        public var _Str_25663(never,set):Bool;
public function  set__Str_25663(k:Bool):Bool        {
            return this._handlePetInfo = k;
        }

        function onRoomObjectAdded(k:RoomEngineObjectEvent)
        {
            var _local_2:RoomUserData = null;
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
            {
                _local_2 = this.handler.roomSession.userDataManager.getUserDataByIndex(k.objectId);
                if (_local_2 != null)
                {
                    if (this.handler.friendList.getFriendNames().indexOf(_local_2.name) > -1)
                    {
                        this._Str_21156(_local_2, k.objectId);
                    }
                }
            }
        }

        function _Str_4159(k:RoomEngineObjectEvent)
        {
            var _local_2 = 0;
            var _local_3:UserNameView = null;
            var _local_4:Array<ASAny> = null;
            var _local_5:BreedPetView = null;
            var _local_6 = 0;
            var _local_7:Array<ASAny> = null;
            var _local_8:UseProductView = null;
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
            {
                final _iter_ = this._avatarNameBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_3  = _tmp_;
                    if (_local_3.objectId == k.objectId)
                    {
                        this.removeView(_local_3, false);
                    }
                }
                _local_4 = [];
                final _iter_ = this._breedPetBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_5  = _tmp_;
                    _local_2 = _local_5._Str_3710;
                    if (_local_2 == _local_6)
                    {
                        _local_4.push(_local_5);
                    }
                }
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
                {
_local_5  = _tmp_;
                    this.removeView(_local_5, false);
                }
                if (this._breedMonsterPlantsConfirmationView != null)
                {
                    if (((k.objectId == this._breedMonsterPlantsConfirmationView._Str_3710) || (k.objectId == this._breedMonsterPlantsConfirmationView._Str_5563)))
                    {
                        this._Str_8286();
                    }
                }
                if (this._confirmPetBreedingView != null)
                {
                    if (((k.objectId == this._confirmPetBreedingView._Str_3710) || (k.objectId == this._confirmPetBreedingView._Str_5563)))
                    {
                        this._Str_10453();
                    }
                }
                if (this._useProductConfirmationView != null)
                {
                    if (((k.objectId == this._useProductConfirmationView._Str_20466) || (k.objectId == this._useProductConfirmationView._Str_5563)))
                    {
                        this.removeUseProductConfirmationView();
                    }
                }
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
            {
                _local_6 = k.objectId;
                if (this._useProductConfirmationView != null)
                {
                    if (this._useProductConfirmationView._Str_20466 == _local_6)
                    {
                        this.removeUseProductConfirmationView();
                    }
                }
                if (this._breedPetsResultView != null)
                {
                    this._breedPetsResultView._Str_17192(_local_6);
                }
                _local_7 = [];
                final _iter_ = this._useProductBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_8  = _tmp_;
                    _local_2 = _local_8._Str_3710;
                    if (_local_2 == _local_6)
                    {
                        _local_7.push(_local_8);
                    }
                }
                if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
                {
_local_8  = _tmp_;
                    this.removeView(_local_8, false);
                }
            }
        }

        public function _Str_23386(k:Array<ASAny>)
        {
            var _local_2:_Str_3858 = null;
            var _local_3:RoomUserData = null;
            this.removeUseProductViews();
            this.removeUseProductConfirmationView();
            this._Str_8286();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = this.handler.roomSession.userDataManager.getUserDataByIndex(_local_2.id);
                this.showUseProductMenu(_local_3, _local_2);
            }
        }

        public function _Str_24967(k:Array<ASAny>)
        {
            var _local_2:_Str_3858 = null;
            var _local_3:RoomUserData = null;
            this._Str_11447();
            this.removeUseProductConfirmationView();
            this._Str_8286();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = this.handler.roomSession.userDataManager.getUserDataByIndex(_local_2.id);
                this.showBreedPetMenu(_local_3, _local_2);
            }
        }

        function _Str_10320(k:HabboInventoryEffectsEvent)
        {
            if (Std.is(this._view , OwnAvatarMenuView))
            {
                Std.downcast(this._view , OwnAvatarMenuView)._Str_2771();
            }
        }

        function _Str_25716()
        {
            messageListener.processWidgetMessage(new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OWN_CHARACTER_INFO, 0, 0));
        }

        override public function dispose()
        {
            var k:UserNameView = null;
            var _local_2:UseProductView = null;
            var _local_3:BreedPetView = null;
            var _local_4 = 0;
            var _local_5:AvatarInfoWidgetHandler = null;
            if (disposed)
            {
                return;
            }
            this.removeAvatarHighlightTimer();
            if (this._avatarNameBubbles != null)
            {
                final _iter_ = this._avatarNameBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._avatarNameBubbles = null;
            }
            if (this._useProductBubbles != null)
            {
                final _iter_ = this._useProductBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_2  = _tmp_;
                    _local_2.dispose();
                }
                this._useProductBubbles = null;
            }
            if (this._breedPetBubbles != null)
            {
                final _iter_ = this._breedPetBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
_local_3  = _tmp_;
                    _local_3.dispose();
                }
                this._breedPetBubbles = null;
            }
            if (this._component != null)
            {
                this._component.removeUpdateReceiver(this);
                this._component = null;
            }
            if (this._cachedNameView != null)
            {
                this._cachedNameView.dispose();
                this._cachedNameView = null;
            }
            if (this._cachedAvatarMenuView != null)
            {
                this._cachedAvatarMenuView.dispose();
                this._cachedAvatarMenuView = null;
            }
            if (this._cachedOwnAvatarMenu != null)
            {
                this._cachedOwnAvatarMenu.dispose();
                this._cachedOwnAvatarMenu = null;
            }
            if (this._cachedRentableBotMenuView != null)
            {
                this._cachedRentableBotMenuView.dispose();
                this._cachedRentableBotMenuView = null;
            }
            if (this._cachedPetMenuView != null)
            {
                this._cachedPetMenuView.dispose();
                this._cachedPetMenuView = null;
            }
            if (this._view != null)
            {
                if (!this._view.disposed)
                {
                    this._view.dispose();
                    this._view = null;
                }
            }
            if (this._decoModeView != null)
            {
                this._decoModeView.dispose();
                this._decoModeView = null;
            }
            if (this._useProductConfirmationView != null)
            {
                this._useProductConfirmationView.dispose();
                this._useProductConfirmationView = null;
            }
            this._Str_8286();
            this._Str_10453();
            if (this._breedPetsResultView != null)
            {
                this._breedPetsResultView.dispose();
                this._breedPetsResultView = null;
            }
            if (this._breedingConfirmationAlert != null)
            {
                this._breedingConfirmationAlert.dispose();
                this._breedingConfirmationAlert = null;
            }
            if (this._botSkillConfigurationViews != null)
            {
                final _iter_ = this._botSkillConfigurationViews.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = ASCompat.toInt(_tmp_);
                    cast(this._botSkillConfigurationViews.getValue(_local_4), BotSkillConfigurationViewBase).dispose();
                }
                this._botSkillConfigurationViews.dispose();
                this._botSkillConfigurationViews = null;
            }
            if (((this._botSkillsWithCommandsMap != null) && (this._botSkillsWithCommandsMap.length > 0)))
            {
                this._botSkillsWithCommandsMap.dispose();
                this._botSkillsWithCommandsMap = null;
            }
            _local_5 = this.handler;
            if (((_local_5 != null) && (_local_5.roomEngine != null)) && (_local_5.roomEngine.events != null))
            {
                _local_5.roomEngine.events.removeEventListener(RoomEngineObjectEvent.ADDED, this.onRoomObjectAdded);
                _local_5.roomEngine.events.removeEventListener(RoomEngineObjectEvent.REMOVED, this._Str_4159);
            }
            if (((((_local_5 != null) && (_local_5.container != null)) && (_local_5.container.inventory != null)) && (_local_5.container.inventory.events != null)))
            {
                _local_5.container.inventory.events.removeEventListener(HabboInventoryEffectsEvent.HIEE_EFFECTS_CHANGED, this._Str_10320);
            }
            if (((((_local_5 != null) && (_local_5.container != null)) && (_local_5.container.userDefinedRoomEvents != null)) && (_local_5.container.userDefinedRoomEvents.events != null)))
            {
                _local_5.container.userDefinedRoomEvents.events.removeEventListener(WiredUserClickHandledEvent.WIRED_USER_CLICK_HANDLED, this.onUserClickHandledEvent);
            }
            this._view = null;
            this._configuration = null;
            super.dispose();
        }

        public function close()
        {
            this.removeView(this._view, false);
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetRentableBotForceOpenContextMenuEvent.OPEN, this.updateEventHandler);
            k.addEventListener(_Str_5375.RWRBSLUE_SKILL_LIST, this.updateEventHandler);
            k.addEventListener(RoomWidgetRentableBotInfoUpdateEvent.RENTABLE_BOT, this.updateEventHandler);
            k.addEventListener(_Str_5393.RWAIE_AVATAR_INFO, this.updateEventHandler);
            k.addEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.updateEventHandler);
            k.addEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this.updateEventHandler);
            k.addEventListener(RoomWidgetFurniInfostandUpdateEvent.FURNI, this.updateEventHandler);
            k.addEventListener(RoomWidgetUserInfoUpdateEvent.BOT, this.updateEventHandler);
            k.addEventListener(RoomWidgetPetInfostandUpdateEvent.PET_INFO, this.updateEventHandler);
            k.addEventListener(_Str_7783.RWUDUE_USER_DATA_UPDATED, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.updateEventHandler);
            k.addEventListener(_Str_3345.RWREUE_NORMAL_MODE, this.updateEventHandler);
            k.addEventListener(_Str_3345.RWREUE_GAME_MODE, this.updateEventHandler);
            k.addEventListener(_Str_3735.RWONE_TYPE, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OVER, this.updateEventHandler);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OUT, this.updateEventHandler);
            k.addEventListener(_Str_4828.RWPIUE_PET_STATUS_UPDATE, this.updateEventHandler);
            k.addEventListener(_Str_4818.RWPLUE_PET_LEVEL_UPDATE, this.updateEventHandler);
            k.addEventListener(_Str_4736.RWPBRE_PET_BREEDING_RESULT, this.updateEventHandler);
            k.addEventListener(RoomWidgetPetBreedingEvent.PET_BREEDING, this.updateEventHandler);
            k.addEventListener(RoomWidgetInventoryUpdatedMessage.RWIUM_INVENTORY_UPDATED, this.updateEventHandler);
            k.addEventListener(_Str_4624.RWPPBE_CONFIRM_PET_BREEDING_, this.updateEventHandler);
            k.addEventListener(_Str_3962.RWPPBE_CONFIRM_PET_BREEDING_RESULT, this.updateEventHandler);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetRentableBotForceOpenContextMenuEvent.OPEN, this.updateEventHandler);
            k.removeEventListener(_Str_5375.RWRBSLUE_SKILL_LIST, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRentableBotInfoUpdateEvent.RENTABLE_BOT, this.updateEventHandler);
            k.removeEventListener(_Str_5393.RWAIE_AVATAR_INFO, this.updateEventHandler);
            k.removeEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.updateEventHandler);
            k.removeEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this.updateEventHandler);
            k.removeEventListener(RoomWidgetFurniInfostandUpdateEvent.FURNI, this.updateEventHandler);
            k.removeEventListener(RoomWidgetUserInfoUpdateEvent.BOT, this.updateEventHandler);
            k.removeEventListener(RoomWidgetPetInfostandUpdateEvent.PET_INFO, this.updateEventHandler);
            k.removeEventListener(_Str_7783.RWUDUE_USER_DATA_UPDATED, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.updateEventHandler);
            k.removeEventListener(_Str_3345.RWREUE_NORMAL_MODE, this.updateEventHandler);
            k.removeEventListener(_Str_3345.RWREUE_GAME_MODE, this.updateEventHandler);
            k.removeEventListener(_Str_3735.RWONE_TYPE, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OUT, this.updateEventHandler);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OUT, this.updateEventHandler);
            k.removeEventListener(_Str_4828.RWPIUE_PET_STATUS_UPDATE, this.updateEventHandler);
            k.removeEventListener(_Str_4818.RWPLUE_PET_LEVEL_UPDATE, this.updateEventHandler);
            k.removeEventListener(_Str_4736.RWPBRE_PET_BREEDING_RESULT, this.updateEventHandler);
            k.removeEventListener(RoomWidgetPetBreedingEvent.PET_BREEDING, this.updateEventHandler);
            k.removeEventListener(RoomWidgetInventoryUpdatedMessage.RWIUM_INVENTORY_UPDATED, this.updateEventHandler);
            k.removeEventListener(_Str_4624.RWPPBE_CONFIRM_PET_BREEDING_, this.updateEventHandler);
            k.removeEventListener(_Str_3962.RWPPBE_CONFIRM_PET_BREEDING_RESULT, this.updateEventHandler);
        }

        function updateEventHandler(k:RoomWidgetUpdateEvent)
        {
            var _local_2:_Str_5393 = null;
            var _local_3:_Str_4828 = null;
            var _local_4:_Str_4818 = null;
            var _local_5:_Str_4736 = null;
            var _local_6:BreedPetsResultData = null;
            var _local_7:BreedPetsResultData = null;
            var _local_8:RoomWidgetPetBreedingEvent = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:_Str_4624 = null;
            var _local_12:_Str_3962 = null;
            var _local_13:RoomWidgetUserInfoUpdateEvent = null;
            var _local_14:AvatarInfoData = null;
            var _local_15:RoomWidgetRentableBotInfoUpdateEvent = null;
            var _local_16:IRoomSession = null;
            var _local_17:RoomUserData = null;
            var _local_18:_Str_5375 = null;
            var _local_19:RoomWidgetRentableBotForceOpenContextMenuEvent = null;
            var _local_20:RoomWidgetUserInfoUpdateEvent = null;
            var _local_21:RoomWidgetRoomObjectUpdateEvent = null;
            var _local_22:RoomUserData = null;
            var _local_23:RoomUserData = null;
            var _local_24 = 0;
            var _local_25:RoomUserData = null;
            var _local_26:RoomWidgetPetInfostandUpdateEvent = null;
            var _local_27:UserNameView = null;
            // A disposed widget can still receive in-flight room-object events (e.g. a furni
            // click routed via RoomDesktop). dispose() nulls the bubble maps, so handlers like
            // _Str_11447() would hit `_breedPetBubbles.reset()` on null -> #1009. Bail early.
            if (disposed)
            {
                return;
            }
            switch (k.type)
            {
                case _Str_5393.RWAIE_AVATAR_INFO:
                    _local_2 = Std.downcast(k , _Str_5393);
                    this._isRoomEnteredOwnAvatarHighlight = (((!this._isInitialized) && (!(this.handler.container.roomSession == null))) && (_local_2.roomIndex == this.handler.container.roomSession.ownUserRoomId));
                    if (_local_2.allowNameChange)
                    {
                        this.useMinimizedOwnAvatarMenu = true;
                        this._Str_19679();
                    }
                    else
                    {
                        this.updateUserView(_local_2.userId, _local_2.userName, _local_2.userType, _local_2.roomIndex, _local_2.allowNameChange, null);
                    }
                    this._isInitialized = true;
                    
                case _Str_3735.RWONE_TYPE:
                    if (cast(k, _Str_3735).category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                    {
                        this.updateUserView(cast(k, _Str_3735).userId, cast(k, _Str_3735).userName, cast(k, _Str_3735).userType, cast(k, _Str_3735).roomIndex, false, null);
                    }
                    
                case RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED:
                    if (cast(k, RoomWidgetRoomObjectUpdateEvent).category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
                    {
                        if (this._breedPetsResultView != null)
                        {
                            this._breedPetsResultView._Str_23033(cast(k, RoomWidgetRoomObjectUpdateEvent).id);
                        }
                    }
                    
                case RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED:
                    if (cast(k, RoomWidgetRoomObjectUpdateEvent).category == RoomObjectCategoryEnum.OBJECT_CATEGORY_USER)
                    {
                        this._handlePetInfo = true;
                    }
                    this._Str_11447();
                    
                case RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED:
                    if (((this._view != null) && (!Std.is(this._view , NewUserHelpView))))
                    {
                        this.removeView(this._view, false);
                    }
                    this.removeUseProductViews();
                    this._Str_11447();
                    
                case RoomWidgetFurniInfostandUpdateEvent.FURNI:
                    if (this._view != null)
                    {
                        this.removeView(this._view, false);
                    }
                    this.removeUseProductViews();
                    this._Str_11447();
                    
                case RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OVER:
                    if (this._isRoomEnteredOwnAvatarHighlight)
                    {
                        return;
                    }
                    if (!((((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)) || Std.is(this._view , OwnPetMenuView)) || Std.is(this._view , NewUserHelpView)) || Std.is(this._view , RentableBotMenuView)))
                    {
                        this._lastRollOverId = cast(k, RoomWidgetRoomObjectUpdateEvent).id;
                        messageListener.processWidgetMessage(new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OBJECT_NAME, cast(k, RoomWidgetRoomObjectUpdateEvent).id, cast(k, RoomWidgetRoomObjectUpdateEvent).category));
                    }
                    
                case RoomWidgetRoomObjectUpdateEvent.OBJECT_ROLL_OUT:
                    if (this._isRoomEnteredOwnAvatarHighlight)
                    {
                        return;
                    }
                    if (!((((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)) || Std.is(this._view , OwnPetMenuView)) || Std.is(this._view , NewUserHelpView)) || Std.is(this._view , RentableBotMenuView)))
                    {
                        if (cast(k, RoomWidgetRoomObjectUpdateEvent).id == this._lastRollOverId)
                        {
                            if (((this._view != null) && (!this._view.allowNameChange)))
                            {
                                this.removeView(this._view, false);
                                this._lastRollOverId = -1;
                            }
                        }
                    }
                    
                case _Str_4828.RWPIUE_PET_STATUS_UPDATE:
                    _local_3 = Std.downcast(k , _Str_4828);
                    if (((this._view != null) && Std.is(this._view , OwnPetMenuView)))
                    {
                        if (((!(_local_3 == null)) && (!(this._petInfoData == null))))
                        {
                            _local_22 = this.handler.roomSession.userDataManager.getUserDataByIndex(_local_3.petId);
                            if (((!(_local_22 == null)) && (_local_22.id == this._petInfoData.id)))
                            {
                                this.removeView(this._view, true);
                            }
                        }
                    }
                    if (_local_3 != null)
                    {
                        this._Str_18983(_local_3.petId);
                    }
                    
                case _Str_4818.RWPLUE_PET_LEVEL_UPDATE:
                    _local_4 = Std.downcast(k , _Str_4818);
                    if (((this._view != null) && Std.is(this._view , OwnPetMenuView)))
                    {
                        if (((!(_local_4 == null)) && (!(this._petInfoData == null))))
                        {
                            _local_23 = this.handler.roomSession.userDataManager.getUserDataByIndex(_local_4.petId);
                            if (((!(_local_23 == null)) && (_local_23.id == this._petInfoData.id)))
                            {
                                this.removeView(this._view, true);
                            }
                        }
                    }
                    if (_local_4 != null)
                    {
                        this._Str_18983(_local_4.petId);
                    }
                    
                case _Str_4736.RWPBRE_PET_BREEDING_RESULT:
                    _local_5 = Std.downcast(k , _Str_4736);
                    _local_6 = new BreedPetsResultData();
                    _local_6.stuffId = _local_5._Str_3713.stuffId;
                    _local_6.classId = _local_5._Str_3713.classId;
                    _local_6.productCode = _local_5._Str_3713.productCode;
                    _local_6.userId = _local_5._Str_3713.userId;
                    _local_6.userName = _local_5._Str_3713.userName;
                    _local_6.rarityLevel = _local_5._Str_3713.rarityLevel;
                    _local_6._Str_4788 = _local_5._Str_3713._Str_4788;
                    _local_7 = new BreedPetsResultData();
                    _local_7.stuffId = _local_5.resultData2.stuffId;
                    _local_7.classId = _local_5.resultData2.classId;
                    _local_7.productCode = _local_5.resultData2.productCode;
                    _local_7.userId = _local_5.resultData2.userId;
                    _local_7.userName = _local_5.resultData2.userName;
                    _local_7.rarityLevel = _local_5.resultData2.rarityLevel;
                    _local_7._Str_4788 = _local_5.resultData2._Str_4788;
                    this._Str_23663(_local_6, _local_7);
                    
                case RoomWidgetPetBreedingEvent.PET_BREEDING:
                    _local_8 = Std.downcast(k , RoomWidgetPetBreedingEvent);
                    _local_9 = this._Str_12418(_local_8.ownPetId);
                    _local_10 = this._Str_12418(_local_8.otherPetId);
                    switch (_local_8.state)
                    {
                        case RoomWidgetPetBreedingEvent.TYPE_START:
                            this._Str_16495(_local_9, _local_10, false);
                            
                        case RoomWidgetPetBreedingEvent.TYPE_CANCEL:
                            this.cancelBreedingPets(_local_9, _local_10);
                            
                        case RoomWidgetPetBreedingEvent.TYPE_ACCEPT:
                            this.acceptBreedingPets(_local_9, _local_10);
                            
                        case RoomWidgetPetBreedingEvent.TYPE_REQUEST:
                            this._Str_16495(_local_9, _local_10, true);
                            
                    }
                    
                case RoomWidgetInventoryUpdatedMessage.RWIUM_INVENTORY_UPDATED:
                    if (this._breedPetsResultView != null)
                    {
                        this._breedPetsResultView._Str_16499();
                    }
                    
                case _Str_4624.RWPPBE_CONFIRM_PET_BREEDING_:
                    _local_11 = Std.downcast(k , _Str_4624);
                    this._Str_22316(_local_11.pet1, _local_11.pet2, _local_11.nestId, _local_11.rarityCategories, _local_11.resultPetTypeId);
                    
                case _Str_3962.RWPPBE_CONFIRM_PET_BREEDING_RESULT:
                    _local_12 = Std.downcast(k , _Str_3962);
                    switch (_local_12.result)
                    {
                        case _Str_3962._Str_5196:
                            this._Str_10453();
                            
                        case _Str_3962.INVALID_NAME:
                            windowManager.simpleAlert("${breedpets.confirmation.alert.title}", "${breedpets.confirmation.alert.name.invalid.head}", "${breedpets.confirmation.alert.name.invalid.desc}");
                            if (this._confirmPetBreedingView != null)
                            {
                                this._confirmPetBreedingView.enable();
                            }
                            
                        case _Str_3962._Str_16705:
                            windowManager.simpleAlert("${breedpets.confirmation.alert.title}", "${breedpets.confirmation.alert.nonest.head}", "${breedpets.confirmation.alert.nonest.desc}");
                            this._Str_10453();
                            
                        case _Str_3962._Str_18855:
                            windowManager.simpleAlert("${breedpets.confirmation.alert.title}", "${breedpets.confirmation.alert.petsmissing.head}", "${breedpets.confirmation.alert.petsmissing.desc}");
                            this._Str_10453();
                            
                    }
                    
                case RoomWidgetUserInfoUpdateEvent.OWN_USER
                   | RoomWidgetUserInfoUpdateEvent.PEER:
                    _local_13 = Std.downcast(k , RoomWidgetUserInfoUpdateEvent);
                    this._userInfoData.populate(_local_13);
                    _local_14 = (_local_13.isSpectatorMode ? null : this._userInfoData);
                    this.updateUserView(_local_13.id, _local_13.name, _local_13.userType, _local_13.userRoomId, this._userInfoData.allowNameChange, _local_14);
                    
                case RoomWidgetRentableBotInfoUpdateEvent.RENTABLE_BOT:
                    _local_15 = Std.downcast(k , RoomWidgetRentableBotInfoUpdateEvent);
                    if (this._rentableBotInfoData == null)
                    {
                        this._rentableBotInfoData = new RentableBotInfoData();
                    }
                    this._rentableBotInfoData.populate(_local_15);
                    _local_16 = this.handler.container.roomSessionManager.getSession(_local_24);
                    if (_local_16 == null)
                    {
                        return;
                    }
                    _local_17 = _local_16.userDataManager._Str_17237(_local_15.id);
                    if (_local_17 == null)
                    {
                        return;
                    }
                    this._botSkillsWithCommandsMap.setProperty(Std.string(_local_15.id), _local_17.botSkillData);
                    if (((this._rentableBotInfoData != null) && (_local_17.botSkillData != null)))
                    {
                        this._rentableBotInfoData._Str_19891(_local_17.botSkillData);
                    }
                    this.updateRentableBotView(_local_15.id, _local_15.name, _local_15.userRoomId, this._rentableBotInfoData);
                    
                case _Str_5375.RWRBSLUE_SKILL_LIST:
                    _local_18 = Std.downcast(k , _Str_5375);
                    this._botSkillsWithCommandsMap.setProperty(Std.string(_local_18.botId), _local_18._Str_10833);
                    if (this._rentableBotInfoData != null)
                    {
                        this._rentableBotInfoData._Str_19891(_local_18._Str_10833);
                        this.updateRentableBotView(this._rentableBotInfoData.id, this._rentableBotInfoData.name, this._rentableBotInfoData.roomIndex, this._rentableBotInfoData, true);
                    }
                    
                case RoomWidgetRentableBotForceOpenContextMenuEvent.OPEN:
                    _local_19 = Std.downcast(k , RoomWidgetRentableBotForceOpenContextMenuEvent);
                    if (this._rentableBotInfoData != null)
                    {
                        this.updateRentableBotView(this._rentableBotInfoData.id, this._rentableBotInfoData.name, this._rentableBotInfoData.roomIndex, this._rentableBotInfoData, false, true);
                    }
                    else
                    {
                        _local_24 = this.handler.container.roomEngine.activeRoomId;
                        _local_25 = this.handler.container.roomSessionManager.getSession(_local_24).userDataManager.getUserDataByType(_local_19.botId, 4);
                        messageListener.processWidgetMessage(new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OBJECT_INFO, _local_25.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER));
                        this.handler.container.roomEngine.selectAvatar(_local_24, _local_25.roomObjectId);
                    }
                    
                case RoomWidgetUserInfoUpdateEvent.BOT:
                    _local_20 = Std.downcast(k , RoomWidgetUserInfoUpdateEvent);
                    this.updateUserView(_local_20.id, _local_20.name, _local_20.userType, _local_20.userRoomId, false, null);
                    
                case RoomWidgetPetInfostandUpdateEvent.PET_INFO:
                    if (this._handlePetInfo)
                    {
                        _local_26 = Std.downcast(k , RoomWidgetPetInfostandUpdateEvent);
                        this._petInfoData.populate(_local_26);
                        this.updatePetView(_local_26.id, _local_26.name, _local_26.roomIndex, this._petInfoData);
                    }
                    
                case _Str_7783.RWUDUE_USER_DATA_UPDATED:
                    if (!this._isInitialized)
                    {
                        this._Str_25716();
                    }
                    
                case RoomWidgetRoomObjectUpdateEvent.USER_REMOVED:
                    _local_21 = Std.downcast(k , RoomWidgetRoomObjectUpdateEvent);
                    if (((this._view != null) && (this._view.roomIndex == _local_21.id)))
                    {
                        this.removeView(this._view, false);
                    }
                    final _iter_ = this._avatarNameBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                    {
_local_27  = _tmp_;
                        if (_local_27.objectId == _local_21.id)
                        {
                            this.removeView(_local_27, false);
                            break;
                        }
                    }
                    this._Str_18983(_local_21.id);
                    
                case _Str_3345.RWREUE_NORMAL_MODE:
                    this._isGameMode = false;
                    
                case _Str_3345.RWREUE_GAME_MODE:
                    this._isGameMode = true;
                    
            }
            this.checkUpdateNeed();
        }

        function _Str_12418(k:Int):Int
        {
            var _local_5:IRoomObject = null;
            var _local_6:RoomUserData = null;
            var _local_2= this.handler.container.roomSession.roomId;
            var _local_3= this.handler.container.roomEngine.getRoomObjectCount(_local_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_5 = this.handler.container.roomEngine.getRoomObjectWithIndex(_local_2, _local_4, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_6 = this.handler.container.roomSession.userDataManager.getUserDataByIndex(_local_5.getId());
                if (((_local_6 == null) || (!(_local_6.type == RoomObjectTypeEnum.PET))))
                {
                }
                else
                {
                    if (_local_6.id == k)
                    {
                        return _local_5.getId();
                    }
                }
                _local_4++;
            }
            return -1;
        }

        function _Str_18983(k:Int)
        {
            var _local_3:BreedPetView = null;
            var _local_4:BreedPetView = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._breedPetBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_3  = _tmp_;
                if (((_local_3.objectId == k) || (_local_3._Str_3710 == k)))
                {
                    if (_local_2.indexOf(_local_3) == -1)
                    {
                        _local_2.push(_local_3);
                    }
                }
            }
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_4  = _tmp_;
                this.removeView(_local_4, false);
            }
        }

        public function _Str_19679()
        {
            var _local_3:RoomWidgetRoomObjectMessage = null;
            if ((((!(this.handler != null)) || (!(this.handler.container != null))) || (!(this.handler.roomSession != null))))
            {
                return;
            }
            var k= this.handler.container.sessionDataManager.userId;
            var _local_2= this.handler.roomSession.userDataManager.getUserData(k);
            if (_local_2 == null)
            {
                return;
            }
            _local_3 = new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_SELECT_OBJECT, _local_2.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            this.handler.container.processWidgetMessage(_local_3);
        }

        public var _Str_22586(get,never):String;
public function  get__Str_22586():String
        {
            var _local_2:IRoomObjectModel = null;
            var k= this._Str_13836();
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    return _local_2.getString(RoomObjectVariableEnum.FIGURE_POSTURE);
                }
            }
            return AvatarAction.POSTURE_STAND;
        }

        public var canStandUp(get,never):Bool;
public function  get_canStandUp():Bool
        {
            var _local_2:IRoomObjectModel = null;
            var k= this._Str_13836();
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    return _local_2.getNumber(RoomObjectVariableEnum.FIGURE_CAN_STAND_UP) > 0;
                }
            }
            return false;
        }

        public var isSwimming(get,never):Bool;
public function  get_isSwimming():Bool
        {
            var _local_2:IRoomObjectModel = null;
            var _local_3 = Math.NaN;
            var k= this._Str_13836();
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getNumber(RoomObjectVariableEnum.FIGURE_EFFECT);
                    return ((_local_3 == EFFECT_TYPE_DEEP_WATER) || (_local_3 == EFFECT_TYPE_SHALLOW_WATER)) || (_local_3 == EFFECT_TYPE_DEEP_WATER_DARK);
                }
            }
            return false;
        }

        function updateRentableBotView(k:Int, _arg_2:String, _arg_3:Int, _arg_4:RentableBotInfoData, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            if (_arg_4 == null)
            {
                return;
            }
            var _local_7= this._configuration.getBoolean("menu.bot.enabled");
            var _local_8= (_arg_5 && (!(this._view != null)));
            if (_arg_6)
            {
                _local_8 = false;
            }
            if (((_local_7 && (this._view != null)) && (!((((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)) || Std.is(this._view , PetMenuView)) || Std.is(this._view , OwnPetMenuView)) || Std.is(this._view , RentableBotMenuView)))))
            {
                this.removeView(this._view, false);
            }
            this.removeUseProductViews();
            if (((((((_arg_6 || (((!(this._view == null)) && (this._view.userId == k)) && (!_arg_5))) || (this._view == null)) || (!(this._view.userId == k))) || (!(this._view.userName == _arg_2))) || (!(this._view.roomIndex == _arg_3))) || (!(this._view.userType == RoomObjectTypeEnum.RENTABLE_BOT))))
            {
                if (this._view != null)
                {
                    this.removeView(this._view, false);
                }
                if (!this._isGameMode)
                {
                    if (this._cachedRentableBotMenuView == null)
                    {
                        this._cachedRentableBotMenuView = new RentableBotMenuView(this);
                    }
                    if (!_local_8)
                    {
                        this._view = this._cachedRentableBotMenuView;
                        RentableBotMenuView.setup(Std.downcast(this._view , RentableBotMenuView), k, _arg_2, _arg_3, RoomObjectTypeEnum.RENTABLE_BOT, _arg_4);
                    }
                }
            }
            else
            {
                if (Std.is(this._view , RentableBotMenuView))
                {
                    if (this._view.userName == _arg_2)
                    {
                        this.removeView(this._view, false);
                    }
                }
            }
        }

        function updatePetView(k:Int, _arg_2:String, _arg_3:Int, _arg_4:PetInfoData)
        {
            if (_arg_4 == null)
            {
                return;
            }
            if (((this._view != null) && (!((((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)) || Std.is(this._view , PetMenuView)) || Std.is(this._view , OwnPetMenuView)) || Std.is(this._view , RentableBotMenuView)))))
            {
                this.removeView(this._view, false);
            }
            this.removeUseProductViews();
            if ((((((this._view == null) || (!(this._view.userId == k))) || (!(this._view.userName == _arg_2))) || (!(this._view.roomIndex == _arg_3))) || (!(this._view.userType == RoomObjectTypeEnum.PET))))
            {
                if (this._view != null)
                {
                    this.removeView(this._view, false);
                }
                if (!this._isGameMode)
                {
                    if (_arg_4._Str_5175)
                    {
                        if (this._cachedOwnPetMenuView == null)
                        {
                            this._cachedOwnPetMenuView = new OwnPetMenuView(this, this._catalog);
                        }
                        this._view = this._cachedOwnPetMenuView;
                        OwnPetMenuView.setup(Std.downcast(this._view , OwnPetMenuView), k, _arg_2, _arg_3, RoomObjectTypeEnum.PET, _arg_4);
                    }
                    else
                    {
                        if (this._cachedPetMenuView == null)
                        {
                            this._cachedPetMenuView = new PetMenuView(this);
                        }
                        this._view = this._cachedPetMenuView;
                        PetMenuView.setup(Std.downcast(this._view , PetMenuView), k, _arg_2, _arg_3, RoomObjectTypeEnum.PET, _arg_4);
                    }
                }
            }
            else
            {
                if ((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)))
                {
                    if (this._view.userName == _arg_2)
                    {
                        this.removeView(this._view, false);
                    }
                }
            }
        }

        function updateUserView(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:AvatarInfoData)
        {
            var _local_8:UserNameView = null;
            var _local_7:ASAny = (!(_arg_6 == null));
            if (((ASCompat.toBool(_local_7) && (this._view != null)) && (!((((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)) || Std.is(this._view , PetMenuView)) || Std.is(this._view , OwnPetMenuView)) || Std.is(this._view , RentableBotMenuView)))))
            {
                this.removeView(this._view, false);
            }
            this.removeUseProductViews();
            if (((((((this._view == null) || (!(this._view.userId == k))) || (!(this._view.userName == _arg_2))) || (!(this._view.roomIndex == _arg_4))) || (!(this._view.userType == RoomObjectTypeEnum.HABBO))) || _arg_5))
            {
                if (this._view != null)
                {
                    this.removeView(this._view, false);
                }
                if (((!this._openingWiredClickMenu) && ASCompat.toBool(_local_7)) && this.shouldDelayWiredClickMenu(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6))
                {
                    return;
                }
                if (!this._isGameMode)
                {
                    if (_local_7)
                    {
                        if (_arg_6.isOwnUser)
                        {
                            if (this.isUserDecorating)
                            {
                                return;
                            }
                            if (RoomEnterEffect.isRunning())
                            {
                                if (this._cachedNewUserHelpView == null)
                                {
                                    this._cachedNewUserHelpView = new NewUserHelpView(this);
                                }
                                this._view = this._cachedNewUserHelpView;
                                NewUserHelpView.setup(Std.downcast(this._view , NewUserHelpView), k, _arg_2, _arg_4, RoomObjectTypeEnum.HABBO);
                            }
                            else
                            {
                                if (this._cachedOwnAvatarMenu == null)
                                {
                                    this._cachedOwnAvatarMenu = new OwnAvatarMenuView(this);
                                }
                                this._view = this._cachedOwnAvatarMenu;
                                OwnAvatarMenuView.setup(Std.downcast(this._view , OwnAvatarMenuView), k, _arg_2, _arg_4, RoomObjectTypeEnum.HABBO, _arg_6);
                            }
                        }
                        else
                        {
                            if (this._cachedAvatarMenuView == null)
                            {
                                this._cachedAvatarMenuView = new AvatarMenuView(this);
                            }
                            this._view = this._cachedAvatarMenuView;
                            AvatarMenuView.setup(Std.downcast(this._view , AvatarMenuView), k, _arg_2, _arg_4, _arg_3, _arg_6);
                            final _iter_ = this._avatarNameBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                            {
_local_8  = _tmp_;
                                if (_local_8.userId == k)
                                {
                                    this.removeView(_local_8, false);
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (!this.handler.roomEngine.getIsSelectedObjectInValidPosition)
                        {
                            if (this._cachedNameView == null)
                            {
                                this._cachedNameView = new AvatarContextInfoButtonView(this);
                            }
                            this._view = this._cachedNameView;
                            if (this.handler.container.sessionDataManager.userId == k)
                            {
                                AvatarContextInfoButtonView.setup(this._view, k, _arg_2, _arg_4, _arg_3, _arg_5);
                                if (this._isRoomEnteredOwnAvatarHighlight)
                                {
                                    this._catalog.windowManager.registerHintWindow(AVATAR, this._view.window);
                                    this._catalog.windowManager.showHint(AVATAR);
                                    if (!this.handler.container.sessionDataManager.isNoob)
                                    {
                                        this.setAvatarHightlightTimer();
                                    }
                                }
                            }
                            else
                            {
                                AvatarContextInfoButtonView.setup(this._view, k, _arg_2, _arg_4, _arg_3, _arg_5, true);
                            }
                        }
                    }
                }
            }
            else
            {
                if ((Std.is(this._view , AvatarMenuView) || Std.is(this._view , OwnAvatarMenuView)))
                {
                    if (this._view.userName == _arg_2)
                    {
                        this.removeView(this._view, false);
                    }
                }
            }
        }

        function shouldDelayWiredClickMenu(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Bool, _arg_6:AvatarInfoData):Bool
        {
            if (((this.handler == null) || (this.handler.container == null)) || (this.handler.container.userDefinedRoomEvents == null))
            {
                return false;
            }
            if (!this.handler.container.userDefinedRoomEvents.hasClickUserWired())
            {
                return false;
            }
            this._pendingWiredClickUserId = k;
            this._pendingWiredClickUserName = _arg_2;
            this._pendingWiredClickUserType = _arg_3;
            this._pendingWiredClickRoomIndex = _arg_4;
            this._pendingWiredClickAllowNameChange = _arg_5;
            this._pendingWiredClickAvatarInfoData = _arg_6;
            return true;
        }

        function onUserClickHandledEvent(k:WiredUserClickHandledEvent)
        {
            if (k.index != this._pendingWiredClickRoomIndex)
            {
                return;
            }
            if (k.openMenu)
            {
                this._openingWiredClickMenu = true;
                this.updateUserView(this._pendingWiredClickUserId, this._pendingWiredClickUserName, this._pendingWiredClickUserType, this._pendingWiredClickRoomIndex, this._pendingWiredClickAllowNameChange, this._pendingWiredClickAvatarInfoData);
                this._openingWiredClickMenu = false;
                this.checkUpdateNeed();
            }
            this.clearPendingWiredClick();
        }

        function clearPendingWiredClick()
        {
            this._pendingWiredClickUserId = -1;
            this._pendingWiredClickUserName = null;
            this._pendingWiredClickUserType = 0;
            this._pendingWiredClickRoomIndex = -1;
            this._pendingWiredClickAllowNameChange = false;
            this._pendingWiredClickAvatarInfoData = null;
        }

        public function removeView(k:ContextInfoView, _arg_2:Bool)
        {
            this._isRoomEnteredOwnAvatarHighlight = false;
            this.removeAvatarHighlightTimer();
            if (k != null)
            {
                if (this._recycleViews)
                {
                    k.hide(_arg_2);
                }
                else
                {
                    k.dispose();
                    this._cachedNameView = null;
                    this._cachedAvatarMenuView = null;
                    this._cachedOwnAvatarMenu = null;
                    this._cachedOwnPetMenuView = null;
                    this._cachedRentableBotMenuView = null;
                    this._cachedPetMenuView = null;
                    this._cachedNewUserHelpView = null;
                }
                if ((k : ASAny) == (this._view : ASAny))
                {
                    this._view = null;
                }
                if (Std.is(k , UserNameView))
                {
                    this._avatarNameBubbles.remove(Std.downcast(k , UserNameView).userName);
                    k.dispose();
                    this.checkUpdateNeed();
                }
                if (Std.is(k , UseProductView))
                {
                    this._useProductBubbles.remove(Std.downcast(k , UseProductView).userId);
                    k.dispose();
                    this.checkUpdateNeed();
                }
                if (Std.is(k , BreedPetView))
                {
                    this._breedPetBubbles.remove(Std.downcast(k , BreedPetView).userId);
                    k.dispose();
                    this.checkUpdateNeed();
                }
            }
        }

        public function removeUseProductViews()
        {
            var k:UseProductView = null;
            final _iter_ = this._useProductBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._useProductBubbles.reset();
            this.checkUpdateNeed();
        }

        public function _Str_11447()
        {
            var k:BreedPetView = null;
            final _iter_ = this._breedPetBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._breedPetBubbles.reset();
            this.checkUpdateNeed();
        }

        public function _Str_21156(k:RoomUserData, _arg_2:Int)
        {
            var _local_3:UserNameView = null;
            if (this._avatarNameBubbles.getValue(k.name)== null)
            {
                _local_3 = new UserNameView(this);
                // The entity's own type, not an assumption. UserDataManager indexes by type, so a
                // bot looked up as a HABBO is never found: its bubble got no location and sat at the
                // room view's origin -- a name tag in the corner of the screen -- for its whole life.
                UserNameView.setup(_local_3, k.id, k.name, -1, k.type, _arg_2);
                this._avatarNameBubbles.setProperty(k.name, _local_3);
                this.checkUpdateNeed();
            }
        }

        public function showGamePlayerName(k:Int, _arg_2:String, _arg_3:UInt, _arg_4:Int)
        {
            var _local_5:UserNameView = null;
            if (this._avatarNameBubbles.getValue(_arg_2)== null)
            {
                _local_5 = new UserNameView(this, true);
                UserNameView.setup(_local_5, k, _arg_2, k, RoomObjectTypeEnum.HABBO, k, _arg_3, _arg_4);
                this._avatarNameBubbles.setProperty(_arg_2, _local_5);
                this.checkUpdateNeed();
            }
        }

        /** Clears context/name views belonging to the hotel room before a private game canvas takes over. */
        public function hideAllAvatarInfo()
        {
var views:Array<ASAny>  = null, view:UserNameView  = null;            if (this._view != null) this.removeView(this._view, false);
            if (this._avatarNameBubbles != null)
            {
views= this._avatarNameBubbles.getValues();
                if (checkNullIteratee(views)) for (_tmp_ in views) {view = _tmp_;
this.removeView(view, false);
};
            }
            this.checkUpdateNeed();
        }

        function showUseProductMenu(k:RoomUserData, _arg_2:_Str_3858)
        {
            var _local_3:UseProductView = null;
            if (this._useProductBubbles.getValue(Std.string(k.id))== null)
            {
                _local_3 = new UseProductView(this);
                UseProductView.setup(_local_3, k.id, k.name, -1, RoomObjectTypeEnum.PET, _arg_2);
                this._useProductBubbles.setProperty(Std.string(k.id), _local_3);
                this.checkUpdateNeed();
            }
        }

        function showBreedPetMenu(k:RoomUserData, _arg_2:_Str_3858)
        {
            var _local_3:BreedPetView = null;
            if (this._breedPetBubbles.getValue(Std.string(k.id))== null)
            {
                _local_3 = new BreedPetView(this);
                BreedPetView.setup(_local_3, k.id, k.name, -1, RoomObjectTypeEnum.PET, _arg_2, k.canBreed);
                this._breedPetBubbles.setProperty(Std.string(k.id), _local_3);
                this.checkUpdateNeed();
            }
        }

        function setAvatarHightlightTimer()
        {
            this._avatarHighlightTimer = new Timer(AVATAR_HIGHLIGHT_DURATION_MSEC);
            this._avatarHighlightTimer.addEventListener(TimerEvent.TIMER, (this.onAvatarHighlightTimerEvent : ASAny));
            this._avatarHighlightTimer.start();
        }

        function removeAvatarHighlightTimer()
        {
            this._isRoomEnteredOwnAvatarHighlight = false;
            this._catalog.windowManager.unregisterHintWindow(AVATAR);
            if (this._avatarHighlightTimer == null)
            {
                return;
            }
            this._avatarHighlightTimer.stop();
            this._avatarHighlightTimer = null;
        }

        function onAvatarHighlightTimerEvent(k:TimerEvent)
        {
            this.removeAvatarHighlightTimer();
        }

        public function checkUpdateNeed()
        {
            if (this._component == null)
            {
                return;
            }
            if ((((((this._view != null) || (this._avatarNameBubbles.length > 0)) || (this._useProductBubbles.length > 0)) || (this._breedPetBubbles.length > 0)) || ((this._decoModeView != null) && (this._decoModeView.isVisible != null))))
            {
                this._component.registerUpdateReceiver(this, 10);
            }
            else
            {
                this._component.removeUpdateReceiver(this);
            }
        }

        public function update(k:UInt)
        {
            var _local_2:_Str_3174 = null;
            var _local_3:UserNameView = null;
            var _local_4:UseProductView = null;
            var _local_5:BreedPetView = null;
            if (this._view != null)
            {
                _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, this._view.userId, this._view.userType)) , _Str_3174);
                if (_local_2 == null)
                {
                    return;
                }
                this._view.update(_local_2.rectangle, _local_2._Str_9337, k);
            }
            if (((this._decoModeView != null) && this._decoModeView.isVisible()))
            {
                _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, this._decoModeView.userId, this._decoModeView.userType)) , _Str_3174);
                if (_local_2 == null)
                {
                    return;
                }
                this._decoModeView.update(_local_2.rectangle, _local_2._Str_9337, k);
            }
            final _iter_ = this._avatarNameBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_3  = _tmp_;
                if (_local_3._Str_23492)
                {
                    _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_GAME_OBJECT_LOCATION, _local_3.userId, _local_3.userType)) , _Str_3174);
                }
                else
                {
                    _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, _local_3.userId, _local_3.userType)) , _Str_3174);
                }
                if (_local_2 != null)
                {
                    _local_3.update(_local_2.rectangle, _local_2._Str_9337, k);
                }
            }
            final _iter_ = this._useProductBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_4  = _tmp_;
                _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, _local_4.userId, _local_4.userType)) , _Str_3174);
                if (_local_2 != null)
                {
                    _local_4.update(_local_2.rectangle, _local_2._Str_9337, k);
                }
            }
            final _iter_ = this._breedPetBubbles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_5  = _tmp_;
                _local_2 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, _local_5.userId, _local_5.userType)) , _Str_3174);
                if (_local_2 != null)
                {
                    _local_5.update(_local_2.rectangle, _local_2._Str_9337, k);
                }
            }
        }

        public function _Str_25121()
        {
            this.handler.container.avatarEditor.openEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR, null, null, true);
            this.handler.container.avatarEditor.loadOwnAvatarInEditor(AvatarEditorInstanceId.OWN_AVATAR_EDITOR);
        }

        public var _Str_6454(get,never):Bool;
public function  get__Str_6454():Bool
        {
            return this.handler.container.sessionDataManager.clubLevel >= HabboClubLevelEnum.CLUB;
        }

        public var hasVip(get,never):Bool;
public function  get_hasVip():Bool
        {
            return this.handler.container.sessionDataManager.clubLevel >= HabboClubLevelEnum.VIP;
        }

        public var hasEffectOn(get,never):Bool;
public function  get_hasEffectOn():Bool
        {
            var _local_2:IWidgetAvatarEffect = null;
            var k= this.handler.container.inventory.getActivatedAvatarEffects();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (_local_2.isInUse)
                {
                    return true;
                }
            }
            return false;
        }

        
        public var isDancing(get,set):Bool;
public function  get_isDancing():Bool
        {
            return this._isDancing;
        }
public function  set_isDancing(k:Bool):Bool        {
            return this._isDancing = k;
        }

        public var _Str_3859(get,never):Bool;
public function  get__Str_3859():Bool
        {
            if (this._petInfoData != null)
            {
                return this._petInfoData.saddle;
            }
            return false;
        }

        public var isRiding(get,never):Bool;
public function  get_isRiding():Bool
        {
            if (this._petInfoData != null)
            {
                return this._petInfoData.rider;
            }
            return false;
        }

        public var _Str_25831(get,never):Bool;
public function  get__Str_25831():Bool
        {
            var _local_2:IRoomObjectModel = null;
            var _local_3 = Math.NaN;
            var k= this._Str_13836();
            if (k != null)
            {
                _local_2 = k.getModel();
                if (_local_2 != null)
                {
                    _local_3 = _local_2.getNumber(RoomObjectVariableEnum.FIGURE_EFFECT);
                    if (_local_3 == EFFECT_TYPE_RIDE)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function _Str_23877()
        {
            this.handler.container.events.dispatchEvent(new RoomWidgetUpdateEvent(RoomWidgetPetCommandsUpdateEvent.OPEN_PET_TRAINING));
        }

        public function _Str_25401()
        {
            this.handler.container.events.dispatchEvent(new RoomWidgetUpdateEvent(RoomWidgetPetCommandsUpdateEvent.CLOSE_PET_TRAINING));
        }

        
        public var useMinimizedOwnAvatarMenu(get,set):Bool;
public function  get_useMinimizedOwnAvatarMenu():Bool
        {
            return this.handler.container.config.getBoolean(MINIMIZED_MENU_KEY);
        }
public function  set_useMinimizedOwnAvatarMenu(k:Bool):Bool        {
            this.handler.container.config.setProperty(MINIMIZED_MENU_KEY, (k ? "1" : "0"));
return k;
        }

        public function sendSignRequest(k:Int)
        {
            this.handler.container.roomSession.sendSignMessage(k);
        }

        public function showUseProductConfirmation(k:Int, _arg_2:Int, _arg_3:Int)
        {
            if (this._useProductConfirmationView == null)
            {
                this._useProductConfirmationView = new UseProductConfirmationView(this);
            }
            this._useProductConfirmationView.open(k, _arg_2, _arg_3);
        }

        function removeUseProductConfirmationView()
        {
            if (this._useProductConfirmationView != null)
            {
                this._useProductConfirmationView.dispose();
                this._useProductConfirmationView = null;
            }
        }

        public function showBreedingPetsWaitingConfirmationAlert(k:Int, _arg_2:Int)
        {
            this.removeBreedingPetsWaitingConfirmationAlert();
            this._breedingConfirmationAlert = windowManager.confirm("${breedpets.confirmation.notification.title}", "${breedpets.confirmation.notification.text}", 0, this.onWaitingConfirmationAlert);
            this._breedingConfirmationAlertRequestRoomObjectId = k;
            this._breedingConfirmationAlertTargetRoomObjectId = _arg_2;
        }

        public function onWaitingConfirmationAlert(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
            }
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_CANCEL)
            {
                if (((!(this._breedingConfirmationAlertTargetRoomObjectId == -1)) && (!(this._breedingConfirmationAlertTargetRoomObjectId == -1))))
                {
                    this._Str_19339(this._breedingConfirmationAlertRequestRoomObjectId, this._breedingConfirmationAlertTargetRoomObjectId);
                }
            }
            this.removeBreedingPetsWaitingConfirmationAlert();
        }

        function removeBreedingPetsWaitingConfirmationAlert()
        {
            if (this._breedingConfirmationAlert != null)
            {
                this._breedingConfirmationAlert.dispose();
                this._breedingConfirmationAlert = null;
                this._breedingConfirmationAlertRequestRoomObjectId = -1;
                this._breedingConfirmationAlertTargetRoomObjectId = -1;
            }
        }

        public function acceptBreedingPets(k:Int, _arg_2:Int)
        {
            if (this._breedMonsterPlantsConfirmationView != null)
            {
                if (((this._breedMonsterPlantsConfirmationView._Str_3710 == k) && (this._breedMonsterPlantsConfirmationView._Str_5563 == _arg_2)))
                {
                    this._Str_8286();
                }
            }
            if (this._breedingConfirmationAlert != null)
            {
                this._breedingConfirmationAlert.dispose();
            }
        }

        public function cancelBreedingPets(k:Int, _arg_2:Int)
        {
            if (this._breedMonsterPlantsConfirmationView != null)
            {
                if (((this._breedMonsterPlantsConfirmationView._Str_3710 == k) && (this._breedMonsterPlantsConfirmationView._Str_5563 == _arg_2)))
                {
                    this._Str_8286();
                }
            }
            this.removeBreedingPetsWaitingConfirmationAlert();
            windowManager.alert("${breedpets.cancel.notification.title}", "${breedpets.cancel.notification.text}", 0, this._Str_25650);
        }

        public function _Str_25650(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (((_arg_2.type == WindowEvent.WINDOW_EVENT_OK) || (_arg_2.type == WindowEvent.WINDOW_EVENT_CANCEL)))
            {
                k.dispose();
            }
        }

        public function _Str_16495(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            if (this._breedMonsterPlantsConfirmationView == null)
            {
                this._breedMonsterPlantsConfirmationView = new BreedMonsterPlantsConfirmationView(this);
            }
            this._breedMonsterPlantsConfirmationView.open(k, _arg_2, _arg_3);
        }

        public function _Str_22316(k:ConfirmPetBreedingPetData, _arg_2:ConfirmPetBreedingPetData, _arg_3:Int, _arg_4:Array<ASAny>, _arg_5:Int)
        {
            if (this._confirmPetBreedingView == null)
            {
                this._confirmPetBreedingView = new ConfirmPetBreedingView(this);
            }
            var _local_6= this._Str_12418(k.webId);
            var _local_7= this._Str_12418(_arg_2.webId);
            this._confirmPetBreedingView.open(_local_6, _local_7, _arg_3, _arg_4, _arg_5, k.level, _arg_2.level);
        }

        function _Str_8286()
        {
            if (this._breedMonsterPlantsConfirmationView != null)
            {
                this._breedMonsterPlantsConfirmationView.dispose();
                this._breedMonsterPlantsConfirmationView = null;
            }
        }

        function _Str_10453()
        {
            if (this._confirmPetBreedingView != null)
            {
                this._confirmPetBreedingView.dispose();
                this._confirmPetBreedingView = null;
            }
        }

        public function _Str_23663(k:BreedPetsResultData, _arg_2:BreedPetsResultData)
        {
            if (this._breedPetsResultView == null)
            {
                this._breedPetsResultView = new BreedPetsResultView(this);
            }
            this._breedPetsResultView.open(k, _arg_2);
        }

        public function _Str_24769(k:BreedPetsResultView)
        {
            if (k != null)
            {
                if (k == this._breedPetsResultView)
                {
                    this._breedPetsResultView.dispose();
                    this._breedPetsResultView = null;
                }
                else
                {
                    k.dispose();
                }
            }
        }

        function _Str_13836():IRoomObject
        {
            var _local_6:IRoomObject = null;
            var _local_7:RoomUserData = null;
            var k= this.handler.container.sessionDataManager.userId;
            var _local_2= this.handler.roomEngine.activeRoomId;
            var _local_3= RoomObjectCategoryEnum.OBJECT_CATEGORY_USER;
            var _local_4= this.handler.roomEngine.getRoomObjectCount(_local_2, _local_3);
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_6 = this.handler.roomEngine.getRoomObjectWithIndex(_local_2, _local_5, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                if (_local_6 != null)
                {
                    _local_7 = this.handler.roomSession.userDataManager.getUserDataByIndex(_local_6.getId());
                    if (_local_7 != null)
                    {
                        if (_local_7.id == k)
                        {
                            return _local_6;
                        }
                    }
                }
                _local_5++;
            }
            return null;
        }

        
        @:allow(com.sulake.habbo.ui.widget.avatarinfo) @:allow(com.sulake.habbo.ui.widget.avatarinfo) var isUserDecorating(get,set):Bool;
function  get_isUserDecorating():Bool
        {
            return this.handler.roomSession.isUserDecorating;
        }
function  set_isUserDecorating(k:Bool):Bool        {
            var _local_2 = 0;
            var _local_3:_Str_3174 = null;
            var _local_4:String = null;
            var _local_5 = 0;
            this.handler.roomSession.isUserDecorating = k;
            if (k)
            {
                _local_2 = this.handler.container.sessionDataManager.userId;
                if (this._decoModeView == null)
                {
                    _local_4 = this.handler.container.sessionDataManager.userName;
                    _local_5 = this.handler.container.roomSession.ownUserRoomId;
                    this._decoModeView = new DecorateModeView(this, _local_2, _local_4, _local_5);
                }
                this._decoModeView.show();
                _local_3 = Std.downcast(messageListener.processWidgetMessage(new RoomWidgetGetObjectLocationMessage(RoomWidgetGetObjectLocationMessage.RWGOI_MESSAGE_GET_OBJECT_LOCATION, _local_2, RoomObjectTypeEnum.HABBO)) , _Str_3174);
                if (_local_3 != null)
                {
                    this._decoModeView.update(_local_3.rectangle, _local_3._Str_9337, 0);
                }
            }
            else
            {
                if (this._decoModeView != null)
                {
                    this._decoModeView.hide(false);
                }
            }
return k;
        }

        public var catalog(get,never):IHabboCatalog;
public function  get_catalog():IHabboCatalog
        {
            return this._catalog;
        }

        public function _Str_20290():Bool
        {
            if (this._petInfoData != null)
            {
                return this._petInfoData._Str_4355 == PetTypeEnum.MONSTERPLANT;
            }
            return false;
        }

        public function _Str_19339(k:Int, _arg_2:Int)
        {
            var _local_3= this.handler.container.roomSession.userDataManager.getUserDataByIndex(k);
            var _local_4= this.handler.container.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            if (((_local_3 != null) && (_local_4 != null)))
            {
                this.handler.container.connection.send(new BreedPetsMessageComposer(BreedPetsMessageComposer._Str_8664, _local_3.id, _local_4.id));
            }
        }

        public function _Str_24933(k:Int, _arg_2:Int)
        {
            var _local_3= this.handler.container.roomSession.userDataManager.getUserDataByIndex(k);
            var _local_4= this.handler.container.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            if (((_local_3 != null) && (_local_4 != null)))
            {
                this.handler.container.connection.send(new BreedPetsMessageComposer(BreedPetsMessageComposer._Str_9186, _local_3.id, _local_4.id));
            }
        }

        public function _Str_22619(k:Int, _arg_2:Int)
        {
            var _local_3= this.handler.container.roomSession.userDataManager.getUserDataByIndex(k);
            var _local_4= this.handler.container.roomSession.userDataManager.getUserDataByIndex(_arg_2);
            if (((_local_3 != null) && (_local_4 != null)))
            {
                this.handler.container.connection.send(new BreedPetsMessageComposer(BreedPetsMessageComposer._Str_17533, _local_3.id, _local_4.id));
            }
        }

        public function _Str_21992(k:Int, _arg_2:Int, _arg_3:Point=null)
        {
            if (!this._botSkillConfigurationViews.hasKey(_arg_2))
            {
                switch (_arg_2)
                {
                    case BotSkillsEnum.SETUP_CHAT:
                        this._botSkillConfigurationViews.add(BotSkillsEnum.SETUP_CHAT, new BotChatterMarkovConfiguration(this));
                        
                    case BotSkillsEnum.CHANGE_BOT_NAME:
                        this._botSkillConfigurationViews.add(BotSkillsEnum.CHANGE_BOT_NAME, new BotChangeNameConfiguration(this));
                        
					case BotSkillsEnum.CHANGE_BOT_MOTTO:
                        this._botSkillConfigurationViews.add(BotSkillsEnum.CHANGE_BOT_MOTTO, new BotChangeMottoConfiguration(this));
                        return;
                    default:
                        return;
                }
            }
            var _local_4:BotSkillConfigurationView = this._botSkillConfigurationViews.getValue(_arg_2);
            _local_4.open(k, _arg_3);
        }

        public function _Str_24617(k:Int)
        {
            this.handler.container.connection.send(new CancelPetBreedingComposer(k));
        }

        public function _Str_23246(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int)
        {
            this.handler.container.connection.send(new ConfirmPetBreedingComposer(k, _arg_2, _arg_3, _arg_4));
        }

        public function _Str_24481(k:Int, _arg_2:Int)
        {
            if (this._nestBreedingSuccessView == null)
            {
                this._nestBreedingSuccessView = new NestBreedingSuccessView(this);
            }
            var _local_3= this._Str_12418(k);
            this._nestBreedingSuccessView.open(_local_3, _arg_2);
        }

        public var friendList(get,never):IHabboFriendsList;
public function  get_friendList():IHabboFriendsList
        {
            return this.handler.friendList;
        }
    }

