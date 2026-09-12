 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.CoreCommunicationManagerBootstrap;
    import com.sulake.iid.IIDCoreCommunicationManager;

     class CoreCommunicationFrameworkLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [CoreCommunicationManagerBootstrap, IIDCoreCommunicationManager];

	public function new() { super(); }
    }

