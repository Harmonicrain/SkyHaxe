package com.sulake.habbo.room.object.visualization.furniture
;
     class FurnitureCounterClockVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final SECONDS_SPRITE= "seconds_sprite";
        static inline final TEN_SECONDS_SPRITE= "ten_seconds_sprite";
        static inline final MINUTES_SPRITE= "minutes_sprite";
        static inline final TEN_MINUTES_SPRITE= "ten_minutes_sprite";


        override public function  get_animationId():Int
        {
            return 0;
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            var _local_3= getSpriteTag(k, direction, _arg_2);
            var _local_4= super.animationId;
            switch (_local_3)
            {
                case SECONDS_SPRITE:
                    return (_local_4 % 60) % 10;
                case TEN_SECONDS_SPRITE:
                    return Std.int((_local_4 % 60) / 10);
                case MINUTES_SPRITE:
                    return Std.int((_local_4 / 60) % 10);
                case TEN_MINUTES_SPRITE:
                    return Std.int(((_local_4 / 60) / 10) % 10);
                default:
                    return super.getFrameNumber(k, _arg_2);
            }
        }

	public function new() { super(); }
    }

