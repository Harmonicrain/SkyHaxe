package com.sulake.room.messages
;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectUpdateMessage 
    {
        var _loc:IVector3d;
        var _dir:IVector3d;

        public function new(k:IVector3d, _arg_2:IVector3d)
        {
            this._loc = k;
            this._dir = _arg_2;
        }

        public var loc(get,never):IVector3d;
public function  get_loc():IVector3d
        {
            return this._loc;
        }

        public var dir(get,never):IVector3d;
public function  get_dir():IVector3d
        {
            return this._dir;
        }
    }

