package com.sulake.room.utils
;

     class RoomEnterEffect 
    {
        public static inline final STATE_NOT_INITIALIZED= 0;
        public static inline final STATE_START_DELAY= 1;
        public static inline final STATE_RUNNING= 2;
        public static inline final STATE_OVER= 3;
        static var _state:Int = STATE_NOT_INITIALIZED;//0
        static var _visualizationOn:Bool = false;
        static var _currentDelta:Float = Math.NaN;
        static var _initializationTimeMs:Int = 0;
        static var _startDelayMs:Int = (20 * 1000);//20000
        static var _effectDurationMs:Int = 2000;


        public static function init(k:Int, _arg_2:Int)
        {
            _currentDelta = 0;
            _startDelayMs = k;
            _effectDurationMs = _arg_2;
            _initializationTimeMs = flash.Lib.getTimer();
            _state = STATE_START_DELAY;
        }

        public static function turnVisualizationOn()
        {
            if (((_state == STATE_NOT_INITIALIZED) || (_state == STATE_OVER)))
            {
                return;
            }
            var k= (flash.Lib.getTimer() - _initializationTimeMs);
            if (k > (_startDelayMs + _effectDurationMs))
            {
                _state = STATE_OVER;
                return;
            }
            _visualizationOn = true;
            if (k < _startDelayMs)
            {
                _state = STATE_START_DELAY;
                return;
            }
            _state = STATE_RUNNING;
            _currentDelta = ((k - _startDelayMs) / _effectDurationMs);
        }

        public static function turnVisualizationOff()
        {
            _visualizationOn = false;
        }

        public static function isVisualizationOn():Bool
        {
            return _visualizationOn && isRunning();
        }

        public static function isRunning():Bool
        {
            if (((_state == STATE_START_DELAY) || (_state == STATE_RUNNING)))
            {
                return true;
            }
            return false;
        }

        public static function getDelta(k:Float=0, _arg_2:Float=1):Float
        {
            return Math.min(Math.max(_currentDelta, k), _arg_2);
        }

        public static var totalRunningTime(get,never):Int;
public static function  get_totalRunningTime():Int
        {
            return _startDelayMs + _effectDurationMs;
        }

	public function new() {}
    }

