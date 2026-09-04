package com.sulake.habbo.catalog.navigation
;
    import com.sulake.habbo.catalog.IHabboCatalog;
    import com.sulake.habbo.communication.messages.incoming.catalog.NodeData;
    import com.sulake.core.window.IWindow;

     interface ICatalogNavigator 
    {
        function dispose():Void;
        var catalog(get,never):IHabboCatalog;
        function buildCatalogIndex(_arg_1:NodeData):Void;
        function showIndex():Void;
        function activateNode(_arg_1:ICatalogNode):Void;
        function loadFrontPage():Void;
        var initialized(get,never):Bool;
        function getNodesByOfferId(_arg_1:Int, _arg_2:Bool=false):Vector<ICatalogNode>;
        function getNodeByName(_arg_1:String):ICatalogNode;
        function getOptionalNodeByName(_arg_1:String):ICatalogNode;
        function getNodeById(_arg_1:Int, _arg_2:ICatalogNode=null):ICatalogNode;
        function openPage(_arg_1:String):Void;
        function openPageById(_arg_1:Int, _arg_2:Int):Void;
        function openPageByOfferId(_arg_1:Int):Void;
        function deactivateCurrentNode():Void;
        function filter(_arg_1:String, _arg_2:Array<ASAny>):Void;
        var listTemplate(get,never):IWindow;
        function getItemTemplate(_arg_1:Int):IWindow;
        var isDeepHierarchy(get,never):Bool;
    }

