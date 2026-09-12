package com.sulake.habbo.roomevents
;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBackgroundWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.utils.IChildWindowHost;

     class Util 
    {
        /**
         * Wired 2.0 represents a signed 32-bit value as the high/low pair used
         * by the AIR variable action definitions.  The high word is only a sign
         * marker here; the low word retains the exact ActionScript int value.
         */
        public static function pushIntAsLong(target:Array<ASAny>, value:Int)
        {
            target.push(value < 0 ? -1 : 0);
            target.push(value);
        }

        public static function splitVariableName(variable:ASObject):Array<ASAny>
        {
            return variable == null || variable.variableName == null
                ? [] : (cast ASCompat.toString(variable.variableName).split("."));
        }

        public static function _Str_6937(k:IWindow, _arg_2:ASFunction)
        {
            k.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
            k.procedure = _arg_2;
        }

        public static function getLowestPoint(k:IWindowContainer):Int
        {
            var _local_4:IWindow = null;
            var _local_2 = 0;
            var _local_3 = 0;
            while (_local_3 < k.numChildren)
            {
                _local_4 = k.getChildAt(_local_3);
                if (_local_4.visible)
                {
                    _local_2 = Std.int(Math.max(_local_2, (_local_4.y + _local_4.height)));
                }
                _local_3++;
            }
            return _local_2;
        }

        public static function hideChildren(k:IWindowContainer)
        {
            var _local_2 = 0;
            while (_local_2 < k.numChildren)
            {
                k.getChildAt(_local_2).visible = false;
                _local_2++;
            }
        }

        public static function _Str_21358(k:IWindowContainer)
        {
            var _local_2 = 0;
            while (_local_2 < k.numChildren)
            {
                k.getChildAt(_local_2).visible = true;
                _local_2++;
            }
        }

        public static function moveChildrenToColumn(k:IWindowContainer, _arg_2:Array<ASAny>, _arg_3:Int, _arg_4:Int)
        {
            var _local_5:String = null;
            var _local_6:IWindow = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_5  = _tmp_;
                _local_6 = k.getChildByName(_local_5);
                if ((((!(_local_6 == null)) && _local_6.visible) && (_local_6.height > 0)))
                {
                    _local_6.y = _arg_3;
                    _arg_3 = (_arg_3 + (_local_6.height + _arg_4));
                }
            }
        }

        public static function _Str_14509(k:IWindowContainer, _arg_2:Int, _arg_3:Int)
        {
            var _local_4 = 0;
            var _local_5:IWindow = null;
            while (_local_4 < k.numChildren)
            {
                _local_5 = k.getChildAt(_local_4);
                if ((((!(_local_5 == null)) && _local_5.visible) && (_local_5.height > 0)))
                {
                    _local_5.y = _arg_2;
                    _arg_2 = (_arg_2 + (_local_5.height + _arg_3));
                }
                _local_4++;
            }
        }

        public static function getLowestPointList(k:IItemListWindow):Int
        {
            var _local_2 = 0;
            var _local_4:IWindow = null;
            var _local_3 = 0;
            while (_local_2 < k.numListItems)
            {
                _local_4 = k.getListItemAt(_local_2);
                if (_local_4.visible && (_local_4.height > 0))
                {
                    _local_3 = Std.int(Math.max(_local_3, (_local_4.y + _local_4.height)));
                }
                _local_2++;
            }
            return _local_3;
        }

        public static function select(k:ISelectableWindow, _arg_2:Bool)
        {
            if (_arg_2)
            {
                k.select();
            }
            else
            {
                k.unselect();
            }
        }

        static function getBlend(k:IWindow):Float
        {
            if (Std.is(k , IBackgroundWindow))
            {
                return ((ASCompat.toInt(k.color )>>> 24) & 0xFF) / 255;
            }
            return k.blend;
        }

        static function setBlend(k:IWindow, _arg_2:Float)
        {
            var _local_3 = 0;
            if (Std.is(k , IBackgroundWindow))
            {
                _local_3 = Std.int(Math.max(0, Math.min(255, Std.int(_arg_2 * 255))));
                k.color = ((ASCompat.toInt(k.color )& 0xFFFFFF) | (_local_3 << 24));
            }
            else
            {
                k.blend = _arg_2;
            }
        }

        public static function disableSection(k:IWindow, _arg_2:Bool = true)
        {
            var _local_7:String = null;
            var _local_8 = Math.NaN;
            var _local_4:IWindowContainer = null;
            var _local_6 = 0;
            var _local_9:IWindow = null;
            if (k.tags.indexOf("DO_NOT_DISABLE") != -1)
            {
                return;
            }
            var _local_3:Float = -1;
            if (k.isEnabled() && _arg_2)
            {
                _local_3 = getBlend(k);
                _local_7 = ("BLEND=" + Std.string(_local_3));
                if (k.tags.indexOf(_local_7) == -1)
                {
                    k.tags.push(_local_7);
                }
            }
            else if ((!k.isEnabled()) && (!_arg_2))
            {
                final _iter_ = k.tags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_7  = _tmp_;
                    if (_local_7.indexOf("BLEND=") == 0)
                    {
                        _local_3 = ASCompat.toNumber(_local_7.substring(6, _local_7.length));
                    }
                }
            }
            if (_local_3 == -1)
            {
                _local_8 = getBlend(k);
            }
            else
            {
                _local_8 = _arg_2 ? (_local_3 / 2) : _local_3;
            }
            var _local_5= (k.tags.indexOf("#icon") != -1);
            if (!Std.is(k , IButtonWindow))
            {
                if ((Std.is(k , IWindowContainer) || Std.is(k , IItemListWindow)) || Std.is(k , ISelectorWindow))
                {
                    if (Std.is(k , IChildWindowHost))
                    {
                        final _iter_ = ASCompat.reinterpretAs(k , IChildWindowHost).children; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                        {
_local_9  = _tmp_;
                            disableSection(_local_9, _arg_2);
                        }
                    }
                    else if (Std.is(k , IWindowContainer))
                    {
                        _local_4 = Std.downcast(k , IWindowContainer);
                        _local_6 = 0;
                        while (_local_6 < _local_4.numChildren)
                        {
                            disableSection(_local_4.getChildAt(_local_6), _arg_2);
                            _local_6++;
                        }
                    }
                    if (Std.is(k , IBorderWindow) || Std.is(k , IBackgroundWindow))
                    {
                        setBlend(k, _local_8);
                    }
                }
                else if (!_local_5)
                {
                    setBlend(k, _local_8);
                }
            }
            if (_arg_2)
            {
                k.disable();
            }
            else
            {
                k.enable();
            }
        }

	public function new() {}
    }

