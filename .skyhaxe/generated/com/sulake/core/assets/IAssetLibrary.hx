package com.sulake.core.assets
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.LibraryLoader;
    import flash.net.URLRequest;

     interface IAssetLibrary extends IDisposable 
    {
        var url(get,never):String;
        var name(get,never):String;
        var isReady(get,never):Bool;
        var numAssets(get,never):UInt;
        var manifest(get,never):com.sulake.core.utils.xml.XML;
        var nameArray(get,never):Array<ASAny>;
        function loadFromFile(libraryLoader:LibraryLoader, prepareAssets:Bool=true):Void;
        function loadFromResource(xml:com.sulake.core.utils.xml.XML, type:Class<Dynamic>):Bool;
        function unload():Void;
        function loadAssetFromFile(name:String, urlRequest:URLRequest, type:String=null, _arg_4:String=null, _arg_5:Int=-1, _arg_6:Int=-1):AssetLoaderStruct;
        function getAssetByName(_arg_1:String):IAsset;
        function getAssetByContent(_arg_1:ASObject):IAsset;
        function getAssetByIndex(_arg_1:UInt):IAsset;
        function getAssetIndex(_arg_1:IAsset):Int;
        function hasAsset(_arg_1:String):Bool;
        function setAsset(name:String, asset:IAsset, _arg_3:Bool=true):Bool;
        function createAsset(name:String, typeDeclaration:AssetTypeDeclaration):IAsset;
        function removeAsset(asset:IAsset):IAsset;
        function registerAssetTypeDeclaration(_arg_1:AssetTypeDeclaration, _arg_2:Bool=true):Bool;
        function getAssetTypeDeclarationByMimeType(_arg_1:String, _arg_2:Bool=true):AssetTypeDeclaration;
        function getAssetTypeDeclarationByClass(_arg_1:Class<Dynamic>, _arg_2:Bool=true):AssetTypeDeclaration;
        function getAssetTypeDeclarationByFileName(_arg_1:String, _arg_2:Bool=true):AssetTypeDeclaration;
    }

