package com.sulake.core.assets;

import com.sulake.core.runtime.IDisposable;
import com.sulake.core.utils.ClassUtils;
import com.sulake.core.utils.xml.XML;
import haxe.ds.StringMap;

typedef AssetContentResolver = String -> Dynamic;

/**
 * Synchronous ownership and manifest core of the AS3 AssetLibrary.
 * Network loaders and runtime SWF symbol resolution are added at G2.
 */
class AssetLibrary implements IDisposable implements IAssetLibrary {
    public static var numAssetLibraryInstances(get, never):Int;
    public static var assetLibraryRefArray(get, never):Array<AssetLibrary>;

    public var url(get, never):Null<String>;
    public var name(get, never):Null<String>;
    public var isReady(get, never):Bool;
    public var manifest(get, never):XML;
    public var numAssets(get, never):Int;
    public var nameArray(get, never):Array<String>;
    public var disposed(get, never):Bool;

    private static var _sharedTypesByMime:Null<StringMap<AssetTypeDeclaration>>;
    private static var _sharedTypes:Null<Array<AssetTypeDeclaration>>;
    private static var _numInstances = 0;
    private static final _references:Array<AssetLibrary> = [];

    private var _name:Null<String>;
    private var _url:Null<String>;
    private var _manifest:Null<XML>;
    private var _isReady = false;
    private var _disposed = false;
    private var _assets:Null<StringMap<IAsset>>;
    private var _assetNames:Null<Array<String>>;
    private var _localTypesByMime:Null<StringMap<AssetTypeDeclaration>>;
    private var _localTypes:Null<Array<AssetTypeDeclaration>>;

    public function new(name:String, ?manifest:XML) {
        ensureSharedTypes();
        _name = name;
        _manifest = manifest;
        _assets = new StringMap();
        _assetNames = [];
        _localTypesByMime = new StringMap();
        _localTypes = [];
        _numInstances++;
        _references.push(this);
    }

    private static function ensureSharedTypes():Void {
        if (_sharedTypesByMime != null) return;
        _sharedTypesByMime = new StringMap();
        _sharedTypes = [];
        addSharedType(new AssetTypeDeclaration("application/octet-stream", UnknownAsset));
        addSharedType(new AssetTypeDeclaration("application/zip", UnknownAsset, null, "zip"));
        addSharedType(new AssetTypeDeclaration("text/xml", XmlAsset, null, "xml"));
        addSharedType(new AssetTypeDeclaration("text/html", XmlAsset, null, "htm", "html"));
        addSharedType(new AssetTypeDeclaration("text/plain", TextAsset, null, "txt"));
    }

    private static function addSharedType(type:AssetTypeDeclaration):Void {
        _sharedTypesByMime.set(type.mimeType, type);
        _sharedTypes.push(type);
    }

    private inline function assets():StringMap<IAsset> {
        if (_assets == null) throw new haxe.Exception("AssetLibrary is disposed");
        return _assets;
    }

    private inline function assetNames():Array<String> {
        if (_assetNames == null) throw new haxe.Exception("AssetLibrary is disposed");
        return _assetNames;
    }

    private inline function localTypesByMime():StringMap<AssetTypeDeclaration> {
        if (_localTypesByMime == null) throw new haxe.Exception("AssetLibrary is disposed");
        return _localTypesByMime;
    }

    private inline function localTypes():Array<AssetTypeDeclaration> {
        if (_localTypes == null) throw new haxe.Exception("AssetLibrary is disposed");
        return _localTypes;
    }

    private static inline function get_numAssetLibraryInstances():Int return _numInstances;
    private static inline function get_assetLibraryRefArray():Array<AssetLibrary> return _references;
    private inline function get_url():Null<String> return _url;
    private inline function get_name():Null<String> return _name;
    private inline function get_isReady():Bool return _isReady;
    private function get_manifest():XML {
        if (_manifest == null) _manifest = new XML();
        return _manifest;
    }
    private inline function get_numAssets():Int return assetNames().length;
    private inline function get_nameArray():Array<String> return assetNames();
    private inline function get_disposed():Bool return _disposed;

