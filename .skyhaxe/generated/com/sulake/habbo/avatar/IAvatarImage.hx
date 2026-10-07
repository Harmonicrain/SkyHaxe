package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.IDisposable;
    import flash.display.BitmapData;
    import com.sulake.habbo.avatar.animation.ISpriteDataContainer;
    import com.sulake.habbo.avatar.animation.IAnimationLayerData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.avatar.structure.figure.IPartColor;
    import com.sulake.habbo.avatar.animation.IAvatarDataContainer;

     interface IAvatarImage extends IDisposable 
    {
function getCroppedImage(_arg_1:String, _arg_2:Float=1):BitmapData;
        function getImage(_arg_1:String, _arg_2:Bool, _arg_3:Float=1):BitmapData;
        function _Str_1009():Array<ASAny>;
        function setDirection(_arg_1:String, _arg_2:Int):Void;
        function setDirectionAngle(_arg_1:String, _arg_2:Int):Void;
        function _Str_953(_arg_1:Int=1):Void;
        function scale():String;
        function _Str_754():Array<ASAny>;
        function getLayerData(_arg_1:ISpriteDataContainer):IAnimationLayerData;
        function getAsset(_arg_1:String):BitmapDataAsset;
        function getDirection():Int;
        function _Str_784():IAvatarFigureContainer;
        function _Str_867(_arg_1:String):IPartColor;
        function isAnimating():Bool;
        function _Str_781():Array<ASAny>;
        function _Str_913():Void;
        function _Str_962():Void;
        function appendAction(_arg_1:String,  _args:Array<ASAny> = null):Bool;
        var AvatarDataContainer(get,never):IAvatarDataContainer;
        function isPlaceholder():Bool;
        function _Str_998():Void;
        var _Str_677(get,never):Bool;
        function _Str_833():Void;
        var _Str_792(get,never):String;
    }

