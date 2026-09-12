package com.sulake.habbo.ui.widget.messages
;
    import com.sulake.core.window.IWindowContainer;

     class RoomWidgetAvatarEditorMessage extends RoomWidgetMessage 
    {
        public static inline final RWCM_OPEN_AVATAR_EDITOR= "RWCM_OPEN_AVATAR_EDITOR";
        public static inline final RWCM_GET_WARDROBE= "RWCM_GET_WARDROBE";
        public static inline final RWAEM_AVATAR_EDITOR_VIEW_DISPOSED= "RWAEM_AVATAR_EDITOR_VIEW_DISPOSED";

        var _context:IWindowContainer;

        public function new(k:String, _arg_2:IWindowContainer=null)
        {
            super(k);
            this._context = _arg_2;
        }

        public var context(get,never):IWindowContainer;
public function  get_context():IWindowContainer
        {
            return this._context;
        }
    }

