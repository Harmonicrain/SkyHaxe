package com.sulake.habbo.room.object.visualization.furniture
;
     class FurnitureBottleVisualization extends FurnitureAnimatedVisualization 
    {
        static inline final ANIMATION_ID_OFFSET_SLOW1= 20;
        static inline final ANIMATION_ID_OFFSET_SLOW2= 9;
        static inline final ANIMATION_ID_ROLL= -1;

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
                    this._stateQueue.push(ANIMATION_ID_ROLL);
                    return;
                }
            }
            if (((k >= 0) && (k <= 7)))
            {
                if (this._running)
                {
                    this._running = false;
                    this._stateQueue = new Array<ASAny>();
                    this._stateQueue.push(ANIMATION_ID_OFFSET_SLOW1);
                    this._stateQueue.push((ANIMATION_ID_OFFSET_SLOW2 + k));
                    this._stateQueue.push(k);
                    return;
                }
                super.setAnimation(k);
            }
        }

        override function updateAnimation(k:Float):Int
        {
            if (super.getLastFramePlayed(0))
            {
                if (this._stateQueue.length > 0)
                {
                    super.setAnimation(ASCompat.toInt(this._stateQueue.shift()));
                }
            }
            return super.updateAnimation(k);
        }
    }

