package com.sulake.habbo.avatar;

#if html5
import com.sulake.core.assets.AssetLibrary;
import com.sulake.core.assets.AssetLibraryCollection;
import com.sulake.core.assets.swf.SwfAssetLibrary;
import com.sulake.core.utils.xml.XML;
import com.sulake.habbo.avatar._enum.AvatarScaleType;
import com.sulake.habbo.utils.HabboFaceFocuser;
import com.sulake.habbo.avatar._enum.AvatarSetType;
import com.sulake.habbo.avatar.alias.AssetAliasCollection;
import com.sulake.habbo.avatar._enum.AvatarAction;
import com.sulake.habbo.room.object.visualization.room.publicroom.PublicRoomVisualizationLoader;
import haxe.ds.StringMap;
import haxe.ds.IntMap;
import js.Browser;
import openfl.utils.Assets;

/**
 * Native loading boundary around the generated clean-client avatar compositor.
 *
 * Figure/geometry/action semantics remain generated from AS3. This class only replaces what the
 * Flash player supplied: fetching XML/SWF files and selecting figure-map libraries. It loads the
 * genuine `sh_*` assets for public-room scale 32; no 64px avatar is resized as a shortcut.
 */
class AvatarRoomRenderer {
    static var loading = false;
    static var ready = false;
    static var collection:AssetLibraryCollection = new AssetLibraryCollection("avatar");
    static var manager:AvatarRenderManager = new AvatarRenderManager(collection);
    static var structure:AvatarStructure;
    static var effectManager = new EffectAssetDownloadManager();
    static var figureData:XML;
    static var figureMap:XML;
    // Name -> the part keys the library was filtered with when it was loaded.
    //
    // A library is fetched once, and `includeAsset` decodes only the parts the room needed at
    // that moment. Because AssetLibrary refuses to register an asset whose bitmap was not
    // decoded, that snapshot decides what the library is understood to contain for the rest of
    // the session. On a first load the room fills slowly and the snapshot is complete; on a
    // reload the server replays room state at once, a library can load against a single user,
    // and every part the other avatars need is then permanently absent. Remembering the
    // signature lets a later render notice it needs more and re-read the file.
    static var loadedLibraries = new StringMap<String>();
    /** Where avatar libraries are fetched from; see ensureReady. */
    static var avatarContentBase:String = "";
    static var skippedLibraries:Array<String> = [];
    static var waiting:Array<Void->Void> = [];
    static var failures:Array<Dynamic->Void> = [];

    /** The same manager used by the legacy canvas and the generated room visualization factory. */
    public static function renderManager():AvatarRenderManager return manager;

    /** Load the compositor documents before the generated engine starts accepting user objects. */
    public static function prepare(contentBase:String, onReady:Void->Void,
            onError:Dynamic->Void):Void {
        ensureReady(contentBase, onReady, onError);
    }
    /** MeMenuNewIconLoader.as:19 -- the button's portrait is 44x41 inside a radius-22 circle. */
    static inline var ME_MENU_ICON_WIDTH = 44;
    static inline var ME_MENU_ICON_HEIGHT = 41;
    static inline var ME_MENU_CIRCLE_RADIUS = 22;
    static inline var ME_MENU_PORTRAIT_OFFSET_X = 0;
    static inline var ME_MENU_PORTRAIT_OFFSET_Y = 2;

    /**
     * The me-menu portrait, as MeMenuNewIconLoader builds it.
     *
     * `BottomBarLeft` uses this loader, not the older `MeMenuIconLoader` -- and the two produce
     * completely different images. The old one crops a 50px band off the full body and the
     * toolbar adds a drop shadow; this one faces the avatar with FULL at direction 4 and HEAD at
     * 3, asks HabboFaceFocuser for the face at direction 3, centre-crops that to 44x41 and cuts a
     * circle out of it. `BottomBarLeft._Str_17734` then clones it straight through -- no shadow.
     */
    public static function composeHead(figure:String, gender:String, contentBase:String,
            onReady:openfl.display.BitmapData->Void, onError:Dynamic->Void):Void {
        ensureReady(contentBase, function() {
            var partKeys = partKeysForFigures([figure]);
            var libraries = requiredLibraries(partKeys, AvatarScaleType.LARGE);
            loadLibraries(libraries, partKeys, AvatarScaleType.LARGE, contentBase, 0, function() {
                try {
                    var image = new AvatarImage(structure, manager.aliases,
                        new AvatarFigureContainer(figure), AvatarScaleType.LARGE,
                        effectManager, null);
                    image.setDirection(AvatarSetType.FULL, 4);
                    image.setDirection(AvatarSetType.HEAD, 3);
                    var face = HabboFaceFocuser.focusUserFace(image, AvatarSetType.FULL, 3, 1);
                    if (face == null) throw "the face focuser returned no image";
                    var portrait = renderPortraitIntoIcon(face);
                    face.dispose();
                    image.dispose();
                    if (portrait == null) throw "the portrait crop returned no image";
                    onReady(portrait);
                } catch (error:Dynamic) onError(error);
            }, onError);
        }, onError);
    }

