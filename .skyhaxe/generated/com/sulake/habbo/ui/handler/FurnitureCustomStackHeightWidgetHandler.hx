package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.customstackheight.CustomStackHeightWidget;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.CustomStackingHeightUpdateMessageEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.room.object.IRoomObject;
    import flash.events.Event;
    import com.sulake.habbo.session._enum.RoomControllerLevel;

     class FurnitureCustomStackHeightWidgetHandler implements IRoomWidgetHandler 
    {
        var _container:IRoomWidgetHandlerContainer;
        var _widget:CustomStackHeightWidget;
        var _lastFurniId:Int = -1;


        public var widget(never,set):CustomStackHeightWidget;
public function  set_widget(k:CustomStackHeightWidget):CustomStackHeightWidget        {
            return this._widget = k;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.CUSTOM_STACK_HEIGHT;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._container.connection.addMessageEvent(new CustomStackingHeightUpdateMessageEvent(this._Str_23242));
return k;
        }

        function _Str_23242(k:CustomStackingHeightUpdateMessageEvent)
        {
            var _local_2= k.getParser();
            if (((this._widget != null) && this._Str_6826()))
            {
                this._widget._Str_24760(_local_2.furniId, _local_2.height);
            }
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
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
            return [];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineTriggerWidgetEvent = null;
            var _local_3:IRoomObject = null;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.OPEN_WIDGET:
                    _local_2 = Std.downcast(k , RoomEngineTriggerWidgetEvent);
                    if (((!(k == null)) && (!(this._container.roomEngine == null))))
                    {
                        this._lastFurniId = _local_2.objectId;
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        if (((_local_3 != null) && this._Str_6826(_local_3)))
                        {
                            if (this._widget != null)
                            {
                                this._widget.open(this._lastFurniId, _local_3.getLocation().z);
                            }
                        }
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    _local_2 = Std.downcast(k , RoomEngineTriggerWidgetEvent);
                    if ((((!(k == null)) && (!(this._container.roomEngine == null))) && (!(this._widget == null))))
                    {
                        if (this._lastFurniId == _local_2.objectId)
                        {
                            this._widget.hide();
                        }
                    }
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            this._container = null;
            this._widget = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }

        function _Str_6826(k:IRoomObject=null):Bool
        {
            var _local_2= this._container.roomSession.isRoomOwner;
            var _local_3:ASAny = (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST);
            var _local_4= this._container.sessionDataManager.isAnyRoomController;
            var _local_5= ((k != null) && this._container.isOwnerOfFurniture(k));
            return ((_local_2 || _local_4) || ASCompat.toBool(_local_3)) || _local_5;
        }
public function new(){}
    }

