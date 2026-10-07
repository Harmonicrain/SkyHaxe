package com.sulake.habbo.tracking
;
    import com.sulake.core.utils.debug.GarbageMonitor;
    import flash.system.Capabilities;
    import flash.external.ExternalInterface;
    import flash.system.System;
    import com.sulake.habbo.communication.messages.outgoing.tracking.PerformanceLogMessageComposer;

     class PerformanceTracker 
    {
        var _counter:Int = 0;
        var _averageUpdateInterval:Float = 0;
        var _userAgent:String = "";
        var _flashVersion:String = "";
        var _operatingSystem:String = "";
        var _cpuArchitecture:String = "";
        var _isDebugger:Bool = false;
        var _garbageMonitor:GarbageMonitor = null;
        var _gcCount:Int = 0;
        var _slowUpdateCount:Int = 0;
        var _lastReport:Int = 0;
        var _reportCount:Int = 0;
        var _lastAverage:Float = 0;
        var _habboTracking:HabboTracking;

        public function new(k:HabboTracking)
        {
            this._habboTracking = k;
            this._flashVersion = Capabilities.version;
            this._operatingSystem = Capabilities.os;
            this._isDebugger = Capabilities.isDebugger;
            try
            {
                this._userAgent = (ExternalInterface.available ? ExternalInterface.call("window.navigator.userAgent.toString") : "unknown");
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }            if (this._userAgent == null)
            {
                this._userAgent = "unknown";
            }
            this._garbageMonitor = new GarbageMonitor();
            this.updateGarbageMonitor();
            this._lastReport = flash.Lib.getTimer();
        }

        static function differenceInPercents(k:Float, _arg_2:Float):Float
        {
            if (k == _arg_2)
            {
                return 0;
            }
            var _local_3= k;
            var _local_4= _arg_2;
            if (_arg_2 > k)
            {
                _local_3 = _arg_2;
                _local_4 = k;
            }
            return 100 * (1 - (_local_4 / _local_3));
        }


        public var flashVersion(get,never):String;
public function  get_flashVersion():String
        {
            return this._flashVersion;
        }

        public var averageUpdateInterval(get,never):Int;
public function  get_averageUpdateInterval():Int
        {
            return Std.int(this._averageUpdateInterval);
        }

        function updateGarbageMonitor():ASObject
        {
            var _local_2:ASObject = null;
            var k= this._garbageMonitor.list;
            if (((k == null) || (k.length == 0)))
            {
                _local_2 = new GarbageTester("tester");
                this._garbageMonitor.insert(_local_2, "tester");
                return _local_2;
            }
            return null;
        }

        public function update(k:UInt, _arg_2:Int)
        {
            var _local_4:ASObject = null;
            var _local_5 = Math.NaN;
            var _local_6:UInt = 0;
            var _local_7 = false;
            var _local_8 = Math.NaN;
            if (this.isGarbageMonitored)
            {
                _local_4 = this.updateGarbageMonitor();
                if (_local_4 != null)
                {
                    this._gcCount++;
                    Logger.log(["Garbage collection"]);
                }
            }
            var _local_3 = false;
            if (k > (this.slowUpdateLimit : UInt))
            {
                this._slowUpdateCount++;
                _local_3 = true;
            }
            else
            {
                this._counter++;
                if (this._counter <= 1)
                {
                    this._averageUpdateInterval = k;
                }
                else
                {
                    _local_5 = this._counter;
                    this._averageUpdateInterval = (((this._averageUpdateInterval * (_local_5 - 1)) / _local_5) + (k / _local_5));
                }
            }
            if ((((_arg_2 - this._lastReport) > (this.reportInterval * 1000)) && (this._reportCount < this.reportLimit)))
            {
                _local_6 = System.totalMemory;
                Logger.log([(((("*** Performance tracker: average frame rate " + Std.string(1000 / this._averageUpdateInterval)) + "/s, system memory usage : ") + Std.string(_local_6)) + " bytes")]);
                _local_7 = true;
                if ((this.useDistribution && (this._reportCount > 0)))
                {
                    _local_8 = differenceInPercents(this._lastAverage, this._averageUpdateInterval);
                    if (_local_8 < this.meanDevianceLimit)
                    {
                        _local_7 = false;
                    }
                }
                this._lastReport = _arg_2;
                if ((_local_7 || _local_3))
                {
                    this._lastAverage = this._averageUpdateInterval;
                    this.sendReport(_arg_2);
                    this._reportCount++;
                }
            }
        }

        function sendReport(k:Int)
        {
            var _local_2= Std.int(k / 1000);
            var _local_3= -1;
            var _local_4= Std.int(System.totalMemory / 0x0400);
            this._habboTracking.send(new PerformanceLogMessageComposer(_local_2, this._userAgent, this._flashVersion, this._operatingSystem, this._cpuArchitecture, this._isDebugger, _local_4, _local_3, this._gcCount, Std.int(this._averageUpdateInterval), this._slowUpdateCount));
            this._gcCount = 0;
            this._averageUpdateInterval = 0;
            this._counter = 0;
            this._slowUpdateCount = 0;
        }

        var isGarbageMonitored(get,never):Bool;
function  get_isGarbageMonitored():Bool
        {
            return this._habboTracking.getBoolean("monitor.garbage.collection");
        }

        var slowUpdateLimit(get,never):Int;
function  get_slowUpdateLimit():Int
        {
            return this._habboTracking.getInteger("performancetest.slowupdatelimit", 1000);
        }

        var reportInterval(get,never):Int;
function  get_reportInterval():Int
        {
            return this._habboTracking.getInteger("performancetest.interval", 60);
        }

        var reportLimit(get,never):Int;
function  get_reportLimit():Int
        {
            return this._habboTracking.getInteger("performancetest.reportlimit", 10);
        }

        var meanDevianceLimit(get,never):Float;
function  get_meanDevianceLimit():Float
        {
            return this._habboTracking.propertyExists("performancetest.distribution.deviancelimit.percent") ? ASCompat.toNumber(this._habboTracking.getProperty("performancetest.distribution.deviancelimit.percent")) : 10;
        }

        var useDistribution(get,never):Bool;
function  get_useDistribution():Bool
        {
            return this._habboTracking.getBoolean("performancetest.distribution.enabled");
        }
    }