    /** MeMenuNewIconLoader.renderPortraitIntoIcon, verbatim. */
    static function renderPortraitIntoIcon(face:openfl.display.BitmapData)
            :Null<openfl.display.BitmapData> {
        if (face == null) return null;
        var icon = new openfl.display.BitmapData(ME_MENU_ICON_WIDTH, ME_MENU_ICON_HEIGHT,
            true, 0);
        var sourceX = Math.round((face.width - ME_MENU_ICON_WIDTH) / 2 - ME_MENU_PORTRAIT_OFFSET_X);
        var sourceY = Math.round((face.height - ME_MENU_ICON_HEIGHT) / 2
            - ME_MENU_PORTRAIT_OFFSET_Y);
        if (sourceX < 0) sourceX = 0;
        if (sourceY < 0) sourceY = 0;
        if (sourceX + ME_MENU_ICON_WIDTH > face.width) sourceX = face.width - ME_MENU_ICON_WIDTH;
        if (sourceY + ME_MENU_ICON_HEIGHT > face.height)
            sourceY = face.height - ME_MENU_ICON_HEIGHT;
        icon.copyPixels(face, new openfl.geom.Rectangle(sourceX, sourceY, ME_MENU_ICON_WIDTH,
            ME_MENU_ICON_HEIGHT), new openfl.geom.Point(0, 0));
        var circled = HabboFaceFocuser.cutCircleFromBitmap(icon, ME_MENU_CIRCLE_RADIUS);
        icon.dispose();
        return circled;
    }

    /** AvatarLogic.as:609-616. */
    static inline function blinkInterval():Float return 4500 + Math.random() * 1000;
    static inline function blinkLength():Float return 50 + Math.random() * 200;
    static inline function nowMs():Float return haxe.Timer.stamp() * 1000;

    static function ensureReady(contentBase:String, onReady:Void->Void,
            onError:Dynamic->Void):Void {
        // Remembered so the manager's download request can reach the same mount later, when it
        // has only a figure string and no caller to pass one in.
        avatarContentBase = contentBase;
        if (ready) {
            onReady();
            return;
        }
        waiting.push(onReady);
        failures.push(onError);
        if (loading) return;
        loading = true;
        fetchText("/ngh/gamedata/figuredata.xml", function(figures) {
            fetchText("/ngh/gamedata/figuremap.xml", function(map) {
                fetchText(sameOriginBase(contentBase) + "HabboAvatarActions.xml", function(actions) {
                    try {
                        figureData = new XML(figures);
                        figureMap = new XML(map);
                        structure = manager.createStructure();
                        structure.initGeometry(new XML(Assets.getText("avatar/HabboAvatarGeometry.xml")));
                        if (!structure.initPartSets(new XML(Assets.getText("avatar/HabboAvatarPartSets.xml"))))
                            throw "Avatar part-set XML was rejected";
                        structure.initActions(new AssetLibrary("avatar-actions"), new XML(actions));
                        if (!structure.initAnimation(new XML(Assets.getText("avatar/HabboAvatarAnimation.xml"))))
                            throw "Avatar animation XML was rejected";
                        if (!structure.initFigureData(figureData))
                            throw "External figuredata.xml was rejected";
                        structure.init();
                        manager.setReady(true);
                        // The manager builds room avatars through createAvatarImage, and needs to
                        // know whether a figure's libraries are in before it decides between the
                        // real image and a placeholder. That knowledge lives here -- figuremap
                        // parsing, the loaded set, the loader -- so it is handed over rather than
                        // duplicated.
                        manager.setDownloads({
                            isReady: figureLibrariesReady,
                            request: requestFigureLibraries
                        });
                        manager.setEffectManager(effectManager);
                        ready = true;
                        loading = false;
                        var callbacks = waiting;
                        waiting = [];
                        failures = [];
                        for (callback in callbacks) callback();
                    } catch (error:Dynamic) failAll(error);
                }, failAll);
            }, failAll);
        }, failAll);
    }

