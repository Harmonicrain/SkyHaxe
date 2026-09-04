package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.events.RoomObjectHSLColorEnableEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.IntArrayStuffData;
    import com.sulake.room.events.RoomObjectEvent;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureRoomBackgroundColorLogic extends FurnitureMultistateLogic 
    {
        var _roomColorUpdated:Bool = false;


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.BACKGROUND_COLOR, RoomObjectHSLColorEnableEvent.ROHSLCEE_ROOM_BACKGROUND_COLOR];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (((!(_local_2 == null)) && (!(_local_2.data == null))))
            {
                _local_2.data.writeRoomObjectModel(object.getModelController());
                if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)
                {
                    this.setupObject();
                }
            }
        }

        function setupObject()
        {
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            }
            var k= new IntArrayStuffData();
            k.initializeFromRoomObjectModel(object.getModel());
            var _local_2= k.getValue(0);
            var _local_3= k.getValue(1);
            var _local_4= k.getValue(2);
            var _local_5= k.getValue(3);
            if (((((_local_2 > -1) && (_local_3 > -1)) && (_local_4 > -1)) && (_local_5 > -1)))
            {
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_HUE, _local_3);
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_SATURATION, _local_4);
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ROOM_BACKGROUND_COLOR_LIGHTNESS, _local_5);
                object.setState(_local_2, 0);
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    eventDispatcher.dispatchEvent(new RoomObjectHSLColorEnableEvent(RoomObjectHSLColorEnableEvent.ROHSLCEE_ROOM_BACKGROUND_COLOR, object, ASCompat.toBool(_local_2), _local_3, _local_4, _local_5));
                }
                this._roomColorUpdated = true;
            }
        }

        override public function dispose()
        {
            if (this._roomColorUpdated)
            {
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)
                    {
                        eventDispatcher.dispatchEvent(new RoomObjectHSLColorEnableEvent(RoomObjectHSLColorEnableEvent.ROHSLCEE_ROOM_BACKGROUND_COLOR, object, false, 0, 0, 0));
                    }
                }
                this._roomColorUpdated = false;
            }
            super.dispose();
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            var _local_3:RoomObjectEvent;
            if (((k == null) || (_arg_2 == null)))
            {
                return;
            }
            if (object == null)
            {
                return;
            }
            switch (k.type)
            {
                case MouseEvent.DOUBLE_CLICK:
                    if (((!(eventDispatcher == null)) && (!(object == null))))
                    {
                        _local_3 = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.BACKGROUND_COLOR, object);
                        eventDispatcher.dispatchEvent(_local_3);
                    }
                    return;
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

	public function new() { super(); }
    }

