package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectHeightUpdateMessage extends RoomObjectUpdateMessage 
    {
        var _height:Float = Math.NaN;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:Float)
        {
            super(k, _arg_2);
            this._height = _arg_3;
        }

        public var height(get,never):Float;
public function  get_height():Float
        {
            return this._height;
        }
    }

