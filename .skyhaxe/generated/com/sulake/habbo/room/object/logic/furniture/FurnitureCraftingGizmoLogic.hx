package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureCraftingGizmoLogic extends FurnitureLogic 
    {


        override public function  get_widget():String
        {
            return RoomWidgetEnum.CRAFTING;
        }

        override public function useObject()
        {
            super.useObject();
        }

        public function _Str_6210(k:Int)
        {
            if (object == null)
            {
                return;
            }
            var _local_2= object.getModelController();
            if (_local_2 != null)
            {
                _local_2.setNumber(RoomObjectVariableEnum.FURNITURE_AUTOMATIC_STATE_INDEX, k, false);
            }
        }

	public function new() { super(); }
    }

