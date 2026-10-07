package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.localization.ILocalizable;
    import com.sulake.core.window.utils.TextMargins;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.TextStyleManager;
    import flash.events.Event;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.text.TextFormat;
    import com.sulake.core.window.utils.IMargins;
    import com.sulake.core.window.utils.TextStyle;
    import com.sulake.core.window.utils.TextFieldCache;
    import flash.text.TextField;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.utils.PropertyStruct;

     class TextLabelController extends WindowController implements ILabelWindow implements  ILocalizable 
    {
        static inline final MARGINS= "margins";

        var _textColor:ASObject = null;
        var _textStyleName:String;
        var _text:String = "";
        var _localized:Bool = false;
        var _margins:TextMargins;
        var _textHeight:Float = 0;
        var _textWidth:Float = 0;
        var _refreshing:Bool = false;
        var _vertical:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._textStyleName = ASCompat.toString(_arg_5.getWindowFactory().getThemeManager().getPropertyDefaults(_arg_3).get(PropertyKeys.TEXT_STYLE));
            TextStyleManager.events.addEventListener(Event.CHANGE, this.onTextStyleChanged);
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public var antiAliasType(get,never):String;
public function  get_antiAliasType():String
        {
            return this.textField.antiAliasType;
        }

        public var autoSize(get,never):String;
public function  get_autoSize():String
        {
            return this.textField.autoSize;
        }

        public var bold(get,never):Bool;
public function  get_bold():Bool
        {
            return this.textField.defaultTextFormat.bold;
        }

        public var border(get,never):Bool;
public function  get_border():Bool
        {
            return this.textField.border;
        }

        public var borderColor(get,never):UInt;
public function  get_borderColor():UInt
        {
            return this.textField.borderColor;
        }

        public var defaultTextFormat(get,never):TextFormat;
public function  get_defaultTextFormat():TextFormat
        {
            return this.textField.defaultTextFormat;
        }

        public var embedFonts(get,never):Bool;
public function  get_embedFonts():Bool
        {
            return this.textField.embedFonts;
        }

        public var fontFace(get,never):String;
public function  get_fontFace():String
        {
            return this.textField.defaultTextFormat.font;
        }

        public var fontSize(get,never):UInt;
public function  get_fontSize():UInt
        {
            return ASCompat.toUInt((this.textField.defaultTextFormat.size == null) ? 12 : ASCompat.toUInt(this.textField.defaultTextFormat.size));
        }

        public var gridFitType(get,never):String;
public function  get_gridFitType():String
        {
            return this.textField.gridFitType;
        }

        public var italic(get,never):Bool;
public function  get_italic():Bool
        {
            return this.textField.defaultTextFormat.italic;
        }

        public var kerning(get,never):Bool;
public function  get_kerning():Bool
        {
            return this.textField.defaultTextFormat.kerning;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._text.length;
        }

        public var margins(get,never):IMargins;
public function  get_margins():IMargins
        {
            if (this._margins == null)
            {
                this._margins = new TextMargins(0, 0, 0, 0, this.setTextMargins);
            }
            return this._margins;
        }

        public var maxChars(get,never):Int;
public function  get_maxChars():Int
        {
            return this.textField.maxChars;
        }

        public var sharpness(get,never):Float;
public function  get_sharpness():Float
        {
            return this.textField.sharpness;
        }

        public var spacing(get,never):Float;
public function  get_spacing():Float
        {
            return ASCompat.toNumber(this.textField.defaultTextFormat.letterSpacing);
        }

        
        public var text(get,set):String;
public function  get_text():String
        {
            return this._text;
        }

        
        public var textColor(get,set):UInt;
public function  get_textColor():UInt
        {
            return ASCompat.toUInt(this._textColor);
        }

        public var textBackground(get,never):Bool;
public function  get_textBackground():Bool
        {
            return background;
        }

        public var textBackgroundColor(get,never):UInt;
public function  get_textBackgroundColor():UInt
        {
            return color;
        }

        public var textHeight(get,never):Float;
public function  get_textHeight():Float
        {
            return this._textHeight;
        }

        public var textWidth(get,never):Float;
public function  get_textWidth():Float
        {
            return this._textWidth;
        }

        
        public var textStyle(get,set):TextStyle;
public function  get_textStyle():TextStyle
        {
            return TextStyleManager.getStyle(this._textStyleName);
        }

        public var thickness(get,never):Float;
public function  get_thickness():Float
        {
            return this.textField.thickness;
        }

        public var underline(get,never):Bool;
public function  get_underline():Bool
        {
            return this.textField.defaultTextFormat.underline;
        }

        public var drawOffsetX(get,never):Int;
public function  get_drawOffsetX():Int
        {
            return (this._margins != null) ? this._margins.left : 0;
        }

        public var drawOffsetY(get,never):Int;
public function  get_drawOffsetY():Int
        {
            return (this._margins != null) ? this._margins.top : 0;
        }

        public var hasTextColor(get,never):Bool;
public function  get_hasTextColor():Bool
        {
            return !(this._textColor == null);
        }

        var textField(get,never):TextField;
function  get_textField():TextField
        {
            var k= TextFieldCache.getTextFieldByStyleName(this._textStyleName);
            if (k != null)
            {
                k.text = this._text;
                if (this._textColor != null)
                {
                    k.textColor = ASCompat.toUInt(this._textColor);
                }
            }
            return k;
        }
public function  set_text(k:String):String        {
            if (k == null)
            {
                return k;
            }
            if (this._localized)
            {
                context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                this._localized = false;
            }
            _caption = k;
            if (((_caption.charAt(0) == "$") && (_caption.charAt(1) == "{")))
            {
                context.registerLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                this._localized = true;
            }
            else
            {
                this._text = k;
                this.refresh();
            }
return k;
        }

        override public function  set_caption(k:String):String        {
            return this.text = k;
        }

        public var localization(never,set):String;
public function  set_localization(k:String):String        {
            if (k != null)
            {
                this._text = k;
                this.refresh();
            }
return k;
        }
public function  set_textStyle(k:TextStyle):TextStyle        {
            if (k == null)
            {
                return k;
            }
            if (this._textStyleName != k.name)
            {
                this._textStyleName = k.name;
                this.refresh();
            }
return k;
        }
public function  set_textColor(k:UInt):UInt        {
            if (k != this._textColor)
            {
                this._textColor = k;
                this.refresh();
            }
return k;
        }

        override public function dispose()
        {
            if (!_disposed)
            {
                TextStyleManager.events.removeEventListener(Event.CHANGE, this.onTextStyleChanged);
                if (this._localized)
                {
                    this._localized = false;
                    context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                }
                if (this._margins != null)
                {
                    this._margins.dispose();
                    this._margins = null;
                }
                super.dispose();
            }
        }

        function refresh(k:Bool=false)
        {
            var _local_11:WindowEvent = null;
            if (this._refreshing)
            {
                return;
            }
            this._refreshing = true;
            var _local_2= this.textField;
            if (_local_2 == null)
            {
                this._refreshing = false;
                return;
            }
            this._textWidth = _local_2.textWidth;
            this._textHeight = _local_2.textHeight;
            var _local_3= (_local_2.border ? 1 : 0);
            var _local_4= ((this._margins != null) ? (this._margins.left + this._margins.right) : 0);
            var _local_5= ((this._margins != null) ? (this._margins.top + this._margins.bottom) : 0);
            var _local_6= (_w - _local_4);
            var _local_7= (_h - _local_5);
            var _local_8= Std.int(Math.ffloor(_local_2.width) + _local_3);
            var _local_9= Std.int(Math.ffloor(_local_2.height) + _local_3);
            var _local_10 = false;
            if (this._vertical)
            {
                if (_local_8 != _local_7)
                {
                    setRectangle(_x, _y, (_local_9 + _local_4), Std.int(Math.ffloor(_local_2.width) + _local_5));
                    _local_10 = true;
                }
                if (_local_9 < _local_6)
                {
                    _local_2.height = (_local_6 - _local_3);
                }
                else
                {
                    if (_local_9 > _local_6)
                    {
                        setRectangle(_x, _y, (_local_9 + _local_4), Std.int(Math.ffloor(_local_2.width) + _local_5));
                        _local_10 = true;
                    }
                }
            }
            else
            {
                if (_local_8 != _local_6)
                {
                    setRectangle(_x, _y, (_local_8 + _local_4), Std.int(Math.ffloor(_local_2.height) + _local_5));
                    _local_10 = true;
                }
                if (_local_9 < _local_7)
                {
                    _local_2.height = (_local_7 - _local_3);
                }
                else
                {
                    if (_local_9 > _local_7)
                    {
                        setRectangle(_x, _y, (_local_8 + _local_4), Std.int(Math.ffloor(_local_2.height) + _local_5));
                        _local_10 = true;
                    }
                }
            }
            this._refreshing = false;
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            if ((((!_local_10) && (!k)) && (_events != null)))
            {
                _local_11 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZED, this, null);
                _events.dispatchEvent(_local_11);
                _local_11.recycle();
            }
        }

        function setTextMargins(k:IMargins)
        {
            if (((k != null) && (!((k : ASAny) == (this._margins : ASAny)))))
            {
                if (this._margins != null)
                {
                    this._margins.assign(k.left, k.top, k.right, k.bottom, this.setTextMargins);
                }
                else
                {
                    this._margins = new TextMargins(k.left, k.top, k.right, k.bottom, this.setTextMargins);
                }
            }
            this.refresh();
        }

        function onTextStyleChanged(k:Event)
        {
            this.refresh();
        }

        function setTextMarginMap(k:Map)
        {
            if (this._margins != null)
            {
                this._margins.assign(ASCompat.toInt(k.getValue("left")), ASCompat.toInt(k.getValue("top")), ASCompat.toInt(k.getValue("right")), ASCompat.toInt(k.getValue("bottom")), this.setTextMargins);
            }
            else
            {
                this._margins = new TextMargins(ASCompat.toInt(k.getValue("left")), ASCompat.toInt(k.getValue("top")), ASCompat.toInt(k.getValue("right")), ASCompat.toInt(k.getValue("bottom")), this.setTextMargins);
            }
            this.refresh();
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            var _local_2= TextStyleManager.getStyle(this._textStyleName);
            k.push(createProperty(PropertyKeys.TEXT_STYLE, this._textStyleName));
            var _local_3= ASCompat.toUInt(((_local_2.color != null) ? _local_2.color : getDefaultProperty(PropertyKeys.TEXT_COLOR).value));
            k.push(new PropertyStruct(PropertyKeys.TEXT_COLOR, ((this._textColor == null) ? _local_3 : this._textColor), PropertyStruct.HEX, ((!(this._textColor == null)) && (!(this._textColor == _local_3)))));
            k.push(createProperty(PropertyKeys.VERTICAL, this._vertical));
            if (this._margins != null)
            {
                k.push(createProperty(PropertyKeys.MARGIN_LEFT, this._margins.left));
                k.push(createProperty(PropertyKeys.MARGIN_TOP, this._margins.top));
                k.push(createProperty(PropertyKeys.MARGIN_RIGHT, this._margins.right));
                k.push(createProperty(PropertyKeys.MARGIN_BOTTOM, this._margins.bottom));
            }
            else
            {
                k.push(getDefaultProperty(PropertyKeys.MARGIN_LEFT));
                k.push(getDefaultProperty(PropertyKeys.MARGIN_TOP));
                k.push(getDefaultProperty(PropertyKeys.MARGIN_RIGHT));
                k.push(getDefaultProperty(PropertyKeys.MARGIN_BOTTOM));
            }
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.TEXT_STYLE:
                        this.textStyle = TextStyleManager.getStyle(ASCompat.asString(_local_2.value ));
                        
                    case PropertyKeys.TEXT_COLOR:
                        this._textColor = ASCompat.asUint(_local_2.value );
                        
                    case PropertyKeys.MARGIN_LEFT:
                        if (((!(this._margins == null)) || _local_2.valid))
                        {
                            this.margins.left = ASCompat.asInt(_local_2.value );
                        }
                        
                    case PropertyKeys.MARGIN_TOP:
                        if (((!(this._margins == null)) || _local_2.valid))
                        {
                            this.margins.top = ASCompat.asInt(_local_2.value );
                        }
                        
                    case PropertyKeys.MARGIN_RIGHT:
                        if (((!(this._margins == null)) || _local_2.valid))
                        {
                            this.margins.right = ASCompat.asInt(_local_2.value );
                        }
                        
                    case PropertyKeys.MARGIN_BOTTOM:
                        if (((!(this._margins == null)) || _local_2.valid))
                        {
                            this.margins.bottom = ASCompat.asInt(_local_2.value );
                        }
                        
                    case MARGINS:
                        this.setTextMarginMap(ASCompat.dynamicAs(_local_2.value , Map));
                        
                    case PropertyKeys.VERTICAL:
                        this.vertical = ASCompat.asBoolean(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }

        
        public var vertical(get,set):Bool;
public function  get_vertical():Bool
        {
            return this._vertical;
        }
public function  set_vertical(k:Bool):Bool        {
            this._vertical = k;
            this.refresh();
return k;
        }
    }

