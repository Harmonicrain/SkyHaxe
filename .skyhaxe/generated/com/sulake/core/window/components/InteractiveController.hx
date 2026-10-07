package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window._enum.MouseCursorType;

     class InteractiveController extends WindowController implements IInteractiveWindow 
    {
        var _Str_3681:UInt = 0;
        var _Str_3422:String;
        var _Str_4476:Bool = false;
        var _Str_3280:Map;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            var _local_12= _arg_5.getWindowFactory().getThemeManager();
            this._Str_3681 = ASCompat.toInt(_local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.TOOL_TIP_DELAY).value);
            this._Str_3422 = ASCompat.toString(_local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.TOOL_TIP_CAPTION).value);
            this._Str_4476 = _local_12.getPropertyDefaults(_arg_3).get(PropertyKeys.TOOL_TIP_IS_DYNAMIC).value;
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public static function _Str_10773(k:IInteractiveWindow, _arg_2:WindowEvent)
        {
            if (k._Str_4074)
            {
                if (_arg_2.type == WindowMouseEvent.OVER)
                {
                    k.context.getWindowServices().getToolTipAgentService().begin(k);
                }
                else
                {
                    if (_arg_2.type == WindowMouseEvent.MOVE)
                    {
                        k.context.getWindowServices().getToolTipAgentService().updateCaption(k);
                    }
                    else
                    {
                        if (_arg_2.type == WindowMouseEvent.OUT)
                        {
                            k.context.getWindowServices().getToolTipAgentService().end(k);
                        }
                    }
                }
            }
            else
            {
                if (((!(k.toolTipCaption == null)) && (k.toolTipCaption.length > 0)))
                {
                    if (_arg_2.type == WindowMouseEvent.OVER)
                    {
                        k.context.getWindowServices().getToolTipAgentService().begin(k);
                    }
                    else
                    {
                        if (_arg_2.type == WindowMouseEvent.OUT)
                        {
                            k.context.getWindowServices().getToolTipAgentService().end(k);
                        }
                    }
                }
            }
        }

        public static function _Str_11019(k:IInteractiveWindow, _arg_2:Array<ASAny>)
        {
            var _local_3:PropertyStruct = null;
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_3  = _tmp_;
                switch (_local_3.key)
                {
                    case PropertyKeys.TOOL_TIP_CAPTION:
                        if (_local_3.value != k.toolTipCaption)
                        {
                            k.toolTipCaption = ASCompat.asString(_local_3.value );
                        }
                        
                    case PropertyKeys.TOOL_TIP_DELAY:
                        if (_local_3.value != k.toolTipDelay)
                        {
                            k.toolTipDelay = ASCompat.asUint(_local_3.value );
                        }
                        
                    case PropertyKeys.TOOL_TIP_IS_DYNAMIC:
                        if (_local_3.value != k._Str_4074)
                        {
                            k._Str_4074 = ASCompat.asBoolean(_local_3.value );
                        }
                        
                }
            }
        }

        public static function _Str_8987(k:IInteractiveWindow, _arg_2:Array<ASAny>):Array<ASAny>
        {
            _arg_2.push(k.createProperty(PropertyKeys.TOOL_TIP_CAPTION, k.toolTipCaption));
            _arg_2.push(k.createProperty(PropertyKeys.TOOL_TIP_DELAY, k.toolTipDelay));
            _arg_2.push(k.createProperty(PropertyKeys.TOOL_TIP_IS_DYNAMIC, k._Str_4074));
            return _arg_2;
        }


        
        public var toolTipCaption(get,set):String;
public function  set_toolTipCaption(k:String):String        {
            this._Str_3422 = ((k == null) ? ASCompat.toString(getDefaultProperty(PropertyKeys.TOOL_TIP_CAPTION).value) : k);
return k;
        }
public function  get_toolTipCaption():String
        {
            return this._Str_3422;
        }

        
        public var toolTipDelay(get,set):UInt;
public function  set_toolTipDelay(k:UInt):UInt        {
            return this._Str_3681 = k;
        }
public function  get_toolTipDelay():UInt
        {
            return this._Str_3681;
        }

        public function setMouseCursorForState(k:UInt, _arg_2:UInt):UInt
        {
            if (testStateFlag(WindowState.DISABLED))
            {
                return MouseCursorType.ARROW;
            }
            if (this._Str_3280 == null)
            {
                this._Str_3280 = new Map();
            }
            var _local_3:UInt = this._Str_3280.getValue(k);
            if (((_arg_2 == MouseCursorType.DEFAULT) || (_arg_2 == -1)))
            {
                this._Str_3280.remove(k);
            }
            else
            {
                this._Str_3280.setProperty(k, _arg_2);
            }
            return _local_3;
        }

        public function getMouseCursorByState(k:UInt):UInt
        {
            if (this._Str_3280 == null)
            {
                return MouseCursorType.DEFAULT;
            }
            return ASCompat.toUInt(this._Str_3280.getValue(k));
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if ((k : ASAny) == (this : ASAny))
            {
                _Str_10773(this, _arg_2);
            }
            return super.update(k, _arg_2);
        }

        public function showToolTip(k:IToolTipWindow)
        {
        }

        public function hideToolTip()
        {
        }

        override public function  get_properties():Array<ASAny>
        {
            return _Str_8987(this, super.properties);
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            _Str_11019(this, k);
            return super.properties = k;
        }

        
        public var _Str_4074(get,set):Bool;
public function  set__Str_4074(k:Bool):Bool        {
            return this._Str_4476 = k;
        }
public function  get__Str_4074():Bool
        {
            return this._Str_4476;
        }
    }

