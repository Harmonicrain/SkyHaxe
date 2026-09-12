package com.sulake.habbo.android
;
    import com.sulake.habbo.utils.HabboWebTools;

    import flash.geom.Rectangle;

    /**
     * Mobile viewport policy.
     *
     * The stage now runs at the device's native resolution, so a fixed magnification is wrong: on a
     * 2000px-wide phone 1.25 left the UI unreadably small, and on a small tablet it would be huge.
     * Instead the scale is derived from the stage so the logical viewport is never smaller than
     * MIN_LOGICAL_WIDTH x MIN_LOGICAL_HEIGHT -- the height floor is what keeps the 607px BattleBall
     * arena frame on screen, which the old fixed 1.25 (576 logical tall) could not.
     *
     * A safe inset is also reserved on the left and right. Rounded display corners and the camera
     * cutout sit on top of a fullscreen surface, so anything anchored hard to an edge -- the toolbar,
     * the purse -- was drawn under them and could not be tapped.
     */
     final class AndroidUiPolicy
    {
        /** Smallest logical viewport we are willing to lay the UI out in. */
        public static inline final MIN_LOGICAL_WIDTH:Float = 1024;
        /** BattleBall's frame is 607 tall; this floor guarantees it fits whole. */
        public static inline final MIN_LOGICAL_HEIGHT:Float = 640;

        public static inline final MIN_SCALE:Float = 1;
        public static inline final MAX_SCALE:Float = 3;

        /**
         * Edge margin kept clear of rounded corners and the camera cutout, as a fraction of the short
         * edge. Horizontal only: in landscape the cutout sits on a short edge, and a horizontal inset
         * wider than the corner radius already pulls corner UI clear of the arc. A vertical inset just
         * left a black band under the toolbar.
         */
        public static inline final SAFE_INSET_RATIO_X= 0.04;
        public static inline final SAFE_INSET_RATIO_Y:Float = 0;

        static var _scale:Float = 1;
        static var _insetX:Int = 0;
        static var _insetY:Int = 0;
        static var _stageWidth:Int = 0;
        static var _stageHeight:Int = 0;

        /**
         * Recompute from the real stage. Cheap and idempotent, so both the window manager and the
         * Android controller call it -- whichever initialises first wins and the other agrees.
         */
        public static function configure(stageWidth:Int, stageHeight:Int)
        {
            if (!HabboWebTools.isAirMobile || stageWidth < 10 || stageHeight < 10)
            {
                return;
            }
            _stageWidth = stageWidth;
            _stageHeight = stageHeight;
            var shortEdge= Math.min(stageWidth, stageHeight);
            _insetX = Std.int(Math.fround(shortEdge * SAFE_INSET_RATIO_X));
            _insetY = Std.int(Math.fround(shortEdge * SAFE_INSET_RATIO_Y));
            var usableWidth:Float = stageWidth - (_insetX * 2);
            var usableHeight:Float = stageHeight - (_insetY * 2);
            var fit= Math.min(usableWidth / MIN_LOGICAL_WIDTH, usableHeight / MIN_LOGICAL_HEIGHT);
            _scale = Math.max(MIN_SCALE, Math.min(MAX_SCALE, fit));
        }

        public static var uiScale(get,never):Float;
public static function  get_uiScale():Float
        {
            return (HabboWebTools.isAirMobile ? _scale : 1);
        }

        public static var safeInsetX(get,never):Int;
public static function  get_safeInsetX():Int
        {
            return (HabboWebTools.isAirMobile ? _insetX : 0);
        }

        public static var safeInsetY(get,never):Int;
public static function  get_safeInsetY():Int
        {
            return (HabboWebTools.isAirMobile ? _insetY : 0);
        }

        /**
         * Every layer gets the same scale. The room canvas is built by buildFromXML into the default
         * context, so room and UI already share a layer -- scaling them apart only desynchronises
         * anything sized from room geometry.
         */
        public static function getWindowLayerScale(layerIndex:UInt):Float
        {
            return (HabboWebTools.isAirMobile ? _scale : 1);
        }

        /** Logical size of a window layer: the safe area, divided by the scale. */
        public static function getWindowLayerRect(stageWidth:Int, stageHeight:Int):Rectangle
        {
            if (!HabboWebTools.isAirMobile)
            {
                return new Rectangle(0, 0, stageWidth, stageHeight);
            }
            configure(stageWidth, stageHeight);
            return new Rectangle(0, 0,
                Math.fround((stageWidth - (_insetX * 2)) / _scale),
                Math.fround((stageHeight - (_insetY * 2)) / _scale));
        }

	public function new() {}
    }

