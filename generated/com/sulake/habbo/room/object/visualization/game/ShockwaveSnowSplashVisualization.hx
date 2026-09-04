package com.sulake.habbo.room.object.visualization.game
;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.room.object.visualization.furniture.GameObjectVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.object.visualization.RoomObjectSpriteVisualization;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.display.BitmapData;

    /** Exact hit1/hit2/hit3 cadence from r26 Snowwar Hit Animation Class. */
     final class ShockwaveSnowSplashVisualization extends RoomObjectSpriteVisualization
    {
        static inline final FRAME_TWO_AT= 240;
        static inline final FRAME_THREE_AT= 360;
        static inline final COMPLETE_AT= 480;
        static final NAMES:Array<ASAny> = ["shockwave_hit1", "shockwave_hit2", "shockwave_hit3"];
        static final REG_X:Array<ASAny> = [8, 8, 11];
        static final REG_Y:Array<ASAny> = [6, 8, 11];

        var _data:GameObjectVisualization;
        var _startedAt:Int = 0;
        var _frame:Int = -1;

        override public function initialize(data:IRoomObjectVisualizationData):Bool
        {
            this._data = Std.downcast(data , GameObjectVisualization);
            if (this._data == null || this._data.assets == null) return false;
            createSprites(1);
            this._startedAt = flash.Lib.getTimer();
            this.setFrame(0);
            return getSprite(0).asset != null;
        }

        override public function update(geometry:IRoomGeometry, time:Int,
                                        update:Bool, skipUpdate:Bool)
        {
            var elapsed= flash.Lib.getTimer() - this._startedAt;
            if (elapsed >= COMPLETE_AT)
            {
                getSprite(0).asset = null;
                return;
            }
            this.setFrame(elapsed >= FRAME_THREE_AT ? 2 : (elapsed >= FRAME_TWO_AT ? 1 : 0));
        }

        function setFrame(frame:Int)
        {
            if (frame == this._frame) return;
            var asset= Std.downcast(this._data.assets.getAssetByName(NAMES[frame]) , BitmapDataAsset);
            if (asset == null) return;
            var sprite= getSprite(0);
            sprite.asset = ASCompat.dynamicAs(asset.content , BitmapData);
            sprite.offsetX = -ASCompat.toInt(REG_X[frame]);
            sprite.offsetY = -ASCompat.toInt(REG_Y[frame]);
            this._frame = frame;
        }

	public function new() { super(); }
    }

