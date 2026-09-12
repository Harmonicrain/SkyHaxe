package com.sulake.habbo.friendlist
;
     interface IFriend 
    {
        var id(get,never):Int;
        var name(get,never):String;
        var gender(get,never):Int;
        var online(get,never):Bool;
        var followingAllowed(get,never):Bool;
        var figure(get,never):String;
        var realName(get,never):String;
        var persistedMessageUser(get,never):Bool;
        var pocketHabboUser(get,never):Bool;
        var relationshipStatus(get,never):Int;
    }

