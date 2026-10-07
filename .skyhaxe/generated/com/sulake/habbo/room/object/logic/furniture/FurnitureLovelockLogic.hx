package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.FriendFurniEngravingWidgetTypeEnum;

     class FurnitureLovelockLogic extends FurnitureFriendFurniLogic 
    {


        override function  get_engravingDialogType():Int
        {
            return FriendFurniEngravingWidgetTypeEnum.LOVE_LOCK;
        }

	public function new() { super(); }
    }

