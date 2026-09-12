package com.sulake.core.window.components
;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.ITextFieldContainer;
    import com.sulake.core.localization.ILocalizable;
    import flash.text.TextField;
    import com.sulake.core.window.utils.TextMargins;
    import flash.text.TextFormat;
    import com.sulake.core.window.utils.TextStyle;
    import com.sulake.core.window.theme.PropertyKeys;
    import com.sulake.core.window.utils.TextStyleManager;
    import flash.events.Event;
    import flash.text.TextFieldAutoSize;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.text.AntiAliasType;
    import flash.text.TextFormatAlign;
    import com.sulake.core.utils.FontEnum;
    import com.sulake.core.utils.Map;
    import flash.text.FontStyle;
    import com.sulake.core.window.utils.IMargins;
    import flash.text.Font;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.graphics.WindowRedrawFlag;
    import flash.display.DisplayObject;
    import flash.text.TextLineMetrics;
    import com.sulake.core.utils.XMLVariableParser;
    import com.sulake.core.window.utils.PropertyStruct;
    import flash.text.StyleSheet;

     class TextController extends WindowController implements ITextWindow implements  ITextFieldContainer implements  ILocalizable 
    {
        static final REPLACE_RANDOM_CHARS:Array<ASAny> = ["a", "B", "c", "D", "e"];
        static final _PROPERTY_SETTER_TABLE:ASDictionary<ASAny,ASAny> = createPropertySetterTable();

        var _overFlowReplace:String = "";
        var _field:TextField;
        var _scrollH:Float = Math.NaN;
        var _scrollV:Float = Math.NaN;
        var _drawing:Bool = false;
        var _margins:TextMargins;
        var _autoSize:String = "none";
        var _localized:Bool = false;
        var _maxLines:Int = 0;
        var _displayRaw:Bool = false;
        var _etchingColor:UInt = 0;
        var _etchingPosition:String;
        var _defaultFormat:TextFormat;
        var _textStyleName:String;
        var _explicitStyle:TextStyle;
        var _settingRectangle:Bool = false;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._explicitStyle = new TextStyle();
            this._margins = new TextMargins(0, 0, 0, 0, this.setTextMargins);
            this._drawing = false;
            this._scrollH = 0;
            this._scrollV = 0;
            if (this._field == null)
            {
                this._field = new TextField();
                if (_arg_6 != null)
                {
                    this._field.width = _arg_6.width;
                    this._field.height = _arg_6.height;
                }
                this._field.mouseWheelEnabled = false;
            }
            this._textStyleName = ASCompat.toString(_arg_5.getWindowFactory().getThemeManager().getPropertyDefaults(_arg_3).get(PropertyKeys.TEXT_STYLE));
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            setTextFormatting(this);
            TextStyleManager.events.addEventListener(Event.CHANGE, this.onTextStyleChanged);
            if (this._field.autoSize == TextFieldAutoSize.NONE)
            {
                this._field.width = _w;
                this._field.height = _h;
            }
        }

        static function setAntiAliasType(k:TextController, _arg_2:String)
        {
            _arg_2 = ((_arg_2 == AntiAliasType.ADVANCED) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL);
            k._explicitStyle.antiAliasType = _arg_2;
            k._field.antiAliasType = _arg_2;
            k.refreshTextImage();
        }

        static function setAlwaysShowSelection(k:TextController, _arg_2:Bool)
        {
            k._field.alwaysShowSelection = _arg_2;
        }

        static function setAutoSize(k:TextController, _arg_2:String)
        {
            var _local_3:TextFormat = null;
            if (_arg_2 != k._autoSize)
            {
                k._autoSize = _arg_2;
                k._field.autoSize = ((_arg_2 != TextFieldAutoSize.NONE) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE);
                _local_3 = k.defaultTextFormat;
                switch (_arg_2)
                {
                    case "center":
                        _local_3.align = TextFormatAlign.CENTER;
                        
                    case "right":
                        _local_3.align = TextFormatAlign.RIGHT;
                        
                    default:
                        _local_3.align = TextFormatAlign.LEFT;
                }
                k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
                k.defaultTextFormat = _local_3;
                k.refreshTextImage();
            }
        }

        static function setTextBackground(k:TextController, _arg_2:Bool)
        {
            k.background = _arg_2;
        }

        static function setTextBackgroundColor(k:TextController, _arg_2:UInt)
        {
            k.color = _arg_2;
        }

        static function setBold(k:TextController, _arg_2:Bool)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.bold = _arg_2;
            k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
            k.defaultTextFormat = _local_3;
            k._explicitStyle.fontWeight = TextStyle.BOLD;
        }

        static function setBorder(k:TextController, _arg_2:Bool)
        {
            k._field.border = _arg_2;
            k.refreshTextImage();
        }

        static function setBorderColor(k:TextController, _arg_2:UInt)
        {
            k._field.borderColor = _arg_2;
            k.refreshTextImage();
        }

        static function setCondenseWhite(k:TextController, _arg_2:Bool)
        {
            k._field.condenseWhite = _arg_2;
            k.refreshTextImage();
        }

        static function setDefaultTextFormat(k:TextController, _arg_2:TextFormat)
        {
            k._field.defaultTextFormat = _arg_2;
            k.refreshTextImage();
        }

        static function setEmbedFonts(k:TextController, _arg_2:Bool)
        {
            k._field.embedFonts = _arg_2;
        }

        static function setFontFace(k:TextController, _arg_2:String)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.font = _arg_2;
            k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
            k._field.embedFonts = FontEnum.isEmbeddedFont(_arg_2);
            k.defaultTextFormat = _local_3;
            k._explicitStyle.fontFamily = _arg_2;
        }

        static function setFontSize(k:TextController, _arg_2:UInt)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.size = _arg_2;
            k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
            k.defaultTextFormat = _local_3;
            k._explicitStyle.fontSize = _arg_2;
        }

        static function setGridFitType(k:TextController, _arg_2:String)
        {
            k._field.gridFitType = _arg_2;
            k.refreshTextImage();
        }

        static function setHtmlText(k:TextController, _arg_2:String)
        {
            if (_arg_2 == null)
            {
                return;
            }
            if (k._localized)
            {
                k.context.removeLocalizationListener(k._caption.substring(2, k._caption.indexOf("}")), k);
                k._localized = false;
            }
            k._caption = _arg_2;
            if (((k._caption.charAt(0) == "$") && (k._caption.charAt(1) == "{")))
            {
                k.context.registerLocalizationListener(k._caption.substring(2, k._caption.indexOf("}")), k);
                k._localized = true;
            }
            else
            {
                if (k._field != null)
                {
                    k._field.htmlText = k._caption;
                    k.refreshTextImage();
                }
            }
        }

        static function setItalic(k:TextController, _arg_2:Bool)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.italic = _arg_2;
            k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
            k.defaultTextFormat = _local_3;
            k._explicitStyle.fontStyle = (_arg_2 ? TextStyle.ITALIC : TextStyle.NORMAL);
        }

        static function setKerning(k:TextController, _arg_2:Bool)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.kerning = _arg_2;
            var _local_4= new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading);
            _local_4.kerning = _arg_2;
            k.setTextFormat(_local_4);
            k.defaultTextFormat = _local_3;
            k._explicitStyle.kerning = _arg_2;
        }

        static function setTextMarginMap(k:TextController, _arg_2:Map)
        {
            if (k._margins != null)
            {
                k._margins.assign(ASCompat.toInt(_arg_2.getValue("left")), ASCompat.toInt(_arg_2.getValue("top")), ASCompat.toInt(_arg_2.getValue("right")), ASCompat.toInt(_arg_2.getValue("bottom")), k.setTextMargins);
            }
            else
            {
                k._margins = new TextMargins(ASCompat.toInt(_arg_2.getValue("left")), ASCompat.toInt(_arg_2.getValue("top")), ASCompat.toInt(_arg_2.getValue("right")), ASCompat.toInt(_arg_2.getValue("bottom")), k.setTextMargins);
            }
            k.refreshTextImage();
        }

        static function setMarginLeft(k:TextController, _arg_2:Int)
        {
            if (((k._margins != null) && (!(k._margins.left == _arg_2))))
            {
                k.margins.left = _arg_2;
            }
        }

        static function setMarginTop(k:TextController, _arg_2:Int)
        {
            if (((k._margins != null) && (!(k._margins.top == _arg_2))))
            {
                k.margins.top = _arg_2;
            }
        }

        static function setMarginRight(k:TextController, _arg_2:Int)
        {
            if (((k._margins != null) && (!(k._margins.right == _arg_2))))
            {
                k.margins.right = _arg_2;
            }
        }

        static function setMarginBottom(k:TextController, _arg_2:Int)
        {
            if (((k._margins != null) && (!(k._margins.bottom == _arg_2))))
            {
                k.margins.bottom = _arg_2;
            }
        }

        static function setMaxChars(k:TextController, _arg_2:Int)
        {
            k._field.maxChars = _arg_2;
            k.refreshTextImage();
        }

        static function setMouseWheelEnabled(k:TextController, _arg_2:Bool)
        {
            k._field.mouseWheelEnabled = _arg_2;
        }

        static function setMultiline(k:TextController, _arg_2:Bool)
        {
            k._field.multiline = _arg_2;
            k.refreshTextImage();
        }

        static function setRestrict(k:TextController, _arg_2:String)
        {
            k._field.restrict = _arg_2;
        }

        static function setSharpness(k:TextController, _arg_2:Float)
        {
            k._field.sharpness = _arg_2;
            k.refreshTextImage();
            k._explicitStyle.sharpness = _arg_2;
        }

        static function setSpacing(k:TextController, _arg_2:Float)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.letterSpacing = _arg_2;
            var _local_4= new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading);
            _local_4.letterSpacing = _arg_2;
            k.setTextFormat(_local_4);
            k.defaultTextFormat = _local_3;
            k._explicitStyle.letterSpacing = _arg_2;
        }

        static function setMaxLines(k:TextController, _arg_2:Int)
        {
            k._maxLines = _arg_2;
            k.refreshTextImage();
        }

        static function setLeading(k:TextController, _arg_2:Float)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.leading = Std.int(_arg_2);
            var _local_4= new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading);
            _local_4.leading = Std.int(_arg_2);
            k.setTextFormat(_local_4);
            k.defaultTextFormat = _local_3;
            k._explicitStyle.leading = _arg_2;
        }

        static function setTextColor(k:TextController, _arg_2:UInt)
        {
            k._field.textColor = _arg_2;
            k.refreshTextImage();
            k._explicitStyle.color = _arg_2;
        }

        static function setTextStyle(k:TextController, _arg_2:TextStyle)
        {
            if (((!(k != null)) || (!(_arg_2 != null))))
            {
                return;
            }
            var _local_3= TextStyleManager.getStyle(_arg_2.name);
            if (((_local_3 != null) && (!_local_3.equals(_arg_2))))
            {
                _local_3 = TextStyleManager.findMatchingTextStyle(_arg_2.toString());
            }
            if (_local_3 != null)
            {
                k._textStyleName = _local_3.name;
                setTextFormatting(k);
                k.refreshTextImage();
            }
        }

        static function setTextStyleString(k:TextController, _arg_2:String)
        {
            var _local_4:TextFormat = null;
            var _local_3= TextStyleManager.getStyle(_arg_2);
            if (_local_3 == null)
            {
                _local_3 = TextStyleManager.findMatchingTextStyle(_arg_2);
            }
            if (_local_3 != null)
            {
                k._textStyleName = _local_3.name;
                setTextFormatting(k);
                k.refreshTextImage();
            }
            else
            {
                _local_3 = TextStyleManager.parseCSS(_arg_2)[0];
                if (_local_3 != null)
                {
                    if (TextStyleManager.getStyle(_local_3.name) == null)
                    {
                        TextStyleManager.setStyle(_local_3.name, _local_3);
                    }
                    setTextStyle(k, _local_3);
                }
            }
            if (k._autoSize == TextFieldAutoSize.CENTER)
            {
                _local_4 = new TextFormat();
                _local_4.align = TextFormatAlign.CENTER;
                k._field.setTextFormat(_local_4);
            }
        }

        static function setThickness(k:TextController, _arg_2:Float)
        {
            k._field.thickness = _arg_2;
            k.refreshTextImage();
            k._explicitStyle.thickness = _arg_2;
        }

        static function setUnderline(k:TextController, _arg_2:Bool)
        {
            var _local_3= k.defaultTextFormat;
            _local_3.underline = _arg_2;
            k.setTextFormat(new TextFormat(_local_3.font, _local_3.size, _local_3.color, _local_3.bold, _local_3.italic, _local_3.underline, _local_3.url, _local_3.target, _local_3.align, _local_3.leftMargin, _local_3.rightMargin, _local_3.indent, _local_3.leading));
            k.defaultTextFormat = _local_3;
            k._explicitStyle.textDecoration = (_arg_2 ? TextStyle.UNDERLINE : TextStyle.NONE);
        }

        static function setWordWrap(k:TextController, _arg_2:Bool)
        {
            k._field.wordWrap = _arg_2;
            k.refreshTextImage();
        }

        static function setOverflowReplace(k:TextController, _arg_2:String)
        {
            k._overFlowReplace = _arg_2;
            k.refreshTextImage();
        }

        static function setTextFormatting(k:TextController)
        {
            var _local_2= k._field;
            var _local_3= k._textStyleName;
            var _local_4= k._explicitStyle;
            var _local_5= TextStyleManager.getStyle(_local_3);
            var _local_6= _local_2.defaultTextFormat;
            if (_local_5 == null)
            {
                _local_5 = TextStyleManager.getStyle(TextStyleManager.REGULAR);
            }
            if (!_local_5.color)
            {
                _local_5.color = 0;
            }
            if (!ASCompat.stringAsBool(_local_4.fontFamily))
            {
                _local_6.font = _local_5.fontFamily;
            }
            if (!_local_4.fontSize)
            {
                _local_6.size = _local_5.fontSize;
            }
            if (!_local_4.color)
            {
                _local_6.color = _local_5.color;
            }
            if (!ASCompat.stringAsBool(_local_4.fontWeight))
            {
                _local_6.bold = ((_local_5.fontWeight == FontStyle.BOLD) ? true : null);
            }
            if (!ASCompat.stringAsBool(_local_4.fontStyle))
            {
                _local_6.italic = ((_local_5.fontStyle == FontStyle.ITALIC) ? true : null);
            }
            if (!ASCompat.stringAsBool(_local_4.textDecoration))
            {
                _local_6.underline = ((_local_5.textDecoration == TextStyle.UNDERLINE) ? true : null);
            }
            if (!_local_4.textIndent)
            {
                _local_6.indent = _local_5.textIndent;
            }
            if (!_local_4.leading)
            {
                _local_6.leading = _local_5.leading;
            }
            if (!_local_4.kerning)
            {
                _local_6.kerning = _local_5.kerning;
            }
            if (!_local_4.letterSpacing)
            {
                _local_6.letterSpacing = _local_5.letterSpacing;
            }
            if (!ASCompat.stringAsBool(_local_4.antiAliasType))
            {
                _local_2.antiAliasType = ((_local_5.antiAliasType == AntiAliasType.ADVANCED) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL);
            }
            if (!_local_4.sharpness)
            {
                _local_2.sharpness = ASCompat.toInt(_local_5.sharpness);
            }
            if (!_local_4.thickness)
            {
                _local_2.thickness = ASCompat.toInt(_local_5.thickness);
            }
            if (_local_4.etchingColor == null)
            {
                k.etchingColor = ASCompat.toUInt(_local_5.etchingColor);
            }
            if (_local_4.etchingPosition == null)
            {
                k.etchingPosition = ASCompat.toString(_local_5.etchingPosition);
            }
            if (((!ASCompat.stringAsBool(_local_5.fontWeight)) && (!ASCompat.stringAsBool(_local_4.fontWeight))))
            {
                _local_6.bold = false;
            }
            if (((!ASCompat.stringAsBool(_local_5.fontStyle)) && (!ASCompat.stringAsBool(_local_4.fontStyle))))
            {
                _local_6.italic = false;
            }
            if (((!ASCompat.stringAsBool(_local_5.textDecoration)) && (!ASCompat.stringAsBool(_local_4.textDecoration))))
            {
                _local_6.underline = false;
            }
            if (((!_local_5.textIndent) && (!_local_4.textIndent)))
            {
                _local_6.indent = 0;
            }
            if (((!_local_5.leading) && (!_local_4.leading)))
            {
                _local_6.leading = 0;
            }
            if (((!_local_5.kerning) && (!_local_4.kerning)))
            {
                _local_6.kerning = false;
            }
            if (((!_local_5.letterSpacing) && (!_local_4.letterSpacing)))
            {
                _local_6.letterSpacing = 0;
            }
            if (((!ASCompat.stringAsBool(_local_5.antiAliasType)) && (!ASCompat.stringAsBool(_local_4.antiAliasType))))
            {
                _local_2.antiAliasType = AntiAliasType.NORMAL;
            }
            if (((!_local_5.sharpness) && (!_local_4.sharpness)))
            {
                _local_2.sharpness = 0;
            }
            if (((!_local_5.thickness) && (!_local_4.thickness)))
            {
                _local_2.thickness = 0;
            }
            if (((_local_5.etchingColor == null) && (_local_4.etchingColor == null)))
            {
                k.etchingColor = 0;
            }
            if (((_local_5.etchingPosition == null) && (_local_4.etchingPosition == null)))
            {
                k.etchingPosition = TextStyle.BOTTOM;
            }
            _local_2.setTextFormat(_local_6);
            _local_2.embedFonts = FontEnum.isEmbeddedFont(_local_6.font);
            _local_2.defaultTextFormat = _local_6;
            k._defaultFormat = _local_6;
        }

        static function createPropertySetterTable():ASDictionary<ASAny,ASAny>
        {
            var k= new ASDictionary<ASAny,ASAny>();
            k[PropertyKeys.ALWAYS_SHOW_SELECTION] = setAlwaysShowSelection;
            k["background"] = setTextBackground;
            k["background_color"] = setTextBackgroundColor;
            k[PropertyKeys.BOLD] = setBold;
            k[PropertyKeys.BORDER] = setBorder;
            k[PropertyKeys.BORDER_COLOR] = setBorderColor;
            k[PropertyKeys.CONDENSE_WHITE] = setCondenseWhite;
            k["default_text_format"] = setDefaultTextFormat;
            k[PropertyKeys.ETCHING_COLOR] = setEtchingColor;
            k[PropertyKeys.ETCHING_POSITION] = setEtchingPosition;
            k[PropertyKeys.FONT_FACE] = setFontFace;
            k[PropertyKeys.FONT_SIZE] = setFontSize;
            k[PropertyKeys.GRID_FIT_TYPE] = setGridFitType;
            k[PropertyKeys.ITALIC] = setItalic;
            k[PropertyKeys.KERNING] = setKerning;
            k[PropertyKeys.MAX_CHARS] = setMaxChars;
            k[PropertyKeys.MULTILINE] = setMultiline;
            k[PropertyKeys.RESTRICT] = setRestrict;
            k[PropertyKeys.SPACING] = setSpacing;
            k[PropertyKeys.SHARPNESS] = setSharpness;
            k[PropertyKeys.THICKNESS] = setThickness;
            k[PropertyKeys.UNDERLINE] = setUnderline;
            k[PropertyKeys.WORD_WRAP] = setWordWrap;
            k["margins"] = setTextMarginMap;
            k[PropertyKeys.MAX_LINES] = setMaxLines;
            k[PropertyKeys.LEADING] = setLeading;
            k[PropertyKeys.ANTIALIAS_TYPE] = setAntiAliasType;
            k[PropertyKeys.AUTO_SIZE] = setAutoSize;
            k[PropertyKeys.MOUSE_WHEEL_ENABLED] = setMouseWheelEnabled;
            k[PropertyKeys.TEXT_COLOR] = setTextColor;
            k[PropertyKeys.TEXT_STYLE] = setTextStyleString;
            k[PropertyKeys.MARGIN_LEFT] = setMarginLeft;
            k[PropertyKeys.MARGIN_TOP] = setMarginTop;
            k[PropertyKeys.MARGIN_RIGHT] = setMarginRight;
            k[PropertyKeys.MARGIN_BOTTOM] = setMarginBottom;
            k[PropertyKeys.OVERFLOW_REPLACE] = setOverflowReplace;
            return k;
        }

        static function setEtchingColor(k:TextController, _arg_2:UInt)
        {
            k._etchingColor = _arg_2;
            k.refreshTextImage();
            k._explicitStyle.etchingColor = k._etchingColor;
        }

        static function setEtchingPosition(k:TextController, _arg_2:String)
        {
            k._etchingPosition = _arg_2;
            k.refreshTextImage();
            k._explicitStyle.etchingPosition = k._etchingPosition;
        }


        
        public var antiAliasType(get,set):String;
