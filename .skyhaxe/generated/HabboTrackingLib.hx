 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboTrackingBootstrap;
    import com.sulake.iid.IIDHabboTracking;

     class HabboTrackingLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboTrackingBootstrap, IIDHabboTracking];

	public function new() { super(); }
    }

