package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.room.events.RoomEngineAreaHideStateWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.ui.widget.furniture.areahide.AreaHideFurniWidget;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.session._enum.RoomControllerLevel;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import flash.events.Event;

     class FurnitureAreaHideWidgetHandler implements IRoomWidgetHandler
    {
        var _disposed:Bool = false;
        var _widget:AreaHideFurniWidget;
        var _container:IRoomWidgetHandlerContainer;

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.container = null;
                this._disposed = true;
            }
        }

        public var type(get,never):String;
public function  get_type():String { return RoomWidgetEnum.AREA_HIDE; }
        public var widget(never,set):AreaHideFurniWidget;
public function  set_widget(k:AreaHideFurniWidget):AreaHideFurniWidget{ return this._widget = k; }
                public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer { return this._container; }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer{ return this._container = k; }
        public function getWidgetMessages():Array<ASAny> { return null; }
        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent { return null; }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE, RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE];
        }

        public function processEvent(k:Event)
        {
var _local_5:RoomEngineAreaHideStateWidgetEvent  = null;            var _local_2:RoomEngineObjectEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_AREA_HIDE:
                    if (this.validateRights())
                    {
                        _local_2 = Std.downcast(k , RoomEngineObjectEvent);
                        _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                        if (_local_3 == null)
                        {
                            return;
                        }
                        _local_4 = _local_3.getModel();
                        this._widget.open(
                            _local_3.getId(),
                            ASCompat.toBool(_local_3.getState(0)),
                            Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_X)),
                            Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_ROOT_Y)),
                            Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WIDTH)),
                            Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_LENGTH)),
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVISIBILITY) == 1,
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_WALLITEMS) == 1,
                            _local_4.getNumber(RoomObjectVariableEnum.FURNITURE_AREA_HIDE_INVERT) == 1);
                    }
                    return;
                case RoomEngineAreaHideStateWidgetEvent.UPDATE_STATE_AREA_HIDE:
_local_5= Std.downcast(k , RoomEngineAreaHideStateWidgetEvent);
                    this._widget.updateStatus(_local_5.objectId, _local_5.isOn);
                    return;
            }
        }

        function validateRights():Bool
        {
            return this._container.roomSession.isRoomOwner ||
                this._container.roomSession.roomControllerLevel >= RoomControllerLevel.GUEST ||
                this._container.sessionDataManager.isAnyRoomController;
        }

        public function update()
        {
        }
public function new(){}
    }

