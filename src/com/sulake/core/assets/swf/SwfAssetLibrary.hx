package com.sulake.core.assets.swf;

#if html5
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.AssetTypeDeclaration;
import com.sulake.core.assets.BitmapDataAsset;
import com.sulake.core.assets.SoundAsset;
import com.sulake.core.utils.xml.XML;
import haxe.io.Bytes;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import js.Browser;
import lime.app.Future;
import openfl.display.BitmapData;

/**
 * Builds an AssetLibrary from a library SWF.
 *
 * Flash got this for free: `Loader` ran the SWF, the SymbolClass tag bound each exported character
 * to a class, and the AS3 AssetLibrary read them back through the ApplicationDomain. With no
 * player, the port has to read the container and register the exports itself.
 *
 * Three things about the real files decide how that is done. Measured against
 * `hh_human_50_hair.swf` (1,092 exports):
 *
 *   * the manifest is exported as `<library>_manifest` -- not `_manifest_bin`;
 *   * every bitmap symbol is prefixed with the library name, so the hair part the compositor asks
 *     for as `sh_std_hr_1_0_0` is exported as `hh_human_50_hair_sh_std_hr_1_0_0`, while the
 *     manifest lists it under the short name. The prefix has to come off, or every lookup misses
 *     and returns null -- parts silently absent, with nothing to see but a bare avatar;
 *   * each manifest asset carries `<param key='offset' value='-7,39'/>`, and those offsets are how
 *     the parts line up. Dropping them composites every layer at the origin.
 *
 * So the decode is done here and the registration is handed to `AssetLibrary.loadFromManifest`,
 * which already walks the assets and aliases and applies the params -- the same path G1d tested.
 */
class SwfAssetLibrary {
    /** Fetch `url`, read it as a SWF, and build a library named `name` from its exports. */
    public static function load(name:String, url:String, onLoaded:AssetLibrary->Void,
            onError:Dynamic->Void, ?includeAsset:String->Bool):Void {
        SwfByteCache.fetch(url).then(function(raw) {
            SwfFile.readAsync(raw).onComplete(function(file) {
                try build(name, url, file, onLoaded, onError, includeAsset)
                catch (error:Dynamic) onError('Could not read $url as a SWF: $error');
            }).onError(function(error) onError('Could not read $url as a SWF: $error'));
            return null;
        }).catchError(onError);
    }

