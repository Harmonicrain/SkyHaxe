 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboGroupsManagerBootstrap;
    import com.sulake.iid.IIDHabboGroupsManager;

     class HabboGroupsCom extends SimpleApplication 
    {
        public static var manifest:Class<Dynamic>;
        public static var group:Class<Dynamic>;
        public static var guild_members_window:Class<Dynamic>;
        public static var group_entry:Class<Dynamic>;
        public static var member_entry:Class<Dynamic>;
        public static var group_info_window:Class<Dynamic>;
        public static var group_management_window:Class<Dynamic>;
        public static var new_extended_profile:Class<Dynamic>;
        public static var club_required:Class<Dynamic>;
        public static var group_created_window:Class<Dynamic>;
        public static var group_room_info:Class<Dynamic>;
        public static var no_groups:Class<Dynamic>;
        public static var badge_color_item:Class<Dynamic>;
        public static var badge_editor:Class<Dynamic>;
        public static var badge_layer:Class<Dynamic>;
        public static var badge_part_item:Class<Dynamic>;
        public static var color_chooser_bg:Class<Dynamic>;
        public static var color_chooser_fg:Class<Dynamic>;
        public static var color_chooser_selected:Class<Dynamic>;
        public static var part_preview_bg:Class<Dynamic>;
        public static var position_grid:Class<Dynamic>;
        public static var position_picker:Class<Dynamic>;
        public static var badge_part_add:Class<Dynamic>;
        public static var badge_part_empty:Class<Dynamic>;
        public static var badge_part_picker:Class<Dynamic>;
        public static var requiredClasses:Array<ASAny> = [HabboGroupsManagerBootstrap, IIDHabboGroupsManager];

	public function new() { super(); }
    }

