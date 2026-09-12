 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomObjectVisualizationFactoryBootstrap;
    import com.sulake.iid.IIDRoomObjectVisualizationFactory;

     class HabboRoomObjectVisualizationLib extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var pet_experience_bubble_png:Class<Dynamic>;
        public static var snowball_small_png:Class<Dynamic>;
        public static var snowball_small_shadow_png:Class<Dynamic>;
        public static var shockwave_snowball_png:Class<Dynamic>;
        public static var shockwave_snowball_shadow_png:Class<Dynamic>;
        public static var shockwave_hit1:Class<Dynamic>;
        public static var shockwave_hit2:Class<Dynamic>;
        public static var shockwave_hit3:Class<Dynamic>;
        public static var snowball_big_png:Class<Dynamic>;
        public static var snowball_splash_1:Class<Dynamic>;
        public static var snowball_splash_2:Class<Dynamic>;
        public static var snowball_splash_3:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [RoomObjectVisualizationFactoryBootstrap, IIDRoomObjectVisualizationFactory];

	public function new() { super(); }
    }

