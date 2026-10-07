package com.sulake.habbo.gamecenter
;
    import flash.display.BitmapData;

     interface IGameRewardListener 
    {
        function setGameRewardName(_arg_1:String):Void;
        function setGameRewardImage(_arg_1:BitmapData):Void;
        function setTimeRemaining(_arg_1:Int):Void;
        function getCurrentlySelectedGame():Int;
        function setRewardingOn(_arg_1:Bool):Void;
    }

