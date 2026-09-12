 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboLocalizationManagerBootstrap;
    import com.sulake.iid.IIDCoreLocalizationManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.localization.HabboLocalizationManager;

     class HabboLocalizationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array<ASAny> = [HabboLocalizationManagerBootstrap, IIDCoreLocalizationManager, IIDHabboLocalizationManager, ICoreLocalizationManager, IHabboLocalizationManager, HabboLocalizationManager];
        public static var manifest:Class<Dynamic>;

	public function new() { super(); }
    }

