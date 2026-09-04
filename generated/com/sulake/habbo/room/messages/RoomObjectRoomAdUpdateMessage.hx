package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.display.BitmapData;

     class RoomObjectRoomAdUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORUM_ROOM_AD_ACTIVATE= "RORUM_ROOM_AD_ACTIVATE";
        public static inline final RORUM_ROOM_BILLBOARD_IMAGE_LOADED= "RORUM_ROOM_BILLBOARD_IMAGE_LOADED";
        public static inline final RORUM_ROOM_BILLBOARD_IMAGE_LOADING_FAILED= "RORUM_ROOM_BILLBOARD_IMAGE_LOADING_FAILED";

        var _type:String;
        var _asset:String;
        var _clickUrl:String;
        var _objectId:Int = 0;
        var _bitmapData:BitmapData;

        public function new(k:String, _arg_2:String, _arg_3:String, _arg_4:Int=-1, _arg_5:BitmapData=null)
        {
            super(null, null);
            this._type = k;
            this._asset = _arg_2;
            this._clickUrl = _arg_3;
            this._objectId = _arg_4;
            this._bitmapData = _arg_5;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var asset(get,never):String;
function  get_asset():String
        {
            return this._asset;
        }

        public var clickUrl(get,never):String;
function  get_clickUrl():String
        {
            return this._clickUrl;
        }

        public var objectId(get,never):Int;
function  get_objectId():Int
        {
            return this._objectId;
        }

        public var bitmapData(get,never):BitmapData;
function  get_bitmapData():BitmapData
        {
            return this._bitmapData;
        }
    }

