package com.sulake.habbo.ui.widget.events
;
     class _Str_4178 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWCCE_USER_CHOOSER_CONTENT= "RWCCE_USER_CHOOSER_CONTENT";
        public static inline final RWCCE_FURNI_CHOOSER_CONTENT= "RWCCE_FURNI_CHOOSER_CONTENT";
        public static inline final RWCCE_FURNI_CHOOSER_CONTENT_ADD= "RWCCE_FURNI_CHOOSER_CONTENT_ADD";

        var _items:Array<ASAny>;
        var _isAnyRoomController:Bool = false;

        public function new(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=false, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(k, _arg_4, _arg_5);
            this._items = _arg_2.slice(0);
            this._isAnyRoomController = _arg_3;
        }

        public var items(get,never):Array<ASAny>;
public function  get_items():Array<ASAny>
        {
            return this._items;
        }

        public var isAnyRoomController(get,never):Bool;
public function  get_isAnyRoomController():Bool
        {
            return this._isAnyRoomController;
        }
    }

