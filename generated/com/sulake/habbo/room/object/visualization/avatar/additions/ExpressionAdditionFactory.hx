package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;

     class ExpressionAdditionFactory 
    {
        public static inline final WAVE= 1;
        public static inline final BLOW= 2;
        public static inline final LAUGH= 3;
        public static inline final CRY= 4;
        public static inline final IDLE= 5;


        public static function make(k:Int, _arg_2:Int, _arg_3:AvatarVisualization):IExpressionAddition
        {
            switch (_arg_2)
            {
                case BLOW:
                    return new FloatingHeart(k, BLOW, _arg_3);
                default:
                    return new ExpressionAddition(k, _arg_2, _arg_3);
            }
        }

	public function new() {}
    }

