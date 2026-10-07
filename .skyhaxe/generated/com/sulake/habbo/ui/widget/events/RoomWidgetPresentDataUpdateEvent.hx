package com.sulake.habbo.ui.widget.events
;
    import flash.display.BitmapData;

     class RoomWidgetPresentDataUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWPDUE_PACKAGEINFO= "RWPDUE_PACKAGEINFO";
        public static inline final RWPDUE_CONTENTS= "RWPDUE_CONTENTS";
        public static inline final RWPDUE_CONTENTS_CLUB= "RWPDUE_CONTENTS_CLUB";
        public static inline final RWPDUE_CONTENTS_FLOOR= "RWPDUE_CONTENTS_FLOOR";
        public static inline final RWPDUE_CONTENTS_LANDSCAPE= "RWPDUE_CONTENTS_LANDSCAPE";
        public static inline final RWPDUE_CONTENTS_WALLPAPER= "RWPDUE_CONTENTS_WALLPAPER";
        public static inline final RWPDUE_CONTENTS_IMAGE= "RWPDUE_CONTENTS_IMAGE";

        var _objectId:Int = -1;
        var _classId:Int = 0;
        var _itemType:String = "";
        var _text:String;
        var _controller:Bool = false;
        var _Str_12168:BitmapData;
        var _Str_19174:String;
        var _Str_19510:String;
        var _placedItemId:Int = -1;
        var _placedItemType:String = "";
        var _placedInRoom:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:Bool=false, _arg_5:BitmapData=null, _arg_6:String=null, _arg_7:String=null, _arg_8:Bool=false, _arg_9:Bool=false)
        {
            super(k, _arg_8, _arg_9);
            this._objectId = _arg_2;
            this._text = _arg_3;
            this._controller = _arg_4;
            this._Str_12168 = _arg_5;
            this._Str_19174 = _arg_6;
            this._Str_19510 = _arg_7;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        
        public var classId(get,set):Int;
public function  get_classId():Int
        {
            return this._classId;
        }
public function  set_classId(k:Int):Int        {
            return this._classId = k;
        }

        
        public var itemType(get,set):String;
public function  get_itemType():String
        {
            return this._itemType;
        }
public function  set_itemType(k:String):String        {
            return this._itemType = k;
        }

        public var text(get,never):String;
public function  get_text():String
        {
            return this._text;
        }

        public var controller(get,never):Bool;
public function  get_controller():Bool
        {
            return this._controller;
        }

        public var _Str_11625(get,never):BitmapData;
public function  get__Str_11625():BitmapData
        {
            return this._Str_12168;
        }

        public var _Str_22956(get,never):String;
public function  get__Str_22956():String
        {
            return this._Str_19174;
        }

        public var _Str_23105(get,never):String;
public function  get__Str_23105():String
        {
            return this._Str_19510;
        }

        
        public var placedItemId(get,set):Int;
public function  get_placedItemId():Int
        {
            return this._placedItemId;
        }
public function  set_placedItemId(k:Int):Int        {
            return this._placedItemId = k;
        }

        
        public var isPlacedInRoom(get,set):Bool;
public function  get_isPlacedInRoom():Bool
        {
            return this._placedInRoom;
        }
public function  set_isPlacedInRoom(k:Bool):Bool        {
            return this._placedInRoom = k;
        }

        
        public var placedItemType(get,set):String;
public function  get_placedItemType():String
        {
            return this._placedItemType;
        }
public function  set_placedItemType(k:String):String        {
            return this._placedItemType = k;
        }
    }

