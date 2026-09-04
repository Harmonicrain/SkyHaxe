package com.sulake.habbo.communication.messages.incoming.room.engine
;
     class WiredUserDirectionData
    {
        public var userIndex:Int = 0;
        public var headDirection:Int = 0;
        public var bodyDirection:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this.userIndex = k;
            this.bodyDirection = _arg_2;
            this.headDirection = _arg_3;
        }
    }

