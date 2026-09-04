package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.room.utils.IVector3d;

     class WiredFurniMovementData
    {
        public var furniId:Int = 0;
        public var source:IVector3d;
        public var target:IVector3d;
        public var rotation:Int = 0;
        public var animationTime:Float = Math.NaN;
        public var overshootingDistance:Float = Math.NaN;
        public var curveStrength:Float = Math.NaN;

        public function new(k:Int, _arg_2:IVector3d, _arg_3:IVector3d, _arg_4:Int, _arg_5:Float, _arg_6:Float=null, _arg_7:Float=null)
{
            if (_arg_6 == null) _arg_6 = Math.NaN;
            if (_arg_7 == null) _arg_7 = Math.NaN;
            this.furniId = k;
            this.source = _arg_2;
            this.target = _arg_3;
            this.rotation = _arg_4;
            this.animationTime = _arg_5;
            this.overshootingDistance = _arg_6;
            this.curveStrength = _arg_7;
        }
    }

