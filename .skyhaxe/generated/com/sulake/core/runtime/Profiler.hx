package com.sulake.core.runtime
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IProfiler;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.utils.profiler.tracking.TrackedBitmapData;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.Event;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.core.utils.profiler.ProfilerAgent;
    import com.sulake.core.runtime.*;

    /*internal*/ class Profiler extends Component implements IProfiler 
    {
        public static inline final PROFILER_START= "PROFILER_START";
        public static inline final PROFILER_STOP= "PROFILER_STOP";

        var _profilersByReceiver:ASDictionary<ASAny,ASAny>;
        var _startTime:Int = 0;
        var _roundTime:Int = 0;

        public function new(k:IContext)
        {
            this._profilersByReceiver = new ASDictionary<ASAny,ASAny>(true);
            super(k, 0, null);
        }

        public var numAssetLibraryInstances(get,never):UInt;
public function  get_numAssetLibraryInstances():UInt
        {
            return AssetLibrary.numAssetLibraryInstances;
        }

        public var numBitmapAssetInstances(get,never):UInt;
public function  get_numBitmapAssetInstances():UInt
        {
            return BitmapDataAsset.instances;
        }

        public var numAllocatedBitmapDataBytes(get,never):UInt;
public function  get_numAllocatedBitmapDataBytes():UInt
        {
            return BitmapDataAsset.allocatedByteCount;
        }

        public var numTrackedBitmapDataInstances(get,never):UInt;
public function  get_numTrackedBitmapDataInstances():UInt
        {
            return TrackedBitmapData.numInstances;
        }

        public var numTrackedBitmapDataBytes(get,never):UInt;
public function  get_numTrackedBitmapDataBytes():UInt
        {
            return TrackedBitmapData.allocatedByteCount;
        }

        override public function dispose()
        {
var k:ASObject  = null;            var k:ASObject = null;
            if (!disposed)
            {
                final _iter_ = this._profilersByReceiver; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    cast(this._profilersByReceiver[k], IDisposable).dispose();
                    this._profilersByReceiver.remove(k);
                }
                super.dispose();
            }
        }

        public function gc()
        {
ASCompat.pauseForGCIfCollectionImminent(0.25);
        }

        public function start()
        {
            events.dispatchEvent(new Event(PROFILER_START, false, false));
            this._startTime = flash.Lib.getTimer();
        }

        public function stop()
        {
            this._roundTime = (flash.Lib.getTimer() - this._startTime);
            events.dispatchEvent(new Event(PROFILER_STOP, false, false));
        }

        public function update(k:IUpdateReceiver, _arg_2:UInt)
        {
            this.getProfilerAgentForReceiver(k).update(ASCompat.toInt(_arg_2));
        }

        public var numProfilerAgents(get,never):UInt;
public function  get_numProfilerAgents():UInt
        {
var _local_2:ASObject  = null;            var _local_2:ASObject = null;
            var k:UInt = 0;
            final _iter_ = this._profilersByReceiver; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_2 = _tmp_;
                if (!cast(_local_2, IDisposable).disposed)
                {
                    k++;
                }
            }
            return k;
        }

        public function getProfilerAgentsInArray():Array<ASAny>
        {
var _local_3:ASObject  = null;            var _local_2:IUpdateReceiver = null;
            var _local_3:ASObject = null;
            var k= new Array<ASAny>();
            final _iter_ = this._profilersByReceiver; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
                _local_2 = ASCompat.dynamicAs(_local_3 , IUpdateReceiver);
                if (cast(_local_3, IDisposable).disposed)
                {
                    cast(this._profilersByReceiver[_local_3], IDisposable).dispose();
                    this._profilersByReceiver.remove(_local_3);
                }
                else
                {
                    k.push(this._profilersByReceiver[_local_3]);
                }
            }
            return k;
        }

        public function getProfilerAgentForReceiver(k:IUpdateReceiver):ProfilerAgent
        {
            var _local_2:ProfilerAgent = this._profilersByReceiver[k];
            return (_local_2 != null) ? _local_2 : this._Str_1324(k);
        }

        public function _Str_1324(updateReceiver:IUpdateReceiver):ProfilerAgent
        {
            if (this._profilersByReceiver[updateReceiver] != null)
            {
                throw new ASError("Profiler for receiver already exists!");
            }
            var _local_2= new ProfilerAgent(updateReceiver);
            this._profilersByReceiver[updateReceiver] = _local_2;
            return _local_2;
        }

        public function addStartEventListener(listener:ASFunction)
        {
            events.addEventListener(PROFILER_START, listener);
        }

        public function addStopEventListener(listener:ASFunction)
        {
            events.addEventListener(PROFILER_STOP, listener);
        }

        public function removeStartEventListener(listener:ASFunction)
        {
            events.removeEventListener(PROFILER_START, listener);
        }

        public function removeStopEventListener(listener:ASFunction)
        {
            events.removeEventListener(PROFILER_STOP, listener);
        }
    }

