package com.sulake.room.object.visualization.utils
;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.display.BitmapData;

     interface IGraphicAssetCollection 
    {
        function dispose():Void;
        var assetLibrary(never,set):IAssetLibrary;
        function _Str_9215():Void;
        function _Str_19942():Void;
        function _Str_20679():Int;
        function _Str_21431():Int;
        function _Str_13182(_arg_1:com.sulake.core.utils.xml.XML):Bool;
        function getAsset(_arg_1:String):IGraphicAsset;
        function getAssetWithPalette(_arg_1:String, _arg_2:String):IGraphicAsset;
        function _Str_21825():Array<ASAny>;
        function _Str_20963(_arg_1:String):Array<ASAny>;
        function _Str_17888(_arg_1:String):com.sulake.core.utils.xml.XML;
        function addAsset(_arg_1:String, _arg_2:BitmapData, _arg_3:Bool, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Bool=false, _arg_7:Bool=false):Bool;
        function disposeAsset(_arg_1:String):Void;
    }

