package org.openvideoads.vast.overlay.button.skip
;
    import org.openvideoads.regions.config.RegionViewConfig;

     class SkipAdRegionViewConfig extends RegionViewConfig 
    {
        public function new(k:ASObject, _arg_2:ASObject)
        {
            var _local_3:ASObject = {};
            if (k == null)
            {
                _local_3 = _arg_2;
            }
            else
            {
                _local_3 = {
                    "id":((k.id != /*undefined*/null) ? k.id : _arg_2.id),
                    "verticalAlign":((k.verticalAlign != /*undefined*/null) ? k.verticalAlign : _arg_2.verticalAlign),
                    "horizontalAlign":((k.horizontalAlign != /*undefined*/null) ? k.horizontalAlign : _arg_2.horizontalAlign),
                    "width":((k.width != /*undefined*/null) ? k.width : _arg_2.width),
                    "height":((k.height != /*undefined*/null) ? k.height : _arg_2.height),
                    "backgroundColor":((k.backgroundColor != /*undefined*/null) ? k.backgroundColor : _arg_2.backgroundColor),
                    "clickable":((k.clickable != /*undefined*/null) ? k.clickable : _arg_2.clickable),
                    "closeButton":((k.closeButton != /*undefined*/null) ? k.closeButton : _arg_2.closeButton),
                    "keepAfterClick":((k.keepAfterClick != /*undefined*/null) ? k.keepAfterClick : _arg_2.keepAfterClick),
                    "image":((k.image != /*undefined*/null) ? k.image : _arg_2.image),
                    "swf":((k.swf != /*undefined*/null) ? k.swf : _arg_2.swf),
                    "html":((k.html != /*undefined*/null) ? k.html : _arg_2.html),
                    "autoHide":false
                }
;                if (k.styleSheetAddress != /*undefined*/null)
                {
                    _local_3.styleSheetAddress = k.styleSheetAddress;
                }
                if (k.style != /*undefined*/null)
                {
                    _local_3.style = k.style;
                }
                if (k.border != /*undefined*/null)
                {
                    _local_3.border = k.border;
                }
                if (k.borderRadius != /*undefined*/null)
                {
                    _local_3.borderRadius = k.borderRadius;
                }
                if (k.borderWidth != /*undefined*/null)
                {
                    _local_3.borderWidth = k.borderWidth;
                }
                if (k.borderColor != /*undefined*/null)
                {
                    _local_3.borderColor = k.borderColor;
                }
                if (k.background != /*undefined*/null)
                {
                    _local_3.background = k.background;
                }
                if (k.backgroundGradient != /*undefined*/null)
                {
                    _local_3.backgroundGradient = k.backgroundGradient;
                }
                if (k.backgroundImage != /*undefined*/null)
                {
                    _local_3.backgroundImage = k.backgroundImage;
                }
                if (k.backgroundRepeat != /*undefined*/null)
                {
                    _local_3.backgroundRepeat = k.backgroundRepeat;
                }
                if (k.backgroundColor != /*undefined*/null)
                {
                    _local_3.backgroundColor = k.backgroundColor;
                }
                if (k.opacity != /*undefined*/null)
                {
                    _local_3.opacity = k.opacity;
                }
                if (k.padding != /*undefined*/null)
                {
                    _local_3.padding = k.padding;
                }
                if (k.canScale != /*undefined*/null)
                {
                    _local_3.canScale = k.canScale;
                }
                if (k.scaleRate != /*undefined*/null)
                {
                    _local_3.scaleRate = k.scaleRate;
                }
                if (k.autoHide != /*undefined*/null)
                {
                    _local_3.autoHide = k.autoHide;
                }
            }
            super(_local_3);
        }
    }

