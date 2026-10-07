package com.sulake.core.window.utils
;
     class DefaultAttStruct 
    {
        public static var hasRectLimits:Bool = true;

        public var color:UInt = 0xFFFFFF;
        public var background:Bool = false;
        public var blend:Float = 1;
        public var threshold:UInt = 10;
        public var width_min:Int = Std.int(-2147483648);
        public var width_max:Int = 2147483647;
        public var height_min:Int = Std.int(-2147483648);
        public var height_max:Int = 2147483647;


        public function _Str_24281():Bool
        {
            return hasRectLimits && ((((this.width_min > ASCompat.MIN_INT) || (this.height_min > ASCompat.MIN_INT)) || (this.width_max < ASCompat.MAX_INT)) || (this.height_max < ASCompat.MAX_INT));
        }
public function new(){}
    }

