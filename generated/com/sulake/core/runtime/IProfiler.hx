package com.sulake.core.runtime
;
    import com.sulake.core.utils.profiler.ProfilerAgent;

     interface IProfiler 
    {
        function getProfilerAgentForReceiver(_arg_1:IUpdateReceiver):ProfilerAgent;
        function getProfilerAgentsInArray():Array<ASAny>;
        function addStartEventListener(_arg_1:ASFunction):Void;
        function addStopEventListener(_arg_1:ASFunction):Void;
        function removeStartEventListener(_arg_1:ASFunction):Void;
        function removeStopEventListener(_arg_1:ASFunction):Void;
        function gc():Void;
        var numAssetLibraryInstances(get,never):UInt;
        var numBitmapAssetInstances(get,never):UInt;
        var numAllocatedBitmapDataBytes(get,never):UInt;
        var numTrackedBitmapDataInstances(get,never):UInt;
        var numTrackedBitmapDataBytes(get,never):UInt;
    }

