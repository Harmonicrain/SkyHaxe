package com.sulake.core.window._enum
;
     class PivotPoint 
    {
        public static inline final TOP_LEFT:UInt = 0;
        public static inline final TOP_CENTER:UInt = 1;
        public static inline final TOP_RIGHT:UInt = 2;
        public static inline final CENTER_LEFT:UInt = 3;
        public static inline final CENTER:UInt = 4;
        public static inline final CENTER_RIGHT:UInt = 5;
        public static inline final BOTTOM_LEFT:UInt = 6;
        public static inline final BOTTOM_CENTER:UInt = 7;
        public static inline final BOTTOM_RIGHT:UInt = 8;
        public static final PIVOT_NAMES:Array<ASAny> = ["top left", "top center", "top right", "center left", "center", "center right", "bottom left", "bottom center", "bottom right"];

        public static function pivotFromName(name:String):UInt
        {
            return PIVOT_NAMES.indexOf(name);
        }

	public function new() {}
    }

