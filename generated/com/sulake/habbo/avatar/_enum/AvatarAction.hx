package com.sulake.habbo.avatar._enum
;
     class AvatarAction 
    {
        public static inline final SIGN= "sign";
        public static inline final SLEEP= "Sleep";
        public static inline final CARRY_OBJECT= "cri";
        public static inline final USE_OBJECT= "usei";
        public static inline final EFFECT= "fx";
        public static inline final TALK= "talk";
        public static inline final GESTURE= "gest";
        public static inline final EXPRESSION= "expression";
        public static inline final VOTE= "vote";
        public static inline final DANCE= "dance";
        public static inline final TYPING= "typing";
        public static inline final MUTED= "muted";
        public static inline final PLAYING_GAME= "playing_game";
        public static inline final GUIDE_STATUS= "guide";
        public static inline final EXPRESSION_RESPECT= "respect";
        public static inline final EXPRESSION_67= "67";
        public static inline final EXPRESSION_WAVE= "wave";
        public static inline final EXPRESSION_BLOW_A_KISS= "blow";
        public static inline final EXPRESSION_LAUGH= "laugh";
        public static inline final EXPRESSION_CRY= "cry";
        public static inline final EXPRESSION_IDLE= "idle";
        public static inline final EXPRESSION_SNOWBOARD_OLLIE= "sbollie";
        public static inline final EXPRESSION_SNOWBORD_360= "sb360";
        public static inline final EXPRESSION_RIDE_JUMP= "ridejump";
        public static inline final GESTURE_SMILE= "sml";
        public static inline final GESTURE_AGGRAVATED= "agr";
        public static inline final GESTURE_SURPRISED= "srp";
        public static inline final GESTURE_SAD= "sad";
        public static inline final PET_GESTURE_JOY= "joy";
        public static inline final PET_GESTURE_CRAZY= "crz";
        public static inline final PET_GESTURE_TONGUE= "tng";
        public static inline final PET_GESTURE_BLINK= "eyb";
        public static inline final PET_GESTURE_MISERABLE= "mis";
        public static inline final PET_GESTURE_PUZZLED= "puz";
        public static inline final POSTURE= "posture";
        public static inline final POSTURE_STAND= "std";
        public static inline final POSTURE_SIT= "sit";
        public static inline final POSTURE_WALK= "mv";
        public static inline final POSTURE_LAY= "lay";
        public static inline final POSTURE_SWIM= "swim";
        public static inline final POSTURE_FLOAT= "float";
		
        public static inline final SNOWWAR_RUN= "swrun";
        public static inline final SNOWWAR_DIE_FRONT= "swdiefront";
        public static inline final SNOWWAR_DIE_BACK= "swdieback";
        public static inline final SNOWWAR_PICK= "swpick";
        public static inline final SNOWWAR_THROW= "swthrow";
		
        static final GESTURE_MAP:Array<ASAny> = ["", GESTURE_SMILE, GESTURE_AGGRAVATED, GESTURE_SURPRISED, GESTURE_SAD, PET_GESTURE_JOY, PET_GESTURE_CRAZY, PET_GESTURE_TONGUE, PET_GESTURE_BLINK, PET_GESTURE_MISERABLE, PET_GESTURE_PUZZLED];
        static final EXPRESSION_MAP:Array<ASAny> = ["", EXPRESSION_WAVE, EXPRESSION_BLOW_A_KISS, EXPRESSION_LAUGH, EXPRESSION_CRY, EXPRESSION_IDLE, DANCE, EXPRESSION_RESPECT, EXPRESSION_SNOWBOARD_OLLIE, EXPRESSION_SNOWBORD_360, EXPRESSION_RIDE_JUMP];


        public static function getExpressionTime(id:Int):Int
        {
            switch (id)
            {
                case 1:
                    return 5000;
                case 2:
                    return 1400;
                case 67:
                    return 990;
                case 3:
                    return 2000;
                case 4:
                    return 2000;
                case 5:
                    return 0;
                case 6:
                    return 700;
                case 7:
                    return 2000;
                case 8:
                    return 1500;
                case 9:
                    return 1500;
                case 10:
                    return 1500;
                default:
                    return 0;
            }
        }

        public static function getExpressionId(expression:String):Int
        {
            if (expression == EXPRESSION_67)
            {
                return 67;
            }
            return EXPRESSION_MAP.indexOf(expression);
        }

        public static function getExpression(expressionId:Int):String
        {
            if (expressionId == 67)
            {
                return EXPRESSION_67;
            }
            if (expressionId < EXPRESSION_MAP.length)
            {
                return EXPRESSION_MAP[expressionId];
            }
            return "";
        }

        public static function getGestureId(gesture:String):Int
        {
            return GESTURE_MAP.indexOf(gesture);
        }

        public static function getGesture(gestureId:Int):String
        {
            if (gestureId < GESTURE_MAP.length)
            {
                return GESTURE_MAP[gestureId];
            }
            return "";
        }

	public function new() {}
    }

