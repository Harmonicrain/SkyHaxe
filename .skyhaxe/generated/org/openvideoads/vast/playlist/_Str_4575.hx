package org.openvideoads.vast.playlist
;
    import org.openvideoads.vast.schedule.Stream;

     interface _Str_4575 
    {
        function _Str_16925(_arg_1:String, _arg_2:_Str_6835=null):Void;
        function loadFromString(_arg_1:String):Void;
        function newPlaylistItem():_Str_3480;
        function _Str_24277(_arg_1:Stream, _arg_2:Int):Void;
        function getModel():Array<ASAny>;
        function reset():Void;
        function rewind():Void;
        var _Str_24840(get,never):Int;
        var _Str_23049(get,never):Int;
        function _Str_23946(_arg_1:Int=0, _arg_2:Bool=false):com.sulake.core.utils.xml.XML;
        function _Str_18453(_arg_1:Bool=false, _arg_2:Bool=true):String;
        function _Str_22737(_arg_1:Bool=false):com.sulake.core.utils.xml.XML;
        function _Str_18213(_arg_1:Bool=false):String;
        function _Str_22903(_arg_1:Bool=false):com.sulake.core.utils.xml.XML;
        function _Str_11606(_arg_1:Int):_Str_3480;
        function _Str_24195():Bool;
        var length(get,never):Int;
        function _Str_10087():Array<ASAny>;
        function _Str_23134(_arg_1:Bool=false):com.sulake.core.utils.xml.XML;
        function toShortString(_arg_1:Bool=false):String;
        function toString(_arg_1:Bool=false):String;
    }

