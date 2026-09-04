package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class FurnitureChestLogic extends FurnitureLogic
    {
        static inline final IS_WIRED_ENABLED_KEY= "is_wired_enabled";

        var _isWiredEnabled:Bool = false;

        override public function processUpdateMessage(message:RoomObjectUpdateMessage)
        {
            super.processUpdateMessage(message);

            var dataUpdate= Std.downcast(message , RoomObjectDataUpdateMessage);
            if (dataUpdate == null)
            {
                return;
            }

            var mapData= Std.downcast(dataUpdate.data , MapStuffData);
            if (mapData == null)
            {
                return;
            }

            var isWiredEnabled= mapData.getValue(IS_WIRED_ENABLED_KEY) == "1";
            if (isWiredEnabled != this._isWiredEnabled)
            {
                this._isWiredEnabled = isWiredEnabled;
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_CHEST_IS_WIRED_ENABLED, isWiredEnabled ? 1 : 0);
                update(flash.Lib.getTimer());
            }
        }

	public function new() { super(); }
    }

