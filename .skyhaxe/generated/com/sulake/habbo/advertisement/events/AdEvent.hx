package com.sulake.habbo.advertisement.events
;
    import flash.events.Event;
    import flash.display.BitmapData;

     class AdEvent extends Event 
    {
        public static inline final ROOM_AD_IMAGE_LOADED= "AE_ROOM_AD_IMAGE_LOADED";
        public static inline final ROOM_AD_IMAGE_LOADING_FAILED= "AE_ROOM_AD_IMAGE_LOADING_FAILED";
        public static inline final ROOM_AD_SHOW= "AE_ROOM_AD_SHOW";

        var _image:BitmapData;
        var _roomId:Int = 0;
        var _imageUrl:String;
        var _clickUrl:String;
        var _adWarningL:BitmapData;
        var _adWarningR:BitmapData;
        var _objectId:Int = 0;
        var _objectCategory:Int = 0;

        public function new(k:String, roomId:Int, image:BitmapData=null, imageUrl:String="", clickUrl:String="", adWarningL:BitmapData=null, adWarningR:BitmapData=null, objectId:Int=-1, objectCategory:Int=-1, _arg_10:Bool=false, _arg_11:Bool=false)
        {
            super(k, _arg_10, _arg_11);
            this._image = image;
            this._roomId = roomId;
            this._imageUrl = imageUrl;
            this._clickUrl = clickUrl;
            this._adWarningL = adWarningL;
            this._adWarningR = adWarningR;
            this._objectId = objectId;
            this._objectCategory = objectCategory;
        }

        public var image(get,never):BitmapData;
public function  get_image():BitmapData
        {
            return this._image;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var imageUrl(get,never):String;
public function  get_imageUrl():String
        {
            return this._imageUrl;
        }

        public var clickUrl(get,never):String;
public function  get_clickUrl():String
        {
            return this._clickUrl;
        }

        public var adWarningL(get,never):BitmapData;
public function  get_adWarningL():BitmapData
        {
            return this._adWarningL;
        }

        public var adWarningR(get,never):BitmapData;
public function  get_adWarningR():BitmapData
        {
            return this._adWarningR;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var objectCategory(get,never):Int;
public function  get_objectCategory():Int
        {
            return this._objectCategory;
        }
    }

