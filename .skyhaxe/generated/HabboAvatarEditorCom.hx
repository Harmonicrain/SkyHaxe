 

    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboAvatarEditorManagerBootstrap;
    import com.sulake.iid.IIDHabboAvatarEditor;

     class HabboAvatarEditorCom extends SimpleApplication 
    {
        public static var requiredClasses:Array<ASAny> = [HabboAvatarEditorManagerBootstrap, IIDHabboAvatarEditor];
        public static var manifest:Class<Dynamic>;
        public static var AvatarEditor:Class<Dynamic>;
        public static var AvatarEditorFrame:Class<Dynamic>;
        public static var AvatarEditorContent:Class<Dynamic>;
        public static var StripClubItemsInfo:Class<Dynamic>;
        public static var Outfit:Class<Dynamic>;
        public static var avatareditor_wardrobe_base:Class<Dynamic>;
        public static var avatar_editor_effect_griditem_xml:Class<Dynamic>;
        public static var avatar_editor_name_change:Class<Dynamic>;
        public static var avatar_editor_name_change_item:Class<Dynamic>;

	public function new() { super(); }
    }

