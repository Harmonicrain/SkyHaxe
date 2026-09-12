 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomRendererFactoryBootstrap;
    import com.sulake.iid.IIDRoomRendererFactory;

     class RoomSpriteRendererLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomRendererFactoryBootstrap, IIDRoomRendererFactory];

	public function new() { super(); }
    }

