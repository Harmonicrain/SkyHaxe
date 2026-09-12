package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureCustomStackHeightLogic extends FurnitureMultistateLogic 
    {


        override public function  get_widget():String
        {
            return RoomWidgetEnum.CUSTOM_STACK_HEIGHT;
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            if (((!(object == null)) && (!(object.getModelController() == null))))
            {
                object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_ALWAYS_STACKABLE, 1);
            }
        }

	public function new() { super(); }
    }

