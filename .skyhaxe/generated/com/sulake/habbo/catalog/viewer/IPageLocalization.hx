package com.sulake.habbo.catalog.viewer
;
     interface IPageLocalization 
    {
        var imageCount(get,never):Int;
        var textCount(get,never):Int;
        function getTextElementName(_arg_1:Int, _arg_2:String):String;
        function getImageElementName(_arg_1:Int, _arg_2:String):String;
        function getTextElementContent(_arg_1:Int):String;
        function getImageElementContent(_arg_1:Int):String;
        function dispose():Void;
        function hasLinks(_arg_1:String):Bool;
        function _Str_20312(_arg_1:String):Array<ASAny>;
        function _Str_22305(_arg_1:Int):UInt;
    }

