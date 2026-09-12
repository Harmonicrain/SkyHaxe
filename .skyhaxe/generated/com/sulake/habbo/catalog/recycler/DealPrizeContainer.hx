package com.sulake.habbo.catalog.recycler
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.incoming.recycler._Str_6068;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.geom.Point;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.room.IRoomEngine;

     class DealPrizeContainer extends _Str_3903 
    {
        var _Str_7699:Array<ASAny>;
        var _Str_16536:Array<ASAny>;
        var _habboCatalog__com_sulake_habbo_catalog_recycler_DealPrizeContainer/*redefined private*/:HabboCatalog;
        var _Str_3370:com.sulake.core.utils.xml.XML;
        var _Str_5577:BitmapData;

        public function new(k:Array<ASAny>, _arg_2:Int, _arg_3:HabboCatalog)
        {
            var _local_4 = 0;
            var _local_7:_Str_6068 = null;
            var _local_8:IFurnitureData = null;
            this._Str_16536 = [];
            this._habboCatalog__com_sulake_habbo_catalog_recycler_DealPrizeContainer = _arg_3;
            this._Str_7699 = k;
            while (_local_4 < k.length)
            {
                _local_7 = k[_local_4];
                _local_8 = _arg_3.getFurnitureData(_local_7._Str_6270, _local_7._Str_7585);
                this._Str_16536.push(_local_8);
                _local_4++;
            }
            var _local_5= Std.downcast(_arg_3.assets.getAssetByName("gridItem") , XmlAsset);
            this._Str_3370 = ((_local_5.content : com.sulake.core.utils.xml.XML) );
            var _local_6= Std.downcast(_arg_3.assets.getAssetByName("ctlg_pic_deal_icon_narrow") , BitmapDataAsset);
            this._Str_5577 = cast(_local_6.content, BitmapData);
            super("deal", -1, null, _arg_2, _arg_3);
        }

        override public function setIcon(k:IRoomEngine)
        {
            var _local_2= cast(view.findChildByName("image"), IBitmapWrapperWindow);
            _local_2.bitmap = new BitmapData(_local_2.width, _local_2.height, true, 0);
            _local_2.bitmap.copyPixels(this._Str_5577, this._Str_5577.rect, new Point(((_local_2.width - this._Str_5577.width) / 2), ((_local_2.height - this._Str_5577.height) / 2)));
            cast(view.findChildByName("bundleCounter"), ITextWindow).text = Std.string(this._Str_7699.length);
        }

        override public function  get_title():String
        {
            return "";
        }

        public var _Str_9475(get,never):Array<ASAny>;
public function  get__Str_9475():Array<ASAny>
        {
            return this._Str_7699;
        }

        public var _Str_26087(get,never):Array<ASAny>;
public function  get__Str_26087():Array<ASAny>
        {
            return this._Str_16536;
        }
    }

