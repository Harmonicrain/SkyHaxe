 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.AdManagerBootstrap;
    import com.sulake.iid.IIDHabboAdManager;

     class HabboAdManagerCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [AdManagerBootstrap, IIDHabboAdManager];

	public function new() { super(); }
    }

