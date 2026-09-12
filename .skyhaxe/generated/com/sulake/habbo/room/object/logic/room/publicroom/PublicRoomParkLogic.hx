package com.sulake.habbo.room.object.logic.room.publicroom
;
    import com.sulake.habbo.room.events.RoomObjectRoomActionEvent;
    import com.sulake.habbo.room.object.logic.room.RoomLogic;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.events.MouseEvent;

     class PublicRoomParkLogic extends RoomLogic
    {
        static inline final BUS= "bus";
        static inline final BUS_OPEN= "bus_oviopen_hidden";
        static inline final GOAWAY_BUS= "goawaybus";

        public function new()
        {
            super();
        }

        override public function mouseEvent(k:RoomSpriteMouseEvent, _arg_2:IRoomGeometry)
        {
var _local_3:String  = null, _local_4:RoomObjectRoomActionEvent = null;            super.mouseEvent(k, _arg_2);
            if (((k == null) || (object == null)))
            {
                return;
            }
            if (k.type == MouseEvent.CLICK)
            {
_local_3= k.spriteTag;
_local_4;
                if (((_local_3 == BUS) || (_local_3 == BUS_OPEN)))
                {
                    _local_4 = new RoomObjectRoomActionEvent(RoomObjectRoomActionEvent.RORAE_TRY_BUS, object);
                }
                else if (_local_3 == GOAWAY_BUS)
                {
                    _local_4 = new RoomObjectRoomActionEvent(RoomObjectRoomActionEvent.RORAE_CHANGE_ROOM, object);
                }
                if (((!(_local_4 == null)) && (!(eventDispatcher == null))))
                {
                    eventDispatcher.dispatchEvent(_local_4);
                }
            }
        }
    }

