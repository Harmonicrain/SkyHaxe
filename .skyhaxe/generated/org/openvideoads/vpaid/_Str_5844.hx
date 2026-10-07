package org.openvideoads.vpaid
;
     interface _Str_5844 
    {
        var adLinear(get,never):Bool;
        var _Str_25601(get,never):Float;
        var _Str_23482(get,never):Float;
        var adExpanded(get,never):Bool;
        var adRemainingTime(get,never):Float;
                var adVolume(get,set):Float;
        var adDuration(get,never):Float;
        var adSkippableState(get,never):Bool;
        var adCompanions(get,never):String;
        var adIcons(get,never):Bool;
        function handshakeVersion(_arg_1:String):String;
        function initAd(_arg_1:Float, _arg_2:Float, _arg_3:String, _arg_4:Float, _arg_5:String, _arg_6:String):Void;
        function resizeAd(_arg_1:Float, _arg_2:Float, _arg_3:String):Void;
        function startAd():Void;
        function stopAd():Void;
        function pauseAd():Void;
        function resumeAd():Void;
        function expandAd():Void;
        function collapseAd():Void;
        function skipAd():Void;
    }

