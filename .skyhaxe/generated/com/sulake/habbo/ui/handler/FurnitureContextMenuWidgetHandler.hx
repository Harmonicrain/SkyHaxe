package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.contextmenu.FurnitureContextMenuWidget;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.ui.widget.furniture.mysterybox.MysteryBoxToolbarExtension;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.GuildFurniContextMenuInfoMessageEvent;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetUseProductMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.enums.ContextMenuEnum;
    import flash.events.Event;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.outgoing.users.JoinHabboGroupMessageComposer;
    import com.sulake.habbo.communication.messages.parser.room.furniture.GuildFurniContextMenuInfoMessageParser;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;

     class FurnitureContextMenuWidgetHandler implements IRoomWidgetHandler 
    {
        var _disposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:FurnitureContextMenuWidget;
        var _connection:IConnection;
        var _furniContextMenuInfoListener:IMessageEvent = null;
        var _mysteryBoxToolbarExtension:MysteryBoxToolbarExtension;

        public function new()
        {
            this._mysteryBoxToolbarExtension = new MysteryBoxToolbarExtension(this);
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._mysteryBoxToolbarExtension != null)
                {
                    this._mysteryBoxToolbarExtension.dispose();
                    this._mysteryBoxToolbarExtension = null;
                }
                this._Str_21505();
                if (((!(this._connection == null)) && (this._furniContextMenuInfoListener != null)))
                {
                    this._connection.removeMessageEvent(this._furniContextMenuInfoListener);
                    this._furniContextMenuInfoListener = null;
                }
                this._connection = null;
                this._widget = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return null;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return (this._container != null) ? this._container.roomEngine : null;
        }

        function _Str_21505()
        {
            if (this._container != null)
            {
                this._container.roomEngine.events.removeEventListener(RoomEngineTriggerWidgetEvent.ROWRE_REQUEST_MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG, this._Str_19781);
                this._container.roomEngine.events.removeEventListener(RoomEngineTriggerWidgetEvent.ROWRE_REQUEST_PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG, this._Str_19399);
                this._container.roomEngine.events.removeEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MYSTERYBOX_OPEN_DIALOG, this._Str_21363);
                this._container.roomEngine.events.removeEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_EFFECTBOX_OPEN_DIALOG, this._Str_19693);
                this._container.roomEngine.events.removeEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MYSTERYTROPHY_OPEN_DIALOG, this._Str_19747);
            }
            this._container = null;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._Str_21505();
            this._container = k;
            if (k == null)
            {
                return k;
            }
            if (this._container.roomEngine != null)
            {
                this._container.roomEngine.events.addEventListener(RoomEngineTriggerWidgetEvent.ROWRE_REQUEST_MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG, this._Str_19781);
                this._container.roomEngine.events.addEventListener(RoomEngineTriggerWidgetEvent.ROWRE_REQUEST_PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG, this._Str_19399);
                this._container.roomEngine.events.addEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MYSTERYBOX_OPEN_DIALOG, this._Str_21363);
                this._container.roomEngine.events.addEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_EFFECTBOX_OPEN_DIALOG, this._Str_19693);
                this._container.roomEngine.events.addEventListener(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_MYSTERYTROPHY_OPEN_DIALOG, this._Str_19747);
            }
return k;
        }

        
        public var widget(get,set):FurnitureContextMenuWidget;
public function  set_widget(k:FurnitureContextMenuWidget):FurnitureContextMenuWidget        {
            this._widget = k;
            if (this._container.config.getBoolean("mysterybox.tracker.active"))
            {
                this._mysteryBoxToolbarExtension.createWindow();
            }
return k;
        }

        public var connection(never,set):IConnection;
