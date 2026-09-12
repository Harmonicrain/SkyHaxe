 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.SessionDataManagerBootstrap;
    import com.sulake.iid.IIDSessionDataManager;

     class HabboSessionDataManagerLib extends SimpleApplication 
    {
        public static var requiredClasses:Array<ASAny> = [SessionDataManagerBootstrap, IIDSessionDataManager];
        public static var manifest:Class<Dynamic>;
        public static var loading_icon:Class<Dynamic>;

	public function new() { super(); }
    }

