package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.room.object.visualization.IRoomObjectVisualizationData;
    import com.sulake.habbo.room.object.visualization.data.ColorData;

     class FurnitureStickieVisualization extends FurnitureVisualization 
    {
        var _data__com_sulake_habbo_room_object_visualization_furniture_FurnitureStickieVisualization/*redefined private*/:FurnitureVisualizationData = null;


        override public function initialize(k:IRoomObjectVisualizationData):Bool
        {
            this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureStickieVisualization = Std.downcast(k , FurnitureVisualizationData);
            return super.initialize(k);
        }

        override function getSpriteColor(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            if (this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureStickieVisualization == null)
            {
                return ASCompat.toInt(ColorData.DEFAULT_COLOR);
            }
            var _local_4= this._data__com_sulake_habbo_room_object_visualization_furniture_FurnitureStickieVisualization.getColor(k, _arg_2, _arg_3);
            return _local_4;
        }

	public function new() { super(); }
    }

