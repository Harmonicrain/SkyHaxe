package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectRoomMaskUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORMUM_ADD_MASK= "RORMUM_ADD_MASK";
        public static inline final REMOVE_MASK= "RORMUM_ADD_MASK";
        public static inline final DOOR= "door";
        public static inline final WINDOW= "window";
        public static inline final HOLE= "hole";

        var _type:String = "";
        var _maskId:String = "";
        var _maskType:String = "";
        var _maskLoc:Vector3d = null;
        var _maskCategory:String = "window";

        public function new(k:String, _arg_2:String, _arg_3:String=null, _arg_4:IVector3d=null, _arg_5:String="window")
        {
            super(null, null);
            this._type = k;
            this._maskId = _arg_2;
            this._maskType = _arg_3;
            if (_arg_4 != null)
            {
                this._maskLoc = new Vector3d(_arg_4.x, _arg_4.y, _arg_4.z);
            }
            this._maskCategory = _arg_5;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var maskId(get,never):String;
public function  get_maskId():String
        {
            return this._maskId;
        }

        public var maskType(get,never):String;
public function  get_maskType():String
        {
            return this._maskType;
        }

        public var maskLocation(get,never):IVector3d;
public function  get_maskLocation():IVector3d
        {
            return this._maskLoc;
        }

        public var maskCategory(get,never):String;
public function  get_maskCategory():String
        {
            return this._maskCategory;
        }
    }

