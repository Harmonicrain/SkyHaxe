package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay
;
	import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
	import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;

     class UpdateableExtraInfoListItem extends ExtraInfoListItem 
    {
        public function new(k:BundlePurchaseExtraInfoCatalogWidget, _arg_2:Int, _arg_3:ExtraInfoItemData, _arg_4:Int=0, _arg_5:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        public function update(k:ExtraInfoItemData)
        {
            data = k;
        }
    }

