package com.sulake.habbo.friendbar.data
;

     interface IFriendEntity 
    {
        var id(get,never):Int;
        var name(get,never):String;
        var gender(get,never):Int;
        var online(get,never):Bool;
        var allowFollow(get,never):Bool;
        var figure(get,never):String;
        var categoryId(get,never):Int;
        var motto(get,never):String;
        var lastAccess(get,never):String;
        var realName(get,never):String;
        var notifications(get,never):Vector<IFriendNotification>;
                var logEventId(get,set):Int;
        function getNextLogEventId():Int;
    }

