package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureWindowLogic extends FurnitureMultistateLogic 
    {


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:com.sulake.core.utils.xml.XML;
            var _local_4:String;
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("mask");
            if (_local_2.length() > 0)
            {
                _local_3 = _local_2.at(0);
                if (XMLValidator.checkRequiredAttributes(_local_3, ["type"]))
                {
                    _local_4 = _local_3.attribute("type").toString();
                    object.getModelController().setNumber(RoomObjectVariableEnum.FURNITURE_USES_PLANE_MASK, 1, true);
                    object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_PLANE_MASK_TYPE, _local_4, true);
                }
            }
        }

	public function new() { super(); }
    }

