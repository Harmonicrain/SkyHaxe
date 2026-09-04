package com.sulake.habbo.room.object.visualization.room.publicroom
;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.publicroom.rasterizer.LayoutRasterizer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

     class PublicRoomVisualizationData extends RoomVisualizationData
    {
        var _layoutRasterizer:LayoutRasterizer;

        public function new()
        {
            super();
            this._layoutRasterizer = new LayoutRasterizer();
        }

        public var layoutRasterizer(get,never):LayoutRasterizer;
function  get_layoutRasterizer():LayoutRasterizer
        {
            return this._layoutRasterizer;
        }

        override public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_4:com.sulake.core.utils.xml.XML;
            if (!super.initialize(k))
            {
                return false;
            }
            if (k == null)
            {
                return false;
            }
            var _local_2= k.child("layoutData");
            var _local_3 = 0;
            while (_local_3 < _local_2.length())
            {
                _local_4 = _local_2.at(_local_3);
                this._layoutRasterizer.initialize(_local_4);
                _local_3++;
            }
            return true;
        }

        override public function initializeAssetCollection(k:IGraphicAssetCollection)
        {
            if (initialized)
            {
                return;
            }
            super.initializeAssetCollection(k);
            this._layoutRasterizer.initializeAssetCollection(k);
        }

        override function reset()
        {
            super.reset();
        }

        override public function dispose()
        {
            super.dispose();
            if (this._layoutRasterizer != null)
            {
                this._layoutRasterizer.dispose();
                this._layoutRasterizer = null;
            }
        }
    }

