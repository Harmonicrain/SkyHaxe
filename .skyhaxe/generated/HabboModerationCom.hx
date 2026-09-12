 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.ModerationManagerBootstrap;
    import com.sulake.iid.IIDHabboModeration;

     class HabboModerationCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [ModerationManagerBootstrap, IIDHabboModeration];
        public static var evidence_frame_xml:Class<Dynamic>;
        public static var issue_browser_xml:Class<Dynamic>;
        public static var modact_summary_xml:Class<Dynamic>;
        public static var send_msgs_xml:Class<Dynamic>;
        public static var start_panel_xml:Class<Dynamic>;
        public static var user_info_xml:Class<Dynamic>;
        public static var user_info_frame_xml:Class<Dynamic>;
        public static var issue_handler_xml:Class<Dynamic>;
        public static var roomtool_frame_xml:Class<Dynamic>;
        public static var roomvisits_frame_xml:Class<Dynamic>;
        public static var userclassification_frame_xml:Class<Dynamic>;
        public static var room_icon_png:Class<Dynamic>;
        public static var user_icon_png:Class<Dynamic>;
		public static var moderation_icon_xml:Class<Dynamic>;
		public static var moderation_m_icon_png:Class<Dynamic>;

	public function new() { super(); }
    }

