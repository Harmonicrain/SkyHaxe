package com.sulake.core.window.dynamicstyle
;

     class DynamicStyleManager 
    {
        static var _styles:ASDictionary<ASAny,ASAny>;

        public static function getStyle(style:String):DynamicStyle
        {
            if (_styles == null)
            {
                fillStyleTable();
            }
            if (_styles.exists(style ))
            {
                return _styles[style];
            }
            return new DynamicStyle();
        }

        static function fillStyleTable()
        {
            _styles = new ASDictionary<ASAny,ASAny>();
            var dynamicStyle= new DynamicStyle(DynamicStyle.STYLE_LIFTED_HOVER);
            dynamicStyle.defaultStyles = {};
            dynamicStyle.pressedSyles = {
                "offsetX":1,
                "colorTransform":([1, 0.7, 0.7, 0.7, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            dynamicStyle.hoverStyles = {
                "offsetY":-1,
                "offsetX":-1
            }
;            var _local_2= new DynamicStyle();
            _local_2.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([1, 1] : Array<Dynamic>)
            }
;            _local_2.hoverStyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([2, 2] : Array<Dynamic>)
            }
;            _local_2.pressedSyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([-1, -1] : Array<Dynamic>)
            }
;            dynamicStyle.childDynamicStyles["#icon"] = _local_2;
            var shadowUnderStyle= new DynamicStyle(DynamicStyle.BRIGHTNESS_AND_SHADOW_UNDER);
            shadowUnderStyle.defaultStyles = {};
            var _local_4= new DynamicStyle();
            _local_4.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>)
            }
;            _local_4.pressedSyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([0, -1] : Array<Dynamic>),
                "offsetY":-1,
                "colorTransform":([0.7, 0.7, 0.7, 1, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            _local_4.hoverStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>),
                "colorTransform":([1, 1, 1, 1, 77, 77, 77, 0] : Array<Dynamic>)
            }
;            shadowUnderStyle.childDynamicStyles["#icon"] = _local_4;
            var _local_5= new DynamicStyle();
            _local_5.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>)
            }
;            _local_5.pressedSyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([0, 0] : Array<Dynamic>),
                "colorTransform":([0.9, 0.9, 0.9, 1, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            _local_5.hoverStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>),
                "colorTransform":([1, 1, 1, 1, 77, 77, 77, 0] : Array<Dynamic>)
            }
;            _local_5.disabledStyles = {"colorTransform":([0.5, 0.5, 0.5, 0.7, 0, 0, 0, 0] : Array<Dynamic>)};
            shadowUnderStyle.childDynamicStyles["#bg"] = _local_5;
            var gentleStyle= new DynamicStyle(DynamicStyle.BRIGHTNESS_AND_SHADOW_UNDER_GENTLE);
            gentleStyle.defaultStyles = {};
            var gentleIconStyle= new DynamicStyle();
            gentleIconStyle.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>)
            }
;            gentleIconStyle.pressedSyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([0, -1] : Array<Dynamic>),
                "offsetY":1,
                "colorTransform":([0.8, 0.8, 0.8, 1, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            gentleIconStyle.hoverStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>),
                "colorTransform":([1.1, 1.1, 1.1, 1, 30, 30, 30, 0] : Array<Dynamic>)
            }
;            gentleStyle.childDynamicStyles["#icon"] = gentleIconStyle;
            var rewardTrackItemStyle= new DynamicStyle(DynamicStyle.REWARD_TRACK_ITEM);
            rewardTrackItemStyle.defaultStyles = {};
            var rewardTrackIconStyle= new DynamicStyle();
            rewardTrackIconStyle.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>)
            }
;            rewardTrackIconStyle.pressedSyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([0, -1] : Array<Dynamic>),
                "offsetY":1,
                "colorTransform":([0.8, 0.8, 0.8, 1, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            rewardTrackIconStyle.hoverStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 1] : Array<Dynamic>),
                "colorTransform":([1.1, 1.1, 1.1, 1, 15, 15, 15, 0] : Array<Dynamic>)
            }
;            rewardTrackIconStyle.disabledStyles = {"colorTransform":([0.75, 0.75, 0.75, 0.8, 0, 0, 0, 0] : Array<Dynamic>)};
            rewardTrackItemStyle.childDynamicStyles["#icon"] = rewardTrackIconStyle;
            var buttonStyle= new DynamicStyle(DynamicStyle.BUTTON);
            buttonStyle.defaultStyles = {};
            var buttonIconStyle= new DynamicStyle();
            buttonIconStyle.defaultStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 0] : Array<Dynamic>)
            }
;            buttonIconStyle.pressedSyles = {
                "etchingColor":0x80000000,
                "etchingPoint":([0, 0] : Array<Dynamic>),
                "offsetY":1,
                "colorTransform":([0.8, 0.8, 0.8, 1, 0, 0, 0, 0] : Array<Dynamic>)
            }
;            buttonIconStyle.hoverStyles = {
                "etchingColor":0x48000000,
                "etchingPoint":([0, 0] : Array<Dynamic>),
                "colorTransform":([1.1, 1.1, 1.1, 1, 15, 15, 15, 0] : Array<Dynamic>)
            }
;            buttonStyle.childDynamicStyles["#icon"] = buttonIconStyle;
            _styles[DynamicStyle.STYLE_LIFTED_HOVER] = dynamicStyle;
            _styles[DynamicStyle.BRIGHTNESS_AND_SHADOW_UNDER] = shadowUnderStyle;
            _styles[DynamicStyle.BRIGHTNESS_AND_SHADOW_UNDER_GENTLE] = gentleStyle;
            _styles[DynamicStyle.REWARD_TRACK_ITEM] = rewardTrackItemStyle;
            _styles[DynamicStyle.BUTTON] = buttonStyle;
        }

	public function new() {}
    }

