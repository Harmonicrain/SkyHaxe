package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetFurniToWidgetMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetStickieSendUpdateMessage;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.habbo.ui.widget.events.RoomWidgetStickieDataUpdateEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import flash.events.Event;

     class FurnitureStickieWidgetHandler implements IRoomWidgetHandler 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_STICKIE_WIDGET;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_STICKIE, RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_DELETE, RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_UPDATE];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetFurniToWidgetMessage = null;
            var _local_3:IRoomObject = null;
            var _local_4:RoomWidgetStickieSendUpdateMessage = null;
            var _local_5:RoomWidgetStickieSendUpdateMessage = null;
            var _local_6:IRoomObjectModel = null;
            var _local_7:String = null;
            var _local_8:String = null;
            var _local_9:String = null;
            var _local_10 = false;
            var _local_11:RoomWidgetStickieDataUpdateEvent = null;
            switch (k.type)
            {
                case RoomWidgetFurniToWidgetMessage.RWFWM_MESSAGE_REQUEST_STICKIE:
                    _local_2 = Std.downcast(k , RoomWidgetFurniToWidgetMessage);
                    _local_3 = this._container.roomEngine.getRoomObject(_local_2.roomId, _local_2.id, _local_2.category);
                    if (_local_3 != null)
                    {
                        _local_6 = _local_3.getModel();
                        if (_local_6 != null)
                        {
                            _local_7 = _local_6.getString(RoomObjectVariableEnum.FURNITURE_ITEMDATA);
                            if (_local_7.length < 6)
                            {
                                return null;
                            }
                            _local_9 = "";
                            if (_local_7.indexOf(" ") > 0)
                            {
                                _local_8 = _local_7.substring(0, _local_7.indexOf(" "));
                                _local_9 = _local_7.substring((_local_7.indexOf(" ") + 1), _local_7.length);
                            }
                            else
                            {
                                _local_8 = _local_7;
                            }
                            _local_10 = (this._container.roomSession.isRoomOwner || this._container.sessionDataManager.isAnyRoomController);
                            _local_11 = new RoomWidgetStickieDataUpdateEvent(RoomWidgetStickieDataUpdateEvent.RWSDUE_STICKIE_DATA, _local_2.id, _local_3.getType(), _local_9, _local_8, _local_10);
                            this._container.events.dispatchEvent(_local_11);
                        }
                    }
                    
                case RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_UPDATE:
                    _local_4 = Std.downcast(k , RoomWidgetStickieSendUpdateMessage);
                    if (_local_4 == null)
                    {
                        return null;
                    }
                    if (((!(this._container == null)) && (!(this._container.roomEngine == null))))
                    {
                        this._container.roomEngine.modifyRoomObjectData(_local_4.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM, _local_4.colorHex, _local_4.text);
                    }
                    
                case RoomWidgetStickieSendUpdateMessage.RWSUM_STICKIE_SEND_DELETE:
                    _local_5 = Std.downcast(k , RoomWidgetStickieSendUpdateMessage);
                    if (_local_5 == null)
                    {
                        return null;
                    }
                    if (((!(this._container == null)) && (!(this._container.roomEngine == null))))
                    {
                        this._container.roomEngine.deleteRoomObject(_local_5.objectId, RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM);
                    }
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [];
        }

        public function processEvent(k:Event)
        {
            var _local_2:Event = null;
        }

        public function update()
        {
        }
public function new(){}
    }

