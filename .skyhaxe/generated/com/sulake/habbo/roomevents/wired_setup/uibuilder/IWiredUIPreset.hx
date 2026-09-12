package com.sulake.habbo.roomevents.wired_setup.uibuilder
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SpacerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

    /**
     * Wired 2.0 UI preset contract (May IWiredUIPreset). A preset wraps one editor
     * widget (or layout) and exposes a single backing window plus fluent decorators.
     */
     interface IWiredUIPreset extends IDisposable
    {
        var window(get,never):IWindow;
        function resizeToWidth(_arg_1:Int):Void;
        function hasStaticWidth():Bool;
        var staticWidth(get,never):Int;

        function alignRight():WiredUIPreset;
        function alignCenter():WiredUIPreset;
        function staticHeight(_arg_1:Int):WiredUIPreset;
        function floatVertically():WiredUIPreset;
        function wrapWindow(_arg_1:IWindow, _arg_2:Bool = false):WiredUIPreset;
        function noDisable():WiredUIPreset;
        function halfBlend():WiredUIPreset;

                var disabled(get,set):Bool;
        function updateDisabledState():Void;

                var visible(get,set):Bool;

        var blendSpacer(never,set):SpacerPreset;
    }