    /** The figure string is all the part scan needs; room state is irrelevant to it. */
    static function partKeysForFigures(figures:Array<String>):StringMap<Bool> {
        var requested = new StringMap<Bool>();
        for (figure in figures) {
            for (segment in figure.split(".")) {
                var pieces = segment.split("-");
                if (pieces.length < 2) continue;
                var type = pieces[0];
                var setId = pieces[1];
                for (setType in figureData.child("sets").child("settype")) {
                    if (attr(setType, "type") != type) continue;
                    for (set in setType.child("set")) {
                        if (attr(set, "id") != setId) continue;
                        for (part in set.child("part"))
                            requested.set(attr(part, "type") + ":" + attr(part, "id"), true);
                    }
                }
            }
        }
        // The small body library supplies the authored floor shadow independently of figuredata.
        requested.set("sd:1", true);
        return requested;
    }

    // At scale 32 the 32px art lives in the legacy `hh_human_50_*` libraries, and they do not use
    // the same part ids as figuredata. A head is figuredata part `hd:2`, which figuremap maps only
    // to the 64px `hh_human_body`; the 32px head is published in `hh_human_50_body` as part id 1
    // and reached through that library's alias table. Selecting libraries by exact part id alone
    // therefore never picks the small library that actually holds the asset -- the head only
    // rendered at all because the forced `sd:1` shadow entry happens to pull `hh_human_50_body`
    // in by accident.
    //
    // So match the small libraries on part *type*: at this scale they are the source for it, and
    // their own aliases resolve the ids.
    static inline var SMALL_LIBRARY_PREFIX = "hh_human_50_";

    /**
     * AvatarAssetDownloadManager.isReady (:225) -- is every library this figure needs loaded?
     *
     * A library recorded as ABSENT counts as resolved: the server does not publish it, so waiting
     * for it would keep every avatar that references it on a placeholder for ever.
     */
    static function figureLibrariesReady(figure:String, scale:String):Bool {
        if (!ready) return false;
        var parts = partKeysForFigures([figure]);
        for (name in requiredLibraries(parts, scale)) {
            var recorded = loadedLibraries.get(name);
            if (recorded == null) return false;
        }
        return true;
    }

    /**
     * AvatarAssetDownloadManager._Str_1320 (:235) -- fetch what is missing, then tell the listener.
     *
     * The listener is the compositor's "this avatar can be drawn properly now" callback; the
     * placeholder stays on screen until it fires.
     */
    static function requestFigureLibraries(figure:String, scale:String,
            listener:Null<IAvatarImageListener>):Void {
        var parts = partKeysForFigures([figure]);
        var names = requiredLibraries(parts, scale);
        loadLibraries(names, parts, scale, avatarContentBase, 0, function() {
            if (listener != null && !listener.disposed) listener.avatarImageReady(figure);
        }, function(error) {
            Browser.console.warn('SKYHAXE_AVATAR_FIGURE_FAILED $figure: ' + Std.string(error));
        });
    }

    static function requiredLibraries(parts:StringMap<Bool>, scale:String):Array<String> {
        var result = new StringMap<Bool>();
        var types = new StringMap<Bool>();
        for (key in parts.keys()) types.set(key.split(":")[0], true);
        // The type-level fallback above exists only because the 32px libraries renumber their
        // parts, and it is meaningless at scale 64: figuremap's ids are the real ones there. Worse
        // than meaningless -- a small library admitted alongside the full-size one claims the same
        // part, and load order then decides whether an avatar comes back 32px in a 64px room.
        var wantSmall = scale == AvatarScaleType.SMALL;
        for (library in figureMap.child("lib")) {
            var id = attr(library, "id");
            var small = StringTools.startsWith(id, SMALL_LIBRARY_PREFIX);
            if (small && !wantSmall) continue;
            for (part in library.child("part")) {
                var type = attr(part, "type");
                if (parts.exists(type + ":" + attr(part, "id"))
                        || (small && types.exists(type))) {
                    result.set(id, true);
                    break;
                }
            }
        }
        var names = [for (name in result.keys()) name];
        names.sort(Reflect.compare);
        return names;
    }

