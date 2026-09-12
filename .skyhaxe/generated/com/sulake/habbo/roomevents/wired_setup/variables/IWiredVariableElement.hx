package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;

     interface IWiredVariableElement extends IWiredElement
    {
        var initialVariableName(get,never):String;
        function variableType():Int;
    }

