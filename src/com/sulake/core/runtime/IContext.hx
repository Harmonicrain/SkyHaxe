package com.sulake.core.runtime;

import com.sulake.core.assets.AssetLibrary;
import openfl.events.EventDispatcher;
import openfl.display.DisplayObjectContainer;

interface IContext extends IUnknown {
    public var assets(get, never):com.sulake.core.assets.IAssetLibrary;
    public var events(get, never):openfl.events.IEventDispatcher;
    public var root(get, never):IContext;
    public var displayObjectContainer(get, never):DisplayObjectContainer;

    /**
     * The hotel's configuration.
     *
     * RoomManager reads `stories.image_url_base`, `extra_data_service_url` and
     * `extra_data_batches_enabled` off it to give every visualization its external base URLs, and
     * Component carries it down to each child context, so the seam has to declare it even though
     * the configuration component itself is unconverted. IContext.as declares both accessors.
     */
    public var configuration(get, set):Null<IHabboConfigurationManager>;

    public function attachComponent(component:Component, identifiers:Array<IID>):Void;
    public function detachComponent(component:Component):Void;

    // Component's own lifecycle registers and removes itself here; IContext.as declares both.
    public function registerUpdateReceiver(receiver:IUpdateReceiver, priority:UInt):Void;
    public function removeUpdateReceiver(receiver:IUpdateReceiver):Void;
    public function createLinkEvent(link:String):Void;
    public var linkEventTrackers(get, never):openfl.Vector<com.sulake.core.runtime.events.ILinkEventTracker>;
    public function addLinkEventTracker(tracker:com.sulake.core.runtime.events.ILinkEventTracker):Void;
    public function removeLinkEventTracker(tracker:com.sulake.core.runtime.events.ILinkEventTracker):Void;

    /** Diagnostic surface consumed by the original HabboTracking component. */
    public function getLastErrorMessage():String;
    public function error(message:String, fatal:Bool, category:Int = -1, cause:Dynamic = null):Void;
    public function debug(message:String):Void;
    public function getLastDebugMessage():String;
    public function warning(message:String):Void;
    public function getLastWarningMessage():String;
}
