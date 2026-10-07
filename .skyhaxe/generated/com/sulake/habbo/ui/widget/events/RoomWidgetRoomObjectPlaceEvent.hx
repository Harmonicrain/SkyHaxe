package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetRoomObjectPlaceEvent extends RoomWidgetRoomObjectUpdateEvent 
    {
        public static inline final OBJECT_PLACED= "RWROUE_OBJECT_PLACED";

        var _wallLocation:String;
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _z:Float = Math.NaN;
        var _direction:Int = 0;
        var _placedInRoom:Bool = false;
        var _placedOnFloor:Bool = false;
        var _placedOnWall:Bool = false;
        var _instanceData:String;
        var _placementSource:String;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:Float, _arg_7:Float, _arg_8:Float, _arg_9:Int, _arg_10:Bool, _arg_11:Bool, _arg_12:Bool, _arg_13:String, _arg_14:String, _arg_15:Bool=false, _arg_16:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_15, _arg_16);
            this._wallLocation = _arg_5;
            this._x = _arg_6;
            this._y = _arg_7;
            this._z = _arg_8;
            this._direction = _arg_9;
            this._placedInRoom = _arg_10;
            this._placedOnFloor = _arg_11;
            this._placedOnWall = _arg_12;
            this._instanceData = _arg_13;
            this._placementSource = _arg_14;
        }

        public var wallLocation(get,never):String;
public function  get_wallLocation():String
        {
            return this._wallLocation;
        }

        public var x(get,never):Float;
public function  get_x():Float
        {
            return this._x;
        }

        public var y(get,never):Float;
public function  get_y():Float
        {
            return this._y;
        }

        public var z(get,never):Float;
public function  get_z():Float
        {
            return this._z;
        }

        public var direction(get,never):Int;
public function  get_direction():Int
        {
            return this._direction;
        }

        public var placedInRoom(get,never):Bool;
public function  get_placedInRoom():Bool
        {
            return this._placedInRoom;
        }

        public var placedOnFloor(get,never):Bool;
public function  get_placedOnFloor():Bool
        {
            return this._placedOnFloor;
        }

        public var placedOnWall(get,never):Bool;
public function  get_placedOnWall():Bool
        {
            return this._placedOnWall;
        }

        public var instanceData(get,never):String;
public function  get_instanceData():String
        {
            return this._instanceData;
        }

        public var placementSource(get,never):String;
public function  get_placementSource():String
        {
            return this._placementSource;
        }
    }