public function  get_antiAliasType():String
        {
            return this._field.antiAliasType;
        }

        
        public var autoSize(get,set):String;
public function  get_autoSize():String
        {
            return this._autoSize;
        }

        
        public var bold(get,set):Bool;
public function  get_bold():Bool
        {
            return this._field.defaultTextFormat.bold;
        }

        
        public var border(get,set):Bool;
public function  get_border():Bool
        {
            return this._field.border;
        }

        
        public var borderColor(get,set):UInt;
public function  get_borderColor():UInt
        {
            return this._field.borderColor;
        }

        public var bottomScrollV(get,never):Int;
public function  get_bottomScrollV():Int
        {
            return this._field.bottomScrollV;
        }

        
        public var defaultTextFormat(get,set):TextFormat;
public function  get_defaultTextFormat():TextFormat
        {
            return this._field.defaultTextFormat;
        }

        
        public var embedFonts(get,set):Bool;
public function  get_embedFonts():Bool
        {
            return this._field.embedFonts;
        }

        
        public var fontFace(get,set):String;
public function  get_fontFace():String
        {
            return this._field.defaultTextFormat.font;
        }

        
        public var fontSize(get,set):UInt;
public function  get_fontSize():UInt
        {
            return ASCompat.toUInt((this._field.defaultTextFormat.size == null) ? 12 : ASCompat.toUInt(this._field.defaultTextFormat.size));
        }

        
        public var gridFitType(get,set):String;
