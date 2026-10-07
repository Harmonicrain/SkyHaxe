package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureSoundblockVisualization extends FurnitureAnimatedVisualization 
    {
        var _Str_12376__com_sulake_habbo_room_object_visualization_furniture_FurnitureSoundblockVisualization/*redefined private*/:Int = 1;
        var _Str_12177:Float = 0;


        override function  get_frameIncrease():Int
        {
            return this._Str_12376__com_sulake_habbo_room_object_visualization_furniture_FurnitureSoundblockVisualization;
        }

        override function updateAnimations(k:Float):Int
        {
            this._Str_12177 = (this._Str_12177 + object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_SOUNDBLOCK_RELATIVE_ANIMATION_SPEED));
            this._Str_12376__com_sulake_habbo_room_object_visualization_furniture_FurnitureSoundblockVisualization = Std.int(this._Str_12177);
            this._Str_12177 = (this._Str_12177 - this._Str_12376__com_sulake_habbo_room_object_visualization_furniture_FurnitureSoundblockVisualization);
            return super.updateAnimations(k);
        }

	public function new() { super(); }
    }

