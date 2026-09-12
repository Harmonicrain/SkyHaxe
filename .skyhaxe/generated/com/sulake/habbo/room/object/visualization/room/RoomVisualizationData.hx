package com.sulake.habbo.room.object.visualization.room
;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.WallRasterizer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.FloorRasterizer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.basic.WallAdRasterizer;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.animated.LandscapeRasterizer;
    import com.sulake.habbo.room.object.visualization.room.mask.PlaneMaskManager;
    import com.sulake.habbo.room.object.visualization.room.rasterizer.IPlaneRasterizer;
    import com.sulake.room.object.visualization.utils.IGraphicAssetCollection;

     class RoomVisualizationData implements IRoomObjectVisualizationData 
    {
        var _wallRasterizer:WallRasterizer;
        var _floorRasterizer:FloorRasterizer;
        var _wallAdRasterizer:WallAdRasterizer;
        var _landscapeRasterizer:LandscapeRasterizer;
        var _maskManager:PlaneMaskManager;
        var _initialized:Bool = false;

        public function new()
        {
            this._wallRasterizer = new WallRasterizer();
            this._floorRasterizer = new FloorRasterizer();
            this._wallAdRasterizer = new WallAdRasterizer();
            this._landscapeRasterizer = new LandscapeRasterizer();
            this._maskManager = new PlaneMaskManager();
        }

        public var initialized(get,never):Bool;
public function  get_initialized():Bool
        {
            return this._initialized;
        }

        public var floorRasterizer(get,never):IPlaneRasterizer;
public function  get_floorRasterizer():IPlaneRasterizer
        {
            return this._floorRasterizer;
        }

        public var wallRasterizer(get,never):IPlaneRasterizer;
public function  get_wallRasterizer():IPlaneRasterizer
        {
            return this._wallRasterizer;
        }

        public var wallAdRasterizr(get,never):WallAdRasterizer;
public function  get_wallAdRasterizr():WallAdRasterizer
        {
            return this._wallAdRasterizer;
        }

        public var landscapeRasterizer(get,never):IPlaneRasterizer;
public function  get_landscapeRasterizer():IPlaneRasterizer
        {
            return this._landscapeRasterizer;
        }

        public var _Str_16279(get,never):PlaneMaskManager;
public function  get__Str_16279():PlaneMaskManager
        {
            return this._maskManager;
        }

        public function dispose()
        {
            if (this._wallRasterizer != null)
            {
                this._wallRasterizer.dispose();
                this._wallRasterizer = null;
            }
            if (this._floorRasterizer != null)
            {
                this._floorRasterizer.dispose();
                this._floorRasterizer = null;
            }
            if (this._wallAdRasterizer != null)
            {
                this._wallAdRasterizer.dispose();
                this._wallAdRasterizer = null;
            }
            if (this._landscapeRasterizer != null)
            {
                this._landscapeRasterizer.dispose();
                this._landscapeRasterizer = null;
            }
            if (this._maskManager != null)
            {
                this._maskManager.dispose();
                this._maskManager = null;
            }
        }

        public function clearCache()
        {
            if (this._wallRasterizer != null)
            {
                this._wallRasterizer.clearCache();
            }
            if (this._floorRasterizer != null)
            {
                this._floorRasterizer.clearCache();
            }
            if (this._landscapeRasterizer != null)
            {
                this._landscapeRasterizer.clearCache();
            }
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:com.sulake.core.utils.xml.XML = null;
            var _local_11:com.sulake.core.utils.xml.XML = null;
            this.reset();
            if (k == null)
            {
                return false;
            }
            var _local_2= k.child("wallData");
            if (_local_2.length() > 0)
            {
                _local_7 = _local_2.at(0);
                this._wallRasterizer.initialize(_local_7);
            }
            var _local_3= k.child("floorData");
            if (_local_3.length() > 0)
            {
                _local_8 = _local_3.at(0);
                this._floorRasterizer.initialize(_local_8);
            }
            var _local_4= k.child("wallAdData");
            if (_local_4.length() > 0)
            {
                _local_9 = _local_4.at(0);
                this._wallAdRasterizer.initialize(_local_9);
            }
            var _local_5= k.child("landscapeData");
            if (_local_5.length() > 0)
            {
                _local_10 = _local_5.at(0);
                this._landscapeRasterizer.initialize(_local_10);
            }
            var _local_6= k.child("maskData");
            if (_local_6.length() > 0)
            {
                _local_11 = _local_6.at(0);
                this._maskManager.initialize(_local_11);
            }
            return true;
        }

        public function initializeAssetCollection(k:IGraphicAssetCollection)
        {
            if (this._initialized)
            {
                return;
            }
            this._wallRasterizer.initializeAssetCollection(k);
            this._floorRasterizer.initializeAssetCollection(k);
            this._wallAdRasterizer.initializeAssetCollection(k);
            this._landscapeRasterizer.initializeAssetCollection(k);
            this._maskManager.initializeAssetCollection(k);
            this._initialized = true;
        }

        function reset()
        {
        }
    }

