package com.sulake.habbo.inventory.items
;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.data.StuffDataBase;
    import com.sulake.habbo.inventory.furni.FurniModel;
    import com.sulake.habbo.room.IRoomEngine;

     class CreditTradingItem extends GroupItem 
    {
        static inline final INVENTORY_THUMB_CREDITS_XML= "inventory_thumb_credits_xml";

        var _creditValue:Int = 0;
        var _assets:IAssetLibrary;

        public function new(k:FurniModel, _arg_2:IAssetLibrary, _arg_3:IRoomEngine, _arg_4:Int)
        {
            var _local_5:BitmapData = null;
            this._creditValue = _arg_4;
            this._assets = _arg_2;
            _local_5 = this._Str_21010();
            super(k, type, category, _arg_3, false, new StuffDataBase(), extra, _local_5, false, "center");
        }

        override public function dispose()
        {
            this._assets = null;
            super.dispose();
        }

        public function _Str_21010():BitmapData
        {
            if (this._assets == null)
            {
                return null;
            }
            var k= this._assets.getAssetByName("inventory_furni_icon_credits");
            return (k != null) ? ASCompat.dynamicAs(k.content , BitmapData).clone() : null;
        }

        public function _Str_22574():String
        {
            return "${purse_coins}";
        }

        public function _Str_21960():Int
        {
            return this._creditValue;
        }

        override public function  get_isGroupable():Bool
        {
            return true;
        }

        override public function getTotalCount():Int
        {
            return this._Str_21960();
        }

        override public function getUnlockedCount():Int
        {
            return this._Str_21960();
        }

        override function createWindow()
        {
            _window = _model.createItemWindow(INVENTORY_THUMB_CREDITS_XML);
        }

        override public function getMinimumItemsToShowCounter():Int
        {
            return 1;
        }
    }

