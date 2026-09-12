package com.sulake.habbo.room.object.visualization.game
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.object.visualization.furniture.GameObjectVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;

    /** Native depth-sorted renderer for the exact dumped r26 SnowStorm ball and shadow. */
     final class ShockwaveSnowballVisualization extends RoomObjectSpriteVisualization
    {
        static inline final HEIGHT_TO_SCREEN= 16;
        var _shadow:IRoomObjectSprite;

        override public function dispose()
        {
            this._shadow = null;
            super.dispose();
        }

        override public function initialize(data:IRoomObjectVisualizationData):Bool
        {
            var gameData= Std.downcast(data , GameObjectVisualization);
            if (gameData == null || gameData.assets == null) return false;
            var ball= Std.downcast(gameData.assets.getAssetByName(
                "shockwave_snowball_png") , BitmapDataAsset);
            var shadow= Std.downcast(gameData.assets.getAssetByName(
                "shockwave_snowball_shadow_png") , BitmapDataAsset);
            if (ball == null || shadow == null) return false;
            createSprites(2);
            getSprite(0).asset = ASCompat.dynamicAs(ball.content , BitmapData);
            // Director member registration points: snowball reg(3,3), snowball_sd reg(3,1).
            getSprite(0).offsetX = -3;
            getSprite(0).offsetY = -3;
            this._shadow = getSprite(1);
            this._shadow.asset = ASCompat.dynamicAs(shadow.content , BitmapData);
            this._shadow.offsetX = -3;
            this._shadow.alpha = 100;
            this._shadow.relativeDepth = 1;
            return true;
        }

        override public function update(geometry:IRoomGeometry, time:Int,
                                        update:Bool, skipUpdate:Bool)
        {
            if (this._shadow == null || object == null || object.getLocation() == null) return;
            this._shadow.offsetY = Std.int(object.getLocation().z * HEIGHT_TO_SCREEN - 1);
            this._shadow.alpha = Std.int(Math.max(0, 100 - this._shadow.offsetY / 10));
        }

	public function new() { super(); }
    }

