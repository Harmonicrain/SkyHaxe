package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureMultiheightLogic extends FurnitureMultistateLogic 
    {


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            super.initialize(k);
            object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_IS_VARIABLE_HEIGHT, 1, true);
        }

	public function new() { super(); }
    }

