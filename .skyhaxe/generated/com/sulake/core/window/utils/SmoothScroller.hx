package com.sulake.core.window.utils
;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

     class SmoothScroller
    {
        public static inline final DEFAULT_SCROLL_STEP:Float = 25;

        static inline final DEFAULT_MAX_DURATION_MS:Float = 200;
        static inline final INVERSE_DELTA_RAMP_START_PX:Float = 120;
        static inline final INVERSE_DELTA_RAMP_END_PX:Float = 480;
        static inline final INVERSE_DELTA_MIN_DURATION_SCALE= 0.5;
        static inline final VELOCITY_BOUND_FUDGE= 2.5;
        static inline final CURVE_EPSILON= 0.01;
        static inline final CURVE_X1= 0.42;
        static inline final CURVE_X2= 0.58;
        static inline final CURVE_Y2:Float = 1;
        static inline final MAX_SLOPE:Float = 1000;
        static inline final NEWTON_ITERATIONS= 4;
        static inline final BINARY_SEARCH_ITERATIONS= 8;

        var _getPosition:ASFunction;
        var _setPosition:ASFunction;
        var _getMaxScroll:ASFunction;
        var _onComplete:ASFunction;
        var _scrollStep:Float = DEFAULT_SCROLL_STEP;
        var _duration:Float = DEFAULT_MAX_DURATION_MS;
        var _minDuration:Float = 100;
        var _normalizeToMaxScroll:Bool = true;
        var _clampToBounds:Bool = true;
        var _timer:Timer;
        var _timerInterval:Float = 1000 / 60;
        var _startPosition:Float = 0;
        var _targetPosition:Float = 0;
        var _startTime:Float = 0;
        var _endTime:Float = 0;
        var _curveControlY1:Float = 0;

        public function new(getPosition:ASFunction, setPosition:ASFunction, getMaxScroll:ASFunction, duration:Float=DEFAULT_MAX_DURATION_MS, frameRate:Int=60, normalizeToMaxScroll:Bool=true, onComplete:ASFunction=null, scrollStep:Float=null, clampToBounds:Bool=true)
{
            if (scrollStep == null) scrollStep = Math.NaN;
            if (!Math.isNaN(scrollStep))
            {
                this._scrollStep = scrollStep;
            }
            this.duration = duration;
            this._normalizeToMaxScroll = normalizeToMaxScroll;
            this._clampToBounds = clampToBounds;
            this._onComplete = onComplete;
            this._getPosition = getPosition;
            this._setPosition = setPosition;
            this._getMaxScroll = getMaxScroll;
            this._timer = new Timer(this._timerInterval = Std.int(1000 / frameRate));
            this._timer.addEventListener(TimerEvent.TIMER, (this.updateScrolling : ASAny));
        }

        static function getBezierValue(k:Float, x1:Float, y1:Float, x2:Float, y2:Float):Float
        {
            k = clamp(k, 0, 1);
            var t= solveCurveTForX(k, x1, x2);
            return sampleCurve(t, y1, y2);
        }

        static function getBezierSlope(k:Float, x1:Float, y1:Float, x2:Float, y2:Float):Float
        {
            k = clamp(k, 0, 1);
            var t= solveCurveTForX(k, x1, x2);
            var dx= sampleCurveDerivative(t, x1, x2);
            if (Math.abs(dx) < CURVE_EPSILON)
            {
                return 0;
            }
            return sampleCurveDerivative(t, y1, y2) / dx;
        }

        static function solveCurveTForX(k:Float, x1:Float, x2:Float):Float
        {
var i = 0;            var i = 0;
            var x = Math.NaN;
            var slope = Math.NaN;
            var t= k;
            for (_tmp_ in 0...NEWTON_ITERATIONS)
            {
i= _tmp_;
                x = sampleCurve(t, x1, x2) - k;
                if (Math.abs(x) < CURVE_EPSILON)
                {
                    return t;
                }
                slope = sampleCurveDerivative(t, x1, x2);
                if (Math.abs(slope) < CURVE_EPSILON)
                {
                    break;
                }
                t = t - (x / slope);
            }
            var low:Float = 0;
            var high:Float = 1;
            t = k;
            for (_tmp_ in 0...BINARY_SEARCH_ITERATIONS)
            {
i= _tmp_;
                x = sampleCurve(t, x1, x2);
                if (Math.abs(x - k) < CURVE_EPSILON)
                {
                    return t;
                }
                if (x > k)
                {
                    high = t;
                }
                else
                {
                    low = t;
                }
                t = (high + low) * 0.5;
            }
            return t;
        }

        static function sampleCurve(k:Float, c1:Float, c2:Float):Float
        {
            return (((getCurveA(c1, c2) * k) + getCurveB(c1, c2)) * k + getCurveC(c1)) * k;
        }

        static function sampleCurveDerivative(k:Float, c1:Float, c2:Float):Float
        {
            return ((3 * getCurveA(c1, c2) * k * k) + (2 * getCurveB(c1, c2) * k) + getCurveC(c1));
        }

        static function getCurveA(c1:Float, c2:Float):Float
        {
            return (1 - (3 * c2) + (3 * c1));
        }

        static function getCurveB(c1:Float, c2:Float):Float
        {
            return ((3 * c2) - (6 * c1));
        }

        static function getCurveC(c1:Float):Float
        {
            return (3 * c1);
        }

        static function clamp(k:Float, min:Float, max:Float):Float
        {
            if (k < min)
            {
                return min;
            }
            if (k > max)
            {
                return max;
            }
            return k;
        }

        public function dispose()
        {
            this.stop();
            if (this._timer != null)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, (this.updateScrolling : ASAny));
                this._timer = null;
            }
            this._getPosition = null;
            this._setPosition = null;
            this._getMaxScroll = null;
            this._onComplete = null;
        }

        
        public var duration(get,set):Float;
