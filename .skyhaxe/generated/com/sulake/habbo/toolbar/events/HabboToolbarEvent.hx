package com.sulake.habbo.toolbar.events
;
    import flash.events.Event;

     class HabboToolbarEvent extends Event 
    {
        public static inline final HTE_TOOLBAR_CLICK= "HTE_TOOLBAR_CLICK";
        public static inline final HTE_GROUP_ROOM_INFO_CLICK= "HTE_GROUP_ROOM_INFO_CLICK";
        public static inline final HTIE_ICON_ZOOM= "HTIE_ICON_ZOOM";
        public static inline final HTE_RESIZED= "HTE_RESIZED";
        public static inline final HTE_ICON_CAMERA= "HTE_ICON_CAMERA";
		public static inline final ICON_MODTOOL= "HTE_ICON_MODTOOL";
        public static inline final ROOMTOOLSMENU= "roomToolsMenu";
        public static inline final CHATCAMERACOMMAND= "chatCameraCommand";
        public static inline final IMAGEWIDGETMAKEOWN= "imageWidgetMakeOwn";
        public static inline final TOOLBARCAMERAICON= "toolBarCameraIcon";

        var _iconId:String;
        var _iconName:String;

        public function new(type:String, bubbles:Bool=false, cancelable:Bool=false)
        {
            super(type, bubbles, cancelable);
        }

        
        public var iconId(get,set):String;
public function  set_iconId(k:String):String        {
            return this._iconId = k;
        }
public function  get_iconId():String
        {
            return this._iconId;
        }

        
        public var iconName(get,set):String;
public function  set_iconName(k:String):String        {
            return this._iconName = k;
        }
public function  get_iconName():String
        {
            return this._iconName;
        }
    }

