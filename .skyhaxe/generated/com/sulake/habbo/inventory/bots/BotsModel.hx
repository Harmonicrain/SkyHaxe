package com.sulake.habbo.inventory.bots
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
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.communication.messages.outgoing.inventory.bots.GetBotInventoryComposer;
    import com.sulake.habbo.communication.messages.parser.inventory.bots.BotData;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import flash.events.Event;
    import com.sulake.habbo.inventory.events.HabboInventoryTrackingEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room._enum.RoomObjectPlacementSource;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.habbo.communication.messages.outgoing.room.engine.PlaceBotMessageComposer;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.inventory._enum.UnseenItemCategoryEnum;

     class BotsModel implements IInventoryModel 
    {
        var _controller:HabboInventory;
        var _view:BotsView;
        var _assets:IAssetLibrary;
        var _communication:IHabboCommunicationManager;
        var _roomEngine:IRoomEngine;
        var _catalog:IHabboCatalog;
        var _items:Map;
        var _isPlacing:Bool = false;
        var _disposed:Bool = false;
        var _isListInitialized:Bool = false;

        public function new(k:HabboInventory, _arg_2:IHabboWindowManager, _arg_3:IHabboCommunicationManager, _arg_4:IAssetLibrary, _arg_5:IRoomEngine, _arg_6:IHabboCatalog, _arg_7:IAvatarRenderManager)
        {
            this._controller = k;
            this._assets = _arg_4;
            this._communication = _arg_3;
            this._roomEngine = _arg_5;
            this._roomEngine.events.addEventListener(RoomEngineObjectEvent.PLACED, this._Str_6946);
            this._catalog = _arg_6;
            this._items = new Map();
            this._view = new BotsView(this, _arg_2, _arg_4, _arg_5, _arg_7);
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
                if (this._items != null)
                {
                    this._items.dispose();
                    this._items = null;
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

        public function _Str_24301()
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
            k.send(new GetBotInventoryComposer());
        }

        public var items(get,never):Map;
public function  get_items():Map
        {
            return this._items;
        }

        public function addItem(k:BotData)
        {
            if (this._items.add(k.id, k))
            {
                this._view.addItem(k);
            }
            this._view._Str_3820();
        }

        public function _Str_23563(k:Map)
        {
            var _local_2 = 0;
            var _local_3= k.getKeys();
            var _local_4= this._items.getKeys();
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_2  = ASCompat.toInt(_tmp_);
                if (_local_3.indexOf(_local_2) == -1)
                {
                    this._items.remove(_local_2);
                    this._view.removeItem(_local_2);
                }
            }
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_2  = ASCompat.toInt(_tmp_);
                if (_local_4.indexOf(_local_2) == -1)
                {
                    this._items.add(_local_2, k.getValue(_local_2));
                    this._view.addItem(k.getValue(_local_2));
                }
            }
        }

        public function removeItem(k:Int)
        {
            this._items.remove(k);
            this._view.removeItem(k);
            this._view._Str_3820();
        }

        public function onInventoryOpen()
        {
            this._Str_24301();
        }

        public function initCategory(k:String)
        {
            if (((k == InventoryCategory.BOTS) && this._controller.isVisible))
            {
                this._controller.events.dispatchEvent(new Event(HabboInventoryTrackingEvent.HABBO_INVENTORY_TRACKING_EVENT_BOTS));
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

        public function _Str_7009(k:Int, _arg_2:Bool=false):Bool
        {
            var _local_4 = 0;
            var _local_3= this._Str_14402(k);
            if (_local_3 == null)
            {
                return false;
            }
            if (!this._controller.roomSession.areBotsAllowed)
            {
                return false;
            }
            if (this._controller.roomSession.isRoomOwner)
            {
                _local_4 = (_local_3.id * -1);
                this._isPlacing = this._roomEngine.initializeRoomObjectInsert(RoomObjectPlacementSource.INVENTORY, _local_4, RoomObjectCategoryEnum.OBJECT_CATEGORY_USER, RoomObjectTypeEnum.RENTABLE_BOT, _local_3.figure);
                this._controller._Str_13252();
                return this._isPlacing;
            }
            if (!_arg_2)
            {
                this._communication.connection.send(new PlaceBotMessageComposer(_local_3.id, 0, 0));
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

        function _Str_14402(k:Int):BotData
        {
            var _local_2:BotData = null;
            final _iter_ = this._items; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
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

        public function _Str_4409()
        {
            this._controller.unseenItemTracker._Str_8813(UnseenItemCategoryEnum.BOT);
            this._controller._Str_6956();
            this._view.update();
        }

        public function isUnseen(k:Int):Bool
        {
            return this._controller.unseenItemTracker.isUnseen(UnseenItemCategoryEnum.BOT, k);
        }

        public function onSubcategorySwitch(k:String)
        {
            this._view._Str_16613(ASCompat.toInt(k));
        }
    }

