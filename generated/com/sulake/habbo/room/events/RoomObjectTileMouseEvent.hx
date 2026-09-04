package com.sulake.habbo.room.events
;
    import com.sulake.room.events.RoomObjectMouseEvent;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectTileMouseEvent extends RoomObjectMouseEvent 
    {
        var _tileX:Float = Math.NaN;
        var _tileY:Float = Math.NaN;
        var _tileZ:Float = Math.NaN;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String, _arg_4:Float, _arg_5:Float, _arg_6:Float, _arg_7:Bool=false, _arg_8:Bool=false, _arg_9:Bool=false, _arg_10:Bool=false, _arg_11:Bool=false, _arg_12:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11, _arg_12);
            this._tileX = _arg_4;
            this._tileY = _arg_5;
            this._tileZ = _arg_6;
        }

        public var tileX(get,never):Float;
function  get_tileX():Float
        {
            return this._tileX;
        }

        public var tileY(get,never):Float;
function  get_tileY():Float
        {
            return this._tileY;
        }

        public var tileZ(get,never):Float;
function  get_tileZ():Float
        {
            return this._tileZ;
        }

        public var tileXAsInt(get,never):Int;
function  get_tileXAsInt():Int
        {
            return Std.int(this._tileX + 0.499);
        }

        public var tileYAsInt(get,never):Int;
function  get_tileYAsInt():Int
        {
            return Std.int(this._tileY + 0.499);
        }

        public var tileZAsInt(get,never):Int;
function  get_tileZAsInt():Int
        {
            return Std.int(this._tileZ + 0.499);
        }
    }