public function  get_gridFitType():String
        {
            return this._field.gridFitType;
        }

        
        public var htmlText(get,set):String;
public function  get_htmlText():String
        {
            return this._field.htmlText;
        }

        
        public var italic(get,set):Bool;
public function  get_italic():Bool
        {
            return this._field.defaultTextFormat.italic;
        }

        
        public var kerning(get,set):Bool;
public function  get_kerning():Bool
        {
            return this._field.defaultTextFormat.kerning;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._field.length;
        }

        public var margins(get,never):IMargins;
public function  get_margins():IMargins
        {
            return this._margins;
        }

        
        public var maxChars(get,set):Int;
public function  get_maxChars():Int
        {
            return this._field.maxChars;
        }

        
        public var multiline(get,set):Bool;
public function  get_multiline():Bool
        {
            return this._field.multiline;
        }

        public var numLines(get,never):Int;
public function  get_numLines():Int
        {
            return this._field.numLines;
        }

        
        public var restrict(get,set):String;
public function  get_restrict():String
        {
            return this._field.restrict;
        }

        
        public var sharpness(get,set):Float;
public function  get_sharpness():Float
        {
            return this._field.sharpness;
        }

        
        public var spacing(get,set):Float;
public function  get_spacing():Float
        {
            return ASCompat.toNumber(this._field.defaultTextFormat.letterSpacing);
        }

        
        public var text(get,set):String;
