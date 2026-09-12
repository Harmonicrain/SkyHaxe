package com.sulake.habbo.ui;

import com.sulake.core.runtime.ComponentDependency;
import com.sulake.core.runtime.IContext;
import com.sulake.core.assets.IAssetLibrary;

/** Dependency selection for the existing V24 Infostand build profile.
 * No replacement widgets or data: all setters, event listeners and routing belong to RoomUI.
 * Services outside this feature remain absent, and may inject later when implemented.
 */
class InfostandRoomUI extends RoomUI {
    public function new(context:IContext, assets:IAssetLibrary) super(context, 0, assets);

    override function get_dependencies():openfl.Vector<ComponentDependency> {
        var required = ["IIDHabboWindowManager", "IIDRoomEngine", "IIDHabboRoomSessionManager",
            "IIDSessionDataManager", "IIDAvatarRenderManager", "IIDHabboLocalizationManager",
            "IIDHabboCommunicationManager", "IIDHabboTracking", "IIDHabboAdManager"];
        var result = new openfl.Vector<ComponentDependency>();
        for (dependency in super.get_dependencies()) {
            var name = Type.getClassName(Type.getClass(dependency.identifier)).split(".").pop();
            result.push(new ComponentDependency(dependency.identifier, dependency.dependencySetter,
                required.indexOf(name) >= 0, dependency.eventListeners));
        }
        return result;
    }
}
