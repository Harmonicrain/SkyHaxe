package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.habbo.catalog._enum.CatalogType;

     class FurniProductContainer extends ProductContainer 
    {
        var _furnitureData:IFurnitureData;

        public function new(k:IPurchasableOffer, _arg_2:Vector<IProduct>, _arg_3:HabboCatalog, _arg_4:IFurnitureData)
        {
            super(k, _arg_2, _arg_3);
            this._furnitureData = _arg_4;
        }

        override public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
            var _local_3:ImageResult = null;
            switch (this._furnitureData.type)
            {
                case ProductTypeEnum.FLOOR:
                    _local_3 = catalog.roomEngine.getFurnitureIcon(this._furnitureData.id, this);
                    
                case ProductTypeEnum.WALL:
                    _local_3 = catalog.roomEngine.getWallItemIcon(this._furnitureData.id, this);
                    
            }
            if (_local_3 != null)
            {
                setIconImage(_local_3.data, true);
            }
        }

        override public function activate()
        {
            super.activate();
            if (((this._furnitureData.rentOfferId > -1) && (!(catalog.catalogType == CatalogType.BUILDER))))
            {
                catalog.sendGetProductOffer(this._furnitureData.rentOfferId);
            }
            else
            {
                catalog.sendGetProductOffer(this._furnitureData.purchaseOfferId);
            }
        }

        override public function  get_isLazy():Bool
        {
            return true;
        }
    }

