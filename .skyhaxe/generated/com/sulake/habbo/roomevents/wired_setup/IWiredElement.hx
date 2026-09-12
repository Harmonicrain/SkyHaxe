package com.sulake.habbo.roomevents.wired_setup
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Wired 2.0 builder element contract adapted from the May/July client.
     */
     interface IWiredElement
    {
        var code(get,never):Int;
        var negativeCode(get,never):Int;
        var inputMode(get,never):Int;
        var requiredCapability(get,never):Int;

        function setRoomEvents(_arg_1:HabboUserDefinedRoomEvents):Void;
        function onInit(_arg_1:HabboUserDefinedRoomEvents):Void;
        var roomEvents(get,never):HabboUserDefinedRoomEvents;

        function onEditStart(_arg_1:Triggerable):Void;
        function onEditInitialized():Void;
        function onEditEnd():Void;

        function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):Void;

        function readIntParamsFromForm():Array<ASAny>;
        function readVariableIdsFromForm():Array<ASAny>;
        function readFurniSourceTypesFromForm():Array<ASAny>;
        function readUserSourceTypesFromForm():Array<ASAny>;
        function readFurniIds2FromForm():Array<ASAny>;
        function readStringParamFromForm():String;

        var hasStateSnapshot(get,never):Bool;
        var requiresFurniSelection(get,never):Bool;
        var forceFurniSelection(get,never):Bool;
        var forceHidePickFurniInstructions(get,never):Bool;
        function furniSelectionTitle(_arg_1:Int):String;
        function userSelectionTitle(_arg_1:Int):String;
        function mergedSelections():Array<ASAny>;
        function mergedSelectionTitle(_arg_1:Int):String;
        function setMergedType(_arg_1:Int, _arg_2:Int):Void;
        function getMergedType(_arg_1:Int):Int;
        function isInputSourceDisabled(_arg_1:Int, _arg_2:Int):Bool;
        function getCustomSourcesForMergedType(_arg_1:Int):Array<ASAny>;
        function mergedSourceOptions(_arg_1:Int):Array<ASAny>;
        function hasCustomTypePicker(_arg_1:Int):Bool;
        function advancedAlwaysVisible():Bool;
        function inputSourcesAlwaysVisible():Bool;
        var usingCustomAdvancedSettings(get,never):Bool;
        function onGuildMemberships(_arg_1:Array<ASAny>):Void;
        function validate():String; // null = valid
        var requireConfirmation(get,never):ASObject;

        var widthModifier(get,never):Float;
        var allowScrolling(get,never):Bool;
    }

