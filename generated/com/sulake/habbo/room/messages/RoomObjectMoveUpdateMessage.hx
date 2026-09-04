package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectMoveUpdateMessage extends RoomObjectUpdateMessage
    {
        var _targetLoc:IVector3d;
        var _isSlideUpdate:Bool = false;
        var _animationTime:Float = Math.NaN;
        var _skipPositionUpdate:Bool = false;
        var _overshootAnimationTime:Float = Math.NaN;
        var _curveStrength:Float = Math.NaN;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:Float=null, _arg_5:Bool=false, _arg_6:Bool=false, _arg_7:Float=null, _arg_8:Float=null)
{
            if (_arg_4 == null) _arg_4 = Math.NaN;
            if (_arg_7 == null) _arg_7 = Math.NaN;
            if (_arg_8 == null) _arg_8 = Math.NaN;
            super(k, _arg_3);
            this._isSlideUpdate = _arg_5;
            this._targetLoc = _arg_2;
            this._animationTime = _arg_4;
            this._skipPositionUpdate = _arg_6;
            this._overshootAnimationTime = _arg_7;
            this._curveStrength = _arg_8;
        }

        public var _Str_7569(get,never):IVector3d;
function  get__Str_7569():IVector3d
        {
            if (this._targetLoc == null)
            {
                return loc;
            }
            return this._targetLoc;
        }

        public var targetLoc(get,never):IVector3d;
function  get_targetLoc():IVector3d
        {
            if (this._targetLoc == null)
            {
                return loc;
            }
            return this._targetLoc;
        }

        public var realTargetLoc(get,never):IVector3d;
function  get_realTargetLoc():IVector3d
        {
            return this._targetLoc;
        }

        public var isSlideUpdate(get,never):Bool;
function  get_isSlideUpdate():Bool
        {
            return this._isSlideUpdate;
        }

        public var animationTime(get,never):Float;
function  get_animationTime():Float
        {
            return this._animationTime;
        }

        public var skipPositionUpdate(get,never):Bool;
function  get_skipPositionUpdate():Bool
        {
            return this._skipPositionUpdate;
        }

        public var overshootAnimationTime(get,never):Float;
function  get_overshootAnimationTime():Float
        {
            return this._overshootAnimationTime;
        }

        public var curveStrength(get,never):Float;
function  get_curveStrength():Float
        {
            return this._curveStrength;
        }
    }

