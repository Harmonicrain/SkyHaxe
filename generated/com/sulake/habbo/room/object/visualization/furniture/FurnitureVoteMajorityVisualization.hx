package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

     class FurnitureVoteMajorityVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ONES_SPRITE= "ones_sprite";
        static inline final TENS_SPRITE= "tens_sprite";
        static inline final HUNDREDS_SPRITE= "hundreds_sprite";
        static final HIDE_RESULTS_STATES:Array<ASAny> = [-1, 1];
        static inline final HIDE_RESULTS_VALUE= -1;


        override function updateObject(k:Float, _arg_2:Float):Bool
        {
            super.updateObject(k, _arg_2);
            return true;
        }

        override function getFrameNumber(k:Int, _arg_2:Int):Int
        {
            var _local_3= object.getModel();
            var _local_4= Std.int(_local_3.getNumber(RoomObjectVariableEnum.FURNITURE_VOTE_MAJORITY_RESULT));
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
            var _local_6:String;
            var _local_4= object.getModel();
            var _local_5= Std.int(_local_4.getNumber(RoomObjectVariableEnum.FURNITURE_VOTE_MAJORITY_RESULT));
            if (((!(HIDE_RESULTS_STATES.indexOf(object.getState(0)) == -1)) || (_local_5 == HIDE_RESULTS_VALUE)))
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

