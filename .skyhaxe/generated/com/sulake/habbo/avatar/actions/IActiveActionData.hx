package com.sulake.habbo.avatar.actions
;
     interface IActiveActionData 
    {
        var id(get,never):String;
        var actionType(get,never):String;
                var actionParameter(get,set):String;
        var startFrame(get,never):Int;
                var definition(get,set):IActionDefinition;
                var overridingAction(get,set):String;
    }