public function  get_text():String
        {
            return (this._field != null) ? this._field.text : "";
        }

        
        public var textColor(get,set):UInt;
public function  get_textColor():UInt
        {
            return this._field.textColor;
        }

        
        public var textBackground(get,set):Bool;
public function  get_textBackground():Bool
        {
            return background;
        }

        
        public var textBackgroundColor(get,set):UInt;
public function  get_textBackgroundColor():UInt
        {
            return color;
        }

        public var textHeight(get,never):Float;
public function  get_textHeight():Float
        {
            return this._field.textHeight;
        }

        public var textWidth(get,never):Float;
public function  get_textWidth():Float
        {
            return this._field.textWidth;
        }

        
        public var textStyle(get,set):TextStyle;
public function  get_textStyle():TextStyle
        {
            return TextStyleManager.getStyle(this._textStyleName);
        }

        
        public var thickness(get,set):Float;
public function  get_thickness():Float
        {
            return this._field.thickness;
        }

        
        public var underline(get,set):Bool;
public function  get_underline():Bool
        {
            return this._field.defaultTextFormat.underline;
        }

        
        public var wordWrap(get,set):Bool;
public function  get_wordWrap():Bool
        {
            return this._field.wordWrap;
        }

        public var textField(get,never):TextField;
public function  get_textField():TextField
        {
            return this._field;
        }

        
        public var maxLines(get,set):Int;
