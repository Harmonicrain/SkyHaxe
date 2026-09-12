package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;

     class FurnitureVimeoLogic extends FurnitureLogic 
    {


        override public function  get_widget():String
        {
            return RoomWidgetEnum.VIMEO;
        }

	public function new() { super(); }
    }

