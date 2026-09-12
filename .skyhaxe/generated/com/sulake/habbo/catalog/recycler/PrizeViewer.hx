package com.sulake.habbo.catalog.recycler
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IItemGridWindow;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.communication.messages.incoming.recycler._Str_6068;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;

     class PrizeViewer implements IGetImageListener 
    {
        var _Str_3607:IBitmapWrapperWindow;
        var _Str_16965:Int = 0;
        var _Str_6872:Array<ASAny>;
        var _Str_3889:IItemGridWindow;


        static function _Str_12777(k:IWindowContainer, _arg_2:BitmapData):IBitmapWrapperWindow
        {
            var _local_3= cast(k.findChildByName("image"), IBitmapWrapperWindow);
            _local_3.bitmap = new BitmapData(_local_3.width, _local_3.height, true, 0xFFFFFF);
            _local_3.bitmap.copyPixels(_arg_2, _arg_2.rect, new Point(((_local_3.width - _arg_2.width) / 2), ((_local_3.height - _arg_2.height) / 2)));
            return _local_3;
        }


        public function dispose()
        {
            this._Str_6872 = null;
            this._Str_3607 = null;
        }

        public function _Str_25618(k:IRoomEngine, _arg_2:IWindowContainer, _arg_3:String, _arg_4:Int, _arg_5:String, _arg_6:String, _arg_7:String="")
        {
            var _local_9:ImageResult = null;
            this._Str_3607 = Std.downcast(_arg_2.findChildByName("ctlg_teaserimg_1") , IBitmapWrapperWindow);
            var _local_8= Std.downcast(_arg_2.findChildByName("bundleGrid") , IItemGridWindow);
            _local_8.visible = false;
            switch (_arg_3)
            {
                case ProductTypeEnum.FLOOR:
                    _local_9 = k.getFurnitureImage(_arg_4, new Vector3d(90, 0, 0), 64, this, 0, _arg_7);
                    
                case ProductTypeEnum.WALL:
                    _local_9 = k.getWallItemImage(_arg_4, new Vector3d(90, 0, 0), 64, this, 0, _arg_7);
                    
                default:
                    return;
            }
            if (_local_9 != null)
            {
                this._Str_3234(_local_9.data, true);
            }
            this._Str_16965 = _local_9.id;
            _arg_2.findChildByName("ctlg_product_name").caption = _arg_5;
            _arg_2.findChildByName("ctlg_description").caption = (ASCompat.stringAsBool(_arg_6) ? _arg_6 : "");
        }

        public function _Str_22540(k:IRoomEngine, _arg_2:ICatalogPage, _arg_3:com.sulake.core.utils.xml.XML, _arg_4:IWindowContainer, _arg_5:DealPrizeContainer, _arg_6:String, _arg_7:String)
        {
            var _local_11:_Str_6068 = null;
            var _local_12:IWindowContainer = null;
            var _local_13:ImageResult = null;
            this._Str_3607 = Std.downcast(_arg_4.findChildByName("ctlg_teaserimg_1") , IBitmapWrapperWindow);
            var _local_8= Std.downcast(_arg_2.viewer.catalog.assets.getAssetByName("ctlg_dyndeal_background") , BitmapDataAsset);
            var _local_9= cast(_local_8.content, BitmapData);
            this._Str_3607.bitmap = new BitmapData(this._Str_3607.width, this._Str_3607.height, true, 0xFFFFFF);
            this._Str_3607.bitmap.copyPixels(_local_9, _local_9.rect, new Point(((this._Str_3607.width - _local_9.width) / 2), ((this._Str_3607.height - _local_9.height) / 2)));
            this._Str_3889 = Std.downcast(_arg_4.findChildByName("bundleGrid") , IItemGridWindow);
            this._Str_3889.destroyGridItems();
            this._Str_3889.visible = true;
            this._Str_24244(_arg_5._Str_9475.length);
            var _local_10 = 0;
            while (_local_10 < _arg_5._Str_9475.length)
            {
                _local_11 = _arg_5._Str_9475[_local_10];
                _local_12 = cast(_arg_2.viewer.catalog.windowManager.buildFromXML(_arg_3), IWindowContainer);
                _local_12.findChildByName("clubLevelIcon").visible = false;
                _local_12.findChildByName("multiContainer").visible = false;
                switch (_local_11._Str_7585)
                {
                    case ProductTypeEnum.FLOOR:
                        _local_13 = k.getFurnitureIcon(_local_11._Str_6270, this);
                        
                    case ProductTypeEnum.WALL:
                        _local_13 = k.getWallItemIcon(_local_11._Str_6270, this);
                        
                    default:
                        return;
                }
                if (_local_13 != null)
                {
                    _Str_12777(_local_12, _local_13.data);
                    this._Str_3889.addGridItem(_local_12);
                }
                if (_local_13.id != 0)
                {
                    this._Str_24735(_local_10, _local_13.id);
                }
                _arg_4.findChildByName("ctlg_product_name").caption = _arg_6;
                _arg_4.findChildByName("ctlg_description").caption = _arg_7;
                _local_10++;
            }
            if (_arg_5._Str_9475.length > 6)
            {
                _arg_4.findChildByName("bundleGridScrollbar").visible = true;
            }
            else
            {
                _arg_4.findChildByName("bundleGridScrollbar").visible = false;
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3 = 0;
            var _local_4:IWindowContainer = null;
            if (k == this._Str_16965)
            {
                this._Str_3234(_arg_2, true);
                this._Str_16965 = 0;
            }
            else
            {
                if (((!(this._Str_3889 == null)) && (!(this._Str_6872 == null))))
                {
                    _local_3 = this._Str_6872.indexOf(k);
                    if (_local_3 != -1)
                    {
                        _local_4 = cast(this._Str_3889.getGridItemAt(_local_3), IWindowContainer);
                        _Str_12777(_local_4, _arg_2);
                    }
                    else
                    {
                        this._Str_6872[_local_3] = 0;
                    }
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_3234(k:BitmapData, _arg_2:Bool)
        {
            var _local_3:Point = null;
            if (((!(this._Str_3607 == null)) && (!this._Str_3607.disposed)))
            {
                if (k == null)
                {
                    k = new BitmapData(1, 1);
                    _arg_2 = true;
                }
                this._Str_3607.bitmap = new BitmapData(this._Str_3607.width, this._Str_3607.height, true, 0xFFFFFF);
                this._Str_3607.bitmap.fillRect(this._Str_3607.bitmap.rect, 0xFFFFFF);
                _local_3 = new Point(((this._Str_3607.width - k.width) / 2), ((this._Str_3607.height - k.height) / 2));
                this._Str_3607.bitmap.copyPixels(k, k.rect, _local_3, null, null, true);
            }
            if ((_arg_2 && (!(k == null))))
            {
                k.dispose();
            }
        }

        function _Str_24244(k:Int)
        {
            this._Str_6872 = ASCompat.allocArray(k);
            var _local_2 = 0;
            while (_local_2 < this._Str_6872.length)
            {
                this._Str_6872[_local_2] = 0;
                _local_2++;
            }
        }

        function _Str_24735(k:Int, _arg_2:Int)
        {
            this._Str_6872[k] = _arg_2;
        }
public function new(){}
    }

