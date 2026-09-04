package com.sulake.core.assets;

import com.sulake.core.utils.xml.XML;

/**
 * The lookup half of the AS3 IAssetLibrary.
 *
 * The AS3 interface declares 22 members, and three of them -- loadFromFile, loadFromResource and
 * unload -- are written in terms of `LibraryLoader`, the AS3 SWF downloader that unzips libraries
 * with a vendored copy of FZip. Converting the interface as written therefore drags the whole
 * loader stack into any closure that names a library, which is how the avatar compositor ended up
 * pulling in a zip decoder it will never run: SkyHaxe reads SWFs with `SwfFile`.
 *
 * So the seam is drawn here. This interface keeps everything that reads a loaded library and drops
 * everything that fetches one; loading is the port's own concern and stays out of the AS3 shape.
 * `AssetLibrary` implements it.
 */
interface IAssetLibrary {
    public var url(get, never):Null<String>;
    public var name(get, never):Null<String>;
    public var isReady(get, never):Bool;
    public var manifest(get, never):XML;
    public var numAssets(get, never):Int;
    public var nameArray(get, never):Array<String>;

    // AS3's IAssetLibrary extends IDisposable, and Component disposes the libraries it owns.
    public function dispose():Void;

    public function getAssetByName(name:String):Null<IAsset>;
    public function getAssetByContent(content:Dynamic):Null<IAsset>;
    public function getAssetByIndex(index:Int):Null<IAsset>;
    public function getAssetIndex(asset:IAsset):Int;
    public function hasAsset(name:String):Bool;
    public function setAsset(name:String, asset:IAsset, overwrite:Bool = true):Bool;
    public function createAsset(name:String, type:AssetTypeDeclaration):Null<IAsset>;
    public function removeAsset(asset:IAsset):Null<IAsset>;

    // The type-declaration lookups belong to the reading half too: GraphicAssetCollection
    // resolves a library's assets by class before it can wrap them.
    public function registerAssetTypeDeclaration(type:AssetTypeDeclaration,
        shared:Bool = true):Bool;
    public function getAssetTypeDeclarationByMimeType(mimeType:String,
        shared:Bool = true):Null<AssetTypeDeclaration>;
    public function getAssetTypeDeclarationByClass(typeClass:Class<Dynamic>,
        shared:Bool = true):Null<AssetTypeDeclaration>;
    public function getAssetTypeDeclarationByFileName(fileName:String,
        shared:Bool = true):Null<AssetTypeDeclaration>;
}
