package com.sulake.habbo.room.object.visualization.room.publicroom
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.visualization.room.RoomVisualization;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.room.utils.IRoomGeometry;

     class PublicRoomVisualization extends RoomVisualization
    {
        var _layerSpriteOffset:Int = 0;
        var _layoutInitialized:Bool = false;
        var _managedSpriteCount:Int = -1;

        public function new()
        {
            super();
        }

        var data(get,never):PublicRoomVisualizationData;
function  get_data():PublicRoomVisualizationData
        {
            return Std.downcast(this._data , PublicRoomVisualizationData);
        }

        override public function  get_floorRelativeDepth():Float
        {
            return 131;
        }

        override public function  get_wallRelativeDepth():Float
        {
            return 135;
        }

        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            if (!Std.is(k , PublicRoomVisualizationData))
            {
                return false;
            }
            return super.initialize(k);
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            super.update(k, _arg_2, _arg_3, _arg_4);
            if (((object == null) || (k == null)))
            {
                return;
            }
            this.ensureLayout(k, _arg_2);
        }

        function addSprites(k:Int)
        {
            createSprites((this._layerSpriteOffset + k));
        }

        function ensureLayout(k:IRoomGeometry, _arg_2:Int)
        {
            var _local_4 = 0;
            if (this.data == null)
            {
                return;
            }
            var _local_2= object.getModel().getString(RoomObjectVariableEnum.ROOM_WORLD_TYPE);
            // The PublicRoomVisualizationData (and its layoutRasterizer) is cached per content type,
            // so park_a and park_b share one rasterizer. Keep it pointed at THIS object's world
            // before any render so the shared layout is always correct for the active room.
            this.data.layoutRasterizer.layout = _local_2;
            var _local_3= this.data.layoutRasterizer.elementCount();
            if (_local_3 <= 0)
            {
                return;
            }
            // SELF-HEAL: the base RoomVisualization re-runs createSprites(planeCount) on geometry /
            // cache changes (e.g. when another room sharing this content disposes and calls
            // _data.clearCache(), forcing a plane re-render). createSprites DISPOSES every sprite
            // above planeCount -> the public-room layout sprites get destroyed and the room goes
            // black (happens on a fast same-content transition like park -> infobus bus, never on a
            // fresh direct entry). Re-establish the layout sprites above the current sprite count
            // whenever the base has changed it.
            if (this._layoutInitialized && (spriteCount == this._managedSpriteCount))
            {
                if ((this.data.layoutRasterizer.hasAnimations || this.data.layoutRasterizer.graphicsChanged))
                {
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        this.data.layoutRasterizer.setElementToSprite(_local_4, getSprite((this._layerSpriteOffset + _local_4)), k, _arg_2);
                        _local_4++;
                    }
                }
                return;
            }
            this._layerSpriteOffset = spriteCount;
            this.addSprites(_local_3);
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                this.data.layoutRasterizer.setElementToSprite(_local_4, getSprite((this._layerSpriteOffset + _local_4)), k, _arg_2);
                _local_4++;
            }
            this._layoutInitialized = true;
            this._managedSpriteCount = spriteCount;
        }
    }

