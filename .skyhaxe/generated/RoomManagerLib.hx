 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomManagerBootstrap;
    import com.sulake.iid.IIDRoomManager;

     class RoomManagerLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomManagerBootstrap, IIDRoomManager];

	public function new() { super(); }
    }

