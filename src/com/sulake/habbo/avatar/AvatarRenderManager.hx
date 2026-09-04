package com.sulake.habbo.avatar;

#if html5
// Generated code gets Vector from generated/import.hx; a hand-written file does not.
import flash.Vector;
import com.sulake.core.assets.AssetLibraryCollection;
import com.sulake.core.assets.IAsset;
import com.sulake.core.assets.IAssetLibrary;
import com.sulake.habbo.avatar.alias.AssetAliasCollection;
import com.sulake.habbo.avatar.animation.IAnimationManager;
import com.sulake.habbo.avatar.structure.IStructureData;
import com.sulake.core.utils.xml.XML;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;

/**
 * How the manager finds out whether a figure's libraries are in, and asks for the missing ones.
 *
 * This is the half of `AvatarAssetDownloadManager` that `createAvatarImage` depends on, and the
 * only half the room needs. The rest of that class -- the download queue, the retry counters, the
 * figuremap fetch -- is the AS3 loader stack this port replaced with `SwfAssetLibrary`, so it is
 * not converted and not emulated. `AvatarRoomRenderer` already computes required libraries and
 * loads them; it supplies these two functions rather than a second copy of that logic existing.
 */
typedef AvatarFigureDownloads = {
    /** AvatarAssetDownloadManager.isReady (:225) -- nothing this figure needs is still missing. */
    var isReady:String->String->Bool;

    /**
     * AvatarAssetDownloadManager._Str_1320 (:235) -- start the missing libraries, and call the
     * listener once the figure can be drawn for real.
     */
    var request:String->String->Null<IAvatarImageListener>->Void;
}

/**
 * Owns the avatar structure and the libraries its parts come from.
 *
 * The AS3 class of this name is an IHabboComponent: two thirds of it is component-framework
 * machinery -- dependency declarations, a context to resolve them against, configuration read
 * through the component's own property bag -- and none of that exists in SkyHaxe. Converting it
 * meant converting Core, CoreComponentContext, the profiler and the AS3 SWF loader with its
 * vendored zip decoder, all so an avatar could be drawn.
 *
 * So this is the port's own. It keeps the two members the converted code actually reaches --
 * `events` and `isReady`, which the download managers use to wait for the structure -- and
 * otherwise does the job directly: hold the structure, hold the libraries, hand out assets.
 *
 * `AvatarStructure` takes one of these in its constructor and exposes it again through
 * `avatarRenderManager`, so the concrete type has to be this one; that is why this is a class
 * replacing a class rather than an interface the port implements freely.
 */
class AvatarRenderManager implements IAvatarRenderManager {
    /** AvatarRenderManager.as:47 -- the head-only figure a placeholder avatar is drawn as. */
    static inline var PLACEHOLDER_FIGURE = "hd-99999-99999";

    public var events(get, never):IEventDispatcher;
    public var isReady(get, never):Bool;
    public var structure(get, never):Null<AvatarStructure>;
    /** The port's own libraries. `assets` below is the interface's, and is a different thing. */
    public var libraries(get, never):AssetLibraryCollection;

    final _events:EventDispatcher;
    final _assets:AssetLibraryCollection;
    var _structure:Null<AvatarStructure>;
    var _isReady:Bool;
    /**
     * The one alias collection for the session (AvatarRenderManager.as:91).
     *
     * Flash builds this once, beside the structure, and `reset()`s it whenever a library lands --
     * it re-walks the manifests of whatever `_assets` holds now, so the same object stays correct
     * as libraries arrive. Recreating it per render, as the room renderer used to, meant nothing
     * owned it between renders and `createAvatarImage` had no aliases at all.
     */
    var _aliases:Null<AssetAliasCollection>;
    var _effects:Null<EffectAssetDownloadManager>;
    var _downloads:Null<AvatarFigureDownloads>;
    var _placeholderFigure:Null<AvatarFigureContainer>;

    public function new(?assets:AssetLibraryCollection) {
        _events = new EventDispatcher();
        _assets = assets != null ? assets : new AssetLibraryCollection("avatar");
        _isReady = false;
    }

    function get_events():IEventDispatcher return _events;
    function get_isReady():Bool return _isReady;
    function get_structure():Null<AvatarStructure> return _structure;
    function get_libraries():AssetLibraryCollection return _assets;

    /**
     * Build the structure from the five documents that define every avatar: the figure data, the
     * geometry, the part sets, the animations and the actions. The AS3 loads these through the
     * component's asset pipeline as each download lands; the caller does the loading here, so this
     * only has to be told when they are all in.
     */
    public function setStructure(structure:AvatarStructure):Void {
        _structure = structure;
    }

    public function setReady(ready:Bool):Void {
        _isReady = ready;
    }

    public function getAssetByName(name:String):Null<IAsset> {
        return _assets.getAssetByName(name);
    }

    public function createStructure():AvatarStructure {
        _structure = new AvatarStructure(this);
        // AvatarRenderManager.as:91 builds the alias collection here, in the same breath as the
        // structure, against the library collection this manager was given.
        _aliases = new AssetAliasCollection(this, _assets);
        _aliases.init();
        return _structure;
    }