public function  get_maxLines():Int
        {
            return this._maxLines;
        }

        
        public var leading(get,set):Float;
public function  get_leading():Float
        {
            return ASCompat.toNumber(this._field.defaultTextFormat.leading);
        }

        public var isOverflowReplaceOn(get,never):Bool;
public function  get_isOverflowReplaceOn():Bool
        {
            return !(this._overFlowReplace == "");
        }

        
        public var overflowReplace(get,set):String;
public function  get_overflowReplace():String
        {
            return this._overFlowReplace;
        }

        
        public var scrollH(get,set):Float;
public function  get_scrollH():Float
        {
            return this._scrollH;
        }

        
        public var scrollV(get,set):Float;
public function  get_scrollV():Float
        {
            return this._scrollV;
        }

        public var maxScrollH(get,never):Int;
public function  get_maxScrollH():Int
        {
            return this._field.maxScrollH;
        }

        public var maxScrollV(get,never):Int;
public function  get_maxScrollV():Int
        {
            return Std.int(Math.max((this._field.textHeight - height), 0));
        }
public function  set_antiAliasType(k:String):String        {
            setAntiAliasType(this, k);
return k;
        }
public function  set_autoSize(k:String):String        {
            setAutoSize(this, k);
return k;
        }
public function  set_bold(k:Bool):Bool        {
            setBold(this, k);
return k;
        }
public function  set_border(k:Bool):Bool        {
            setBorder(this, k);
return k;
        }
public function  set_borderColor(k:UInt):UInt        {
            setBorderColor(this, k);
return k;
        }
public function  set_defaultTextFormat(k:TextFormat):TextFormat        {
            setDefaultTextFormat(this, k);
return k;
        }
public function  set_embedFonts(k:Bool):Bool        {
            setEmbedFonts(this, k);
return k;
        }
public function  set_fontFace(k:String):String        {
            setFontFace(this, k);
return k;
        }
public function  set_fontSize(k:UInt):UInt        {
            setFontSize(this, k);
return k;
        }
public function  set_gridFitType(k:String):String        {
            setGridFitType(this, k);
return k;
        }
public function  set_htmlText(k:String):String        {
            setHtmlText(this, k);
return k;
        }
public function  set_italic(k:Bool):Bool        {
            setItalic(this, k);
return k;
        }
public function  set_kerning(k:Bool):Bool        {
            setKerning(this, k);
return k;
        }
public function  set_maxChars(k:Int):Int        {
            setMaxChars(this, k);
return k;
        }
public function  set_multiline(k:Bool):Bool        {
            setMultiline(this, k);
return k;
        }
public function  set_restrict(k:String):String        {
            setRestrict(this, k);
return k;
        }
public function  set_sharpness(k:Float):Float        {
            setSharpness(this, k);
return k;
        }
public function  set_spacing(k:Float):Float        {
            setSpacing(this, k);
return k;
        }
public function  set_textColor(k:UInt):UInt        {
            setTextColor(this, k);
return k;
        }
public function  set_textBackground(k:Bool):Bool        {
            setTextBackground(this, k);
return k;
        }
public function  set_textBackgroundColor(k:UInt):UInt        {
            setTextBackgroundColor(this, k);
return k;
        }
public function  set_textStyle(k:TextStyle):TextStyle        {
            setTextStyle(this, k);
return k;
        }
public function  set_thickness(k:Float):Float        {
            setThickness(this, k);
return k;
        }
public function  set_underline(k:Bool):Bool        {
            setUnderline(this, k);
return k;
        }
public function  set_wordWrap(k:Bool):Bool        {
            setWordWrap(this, k);
return k;
        }
public function  set_maxLines(k:Int):Int        {
            setMaxLines(this, k);
return k;
        }
public function  set_leading(k:Float):Float        {
            setLeading(this, k);
return k;
        }
public function  set_overflowReplace(k:String):String        {
            setOverflowReplace(this, k);
return k;
        }

        function limitStringLength(k:String):String
        {
            return (this.maxChars > 0) ? k.substr(0, this.maxChars) : k;
        }

        override public function setRectangle(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int)
        {
            if (((this._settingRectangle || (!this.multiline)) || (!this.wordWrap)))
            {
                super.setRectangle(k, _arg_2, _arg_3, _arg_4);
                return;
            }
            this._settingRectangle = true;
            var _local_5= this.autoSize;
            this.autoSize = TextFieldAutoSize.NONE;
            super.setRectangle(k, _arg_2, _arg_3, _arg_4);
            this.autoSize = _local_5;
            this._settingRectangle = false;
        }
public function  set_scrollH(k:Float):Float        {
            this._scrollH = k;
            this._field.scrollH = Std.int(this._scrollH * this._field.maxScrollH);
            this.refreshTextImage();
return k;
        }
public function  set_scrollV(k:Float):Float        {
            if (k > this._scrollV)
            {
                this._scrollV = k;
                this._field.scrollV = Std.int(Math.max(this._field.scrollV, ((k * this._field.maxScrollV) + 1)));
                this.refreshTextImage();
            }
            else
            {
                if (k < this._scrollV)
                {
                    this._scrollV = k;
                    this._field.scrollV = Std.int(Math.min(this._field.scrollV, ((k * this._field.maxScrollV) - 1)));
                    this.refreshTextImage();
                }
            }
return k;
        }

        public var visibleRegion(get,never):Rectangle;
