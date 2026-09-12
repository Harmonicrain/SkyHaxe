 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomObjectFactoryBootstrap;
    import com.sulake.iid.IIDRoomObjectFactory;

     class HabboRoomObjectLogicLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomObjectFactoryBootstrap, IIDRoomObjectFactory];

	public function new() { super(); }
    }

