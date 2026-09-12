package com.sulake.habbo.roomevents.wired_setup.conditions.chests
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

    /** July condition 46: count selected item types in selected furni chests. */
     class ChestHasItemTypesConditionElement extends ChestHasAmountConditionElement
    {
        override public function  get_code():Int { return ConditionCodes.CHEST_HAS_ITEM_TYPES; }
        override public function furniSelectionTitle(index:Int):String
        {
            return index == 0 ? "wiredfurni.params.sources.furni.title.item_types" :
                "wiredfurni.params.sources.furni.title.chests";
        }
        override public function mergedSelections():Array<ASAny> { return [([2, 0] : Array<Dynamic>)]; }

	public function new() { super(); }
    }

