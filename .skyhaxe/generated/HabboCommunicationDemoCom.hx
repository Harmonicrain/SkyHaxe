 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboCommunicationDemoBootstrap;

     class HabboCommunicationDemoCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var login_window:Class<Dynamic>;
        public static var login_environment_list_item:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboCommunicationDemoBootstrap];

	public function new() { super(); }
    }

