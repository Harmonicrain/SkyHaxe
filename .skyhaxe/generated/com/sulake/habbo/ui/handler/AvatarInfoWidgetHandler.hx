package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.avatarinfo.AvatarInfoWidget;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.friendlist.IHabboFriendsList;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.session.events.UserNameUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionPetStatusUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionPetLevelUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionNestBreedingSuccessEvent;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListAddOrUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.CustomUserNotificationMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetInventoryUpdatedMessage;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.ui.widget.events._Str_4828;
    import com.sulake.habbo.ui.widget.events._Str_4818;
    import com.sulake.habbo.ui.widget.events._Str_5393;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRoomObjectMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUserActionMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUseProductMessage;
    import com.sulake.habbo.session.events.RoomSessionUserDataUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionDanceEvent;
    import com.sulake.habbo.room.events.RoomEngineUseProductEvent;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_7783;
    import flash.events.Event;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.inventory._enum.FurniCategory;
    import com.sulake.habbo.ui.widget.events._Str_3858;

     class AvatarInfoWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:AvatarInfoWidget;
        var _furniListInsertListener:IMessageEvent;
        var _respectNotificationListener:IMessageEvent;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var widget(never,set):AvatarInfoWidget;
public function  set_widget(k:AvatarInfoWidget):AvatarInfoWidget        {
            return this._widget = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (((this._respectNotificationListener != null) && (this._container.connection != null)))
                {
                    this._container.connection.removeMessageEvent(this._respectNotificationListener);
                }
                this.container = null;
                this._widget = null;
                if (this._furniListInsertListener != null)
                {
                    this._furniListInsertListener.dispose();
                    this._furniListInsertListener = null;
                }
                this._respectNotificationListener = null;
                this._disposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.AVATAR_INFO;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return (this._container != null) ? this._container.roomEngine : null;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return (this._container != null) ? this._container.roomSession : null;
        }

        public var friendList(get,never):IHabboFriendsList;
public function  get_friendList():IHabboFriendsList
        {
            return (this._container != null) ? this._container.friendList : null;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            if ((((this._container != null) && (this._container.toolbar != null)) && (this._container.toolbar.events != null)))
            {
                this._container.toolbar.events.removeEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClicked);
            }
            if ((((this._container != null) && (this._container.sessionDataManager != null)) && (this._container.sessionDataManager.events != null)))
            {
                this._container.sessionDataManager.events.removeEventListener(UserNameUpdateEvent.UNUE_NAME_UPDATED, this._Str_21944);
            }
            if ((((this._container != null) && (this._container.roomSessionManager != null)) && (this._container.roomSessionManager.events != null)))
            {
                this._container.roomSessionManager.events.removeEventListener(RoomSessionPetStatusUpdateEvent.RSPFUE_PET_STATUS_UPDATE, this.onPetStatusUpdate);
                this._container.roomSessionManager.events.removeEventListener(RoomSessionPetLevelUpdateEvent.RSPLUE_PET_LEVEL_UPDATE, this.onPetLevelUpdate);
                this._container.roomSessionManager.events.removeEventListener(RoomSessionNestBreedingSuccessEvent.RSPFUE_NEST_BREEDING_SUCCESS, this._Str_20584);
            }
            if (((this._container != null) && (this._container.connection != null)))
            {
                this._container.connection.removeMessageEvent(this._furniListInsertListener);
            }
            if ((((this._container != null) && (this._container.connection != null)) && (this._respectNotificationListener != null)))
            {
                this._container.connection.removeMessageEvent(this._respectNotificationListener);
            }
            this._container = k;
            if (k == null)
            {
                return k;
            }
            if (this._furniListInsertListener == null)
            {
                this._furniListInsertListener = new FurniListAddOrUpdateEvent(this._Str_11630);
            }
            if (((!(this._respectNotificationListener != null)) && (this._container.connection != null)))
            {
                this._respectNotificationListener = new CustomUserNotificationMessageEvent(this._Str_22329);
                this._container.connection.addMessageEvent(this._respectNotificationListener);
            }
            if ((((this._container != null) && (this._container.toolbar != null)) && (this._container.toolbar.events != null)))
            {
                this._container.toolbar.events.addEventListener(HabboToolbarEvent.HTE_TOOLBAR_CLICK, this.onToolbarClicked);
            }
            if ((((this._container != null) && (this._container.sessionDataManager != null)) && (this._container.sessionDataManager.events != null)))
            {
                this._container.sessionDataManager.events.addEventListener(UserNameUpdateEvent.UNUE_NAME_UPDATED, this._Str_21944);
            }
            if ((((this._container != null) && (this._container.roomSessionManager != null)) && (this._container.roomSessionManager.events != null)))
            {
                this._container.roomSessionManager.events.addEventListener(RoomSessionPetStatusUpdateEvent.RSPFUE_PET_STATUS_UPDATE, this.onPetStatusUpdate);
                this._container.roomSessionManager.events.addEventListener(RoomSessionNestBreedingSuccessEvent.RSPFUE_NEST_BREEDING_SUCCESS, this._Str_20584);
                this._container.roomSessionManager.events.addEventListener(RoomSessionPetLevelUpdateEvent.RSPLUE_PET_LEVEL_UPDATE, this.onPetLevelUpdate);
            }
            if (((this._container != null) && (this._container.connection != null)))
            {
                this._container.connection.addMessageEvent(this._furniListInsertListener);
            }
