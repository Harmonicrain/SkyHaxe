package com.sulake.habbo.catalog.navigation
;

     interface ICatalogNode 
    {
        function dispose():Void;
        var isOpen(get,never):Bool;
        var depth(get,never):Int;
        var isBranch(get,never):Bool;
        var isLeaf(get,never):Bool;
        var visible(get,never):Bool;
        var localization(get,never):String;
        var pageId(get,never):Int;
        var pageName(get,never):String;
        var children(get,never):Vector<ICatalogNode>;
        var offerIds(get,never):Vector<Int>;
        function activate():Void;
        function deactivate():Void;
        function addChild(_arg_1:ICatalogNode):Void;
        function open():Void;
        function close():Void;
        var parent(get,never):ICatalogNode;
        var iconName(get,never):String;
        var offsetV(get,never):Int;
    }

