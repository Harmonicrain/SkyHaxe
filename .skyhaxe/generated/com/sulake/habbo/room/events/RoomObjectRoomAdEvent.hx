package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectEvent;
    import com.sulake.room.object.IRoomObject;
    import flash.events.Event;

     class RoomObjectRoomAdEvent extends RoomObjectEvent 
    {
        public static inline final RORAE_ROOM_AD_LOAD_IMAGE= "RORAE_ROOM_AD_LOAD_IMAGE";
        public static inline final RORAE_ROOM_AD_FURNI_CLICK= "RORAE_ROOM_AD_FURNI_CLICK";
        public static inline final RORAE_ROOM_AD_FURNI_DOUBLE_CLICK= "RORAE_ROOM_AD_FURNI_DOUBLE_CLICK";
        public static inline final RORAE_ROOM_AD_TOOLTIP_SHOW= "RORAE_ROOM_AD_TOOLTIP_SHOW";
        public static inline final RORAE_ROOM_AD_TOOLTIP_HIDE= "RORAE_ROOM_AD_TOOLTIP_HIDE";

        var _imageUrl:String = "";
        var _clickUrl:String = "";

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String="", _arg_4:String="", _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_5, _arg_6);
            this._imageUrl = _arg_3;
            this._clickUrl = _arg_4;
        }

        public var clickUrl(get,never):String;
public function  get_clickUrl():String
        {
            return this._clickUrl;
        }

        public var imageUrl(get,never):String;
public function  get_imageUrl():String
        {
            return this._imageUrl;
        }

        override public function clone():Event
        {
            return new RoomObjectRoomAdEvent(type, object, this.imageUrl, this.clickUrl, bubbles, cancelable);
        }
    }