    /**
     * A library has landed; re-read the manifests.
     *
     * AvatarRenderManager.as:217 -- the AS3 manager listens for `LIBRARY_LOADED` from its two
     * download managers and calls exactly this. The port does its own downloading, so the caller
     * announces the load instead of an event doing it.
     */
    public function resetAliases():Void {
        if (_aliases != null) _aliases.reset();
    }

    public var aliases(get, never):Null<AssetAliasCollection>;
    function get_aliases():Null<AssetAliasCollection> return _aliases;

    /**
     * The effect download manager avatar images are built against.
     *
     * AvatarRenderManager.as:208 constructs its own; this port already has one, so it is handed
     * over rather than built twice.
     */
    public function setEffectManager(effects:EffectAssetDownloadManager):Void {
        _effects = effects;
    }

    /** Supply the readiness check and the download request; see AvatarFigureDownloads. */
    public function setDownloads(downloads:AvatarFigureDownloads):Void {
        _downloads = downloads;
    }

    // ----------------------------------------------------------------- IAvatarRenderManager
    //
    // The room reaches this interface for exactly one thing: AvatarVisualizationData calls
    // createAvatarImage to build the image a room avatar draws from. The rest of the interface
    // belongs to the avatar editor -- figure validation, palette queries, the animation manager --
    // and the room never calls any of it, so those refuse rather than invent an answer.

    public function createAvatarImage(figure:String, scale:String, gender:String = null,
            listener:IAvatarImageListener = null, effectListener:_Str_936 = null):IAvatarImage {
        if (_structure == null || _aliases == null) return null;
        // AvatarRenderManager.as:310. The last argument is the *effect* listener; the image
        // listener the interface takes before it belongs to the download manager, not to
        // AvatarImage, which has no listener member at all.
        //
        var container = new AvatarFigureContainer(figure);
        // AvatarRenderManager.as:308. If everything this figure needs is already in, draw it for
        // real. Otherwise start the missing libraries, hand the listener over to be called when
        // they land, and return a placeholder in the meantime -- the same shape furniture has,
        // and the reason an avatar appears the moment the server mentions them rather than after
        // a download.
        if (_downloads == null || _downloads.isReady(figure, scale)) {
            return new AvatarImage(_structure, _aliases, container, scale, _effects,
                effectListener);
        }
        _downloads.request(figure, scale, listener);
        if (_placeholderFigure == null) {
            // AvatarRenderManager.as:47 -- the figure a not-yet-loaded avatar is drawn as.
            _placeholderFigure = new AvatarFigureContainer(PLACEHOLDER_FIGURE);
        }
        return new PlaceholderAvatarImage(_structure, _aliases, _placeholderFigure, scale,
            _effects);
    }

    /**
     * The interface's asset accessor, which is the AS3 component's own single library.
     *
     * This port holds many libraries rather than one -- see `libraries` -- and nothing on the room
     * path reads this, so there is no single library to hand back that would be true.
     */
    public var assets(get, never):IAssetLibrary;
    function get_assets():IAssetLibrary return null;

    public var mode(get, set):String;
    // RenderMode is not converted; the room never reads this and the AS3 default
    // is the normal renderer.
    function get_mode():String return "normal";
    function set_mode(value:String):String return value;

    public var _Str_906(get, never):ASDictionary<ASAny, ASAny>;
    function get__Str_906():ASDictionary<ASAny, ASAny> return null;

    public function _Str_813():IStructureData return null;

    public function getFigureStringWithFigureIds(_arg_1:String, _arg_2:String,
        _arg_3:Vector<Int>):String return _arg_1;

    public function isValidFigureSetForGender(_arg_1:Int, _arg_2:String):Bool return false;

    public function _Str_838(_arg_1:String, _arg_2:Int):Array<ASAny> return null;

    public function _Str_882(_arg_1:compat.XML):Void {}

    public function _Str_718(_arg_1:String):IAvatarFigureContainer
        return new AvatarFigureContainer(_arg_1);

    public function _Str_961(_arg_1:IAvatarFigureContainer):Bool return false;

    public function _Str_889(_arg_1:IAvatarFigureContainer, _arg_2:IAvatarImageListener):Void {}

    public function _Str_723():IAnimationManager return null;

    public function resetAssetManager():Void {}

    public function _Str_932(_arg_1:IAvatarFigureContainer, _arg_2:String,
        _arg_3:Array<ASAny> = null):Int return -1;

    public function _Str_672():Array<ASAny> return [];

    // IUnknown, which IAvatarRenderManager extends. This is not a component and is never
    // resolved through a context, so the interface plumbing has nothing to do.
    public var disposed(get, never):Bool;
    function get_disposed():Bool return false;

    public function dispose():Void {}

    public function queueInterface(identifier:com.sulake.core.runtime.IID,
        ?receiver:ASFunction):Null<com.sulake.core.runtime.IUnknown> return null;

    public function release(identifier:com.sulake.core.runtime.IID):Int return 0;
}
#end
