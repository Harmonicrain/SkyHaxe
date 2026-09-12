package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

     class FurnitureEditableRoomLinkLogic extends FurnitureLogic 
    {


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("action");
            if (_local_2.length() != 0)
            {
                object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_INTERNAL_LINK, _local_2.attribute("link").toString());
            }
        }

        public function _Str_6210(k:Int)
        {
            if (object == null)
            {
                return;
            }
            var _local_2= object.getModelController();
            if (_local_2 != null)
            {
                _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_AUTOMATIC_STATE_INDEX, k, false);
            }
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.ROOM_LINK]);
        }

        override public function useObject()
        {
            this._Str_6210(1);
            var k= new Timer(2500);
            k.addEventListener(TimerEvent.TIMER, (this._Str_24963 : ASAny));
            k.start();
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.ROOM_LINK, object));
            }
        }

        function _Str_24963(k:TimerEvent)
        {
            this._Str_6210(0);
        }

	public function new() { super(); }
    }

