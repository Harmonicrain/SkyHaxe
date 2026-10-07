package com.sulake.habbo.help._enum
;
    import flash.events.Event;

     class HabboHelpTutorialEvent extends Event 
    {
        public static inline final HHTPNUFWE_AVATAR_TUTORIAL_START= "HHTPNUFWE_AVATAR_TUTORIAL_START";
        public static inline final HHTPNUFWE_LIGHT_CLOTHES_ICON= "HHTPNUFWE_LIGHT_CLOTHES_ICON";
        public static inline final HHTE_DONE_AVATAR_EDITOR_OPENING= "HHTE_DONE_AVATAR_EDITOR_OPENING";
        public static inline final HHTE_DONE_AVATAR_EDITOR_CLOSING= "HHTE_DONE_AVATAR_EDITOR_CLOSING";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

