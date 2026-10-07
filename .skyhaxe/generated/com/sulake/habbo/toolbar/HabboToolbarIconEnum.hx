package com.sulake.habbo.toolbar
;

     class HabboToolbarIconEnum 
    {
        public static inline final HELP= "HTIE_ICON_HELP";
        public static inline final NAVIGATOR= "HTIE_ICON_NAVIGATOR";
        public static inline final CATALOGUE= "HTIE_ICON_CATALOGUE";
        public static inline final INVENTORY= "HTIE_ICON_INVENTORY";
        public static inline final QUESTS= "HTIE_ICON_QUESTS";
        public static inline final PROGRESSION= "HTIE_ICON_PROGRESSION";
        public static inline final ACHIEVEMENTS= "HTIE_ICON_ACHIEVEMENTS";
        public static inline final WIRED_MENU= "HTIE_ICON_WIRED_MENU";
        public static inline final MEMENU= "HTIE_ICON_MEMENU";
        public static inline final GAMES= "HTIE_ICON_GAMES";
        public static inline final STORIES= "HTIE_ICON_STORIES";
        public static inline final RECEPTION= "HTIE_ICON_RECEPTION";
        public static inline final HOME= "HTIE_ICON_HOME";
        public static inline final GUIDE= "HTIE_ICON_GUIDE";
        public static inline final BUILDER= "HTIE_ICON_BUILDER";
        public static inline final CAMERA= "HTIE_ICON_CAMERA";
        public static inline final ROOMINFO= "HTIE_ICON_ROOMINFO";
        public static inline final EXT_GROUP= "HTIE_EXT_GROUP";
        public static inline final NAVIGATOR_ME_TAB= "HTIE_ICON_NAVIGATOR_ME_TAB";
		public static inline final MODTOOL= "HTIE_ICON_MODTOOL";
        static final _TOOLBAR_NAMES:ASDictionary<ASAny,ASAny> = new ASDictionary();


        public static function getIconName(k:String):String
        {
            return _TOOLBAR_NAMES[k];
        }

	public function new() {}

	static final ___init = {

        {
            _TOOLBAR_NAMES[HELP] = "HELP";
            _TOOLBAR_NAMES[NAVIGATOR] = "NAVIGATOR";
            _TOOLBAR_NAMES[CATALOGUE] = "CATALOGUE";
            _TOOLBAR_NAMES[INVENTORY] = "INVENTORY";
            _TOOLBAR_NAMES[QUESTS] = "QUESTS";
            _TOOLBAR_NAMES[PROGRESSION] = "PROGRESSION";
            _TOOLBAR_NAMES[ACHIEVEMENTS] = "ACHIEVEMENTS";
            _TOOLBAR_NAMES[WIRED_MENU] = "WIRED_MENU";
            _TOOLBAR_NAMES[MEMENU] = "MEMENU";
            _TOOLBAR_NAMES[GAMES] = "GAMES";
            _TOOLBAR_NAMES[STORIES] = "STORIES";
            _TOOLBAR_NAMES[RECEPTION] = "RECEPTION";
            _TOOLBAR_NAMES[HOME] = "HOME";
            _TOOLBAR_NAMES[GUIDE] = "GUIDE";
            _TOOLBAR_NAMES[BUILDER] = "BUILDER";
            _TOOLBAR_NAMES[CAMERA] = "CAMERA";
			_TOOLBAR_NAMES[MODTOOL] = "MODTOOL";
        }

	null;
	};
    }