public function  get_visibleRegion():Rectangle
        {
            return new Rectangle((this._scrollH * this.maxScrollH), (this._scrollV * this.maxScrollV), width, height);
        }

        public var scrollableRegion(get,never):Rectangle;
public function  get_scrollableRegion():Rectangle
        {
            return new Rectangle(0, 0, (this.maxScrollH + width), (this.maxScrollV + height));
        }

        
        public var scrollStepH(get,set):Float;
public function  get_scrollStepH():Float
        {
            return 10;
        }

        
        public var scrollStepV(get,set):Float;
public function  get_scrollStepV():Float
        {
            return this._field.textHeight / this._field.numLines;
        }
public function  set_scrollStepH(k:Float):Float        {
return k;
        }
public function  set_scrollStepV(k:Float):Float        {
return k;
        }

        function replaceNonRenderableCharacters(k:String):String
        {
            var _local_4:Font = null;
            var _local_5:Font = null;
            var _local_6:String = null;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_2= this._field.getTextFormat();
            if (((!(_local_2 != null)) || (!ASCompat.stringAsBool(_local_2.font))))
            {
                return k;
            }
            var _local_3= Font.enumerateFonts();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_5  = _tmp_;
                if (_local_5.fontName.toLowerCase() == _local_2.font.toLowerCase())
                {
                    _local_4 = _local_5;
                }
            }
            if (_local_4 == null)
            {
                return k;
            }
            if (com.sulake.core.window.text.TruffleText.fontHasGlyphs(_local_4, k))
            {
                return k;
            }
            _local_6 = "";
            _local_7 = 0;
            while (_local_7 < k.length)
            {
                _local_8 = k.charAt(_local_7);
                if ((((!com.sulake.core.window.text.TruffleText.fontHasGlyphs(_local_4, _local_8)) && (!(_local_8 == "\r"))) && (!(_local_8 == "\n"))))
                {
                    _local_6 = (_local_6 + REPLACE_RANDOM_CHARS[Std.int(Math.ffloor((Math.random() * REPLACE_RANDOM_CHARS.length)))]);
                }
                else
                {
                    _local_6 = (_local_6 + _local_8);
                }
                _local_7++;
            }
            return _local_6;
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
            if ((((!this._displayRaw) && (_caption.charAt(0) == "$")) && (_caption.charAt(1) == "{")))
            {
                this._localized = true;
                context.registerLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
            }
            else
            {
                if (this._field != null)
                {
                    this._field.text = this.replaceNonRenderableCharacters(_caption);
                    this.refreshTextImage();
                }
            }
return k;
        }

        override public function  set_caption(k:String):String        {
            return this.text = k;
        }

        override public function  set_color(k:UInt):UInt        {
            super.color = k;
            return this._field.backgroundColor = k;
        }

        override public function  set_background(k:Bool):Bool        {
            super.background = k;
            return this._field.background = k;
        }

        public var localization(never,set):String;
