package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;

     class FurnitureMannequinLogic extends FurnitureLogic 
    {
        static inline final GENDER= "GENDER";
        static inline final FIGURE= "FIGURE";
        static inline final OUTFIT_NAME= "OUTFIT_NAME";


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.MANNEQUIN];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (((!(_local_2 == null)) && (!(_local_2.data == null))))
            {
                _local_2.data.writeRoomObjectModel(object.getModelController());
                this._Str_16576();
            }
        }

        function _Str_16576()
        {
            if (((object == null) || (object.getModelController() == null)))
            {
                return;
            }
            var k= new MapStuffData();
            k.initializeFromRoomObjectModel(object.getModel());
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_GENDER, k.getValue(GENDER));
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_FIGURE, k.getValue(FIGURE));
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_MANNEQUIN_NAME, k.getValue(OUTFIT_NAME));
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
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
                    this.useObject();
                    return;
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

        override public function useObject()
        {
            var k:RoomObjectEvent = null;
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.MANNEQUIN, object);
                eventDispatcher.dispatchEvent(k);
            }
        }

	public function new() { super(); }
    }

