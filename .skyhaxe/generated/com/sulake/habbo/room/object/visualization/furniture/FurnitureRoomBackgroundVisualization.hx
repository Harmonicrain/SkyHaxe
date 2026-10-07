package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.IRoomObjectModel;
    import flash.display.BitmapData;
    import com.sulake.habbo.room.object.visualization.data.DirectionalOffsetData;
    import com.sulake.room.utils.RoomGeometry;

     class FurnitureRoomBackgroundVisualization extends FurnitureBrandedImageVisualization 
    {
        var _imageOffsets:ASDictionary<ASAny,ASAny>;


        override public function dispose()
        {
            super.dispose();
            this._imageOffsets = null;
        }

        override function getAdClickUrl(k:IRoomObjectModel):String
        {
            return null;
        }

        override function imageReady(k:BitmapData, _arg_2:String)
        {
            var _local_3 = 0;
            var _local_4 = 0;
            var _local_5 = 0;
            super.imageReady(k, _arg_2);
            if (k != null)
            {
                this._imageOffsets = new ASDictionary<ASAny,ASAny>();
                _local_3 = 64;
                _local_4 = k.width;
                _local_5 = k.height;
                this.addDirectionalOffsets(_local_3, _local_5, _local_4);
                _local_3 = 32;
                _local_4 = Std.int(_local_4 / 2);
                _local_5 = Std.int(_local_5 / 2);
                this.addDirectionalOffsets(_local_3, _local_5, _local_4);
            }
        }

        function addDirectionalOffsets(k:Int, _arg_2:Int, _arg_3:Int)
        {
            var _local_4= _Str_3033(k);
            var _local_5= new DirectionalOffsetData();
            _local_5.setOffset(1, 0, -_arg_2);
            _local_5.setOffset(3, 0, 0);
            _local_5.setOffset(5, -_arg_3, 0);
            _local_5.setOffset(7, -_arg_3, -_arg_2);
            _local_5.setOffset(4, Std.int(-_arg_3 / 2), Std.int(-_arg_2 / 2));
            this._imageOffsets[_local_4] = _local_5;
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4 = 0;
            var _local_5:DirectionalOffsetData = null;
            if (this._imageOffsets != null)
            {
                _local_4 = _Str_3033(k);
                _local_5 = this._imageOffsets[_local_4];
                if (_local_5 != null)
                {
                    return Std.int(_local_5.getOffsetX(_arg_2, 0) + this.getScaledOffset(offsetX, k));
                }
            }
            return Std.int(super.getSpriteXOffset(k, _arg_2, _arg_3) + this.getScaledOffset(offsetX, k));
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4 = 0;
            var _local_5:DirectionalOffsetData = null;
            if (this._imageOffsets != null)
            {
                _local_4 = _Str_3033(k);
                _local_5 = this._imageOffsets[_local_4];
                if (_local_5 != null)
                {
                    return Std.int(_local_5.getOffsetY(_arg_2, 0) + this.getScaledOffset(offsetY, k));
                }
            }
            return Std.int(super.getSpriteYOffset(k, _arg_2, _arg_3) + this.getScaledOffset(offsetY, k));
        }

        override function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            return super.getSpriteZOffset(k, _arg_2, _arg_3) + (offsetZ * -1);
        }

        override function getSpriteMouseCapture(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            return false;
        }

        function getScaledOffset(k:Int, _arg_2:Int):Float
        {
            return (k * _arg_2) / RoomGeometry.SCALE_ZOOMED_IN;
        }

	public function new() { super(); }
    }

