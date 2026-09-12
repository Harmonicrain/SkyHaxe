 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomEngineBootstrap;
    import com.sulake.iid.IIDRoomEngine;

     class HabboRoomEngineCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomEngineBootstrap, IIDRoomEngine];

	public function new() { super(); }
    }

