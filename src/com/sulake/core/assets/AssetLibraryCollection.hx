package com.sulake.core.assets;

import com.sulake.core.utils.xml.XML;

/**
 * A named set of asset libraries, searched in registration order.
 *
 * The AS3 class is the client's whole asset registry: it owns library loading, a download queue, a
 * manifest merger and the component-level sharing rules, all built on `LibraryLoader` and its
 * vendored FZip. SkyHaxe fetches bytes itself and reads them with `SwfFile`, so none of that half
 * belongs in the port -- see IAssetLibrary for the same seam drawn one level down.
 *
 * What the avatar compositor actually asks a collection for is small and entirely read-only:
 * `AssetAliasCollection` walks `getManifests()` to build the alias table, and looks a part up with
 * `getAssetByName`. That is what this implements, over libraries the caller registers.
 *
 * `loadAssetFromFile` is deliberately absent, just as it is from the port's IAssetLibrary seam.
 * Runtime loading belongs to SwfAssetLibrary; retaining a dead signature here pulls the generated
 * Flash AssetLoaderStruct graph into an otherwise read-only registry.
 */
class AssetLibraryCollection {
    public var name(get, never):String;

    private final _name:String;
    private final _libraries:Array<IAssetLibrary> = [];

    public function new(name:String) {
        _name = name;
    }

    private function get_name():String {
        return _name;
    }

    /**
     * Register a library, replacing any earlier one of the same name.
     *
     * A library can be re-read when the room turns out to need parts that were filtered out the
     * first time. Appending the new copy would leave the older, thinner one earlier in the search
     * order, so every lookup would keep finding the version missing those parts.
     */
    public function replaceAssetLibrary(library:IAssetLibrary):Void {
        if (library == null) return;
        for (existing in _libraries.copy())
            if (existing.name == library.name) _libraries.remove(existing);
        _libraries.push(library);
    }

    public function addAssetLibrary(library:IAssetLibrary):Void {
        if (library != null && _libraries.indexOf(library) == -1) _libraries.push(library);
    }

    public function removeAssetLibrary(library:IAssetLibrary):Void {
        _libraries.remove(library);
    }

    public function hasAssetLibrary(name:String):Bool {
        for (library in _libraries) if (library.name == name) return true;
        return false;
    }

    public function getAssetLibrary(name:String):Null<IAssetLibrary> {
        for (library in _libraries) if (library.name == name) return library;
        return null;
    }

    /** Every registered library's manifest, in registration order. */
    public function getManifests():Array<XML> {
        var manifests = [];
        for (library in _libraries) {
            var manifest = library.manifest;
            if (manifest != null) manifests.push(manifest);
        }
        return manifests;
    }

    /** First library holding the name wins, matching the AS3 search order. */
    public function getAssetByName(name:String):Null<IAsset> {
        for (library in _libraries) {
            var asset = library.getAssetByName(name);
            if (asset != null) return asset;
        }
        return null;
    }

    /** Diagnostic:each library's registered asset count, in registration order. */
    public function describeLibraries():Array<{name:String, assets:Int}> {
        return [for (library in _libraries) {name: library.name, assets: library.numAssets}];
    }

    public function hasAsset(name:String):Bool {
        for (library in _libraries) if (library.hasAsset(name)) return true;
        return false;
    }
}
