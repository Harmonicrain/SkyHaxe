package com.sulake.habbo.catalog.recycler
;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;

     class _Str_3903 extends PrizeItemContainer 
    {
        var _Str_6780:String;
        var _Str_6222:Int = 0;
        var _Str_21793:Int = 0;
        var _furnitureData:IFurnitureData;
        var _gridItem:PrizeItemContainer;

        public function new(k:String, _arg_2:Int, _arg_3:IFurnitureData, _arg_4:Int, _arg_5:HabboCatalog)
        {
            super(_arg_5);
            this._Str_6780 = k;
            this._Str_6222 = _arg_2;
            this._furnitureData = _arg_3;
            this._Str_21793 = _arg_4;
        }

        public function setIcon(k:IRoomEngine)
        {
            if (((k == null) || (this._furnitureData == null)))
            {
                return;
            }
            initProductIcon(k, this._furnitureData.type, this._Str_6222);
        }

        public var _Str_7585(get,never):String;
public function  get__Str_7585():String
        {
            return this._Str_6780;
        }

        public var _Str_6270(get,never):Int;
public function  get__Str_6270():Int
        {
            return this._Str_6222;
        }

        public var gridItem(get,never):PrizeItemContainer;
public function  get_gridItem():PrizeItemContainer
        {
            return this._gridItem;
        }

        public var _Str_21913(get,never):Int;
public function  get__Str_21913():Int
        {
            return this._Str_21793;
        }

        public var title(get,never):String;
public function  get_title():String
        {
            if (this._furnitureData == null)
            {
                return "";
            }
            return this._furnitureData.localizedName;
        }
    }

