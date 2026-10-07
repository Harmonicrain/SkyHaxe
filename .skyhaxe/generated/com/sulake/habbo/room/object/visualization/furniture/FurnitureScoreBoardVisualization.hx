package com.sulake.habbo.room.object.visualization.furniture
;
     class FurnitureScoreBoardVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ONES_SPRITE= "ones_sprite";
        static inline final TENS_SPRITE= "tens_sprite";
        static inline final HUNDREDS_SPRITE= "hundreds_sprite";
        static inline final THOUSANDS_SPRITE= "thousands_sprite";


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
                case ONES_SPRITE:
                    return _local_4 % 10;
                case TENS_SPRITE:
                    return Std.int((_local_4 / 10) % 10);
                case HUNDREDS_SPRITE:
                    return Std.int((_local_4 / 100) % 10);
                case THOUSANDS_SPRITE:
                    return Std.int((_local_4 / 1000) % 10);
                default:
                    return super.getFrameNumber(k, _arg_2);
            }
        }

	public function new() { super(); }
    }

