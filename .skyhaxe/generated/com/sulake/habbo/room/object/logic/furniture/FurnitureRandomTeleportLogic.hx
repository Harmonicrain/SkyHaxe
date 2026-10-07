package com.sulake.habbo.room.object.logic.furniture
;
    import com.sulake.habbo.ui.widget.enums.ContextMenuEnum;

     class FurnitureRandomTeleportLogic extends FurnitureMultistateLogic 
    {


        override public function  get_contextMenu():String
        {
            return ContextMenuEnum.RANDOM_TELEPORT;
        }

	public function new() { super(); }
    }

