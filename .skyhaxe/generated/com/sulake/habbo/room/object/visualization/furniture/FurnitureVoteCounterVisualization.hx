package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureVoteCounterVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ONES_SPRITE= "ones_sprite";
        static inline final TENS_SPRITE= "tens_sprite";
        static inline final HUNDREDS_SPRITE= "hundreds_sprite";
        static inline final HIDE_COUNTER_SCORE= -1;


        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            super.updateObject(k, _arg_2);
            return true;
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            var _local_3= object.getModel();
            var _local_4= Std.int(_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_VOTE_COUNTER_COUNT));
            var _local_5= getSpriteTag(k, direction, _arg_2);
            switch (_local_5)
            {
                case ONES_SPRITE:
                    return _local_4 % 10;
                case TENS_SPRITE:
                    return Std.int((_local_4 / 10) % 10);
                case HUNDREDS_SPRITE:
                    return Std.int((_local_4 / 100) % 10);
                default:
                    return super.getFrameNumber(k, _arg_2);
            }
        }

        override function getSpriteAlpha(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_6:String = null;
            var _local_4= object.getModel();
            var _local_5= Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_VOTE_COUNTER_COUNT));
            if (_local_5 == HIDE_COUNTER_SCORE)
            {
                _local_6 = getSpriteTag(k, _arg_2, _arg_3);
                switch (_local_6)
                {
                    case ONES_SPRITE
                       | TENS_SPRITE
                       | HUNDREDS_SPRITE:
                        return 0;
                }
            }
            return super.getSpriteAlpha(k, _arg_2, _arg_3);
        }

	public function new() { super(); }
    }

