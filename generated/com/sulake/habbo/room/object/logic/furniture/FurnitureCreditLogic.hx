package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import com.sulake.room.events.RoomObjectEvent;

     class FurnitureCreditLogic extends FurnitureLogic 
    {


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.CREDITFURNI];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function dispose()
        {
            super.dispose();
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_4:IRoomObjectModelController;
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("credits");
            if (_local_2.length() == 0)
            {
                return;
            }
            var _local_3= ASCompat.toNumber(_local_2.at(0).attribute("value"));
            if (object != null)
            {
                _local_4 = object.getModelController();
                if (_local_4 != null)
                {
                    _local_4.setNumber(RoomObjectVariableEnum.FURNITURE_CREDIT_VALUE, _local_3);
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
                k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.CREDITFURNI, object);
                eventDispatcher.dispatchEvent(k);
            }
            super.useObject();
        }

	public function new() { super(); }
    }

