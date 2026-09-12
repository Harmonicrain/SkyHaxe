 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboNotificationsBootstrap;
    import com.sulake.iid.IIDHabboNotifications;

     class HabboNotificationsCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var habbo_notifications_config_xml:Class<Dynamic>;
        public static var if_icon_temp_png:Class<Dynamic>;
        public static var if_icon_hc_png:Class<Dynamic>;
        public static var if_icon_vip_png:Class<Dynamic>;
        public static var if_icon_recycler_png:Class<Dynamic>;
        public static var if_icon_friend_bg_blue_png:Class<Dynamic>;
        public static var if_icon_duckets_png:Class<Dynamic>;
        public static var if_icon_loyalty_png:Class<Dynamic>;
        public static var if_icon_diamond_png:Class<Dynamic>;
        public static var chests_icon_chest_capacity_exceeds:Class<Dynamic>;
        public static var chests_icon_chest_donation:Class<Dynamic>;
        public static var chests_icon_chest_empty:Class<Dynamic>;
        public static var chests_icon_chest_full:Class<Dynamic>;
        public static var chests_icon_chest_wired_transaction:Class<Dynamic>;
        public static var chests_icon_chest_withdraw:Class<Dynamic>;
        public static var chests_icon_rejected:Class<Dynamic>;
        public static var chests_icon_successful:Class<Dynamic>;
        public static var chests_icon_trading_error:Class<Dynamic>;
        public static var motd_notification_xml:Class<Dynamic>;
        public static var motd_notification_item_xml:Class<Dynamic>;
        public static var layout_notification_xml:Class<Dynamic>;
        public static var layout_notification_wired_xml:Class<Dynamic>;
        public static var layout_notifications_browser_xml:Class<Dynamic>;
        public static var club_gift_notification_xml:Class<Dynamic>;
        public static var safety_locked_notification_xml:Class<Dynamic>;
        public static var layout_notification_popup_xml:Class<Dynamic>;
        public static var discord_box_png:Class<Dynamic>;
        public static var icon_curator_stamp_large_png:Class<Dynamic>;
        public static var discord_activity_dialog_xml:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboNotificationsBootstrap, IIDHabboNotifications];

	public function new() { super(); }
    }

