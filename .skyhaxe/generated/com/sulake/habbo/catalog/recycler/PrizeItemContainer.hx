package com.sulake.habbo.catalog.recycler
;
    import com.sulake.habbo.catalog.viewer.ProductGridItem;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.ImageResult;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.room.IRoomEngine;

     class PrizeItemContainer extends ProductGridItem implements IGetImageListener implements  IGridItem 
    {
        public function new(k:HabboCatalog)
        {
            super(k);
        }

        function initProductIcon(k:IRoomEngine, _arg_2:String, _arg_3:Int, _arg_4:String="")
        {
            var _local_6:ImageResult = null;
            var _local_5:BitmapData = null;
            switch (_arg_2)
            {
                case ProductTypeEnum.FLOOR:
                    _local_6 = k.getFurnitureIcon(_arg_3, this);
                    
                case ProductTypeEnum.WALL:
                    _local_6 = k.getWallItemIcon(_arg_3, this, _arg_4);
                    
                default:
                    Logger.log([("[PrizeItemContainer] Can not yet handle this type of product: " + _arg_2)]);
                    return;
            }
            if (_local_6 != null)
            {
                _local_5 = _local_6.data;
                setIconImage(_local_5, true);
            }
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (disposed)
            {
                return;
            }
            setIconImage(_arg_2, true);
        }

        public function imageFailed(k:Int)
        {
        }
    }

