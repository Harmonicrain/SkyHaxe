package com.sulake.habbo.communication.messages.incoming.users
;
     interface IGuildData
    {
        var ownedRooms(get,never):Array<ASAny>;
        var exists(get,never):Bool;
        var isOwner(get,never):Bool;
        var groupId(get,never):Int;
        var groupName(get,never):String;
        var groupDesc(get,never):String;
        var baseRoomId(get,never):Int;
        var primaryColorId(get,never):Int;
        var secondaryColorId(get,never):Int;
        var badgeSettings(get,never):Array<ASAny>;
        var locked(get,never):Bool;
        var url(get,never):String;
        var guildType(get,never):Int;
        var guildRightsLevel(get,never):Int;
        var badgeCode(get,never):String;
        var membershipCount(get,never):Int;
    }