public function  set_localization(k:String):String        {
            if (((!(k == null)) && (!(this._field == null))))
            {
                this._field.text = this.limitStringLength(k);
                this.refreshTextImage();
            }
return k;
        }

        override public function clone():IWindow
        {
            var k= Std.downcast(super.clone() , TextController);
            k._field.backgroundColor = color;
            k._field.background = background;
            k._scrollH = this._scrollH;
            k._scrollV = this._scrollV;
            k._margins = this._margins.clone(k.setTextMargins);
            k._autoSize = this._autoSize;
            k._localized = this._localized;
            return k;
        }

        override public function dispose()
        {
            immediateClickMode = false;
            TextStyleManager.events.removeEventListener(Event.CHANGE, this.onTextStyleChanged);
            if (this._localized)
            {
                context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
            }
            if (this._margins != null)
            {
                this._margins.dispose();
                this._margins = null;
            }
            this._field = null;
            super.dispose();
        }

        override public function update(k:WindowController, _arg_2:WindowEvent):Bool
        {
            if (!this._drawing)
            {
                if (_arg_2.type == WindowEvent.WINDOW_EVENT_RESIZED)
                {
                    this.refreshTextImage(true);
                }
            }
            return super.update(k, _arg_2);
        }

        function refreshTextImage(k:Bool=false)
        {
            var _local_8 = 0;
            var _local_9:String = null;
            var _local_10:String = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15:TextFormat = null;
            var _local_16 = 0;
            var _local_17:WindowEvent = null;
            if (this._drawing)
            {
                return;
            }
            this._drawing = true;
            var _local_2= (this._margins.left + this._margins.right);
            var _local_3= (this._margins.top + this._margins.bottom);
            var _local_4= (_w - _local_2);
            var _local_5= (_h - _local_3);
            var _local_6= Std.int(Math.ffloor(this._field.width) + (this._field.border ? 1 : 0));
            var _local_7 = false;
            if (((this._autoSize == TextFieldAutoSize.NONE) && this.isOverflowReplaceOn))
            {
                _local_9 = this._field.text;
                if ((this._field.textHeight + _local_3) > _local_5)
                {
                    _local_11 = (this._field.numLines - 1);
                    while (((this._field.getCharBoundaries(this._field.getLineOffset(_local_11)) == null) || (this._field.getCharBoundaries(this._field.getLineOffset(_local_11)).bottom > _local_5)))
                    {
                        _local_11--;
                    }
                    _local_12 = this._field.getLineOffset(_local_11);
                    _local_13 = (_local_12 + this._field.getLineLength(_local_11));
                    _local_8 = _local_13;
                    while ((((this._field.textHeight + _local_3) > _local_5) && (_local_8 > 0)))
                    {
                        this._field.text = (_local_9.substring(0, --_local_8) + this.overflowReplace);
                    }
                }
                _local_10 = this._field.text;
                if ((this._field.textWidth + _local_2) > _local_4)
                {
                    _local_14 = (this._field.text.length - 1);
                    while (((this._field.getCharBoundaries(_local_14) == null) || (this._field.getCharBoundaries(_local_14).right > _local_4)))
                    {
                        _local_14--;
                    }
                    _local_15 = this.getTextFormat(0, _local_14);
                    _local_8 = _local_14;
                    _local_16 = (((_local_2 + ASCompat.toInt(_local_15.indent)) + ASCompat.toInt(_local_15.leftMargin)) + ASCompat.toInt(_local_15.rightMargin));
                    while (((((this._field.textWidth + _local_16) + 2) > _local_4) && (_local_8 > 0)))
                    {
                        this._field.text = (_local_10.substring(0, --_local_8) + this.overflowReplace);
                    }
                }
                _local_6 = Std.int(Math.ffloor(this._field.width) + (this._field.border ? 1 : 0));
            }
            if (_local_6 != _local_4)
            {
                if (this._autoSize == TextFieldAutoSize.LEFT)
                {
                    this.setRectangle(_x, _y, (_local_6 + _local_2), Std.int(Math.ffloor(this._field.height) + _local_3));
                    _local_7 = true;
                }
                else
                {
                    if (this._autoSize != TextFieldAutoSize.RIGHT)
                    {
                        if (this._autoSize != TextFieldAutoSize.CENTER)
                        {
                            this._field.width = (_local_4 - (this._field.border ? 1 : 0));
                            this._field.height = (_local_5 - (this._field.border ? 1 : 0));
                        }
                    }
                }
            }
            if ((this._field.height + (this._field.border ? 1 : 0)) < _local_5)
            {
                if (this._autoSize == TextFieldAutoSize.NONE)
                {
                    this._field.height = (_local_5 - (this._field.border ? 1 : 0));
                }
                else
                {
                    height = Std.int(Math.ffloor(this._field.height) + _local_3);
                    _local_7 = true;
                }
            }
            else
            {
                if ((this._field.height + (this._field.border ? 1 : 0)) > _local_5)
                {
                    if (this._autoSize != TextFieldAutoSize.NONE)
                    {
                        height = Std.int(Math.ffloor(this._field.height) + _local_3);
                        _local_7 = true;
                    }
                }
            }
            this._drawing = false;
            _context.invalidate(this, null, WindowRedrawFlag.REDRAW);
            if ((((!_local_7) && (!k)) && (_events != null)))
            {
                _local_17 = WindowEvent.allocate(WindowEvent.WINDOW_EVENT_RESIZED, this, null);
                _events.dispatchEvent(_local_17);
                _local_17.recycle();
            }
        }

        public function appendText(k:String)
        {
            this._field.appendText(k);
            this.refreshTextImage();
        }

        public function getCharBoundaries(k:Int):Rectangle
        {
            return this._field.getCharBoundaries(k);
        }

        public function getCharIndexAtPoint(k:Float, _arg_2:Float):Int
        {
            return this._field.getCharIndexAtPoint(k, _arg_2);
        }

        public function getFirstCharInParagraph(k:Int):Int
        {
            return this._field.getFirstCharInParagraph(k);
        }

        public function getImageReference(k:String):DisplayObject
        {
            return this._field.getImageReference(k);
        }

        public function getLineIndexAtPoint(k:Float, _arg_2:Float):Int
        {
            return this._field.getLineIndexAtPoint(k, _arg_2);
        }

        public function getLineIndexOfChar(k:Int):Int
        {
            return this._field.getLineIndexOfChar(k);
        }

        public function getLineLength(k:Int):Int
        {
            return this._field.getLineLength(k);
        }

        public function getLineMetrics(k:Int):TextLineMetrics
        {
            return this._field.getLineMetrics(k);
        }

        public function getLineOffset(k:Int):Int
        {
            return this._field.getLineOffset(k);
        }

        public function getLineText(k:Int):String
        {
            return this._field.getLineText(k);
        }

        public function getParagraphLength(k:Int):Int
        {
            return this._field.getParagraphLength(k);
        }

        public function getTextFormat(k:Int=-1, _arg_2:Int=-1):TextFormat
        {
            return this._field.getTextFormat(k, _arg_2);
        }

        public function replaceText(k:Int, _arg_2:Int, _arg_3:String)
        {
            this._field.replaceText(k, _arg_2, _arg_3);
            this.refreshTextImage();
        }

        public function setTextFormat(k:TextFormat, _arg_2:Int=-1, _arg_3:Int=-1)
        {
            if ((((_arg_2 >= 0) && (_arg_3 > _arg_2)) && (_arg_3 < this._field.length)))
            {
                this._field.setTextFormat(k, _arg_2, _arg_3);
                this.refreshTextImage();
            }
        }

        public function setTextMargins(k:IMargins)
        {
            if ((k : ASAny) != (this._margins : ASAny))
            {
                this._margins.dispose();
                this._margins = new TextMargins(k.left, k.top, k.right, k.bottom, this.setTextMargins);
            }
            if (this._autoSize == TextFieldAutoSize.LEFT)
            {
                this._field.width = ((_w - this._margins.left) - this._margins.right);
            }
            this.refreshTextImage();
        }

        function onTextStyleChanged(k:Event)
        {
            setTextFormatting(this);
            this.refreshTextImage();
        }

        function parseVariableSet(k:com.sulake.core.utils.xml.XML)
        {
var _local_2:String  = null;            var _local_2:String = null;
            var _local_3:ASFunction = null;
            var _local_4:Map = null;
            if (k != null)
            {
                _local_4 = new Map();
                XMLVariableParser.parseVariableList(k.children(), _local_4);
                this._drawing = true;
                if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4.getKeys())
                {
_local_2 = _tmp_;
                    _local_3 = _PROPERTY_SETTER_TABLE[_local_2];
                    if (_local_3 != null)
                    {
                        _local_3(this, _local_4.getValue(_local_2));
                    }
                }
                this._drawing = false;
            }
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:ASFunction = null;
            var _local_3:PropertyStruct = null;
            this._drawing = true;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_2 = _PROPERTY_SETTER_TABLE[_local_3.key];
                if (_local_2 != null)
                {
                    _local_2(this, _local_3.value);
                }
            }
            this._drawing = false;
            super.properties = k;
            this.refreshTextImage();
