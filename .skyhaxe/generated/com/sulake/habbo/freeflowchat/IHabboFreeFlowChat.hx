package com.sulake.habbo.freeflowchat
;
    import com.sulake.core.runtime.IUnknown;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.style.IChatStyleLibrary;

     interface IHabboFreeFlowChat extends IUnknown
    {
        var displayObject(get,never):DisplayObject;
        var chatStyleLibrary(get,never):IChatStyleLibrary;
        function createChatStylePreviewBitmap(_arg_1:Int, _arg_2:String, _arg_3:String, _arg_4:String):BitmapData;
                var isDisabledInPreferences(get,set):Bool;
                var preferedChatStyle(get,set):Int;
                var chatFontSizeMode(get,set):Int;
        var chatFontSizeScale(get,never):Float;
        function isNotificationStyle(_arg_1:Int):Bool;
        function clear():Void;
        function toggleVisibility():Void;
    }

