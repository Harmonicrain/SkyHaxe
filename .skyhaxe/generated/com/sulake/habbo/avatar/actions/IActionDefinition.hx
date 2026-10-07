package com.sulake.habbo.avatar.actions
;
     interface IActionDefinition 
    {
        var id(get,never):String;
        var state(get,never):String;
        var precedence(get,never):Int;
        var activePartSet(get,never):String;
        var isMain(get,never):Bool;
        var isDefault(get,never):Bool;
        var assetPartDefinition(get,never):String;
        var lay(get,never):String;
        var geometryType(get,never):String;
        var isAnimation(get,never):Bool;
        var startFromFrameZero(get,never):Bool;
        function isAnimated(_arg_1:String):Bool;
        function getPrevents(_arg_1:String=""):Array<ASAny>;
        function getPreventHeadTurn(_arg_1:String=""):Bool;
        function setOffsets(_arg_1:String, _arg_2:Int, _arg_3:Array<ASAny>):Void;
        function getOffsets(_arg_1:String, _arg_2:Int):Array<ASAny>;
    }

