package com.sulake.room.object.visualization.utils
;
    import com.sulake.core.assets.IAsset;

     interface IGraphicAsset 
    {
        var flipV(get,never):Bool;
        var flipH(get,never):Bool;
        var width(get,never):Int;
        var height(get,never):Int;
        var asset(get,never):IAsset;
        var assetName(get,never):String;
        var libraryAssetName(get,never):String;
        var offsetX(get,never):Int;
        var offsetY(get,never):Int;
        var _Str_20249(get,never):Int;
        var _Str_19351(get,never):Int;
        var usesPalette(get,never):Bool;
    }

