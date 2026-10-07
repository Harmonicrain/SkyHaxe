package com.sulake.habbo.room.object.visualization.avatar.additions
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.room.object.visualization.IRoomObjectSprite;

     interface IAvatarAddition extends IDisposable 
    {
        var id(get,never):Int;
        function update(_arg_1:IRoomObjectSprite, _arg_2:Float):Void;
        function animate(_arg_1:IRoomObjectSprite):Bool;
    }