    public function getAssetByName(name:String):Null<IAsset> {
        return assets().get(name);
    }

    public function getAssetByIndex(index:Int):Null<IAsset> {
        var names = assetNames();
        return index >= 0 && index < names.length ? assets().get(names[index]) : null;
    }

    public function getAssetByContent(content:Dynamic):Null<IAsset> {
        for (name in assetNames()) {
            var asset = assets().get(name);
            if (asset != null && same(asset.content, content)) return asset;
        }
        return null;
    }

    public function getAssetIndex(asset:IAsset):Int {
        var names = assetNames();
        for (index in 0...names.length) {
            if (assets().get(names[index]) == asset) return index;
        }
        return -1;
    }

    public inline function hasAsset(name:String):Bool {
        return assets().exists(name) && assets().get(name) != null;
    }

    public function setAsset(name:String, asset:IAsset, overwrite:Bool = true):Bool {
        var isNew = !hasAsset(name);
        if (!overwrite && !isNew) return false;
        if (isNew) assetNames().push(name);
        assets().set(name, asset);
        return true;
    }

    public function createAsset(name:String, type:AssetTypeDeclaration):Null<IAsset> {
        if (hasAsset(name) || type == null) return null;
        var value:Dynamic = Type.createInstance(type.assetClass, [type]);
        if (!Std.isOfType(value, IAsset)) {
            throw new haxe.Exception('Asset class does not implement IAsset: ${ClassUtils.getQualifiedClassName(type.assetClass)}');
        }
        var asset:IAsset = cast value;
        if (!setAsset(name, asset)) {
            asset.dispose();
            return null;
        }
        return asset;
    }

    /** Removes ownership without disposing the returned asset. */
    public function removeAsset(asset:IAsset):Null<IAsset> {
        var names = assetNames();
        for (index in 0...names.length) {
            var name = names[index];
            if (assets().get(name) == asset) {
                names.splice(index, 1);
                assets().remove(name);
                return asset;
            }
        }
        return null;
    }

    public function registerAssetTypeDeclaration(type:AssetTypeDeclaration, shared:Bool = true):Bool {
        var map = shared ? _sharedTypesByMime : localTypesByMime();
        var list = shared ? _sharedTypes : localTypes();
        if (map.exists(type.mimeType)) {
            throw new haxe.Exception('Asset type ${type.mimeType} already registered!');
        }
        map.set(type.mimeType, type);
        list.push(type);
        return true;
    }

    public function getAssetTypeDeclarationByMimeType(mimeType:String, shared:Bool = true):Null<AssetTypeDeclaration> {
        if (shared) {
            var type = _sharedTypesByMime.get(mimeType);
            if (type != null) return type;
        }
        return localTypesByMime().get(mimeType);
    }

    public function getAssetTypeDeclarationByClass(typeClass:Class<Dynamic>, shared:Bool = true):Null<AssetTypeDeclaration> {
        if (shared) {
            for (type in _sharedTypes) if (type.assetClass == typeClass) return type;
        }
        for (type in localTypes()) if (type.assetClass == typeClass) return type;
        return null;
    }

    public function getAssetTypeDeclarationByFileName(fileName:String, shared:Bool = true):Null<AssetTypeDeclaration> {
        var query = fileName.indexOf("?");
        if (query > -1) fileName = fileName.substr(0, query);
        var dot = fileName.lastIndexOf(".");
        if (dot == -1 || dot == fileName.length - 1) return null;
        var extension = fileName.substr(dot + 1);
        if (shared) {
            for (type in _sharedTypes) if (type.fileTypes.indexOf(extension) > -1) return type;
        }
        for (type in localTypes()) if (type.fileTypes.indexOf(extension) > -1) return type;
        return null;
    }

