 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboCommunicationManagerBootstrap;
    import com.sulake.iid.IIDHabboCommunicationManager;

     class HabboCommunicationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array<ASAny> = [HabboCommunicationManagerBootstrap, IIDHabboCommunicationManager];
        public static var manifest:Class<Dynamic>;

	public function new() { super(); }
    }

