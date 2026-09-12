package com.sulake.core.window.components
;
    import flash.filters.DropShadowFilter;
    import com.sulake.core.window._enum.WindowParam;
    import flash.text.TextField;
    import flash.events.TextEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.text.TextFieldType;
    import com.sulake.core.window.graphics.GraphicContext;
    import com.sulake.core.window.graphics.IGraphicContext;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.WindowController;
    import flash.geom.Point;
    import flash.text.TextFieldAutoSize;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.IInputEventTracker;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.PropertyStruct;

     class TextFieldController extends TextController implements ITextFieldWindow 
    {
        static final _Str_16549:compat.RegExp = new compat.RegExp("[~%&!\\\\;:\"',<>?#\\s\\.\\-()=\\[\\]\\{\\}\\^_]", "g");

        var _Str_14685:DropShadowFilter;
        var _Str_3681:UInt = 500;
        var _Str_3422:String = "";
        var _Str_4476:Bool = false;
        var _Str_9948:Bool = false;
        var _initialized:Bool = false;
        var _Str_6131:Array<ASAny>;
        var _Str_12892:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._Str_14685 = new DropShadowFilter(1, 90, 0xFFFFFF, 1, 0, 0);
            this._Str_6131 = [];
            _arg_4 = (ASCompat.toInt(_arg_4 )& (~ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            _x = Std.int(_arg_6.x);
            _y = Std.int(_arg_6.y);
            _w = Std.int(_arg_6.width);
            _h = Std.int(_arg_6.height);
            _field = cast(this.getGraphicContext(true).getDisplayObject(), TextField);
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _field.addEventListener(TextEvent.TEXT_INPUT, (this._Str_22281 : ASAny));
            _field.addEventListener(KeyboardEvent.KEY_DOWN, (this._Str_19964 : ASAny));
            _field.addEventListener(KeyboardEvent.KEY_UP, (this._Str_21573 : ASAny));
            _field.addEventListener(Event.CHANGE, (this._Str_16912 : ASAny));
            _field.addEventListener(FocusEvent.FOCUS_IN, (this._Str_4932 : ASAny));
            _field.addEventListener(FocusEvent.FOCUS_OUT, (this._Str_4932 : ASAny));
            _field.addEventListener(Event.REMOVED_FROM_STAGE, (this._Str_19111 : ASAny));
            _drawable = false;
            this._initialized = true;
        }

        public static function _Str_22243(k:String):Array<ASAny>
        {
            var _local_3:ASObject = null;
            var _local_2= new Array<ASAny>();
            _local_2.push(0);
            while ((_local_3 = _Str_16549.exec(k)) != null)
            {
                if (_local_3.index < k.length)
                {
                    _local_2.push((_local_3.index + 1));
                }
            }
            return _local_2;
        }


        public var focused(get,never):Bool;
public function  get_focused():Bool
        {
            if (_field != null)
            {
                if (_field.stage != null)
                {
                    return (_field.stage.focus : ASAny) == (_field : ASAny);
                }
            }
            return false;
        }

        override public function enable():Bool
        {
            if (super.enable())
            {
                _field.type = TextFieldType.INPUT;
                return true;
            }
            _field.type = TextFieldType.DYNAMIC;
            return false;
        }

        override public function disable():Bool
        {
            if (super.disable())
            {
                _field.type = TextFieldType.DYNAMIC;
                return true;
            }
            _field.type = TextFieldType.INPUT;
            return false;
        }

        
        public var editable(get,set):Bool;
public function  get_editable():Bool
        {
            return _field.type == TextFieldType.INPUT;
        }
public function  set_editable(k:Bool):Bool        {
            _field.type = (k ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
return k;
        }

        
        public var selectable(get,set):Bool;
public function  get_selectable():Bool
        {
            return _field.selectable;
        }
public function  set_selectable(k:Bool):Bool        {
            return _field.selectable = k;
        }

        
        public var displayAsPassword(get,set):Bool;
public function  set_displayAsPassword(k:Bool):Bool        {
            return _field.displayAsPassword = k;
        }
public function  get_displayAsPassword():Bool
        {
            return _field.displayAsPassword;
        }

        
        public var mouseCursorType(get,set):UInt;
public function  set_mouseCursorType(k:UInt):UInt        {
return k;
        }
public function  get_mouseCursorType():UInt
        {
            return 0;
        }

        
        public var toolTipCaption(get,set):String;
public function  set_toolTipCaption(k:String):String        {
            this._Str_3422 = ((k == null) ? "" : k);
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
            throw new ASError("Unimplemented method!");
        }

        public function getMouseCursorByState(k:UInt):UInt
        {
            throw new ASError("Unimplemented method!");
        }

        public function showToolTip(k:IToolTipWindow)
        {
            throw new ASError("Unimplemented method!");
        }

        public function hideToolTip()
        {
            throw new ASError("Unimplemented method!");
        }

        override public function  set_autoSize(k:String):String        {
            super.autoSize = k;
            this._Str_18556();
return k;
        }

        override public function  set_background(k:Bool):Bool        {
            _field.background = k;
            _background = k;
            _fillColor = (_background ? (ASCompat.toInt(_fillColor )| ASCompat.toInt(_alphaColor)) : (ASCompat.toInt(_fillColor )& 0xFFFFFF));
return k;
        }

        public function setSelection(k:Int, _arg_2:Int)
        {
            _field.setSelection(k, _arg_2);
        }

        public var selectionBeginIndex(get,never):Int;
public function  get_selectionBeginIndex():Int
        {
            return _field.selectionBeginIndex;
        }

        public var selectionEndIndex(get,never):Int;
public function  get_selectionEndIndex():Int
        {
            return _field.selectionEndIndex;
        }

        override public function getGraphicContext(k:Bool):IGraphicContext
        {
            if ((k && (!(_graphics != null))))
            {
                _graphics = new GraphicContext((("GC {" + _name) + "}"), GraphicContext.GC_TYPE_TEXTFIELD, rectangle);
            }
            return _graphics;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                _context.getWindowServices().getFocusManagerService().removeFocusWindow(this);
                this._Str_9948 = false;
                if (_field != null)
                {
                    if (this.focused)
                    {
                        this.unfocus();
                    }
                    _field.removeEventListener(KeyboardEvent.KEY_DOWN, (this._Str_19964 : ASAny));
                    _field.removeEventListener(KeyboardEvent.KEY_UP, (this._Str_21573 : ASAny));
                    _field.removeEventListener(Event.CHANGE, (this._Str_16912 : ASAny));
                    _field.removeEventListener(FocusEvent.FOCUS_IN, (this._Str_4932 : ASAny));
                    _field.removeEventListener(FocusEvent.FOCUS_OUT, (this._Str_4932 : ASAny));
                    _field.removeEventListener(Event.REMOVED_FROM_STAGE, (this._Str_19111 : ASAny));
                }
                super.dispose();
            }
        }

        override public function  set_text(k:String):String        {
            super.text = k;
            this._Str_18556();
return k;
        }

        override public function focus():Bool
        {
            var k= super.focus();
            if (k)
            {
                if (_field != null)
                {
                    if (_field.stage != null)
                    {
                        if ((_field.stage.focus : ASAny) != (_field : ASAny))
                        {
                            _field.stage.focus = _field;
                        }
                    }
                }
            }
            return k;
        }

        override public function unfocus():Bool
        {
            if (_field != null)
            {
                if (_field.stage != null)
                {
                    if ((_field.stage.focus : ASAny) == (_field : ASAny))
                    {
                        _field.stage.focus = null;
                    }
                }
            }
            return super.unfocus();
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            var _local_3= super.update(k, _arg_2);
            switch (_arg_2.type)
            {
                case WindowEvent.WINDOW_EVENT_ACTIVATED
                   | WindowMouseEvent.DOWN:
                    this.focus();
                    
                case WindowEvent.WINDOW_EVENT_RESIZED:
                    if ((k : ASAny) == (this : ASAny))
                    {
                        _field.width = this.width;
                        _field.height = this.height;
                    }
                    
            }
            if ((k : ASAny) == (this : ASAny))
            {
                InteractiveController._Str_10773(this, _arg_2);
            }
            return _local_3;
        }

        function _Str_18556()
        {
            var k:Point = null;
            var _local_2:Point = null;
            var _local_3:Point = null;
            if ((this._initialized && (!(autoSize == TextFieldAutoSize.NONE))))
            {
                if (((!(_w == _field.width)) || (!(_h == _field.height))))
                {
                    k = _field.localToGlobal(new Point(_field.x, _field.y));
                    _local_2 = new Point();
                    getGlobalPosition(_local_2);
                    _local_3 = new Point((k.x - _local_2.x), (k.y - _local_2.y));
                    setRectangle(Std.int(_x + _local_3.x), Std.int(_y + _local_3.y), Std.int(_field.width), Std.int(_field.height));
                }
            }
        }

        override public function  set_filters(k:Array<ASAny>):Array<ASAny>        {
            this._Str_12892 = true;
            this._Str_6131 = k;
            this._Str_20609();
return k;
        }

        override public function  get_filters():Array<ASAny>
        {
            return this._Str_6131;
        }

        override public function  set_etchingColor(k:UInt):UInt        {
            this._Str_12892 = true;
            return super.etchingColor = k;
        }

        function _Str_20609()
        {
            var k:Array<ASAny> = null;
            if (!this._Str_12892)
            {
                return;
            }
            this._Str_12892 = false;
            if ((ASCompat.toInt(_etchingColor )& ASCompat.toInt(0xFF000000)) != 0)
            {
                this._Str_14685.color = (ASCompat.toInt(_etchingColor )& 0xFFFFFF);
                this._Str_14685.alpha = (((ASCompat.toInt(_etchingColor )>> 24) & 0xFF) / 0xFF);
                k = this._Str_6131.slice(0);
                k.push(this._Str_14685);
                this.getGraphicContext(true).filters = (cast k);
            }
            else
            {
                this.getGraphicContext(true).filters = (cast this._Str_6131);
            }
        }

        override function refreshTextImage(k:Bool=false)
        {
            var _local_3:WindowEvent = null;
            var _local_2 = false;
            this._Str_20609();
            if (_w != _field.width)
            {
                if (autoSize != TextFieldAutoSize.NONE)
                {
                    width = Std.int(_field.width);
                    _local_2 = true;
                }
                else
                {
                    _field.width = width;
                }
            }
            if (_h != _field.height)
            {
                if (autoSize != TextFieldAutoSize.NONE)
                {
                    height = Std.int(_field.height);
                    _local_2 = true;
                }
                else
                {
                    _field.height = height;
                }
            }
            if ((((!_local_2) && (!k)) && (_events != null)))
            {
                _local_3 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZED, this, null);
                _events.dispatchEvent(_local_3);
                _local_3.recycle();
            }
        }

        function _Str_22281(k:TextEvent)
        {
            if (this._Str_22506(k.text))
            {
                k.preventDefault();
            }
        }

        function _Str_22506(k:String):Bool
        {
            var _local_3:String = null;
            var _local_4 = 0;
            var _local_2 = false;
            if ((multiline && (maxLines > 0)))
            {
                _local_2 = (numLines > maxLines);
                if (k != null)
                {
                    _local_3 = _field.text;
                    _local_4 = _field.caretIndex;
                    _field.text = ((_local_3.substring(0, _local_4) + k) + _local_3.substring(_local_4, _local_3.length));
                    if (numLines > maxLines)
                    {
                        _local_2 = true;
                    }
                    _field.text = _local_3;
                }
            }
            return _local_2;
        }

        function _Str_19964(event:KeyboardEvent)
        {
            var windowEvent:WindowKeyboardEvent = null;
            var tracker:IInputEventTracker = null;
            try
            {
                windowEvent = WindowKeyboardEvent.allocate(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, event, this, null);
                this.update(this, windowEvent);
                if (disposed)
                {
                    return;
                }
                final _iter_ = _context.inputEventTrackers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
tracker  = _tmp_;
                    tracker.eventReceived(windowEvent, this);
                }
                windowEvent.recycle();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.handleError(WindowContext.ERROR_DURING_EVENT_HANDLING, e);
            }
 }        }

        function _Str_21573(event:KeyboardEvent)
        {
            var windowEvent:WindowKeyboardEvent = null;
            var tracker:IInputEventTracker = null;
            try
            {
                _caption = _field.text;
                windowEvent = WindowKeyboardEvent.allocate(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, event, this, null);
                this.update(this, windowEvent);
                if (disposed)
                {
                    return;
                }
                final _iter_ = _context.inputEventTrackers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
tracker  = _tmp_;
                    tracker.eventReceived(windowEvent, this);
                }
                windowEvent.recycle();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.handleError(WindowContext.ERROR_DURING_EVENT_HANDLING, e);
            }
 }        }

        public function requestChangeEvent()
        {
            this._Str_16912(null);
        }

        function _Str_16912(event:Event)
        {
            var windowEvent:WindowEvent = null;
            try
            {
                _caption = _field.text;
                this._Str_18556();
                windowEvent = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_CHANGE, this, null);
                this.update(this, windowEvent);
                windowEvent.recycle();
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.handleError(WindowContext.ERROR_DURING_EVENT_HANDLING, e);
            }
 }        }

        function _Str_4932(event:FocusEvent)
        {
            try
            {
                if (event.type == FocusEvent.FOCUS_IN)
                {
                    if (!getStateFlag(WindowState.FOCUSED))
                    {
                        this.focus();
                    }
                }
                else
                {
                    if (event.type == FocusEvent.FOCUS_OUT)
                    {
                        if (getStateFlag(WindowState.FOCUSED))
                        {
                            this.unfocus();
                        }
                    }
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.handleError(WindowContext.ERROR_DURING_EVENT_HANDLING, e);
            }
 }        }

        function _Str_19111(event:Event)
        {
            try
            {
                if (getStateFlag(WindowState.FOCUSED))
                {
                    this.unfocus();
                }
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
                _context.handleError(WindowContext.ERROR_DURING_EVENT_HANDLING, e);
            }
 }        }

        override public function  get_properties():Array<ASAny>
        {
            var k= InteractiveController._Str_8987(this, super.properties);
            k.push(createProperty(PropertyKeys.EDITABLE, (_field.type == TextFieldType.INPUT)));
            k.push(createProperty(PropertyKeys.FOCUS_CAPTURER, this._Str_9948));
            k.push(createProperty(PropertyKeys.SELECTABLE, _field.selectable));
            k.push(createProperty(PropertyKeys.DISPLAY_AS_PASSWORD, _field.displayAsPassword));
            k.push(createProperty(PropertyKeys.DISPLAY_RAW, _displayRaw));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            InteractiveController._Str_11019(this, k);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.FOCUS_CAPTURER:
                        this._Str_9948 = ASCompat.asBoolean(_local_2.value );
                        if (this._Str_9948)
                        {
                            _context.getWindowServices().getFocusManagerService().registerFocusWindow(this);
                        }
                        
                    case PropertyKeys.SELECTABLE:
                        _field.selectable = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.EDITABLE:
                        _field.type = (_local_2.value ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
                        
                    case PropertyKeys.DISPLAY_AS_PASSWORD:
                        _field.displayAsPassword = ASCompat.asBoolean(_local_2.value );
                        
                    case PropertyKeys.DISPLAY_RAW:
                        _displayRaw = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
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

        
        public var _Str_16747(get,set):Bool;
public function  set__Str_16747(k:Bool):Bool        {
            return _displayRaw = k;
        }
public function  get__Str_16747():Bool
        {
            return _displayRaw;
        }

        override public function  set_localization(k:String):String        {
            super.localization = limitStringLength((_displayRaw ? _caption : k));
return k;
        }

        public function getWordAt(k:Int, _arg_2:Int):String
        {
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_3= getCharIndexAtPoint(k, _arg_2);
            var _local_4= _field.text;
            var _local_5= _Str_22243(_local_4);
            var _local_6= "";
            var _local_7 = 0;
            while (_local_7 < _local_5.length)
            {
                _local_8 = ASCompat.toInt(_local_5[_local_7]);
                _local_9 = _local_4.length;
                if ((_local_7 + 1) < _local_5.length)
                {
                    _local_9 = ASCompat.toInt(ASCompat.toNumber(_local_5[(_local_7 + 1)]) - 1);
                }
                if (((_local_3 >= _local_8) && (_local_3 <= _local_9)))
                {
                    _local_6 = _local_4.substring(_local_8, _local_9);
                    break;
                }
                _local_7++;
            }
            return _local_6;
        }
    }

