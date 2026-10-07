package com.sulake.core.window._enum
;
     class WindowState 
    {
        public static final DEFAULT:UInt = (0 << 0);
        public static final ACTIVE:UInt = (1 << 0);
        public static final FOCUSED:UInt = (1 << 1);
        public static final HOVERING:UInt = (1 << 2);
        public static final SELECTED:UInt = (1 << 3);
        public static final PRESSED:UInt = (1 << 4);
        public static final DISABLED:UInt = (1 << 5);
        public static final LOCKED:UInt = (1 << 6);
        public static final DISPOSED:UInt = (1 << 30);

	public function new() {}
    }

