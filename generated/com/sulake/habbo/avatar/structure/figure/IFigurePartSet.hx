package com.sulake.habbo.avatar.structure.figure
;
     interface IFigurePartSet 
    {
        function getPart(_arg_1:String, _arg_2:Int):IFigurePart;
        var type(get,never):String;
        var id(get,never):Int;
        var gender(get,never):String;
        var clubLevel(get,never):Int;
        var isColorable(get,never):Bool;
        var isSelectable(get,never):Bool;
        var isPreSelectable(get,never):Bool;
        var isSellable(get,never):Bool;
        var parts(get,never):Array<ASAny>;
        var hiddenLayers(get,never):Array<ASAny>;
    }

