package com.sulake.habbo.avatar.structure.figure
;

     interface IPalette 
    {
        var id(get,never):Int;
        function getColor(_arg_1:Int):IPartColor;
        var colors(get,never):ASDictionary<ASAny,ASAny>;
    }

