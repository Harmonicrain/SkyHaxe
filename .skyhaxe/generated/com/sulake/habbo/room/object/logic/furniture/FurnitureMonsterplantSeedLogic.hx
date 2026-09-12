package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.ContextMenuEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.events.RoomObjectEvent;

     class FurnitureMonsterplantSeedLogic extends FurnitureMultistateLogic 
    {


        override public function  get_contextMenu():String
        {
            return ContextMenuEnum.MONSTERPLANT_SEED;
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG]);
        }

        override public function useObject()
        {
            var k:RoomObjectEvent = null;
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.MONSTERPLANT_SEED_PLANT_CONFIRMATION_DIALOG, object);
                eventDispatcher.dispatchEvent(k);
            }
        }

	public function new() { super(); }
    }

