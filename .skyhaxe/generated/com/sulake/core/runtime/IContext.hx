package com.sulake.core.runtime
;
    import com.sulake.core.assets.IAssetLibrary;
    import flash.events.IEventDispatcher;
    import flash.display.DisplayObjectContainer;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import com.sulake.core.utils.LibraryLoader;
    import flash.system.ApplicationDomain;
    import com.sulake.core.runtime.events.ILinkEventTracker;

     interface IContext extends IUnknown 
    {
        var assets(get,never):IAssetLibrary;
        var events(get,never):IEventDispatcher;
        var root(get,never):IContext;
        function error(_arg_1:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null):Void;
        function getLastErrorMessage():String;
        function debug(_arg_1:String):Void;
        function getLastDebugMessage():String;
        function warning(_arg_1:String):Void;
        function getLastWarningMessage():String;
        var displayObjectContainer(get,never):DisplayObjectContainer;
        function loadFromFile(_arg_1:URLRequest, _arg_2:LoaderContext):LibraryLoader;
        function attachComponent(_arg_1:Component, _arg_2:Array<ASAny>):Void;
        function detachComponent(_arg_1:Component):Void;
        function prepareComponent(_arg_1:Class<Dynamic>, _arg_2:UInt=0, _arg_3:ApplicationDomain=null):IUnknown;
        function prepareAssetLibrary(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:Class<Dynamic>):Bool;
        function registerUpdateReceiver(_arg_1:IUpdateReceiver, _arg_2:UInt):Void;
        function removeUpdateReceiver(_arg_1:IUpdateReceiver):Void;
        function toXMLString(_arg_1:UInt=0):String;
                var configuration(get,set):IHabboConfigurationManager;
        function addLinkEventTracker(_arg_1:ILinkEventTracker):Void;
        function removeLinkEventTracker(_arg_1:ILinkEventTracker):Void;
        function createLinkEvent(_arg_1:String):Void;
        var linkEventTrackers(get,never):Vector<ILinkEventTracker>;
    }

