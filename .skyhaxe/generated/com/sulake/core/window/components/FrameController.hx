package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.utils.IMargins;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.utils.TextMargins;
    import com.sulake.core.window.iterators.ContainerIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.theme.PropertyKeys;

     class FrameController extends ContainerController implements IFrameWindow 
    {
        static inline final _TITLE= "_TITLE";
        static inline final _HEADER= "_HEADER";
        static inline final _CONTENT= "_CONTENT";
        static inline final _SCALER= "_SCALER";

        var _title:ILabelWindow;
        var _header:IHeaderWindow;
        var _content:IWindowContainer;
        var _margins:IMargins;
        var _ready:Bool = false;
        var _helpPage:String = "";
        var _helpButtonAction:ASFunction = null;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction=null, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            _arg_4 = (ASCompat.toInt(_arg_4 )| ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR));
            _arg_4 = (ASCompat.toInt(_arg_4 )& (~ASCompat.toInt(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            this._ready = true;
            activate();
            this._Str_21397();
            var _local_12= findChildByName("header_button_help");
            if (_local_12 != null)
            {
                _local_12.procedure = this._Str_22906;
            }
            this._Str_7032 = this._helpPage;
        }

        public var title(get,never):ILabelWindow;
public function  get_title():ILabelWindow
        {
            return (this._title != null) ? this._title : (this._title = cast(findChildByTag(_TITLE), ILabelWindow));
        }

        public var header(get,never):IHeaderWindow;
public function  get_header():IHeaderWindow
        {
            return (this._header != null) ? this._header : (this._header = cast(findChildByTag(_HEADER), IHeaderWindow));
        }

        public var content(get,never):IWindowContainer;
public function  get_content():IWindowContainer
        {
            return (this._content != null) ? this._content : (this._content = cast(findChildByTag(_CONTENT), IWindowContainer));
        }

        public var scaler(get,never):IScalerWindow;
public function  get_scaler():IScalerWindow
        {
            return Std.downcast(findChildByTag(_SCALER) , IScalerWindow);
        }

        public var margins(get,never):IMargins;
public function  get_margins():IMargins
        {
            if (this._margins == null)
            {
                this._margins = new TextMargins(this.content.left, this.content.top, this.content.right, this.content.bottom, this._Str_24678);
            }
            return this._margins;
        }

        override public function  set_caption(k:String):String        {
            super.caption = k;
            try
            {
                this.title.text = k;
            }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);             {
            }
 }return k;
        }

        override public function  set_color(k:UInt):UInt        {
            var _local_3:IWindow = null;
            super.color = k;
            var _local_2= new Array<ASAny>();
            groupChildrenWithTag(WindowController._COLORIZE, _local_2);
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_3  = _tmp_;
                _local_3.color = k;
            }
return k;
        }

        override public function  get_iterator():IIterator
        {
            return ((!(this.content == null)) && this._ready) ? this.content.iterator : new ContainerIterator(this);
        }

        function _Str_22906(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((k.type == WindowMouseEvent.CLICK) && (!(this._helpPage == ""))) && (!(this._helpButtonAction == null))))
            {
                this._helpButtonAction(this._helpPage);
            }
        }

        public var _Str_21008(never,set):ASFunction;
