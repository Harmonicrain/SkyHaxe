 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboConfigurationManagerBootstrap;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.habbo.configuration.HabboConfigurationManager;

     class HabboConfigurationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array<ASAny> = [HabboConfigurationManagerBootstrap, IIDHabboConfigurationManager, HabboConfigurationManager];
        public static var manifest:Class<Dynamic>;
        public static var localization_configuration:Class<Dynamic>;

	public function new() { super(); }
    }

