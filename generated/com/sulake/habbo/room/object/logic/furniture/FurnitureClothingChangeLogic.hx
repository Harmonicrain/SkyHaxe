package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;

     class FurnitureClothingChangeLogic extends FurnitureLogic 
    {


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.CLOTHING_CHANGE];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (((object == null) || (object.getModel() == null)))
            {
                return;
            }
            var _local_2= object.getModel().getString(RoomObjectVariableEnum.FURNITURE_DATA);
            this.updateClothingData(_local_2);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_3:IStuffData;
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                _local_3 = _local_2.data;
                if (_local_3 != null)
                {
                    this.updateClothingData(_local_3.getLegacyString());
                }
            }
        }

        function updateClothingData(k:String)
        {
            var _local_2:Array<ASAny>;
            if (((!(k == null)) && (k.length > 0)))
            {
                _local_2 = (cast k.split(","));
                if (_local_2.length > 0)
                {
                    object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_CLOTHING_BOY, _local_2[0]);
                }
                if (_local_2.length > 1)
                {
                    object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_CLOTHING_GIRL, _local_2[1]);
                }
            }
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
            var k:RoomObjectEvent;
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.CLOTHING_CHANGE, object);
                eventDispatcher.dispatchEvent(k);
            }
        }

	public function new() { super(); }
    }

