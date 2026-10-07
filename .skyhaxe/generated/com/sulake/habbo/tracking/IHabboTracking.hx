package com.sulake.habbo.tracking
;
    import com.sulake.core.runtime.IUnknown;

     interface IHabboTracking extends IUnknown 
    {
        function trackGoogle(_arg_1:String, _arg_2:String, _arg_3:Int=-1):Void;
        function legacyTrackGoogle(_arg_1:String, _arg_2:String, _arg_3:Array<ASAny>=null):Void;
        function logError(_arg_1:String):Void;
        function chatLagDetected(_arg_1:Int):Void;
        function trackEventLog(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:Int=0):Void;
        function trackEventLogOncePerSession(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:Int=0):Void;
        function trackTalentTrackOpen(_arg_1:String, _arg_2:String):Void;
    }