    static function loadLibraries(names:Array<String>, parts:StringMap<Bool>, scale:String,
            contentBase:String, index:Int, onLoaded:Void->Void, onError:Dynamic->Void):Void {
        if (index >= names.length) {
            onLoaded();
            return;
        }
        var name = names[index];
        var signature = librarySignature(name, parts, scale);
        var recorded = loadedLibraries.get(name);
        if (recorded == ABSENT || recorded == signature) {
            loadLibraries(names, parts, scale, contentBase, index + 1, onLoaded, onError);
            return;
        }
        SwfAssetLibrary.load(name, sameOriginBase(contentBase) + name + ".swf", function(library) {
            collection.replaceAssetLibrary(library);
            loadedLibraries.set(name, signature);
            // AvatarRenderManager.as:217 -- LIBRARY_LOADED re-reads the manifests, so every alias
            // the new library declares resolves from here on.
            manager.resetAliases();
            loadLibraries(names, parts, scale, contentBase, index + 1, onLoaded, onError);
        }, function(error) {
            // A library that will not load costs the parts it holds, not the whole room. This
            // gordon build ships no hh_human_50_fx.swf at all -- figuremap lists it, the file was
            // never published -- and treating that 404 as fatal meant every avatar disappeared
            // because of an effects library nobody was using.
            //
            // Only a file that is genuinely absent is remembered as loaded. Marking *every*
            // failure that way meant one transient error left the library missing for the rest of
            // the session, with no retry -- a reload that briefly failed on hh_human_50_body gave
            // headless, bodiless avatars until the page was reloaded again. A transient failure
            // stays retryable, so the next render picks the library back up.
            var message = Std.string(error);
            if (isMissingFile(message)) {
                loadedLibraries.set(name, ABSENT);
                Browser.console.warn('SKYHAXE_AVATAR_LIBRARY_ABSENT $name: ' + message);
            } else {
                Browser.console.error('SKYHAXE_AVATAR_LIBRARY_FAILED $name (will retry): '
                    + message);
            }
            skippedLibraries.push(name);
            loadLibraries(names, parts, scale, contentBase, index + 1, onLoaded, onError);
        }, function(assetName) return requiredAsset(assetName, parts, scale));
    }

    /** Signature for a library that this gordon build does not ship at all. */
    static inline var ABSENT = " absent";

    /**
     * Which of `parts` this library could contribute, as a stable string.
     *
     * Only the parts that pass the same filter the loader uses matter: a library is re-read when
     * the room starts needing something from it that was not decoded the first time.
     */
    static function librarySignature(name:String, parts:StringMap<Bool>, scale:String):String {
        var relevant = [];
        for (key in parts.keys()) relevant.push(key);
        relevant.sort(Reflect.compare);
        return scale + "|" + relevant.join(",");
    }

    /** A 404/410 means the build does not ship the file; anything else may succeed next time. */
    static function isMissingFile(message:String):Bool {
        return message.indexOf("HTTP 404") >= 0 || message.indexOf("HTTP 410") >= 0;
    }

    /**
     * Keep the assets of one scale that a required part needs.
     *
     * Asset names carry their scale as their first segment -- AvatarScaleType's own values, `sh`
     * for 32 and `h` for 64 -- so the prefix is the scale plus an underscore. Hardcoding `sh_`
     * admitted nothing at all from the full-size libraries: `hh_human_body` publishes 241 bitmaps
     * and every one of them is `h_`, so a 64px room got a library with zero assets in it and an
     * avatar with no body, no face and no legs.
     */
    static function requiredAsset(name:String, parts:StringMap<Bool>, scale:String):Bool {
        if (!StringTools.startsWith(name, scale + "_")) return false;
        var pieces = name.split("_");
        // <scale>_<action>_<type>_<id>_<direction>_<frame>
        var assetType = pieces.length > 2 ? pieces[2] : "";
        for (key in parts.keys()) {
            var wanted = key.split(":");
            if (wanted.length != 2) continue;
            if (name.indexOf("_" + wanted[0] + "_" + wanted[1] + "_") >= 0) return true;
            if (assetType != "" && assetType == wanted[0]) return true;
        }
        return false;
    }

    static function failAll(error:Dynamic):Void {
        loading = false;
        var callbacks = failures;
        waiting = [];
        failures = [];
        for (callback in callbacks) callback(error);
    }

    static function fetchText(url:String, onLoaded:String->Void, onError:Dynamic->Void):Void {
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) throw 'HTTP ${response.status} for $url';
            return response.text();
        }).then(function(text) {
            onLoaded(text);
            return null;
        }).catchError(onError);
    }

    static function sameOriginBase(value:String):String {
        var path = new js.html.URL(value, Browser.window.location.href).pathname;
        return StringTools.endsWith(path, "/") ? path : path + "/";
    }

    static inline function attr(node:XML, name:String):String
        return node.attribute(name).toString();
}
#end
