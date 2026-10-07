package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;

     class FurnitureGroupForumTerminalLogic extends FurnitureGuildCustomizedLogic 
    {


        override function openContextMenu()
        {
        }

        override function updateGuildId(k:String)
        {
            super.updateGuildId(k);
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_INTERNAL_LINK, ("groupforum/" + k));
        }

        override public function useObject()
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.INERNAL_LINK, object));
            }
            super.useObject();
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.INERNAL_LINK]);
        }

	public function new() { super(); }
    }

