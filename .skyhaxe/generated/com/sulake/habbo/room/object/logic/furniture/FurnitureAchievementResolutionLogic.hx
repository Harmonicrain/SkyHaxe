package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.events.RoomObjectBadgeAssetEvent;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureAchievementResolutionLogic extends FurnitureBadgeDisplayLogic 
    {
        public static inline final STATE_RESOLUTION_NOT_STARTED= 0;
        public static inline final STATE_RESOLUTION_IN_PROGRESS= 1;
        public static inline final STATE_RESOLUTION_ACHIEVED= 2;
        public static inline final STATE_RESOLUTION_FAILED= 3;
        static inline final ACH_NOT_SET= "ACH_0";
        static inline final BADGE_VISIBLE_IN_STATE:Float = 2;


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_OPEN, RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_ENGRAVING, RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_FAILED, RoomObjectBadgeAssetEvent.ROGBE_LOAD_BADGE];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_4:RoomObjectEvent = null;
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectGroupBadgeUpdateMessage);
            if (_local_2 != null)
            {
                if (_local_2.assetName != "loading_icon")
                {
                    object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_BADGE_VISIBLE_IN_STATE, BADGE_VISIBLE_IN_STATE);
                }
            }
            var _local_3= Std.downcast(k , RoomObjectSelectedMessage);
            if (_local_3 != null)
            {
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    if (!_local_3.selected)
                    {
                        _local_4 = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.CLOSE_FURNI_CONTEXT_MENU, object);
                        eventDispatcher.dispatchEvent(_local_4);
                    }
                }
            }
        }

        override public function useObject()
        {
            var k:RoomObjectEvent = null;
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                k = null;
                switch (object.getState(0))
                {
                    case STATE_RESOLUTION_NOT_STARTED
                       | STATE_RESOLUTION_IN_PROGRESS:
                        k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_OPEN, object);
                        
                    case STATE_RESOLUTION_ACHIEVED:
                        k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_ENGRAVING, object);
                        
                    case STATE_RESOLUTION_FAILED:
                        k = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.ACHIEVEMENT_RESOLUTION_FAILED, object);
                        
                }
                if (k != null)
                {
                    eventDispatcher.dispatchEvent(k);
                }
            }
        }

        override function updateBadge(k:String)
        {
            if (k != ACH_NOT_SET)
            {
                super.updateBadge(k);
            }
        }

	public function new() { super(); }
    }

