package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectStateChangedEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureCounterClockLogic extends FurnitureLogic 
    {


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectStateChangedEvent.STATE_CHANGE];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
            var _local_3:RoomObjectEvent = null;
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
                    switch (k.spriteTag)
                    {
                        case "start_stop":
                            _local_3 = new RoomObjectStateChangedEvent(RoomObjectStateChangedEvent.STATE_CHANGE, object, 1);
                            
                        case "reset":
                            _local_3 = new RoomObjectStateChangedEvent(RoomObjectStateChangedEvent.STATE_CHANGE, object, 2);
                            
                    }
                    if (((!(eventDispatcher == null)) && (!(_local_3 == null))))
                    {
                        eventDispatcher.dispatchEvent(_local_3);
                        return;
                    }
                    
            }
            super.mouseEvent(k, _arg_2);
        }

        override public function useObject()
        {
            var k:RoomObjectEvent;
            if (object != null)
            {
                k = new RoomObjectStateChangedEvent(RoomObjectStateChangedEvent.STATE_CHANGE, object, 1);
                if (eventDispatcher != null)
                {
                    eventDispatcher.dispatchEvent(k);
                }
            }
        }

	public function new() { super(); }
    }

