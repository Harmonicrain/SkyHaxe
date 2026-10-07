package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.events.RoomObjectDataRequestEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureYoutubeLogic extends FurnitureLogic 
    {


        override public function  get_widget():String
        {
            return RoomWidgetEnum.YOUTUBE;
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectDataRequestEvent.RODRE_URL_PREFIX]);
        }

        override public function update(k:Int)
        {
            super.update(k);
            if (!object.getModel().hasString(RoomObjectVariableEnum.SESSION_URL_PREFIX))
            {
                eventDispatcher.dispatchEvent(new RoomObjectDataRequestEvent(RoomObjectDataRequestEvent.RODRE_URL_PREFIX, object));
            }
        }

	public function new() { super(); }
    }

