package com.sulake.habbo.catalog.recycler
;
     interface IRecycler 
    {
        function init(_arg_1:_Str_7232=null):Void;
        function cancel():Void;
        function empty():Void;
        function _Str_18924(_arg_1:Int):_Str_3718;
        function placeObjectAtSlot(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String):Void;
        function releaseSlot(_arg_1:Int):Void;
        function executeRecycler():Void;
        function isReadyToRecycle():Bool;
        function getPrizeTable():Array<ASAny>;
        var numberOfSlots(get,never):Int;
    }

