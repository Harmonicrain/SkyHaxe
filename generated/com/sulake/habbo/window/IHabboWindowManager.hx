package com.sulake.habbo.window
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.window.ICoreWindowManager;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.window.utils.IAlertDialogWithLink;
    import com.sulake.habbo.window.utils.IConfirmDialog;
    import com.sulake.core.window.IInputEventTracker;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.IResourceManager;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.utils.Map;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.text.StyleSheet;

     interface IHabboWindowManager extends IUnknown extends  ICoreWindowManager 
    {
        function createWindow(_arg_1:String, _arg_2:String="", _arg_3:UInt=0, _arg_4:UInt=0, _arg_5:UInt=0, _arg_6:Rectangle=null, _arg_7:ASFunction=null, _arg_8:UInt=0, _arg_9:UInt=1, _arg_10:String=""):IWindow;
        function removeWindow(_arg_1:String, _arg_2:UInt=1):Void;
        function getWindowByName(_arg_1:String, _arg_2:UInt=1):IWindow;
        function getActiveWindow(_arg_1:UInt=1):IWindow;
        function getWindowContext(_arg_1:UInt):IWindowContext;
        function alert(_arg_1:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IAlertDialog;
        function alertWithModal(_arg_1:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IAlertDialog;
        function alertWithLink(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:UInt, _arg_6:ASFunction):IAlertDialogWithLink;
        function confirm(_arg_1:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IConfirmDialog;
        function confirmWithModal(_arg_1:String, _arg_2:String, _arg_3:UInt, _arg_4:ASFunction):IConfirmDialog;
        function registerLocalizationParameter(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="%"):Void;
        function addMouseEventTracker(_arg_1:IInputEventTracker):Void;
        function removeMouseEventTracker(_arg_1:IInputEventTracker):Void;
        function createUnseenItemCounter():IWindowContainer;
        var resourceManager(get,never):IResourceManager;
        function buildModalDialogFromXML(_arg_1:com.sulake.core.utils.xml.XML):IModalDialog;
        function simpleAlert(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String=null, _arg_5:String=null, _arg_6:Map=null, _arg_7:String=null, _arg_8:ASFunction=null, _arg_9:ASFunction=null):Void;
        var assets(get,never):IAssetLibrary;
        function registerHintWindow(_arg_1:String, _arg_2:IWindow, _arg_3:Int=1):Void;
        function unregisterHintWindow(_arg_1:String):Void;
        function showHint(_arg_1:String, _arg_2:Rectangle=null):Void;
        function hideHint():Void;
        function displayFloorPlanEditor():Void;
        function openHelpPage(_arg_1:String):Void;
        var habboPagesStyleSheet(get,never):StyleSheet;
        function hideMatchingHint(_arg_1:String):Void;
    }

