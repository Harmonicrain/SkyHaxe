 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomSessionManagerBootstrap;
    import com.sulake.iid.IIDHabboRoomSessionManager;

     class HabboRoomSessionManagerLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomSessionManagerBootstrap, IIDHabboRoomSessionManager];

	public function new() { super(); }
    }

