package com.sulake.habbo.inventory.pets
;
    import com.sulake.habbo.inventory.IInventoryModel;
    import com.sulake.habbo.inventory.HabboInventory;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.communication.messages.outgoing.inventory.pets.GetPetInventoryComposer;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.Pet;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import flash.events.Event;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.avatar.pets.PetTypeEnum;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.PlacePetMessageComposer;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;

     class PetsModel implements IInventoryModel 
    {
        var _controller:HabboInventory;
        var _view:PetsView;
        var _assets:IAssetLibrary;
        var _communication:IHabboCommunicationManager;
        var _roomEngine:IRoomEngine;
        var _catalog:IHabboCatalog;
        var _pets:Map;
        var _isPlacing:Bool = false;
        var _disposed:Bool = false;
        var _isListInitialized:Bool = false;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine, _arg_6:IHabboCatalog)
        {
            this._controller = k;
            this._assets = _arg_4;
            this._communication = _arg_3;
            this._roomEngine = _arg_5;
            this._roomEngine.events.addEventListener(RoomEngineObjectEvent.PLACED, this._Str_6946);
            this._catalog = _arg_6;
            this._pets = new Map();
            this._view = new PetsView(this, _arg_2, _arg_4, _arg_5);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._view != null)
                {
                    this._view.dispose();
                    this._view = null;
                }
                if (this._roomEngine != null)
                {
                    if (this._roomEngine.events != null)
                    {
                        this._roomEngine.events.removeEventListener(RoomEngineObjectEvent.PLACED, this._Str_6946);
                    }
                    this._roomEngine = null;
                }
                if (this._pets != null)
                {
                    this._pets.dispose();
                    this._pets = null;
                }
                this._controller = null;
                this._catalog = null;
                this._assets = null;
                this._communication = null;
                this._disposed = true;
            }
        }

        public var controller(get,never):HabboInventory;
public function  get_controller():HabboInventory
        {
            return this._controller;
        }

        public function _Str_18819():Bool
        {
            return this._isListInitialized;
        }

        public function _Str_11524()
        {
            this._isListInitialized = true;
            this._view._Str_3820();
        }

        public function _Str_22384()
        {
            if (this._communication == null)
            {
                return;
            }
            var k= this._communication.connection;
            if (k == null)
            {
                return;
            }
            k.send(new GetPetInventoryComposer());
        }

        public var pets(get,never):Map;
public function  get_pets():Map
        {
            return this._pets;
        }

        public function _Str_9947(k:Pet)
        {
            if (this._pets.add(k.id, k))
            {
                this._view._Str_9947(k);
            }
            this._view._Str_3820();
        }

        public function _Str_25168(k:Map)
        {
            var _local_2 = 0;
            var _local_3= k.getKeys();
            var _local_4= this._pets.getKeys();
            this._controller._Str_5943(InventoryCategory.PETS);
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_2  = ASCompat.toInt(_tmp_);
                if (_local_3.indexOf(_local_2) == -1)
                {
                    this._pets.remove(_local_2);
                    this._view._Str_12321(_local_2);
                }
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_2  = ASCompat.toInt(_tmp_);
                if (_local_4.indexOf(_local_2) == -1)
                {
                    this._pets.add(_local_2, k.getValue(_local_2));
                    this._view._Str_9947(k.getValue(_local_2));
                }
            }
            this._Str_11524();
        }

        public function _Str_12321(k:Int)
        {
            this._pets.remove(k);
            this._view._Str_12321(k);
            this._view._Str_3820();
        }

        public function onInventoryOpen()
        {
            this._Str_22384();
        }

        public function initCategory(k:String)
        {
            if (((k == InventoryCategory.PETS) && this._controller.isVisible))
            {
                this._controller.events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_PETS));
            }
        }

        public function getWindowContainer():IWindowContainer
        {
            return this._view.getWindowContainer();
        }

        public function onInventoryClose()
        {
            if (this._view.isVisible)
            {
                this._Str_4409();
            }
        }

        public function onCategorySwitch(k:String)
        {
        }

        public function placePetToRoom(k:Int, _arg_2:Bool=false):Bool
        {
            var _local_5 = 0;
            var _local_3= this._Str_22756(k);
            if (_local_3 == null)
            {
                return false;
            }
            var _local_4:String = null;
            if (_local_3.typeId == PetTypeEnum.MONSTERPLANT)
            {
                if (_local_3.level >= 7)
                {
                    _local_4 = "std";
                }
                else
                {
                    _local_4 = ("grw" + Std.string(_local_3.level));
                }
            }
            if (this._controller.roomSession.isRoomOwner)
            {
                _local_5 = (_local_3.id * -1);
                this._isPlacing = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, _local_5, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, RoomObjectTypeEnum.PET, _local_3.figureString, null, -1, -1, _local_4);
                this._controller._Str_13252();
                return this._isPlacing;
            }
            if (!this._controller.roomSession.arePetsAllowed)
            {
                return false;
            }
            if (!_arg_2)
            {
                this._communication.connection.send(new PlacePetMessageComposer(_local_3.id, 0, 0));
            }
            return true;
        }

        public function updateView()
        {
            if (this._view == null)
            {
                return;
            }
            this._view.update();
        }

        function _Str_22756(k:Int):Pet
        {
            var _local_2:Pet = null;
            final _iter_ = this._pets; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_2  = _tmp_;
                if (_local_2.id == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_6946(k:Event)
        {
            if (k == null)
            {
                return;
            }
            if ((this._isPlacing && (k.type == RoomEngineObjectEvent.PLACED)))
            {
                this._controller.showView();
                this._isPlacing = false;
            }
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return this._controller.roomSession;
        }

        public function _Str_19310()
        {
            this._view.update();
        }

        public function _Str_4409()
        {
            this._controller.unseenItemTracker._Str_8813(UnseenItemCategoryEnum.PET);
            this._controller._Str_6956();
            this._view.update();
        }

        public function isUnseen(k:Int):Bool
        {
            return this._controller.unseenItemTracker.isUnseen(UnseenItemCategoryEnum.PET, k);
        }

        public function _Str_7938(k:Int):Bool
        {
            var _local_2 = false;
            if (this.isUnseen(k))
            {
            _local_2 = this._controller.unseenItemTracker._Str_16745(UnseenItemCategoryEnum.PET, k);
                if (_local_2)
                {
            this._controller.unseenItemTracker._Str_17159(UnseenItemCategoryEnum.PET);
                }
            }
            return _local_2;
        }

        public function onSubcategorySwitch(k:String)
        {
            this._view._Str_16613(ASCompat.toInt(k));
        }
    }

