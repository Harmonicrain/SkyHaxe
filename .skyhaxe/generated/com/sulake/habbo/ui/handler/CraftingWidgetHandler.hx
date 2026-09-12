package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.crafting.CraftingWidget;
    import com.sulake.habbo.ui.RoomDesktop;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftableProductsEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingRecipeEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingResultEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingRecipesAvailableEvent;
    import com.sulake.habbo.inventory.events.HabboInventoryFurniListParsedEvent;
    import com.sulake.habbo.inventory._enum.InventoryCategory;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftingRecipeComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftableProductsComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.GetCraftingRecipesAvailableComposer;
    import com.sulake.habbo.ui.widget.crafting.utils.CraftingViewStateEnum;
    import com.sulake.habbo.communication.messages.outgoing.crafting.CraftComposer;
    import com.sulake.habbo.communication.messages.outgoing.crafting.CraftSecretComposer;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingResultObjectParser;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.communication.messages.incoming.inventory.furni.FurniListInvalidateEvent;
    import com.sulake.habbo.communication.messages.outgoing.inventory.furni.RequestFurniInventoryComposer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import flash.events.Event;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

     class CraftingWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer;
        var _widget:CraftingWidget;
        var _roomDesktop:RoomDesktop;
        var _inventoryUpdateEvent:IMessageEvent;
        var _messageEvents:Vector<IMessageEvent>;
        var _gizmoFurnitureId:Int = 0;
        var _waitingForInitialData:Bool = false;
        var _inventoryDirty:Bool = false;
        var _craftingInProgress:Bool = false;
        var _selectedProductData:IProductData;

        public function new(k:RoomDesktop)
        {
            this._roomDesktop = k;
        }

        public function dispose()
        {
            this._Str_15944();
            this._widget = null;
            this._container = null;
            this._roomDesktop = null;
            this._selectedProductData = null;
            this._disposed = true;
        }

        function _Str_17717()
        {
            var k:IMessageEvent = null;
            if (((!(this._container != null)) || (!(this._container.connection != null))))
            {
                return;
            }
            this._messageEvents = new Vector<IMessageEvent>(0);
            this._messageEvents.push(new CraftableProductsEvent(this._Str_23500));
            this._messageEvents.push(new CraftingRecipeEvent(this._Str_24394));
            this._messageEvents.push(new CraftingResultEvent(this._Str_24572));
            this._messageEvents.push(new CraftingRecipesAvailableEvent(this._Str_23175));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._container.connection.addMessageEvent(k);
            }
        }

        function _Str_15944()
        {
            var k:IMessageEvent = null;
            if ((((!(this._container != null)) || (!(this._container.connection != null))) || (!(this._messageEvents != null))))
            {
                return;
            }
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this._container.connection.removeMessageEvent(k);
                k.dispose();
            }
            this._Str_15726();
            if (((this._container.inventory != null) && (this._container.inventory.events != null)))
            {
                this._container.inventory.events.removeEventListener(HabboInventoryFurniListParsedEvent.HFLPE_FURNI_LIST_PARSED, this._Str_21755);
            }
            this._messageEvents = null;
        }

        public function _Str_25738()
        {
            if (this._waitingForInitialData)
            {
                return;
            }
            this._waitingForInitialData = true;
            if (this._container.inventory.checkCategoryInitilization(InventoryCategory.FURNI))
            {
                this._Str_19499();
            }
        }

        function _Str_21755(k:HabboInventoryFurniListParsedEvent)
        {
            if ((this._waitingForInitialData && (k.category == InventoryCategory.FURNI)))
            {
                this._Str_19499();
            }
        }

        function _Str_19499()
        {
            this._container.connection.send(new GetCraftingRecipeComposer(this._gizmoFurnitureId));
        }

        function _Str_23500(k:CraftableProductsEvent)
        {
            this._waitingForInitialData = false;
            if (this._widget == null)
            {
                return;
            }
            if (!k.getParser().isActive())
            {
                this._widget.hide();
                return;
            }
            this._widget._Str_22471();
            this._widget._Str_24786(k.getParser().recipes, k.getParser().ingredients, this._container.roomEngine, this._container.sessionDataManager);
            this._inventoryDirty = false;
        }

        public function _Str_25388(k:String)
        {
            this._selectedProductData = this._container.sessionDataManager.getProductData(k);
            this._container.connection.send(new GetCraftableProductsComposer(k));
        }

        function _Str_24394(k:CraftingRecipeEvent)
        {
            this._widget._Str_23442(k.getParser().ingredients);
        }

        public function _Str_25351(k:Vector<Int>)
        {
            this._container.connection.send(new GetCraftingRecipesAvailableComposer(this._gizmoFurnitureId, k));
        }

        function _Str_23175(k:CraftingRecipesAvailableEvent)
        {
            this._widget._Str_11931._Str_25724(k.getParser().count, k.getParser().hasRecipes);
        }

        public function _Str_23985()
        {
            if (this._selectedProductData == null)
            {
                return;
            }
            this._widget._Str_11931.setState(CraftingViewStateEnum._Str_9671);
            this._Str_21898();
            this._container.connection.send(new CraftComposer(this._gizmoFurnitureId, this._selectedProductData.type));
        }

        public function _Str_23682()
        {
            this._widget._Str_11931.setState(CraftingViewStateEnum._Str_9671);
            var k= this._widget._Str_24728();
            this._Str_21898();
            this._container.connection.send(new CraftSecretComposer(this._gizmoFurnitureId, k));
        }

        function _Str_24572(k:CraftingResultEvent)
        {
            var _local_2:CraftingResultObjectParser = null;
            var _local_3:IFurnitureData = null;
            this._craftingInProgress = false;
            if (!k.getParser().success)
            {
                this._widget._Str_14796();
                this._inventoryDirty = false;
                this._Str_15726();
                this._widget.setInfoState(CraftingViewStateEnum._Str_8764);
            }
            else
            {
                this._widget._Str_14796();
                _local_2 = k.getParser().result;
                _local_3 = this._container.sessionDataManager.getFloorItemDataByName(_local_2.itemName);
                if (_local_3 == null)
                {
                    return;
                }
                this._widget.setInfoState(CraftingViewStateEnum._Str_13842, [_local_3]);
            }
        }

        function _Str_21898()
        {
            this._inventoryDirty = true;
            if (this._inventoryUpdateEvent == null)
            {
                this._inventoryUpdateEvent = new FurniListInvalidateEvent(this._Str_18656);
                this._container.connection.addMessageEvent(this._inventoryUpdateEvent);
            }
        }

        function _Str_18656(k:FurniListInvalidateEvent)
        {
            this._container.connection.send(new RequestFurniInventoryComposer());
            this._container.connection.send(new GetCraftingRecipeComposer(this._gizmoFurnitureId));
            this._Str_15726();
        }

        public function _Str_15726()
        {
            if (this._inventoryUpdateEvent != null)
            {
                this._container.connection.removeMessageEvent(this._inventoryUpdateEvent);
                this._inventoryUpdateEvent = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CRAFTING;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._Str_17717();
            if (((this._container.inventory != null) && (this._container.inventory.events != null)))
            {
                this._container.inventory.events.addEventListener(HabboInventoryFurniListParsedEvent.HFLPE_FURNI_LIST_PARSED, this._Str_21755);
            }
return k;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var widget(never,set):CraftingWidget;
public function  set_widget(k:CraftingWidget):CraftingWidget        {
            return this._widget = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return null;
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.OPEN_WIDGET, RoomEngineTriggerWidgetEvent.CLOSE_WIDGET];
        }

        public function processEvent(k:Event)
        {
            if (((this._container.roomEngine == null) || (this._widget == null)))
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomEngineTriggerWidgetEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET:
                    if (this._widget.window != null)
                    {
                        return;
                    }
                    if (_local_3 != null)
                    {
                        this._gizmoFurnitureId = _local_3.getId();
                        this._Str_25738();
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    this._gizmoFurnitureId = -1;
                    this._widget.hide();
                    return;
            }
        }

        public var isOwner(get,never):Bool;
public function  get_isOwner():Bool
        {
            var k= this._container.roomEngine.activeRoomId;
            var _local_2= this._container.roomEngine.getRoomObject(k, this._gizmoFurnitureId, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
            return (!(_local_2 == null)) && this._container.isOwnerOfFurniture(_local_2);
        }

        
        public var craftingInProgress(get,set):Bool;
public function  get_craftingInProgress():Bool
        {
            return this._craftingInProgress;
        }
public function  set_craftingInProgress(k:Bool):Bool        {
            return this._craftingInProgress = k;
        }

        public var inventoryDirty(get,never):Bool;
public function  get_inventoryDirty():Bool
        {
            return this._inventoryDirty;
        }

        public function update()
        {
        }
    }

