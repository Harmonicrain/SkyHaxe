package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetRequestWidgetMessage extends RoomWidgetMessage 
    {
        public static inline final RWRWM_USER_CHOOSER= "RWRWM_USER_CHOOSER";
        public static inline final RWRWM_FURNI_CHOOSER= "RWRWM_FURNI_CHOOSER";
        public static inline final RWRWM_FURNI_CHOOSER_ADD= "RWRWM_FURNI_CHOOSER_ADD";
        public static inline final RWRWM_ME_MENU= "RWRWM_ME_MENU";
        public static inline final RWRWM_EFFECTS= "RWRWM_EFFECTS";

        var _id:Int = 0;
        var _category:Int = 0;

        public function new(k:String, _arg_2:Int=-1, _arg_3:Int=-1)
        {
            super(k);
            this._id = _arg_2;
            this._category = _arg_3;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
    }