return k;
        }

        function _Str_11630(k:IMessageEvent)
        {
            if (this._container != null)
            {
                if (this._container.events != null)
                {
                    this._container.events.dispatchEvent(new RoomWidgetInventoryUpdatedMessage(RoomWidgetInventoryUpdatedMessage.RWIUM_INVENTORY_UPDATED));
                }
            }
        }

        function onToolbarClicked(k:HabboToolbarEvent)
        {
            if (k.iconId == HabboToolbarIconEnum.MEMENU)
            {
                if (this.container.config.getBoolean("simple.memenu.enabled"))
                {
                    this._widget._Str_19679();
                }
                else
                {
                    this._Str_19177();
                }
            }
        }

        function _Str_21944(k:UserNameUpdateEvent)
        {
            this._widget.close();
        }

        function onPetStatusUpdate(k:RoomSessionPetStatusUpdateEvent)
        {
            var _local_2 = false;
            var _local_3 = false;
            var _local_4 = false;
            var _local_5 = false;
            var _local_6:RoomUserData = null;
            var _local_7:_Str_4828 = null;
            if (((!(this._container == null)) && (!(this._container.events == null))))
            {
                _local_2 = k.canBreed;
                _local_3 = k.canHarvest;
                _local_4 = k.canRevive;
                _local_5 = k.hasBreedingPermission;
                _local_6 = this._Str_19958(k.petId);
                if (_local_6 == null)
                {
                    Logger.log([(("Could not find pet with the id: " + Std.string(k.petId)) + " given by petStatusUpdate")]);
                    return;
                }
                _local_7 = new _Str_4828(_local_6.roomObjectId, _local_2, _local_3, _local_4, _local_5);
                this._container.events.dispatchEvent(_local_7);
            }
        }

        function onPetLevelUpdate(k:RoomSessionPetLevelUpdateEvent)
        {
            var _local_2 = 0;
            var _local_3:RoomUserData = null;
            var _local_4:_Str_4818 = null;
            if (((!(this._container == null)) && (!(this._container.events == null))))
            {
                _local_2 = k.level;
                _local_3 = this._Str_19958(k.petId);
                _local_4 = new _Str_4818(_local_3.roomObjectId, _local_2);
                this._container.events.dispatchEvent(_local_4);
            }
        }

        function _Str_19177()
        {
            var k= this._container.sessionDataManager.userId;
            var _local_2= this._container.sessionDataManager.userName;
            var _local_3= this._container.sessionDataManager.nameChangeAllowed;
            var _local_4= this._container.roomSession.userDataManager.getUserData(k);
            if (_local_4 != null)
            {
                this._container.events.dispatchEvent(new _Str_5393(k, _local_2, _local_4.type, _local_4.roomObjectId, _local_3));
            }
        }

        public function getWidgetMessages():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomWidgetRoomObjectMessage.RWROM_GET_OWN_CHARACTER_INFO);
            k.push(RoomWidgetUserActionMessage.RWUAM_START_NAME_CHANGE);
            k.push(RoomWidgetUserActionMessage.RWUAM_REQUEST_PET_UPDATE);
            k.push(RoomWidgetUseProductMessage.RWUPM_PET_PRODUCT);
            k.push(RoomWidgetUserActionMessage.RWUAM_REQUEST_BREED_PET);
            k.push(RoomWidgetUserActionMessage.RWUAM_HARVEST_PET);
            k.push(RoomWidgetUserActionMessage.RWUAM_REVIVE_PET);
            k.push(RoomWidgetUserActionMessage.RWUAM_COMPOST_PLANT);
            return k;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomSessionUserDataUpdateEvent.RSUDUE_USER_DATA_UPDATED);
            k.push(RoomSessionDanceEvent.RSDE_DANCE);
            k.push(RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY);
            k.push(RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_ROOM);
            return k;
        }

        public function processWidgetMessage(message:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var userId = 0;
            var userData:RoomUserData = null;
            var useProductMessage:RoomWidgetUseProductMessage = null;
            var localization:IHabboLocalizationManager = null;
            if (message == null)
            {
                return null;
            }
            userId = 0;
            var userAction= Std.downcast(message , RoomWidgetUserActionMessage);
            if (userAction != null)
            {
                userId = userAction.userId;
            }
            switch (message.type)
            {
                case RoomWidgetRoomObjectMessage.RWROM_GET_OWN_CHARACTER_INFO:
                    this._Str_19177();
                    
                case RoomWidgetUserActionMessage.RWUAM_START_NAME_CHANGE:
                    this._container.habboHelp.startNameChange();
                    
                case RoomWidgetUserActionMessage.RWUAM_REQUEST_PET_UPDATE:
                    this._widget._Str_25663 = false;
                    
                case RoomWidgetUseProductMessage.RWUPM_PET_PRODUCT:
                    useProductMessage = Std.downcast(message , RoomWidgetUseProductMessage);
                    if (useProductMessage != null)
                    {
                        this._container.roomSession.useProductForPet(useProductMessage.roomObjectId, useProductMessage.petId);
                    }
                    
                case RoomWidgetUserActionMessage.RWUAM_HARVEST_PET:
                    this._container.roomSession.harvestPet(userId);
                    
                case RoomWidgetUserActionMessage.RWUAM_REVIVE_PET:
                    
                case RoomWidgetUserActionMessage.RWUAM_COMPOST_PLANT:
                    localization = this._widget.catalog.localization;
                    this._widget.windowManager.confirm(localization.getLocalization("monsterplant.confirm.title.compost"), localization.getLocalization("monsterplant.confirm.desc.compost"), 0, function onCompostConfirmed (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                    {
                        k.dispose();
                        if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                        {
                            _container.roomSession.compostPlant(userId);
                        }
                    });
                    
                case RoomWidgetUserActionMessage.RWUAM_REQUEST_BREED_PET:
                    this._Str_25013(userId);
                    
                case RoomWidgetInventoryUpdatedMessage.RWIUM_INVENTORY_UPDATED:
                    
            }
            return null;
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionDanceEvent = null;
            var _local_3:RoomUserData = null;
            var _local_4:RoomUserData = null;
            switch (k.type)
            {
                case RoomSessionUserDataUpdateEvent.RSUDUE_USER_DATA_UPDATED:
                    this._container.events.dispatchEvent(new _Str_7783());
                    final _iter_ = cast(k, RoomSessionUserDataUpdateEvent)._Str_24272; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_3  = _tmp_;
                        if (this.friendList.getFriendNames().indexOf(_local_3.name) > -1)
                        {
                            this._widget._Str_21156(_local_3, _local_3.roomObjectId);
                        }
                    }
                    return;
                case RoomSessionDanceEvent.RSDE_DANCE:
                    _local_2 = Std.downcast(k , RoomSessionDanceEvent);
                    if ((((((_local_2 != null) && (this._widget != null)) && (this.container != null)) && (this.container.roomSession != null)) && (this.container.roomSession.userDataManager != null)))
                    {
                        _local_4 = this.container.roomSession.userDataManager.getUserData(this.container.sessionDataManager.userId);
                        if (((_local_4 != null) && (_local_2.userId == _local_4.roomObjectId)))
                        {
                            this._widget.isDancing = (!(_local_2._Str_8263 == 0));
                        }
                    }
                    return;
                case RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_INVENTORY:
                    this._Str_23199(Std.downcast(k , RoomEngineUseProductEvent).inventoryStripId, Std.downcast(k , RoomEngineUseProductEvent).furnitureTypeId);
                    return;
                case RoomEngineUseProductEvent.ROSM_USE_PRODUCT_FROM_ROOM:
                    this._Str_23807(Std.downcast(k , RoomEngineUseProductEvent).objectId);
                    return;
            }
        }

        function _Str_25013(k:Int)
        {
            Logger.log([("Show breed menu. finally: " + Std.string(k))]);
            if ((((this._container == null) || (this._container.roomSession == null)) || (this._container.roomEngine == null)))
            {
                return;
            }
            if (this._container.roomSession.userDataManager == null)
            {
                return;
            }
            var _local_2= this._container.roomSession.roomId;
            var _local_3= this._container.sessionDataManager.userId;
            var _local_4= this._container.roomSession.userDataManager.getUserDataByType(k, RoomObjectTypeEnum.PET);
            if (_local_4 == null)
            {
                return;
            }
            var _local_5:Array<ASAny> = (cast _local_4.figure.split(" "));
            var _local_6= ASCompat.toInt((_local_5.length > 0) ? ASCompat.toInt(_local_5[0] ): -1);
            this._Str_25028(_local_2, k, _local_6, _local_4.roomObjectId, _local_3);
        }

        public function update()
        {
        }

        function _Str_20584(k:RoomSessionNestBreedingSuccessEvent)
        {
            if (((!(this._container == null)) && (!(this._container.events == null))))
            {
                this._widget._Str_24481(k.petId, k.rarityCategory);
            }
        }

        public function getFurniData(k:IRoomObject):IFurnitureData
        {
            var _local_2:IFurnitureData = null;
            var _local_3 = 0;
            if (k != null)
            {
                _local_3 = Std.int(k.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_TYPE_ID));
                _local_2 = this._container.sessionDataManager.getFloorItemData(_local_3);
            }
            return _local_2;
        }

        function _Str_23199(k:Int, _arg_2:Int)
        {
            if ((((this._container == null) || (this._container.roomSession == null)) || (this._container.roomEngine == null)))
            {
                return;
            }
            if (this._container.roomSession.userDataManager == null)
            {
                return;
            }
            var _local_3= this._container.roomSession.roomId;
            var _local_4= this._container.sessionDataManager.userId;
            var _local_5= this._container.sessionDataManager.getFloorItemData(_arg_2);
            if (_local_5 == null)
            {
                return;
            }
            var _local_6:Array<ASAny> = (cast _local_5.customParams.split(" "));
            var _local_7= ((_local_6.length > 0) ? ASCompat.parseInt(_local_6[0]) : -1);
            if (_local_7 == -1)
            {
                return;
            }
            this._Str_21985(_local_3, _arg_2, _local_7, _local_5.category, _local_4, k);
        }

        function _Str_23807(k:Int)
        {
            if ((((this._container == null) || (this._container.roomSession == null)) || (this._container.roomEngine == null)))
            {
                return;
            }
            if (this._container.roomSession.userDataManager == null)
            {
                return;
            }
            var _local_2= this._container.roomSession.roomId;
            var _local_3= this._container.roomEngine.getRoomObject(_local_2, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            var _local_4= this._container.isOwnerOfFurniture(_local_3);
            if (!_local_4)
            {
                return;
            }
            var _local_5= this._container.getFurnitureOwnerId(_local_3);
            var _local_6= this.getFurniData(_local_3);
            var _local_7:Array<ASAny> = (cast _local_6.customParams.split(" "));
            var _local_8= ((_local_7.length > 0) ? ASCompat.parseInt(_local_7[0]) : -1);
            if (_local_8 == -1)
            {
                return;
            }
            this._Str_21985(_local_2, k, _local_8, _local_6.category, _local_5);
        }

        function _Str_21985(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int=-1)
        {
            var _local_8:IRoomObject = null;
            var _local_12:RoomUserData = null;
            var _local_13 = false;
            var _local_14:Array<ASAny> = null;
            var _local_15 = 0;
            var _local_7:Array<ASAny> = [];
            var _local_9= this._container.roomEngine.getRoomObjectCount(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_10= 7;
            var _local_11 = 0;
            while (_local_11 < _local_9)
            {
                _local_8 = this._container.roomEngine.getRoomObjectWithIndex(k, _local_11, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_12 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_8.getId());
                _local_13 = false;
                if (((_local_12 == null) || (!(_local_12.type == RoomObjectTypeEnum.PET))))
                {
                }
                else
                {
                    if (_local_12.ownerId == _arg_5)
                    {
                        if ((_local_12.hasSaddle && (_arg_4 == FurniCategory.PET_SADDLE)))
                        {
                            _local_13 = true;
                        }
                        _local_14 = (cast _local_12.figure.split(" "));
                        _local_15 = ASCompat.toInt((_local_14.length > 0) ? ASCompat.toInt(_local_14[0] ): -1);
                        if (_local_15 == _arg_3)
                        {
                            if (_arg_4 == FurniCategory.MONSTERPLANT_REVIVAL)
                            {
                                if (!_local_12.canRevive)
                                {
                                    _local_11++;continue;
                                }
                            }
                            if (_arg_4 == FurniCategory.MONSTERPLANT_REBREED)
                            {
                                if ((((_local_12.petLevel < _local_10) || _local_12.canRevive) || _local_12.canBreed))
                                {
                                    _local_11++;continue;
                                }
                            }
                            if (_arg_4 == FurniCategory.MONSTERPLANT_FERTILIZE)
                            {
                                if (((_local_12.petLevel >= _local_10) || _local_12.canRevive))
                                {
                                    _local_11++;continue;
                                }
                            }
                            _local_7.push(new _Str_3858(_local_12.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, _local_12.name, _arg_2, _local_8.getId(), _arg_6, _local_13));
                        }
                    }
                }
_local_11++;
            }
            this._widget._Str_23386(_local_7);
        }

        function _Str_25028(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            var _local_7:IRoomObject = null;
            var _local_10:RoomUserData = null;
            var _local_11:RoomUserData = null;
            var _local_12:Array<ASAny> = null;
            var _local_13 = 0;
            var _local_6:Array<ASAny> = [];
            var _local_8= this._container.roomEngine.getRoomObjectCount(k, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_9 = 0;
            while (_local_9 < _local_8)
            {
                _local_7 = this._container.roomEngine.getRoomObjectWithIndex(k, _local_9, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_10 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_7.getId());
                if (((_local_10 == null) || (!(_local_10.type == RoomObjectTypeEnum.PET))))
                {
                }
                else
                {
                    if (!_local_10.canBreed)
                    {
                    }
                    else
                    {
                        if (((!_local_10.hasBreedingPermission) && (!(_local_10.ownerId == _arg_5))))
                        {
                        }
                        else
                        {
                            _local_11 = this._container.roomSession.userDataManager.getUserData(_local_10.ownerId);
                            if (_local_11 == null)
                            {
                            }
                            else
                            {
                                _local_12 = (cast _local_10.figure.split(" "));
                                _local_13 = ASCompat.toInt((_local_12.length > 0) ? ASCompat.toInt(_local_12[0] ): -1);
                                if (((_local_13 == _arg_3) && (!(_local_10.roomObjectId == _arg_4))))
                                {
                                    _local_6.push(new _Str_3858(_local_10.roomObjectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, _local_10.name, _arg_4, _local_7.getId()));
                                }
                            }
                        }
                    }
                }
                _local_9++;
            }
            this._widget._Str_24967(_local_6);
        }

        function _Str_19958(k:Int):RoomUserData
        {
            var _local_5:IRoomObject = null;
            var _local_6:RoomUserData = null;
            var _local_2= this._container.roomSession.roomId;
            var _local_3= this._container.roomEngine.getRoomObjectCount(_local_2, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_5 = this._container.roomEngine.getRoomObjectWithIndex(_local_2, _local_4, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER);
                _local_6 = this._container.roomSession.userDataManager.getUserDataByIndex(_local_5.getId());
                if (((_local_6 == null) || (!(_local_6.type == RoomObjectTypeEnum.PET))))
                {
                }
                else
                {
                    if (_local_6.id == k)
                    {
                        return _local_6;
                    }
                }
                _local_4++;
            }
            return null;
        }

        public function _Str_22329(k:CustomUserNotificationMessageEvent)
        {
            var _local_2= k.getParser().code;
            switch (_local_2)
            {
                case 4
                   | 5:
                    this._container.sessionDataManager.giveRespectFailed();
                    return;
            }
        }
public function new(){}
    }

