package com.sulake.habbo.room.object.visualization.furniture
;
     class FurnitureHabbowheelVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ANIMATION_ID_OFFSET_SLOW1= 10;
        static inline final ANIMATION_ID_OFFSET_SLOW2= 20;
        static inline final ANIMATION_ID_START_ROLL= 31;
        static inline final ANIMATION_ID_ROLL= 32;

        var _stateQueue:Array<ASAny>;
        var _running:Bool = false;

        public function new()
        {
            this._stateQueue = new Array<ASAny>();
            super();
        }

        override function setAnimation(k:Int)
        {
            if (k == -1)
            {
                if (!this._running)
                {
                    this._running = true;
                    this._stateQueue = new Array<ASAny>();
                    this._stateQueue.push(ANIMATION_ID_START_ROLL);
                    this._stateQueue.push(ANIMATION_ID_ROLL);
                    return;
                }
            }
            if (((k > 0) && (k <= ANIMATION_ID_OFFSET_SLOW1)))
            {
                if (this._running)
                {
                    this._running = false;
                    this._stateQueue = new Array<ASAny>();
                    this._stateQueue.push((ANIMATION_ID_OFFSET_SLOW1 + k));
                    this._stateQueue.push((ANIMATION_ID_OFFSET_SLOW2 + k));
                    this._stateQueue.push(k);
                    return;
                }
                super.setAnimation(k);
            }
        }

        override function updateAnimation(k:Float):Int
        {
            if (((super.getLastFramePlayed(1) && super.getLastFramePlayed(2)) && super.getLastFramePlayed(3)))
            {
                if (this._stateQueue.length > 0)
                {
                    super.setAnimation(ASCompat.toInt(this._stateQueue.shift()));
                }
            }
            return super.updateAnimation(k);
        }
    }

