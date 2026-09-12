 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboMessengerBootstrap;
    import com.sulake.iid.IIDHabboMessenger;

     class HabboMessengerCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var close_png:Class<Dynamic>;
        public static var convo_bg_png:Class<Dynamic>;
        public static var follow_friend_png:Class<Dynamic>;
        public static var minimail_png:Class<Dynamic>;
        public static var next_png:Class<Dynamic>;
        public static var prev_png:Class<Dynamic>;
        public static var resize_png:Class<Dynamic>;
        public static var tab_bg_hilite_png:Class<Dynamic>;
        public static var tab_bg_next_png:Class<Dynamic>;
        public static var tab_bg_sel_png:Class<Dynamic>;
        public static var tab_bg_unsel_png:Class<Dynamic>;
        public static var main_window_xml:Class<Dynamic>;
        public static var msg_entry_xml:Class<Dynamic>;
        public static var tab_entry_xml:Class<Dynamic>;
        public static var messenger_xml:Class<Dynamic>;
        public static var messenger_habbicon_picker_xml:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboMessengerBootstrap, IIDHabboMessenger];

	public function new() { super(); }
    }

