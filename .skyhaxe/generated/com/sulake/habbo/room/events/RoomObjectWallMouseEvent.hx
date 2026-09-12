package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.room.object.IRoomObject;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectWallMouseEvent extends RoomObjectMouseEvent 
    {
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _direction:Float = Math.NaN;
        var _wallLoc:Vector3d = null;
        var _wallWd:Vector3d = null;
        var _wallHt:Vector3d = null;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String, _arg_4:IVector3d, _arg_5:IVector3d, _arg_6:IVector3d, _arg_7:Float, _arg_8:Float, _arg_9:Float, _arg_10:Bool=false, _arg_11:Bool=false, _arg_12:Bool=false, _arg_13:Bool=false, _arg_14:Bool=false, _arg_15:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_10, _arg_11, _arg_12, _arg_13, _arg_14, _arg_15);
            this._wallLoc = new Vector3d();
            this._wallLoc.assign(_arg_4);
            this._wallWd = new Vector3d();
            this._wallWd.assign(_arg_5);
            this._wallHt = new Vector3d();
            this._wallHt.assign(_arg_6);
            this._x = _arg_7;
            this._y = _arg_8;
            this._direction = _arg_9;
        }

        public var _Str_7031(get,never):IVector3d;
public function  get__Str_7031():IVector3d
        {
            return this._wallLoc;
        }

        public var wallWidth(get,never):IVector3d;
public function  get_wallWidth():IVector3d
        {
            return this._wallWd;
        }

        public var wallHeight(get,never):IVector3d;
public function  get_wallHeight():IVector3d
        {
            return this._wallHt;
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

        public var direction(get,never):Float;
public function  get_direction():Float
        {
            return this._direction;
        }
    }

