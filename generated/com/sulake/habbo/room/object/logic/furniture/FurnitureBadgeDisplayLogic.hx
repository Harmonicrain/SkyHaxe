package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectBadgeAssetEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureBadgeDisplayLogic extends FurnitureLogic 
    {


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectBadgeAssetEvent.ROGBE_LOAD_BADGE, RoomObjectWidgetRequestEvent.BADGE_DISPLAY_ENGRAVING];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_4:StringArrayStuffData;
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                _local_4 = Std.downcast(_local_2.data , StringArrayStuffData);
                if (_local_4 != null)
                {
                    this.updateBadge(_local_4.getValue(1));
                }
            }
            var _local_3= Std.downcast(k , RoomObjectGroupBadgeUpdateMessage);
            if (_local_3 != null)
            {
                if (_local_3.assetName != "loading_icon")
                {
                    object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_BADGE_ASSET_NAME, _local_3.assetName);
                    object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_BADGE_IMAGE_STATUS, 1);
                    this.update(flash.Lib.getTimer());
                }
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
                    this.useObject();
                    return;
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

        override public function useObject()
        {
            if (((!(eventDispatcher == null)) && (!(object == null))))
            {
                eventDispatcher.dispatchEvent(new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.BADGE_DISPLAY_ENGRAVING, object));
            }
        }

        function updateBadge(k:String)
        {
            if (k != "")
            {
                eventDispatcher.dispatchEvent(new RoomObjectBadgeAssetEvent(RoomObjectBadgeAssetEvent.ROGBE_LOAD_BADGE, object, k, false));
            }
        }

	public function new() { super(); }
    }

