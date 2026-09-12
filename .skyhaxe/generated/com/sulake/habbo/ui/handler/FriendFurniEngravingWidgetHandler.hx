package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.furniture.friendfurni.FriendFurniEngravingWidget;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.events.RoomEngineTriggerWidgetEvent;
    import com.sulake.habbo.room.events.RoomEngineObjectEvent;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.Event;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;

     class FriendFurniEngravingWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _widget:FriendFurniEngravingWidget = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FRIEND_FURNI_ENGRAVING;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public var widget(never,set):FriendFurniEngravingWidget;
public function  set_widget(k:FriendFurniEngravingWidget):FriendFurniEngravingWidget        {
            return this._widget = k;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
            this._widget = null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomEngineTriggerWidgetEvent.RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomEngineObjectEvent = null;
            var _local_3:IRoomObject = null;
            var _local_4:IRoomObjectModel = null;
            var _local_5:StringArrayStuffData = null;
            if ((this.disposed || (k == null)))
            {
                return;
            }
            switch (k.type)
            {
                case RoomEngineTriggerWidgetEvent.RETWE_REQUEST_FRIEND_FURNITURE_ENGRAVING:
                    _local_2 = cast(k, RoomEngineObjectEvent);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.objectId, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_4 = _local_3.getModel();
                        if (_local_4 != null)
                        {
                            _local_5 = new StringArrayStuffData();
                            _local_5.initializeFromRoomObjectModel(_local_4);
                            this._widget.open(_local_3.getId(), Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_FRIENDFURNI_ENGRAVING_TYPE)), _local_5);
                        }
                    }
                    return;
            }
        }

        public function update()
        {
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }
public function new(){}
    }

