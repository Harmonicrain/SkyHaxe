package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IHabboQuestEngine extends IUnknown 
    {
        function isTrackerVisible():Bool;
        function ensureAchievementsInitialized():Void;
        function showAchievements():Void;
        function showQuests():Void;
        function getAchievementLevel(_arg_1:String, _arg_2:String):Int;
        function reenableRoomCompetitionWindow():Void;
        function requestSeasonalQuests():Void;
        function requestQuests():Void;
        var events(get,never):IEventDispatcher;
        function activateQuest(_arg_1:Int):Void;
        function goToQuestRooms():Void;
        function openRewardTrack(_arg_1:String):Void;
    }

