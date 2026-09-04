package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class WiredWallItemMovementData
    {
        public var itemId:Int = 0;
        public var isDirectionRight:Bool = false;
        public var oldWallX:Int = 0;
        public var oldWallY:Int = 0;
        public var oldOffsetX:Int = 0;
        public var oldOffsetY:Int = 0;
        public var newWallX:Int = 0;
        public var newWallY:Int = 0;
        public var newOffsetX:Int = 0;
        public var newOffsetY:Int = 0;
        public var animationTime:Int = 0;

        public function new(k:Int, _arg_2:Bool, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int, _arg_8:Int, _arg_9:Int, _arg_10:Int, _arg_11:Int)
        {
            this.itemId = k;
            this.isDirectionRight = _arg_2;
            this.oldWallX = _arg_3;
            this.oldWallY = _arg_4;
            this.oldOffsetX = _arg_5;
            this.oldOffsetY = _arg_6;
            this.newWallX = _arg_7;
            this.newWallY = _arg_8;
            this.newOffsetX = _arg_9;
            this.newOffsetY = _arg_10;
            this.animationTime = _arg_11;
        }
    }

