package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurniturePlanetSystemLogic extends FurnitureLogic 
    {


        override public function initialize(k:com.sulake.core.utils.xml.XML)
        {
            var _local_3:IRoomObjectModelController = null;
            super.initialize(k);
            if (k == null)
            {
                return;
            }
            var _local_2= k.child("planetsystem");
            if (_local_2.length() == 0)
            {
                return;
            }
            if (object != null)
            {
                _local_3 = object.getModelController();
                if (_local_3 != null)
                {
                    _local_3.setString(RoomObjectVariableEnum.FURNITURE_PLANETSYSTEM_DATA, _local_2.toString());
                }
            }
        }

	public function new() { super(); }
    }

