package com.sulake.core.assets;

class AssetTypeDeclaration {
    public var mimeType(get, never):String;
    public var assetClass(get, never):Class<Dynamic>;
    public var loaderClass(get, never):Null<Class<Dynamic>>;
    public var fileTypes(get, never):Array<String>;

    private final _mimeType:String;
    private final _assetClass:Class<Dynamic>;
    private final _loaderClass:Null<Class<Dynamic>>;
    private final _fileTypes:Array<String>;

    public function new(
        mimeType:String,
        assetClass:Class<Dynamic>,
        ?loaderClass:Class<Dynamic>,
        ...fileTypes:String
    ) {
        _mimeType = mimeType;
        _assetClass = assetClass;
        _loaderClass = loaderClass;
        _fileTypes = fileTypes.toArray();
    }

    private inline function get_mimeType():String return _mimeType;
    private inline function get_assetClass():Class<Dynamic> return _assetClass;
    private inline function get_loaderClass():Null<Class<Dynamic>> return _loaderClass;
    private inline function get_fileTypes():Array<String> return _fileTypes;
}
