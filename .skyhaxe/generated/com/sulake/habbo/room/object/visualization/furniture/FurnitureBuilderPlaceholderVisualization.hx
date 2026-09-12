package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureBuilderPlaceholderVisualization extends FurnitureVisualization 
    {
        var _sizeX:Int = -1;
        var _sizeY:Int = -1;


        override function updateModel(k:Float):Bool
        {
            var _local_2= super.updateModel(k);
            var _local_3= object.getModel();
            var _local_4= Std.int(_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_X));
            var _local_5= Std.int(_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_SIZE_Y));
            if (((!(_local_4 == this._sizeX)) || (!(_local_5 == this._sizeY))))
            {
                this._sizeX = _local_4;
                this._sizeY = _local_5;
                this.instantiateSprites(k);
            }
            return _local_2;
        }

        function instantiateSprites(k:Float)
        {
            this.updateLayerCount(data.getLayerCount(Std.int(k)));
            createSprites(((data.getLayerCount(Std.int(k)) * this._sizeX) * this._sizeY));
            updateSprites(Std.int(k), true, 0);
        }

        override function updateLayerCount(k:Int)
        {
            _Str_3416 = k;
            if ((this._sizeX * this._sizeY) > 1)
            {
                _Str_3416 = (_Str_3416 * (this._sizeX * this._sizeY));
            }
        }

        override function getAdditionalSpriteCount():Int
        {
            return 0;
        }

        override function getSpriteTag(k:Int, _arg_2:Int, _arg_3:Int):String
        {
            return super.getSpriteTag(k, _arg_2, this.getIndex(k, _arg_3));
        }

        override function getSpriteAlpha(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            return super.getSpriteAlpha(k, _arg_2, this.getIndex(k, _arg_3));
        }

        override function getSpriteColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            return super.getSpriteColor(k, this.getIndex(k, _arg_2), _arg_3);
        }

        override function getSpriteAssetName(k:Int, _arg_2:Int):String
        {
            return super.getSpriteAssetName(k, this.getIndex(k, _arg_2));
        }

        override function getSpriteXOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= super.getSpriteXOffset(k, _arg_2, this.getIndex(k, _arg_3));
            var _local_5= Std.int(_arg_3 / data.getLayerCount(k));
            var _local_6= (_local_5 % this._sizeY);
            var _local_7= Std.int(_local_5 / this._sizeY);
            return Std.int(_local_4 + (((_local_6 - _local_7) * k) / 2));
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= super.getSpriteYOffset(k, _arg_2, this.getIndex(k, _arg_3));
            var _local_5= Std.int(_arg_3 / data.getLayerCount(k));
            var _local_6= (_local_5 % this._sizeY);
            var _local_7= Std.int(_local_5 / this._sizeY);
            return Std.int(_local_4 + (((_local_6 + _local_7) * k) / 4));
        }

        override function getSpriteMouseCapture(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            return super.getSpriteMouseCapture(k, _arg_2, this.getIndex(k, _arg_3));
        }

        override function getSpriteInk(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            return super.getSpriteInk(k, _arg_2, this.getIndex(k, _arg_3));
        }

        override function getSpriteZOffset(k:Int, _arg_2:Int, _arg_3:Int):Float
        {
            return super.getSpriteZOffset(k, _arg_2, this.getIndex(k, _arg_3));
        }

        function getIndex(k:Int, _arg_2:Int):Int
        {
            return (data != null) ? (_arg_2 % data.getLayerCount(k)) : _arg_2;
        }

	public function new() { super(); }
    }