    public static function build(name:String, url:String, file:SwfFile,
            onLoaded:AssetLibrary->Void, onError:Dynamic->Void,
            ?includeAsset:String->Bool):Void {
        var manifestSymbol = name + "_manifest";
        var prefix = name + "_";
        var manifest:Null<XML> = null;
        var characters = new StringMap<SwfCharacter>();
        var soundBytes = new StringMap<Bytes>();
        var undecodable:Array<String> = [];

        for (symbol in file.exportedNames()) {
            var character = file.symbols.get(symbol);
            if (character == null) continue;
            if (symbol == manifestSymbol) {
                manifest = new XML(character.payload.toString());
                break;
            }
        }

        if (manifest == null) {
            onError('$url has no $manifestSymbol export, so its assets cannot be named');
            return;
        }

        // A caller-supplied filter selects the parts this room actually needs, but an alias is a
        // second name for another asset's bitmap -- an avatar head is published once under part
        // id 1 and aliased for ids 2, 3 and 4. Filtering on the alias's own name alone therefore
        // drops the bitmap it points at, and the alias resolves to nothing. Keep every link
        // target of an alias that survives the filter.
        var aliasTargets = new StringMap<Bool>();
        if (includeAsset != null) {
            var aliases = manifest.child("library").at(0);
            if (aliases == null) aliases = manifest.child("component").at(0);
            var aliasesNode = aliases == null ? null : aliases.child("aliases").at(0);
            if (aliasesNode != null) for (alias in aliasesNode.child("alias")) {
                var aliasName = alias.attribute("name").toString();
                var link = alias.attribute("link").toString();
                if (link != "" && includeAsset(aliasName)) aliasTargets.set(link, true);
            }
        }

        for (symbol in file.exportedNames()) {
            var character = file.symbols.get(symbol);
            if (character == null || symbol == manifestSymbol) continue;
            // Short name: what the manifest lists and the compositor asks for.
            var shortName = StringTools.startsWith(symbol, prefix)
                ? symbol.substr(prefix.length) : symbol;
            var wanted = includeAsset == null || includeAsset(shortName)
                || aliasTargets.exists(shortName);
            switch (character.kind) {
                case Bitmap:
                    if (wanted) characters.set(shortName, character);
                case Sound:
                    // Decoded here rather than through the bitmaps' Future machinery: reading a
                    // DefineSound header is a few field reads, and SoundAsset defers the expensive
                    // part -- base64 into a Howler source -- until something actually plays.
                    if (wanted) {
                        try soundBytes.set(shortName, SwfSound.decodeMp3(character).mp3)
                        catch (error:Dynamic) undecodable.push('$shortName ($error)');
                    }
                case _:
            }
        }

        var bitmaps = new StringMap<BitmapData>();
        var decodes = new IntMap<Future<BitmapData>>();
        var decodeOwners = new IntMap<Int>();
        var pending = 0;
        for (_ in characters.keys()) pending++;

        var library = new AssetLibrary(name);
        // The player used the manifest MIME type to instantiate BitmapDataAsset. Native SWF
        // decoding produces BitmapData directly, but the manifest still needs those declarations
        // or AssetLibrary correctly rejects every bitmap as an unknown type and the compositor
        // silently renders an empty canvas.
        library.registerAssetTypeDeclaration(
            new AssetTypeDeclaration("image/png", BitmapDataAsset, null, "png"), false);
        library.registerAssetTypeDeclaration(
            new AssetTypeDeclaration("image/jpeg", BitmapDataAsset, null, "jpg", "jpeg"), false);
        // Same reasoning for sound, and the same MIME the converted AssetLibrary declares for it.
        // Without this the manifest's sound entries find no type, register nothing, and
        // HabboSoundManagerFlash10.playSound dereferences the missing asset.
        library.registerAssetTypeDeclaration(
            new AssetTypeDeclaration("sound/mp3", SoundAsset, null, "mp3"), false);
        function register():Void {
            if (undecodable.length > 0)
                Browser.console.warn('SKYHAXE_LIBRARY_ASSETS_UNDECODABLE $name: '
                    + undecodable.length + " asset(s) -- "
                    + undecodable.slice(0, 8).join(", "));
            try {
                library.loadFromManifest(manifest, function(assetName):Dynamic {
                    var bitmap = bitmaps.get(assetName);
                    if (bitmap != null) return bitmap;
                    // MP3 frames, not a Sound: SoundAsset builds the Sound on first play, so a
                    // library's samples cost nothing until one is used.
                    return soundBytes.get(assetName);
                });
                onLoaded(library);
            } catch (error:Dynamic) {
                onError('Could not register $url from its manifest: $error');
            }
        }

        if (pending == 0) {
            register();
            return;
        }

        // A decode failure costs that one asset, not the library.
        //
        // This used to abort the whole registration on the first bad bitmap, which is how a
        // reload could lose every head, body and hand in the room: warm-cache reloads decode all
        // ~180 body bitmaps almost simultaneously, and a single failure anywhere in that batch
        // dropped hh_human_50_body entirely -- 179 assets and 56 aliases -- while the other 24
        // libraries registered normally. The avatar then rendered as clothing with no body.
        //
        // The manifest still names the missing asset, so it registers with null content and the
        // compositor's own fallback chain handles it, exactly as it does for a part the filter
        // never decoded.
        for (assetName => character in characters) {
            var decode = decodes.get(character.id);
            if (decode == null) {
                decode = SwfBitmap.decodeBitmapAsync(character);
                decodes.set(character.id, decode);
            }
            decode.onComplete(function(bitmap) {
                // AssetLibrary owns mutable surfaces. Aliases share through the manifest, while
                // genuinely repeated export names get independent BitmapData instances.
                var owners = decodeOwners.get(character.id);
                if (owners == null) owners = 0;
                bitmaps.set(assetName, owners == 0 ? bitmap : bitmap.clone());
                decodeOwners.set(character.id, owners + 1);
                if (--pending == 0) register();
            }).onError(function(error) {
                undecodable.push('$assetName ($error)');
                if (--pending == 0) register();
            });
        }
    }

}
#end
