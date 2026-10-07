package com.sulake.habbo.catalog.purse
;
     interface IPurse 
    {
                var credits(get,set):Int;
                var clubDays(get,set):Int;
                var clubPeriods(get,set):Int;
                var isExpiring(get,set):Bool;
        var minutesUntilExpiration(get,never):Int;
        var hasClubLeft(get,never):Bool;
        var isVIP(get,never):Bool;
        var pastClubDays(get,never):Int;
        var pastVipDays(get,never):Int;
        function getActivityPointsForType(_arg_1:Int):Int;
    }

