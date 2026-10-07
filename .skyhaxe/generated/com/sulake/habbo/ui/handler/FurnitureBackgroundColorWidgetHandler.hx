package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.widget.furniture.backgroundcolor.BackgroundColorFurniWidget;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.Event;
    import com.sulake.habbo.session._enum.RoomControllerLevel;

     class FurnitureBackgroundColorWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _widget:BackgroundColorFurniWidget;
        var _container:IRoomWidgetHandlerContainer;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function dispose()
        {
            if (!this._isDisposed)
            {
                this.container = null;
                this._isDisposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_BACKGROUND_COLOR;
        }

        public var widget(never,set):BackgroundColorFurniWidget;
public function  set_widget(k:BackgroundColorFurniWidget):BackgroundColorFurniWidget        {
            return this._widget = k;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
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
            var k:Array<ASAny> = [];
            k.push(RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BACKGROUND_COLOR);
            return k;
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineObjectEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_BACKGROUND_COLOR:
                    if (this._Str_6826())
                    {
                        _local_2 = Std.downcast(k , RoomEngineObjectEvent);
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        _local_4 = _local_3.getModel();
                        _local_5 = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_HUE));
                        _local_6 = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_SATURATION));
                        _local_7 = Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_LIGHTNESS));
                        this._widget.open(_local_3.getId(), _local_5, _local_6, _local_7);
                    }
                    return;
            }
        }

        function _Str_6826():Bool
        {
            var k= this._container.roomSession.isRoomOwner;
            var _local_2:ASAny = (this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST);
            var _local_3= this._container.sessionDataManager.isAnyRoomController;
            return (k || _local_3) || ASCompat.toBool(_local_2);
        }

        public function update()
        {
        }
public function new(){}
    }

