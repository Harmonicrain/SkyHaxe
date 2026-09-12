package com.sulake.core.utils
;
    import flash.system.System;
    import com.sulake.core.Core;

     class PurgeTrigger 
    {
        static var _softPurgeTriggerMegaBytes:UInt = 300;
        static var _hardPurgeTriggerMegaBytes:UInt = 400;
        static var _frequencyMilliSeconds:UInt = (60 * 1000);//60000
        static var _running:Bool = false;


        
        public static var softPurgeTriggerMegaBytes(get,set):UInt;
public static function  get_softPurgeTriggerMegaBytes():UInt
        {
            return _softPurgeTriggerMegaBytes;
        }
public static function  set_softPurgeTriggerMegaBytes(k:UInt):UInt        {
            return _softPurgeTriggerMegaBytes = k;
        }

        
        public static var hardPurgeTriggerMegaBytes(get,set):UInt;
public static function  get_hardPurgeTriggerMegaBytes():UInt
        {
            return _hardPurgeTriggerMegaBytes;
        }
public static function  set_hardPurgeTriggerMegaBytes(limit:UInt):UInt        {
            _hardPurgeTriggerMegaBytes = Std.int(Math.max(limit, _softPurgeTriggerMegaBytes));
return limit;
        }

        
        public static var frequencyMilliSeconds(get,set):UInt;
public static function  get_frequencyMilliSeconds():UInt
        {
            return _frequencyMilliSeconds;
        }
public static function  set_frequencyMilliSeconds(limit:UInt):UInt        {
            return _frequencyMilliSeconds = limit;
        }

        public static var running(get,never):Bool;
public static function  get_running():Bool
        {
            return _running;
        }

        static var isMemoryDataAvailable(get,never):Bool;
static function  get_isMemoryDataAvailable():Bool
        {
            return (Player.majorVersion > 10) || ((Player.majorVersion == 10) && (Player.majorRevision >= 1));
        }

        public static function start()
        {
            if (!_running)
            {
                if (!isMemoryDataAvailable)
                {
                    _frequencyMilliSeconds = (_frequencyMilliSeconds * 2);
                    _softPurgeTriggerMegaBytes = 0;
                    _hardPurgeTriggerMegaBytes = ASCompat.MAX_INT;
                }
                ASCompat.setTimeout(onInterval, _frequencyMilliSeconds);
                _running = true;
            }
        }

        public static function stop()
        {
            if (_running)
            {
                _running = false;
            }
        }

        public static function trigger()
        {
            var timer = 0;
            var _local_4 = Math.NaN;
            var k:ASObject = System;
            var _local_2= (isMemoryDataAvailable ? ((ASCompat.toNumber(ASCompat.toNumber(k.totalMemory) - ASCompat.toNumber(k.freeMemory)) / 0x0400) / 0x0400) : (softPurgeTriggerMegaBytes + 1));
            if (_local_2 > softPurgeTriggerMegaBytes)
            {
                timer = flash.Lib.getTimer();
                Core.purge();
                _local_4 = (isMemoryDataAvailable ? ((ASCompat.toNumber(ASCompat.toNumber(k.totalMemory) - ASCompat.toNumber(k.freeMemory)) / 0x0400) / 0x0400) : 0);
                if (_local_4 > _hardPurgeTriggerMegaBytes)
                {
                    triggerGC();
                }
            }
        }

        public static function triggerGC()
        {
ASCompat.pauseForGCIfCollectionImminent(0.25);
        }

        static function onInterval()
        {
            if (_running)
            {
                trigger();
                ASCompat.setTimeout(onInterval, _frequencyMilliSeconds);
            }
        }

	public function new() {}
    }

