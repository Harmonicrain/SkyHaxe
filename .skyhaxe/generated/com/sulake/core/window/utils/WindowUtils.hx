package com.sulake.core.window.utils
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBackgroundWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window._enum.WindowParam;

     class WindowUtils
    {
        public static function disableButton(window:IWindow, disabled:Bool)
        {
            if (disabled)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }

        static function getBlend(window:IWindow):Float
        {
            if (Std.is(window , IBackgroundWindow))
            {
                return (((ASCompat.toInt(window.color )>>> 24) & 0xFF) / 0xFF);
            }
            return window.blend;
        }

        static function setBlend(window:IWindow, value:Float)
        {
            var alpha = 0;
            if (Std.is(window , IBackgroundWindow))
            {
                alpha = Std.int(Math.max(0, Math.min(0xFF, Std.int(value * 0xFF))));
                window.color = ((ASCompat.toInt(window.color )& 0xFFFFFF) | (alpha << 24));
            }
            else
            {
                window.blend = value;
            }
        }

        public static function disableSection(window:IWindow, disabled:Bool=true, factor:Float=0.5)
        {
            var tag:String = null;
            var targetBlend = Math.NaN;
            var container:IWindowContainer = null;
            var i = 0;
            if (window.tags.indexOf("DO_NOT_DISABLE") != -1)
            {
                return;
            }
            var originalBlend:Float = -1;
            final _iter_ = window.tags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tag  = _tmp_;
                if (tag.indexOf("BLEND=") == 0)
                {
                    originalBlend = ASCompat.toNumber(tag.substring(6, tag.length));
                }
            }
            if (originalBlend == -1)
            {
                originalBlend = getBlend(window);
                tag = ("BLEND=" + Std.string(originalBlend));
                if (window.tags.indexOf(tag) == -1)
                {
                    window.tags.push(tag);
                }
            }
            if ((disabled && (window.tags.indexOf("INVIS_ON_DISABLE") != -1)))
            {
                targetBlend = 0;
            }
            else
            {
                targetBlend = (disabled ? (originalBlend * factor) : originalBlend);
            }
            var isIcon= (window.tags.indexOf("#icon") != -1);
            var hasOwnGraphics= (!window.getParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT));
            if (!Std.is(window , IButtonWindow))
            {
                if ((Std.is(window , IWindowContainer) || Std.is(window , IItemListWindow) || Std.is(window , ISelectorWindow)))
                {
                    container = Std.downcast(window , IWindowContainer);
                    if (container != null)
                    {
                        i = 0;
                        while (i < container.numChildren)
                        {
                            disableSection(container.getChildAt(i), disabled, (hasOwnGraphics ? 1 : factor));
                            i++;
                        }
                    }
                    if ((Std.is(window , IBorderWindow) || Std.is(window , IBackgroundWindow) || hasOwnGraphics))
                    {
                        setBlend(window, targetBlend);
                    }
                }
                else
                {
                    if (!isIcon)
                    {
                        setBlend(window, targetBlend);
                    }
                }
            }
            if (disabled)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }

	public function new() {}
    }

