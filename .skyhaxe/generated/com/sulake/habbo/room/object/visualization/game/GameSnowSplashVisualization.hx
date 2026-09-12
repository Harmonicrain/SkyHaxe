package com.sulake.habbo.room.object.visualization.game
;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.habbo.room.object.visualization.furniture.GameObjectVisualization;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.display.BitmapData;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;

     class GameSnowSplashVisualization extends RoomObjectSpriteVisualization 
    {
        static final FRAME_ASSET_NAMES:Array<ASAny> = ["snowball_splash_1", "snowball_splash_2", "snowball_splash_3"];

        var _frameNumber:Int = 0;
        var _data:GameObjectVisualization;


        public var _Str_22837(get,never):Bool;
public function  get__Str_22837():Bool
        {
            return !(this._frameNumber < FRAME_ASSET_NAMES.length);
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            var _local_2:BitmapDataAsset = null;
            this._data = Std.downcast(k , GameObjectVisualization);
            createSprites(1);
            _local_2 = Std.downcast(this._data.assets.getAssetByName(FRAME_ASSET_NAMES[this._frameNumber]) , BitmapDataAsset);
            getSprite(0).asset = ASCompat.dynamicAs(_local_2.content , BitmapData);
            return true;
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            this._frameNumber++;
            getSprite(0).asset = (this._Str_22837 ? null : ASCompat.dynamicAs(this._data.assets.getAssetByName(FRAME_ASSET_NAMES[this._frameNumber]).content , BitmapData));
        }

	public function new() { super(); }
    }

