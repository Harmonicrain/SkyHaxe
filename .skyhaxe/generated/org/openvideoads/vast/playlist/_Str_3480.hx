package org.openvideoads.vast.playlist
;
    import org.openvideoads.vast.schedule.Stream;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;

     interface _Str_3480 
    {
                var stream(get,set):Stream;
                var index(get,set):Int;
                var provider(get,set):String;
                var providers(get,set):ProvidersConfigGroup;
                var streamer(get,set):String;
        var title(get,never):String;
        var link(get,never):String;
        var description(get,never):String;
                var filename(get,set):String;
                var url(get,set):String;
                var mimeType(get,set):String;
        var loadOnDemand(get,never):Bool;
        function _Str_16634():Bool;
        function isInteractive():Bool;
        function _Str_5059(_arg_1:Bool=true):String;
        function getQualifiedStreamAddress():String;
        var duration(get,never):String;
        function _Str_17310():Int;
        function _Str_24674():String;
        function getStartTimeAsSeconds():Int;
        function _Str_17397():String;
        function getType():String;
        function _Str_21970():String;
        function toString(_arg_1:Bool=false):String;
        function toShowStreamConfigObject():ASObject;
        function isRTMP():Bool;
        function _Str_25252():Bool;
        function reset():Void;
        function rewind():Void;
        function _Str_10174():Bool;
        function _Str_22734():Bool;
    }

