package org.openvideoads.vast.server.response
;
    import org.openvideoads.vast.server.request.AdServerRequest;
    import flash.events.Event;
    import org.openvideoads.vast.analytics._Str_2408;

     interface _Str_3802 
    {
        function onAdCallStarted(_arg_1:AdServerRequest):Void;
        function onAdCallFailover(_arg_1:AdServerRequest, _arg_2:AdServerRequest):Void;
        function onAdCallComplete(_arg_1:AdServerRequest, _arg_2:Bool):Void;
        function onTemplateLoaded(_arg_1:AdServerTemplate):Void;
        function onTemplateLoadError(_arg_1:Event):Void;
        function _Str_5807(_arg_1:Event):Void;
        function _Str_5916(_arg_1:Event):Void;
        var analyticsProcessor(get,never):_Str_2408;
        var uid(get,never):String;
    }

