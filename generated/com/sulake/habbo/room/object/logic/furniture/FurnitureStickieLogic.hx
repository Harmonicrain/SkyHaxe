package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.events.RoomObjectFurnitureActionEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectItemDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;

     class FurnitureStickieLogic extends FurnitureLogic 
    {


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.STICKIE, RoomObjectFurnitureActionEvent.STICKIE];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            this.setColorIndexFromItemData();
            if (object != null)
            {
                object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_IS_STICKIE, "");
            }
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_2:RoomObjectWidgetRequestEvent;
            super.processUpdateMessage(k);
            if (Std.is(k , RoomObjectItemDataUpdateMessage))
            {
                _local_2 = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.STICKIE, object);
                if (_local_2 != null)
                {
                    eventDispatcher.dispatchEvent(_local_2);
                }
            }
            this.setColorIndexFromItemData();
        }

        function setColorIndexFromItemData()
        {
            var k:String;
            var _local_2:Array<ASAny>;
            var _local_3:Int;
            if (object != null)
            {
                k = object.getModel().getString(RoomObjectVariableEnum.FURNITURE_DATA);
                _local_2 = ["9CCEFF", "FF9CFF", "9CFF9C", "FFFF33"];
                _local_3 = _local_2.indexOf(k);
                if (_local_3 < 0)
                {
                    _local_3 = 3;
                }
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_COLOR, (_local_3 + 1));
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
                k = new RoomObjectFurnitureActionEvent(RoomObjectFurnitureActionEvent.STICKIE, object);
                eventDispatcher.dispatchEvent(k);
            }
        }

	public function new() { super(); }
    }

