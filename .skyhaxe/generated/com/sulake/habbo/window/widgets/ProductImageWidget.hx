package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.room.utils.Vector3d;

     class ProductImageWidget extends ProductIconWidget
    {
        public static inline final PRODUCT_IMAGE= "product_image";
        public function new(window:IWidgetWindow,
            manager:HabboWindowManagerComponent)
        {
            super(window, manager, "product_image_xml");
        }

        override function  get_productPreviewBitmap():IBitmapWrapperWindow
        {
            return this._root == null ? null : Std.downcast(this._root.findChildByName("product_preview") , IBitmapWrapperWindow);
        }

        override public function previewImage(info:IProductDisplayInfo)
        {
            var furniture:IFurnitureData = null;
            var image:ImageResult = null;

            if (info == null)
            {
                super.previewImage(info);
                return;
            }

            switch (info.productTypeId)
            {
                case 1:
                    furniture = this._windowManager.sessionDataManager.getWallItemData(ASCompat.parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    image = this._windowManager.roomEngine.getWallItemImage(furniture.id, new Vector3d(90), 64, this, 0, info.extraData);
                    
                case 2:
                    furniture = this._windowManager.sessionDataManager.getFloorItemData(ASCompat.parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    image = this._windowManager.roomEngine.getFurnitureImage(furniture.id, new Vector3d(90, 0, 0), 64, this);
                    
                default:
                    super.previewImage(info);
                    return;
            }

            this.imageResult = image;
        }
    }