    public function loadFromManifest(manifest:XML, resolveContent:AssetContentResolver):Bool {
        var container = manifest.child("library").at(0);
        if (container == null) container = manifest.child("component").at(0);
        if (container == null) throw new haxe.Exception("Provided manifest contains neither library nor component node");

        var assetsNode = container.child("assets").at(0);
        if (assetsNode != null) {
            for (item in assetsNode.child("asset")) loadManifestAsset(item, resolveContent);
        }
        var aliasesNode = container.child("aliases").at(0);
        if (aliasesNode != null) {
            // Real manifests use <alias>; the G1d fixture uses <asset>. Read both.
            for (item in aliasesNode.child("alias")) loadManifestAlias(item);
            for (item in aliasesNode.child("asset")) loadManifestAlias(item);
        }
        _manifest = manifest;
        _isReady = true;
        return true;
    }

    private function loadManifestAsset(item:XML, resolveContent:AssetContentResolver):Void {
        var name = item.attribute("name").toString();
        var mimeType = item.attribute("mimeType").toString();
        var type = getAssetTypeDeclarationByMimeType(mimeType);
        if (type == null) return;
        var content = resolveContent(name);
        // A native reader can deliberately expose only a measured subset of a large SWF. Do not
        // register a poisoned asset whose first `content` read will fail; absence lets the normal
        // library search continue to another scale/library.
        if (content == null) return;
        var asset = createAsset(name, type);
        if (asset == null) throw new haxe.Exception('Duplicate manifest asset: $name');
        asset.setUnknownContent(content);
        var parameters = item.child("param");
        if (parameters.length() > 0) asset.setParamsDesc(parameters);
    }

    private function loadManifestAlias(item:XML):Void {
        var name = item.attribute("name").toString();
        // A real library manifest writes `<alias name link fliph flipv/>` with no mimeType. The
        // `ref` and `mimeType` spelling is the synthetic shape the G1d fixture uses, kept so that
        // contract stays green. Reading only the synthetic one meant no alias in any real library
        // ever loaded -- `mimeType` is absent, so the type lookup returned null and this returned
        // before doing anything. Aliases are not decoration: an avatar head is published once for
        // part id 1 and aliased for ids 2, 3 and 4, so every avatar wearing one of those rendered
        // without a head, silently.
        var reference = item.attribute("link").toString();
        if (reference == "") reference = item.attribute("ref").toString();
        var source = getAssetByName(reference);
        // The source may have been intentionally filtered from a native SWF library.
        if (source == null) return;
        var mimeType = item.attribute("mimeType").toString();
        var type = mimeType == ""
            ? source.declaration
            : getAssetTypeDeclarationByMimeType(mimeType);
        if (type == null) return;
        var alias = createAsset(name, type);
        if (alias == null) throw new haxe.Exception('Duplicate manifest alias: $name');
        alias.setFromOtherAsset(source);
        var parameters = item.child("param");
        if (parameters.length() > 0) alias.setParamsDesc(parameters);
        // An alias is also how a library spells "the same bitmap, mirrored". setFromOtherAsset
        // copies the source's own flips, so these have to be applied after it.
        var flipH = item.attribute("fliph").toString();
        var flipV = item.attribute("flipv").toString();
        if (flipH != "" || flipV != "") {
            var h = flipH == "" ? "0" : flipH;
            var v = flipV == "" ? "0" : flipV;
            alias.setParamsDesc(new XML('<params><param key="flipH" value="$h" />'
                + '<param key="flipV" value="$v" /></params>').child("param"));
        }
    }

    public function unload():Void {
        if (_assets == null) return;
        for (name in assetNames()) {
            var asset = assets().get(name);
            if (asset != null) asset.dispose();
        }
        _assets = new StringMap();
        _assetNames = [];
        _isReady = false;
        _url = null;
    }

    public function dispose():Void {
        if (_disposed) return;
        unload();
        _disposed = true;
        _references.remove(this);
        _numInstances--;
        _assets = null;
        _assetNames = null;
        _localTypesByMime = null;
        _localTypes = null;
        _manifest = null;
        _name = null;
    }

    public function toString():String {
        return '${ClassUtils.getQualifiedClassName(this)}: ${Std.string(_name)}';
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        #if js
        return js.Syntax.strictEq(left, right);
        #else
        return left == right;
        #end
    }
}
