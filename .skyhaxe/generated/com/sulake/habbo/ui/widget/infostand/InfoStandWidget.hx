package com.sulake.habbo.ui.widget.infostand
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.events.TimerEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.ui.handler.InfoStandWidgetHandler;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetFurniInfostandUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRentableBotInfoUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUserTagsUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetInfostandUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetCommandsUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetSongUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetPetFigureUpdateEvent;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectPlaceEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnumItemExtradataParameter;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceRoomItemMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.catalog.BuildersClubPlaceWallItemMessageComposer;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;

     class InfoStandWidget extends RoomWidgetBase
    {
        static inline final USER_VIEW= "infostand_user_view";
        static inline final FURNI_VIEW= "infostand_furni_view";
        static inline final PET_VIEW= "infostand_pet_view";
        static inline final BOT_VIEW= "infostand_bot_view";
        static inline final RENTABLE_BOT_VIEW= "infostand_rentable_bot_view";
        static inline final JUKEBOX_VIEW= "infostand_jukebox_view";
        static inline final CRACKABLE_FURNI_VIEW= "infostand_crackable_furni_view";
        static inline final SONGDISK_VIEW= "infostand_songdisk_view";
        static inline final UPDATE_VIEW_INTERVAL= 3000;

        var _furniView:InfoStandFurniView;
        var _userView:InfoStandUserView;
        var _petView:InfoStandPetView;
        var _botView:InfoStandBotView;
        var _rentableBotView:InfoStandRentableBotView;
        var _jukeboxView:InfoStandJukeboxView;
        var _crackableFurniView:InfoStandCrackableFurniView;
        var _songDiskView:InfoStandSongDiskView;
        var _ownTags:Array<ASAny>;
        var _userData:InfoStandUserData;
        var _furniData:InfoStandFurniData;
        var _petData:InfoStandPetData;
        var _rentableBotdata:InfoStandRentableBotData;
        var _mainContainer:IWindowContainer;
        var _updateTimer:Timer;
        var _config:IHabboConfigurationManager;
        var _placeMoreActive:Bool = false;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager, _arg_6:IHabboCatalog)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._config = _arg_5;
            this._furniView = new InfoStandFurniView(this, FURNI_VIEW, _arg_6);
            this._userView = new InfoStandUserView(this, USER_VIEW);
            this._petView = new InfoStandPetView(this, PET_VIEW, _arg_6);
            this._botView = new InfoStandBotView(this, BOT_VIEW);
            this._rentableBotView = new InfoStandRentableBotView(this, RENTABLE_BOT_VIEW, _arg_6);
            this._jukeboxView = new InfoStandJukeboxView(this, JUKEBOX_VIEW, _arg_6);
            this._crackableFurniView = new InfoStandCrackableFurniView(this, CRACKABLE_FURNI_VIEW, _arg_6);
            this._songDiskView = new InfoStandSongDiskView(this, SONGDISK_VIEW, _arg_6);
            this._userData = new InfoStandUserData();
            this._furniData = new InfoStandFurniData();
            this._petData = new InfoStandPetData();
            this._rentableBotdata = new InfoStandRentableBotData();
            this._updateTimer = new Timer(UPDATE_VIEW_INTERVAL);
            this._updateTimer.addEventListener(TimerEvent.TIMER, (this.refreshPetInfoStand : ASAny));
            this.mainContainer.visible = false;
            this.handler.widget = this;
        }

        public var handler(get,never):InfoStandWidgetHandler;
public function  get_handler():InfoStandWidgetHandler
        {
            return Std.downcast(_handler , InfoStandWidgetHandler);
        }

        public var _Str_21463(get,never):InfoStandFurniView;
public function  get__Str_21463():InfoStandFurniView
        {
            return this._furniView;
        }

        override public function  get_mainWindow():IWindow
        {
            return this.mainContainer;
        }

        public var config(get,never):IHabboConfigurationManager;
