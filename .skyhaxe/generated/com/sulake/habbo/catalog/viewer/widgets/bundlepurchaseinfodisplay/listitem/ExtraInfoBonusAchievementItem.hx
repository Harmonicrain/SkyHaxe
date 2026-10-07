package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem
;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.core.window.IWindowContainer;

     class ExtraInfoBonusAchievementItem extends ExtraInfoListItem 
    {
        public function new(k:Int, _arg_2:ExtraInfoItemData)
        {
            super(null, k, _arg_2, ExtraInfoListItem.ALIGN_TOP);
        }

        override public function getRenderedWindow():IWindowContainer
        {
            return null;
        }
    }

