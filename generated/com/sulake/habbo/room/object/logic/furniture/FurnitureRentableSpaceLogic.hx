package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.events.RoomObjectDataRequestEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureRentableSpaceLogic extends FurnitureLogic 
    {


        override function  get_widget():String
        {
            return RoomWidgetEnum.RENTABLESPACE;
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectDataRequestEvent.RODRE_CURRENT_USER_ID]);
        }

        override public function update(k:Int)
        {
            super.update(k);
            if (!object.getModel().hasNumber(RoomObjectVariableEnum.SESSION_CURRENT_USER_ID))
            {
                eventDispatcher.dispatchEvent(new RoomObjectDataRequestEvent(RoomObjectDataRequestEvent.RODRE_CURRENT_USER_ID, object));
            }
            var _local_2= object.getModel();
            var _local_3:String = _local_2.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA).getValue("renterId");
            var _local_4= _local_2.getNumber(RoomObjectVariableEnum.SESSION_CURRENT_USER_ID);
            if (_local_3 != null)
            {
                if (ASCompat.toNumber(_local_3) == _local_4)
                {
                    object.setState(2, 0);
                }
                else
                {
                    object.setState(1, 0);
                }
            }
            else
            {
                object.setState(0, 0);
            }
        }

	public function new() { super(); }
    }