public function  get_config():IHabboConfigurationManager
        {
            return this._config;
        }

        public var mainContainer(get,never):IWindowContainer;
public function  get_mainContainer():IWindowContainer
        {
            if (this._mainContainer == null)
            {
                this._mainContainer = Std.downcast(windowManager.createWindow("infostand_main_container", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.NULL, WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 50, 100)) , IWindowContainer);
                this._mainContainer.tags.push("room_widget_infostand");
                this._mainContainer.background = true;
                this._mainContainer.color = 0;
            }
            return this._mainContainer;
        }

        public function _Str_22447(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:String)
        {
            var _local_6:String = null;
            if (((!(this.userData != null)) || (!(this.userData.userRoomId == k))))
            {
                return;
            }
            if (this.mainContainer == null)
            {
                return;
            }
            var _local_5= this.mainContainer.findChildByName(USER_VIEW);
            if (((!(_local_5 != null)) || (!_local_5.visible)))
            {
                return;
            }
            this._userView._Str_21116();
            if (_arg_2 != -1)
            {
                _local_6 = this.handler.container.sessionDataManager.getGroupBadgeId(_arg_2);
                this.userData.groupId = _arg_2;
                this.userData.groupBadgeId = _local_6;
                this.userData.groupName = _arg_4;
                this._userView._Str_16673(_local_6);
            }
        }

        public function getXmlWindow(name:String):IWindow
        {
            var asset:IAsset = null;
            var xmlAsset:XmlAsset = null;
            var window:IWindow = null;
            try
            {
                asset = assets.getAssetByName(name);
                xmlAsset = cast(asset, XmlAsset);
                window = windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(xmlAsset.content));
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                Logger.log([("[InfoStandWidget] Missing window XML: " + name)]);
            }
 }            return window;
        }

        public function setRelationshipStatus(k:Int, _arg_2:Map)
        {
            if (this._userData.userId == k)
            {
                this._userView._Str_25662(_arg_2);
            }
        }

        override public function dispose()
        {
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
            this._updateTimer = null;
            if (this._userView != null)
            {
                this._userView.dispose();
            }
            this._userView = null;
            if (this._furniView != null)
            {
                this._furniView.dispose();
            }
            this._furniView = null;
            if (this._botView != null)
            {
                this._botView.dispose();
            }
            this._botView = null;
            if (this._rentableBotView != null)
            {
                this._rentableBotView.dispose();
            }
            this._rentableBotView = null;
            if (this._petView != null)
            {
                this._petView.dispose();
            }
            this._petView = null;
            if (this._jukeboxView != null)
            {
                this._jukeboxView.dispose();
            }
            this._jukeboxView = null;
            if (this._crackableFurniView != null)
            {
                this._crackableFurniView.dispose();
            }
            this._crackableFurniView = null;
            if (this._songDiskView != null)
            {
                this._songDiskView.dispose();
            }
            this._songDiskView = null;
            super.dispose();
        }

        override public function registerUpdateEvents(eventDispatcher:IEventDispatcher)
        {
            if (eventDispatcher == null)
            {
                return;
            }
            eventDispatcher.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED, this.objectSelectedHandler);
            eventDispatcher.addEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this.objectDeselectedHandler);
            eventDispatcher.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.objectRemovedHandler);
            eventDispatcher.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.objectRemovedHandler);
            eventDispatcher.addEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.userInstandUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.userInstandUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetUserInfoUpdateEvent.BOT, this.botInfostandUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetFurniInfostandUpdateEvent.FURNI, this.furniUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetRentableBotInfoUpdateEvent.RENTABLE_BOT, this.rentableBotInfostandUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetUserTagsUpdateEvent.USER_TAGS, this.userTagsUpdatedHandler);
            eventDispatcher.addEventListener(RoomWidgetPetInfostandUpdateEvent.PET_INFO, this.petInfostandUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetPetCommandsUpdateEvent.PET_COMMANDS, this.petCommandsUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetPetCommandsUpdateEvent.OPEN_PET_TRAINING, this.openPetTraningHandler);
            eventDispatcher.addEventListener(RoomWidgetPetCommandsUpdateEvent.CLOSE_PET_TRAINING, this.closePetTrainingHandler);
            eventDispatcher.addEventListener(RoomWidgetSongUpdateEvent.PLAYING_CHANGED, this.songUpdatedHandler);
            eventDispatcher.addEventListener(RoomWidgetSongUpdateEvent.DATA_RECEIVED, this.songUpdatedHandler);
            eventDispatcher.addEventListener(RoomWidgetPetFigureUpdateEvent.PET_FIGURE_UPDATE, this.petFigureUpdateHandler);
            eventDispatcher.addEventListener(RoomWidgetRoomObjectPlaceEvent.OBJECT_PLACED, this.onRoomObjectPlaced);
            super.registerUpdateEvents(eventDispatcher);
        }

        override public function unregisterUpdateEvents(eventDispatcher:IEventDispatcher)
        {
            if (eventDispatcher == null)
            {
                return;
            }
            eventDispatcher.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_SELECTED, this.objectSelectedHandler);
            eventDispatcher.removeEventListener(RoomWidgetRoomObjectUpdateEvent.OBJECT_DESELECTED, this.objectDeselectedHandler);
            eventDispatcher.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.objectRemovedHandler);
            eventDispatcher.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.objectRemovedHandler);
            eventDispatcher.removeEventListener(RoomWidgetUserInfoUpdateEvent.OWN_USER, this.userInstandUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetUserInfoUpdateEvent.PEER, this.userInstandUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetUserInfoUpdateEvent.BOT, this.botInfostandUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetFurniInfostandUpdateEvent.FURNI, this.furniUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetRentableBotInfoUpdateEvent.RENTABLE_BOT, this.rentableBotInfostandUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetUserTagsUpdateEvent.USER_TAGS, this.userTagsUpdatedHandler);
            eventDispatcher.removeEventListener(RoomWidgetPetInfostandUpdateEvent.PET_INFO, this.petInfostandUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetPetCommandsUpdateEvent.PET_COMMANDS, this.petCommandsUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetPetCommandsUpdateEvent.OPEN_PET_TRAINING, this.openPetTraningHandler);
            eventDispatcher.removeEventListener(RoomWidgetPetCommandsUpdateEvent.CLOSE_PET_TRAINING, this.closePetTrainingHandler);
            eventDispatcher.removeEventListener(RoomWidgetSongUpdateEvent.PLAYING_CHANGED, this.songUpdatedHandler);
            eventDispatcher.removeEventListener(RoomWidgetSongUpdateEvent.DATA_RECEIVED, this.songUpdatedHandler);
            eventDispatcher.removeEventListener(RoomWidgetPetFigureUpdateEvent.PET_FIGURE_UPDATE, this.petFigureUpdateHandler);
            eventDispatcher.removeEventListener(RoomWidgetRoomObjectPlaceEvent.OBJECT_PLACED, this.onRoomObjectPlaced);
        }

        public var botData(get,never):InfoStandRentableBotData;
