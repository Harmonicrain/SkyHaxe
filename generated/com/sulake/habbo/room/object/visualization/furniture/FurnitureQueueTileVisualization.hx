package com.sulake.habbo.room.object.visualization.furniture
;
     class FurnitureQueueTileVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ANIMATION_ID_ROLL= 3;
        static inline final ANIMATION_ID_ROLL_ONCE= 2;
        static inline final ANIMATION_ID_NORMAL= 1;
        static inline final ANIMATION_DURATION= 15;

        var _stateQueue:Array<ASAny>;
        var _animationCounter:Int = 0;

        public function new()
        {
            this._stateQueue = new Array<ASAny>();
            super();
        }

        override function setAnimation(k:Int)
        {
            if (k == ANIMATION_ID_ROLL_ONCE)
            {
                this._stateQueue = new Array<ASAny>();
                this._stateQueue.push(ANIMATION_ID_NORMAL);
                this._animationCounter = ANIMATION_DURATION;
            }
            super.setAnimation(k);
        }

        override function updateAnimation(k:Float):Int
        {
            if (this._animationCounter > 0)
            {
                this._animationCounter--;
            }
            if (this._animationCounter == 0)
            {
                if (this._stateQueue.length > 0)
                {
                    super.setAnimation(ASCompat.toInt(this._stateQueue.shift()));
                }
            }
            return super.updateAnimation(k);
        }

        override function usesAnimationResetting():Bool
        {
            return true;
        }
    }

