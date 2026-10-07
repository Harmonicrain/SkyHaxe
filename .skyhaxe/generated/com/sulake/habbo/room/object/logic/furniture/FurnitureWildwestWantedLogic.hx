package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.FriendFurniEngravingWidgetTypeEnum;

     class FurnitureWildwestWantedLogic extends FurnitureFriendFurniLogic 
    {


        override function  get_engravingDialogType():Int
        {
            return FriendFurniEngravingWidgetTypeEnum.WILD_WEST_WANTED;
        }

	public function new() { super(); }
    }