public function  get_botData():InfoStandRentableBotData
        {
            return this._rentableBotdata;
        }

        public var userData(get,never):InfoStandUserData;
public function  get_userData():InfoStandUserData
        {
            return this._userData;
        }

        public var furniData(get,never):InfoStandFurniData;
public function  get_furniData():InfoStandFurniData
        {
            return this._furniData;
        }

        public var petData(get,never):InfoStandPetData;
public function  get_petData():InfoStandPetData
        {
            return this._petData;
        }

        function refreshPetInfoStand(k:TimerEvent)
        {
            if (this._petView == null)
            {
                return;
            }
            messageListener.processWidgetMessage(new RoomWidgetUserActionMessage(RoomWidgetUserActionMessage.RWUAM_REQUEST_PET_UPDATE, this._petView._Str_23859()));
        }

        function userInstandUpdateHandler(updateEvent:RoomWidgetUserInfoUpdateEvent)
        {
            this.userData._Str_5479(updateEvent);
            this._userView.update(updateEvent);
            this._Str_3734(USER_VIEW);
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        function botInfostandUpdateHandler(updateEvent:RoomWidgetUserInfoUpdateEvent)
        {
            this.userData._Str_5479(updateEvent);
            this._botView.update(updateEvent);
            this._Str_3734(BOT_VIEW);
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        function rentableBotInfostandUpdateHandler(updateEvent:RoomWidgetRentableBotInfoUpdateEvent)
        {
            this.botData._Str_5479(updateEvent);
            this._rentableBotView.update(updateEvent);
            this._Str_3734(RENTABLE_BOT_VIEW);
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        function furniUpdateHandler(updateEvent:RoomWidgetFurniInfostandUpdateEvent)
        {
            if ((this._placeMoreActive && (this._furniData.id > 0)) && (!(updateEvent.id == this._furniData.id)))
            {
                this.stopPlaceMore();
            }
            this.furniData._Str_5479(updateEvent);
            if (updateEvent.extraParam == RoomWidgetEnumItemExtradataParameter.JUKEBOX)
            {
                this._jukeboxView.update(updateEvent);
                this._Str_3734(JUKEBOX_VIEW);
            }
            else
            {
                if (updateEvent.extraParam.indexOf(RoomWidgetEnumItemExtradataParameter.SONGDISK) != -1)
                {
                    this._songDiskView.update(updateEvent);
                    this._Str_3734(SONGDISK_VIEW);
                }
                else
                {
                    if (updateEvent.extraParam.indexOf(RoomWidgetEnumItemExtradataParameter.CRACKABLE_FURNI) != -1)
                    {
                        this._crackableFurniView.update(updateEvent);
                        this._Str_3734(CRACKABLE_FURNI_VIEW);
                    }
                    else
                    {
                        this._furniView.update(updateEvent);
                        this._Str_3734(FURNI_VIEW);
                    }
                }
            }
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        function petInfostandUpdateHandler(updateEvent:RoomWidgetPetInfostandUpdateEvent)
        {
            this.petData._Str_5479(updateEvent);
            this.userData.petRespectLeft = updateEvent.petRespectLeft;
            this._petView.update(this.petData);
            this._Str_3734(PET_VIEW);
            if (this._updateTimer != null)
            {
                this._updateTimer.start();
            }
        }

        function petFigureUpdateHandler(updateEvent:RoomWidgetPetFigureUpdateEvent)
        {
            this._petView._Str_4497(updateEvent.petId, updateEvent.image);
        }

        function petCommandsUpdateHandler(updateEvent:RoomWidgetPetCommandsUpdateEvent)
        {
            var _local_2= updateEvent.commands;
            var _local_3= updateEvent.enabledCommands;
            if (((((this.petData.type == PetTypeEnum.DOG) && (!this._config.getBoolean("nest.breeding.dog.enabled"))) || ((this.petData.type == PetTypeEnum.CAT) && (!this._config.getBoolean("nest.breeding.cat.enabled")))) || ((this.petData.type == PetTypeEnum.PIG) && (!this._config.getBoolean("nest.breeding.pig.enabled")))))
            {
                if (_local_2.indexOf(46) != -1)
                {
                    _local_2.splice(_local_2.indexOf(46), 1);
                }
                if (_local_3.indexOf(46) != -1)
                {
                    _local_3.splice(_local_3.indexOf(46), 1);
                }
            }
            this._petView._Str_24853(updateEvent.id, new CommandConfiguration(updateEvent.commands, updateEvent.enabledCommands));
        }

        function openPetTraningHandler(updateEvent:RoomWidgetUpdateEvent)
        {
            this._petView._Str_19969();
        }

        function closePetTrainingHandler(updateEvent:RoomWidgetUpdateEvent)
        {
            this._petView._Str_23384();
        }

        function userTagsUpdatedHandler(updateEvent:RoomWidgetUserTagsUpdateEvent)
        {
            if (updateEvent.isOwnUser)
            {
                this._ownTags = updateEvent.tags;
            }
            if (updateEvent.userId != this.userData.userId)
            {
                return;
            }
            if (updateEvent.isOwnUser)
            {
                this._userView._Str_17290(updateEvent.tags);
            }
            else
            {
                this._userView._Str_17290(updateEvent.tags, this._ownTags);
            }
        }

        public function _Str_17133(id:Int, _arg_2:String, _arg_3:Int, _arg_4:String, _arg_5:Bool)
        {
            if (id != this.userData.userId)
            {
                return;
            }
            if (this.userData._Str_18577())
            {
                this._botView._Str_7907(_arg_2);
            }
            else
            {
                this._userView._Str_7907(_arg_2);
                this._userView._Str_12782(_arg_4, _arg_5);
                if (this.handler.isActivityDisplayEnabled)
                {
                    this._userView.activityPoints = _arg_3;
                }
            }
        }

        public function _Str_22739(k:Int, _arg_2:Array<ASAny>)
        {
            var _local_3:String = null;
            if (k != this.userData.userId)
            {
                return;
            }
            this.userData.badges = _arg_2;
            if (this.userData._Str_18577())
            {
                this._botView._Str_10630();
            }
            else
            {
                this._userView._Str_10630();
            }
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                this._Str_21919(_local_3);
            }
        }

        public function _Str_21919(k:String)
        {
            var _local_2= this.userData.badges.indexOf(k);
            if (_local_2 >= 0)
            {
                if (this.userData._Str_18577())
                {
                    this._botView._Str_5605(_local_2, k);
                }
                else
                {
                    this._userView._Str_5605(_local_2, k);
                }
                return;
            }
            if (k == this.userData.groupBadgeId)
            {
                this._userView._Str_16673(k);
            }
        }

        function objectSelectedHandler(k:RoomWidgetRoomObjectUpdateEvent)
        {
            var _local_2= new RoomWidgetRoomObjectMessage(RoomWidgetRoomObjectMessage.RWROM_GET_OBJECT_INFO, k.id, k.category);
            messageListener.processWidgetMessage(_local_2);
        }

        function objectRemovedHandler(k:RoomWidgetRoomObjectUpdateEvent)
        {
            var _local_2 = false;
            switch (k.type)
            {
                case RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED:
                    _local_2 = (k.id == this._furniData.id);
                    
                case RoomWidgetRoomObjectUpdateEvent.USER_REMOVED:
                    if ((((!(this._userView == null)) && (!(this._userView.window == null))) && this._userView.window.visible))
                    {
                        _local_2 = (k.id == this._userData.userRoomId);
                    }
                    else if ((((!(this._petView == null)) && (!(this._petView.window == null))) && this._petView.window.visible))
                    {
                        _local_2 = (k.id == this._petData.roomIndex);
                    }
                    else if ((((!(this._botView == null)) && (!(this._botView.window == null))) && this._botView.window.visible))
                    {
                        _local_2 = (k.id == this._userData.userRoomId);
                    }
                    else if ((((!(this._rentableBotView == null)) && (!(this._rentableBotView.window == null))) && this._rentableBotView.window.visible))
                    {
                        _local_2 = (k.id == this._rentableBotdata.userRoomId);
                    }
            }
            if (_local_2)
            {
                this.close();
            }
        }

        function songUpdatedHandler(k:RoomWidgetSongUpdateEvent)
        {
            this._jukeboxView._Str_17571(k);
            this._songDiskView._Str_17571(k);
        }

        public function close()
        {
            if (this._userView != null)
            {
                this._userView.hidePreview();
            }
            this.stopPlaceMore();
            this.hideChildren();
            this.mainContainer.visible = false;
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        function objectDeselectedHandler(k:RoomWidgetRoomObjectUpdateEvent)
        {
            this.stopPlaceMore();
            this.close();
            if (this._updateTimer != null)
            {
                this._updateTimer.stop();
            }
        }

        public function requestItemToMover()
        {
            var _local_1:IRoomObject = null;
            var _local_2 = 0;
            if (((this.furniData == null) || (this.furniData.bcOfferId < 0)))
            {
                this.stopPlaceMore();
                return;
            }
            if (!this.handler.container.catalog.canPlaceWithBC())
            {
                this.stopPlaceMore();
                return;
            }
            if (this.handler.container.roomSession == null)
            {
                this.stopPlaceMore();
                return;
            }
            _local_1 = this.handler.container.roomEngine.getRoomObject(this.handler.container.roomSession.roomId, this.furniData.id, this.furniData.category);
            if (_local_1 == null)
            {
                this.stopPlaceMore();
                return;
            }
            _local_2 = Std.int(_local_1.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
            this._placeMoreActive = this.handler.container.roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INFO_STAND, -this.furniData.bcOfferId, this.furniData.category, _local_2, this.furniData.extraParam, null, -1, -1, null);
        }

        function onRoomObjectPlaced(k:RoomWidgetRoomObjectPlaceEvent)
        {
            if (!(k.placementSource == RoomObjectPlacementSource.INFO_STAND))
            {
                return;
            }
            if (!k.placedInRoom)
            {
                this.stopPlaceMore();
                return;
            }
            if (((this.furniData == null) || (this.furniData.bcOfferId < 0)))
            {
                this.stopPlaceMore();
                return;
            }
            if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE)
            {
                this.handler.container.connection.send(new BuildersClubPlaceRoomItemMessageComposer(-1, this.furniData.bcOfferId, this.furniData.extraParam, Std.int(k.x), Std.int(k.y), k.direction));
            }
            else
            {
                if (k.category == RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM)
                {
                    this.handler.container.connection.send(new BuildersClubPlaceWallItemMessageComposer(-1, this.furniData.bcOfferId, this.furniData.extraParam, k.wallLocation));
                }
                else
                {
                    this.stopPlaceMore();
                    return;
                }
            }
            this.requestItemToMover();
        }

        function stopPlaceMore()
        {
            if (this._placeMoreActive)
            {
                this.handler.container.roomEngine.cancelRoomObjectInsert();
            }
            this._placeMoreActive = false;
        }

        function hideChildren()
        {
            var k = 0;
            if (this._mainContainer != null)
            {
                k = 0;
                while (k < this._mainContainer.numChildren)
                {
                    this._mainContainer.getChildAt(k).visible = false;
                    k++;
                }
            }
        }

        public function _Str_25620():Bool
        {
            var k:IWindow = null;
            if (this._mainContainer != null)
            {
                k = this._mainContainer.getChildByName(FURNI_VIEW) ;
                if (k != null)
                {
                    return k.visible;
                }
            }
            return false;
        }

        function _Str_3734(view:String)
        {
            // Tear down the live avatar previewer whenever we switch away from the user view, so it
            // never stays listening to the room engine while another view (or no infostand) is shown.
            if (((!(view == USER_VIEW)) && (!(this._userView == null))))
            {
                this._userView.hidePreview();
            }
            this.hideChildren();
            var _local_2= this.mainContainer.getChildByName(view) ;
            if (_local_2 == null)
            {
                return;
            }
            _local_2.visible = true;
            this.mainContainer.visible = true;
            this.mainContainer.width = _local_2.width;
            this.mainContainer.height = _local_2.height;
        }

        public function _Str_10301()
        {
            var k:IWindow = null;
            var _local_2 = 0;
            while (_local_2 < this.mainContainer.numChildren)
            {
                k = this.mainContainer.getChildAt(_local_2);
                if (k.visible)
                {
                    this.mainContainer.width = k.width;
                    this.mainContainer.height = k.height;
                }
                _local_2++;
            }
        }
    }
