package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureHighScoreLogic extends FurnitureLogic 
    {
        static inline final SHOW_WIDGET_IN_STATE= 1;

        var _state:Int = -1;


        override public function getEventTypes():Array<ASAny>
        {
            return [RoomObjectWidgetRequestEvent.HIGH_SCORE_DISPLAY, RoomObjectWidgetRequestEvent.HIDE_HIGH_SCORE_DISPLAY];
        }

        override public function tearDown()
        {
            if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) == 1)
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.HIDE_HIGH_SCORE_DISPLAY, object));
            }
            super.tearDown();
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(k);
            if (object.getModelController().getNumber(RoomObjectVariableEnum.FURNITURE_REAL_ROOM_OBJECT) != 1)
            {
                return;
            }
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                if (_local_2.state == SHOW_WIDGET_IN_STATE)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.HIGH_SCORE_DISPLAY, object));
                }
                else
                {
                    eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.HIDE_HIGH_SCORE_DISPLAY, object));
                }
                this._state = _local_2.state;
                return;
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
                    useObject();
                    return;
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

	public function new() { super(); }
    }

