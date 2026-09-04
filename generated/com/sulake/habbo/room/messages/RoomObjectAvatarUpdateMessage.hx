package com.sulake.habbo.room.messages
;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectAvatarUpdateMessage extends RoomObjectMoveUpdateMessage
    {
        var _dirHead:Int = 0;
        var _canStandUp:Bool = false;
        var _baseY:Float = Math.NaN;
        var _jumpingPower:Float = Math.NaN;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:Int, _arg_5:Bool, _arg_6:Float, _arg_7:Float=null, _arg_8:Bool=false, _arg_9:Float=null)
{
            if (_arg_7 == null) _arg_7 = Math.NaN;
            if (_arg_9 == null) _arg_9 = Math.NaN;
            super(k, _arg_2, _arg_3, _arg_7, false, _arg_8);
            this._dirHead = _arg_4;
            this._canStandUp = _arg_5;
            this._baseY = _arg_6;
            this._jumpingPower = _arg_9;
        }

        public var jumpingPower(get,never):Float;
function  get_jumpingPower():Float
        {
            return this._jumpingPower;
        }

        public var dirHead(get,never):Int;
function  get_dirHead():Int
        {
            return this._dirHead;
        }

        public var canStandUp(get,never):Bool;
function  get_canStandUp():Bool
        {
            return this._canStandUp;
        }

        public var baseY(get,never):Float;
function  get_baseY():Float
        {
            return this._baseY;
        }
    }

