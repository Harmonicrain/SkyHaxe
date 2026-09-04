package com.sulake.habbo.room.object.visualization.room.publicroom
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.utils.IRoomGeometry;

     class PublicRoomParkVisualization extends PublicRoomVisualization
    {
        var _busDoorOpen:Bool = false;

        public function new()
        {
            super();
        }

        override public function update(k:IRoomGeometry, _arg_2:Int, _arg_3:Bool, _arg_4:Bool)
        {
            super.update(k, _arg_2, _arg_3, _arg_4);
            var _local_5= object;
            if (_local_5 == null)
            {
                return;
            }
            if (k == null)
            {
                return;
            }
            if (this.data == null)
            {
                return;
            }
            var _local_6= _local_5.getModel();
            var _local_7= _local_6.getNumber(RoomObjectVariableEnum.ROOM_PUBLIC_PARK_BUS_DOOR_STATUS);
            var _local_9= _local_6.getString(RoomObjectVariableEnum.ROOM_WORLD_TYPE);
            if (_local_9 != "park_a")
            {
                return;
            }
            var _local_8= ((!Math.isNaN(_local_7)) && (_local_7 != 0));
            if (this._busDoorOpen != _local_8)
            {
                if (_local_8)
                {
                    this.data.layoutRasterizer.changeElementAlpha("bus", 0);
                    this.data.layoutRasterizer.changeElementAlpha("bus_oviopen_hidden", 255);
                }
                else
                {
                    this.data.layoutRasterizer.changeElementAlpha("bus", 255);
                    this.data.layoutRasterizer.changeElementAlpha("bus_oviopen_hidden", 0);
                }
                this._busDoorOpen = _local_8;
            }
            if (this.data.layoutRasterizer.graphicsChanged)
            {
                var _local_10= 0;
                while (_local_10 < this.data.layoutRasterizer.elementCount())
                {
                    this.data.layoutRasterizer.setElementToSprite(_local_10, getSprite((_local_10 + this._layerSpriteOffset)), k);
                    _local_10++;
                }
            }
        }
    }

