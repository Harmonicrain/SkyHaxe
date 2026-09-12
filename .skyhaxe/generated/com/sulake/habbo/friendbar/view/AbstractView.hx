package com.sulake.habbo.friendbar.view
;
    import com.sulake.core.runtime.Component;
	import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.tracking.IHabboTracking;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
	import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDSessionDataManager;
    import com.sulake.iid.IIDAvatarRenderManager;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboTracking;

     class AbstractView extends Component 
    {
        var _windowManager:IHabboWindowManager;
        var _avatarManager:IAvatarRenderManager;
        var _localizationManager:IHabboLocalizationManager;
        var _sessionDataManager:ISessionDataManager;
        var _tracking:IHabboTracking;
		var configurationManager:IHabboConfigurationManager;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDSessionDataManager(), function (k:ISessionDataManager)
            {
                _sessionDataManager = k;
            }), new ComponentDependency(new IIDAvatarRenderManager(), function (k:IAvatarRenderManager)
            {
                _avatarManager = k;
            }), new ComponentDependency(new IIDHabboWindowManager(), function (k:IHabboWindowManager)
            {
                _windowManager = k;
            }), new ComponentDependency(new IIDHabboLocalizationManager(), function (k:IHabboLocalizationManager)
            {
                _localizationManager = k;
            }), new ComponentDependency(new IIDHabboConfigurationManager(), function (k:IHabboConfigurationManager)
            {
                configurationManager = k;
            }), new ComponentDependency(new IIDHabboTracking(), function (k:IHabboTracking)
            {
                _tracking = k;
            })]));
        }
    }

