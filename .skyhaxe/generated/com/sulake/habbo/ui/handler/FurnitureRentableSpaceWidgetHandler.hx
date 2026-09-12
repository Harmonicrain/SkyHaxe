package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.rentablespace.RentableSpaceDisplayWidget;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RentableSpaceStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RentableSpaceRentOkMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.furniture.RentableSpaceRentFailedMessageEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RentableSpaceStatusMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RentableSpaceCancelRentMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.room.furniture.RentableSpaceRentMessageComposer;

     class FurnitureRentableSpaceWidgetHandler implements IRoomWidgetHandler 
    {
        var _container:IRoomWidgetHandlerContainer;
        var _widget:RentableSpaceDisplayWidget;
        var _rentableSpaceStatusMessageEvent:RentableSpaceStatusMessageEvent;
        var _rentableSpaceRentOkMessageEvent:RentableSpaceRentOkMessageEvent;
        var _rentableSpaceRentFailedMessageEvent:RentableSpaceRentFailedMessageEvent;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.RENTABLESPACE;
        }

        public var widget(never,set):RentableSpaceDisplayWidget;
public function  set_widget(k:RentableSpaceDisplayWidget):RentableSpaceDisplayWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            this._container = k;
            this._rentableSpaceStatusMessageEvent = new RentableSpaceStatusMessageEvent(this._Str_24112);
            this._container.connection.addMessageEvent(this._rentableSpaceStatusMessageEvent);
            this._rentableSpaceRentOkMessageEvent = new RentableSpaceRentOkMessageEvent(this.onRentableSpaceRentOkMessage);
            this._container.connection.addMessageEvent(this._rentableSpaceRentOkMessageEvent);
            this._rentableSpaceRentFailedMessageEvent = new RentableSpaceRentFailedMessageEvent(this._Str_22780);
            this._container.connection.addMessageEvent(this._rentableSpaceRentFailedMessageEvent);
return k;
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
            if (this._container.roomEngine == null)
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
                    if (_local_3 != null)
                    {
                        this._widget.show(_local_3);
                    }
                    return;
                case RoomEngineTriggerWidgetEvent.CLOSE_WIDGET:
                    this._widget.hide(_local_3);
                    return;
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._rentableSpaceStatusMessageEvent != null)
            {
                this._container.connection.removeMessageEvent(this._rentableSpaceStatusMessageEvent);
                this._rentableSpaceStatusMessageEvent = null;
            }
            if (this._rentableSpaceRentOkMessageEvent != null)
            {
                this._container.connection.removeMessageEvent(this._rentableSpaceRentOkMessageEvent);
                this._rentableSpaceRentOkMessageEvent = null;
            }
            if (this._rentableSpaceRentFailedMessageEvent != null)
            {
                this._container.connection.removeMessageEvent(this._rentableSpaceRentFailedMessageEvent);
                this._rentableSpaceRentFailedMessageEvent = null;
            }
            this._container = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._container == null;
        }

        public function onRentableSpaceRentOkMessage(k:RentableSpaceRentOkMessageEvent)
        {
            this._widget.updateWidgetState();
        }

        public function _Str_22780(k:RentableSpaceRentFailedMessageEvent)
        {
            var _local_2= k.getParser();
            this._widget._Str_23970(_local_2.reason);
        }

        public function _Str_24112(k:RentableSpaceStatusMessageEvent)
        {
            var _local_2= k.getParser();
            this._widget._Str_23885(_local_2._Str_22736, _local_2._Str_23603, _local_2._Str_25070, _local_2.renterId, _local_2._Str_23275, _local_2._Str_24083, _local_2.price);
        }

        public function getRentableSpaceStatus(k:Int)
        {
            this._container.connection.send(new RentableSpaceStatusMessageComposer(k));
        }

        public function cancelRent(k:Int)
        {
            this._container.connection.send(new RentableSpaceCancelRentMessageComposer(k));
        }

        public function rentSpace(k:Int)
        {
            this._container.connection.send(new RentableSpaceRentMessageComposer(k));
        }

        public function _Str_26430():Int
        {
            return this._container.sessionDataManager.clubLevel;
        }

        public function _Str_23322():Int
        {
            return this._container.catalog.getPurse().credits;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function new(){}
    }

