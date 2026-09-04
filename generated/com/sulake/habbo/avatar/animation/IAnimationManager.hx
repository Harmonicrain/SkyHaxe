package com.sulake.habbo.avatar.animation
;

     interface IAnimationManager 
    {
        var animations(get,never):ASDictionary<ASAny,ASAny>;
        function getAnimation(_arg_1:String):IAnimation;
        function getLayerData(_arg_1:String, _arg_2:Int, _arg_3:String):IAnimationLayerData;
    }

