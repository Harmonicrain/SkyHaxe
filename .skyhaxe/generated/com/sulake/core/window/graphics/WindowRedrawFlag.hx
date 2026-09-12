package com.sulake.core.window.graphics
;
     class WindowRedrawFlag 
    {
        public static inline final UNKNOWN:UInt = 0;
        public static final REDRAW:UInt = (1 << 0);
        public static final RESIZE:UInt = (1 << 1);
        public static final RELOCATE:UInt = (1 << 2);
        public static final STATE:UInt = (1 << 3);
        public static final BLEND:UInt = (1 << 4);
        public static final CASCADE:UInt = (1 << 5);

	public function new() {}
    }