return k;
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= super.properties;
            var _local_2= TextStyleManager.getStyle(this._textStyleName);
            k.push(createProperty(PropertyKeys.ALWAYS_SHOW_SELECTION, this._field.alwaysShowSelection));
            k.push(new PropertyStruct(PropertyKeys.ANTIALIAS_TYPE, this._field.antiAliasType, PropertyStruct.STRING, (!(this._field.antiAliasType == _local_2.antiAliasType)), PropertyKeys.ANTIALIAS_TYPE_RANGE));
            k.push(createProperty(PropertyKeys.AUTO_SIZE, this._autoSize));
            k.push(createProperty(PropertyKeys.BORDER, this._field.border));
            k.push(createProperty(PropertyKeys.BORDER_COLOR, this._field.borderColor));
            k.push(new PropertyStruct(PropertyKeys.ETCHING_COLOR, this._etchingColor, PropertyStruct.HEX, (!(this._etchingColor == ASCompat.toUInt(_local_2.etchingColor)))));
            k.push(new PropertyStruct(PropertyKeys.ETCHING_POSITION, this._etchingPosition, PropertyStruct.STRING, (!(this._etchingPosition == ASCompat.toString(_local_2.etchingPosition))), PropertyKeys.ETCHING_POSITION_RANGE));
            k.push(createProperty(PropertyKeys.CONDENSE_WHITE, this._field.condenseWhite));
            k.push(new PropertyStruct(PropertyKeys.FONT_FACE, this.defaultTextFormat.font, PropertyStruct.STRING, (!(this.defaultTextFormat.font == _local_2.fontFamily))));
            k.push(new PropertyStruct(PropertyKeys.FONT_SIZE, this.defaultTextFormat.size, PropertyStruct.UINT, (!(this.defaultTextFormat.size == _local_2.fontSize))));
            k.push(createProperty(PropertyKeys.GRID_FIT_TYPE, this._field.gridFitType));
            var _local_3= ASCompat.toUInt(((_local_2.color != null) ? _local_2.color : getDefaultProperty(PropertyKeys.TEXT_COLOR).value));
            k.push(new PropertyStruct(PropertyKeys.TEXT_COLOR, this._field.textColor, PropertyStruct.HEX, (!(this._field.textColor == _local_3))));
            k.push(createProperty(PropertyKeys.TEXT_STYLE, this._textStyleName));
            k.push(createProperty(PropertyKeys.MARGIN_LEFT, this._margins.left));
            k.push(createProperty(PropertyKeys.MARGIN_TOP, this._margins.top));
            k.push(createProperty(PropertyKeys.MARGIN_RIGHT, this._margins.right));
            k.push(createProperty(PropertyKeys.MARGIN_BOTTOM, this._margins.bottom));
            k.push(createProperty(PropertyKeys.MOUSE_WHEEL_ENABLED, this._field.mouseWheelEnabled));
            k.push(createProperty(PropertyKeys.MAX_CHARS, this._field.maxChars));
            k.push(createProperty(PropertyKeys.MULTILINE, this._field.multiline));
            k.push(createProperty(PropertyKeys.RESTRICT, this._field.restrict));
            k.push(new PropertyStruct(PropertyKeys.SHARPNESS, this._field.sharpness, PropertyStruct.NUMBER, (!(this._field.sharpness == _local_2.sharpness))));
            k.push(new PropertyStruct(PropertyKeys.THICKNESS, this._field.thickness, PropertyStruct.NUMBER, (!(this._field.thickness == _local_2.thickness))));
            k.push(createProperty(PropertyKeys.WORD_WRAP, this._field.wordWrap));
            k.push(createProperty(PropertyKeys.MAX_LINES, this.maxLines));
            k.push(createProperty(PropertyKeys.OVERFLOW_REPLACE, this.overflowReplace));
            k.push(new PropertyStruct(PropertyKeys.BOLD, (!(this._field.defaultTextFormat.bold == false)), PropertyStruct.BOOLEAN, (!(this._field.defaultTextFormat.bold == (_local_2.fontWeight == FontStyle.BOLD)))));
            k.push(new PropertyStruct(PropertyKeys.ITALIC, (!(this._field.defaultTextFormat.italic == false)), PropertyStruct.BOOLEAN, (!(this._field.defaultTextFormat.italic == (_local_2.fontStyle == FontStyle.ITALIC)))));
            k.push(new PropertyStruct(PropertyKeys.UNDERLINE, (!(this._field.defaultTextFormat.underline == false)), PropertyStruct.BOOLEAN, (!(this._field.defaultTextFormat.underline == (_local_2.textDecoration == "underline")))));
            k.push(new PropertyStruct(PropertyKeys.KERNING, (!(this._field.defaultTextFormat.kerning == false)), PropertyStruct.BOOLEAN, (!(this._field.defaultTextFormat.kerning == _local_2.kerning))));
            k.push(new PropertyStruct(PropertyKeys.SPACING, this._field.defaultTextFormat.letterSpacing, PropertyStruct.NUMBER, (!(this._field.defaultTextFormat.letterSpacing == _local_2.letterSpacing))));
            k.push(new PropertyStruct(PropertyKeys.LEADING, this._field.defaultTextFormat.leading, PropertyStruct.NUMBER, (!(this._field.defaultTextFormat.leading == _local_2.leading))));
            return k;
        }

        
        public var etchingColor(get,set):UInt;
public function  get_etchingColor():UInt
        {
            return this._etchingColor;
        }
public function  set_etchingColor(k:UInt):UInt        {
            setEtchingColor(this, k);
return k;
        }

        public var styleSheet(never,set):StyleSheet;
public function  set_styleSheet(k:StyleSheet):StyleSheet        {
            this.setStyleSheet(this, k);
return k;
        }

        function setStyleSheet(k:TextController, _arg_2:StyleSheet)
        {
            k._field.styleSheet = _arg_2;
            this.refreshTextImage();
        }

        
        public var etchingPosition(get,set):String;
public function  get_etchingPosition():String
        {
            return this._etchingPosition;
        }
public function  set_etchingPosition(k:String):String        {
            setEtchingPosition(this, k);
return k;
        }

        public function resetExplicitStyle()
        {
            this._explicitStyle = new TextStyle();
        }
    }

