package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;

     class CommunityGoalVsModeWidget extends CommunityGoalWidget 
    {
        static final NEEDLE_LEVELS:Array<ASAny> = [-3, -2, -1, 0, 1, 2, 3];
        static final NEEDLE_FRAMES:Array<ASAny> = [0, 0, 4.75, 11.5, 16.25, 23, 23];

        public function new(k:HabboLandingView, _arg_2:Bool=false)
        {
            super(k, _arg_2);
        }

        override function getCurrentNeedleFrame():Int
        {
            if (communityProgress.communityHighestAchievedLevel <= NEEDLE_LEVELS[0])
            {
                return Std.int(Math.fround(ASCompat.toNumber(NEEDLE_FRAMES[0])));
            }
            if (communityProgress.communityHighestAchievedLevel >= NEEDLE_LEVELS[(NEEDLE_LEVELS.length - 1)])
            {
                return Std.int(Math.fround(ASCompat.toNumber(NEEDLE_FRAMES[(NEEDLE_LEVELS.length - 1)])));
            }
            var k= ((communityProgress.scoreRemainingUntilNextLevel < 0) ? -1 : 1);
            var _local_2= communityProgress.communityHighestAchievedLevel;
            var _local_3= ASCompat.toNumber(NEEDLE_FRAMES[NEEDLE_LEVELS.indexOf(_local_2)]);
            var _local_4= Math.abs(ASCompat.toNumber(ASCompat.toNumber(NEEDLE_FRAMES[NEEDLE_LEVELS.indexOf((_local_2 + k))]) - ASCompat.toNumber(NEEDLE_FRAMES[NEEDLE_LEVELS.indexOf(_local_2)])));
            return Std.int(Math.fround((_local_3 + (((communityProgress.percentCompletionTowardsNextLevel / 100) * _local_4) * k))));
        }

        override public function update(k:UInt)
        {
            updateMeter(Std.int(Math.ffloor(this.getCurrentNeedleFrame())), false);
        }

        override public function initialize()
        {
            super.initialize();
            _communityGoalContainer.findChildByName("community_total_status").visible = false;
        }
    }

