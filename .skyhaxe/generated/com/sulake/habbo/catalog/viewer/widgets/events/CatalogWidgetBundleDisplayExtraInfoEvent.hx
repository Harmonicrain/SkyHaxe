package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;

     class CatalogWidgetBundleDisplayExtraInfoEvent extends Event 
    {
        public static inline final CWPPEIE_RESET= "CWPPEIE_RESET";
        public static inline final CWPPEIE_HIDE= "CWPPEIE_HIDE";
        public static inline final CWPPEIE_ITEM_CLICKED= "CWPPEIE_ITEM_CLICKED";

        var _id:Int = 0;
        var _data:ExtraInfoItemData;

        public function new(k:String, _arg_2:ExtraInfoItemData=null, _arg_3:Int=-1)
        {
            super(k);
            this._id = _arg_3;
            this._data = _arg_2;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var data(get,never):ExtraInfoItemData;
public function  get_data():ExtraInfoItemData
        {
            return this._data;
        }
    }