public function  set_connection(k:IConnection):IConnection        {
            this._connection = k;
            if (this._furniContextMenuInfoListener == null)
            {
                this._furniContextMenuInfoListener = new GuildFurniContextMenuInfoMessageEvent(this.onGuildFurniContextMenuInfo);
                this._connection.addMessageEvent(this._furniContextMenuInfoListener);
            }
return k;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return (this._container != null) ? this._container.roomSession : null;
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

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetUseProductMessage.MONSTERPLANT_SEED];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetUseProductMessage = null;
            if (k == null)
            {
                return null;
            }
            switch (k.type)
            {
                case RoomWidgetUseProductMessage.MONSTERPLANT_SEED:
                    _local_2 = Std.downcast(k , RoomWidgetUseProductMessage);
                    if (_local_2 != null)
                    {
                        this._container.roomSession.plantSeed(_local_2.roomObjectId);
                    }
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_OPEN_FURNI_CONTEXT_MENU, RoomEngineTriggerWidgetEvent.RETWE_CLOSE_FURNI_CONTEXT_MENU];
        }

        public function processEvent(k:Event)
        {
            if (this._widget == null)
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomEngineTriggerWidgetEvent);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= this.getRoomObject(_local_2.objectId);
            if (_local_3 == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_OPEN_FURNI_CONTEXT_MENU:
                    switch (_local_2.contextMenu)
                    {
                        case ContextMenuEnum.FRIEND_FURNITURE:
                            this._widget._Str_25158(_local_3);
                            
                        case ContextMenuEnum.MONSTERPLANT_SEED:
                            if (this._container.isOwnerOfFurniture(_local_3))
                            {
                                this._widget._Str_23088(_local_3, _local_2.category);
                            }
                            
                        case ContextMenuEnum.MYSTERY_BOX:
                            this._widget._Str_25785(_local_3);
                            
                        case ContextMenuEnum.RANDOM_TELEPORT:
                            this._widget._Str_23454(_local_3, _local_2.category);
                            
                        case ContextMenuEnum.PURCHASABLE_CLOTHING:
                            this._widget._Str_23812(_local_3, _local_2.category);
                            
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.RETWE_CLOSE_FURNI_CONTEXT_MENU:
                    this._widget._Str_22969(_local_3);
                    return;
            }
        }

        public function update()
        {
        }

        public function _Str_25023(k:Int):Rectangle
        {
            return this._container.roomEngine.getRoomObjectBoundingRectangle(this._container.roomSession.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, this._container.getFirstCanvasId());
        }

        public function _Str_22398(k:Int):Point
        {
            return this._container.roomEngine.getRoomObjectScreenLocation(this._container.roomSession.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE, this._container.getFirstCanvasId());
        }

        public function _Str_24389(k:Int)
        {
            this._container.navigator.goToPrivateRoom(k);
        }

        public function _Str_24943(k:Int)
        {
            this._connection.send(new JoinHabboGroupMessageComposer(k));
        }

        function getRoomObject(k:Int):IRoomObject
        {
            if (this._container == null)
            {
                return null;
            }
            return this._container.roomEngine.getRoomObject(this._container.roomSession.roomId, k, RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE);
        }

        function onGuildFurniContextMenuInfo(k:GuildFurniContextMenuInfoMessageEvent)
        {
            var _local_2:GuildFurniContextMenuInfoMessageParser = null;
            var _local_3:IRoomObject = null;
            if (this._widget != null)
            {
                _local_2 = k.getParser();
                _local_3 = this.getRoomObject(_local_2.objectId);
                if (_local_3 != null)
                {
                    this._widget._Str_24867(_local_3, _local_2.guildId, _local_2._Str_24570, _local_2._Str_25076, _local_2._Str_24832, _local_2._Str_24908);
                }
            }
        }

        function _Str_19781(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3 = false;
            if (this._widget != null)
            {
                _local_2 = this.getRoomObject(k.objectId);
                if (_local_2 != null)
                {
                    _local_3 = this._container.isOwnerOfFurniture(_local_2);
                    if (!_local_3)
                    {
                        return;
                    }
                    this._widget._Str_20801(_local_2);
                }
            }
        }

        function _Str_19399(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3 = false;
            if (this._widget != null)
            {
                _local_2 = this.getRoomObject(k.objectId);
                if (_local_2 != null)
                {
                    _local_3 = this._container.isOwnerOfFurniture(_local_2);
                    if (!_local_3)
                    {
                        return;
                    }
                    this._widget._Str_24748(_local_2);
                }
            }
        }

        function _Str_19693(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3 = false;
            if (this._widget != null)
            {
                _local_2 = this.getRoomObject(k.objectId);
                if (_local_2 != null)
                {
                    _local_3 = this._container.isOwnerOfFurniture(_local_2);
                    if (!_local_3)
                    {
                        return;
                    }
                    this._widget._Str_22510(_local_2);
                }
            }
        }

        function _Str_19747(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            var _local_3 = false;
            if (this._widget != null)
            {
                _local_2 = this.getRoomObject(k.objectId);
                if (_local_2 != null)
                {
                    _local_3 = this._container.isOwnerOfFurniture(_local_2);
                    if (!_local_3)
                    {
                        return;
                    }
                    this._widget._Str_25152(_local_2);
                }
            }
        }

        function _Str_21363(k:RoomEngineObjectEvent)
        {
            var _local_2:IRoomObject = null;
            if (this._widget != null)
            {
                _local_2 = this.getRoomObject(k.objectId);
                if (_local_2 != null)
                {
                    this._widget._Str_20629(_local_2);
                }
            }
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function  get_widget():FurnitureContextMenuWidget
        {
            return this._widget;
        }
    }

