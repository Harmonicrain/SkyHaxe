package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.avatar.structure.IStructureData;
    import com.sulake.core.assets.IAsset;
    import com.sulake.habbo.avatar.animation.IAnimationManager;
    import flash.events.IEventDispatcher;

     interface IAvatarRenderManager extends IUnknown 
    {
        function createAvatarImage(_arg_1:String, _arg_2:String, _arg_3:String=null, _arg_4:IAvatarImageListener=null, _arg_5:_Str_936=null):IAvatarImage;
        var assets(get,never):IAssetLibrary;
        function _Str_813():IStructureData;
        function getFigureStringWithFigureIds(_arg_1:String, _arg_2:String, _arg_3:Vector<Int>):String;
        function isValidFigureSetForGender(_arg_1:Int, _arg_2:String):Bool;
        function _Str_838(_arg_1:String, _arg_2:Int):Array<ASAny>;
        function getAssetByName(_arg_1:String):IAsset;
                var mode(get,set):String;
        function _Str_882(_arg_1:com.sulake.core.utils.xml.XML):Void;
        function _Str_718(_arg_1:String):IAvatarFigureContainer;
        function _Str_961(_arg_1:IAvatarFigureContainer):Bool;
        function _Str_889(_arg_1:IAvatarFigureContainer, _arg_2:IAvatarImageListener):Void;
        function _Str_723():IAnimationManager;
        var events(get,never):IEventDispatcher;
        function resetAssetManager():Void;
        function _Str_932(_arg_1:IAvatarFigureContainer, _arg_2:String, _arg_3:Array<ASAny>=null):Int;
        function _Str_672():Array<ASAny>;
        var _Str_906(get,never):ASDictionary<ASAny,ASAny>;
    }

