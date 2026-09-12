 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboNewNavigatorBootstrap;
    import com.sulake.iid.IIDHabboNewNavigator;

     class HabboNewNavigatorCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var navigator_frame_2_xml:Class<Dynamic>;
        public static var room_info_popup_bubble_xml:Class<Dynamic>;
        public static var property_xml:Class<Dynamic>;
        public static var tag_xml:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboNewNavigatorBootstrap, IIDHabboNewNavigator];

	public function new() { super(); }
    }

