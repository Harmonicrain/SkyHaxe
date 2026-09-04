package com.sulake.habbo.room.object.visualization.game
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.GameObjectVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;

     class GameSnowballVisualization extends RoomObjectSpriteVisualization 
    {
        static inline final SNOWBALL_SMALL_PNG= "snowball_small_png";
        static inline final SNOWBALL_SMALL_SHADOW_PNG= "snowball_small_shadow_png";
        static inline final _Str_18767= 16;

        var _data:GameObjectVisualization;
        var _Str_6286:IRoomObjectSprite;


        override public function dispose()
        {
            this._Str_6286 = null;
            super.dispose();
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            var _local_2:BitmapDataAsset;
            this._data = Std.downcast(k , GameObjectVisualization);
            createSprites(2);
            _local_2 = Std.downcast(this._data.assets.getAssetByName(SNOWBALL_SMALL_PNG) , BitmapDataAsset);
            getSprite(0).asset = ASCompat.dynamicAs(_local_2.content , BitmapData);
            _local_2 = Std.downcast(this._data.assets.getAssetByName(SNOWBALL_SMALL_SHADOW_PNG) , BitmapDataAsset);
            this._Str_6286 = getSprite(1);
            this._Str_6286.asset = ASCompat.dynamicAs(_local_2.content , BitmapData);
            this._Str_6286.alpha = 100;
            this._Str_6286.relativeDepth = 1;
            return true;
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            this._Str_6286.offsetY = Std.int(object.getLocation().z * _Str_18767);
            this._Str_6286.alpha = Std.int(Math.max(0, (100 - (this._Str_6286.offsetY / 10))));
        }

	public function new() { super(); }
    }

