package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.ContextMenuEnum;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.room.events.RoomObjectEvent;

     class FurniturePurchasableClothingLogic extends FurnitureMultistateLogic 
    {


        override public function  get_contextMenu():String
        {
            return ContextMenuEnum.PURCHASABLE_CLOTHING;
        }

        override public function getEventTypes():Array<ASAny>
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectWidgetRequestEvent.PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG]);
        }

        override public function useObject()
        {
            var k:RoomObjectEvent = null;
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.PURCHASABLE_CLOTHING_CONFIRMATION_DIALOG, object);
                eventDispatcher.dispatchEvent(k);
            }
        }

	public function new() { super(); }
    }

