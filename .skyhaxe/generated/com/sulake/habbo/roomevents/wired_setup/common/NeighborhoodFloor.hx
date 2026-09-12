package com.sulake.habbo.roomevents.wired_setup.common
;
     class NeighborhoodFloor
    {
        public static inline final RADIUS= 10;
        public static inline final SMALL_RADIUS= 5;

        var _floorPlanCache:Array<ASAny>;
        var _floorPlanCacheBuffer:Array<ASAny>;
        var _smallMode:Bool = false;
        var _onChanged:ASFunction;

        public function new(floorPlanCache:Array<ASAny>, smallMode:Bool, onChanged:ASFunction)
        {
            this._floorPlanCache = floorPlanCache;
            this._smallMode = smallMode;
            this._onChanged = onChanged;
        }

        public var floorPlanCache(get,never):Array<ASAny>;
public function  get_floorPlanCache():Array<ASAny> { return this._floorPlanCache; }
        public function setOccupied(x:Int, y:Int, occupied:Bool) { this._floorPlanCache[x][y] = occupied; }
        public function isOccupied(x:Int, y:Int):Bool { return this._floorPlanCache[x][y]; }

        public function occupationHasChanged()
        {
            if (this._onChanged != null) this._onChanged();
        }

        public var smallMode(never,set):Bool;
public function  set_smallMode(value:Bool):Bool{ return this._smallMode = value; }

        public function smallModeAllowed():Bool
        {
var x = 0, y = 0;            for (_tmp_ in -RADIUS...RADIUS + 1)
            {
x= _tmp_;
                for (_tmp_ in -RADIUS...RADIUS + 1)
                {
y= _tmp_;
                    if ((x < -SMALL_RADIUS || x > SMALL_RADIUS || y < -SMALL_RADIUS || y > SMALL_RADIUS)
                            && this.isOccupied(x + RADIUS, y + RADIUS))
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        public var visualizingRadius(get,never):Int;
public function  get_visualizingRadius():Int { return this._smallMode ? SMALL_RADIUS : RADIUS; }
        public var visualizingDimension(get,never):Int;
public function  get_visualizingDimension():Int { return this.visualizingRadius * 2 + 1; }

        public function initTemporaryCache()
        {
            this._floorPlanCacheBuffer = this._floorPlanCache;
            this.clearTemporaryCache();
        }

        public function clearTemporaryCache()
        {
var row:Array<ASAny>  = null;            if (this._floorPlanCacheBuffer == null) return;
            this._floorPlanCache = [];
            final _iter_ = this._floorPlanCacheBuffer; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
row = _tmp_;
                this._floorPlanCache.push(row.copy());
            }
        }

        public function submitTemporaryCache() { this._floorPlanCacheBuffer = null; }
    }

