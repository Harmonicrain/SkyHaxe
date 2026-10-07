package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.FriendFurniEngravingWidgetTypeEnum;

     class FurnitureHweenLovelockLogic extends FurnitureFriendFurniLogic 
    {


        override function  get_engravingDialogType():Int
        {
            return FriendFurniEngravingWidgetTypeEnum.HABBOWEEN;
        }

	public function new() { super(); }
    }