public function  set__Str_21008(k:ASFunction):ASFunction        {
            return this._helpButtonAction = k;
        }

        override public function buildFromXML(k:com.sulake.core.utils.xml.XML, _arg_2:Map=null):Bool
        {
            return !(context.getWindowParser().parseAndConstruct(k, this.content, _arg_2) == null);
        }

        override public function setParamFlag(k:UInt, _arg_2:Bool=true)
        {
            super.setParamFlag(k, _arg_2);
            this._Str_21397();
        }

        function _Str_21397()
        {
            var k:IWindow = this.scaler;
            var _local_2= testParamFlag(WindowParam.WINDOW_PARAM_MOUSE_SCALING_TARGET);
            var _local_3= testParamFlag(WindowParam.WINDOW_PARAM_VERTICAL_MOUSE_SCALING_TRIGGER);
            var _local_4= testParamFlag(WindowParam.WINDOW_PARAM_HORIZONTAL_MOUSE_SCALING_TRIGGER);
            if (k != null)
            {
                if ((_local_3 || _local_2))
                {
                    k.setParamFlag(WindowParam.WINDOW_PARAM_VERTICAL_MOUSE_SCALING_TRIGGER, true);
                }
                else
                {
                    k.setParamFlag(WindowParam.WINDOW_PARAM_VERTICAL_MOUSE_SCALING_TRIGGER, false);
                }
                if ((_local_4 || _local_2))
                {
                    k.setParamFlag(WindowParam.WINDOW_PARAM_HORIZONTAL_MOUSE_SCALING_TRIGGER, true);
                }
                else
                {
                    k.setParamFlag(WindowParam.WINDOW_PARAM_HORIZONTAL_MOUSE_SCALING_TRIGGER, false);
                }
                k.visible = ((_local_3 || _local_4) || _local_2);
            }
        }

        public function _Str_5665()
        {
            WindowController.resizeToAccommodateChildren(ASCompat.reinterpretAs(this.content , WindowController));
        }

        function _Str_24678(k:IMargins)
        {
            var _local_2:IWindow = this.content;
            var _local_3= _local_2.param;
            var _local_4:UInt = (ASCompat.toInt(_local_2.param )& (ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)));
            if (_local_4 != 0)
            {
                _local_2.setParamFlag((ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER )| ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)), false);
            }
            var _local_5:UInt = (ASCompat.toInt(_local_2.param )& ASCompat.toInt(WindowParam.WINDOW_PARAM_REFLECT_RESIZE_TO_PARENT));
            if (_local_5 != 0)
            {
                _local_2.setParamFlag(WindowParam.WINDOW_PARAM_REFLECT_RESIZE_TO_PARENT, false);
            }
            _local_2.rectangle = new Rectangle(k.left, k.top, (k.right - k.left), (k.bottom - k.top));
            if (((_local_4 != 0) || (_local_5 != 0)))
            {
                _local_2.setParamFlag(0xFFFFFFFF, false);
                _local_2.setParamFlag(_local_3, true);
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            var _local_2:ASAny = (!(this._margins == null));
            k.push(new PropertyStruct(PropertyKeys.HELP_PAGE, this._helpPage, PropertyStruct.STRING, (!(this._helpPage == ""))));
            k.push(new PropertyStruct(PropertyKeys.MARGIN_LEFT, this.content.left, PropertyStruct.INT, _local_2));
            k.push(new PropertyStruct(PropertyKeys.MARGIN_TOP, this.content.top, PropertyStruct.INT, _local_2));
            k.push(new PropertyStruct(PropertyKeys.MARGIN_RIGHT, (_w - this.content.right), PropertyStruct.INT, _local_2));
            k.push(new PropertyStruct(PropertyKeys.MARGIN_BOTTOM, (_h - this.content.bottom), PropertyStruct.INT, _local_2));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.HELP_PAGE:
                        this._Str_7032 = ASCompat.asString(_local_2.value );
                        
                    case PropertyKeys.MARGIN_LEFT:
                        this.margins.left = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.MARGIN_TOP:
                        this.margins.top = ASCompat.asInt(_local_2.value );
                        
                    case PropertyKeys.MARGIN_RIGHT:
                        this.margins.right = (_w - ASCompat.asInt(_local_2.value ));
                        
                    case PropertyKeys.MARGIN_BOTTOM:
                        this.margins.bottom = (_h - ASCompat.asInt(_local_2.value ));
                        
                }
            }
            return super.properties = k;
        }

        
        public var _Str_7032(get,set):String;
public function  get__Str_7032():String
        {
            return this._helpPage;
        }
public function  set__Str_7032(k:String):String        {
            this._helpPage = k;
            var _local_2= findChildByName("header_button_help");
            if (_local_2 != null)
            {
                _local_2.visible = (!(this._helpPage == ""));
            }
return k;
        }
    }

