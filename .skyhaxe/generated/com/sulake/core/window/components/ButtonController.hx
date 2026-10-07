package com.sulake.core.window.components
;
    import com.sulake.core.window.utils.tablet.ITouchAwareWindow;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowTouchEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.TextStyleManager;

     class ButtonController extends InteractiveController implements IButtonWindow implements  ITouchAwareWindow 
    {
        static inline final _BTN_TEXT= "_BTN_TEXT";
        static inline final _Str_5734= 0.5;
        var _buttonTextStyleName:String;
        var _buttonTextColor:ASObject = null;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        override public function addChild(k:IWindow):IWindow
        {
            var child= super.addChild(k);
            if (child != null && child.name == _BTN_TEXT)
            {
                this.applyButtonTextProperties();
            }
            return child;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var property:PropertyStruct = null;
            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
property  = _tmp_;
                    switch (property.key)
                    {
                        case PropertyKeys.TEXT_STYLE:
                            this._buttonTextStyleName = ASCompat.asString(property.value );
                            
                        case PropertyKeys.TEXT_COLOR:
                            this._buttonTextColor = property.value;
                            
                    }
                }
            }
            super.properties = k;
            this.applyButtonTextProperties();
return k;
        }

        override public function  set_caption(k:String):String        {
            super.caption = k;
            var _local_2= getChildByName(_BTN_TEXT);
            if (_local_2 != null)
            {
                _local_2.caption = caption;
            }
return k;
        }

        override public function  set_blend(k:Float):Float        {
            super.blend = k;
            var _local_2= getChildByName(_BTN_TEXT);
            var _local_3= getStateFlag(WindowState.DISABLED);
            if (_local_2 != null)
            {
                _local_2.blend = (_local_3 ? (k / 2) : k);
            }
return k;
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3:String = null;
            var _local_4:WindowEvent = null;
            var _local_5 = false;
            if (Std.is(_arg_2 , WindowEvent))
            {
                switch (_arg_2.type)
                {
                    case WindowEvent.WINDOW_EVENT_CHILD_RESIZED:
                        width = 0;
                        
                    case WindowEvent.WINDOW_EVENT_ENABLED:
                        try
                        {
                            getChildByName(_BTN_TEXT).blend = (getChildByName(_BTN_TEXT).blend + _Str_5734);
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                        }
                        
 }                    case WindowEvent.WINDOW_EVENT_DISABLED:
                        try
                        {
                            getChildByName(_BTN_TEXT).blend = (getChildByName(_BTN_TEXT).blend - _Str_5734);
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                        }
                        
 }                }
            }
            else
            {
                if (Std.is(_arg_2 , WindowTouchEvent))
                {
                    _local_3 = WindowEvent.UNKNOWN;
                    switch (_arg_2.type)
                    {
                        case WindowTouchEvent.WTE_BEGIN:
                            _local_3 = WindowMouseEvent.DOWN;
                            
                        case WindowTouchEvent.WTE_END:
                            _local_3 = WindowMouseEvent.UP;
                            
                        case WindowTouchEvent.WTE_TAP:
                            _local_3 = WindowMouseEvent.CLICK;
                            
                    }
                    _local_4 = WindowMouseEvent.allocate(_local_3, cast(_arg_2, WindowTouchEvent).window, cast(_arg_2, WindowTouchEvent).related, cast(_arg_2, WindowTouchEvent).localX, cast(_arg_2, WindowTouchEvent).localY, cast(_arg_2, WindowTouchEvent).stageX, cast(_arg_2, WindowTouchEvent).stageY, cast(_arg_2, WindowTouchEvent).altKey, cast(_arg_2, WindowTouchEvent).ctrlKey, cast(_arg_2, WindowTouchEvent).shiftKey, true, 0);
                    _local_5 = super.update(k, _local_4);
                    _local_4.recycle();
                    return _local_5;
                }
            }
            return super.update(k, _arg_2);
        }

        function applyButtonTextProperties()
        {
            var label= Std.downcast(getChildByName(_BTN_TEXT) , ILabelWindow);
            if (label == null)
            {
                return;
            }
            if (this._buttonTextStyleName != null && this._buttonTextStyleName != "")
            {
                label.textStyle = TextStyleManager.getStyle(this._buttonTextStyleName);
            }
            if (this._buttonTextColor != null)
            {
                label.textColor = ASCompat.toUInt(this._buttonTextColor);
            }
        }
    }

