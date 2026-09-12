package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.room.utils.IVector3d;

     class WiredUserMovementData
    {
        public var userIndex:Int = 0;
        public var source:IVector3d;
        public var target:IVector3d;
        public var moveType:String;
        public var animationTime:Float = Math.NaN;
        public var headDirection:Int = 0;
        public var bodyDirection:Int = 0;
        public var jumpPower:Float = Math.NaN;

        public function new(k:Int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:String, _arg_5:Float, _arg_6:Int, _arg_7:Int, _arg_8:Float=null)
{
            if (_arg_8 == null) _arg_8 = Math.NaN;
            this.userIndex = k;
            this.source = _arg_2;
            this.target = _arg_3;
            this.moveType = _arg_4;
            this.animationTime = _arg_5;
            this.bodyDirection = _arg_6;
            this.headDirection = _arg_7;
            this.jumpPower = _arg_8;
        }
    }

