package com.sulake.core.window.dynamicstyle
;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.WindowController;
    import flash.geom.ColorTransform;

     class DynamicStyle 
    {
        public static inline final STYLE_LIFTED_HOVER= "lifted_hover";
        public static inline final BUTTON= "button";
        public static inline final BRIGHTNESS_AND_SHADOW_UNDER= "brightness_and_shadow_under";
        public static inline final BRIGHTNESS_AND_SHADOW_UNDER_GENTLE= "brightness_and_shadow_under_gentle";
        public static inline final REWARD_TRACK_ITEM= "reward_track_item";

        public var name:String;
        public var hoverStyles:ASObject;
        public var defaultStyles:ASObject;
        public var pressedSyles:ASObject;
        public var disabledStyles:ASObject;
        public var childDynamicStyles:ASDictionary<ASAny,ASAny>;

        public function new(name:String="")
        {
            this.hoverStyles = {};
            this.defaultStyles = {};
            this.pressedSyles = {};
            this.disabledStyles = {"colorTransform":([1, 1, 1, 0.4, 0, 0, 0, 0] : Array<Dynamic>)};
            this.childDynamicStyles = new ASDictionary<ASAny,ASAny>();
            this.name = name;
        }

        public function getStyleByWindowState(state:UInt):ASObject
        {
            switch (state)
            {
                case WindowState.PRESSED:
                    return this.pressedSyles;
                case WindowState.HOVERING:
                    return this.hoverStyles;
                case WindowState.DEFAULT:
                    return this.defaultStyles;
                case WindowState.DISABLED:
                    return this.disabledStyles;
            }
            return {};
        }

        function getChildDynamicStyleByKey(key:String):DynamicStyle
        {
            if (this.childDynamicStyles[key])
            {
                return this.childDynamicStyles[key];
            }
            return new DynamicStyle();
        }

        public function getChildStyle(childController:WindowController):DynamicStyle
        {
var tag:String  = null;            final _iter_ = childController.tags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tag = _tmp_;
                if (tag.charAt(0) == "#")
                {
                    return this.getChildDynamicStyleByKey(tag);
                }
            }
            return null;
        }

        public function getColorValue(value:UInt):UInt
        {
var transform:Array<ASAny>  = null, colorString:String  = null, index = 0, channel = 0;            if (this.getStyleByWindowState(value).colorTransform)
            {
transform= this.getStyleByWindowState(value).colorTransform;
colorString= "";
                for (_tmp_ in 0...3)
                {
index= _tmp_;
channel= ASCompat.toInt((ASCompat.toNumber(transform[index]) * 0xFF) + transform[(index + 4)]);
                    colorString = (colorString + ASCompat.toRadix(Math.min(0xFF, channel), 16));
                }
                return ASCompat.parseInt(colorString, 16);
            }
            return ASCompat.toUInt(null);
        }

        public function getColorTransform(state:UInt):ColorTransform
        {
var transform:Array<ASAny>  = null, tint:Array<ASAny>  = null;            if (this.getStyleByWindowState(state).colorTransform)
            {
transform= this.getStyleByWindowState(state).colorTransform;
tint= this.getStyleByWindowState(state).tint;
                if (tint == null)
                {
                    tint = [0xFF, 0xFF, 0xFF];
                }
                return new ColorTransform((ASCompat.toNumber(ASCompat.toNumber(transform[0]) * ASCompat.toNumber(tint[0])) / 0xFF), (ASCompat.toNumber(ASCompat.toNumber(transform[1]) * ASCompat.toNumber(tint[1])) / 0xFF), (ASCompat.toNumber(ASCompat.toNumber(transform[2]) * ASCompat.toNumber(tint[2])) / 0xFF), ASCompat.toNumber(transform[3]), ASCompat.toNumber(transform[4]), ASCompat.toNumber(transform[5]), ASCompat.toNumber(transform[6]), ASCompat.toNumber(transform[7]));
            }
            return new ColorTransform();
        }
    }

