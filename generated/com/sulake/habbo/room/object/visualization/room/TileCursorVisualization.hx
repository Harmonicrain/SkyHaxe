package com.sulake.habbo.room.object.visualization.room
;
    import com.sulake.habbo.room.object.visualization.furniture.FurnitureAnimatedVisualization;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class TileCursorVisualization extends FurnitureAnimatedVisualization 
    {
        var _tileHeight:Float = 0;


        
        public var tileHeight(get,set):Float;
function  get_tileHeight():Float
        {
            return this._tileHeight;
        }
function  set_tileHeight(k:Float):Float        {
            return this._tileHeight = k;
        }

        override function getSpriteYOffset(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (_arg_3 == 1)
            {
                this.tileHeight = object.getModel().getNumber(RoomObjectVariableEnum.TILE_CURSOR_HEIGHT);
                return Std.int(-this.tileHeight * (k / 2));
            }
            return super.getSpriteYOffset(k, _arg_2, _arg_3);
        }

	public function new() { super(); }
    }