public function  get_duration():Float
        {
            return this._duration;
        }
public function  set_duration(k:Float):Float        {
            if (!Math.isFinite(k) || k <= 0)
            {
                k = DEFAULT_MAX_DURATION_MS;
            }
            this._duration = k;
            this._minDuration = k * INVERSE_DELTA_MIN_DURATION_SCALE;
return k;
        }

        public var isScrolling(get,never):Bool;
public function  get_isScrolling():Bool
        {
            return (this._timer != null) && this._timer.running;
        }

        public function adjustStartPosition(k:Float)
        {
            if (!this.isScrolling || !Math.isFinite(k) || k == 0)
            {
                return;
            }
            this._startPosition = this.clampPosition(this._startPosition + k);
            this._targetPosition = this.clampPosition(this._targetPosition + k);
        }

        public function scrollWithWheel(k:Float):Bool
        {
            return this.scrollBySteps(k);
        }

        public function scrollBySteps(k:Float):Bool
        {
            if (!Math.isFinite(k) || k == 0)
            {
                return false;
            }
            var maxScroll= this.getMaxScroll();
            if (this._normalizeToMaxScroll && (!Math.isFinite(maxScroll) || maxScroll <= 0))
            {
                this.stop();
                return false;
            }
            var delta= this.wheelDeltaToScrollDelta(k, maxScroll);
            if (!Math.isFinite(delta) || delta == 0)
            {
                return false;
            }
            var now:Float = flash.Lib.getTimer();
            var current= this.getPosition();
            var target= this.clampPosition((this.isScrolling ? this._targetPosition : current) + delta);
            if ((Math.abs(target - current) < CURVE_EPSILON) && (!this.isScrolling || Math.abs(target - this._targetPosition) < CURVE_EPSILON))
            {
                if (target != current)
                {
                    this.setPosition(target);
                    this.stop();
                    return true;
                }
                this.stop();
                return false;
            }
            if (this.isScrolling)
            {
                this.updateTarget(now, target);
            }
            else
            {
                this.startAnimation(now, current, target);
            }
            if (this._endTime <= this._startTime)
            {
                this.complete();
                return false;
            }
            this._timer.reset();
            this._timer.start();
            this.applyPositionAt(now + this._timerInterval);
            return true;
        }

        public function stop()
        {
            this.stopInternal(false);
        }

        public function complete()
        {
            if (this._endTime > this._startTime)
            {
                this.setPosition(this.clampPosition(this._targetPosition));
            }
            this.stopInternal(true);
        }

        function stopInternal(complete:Bool)
        {
            if (this._timer == null)
            {
                return;
            }
            var wasRunning= this._timer.running;
            this._timer.reset();
            this._startTime = 0;
            this._endTime = 0;
            this._startPosition = 0;
            this._targetPosition = 0;
            this._curveControlY1 = 0;
            if (complete && wasRunning && this._onComplete != null)
            {
                this._onComplete();
            }
        }

        function startAnimation(now:Float, start:Float, target:Float)
        {
            this._startPosition = this.clampPosition(start);
            this._targetPosition = this.clampPosition(target);
            this._curveControlY1 = 0;
            this._startTime = now;
            this._endTime = now + this.getInverseDeltaDurationMs(this._targetPosition - this._startPosition);
        }

        function updateTarget(now:Float, target:Float)
        {
            target = this.clampPosition(target);
            if (Math.abs(this._targetPosition - target) < CURVE_EPSILON)
            {
                this._targetPosition = target;
                return;
            }
            var current= this.getValueAt(now);
            var delta= target - current;
            if (Math.abs(delta) < CURVE_EPSILON)
            {
                this._startPosition = current;
                this._targetPosition = target;
                this._startTime = now;
                this._endTime = now;
                return;
            }
            if ((this._endTime - this._startTime) <= CURVE_EPSILON)
            {
                this.startAnimation(now, current, target);
                return;
            }
            var velocity= this.calculateVelocity(now);
            var duration= this.getBoundedDurationMs(delta, velocity);
            if (!Math.isFinite(duration) || duration < CURVE_EPSILON)
            {
                this._startPosition = current;
                this._targetPosition = target;
                this._startTime = now;
                this._endTime = now;
                return;
            }
            var slope= velocity * (duration / delta);
            slope = clamp(slope, -MAX_SLOPE, MAX_SLOPE);
            this._curveControlY1 = slope * CURVE_X1;
            this._startPosition = current;
            this._targetPosition = target;
            this._startTime = now;
            this._endTime = now + duration;
        }

        function updateScrolling(k:TimerEvent)
        {
            this.applyPositionAt(flash.Lib.getTimer());
        }

        function applyPositionAt(k:Float)
        {
            this.setPosition(this.getValueAt(k));
            if (k >= this._endTime || ((this._endTime - this._startTime) <= CURVE_EPSILON))
            {
                this.complete();
            }
        }

        function wheelDeltaToScrollDelta(delta:Float, maxScroll:Float):Float
        {
            if (this._normalizeToMaxScroll)
            {
                return ((-delta * this._scrollStep) / maxScroll);
            }
            return (-delta * this._scrollStep);
        }

        function getInverseDeltaDurationMs(k:Float):Float
        {
            var distance= Math.abs(k);
            var result= this._duration;
            if (distance > INVERSE_DELTA_RAMP_START_PX)
            {
                result = result + ((distance - INVERSE_DELTA_RAMP_START_PX) * (this._minDuration - this._duration) / (INVERSE_DELTA_RAMP_END_PX - INVERSE_DELTA_RAMP_START_PX));
            }
            return clamp(result, this._minDuration, this._duration);
        }

        function getBoundedDurationMs(delta:Float, velocity:Float):Float
        {
            return Math.min(this.getInverseDeltaDurationMs(delta), this.getVelocityBasedDurationBoundMs(delta, velocity));
        }

        function getVelocityBasedDurationBoundMs(delta:Float, velocity:Float):Float
        {
            if (Math.abs(delta) < CURVE_EPSILON)
            {
                return 0;
            }
            if (Math.abs(velocity) < CURVE_EPSILON)
            {
                return ASCompat.MAX_FLOAT;
            }
            var result= (delta / velocity) * VELOCITY_BOUND_FUDGE;
            return (result < 0) ? ASCompat.MAX_FLOAT : result;
        }

        function getValueAt(k:Float):Float
        {
            var duration= this._endTime - this._startTime;
            if (duration <= CURVE_EPSILON || k >= this._endTime)
            {
                return this._targetPosition;
            }
            if (k <= this._startTime)
            {
                return this._startPosition;
            }
            var progress= (k - this._startTime) / duration;
            var eased= getBezierValue(progress, CURVE_X1, this._curveControlY1, CURVE_X2, CURVE_Y2);
            return this._startPosition + ((this._targetPosition - this._startPosition) * eased);
        }

        function calculateVelocity(k:Float):Float
        {
            var duration= this._endTime - this._startTime;
            if (duration <= CURVE_EPSILON)
            {
                return 0;
            }
            var progress= clamp((k - this._startTime) / duration, 0, 1);
            var slope= getBezierSlope(progress, CURVE_X1, this._curveControlY1, CURVE_X2, CURVE_Y2);
            return slope * ((this._targetPosition - this._startPosition) / duration);
        }

        function getPosition():Float
        {
            return ASCompat.toNumber(this._getPosition());
        }

        function setPosition(k:Float)
        {
            this._setPosition(k);
        }

        function getMaxScroll():Float
        {
            return ASCompat.toNumber(this._getMaxScroll());
        }

        function clampPosition(k:Float):Float
        {
            if (!this._clampToBounds || !Math.isFinite(k))
            {
                return k;
            }
            var maxPosition= this.getMaxPosition();
            if (!Math.isFinite(maxPosition))
            {
                return k;
            }
            return clamp(k, 0, maxPosition);
        }

        function getMaxPosition():Float
        {
            var maxScroll = Math.NaN;
            if (this._normalizeToMaxScroll)
            {
                return 1;
            }
            maxScroll = this.getMaxScroll();
            if (!Math.isFinite(maxScroll) || maxScroll < 0)
            {
                return Math.NaN;
            }
            return maxScroll;
        }
    }

