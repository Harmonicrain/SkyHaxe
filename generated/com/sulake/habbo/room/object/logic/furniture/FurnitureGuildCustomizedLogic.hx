package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.events.RoomObjectBadgeAssetEvent;
    import com.sulake.habbo.room.events.RoomObjectWidgetRequestEvent;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectGroupBadgeUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.messages.RoomObjectSelectedMessage;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.events.MouseEvent;
    import com.sulake.room.events.RoomSpriteMouseEvent;
    import com.sulake.room.utils.IRoomGeometry;

     class FurnitureGuildCustomizedLogic extends FurnitureMultistateLogic 
    {
        public static inline final GUILD_ID_STUFFDATA_KEY= 1;
        public static inline final BADGE_CODE_STUFFDATA_KEY= 2;
        public static inline final COLOR_1_STUFFDATA_KEY= 3;
        public static inline final COLOR_2_STUFFDATA_KEY= 4;


        override public function getEventTypes():Array<ASAny>
        {
            var k:Array<ASAny> = [RoomObjectBadgeAssetEvent.ROGBE_LOAD_BADGE, RoomObjectWidgetRequestEvent.GUILD_FURNI_CONTEXT_MENU, RoomObjectWidgetRequestEvent.CLOSE_FURNI_CONTEXT_MENU];
            return getAllEventTypes(super.getEventTypes(), k);
        }

        override public function processUpdateMessage(k:RoomObjectUpdateMessage)
        {
            var _local_5:StringArrayStuffData;
            var _local_6:RoomObjectEvent;
            super.processUpdateMessage(k);
            var _local_2= Std.downcast(k , RoomObjectDataUpdateMessage);
            if (_local_2 != null)
            {
                _local_5 = Std.downcast(_local_2.data , StringArrayStuffData);
                if (_local_5 != null)
                {
                    this.updateGuildId(_local_5.getValue(GUILD_ID_STUFFDATA_KEY));
                    this.updateGuildBadge(_local_5.getValue(BADGE_CODE_STUFFDATA_KEY));
                    this.updateGuildColors(_local_5.getValue(COLOR_1_STUFFDATA_KEY), _local_5.getValue(COLOR_2_STUFFDATA_KEY));
                }
            }
            var _local_3= Std.downcast(k , RoomObjectGroupBadgeUpdateMessage);
            if (_local_3 != null)
            {
                if (_local_3.assetName != "loading_icon")
                {
                    object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_ASSET_NAME, _local_3.assetName);
                    this.update(flash.Lib.getTimer());
                }
            }
            var _local_4= Std.downcast(k , RoomObjectSelectedMessage);
            if (_local_4 != null)
            {
                if (((!(eventDispatcher == null)) && (!(object == null))))
                {
                    if (!_local_4.selected)
                    {
                        _local_6 = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.CLOSE_FURNI_CONTEXT_MENU, object);
                        eventDispatcher.dispatchEvent(_local_6);
                    }
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
                case MouseEvent.CLICK:
                    this.openContextMenu();
                    super.mouseEvent(k, _arg_2);
                    
                default:
                    super.mouseEvent(k, _arg_2);
            }
        }

        function openContextMenu()
        {
            var k:RoomObjectEvent = new RoomObjectWidgetRequestEvent(RoomObjectWidgetRequestEvent.GUILD_FURNI_CONTEXT_MENU, object);
            eventDispatcher.dispatchEvent(k);
        }

        function updateGuildColors(k:String, _arg_2:String)
        {
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_COLOR_1, ASCompat.parseInt(k, 16));
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_COLOR_2, ASCompat.parseInt(_arg_2, 16));
        }

        function updateGuildBadge(k:String)
        {
            eventDispatcher.dispatchEvent(new RoomObjectBadgeAssetEvent(RoomObjectBadgeAssetEvent.ROGBE_LOAD_BADGE, object, k, true));
        }

        function updateGuildId(k:String)
        {
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_GUILD_CUSTOMIZED_GUILD_ID, ASCompat.parseInt(k));
        }

	public function new() { super(); }
    }

