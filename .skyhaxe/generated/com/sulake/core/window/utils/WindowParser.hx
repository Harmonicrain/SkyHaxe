package com.sulake.core.window.utils
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindowContext;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.utils.XMLVariableParser;
    import com.sulake.core.window.WindowController;
    import flash.geom.Rectangle;
    import flash.filters.BitmapFilter;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.core.window.components.IBoxSizerWindow;
    import flash.filters.DropShadowFilter;
    import flash.utils.*;

     class WindowParser implements IWindowParser 
    {
        public static inline final _EXCLUDE= "_EXCLUDE";
        public static inline final _INCLUDE= "_INCLUDE";
        public static inline final _TEMP= "_TEMP";
        static inline final LAYOUT= "layout";
        static inline final WINDOW= "window";
        static inline final VARIABLES= "variables";
        static inline final FILTERS= "filters";
        static inline final NAME= "name";
        static inline final STYLE= "style";
        static inline final DYNAMIC_STYLE= "dynamic_style";
        static inline final PARAMS= "params";
        static inline final TAGS= "tags";
        static inline final X= "x";
        static inline final Y= "y";
        static inline final WIDTH= "width";
        static inline final HEIGHT= "height";
        static inline final VISIBLE= "visible";
        static inline final CAPTION= "caption";
        static inline final ID= "id";
        static inline final BACKGROUND= "background";
        static inline final BLEND= "blend";
        static inline final CLIPPING= "clipping";
        static inline final COLOR= "color";
        static inline final TRESHOLD= "treshold";
        static inline final CHILDREN= "children";
        static inline final WIDTH_MIN= "width_min";
        static inline final WIDTH_MAX= "width_max";
        static inline final HEIGHT_MIN= "height_min";
        static inline final HEIGHT_MAX= "height_max";
        static inline final TRUE= "true";
        static inline final _Str_3625= "0";
        static inline final _Str_17504= "$";
        static inline final COMMA= ",";
        static inline final EMPTY= "";
        static final _Str_18567:compat.RegExp = new compat.RegExp("^(\\s|\\n|\\r|\\t|\\x0B)*", "m");
        static final _Str_16066:compat.RegExp = new compat.RegExp("(\\s|\\n|\\r|\\t|\\x0B)*$");

        var _typeStringToCodeTable:ASDictionary<ASAny,ASAny>;
        var _typeCodeToStringTable:ASDictionary<ASAny,ASAny>;
        var _paramStringToCodeTable:ASDictionary<ASAny,ASAny>;
        var _paramCoreToStringTable:ASDictionary<ASAny,ASAny>;
        var _parsedLayoutCache:Map;
        var _context:IWindowContext;
        var _disposed:Bool = false;

        public function new(context:IWindowContext)
        {
            this._context = context;
            this._typeStringToCodeTable = new ASDictionary<ASAny,ASAny>();
            this._typeCodeToStringTable = new ASDictionary<ASAny,ASAny>();
            TypeCodeTable.fillTables(this._typeStringToCodeTable, this._typeCodeToStringTable);
            this._paramStringToCodeTable = new ASDictionary<ASAny,ASAny>();
            this._paramCoreToStringTable = new ASDictionary<ASAny,ASAny>();
            ParamCodeTable._Str_8871(this._paramStringToCodeTable, this._paramCoreToStringTable);
            this._parsedLayoutCache = new Map();
        }

        static function filterToXmlString(k:String):String
        {
            k = _Str_16066.replace(k, EMPTY);
            k = _Str_18567.replace(k, EMPTY);
            return k;
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
var key:ASObject  = null;            var key:ASObject = null;
            if (!this._disposed)
            {
                final _iter_ = this._typeStringToCodeTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    this._typeStringToCodeTable.remove(key);
                }
                final _iter_ = this._typeCodeToStringTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    this._typeCodeToStringTable.remove(key);
                }
                final _iter_ = this._paramStringToCodeTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    this._paramStringToCodeTable.remove(key);
                }
                final _iter_ = this._paramCoreToStringTable; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
key = _tmp_;
                    this._paramCoreToStringTable.remove(key);
                }
                this._parsedLayoutCache.dispose();
                this._parsedLayoutCache = null;
                this._context = null;
                this._disposed = true;
            }
        }

        public function parseAndConstruct(xml:com.sulake.core.utils.xml.XML, window:IWindow, variableList:Map):IWindow
        {
var variables:com.sulake.core.utils.xml.XMLList  = null, firstVariable:com.sulake.core.utils.xml.XML  = null, childVariables:com.sulake.core.utils.xml.XMLList  = null, filters:com.sulake.core.utils.xml.XMLList  = null, windowFilters:Array<ASAny>  = null,                     i:UInt  = 0;            var children:com.sulake.core.utils.xml.XMLList = null;
			var i:UInt = 0;
			var singleWindowEntity:IWindow = null;
            if (xml.localName() == LAYOUT)
            {
variables= xml.child(VARIABLES);
                if (variables.length() > 0)
                {
firstVariable= variables.at(0);
childVariables= new com.sulake.core.utils.xml.XML(firstVariable.at(0)).children();
                    if (childVariables.length() > 0)
                    {
                        if (variableList == null)
                        {
                            variableList = new Map();
                        }
                        XMLVariableParser.parseVariableList(childVariables, variableList);
                    }
                }
filters= xml.child(FILTERS).children();
                if (filters.length() > 0)
                {
windowFilters= new Array<ASAny>();
                    i= 0;while (i < (filters.length() : UInt))
                    {
                        windowFilters.push(this._Str_20744(filters.at(i)));
i++ ;
                    }
                    window.filters = windowFilters;
                }
                children = xml.child(WINDOW);
                switch (children.length())
                {
                    case 0:
                        return null;
                    case 1:
                        xml = children.at(0);
                        
                    default:
                        i= 0;while (i < (children.length() : UInt))
                        {
                            singleWindowEntity = this.parseSingleWindowEntity(children.at(i), cast(window, WindowController), variableList);
i++;
                        }
                        return singleWindowEntity;
                }
            }
            if (xml.localName() == WINDOW)
            {
                children = xml.children();
                if (children.length() > 1)
                {
                    i= 0;while (i < (children.length() : UInt))
                    {
                        singleWindowEntity = this.parseSingleWindowEntity(children.at(i), cast(window, WindowController), variableList);
i++;
                    }
                    return singleWindowEntity;
                }
                xml = xml.children().at(0);
            }
            return (xml != null) ? this.parseSingleWindowEntity(xml, cast(window, WindowController), variableList) : null;
        }

        function parseSingleWindowEntity(xml:com.sulake.core.utils.xml.XML, window:WindowController, variableList:Map):IWindow
        {
            var _local_4:WindowController = null;
            var _local_19:com.sulake.core.utils.xml.XML = null;
            var _local_20:com.sulake.core.utils.xml.XMLList = null;
            var _local_21:UInt = 0;
            var _local_23:UInt = 0;
            var _local_24:Array<ASAny> = null;
            var _local_26:String = null;
            var _local_27:Array<ASAny> = null;
            var _local_28:BitmapFilter = null;
            var _local_29:IIterator = null;
            var _local_7= EMPTY;
            var _local_9= true;
            var _local_10= "0x00ffffff";
            var _local_11:Float = 1;
            var _local_12 = false;
            var _local_13:UInt = 10;
			
            var typeCode= ASCompat.toUInt(this._typeStringToCodeTable[xml.localName()]);
            var unescapedXml= ASCompat.unescape(ASCompat.toString(this.parseAttribute(xml, NAME, variableList, "")));
			var windowStyle= ASCompat.toUInt((window != null) ? window.style : 0);
            windowStyle = ASCompat.toUInt(this.parseAttribute(xml, STYLE, variableList, windowStyle));
            var dynamicStyle= ASCompat.toString(this.parseAttribute(xml, DYNAMIC_STYLE, variableList, ""));
            var _local_16= ASCompat.toUInt(this.parseAttribute(xml, PARAMS, variableList, 0));
            var _local_18= ASCompat.unescape(ASCompat.toString(this.parseAttribute(xml, TAGS, variableList, EMPTY)));
            var _local_17= new Rectangle();
            _local_17.x = ASCompat.toNumber(this.parseAttribute(xml, X, variableList, _Str_3625));
            _local_17.y = ASCompat.toNumber(this.parseAttribute(xml, Y, variableList, _Str_3625));
            _local_17.width = ASCompat.toNumber(this.parseAttribute(xml, WIDTH, variableList, _Str_3625));
            _local_17.height = ASCompat.toNumber(this.parseAttribute(xml, HEIGHT, variableList, _Str_3625));
            var _local_8= (this.parseAttribute(xml, VISIBLE, variableList, "true") == TRUE);
            var _local_22= ASCompat.toInt(this.parseAttribute(xml, ID, variableList, "0"));
            if (xml.child(PARAMS).length() > 0)
            {
                _local_20 = xml.child(PARAMS).children();
                _local_21 = _local_20.length();
                _local_23 = 0;
                while (_local_23 < _local_21)
                {
                    _local_19 = _local_20.at(_local_23);
                    _local_26 = ASCompat.asString(this.parseAttribute(_local_19, NAME, variableList, "") );
                    if (this._paramStringToCodeTable[_local_26] != null)
                    {
                        _local_16 = (ASCompat.toInt(_local_16 )| ASCompat.toInt(this._paramStringToCodeTable[_local_26]));
                    }
                    else
                    {
                        throw new ASError((('Unknown window parameter "' + _local_19.attribute(NAME).toString()) + '"!'));
                    }
                    _local_23++;
                }
            }
            _local_7 = (((ASCompat.toInt(_local_16 )& ASCompat.toInt(WindowParam.WINDOW_PARAM_INHERIT_CAPTION)) != 0) ? ((window != null) ? window.caption : EMPTY) : EMPTY);
            _local_7 = ASCompat.unescape(ASCompat.toString(this.parseAttribute(xml, CAPTION, variableList, _local_7)));
            if (_local_18 != EMPTY)
            {
                _local_24 = (cast _local_18.split(COMMA));
                _local_21 = _local_24.length;
                _local_23 = 0;
                while (_local_23 < _local_21)
                {
                    _local_24[ASCompat.toInt(_local_23)] = WindowParser.filterToXmlString(_local_24[ASCompat.toInt(_local_23)]);
                    _local_23++;
                }
            }
            _local_4 = Std.downcast(this._context.create(unescapedXml, null, typeCode, windowStyle, _local_16, _local_17, null, (Std.is(window , IIterable) ? null : window), _local_22, this.parseProperties(xml.child(VARIABLES).at(0)), dynamicStyle, _local_24) , WindowController);
            if (this.hasAttribute(xml, WIDTH_MIN))
            {
                _local_4.limits.minWidth = ASCompat.toInt(this.parseAttribute(xml, WIDTH_MIN, variableList, _local_4.limits.minWidth));
            }
            if (this.hasAttribute(xml, WIDTH_MAX))
            {
                _local_4.limits.maxWidth = ASCompat.toInt(this.parseAttribute(xml, WIDTH_MAX, variableList, _local_4.limits.maxWidth));
            }
            if (this.hasAttribute(xml, HEIGHT_MIN))
            {
                _local_4.limits.minHeight = ASCompat.toInt(this.parseAttribute(xml, HEIGHT_MIN, variableList, _local_4.limits.minHeight));
            }
            if (this.hasAttribute(xml, HEIGHT_MAX))
            {
                _local_4.limits.maxHeight = ASCompat.toInt(this.parseAttribute(xml, HEIGHT_MAX, variableList, _local_4.limits.maxHeight));
            }
            _local_4.limits.limit();
            _local_12 = (this.parseAttribute(xml, BACKGROUND, variableList, Std.string(_local_4.background)) == TRUE);
            _local_11 = ASCompat.toNumber(this.parseAttribute(xml, BLEND, variableList, Std.string(_local_4.blend)));
            _local_9 = (this.parseAttribute(xml, CLIPPING, variableList, Std.string(_local_4.clipping)) == TRUE);
            _local_10 = ASCompat.toString(this.parseAttribute(xml, COLOR, variableList, Std.string(_local_4.color)));
            _local_13 = ASCompat.toUInt(this.parseAttribute(xml, TRESHOLD, variableList, Std.string(_local_4.mouseThreshold)));
            if (_local_4.caption != _local_7)
            {
                _local_4.caption = _local_7;
            }
            if (_local_4.blend != _local_11)
            {
                _local_4.blend = _local_11;
            }
            if (_local_4.visible != _local_8)
            {
                _local_4.visible = _local_8;
            }
            if (_local_4.clipping != _local_9)
            {
                _local_4.clipping = _local_9;
            }
            if (_local_4.background != _local_12)
            {
                _local_4.background = _local_12;
            }
            if (_local_4.mouseThreshold != _local_13)
            {
                _local_4.mouseThreshold = _local_13;
            }
            var _local_25= ASCompat.toUInt((_local_10.charAt(1) == X) ? ASCompat.parseInt(_local_10, 16) : ASCompat.toUInt(_local_10));
            if (_local_4.color != _local_25)
            {
                _local_4.color = _local_25;
            }
            _local_20 = xml.child(FILTERS).children();
            _local_21 = _local_20.length();
            if (_local_21 > 0)
            {
                _local_27 = new Array<ASAny>();
                _local_23 = 0;
                while (_local_23 < _local_21)
                {
                    _local_28 = this._Str_20744(_local_20.at(_local_23)) ;
                    if (_local_28 != null)
                    {
                        _local_27.push(_local_28);
                    }
                    _local_23++;
                }
                _local_4.filters = _local_27;
            }
            if (_local_4 != null)
            {
                if (window != null)
                {
                    if (Std.is(window , IIterable))
                    {
                        if (((((!(_local_4.x == _local_17.x)) || (!(_local_4.y == _local_17.y))) || (!(_local_4.width == _local_17.width))) || (!(_local_4.height == _local_17.height))))
                        {
                            if (((ASCompat.toInt(_local_16 )& ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER)) : UInt) == WindowParam.WINDOW_PARAM_RELATIVE_HORIZONTAL_SCALE_CENTER)
                            {
                                _local_4.x = Std.int(_local_17.x);
                            }
                            if (((ASCompat.toInt(_local_16 )& ASCompat.toInt(WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)) : UInt) == WindowParam.WINDOW_PARAM_RELATIVE_VERTICAL_SCALE_CENTER)
                            {
                                _local_4.y = Std.int(_local_17.y);
                            }
                        }
                        try
                        {
                            _local_29 = cast(window, IIterable).iterator;
                        }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                         {
                        }
 }                        if (_local_29 != null)
                        {
com.sulake.core.utils.ASProxy.set(                            _local_29, _local_29.length, _local_4);
                        }
                        else
                        {
                            window.addChild(_local_4);
                        }
                    }
                }
            }
            _local_20 = xml.child(CHILDREN);
            if (_local_20.length() > 0)
            {
                _local_19 = _local_20.at(0);
                _local_20 = _local_19.children();
                _local_21 = _local_20.length();
                if (Std.is(_local_4 , IBoxSizerWindow))
                {
                    cast(_local_4, IBoxSizerWindow).setAutoRearrange(false);
                }
                _local_23 = 0;
                while (_local_23 < _local_21)
                {
                    this.parseAndConstruct(_local_20.at(_local_23), _local_4, variableList);
                    _local_23++;
                }
            }
            if (Std.is(_local_4 , IBoxSizerWindow))
            {
                cast(_local_4, IBoxSizerWindow).setAutoRearrange(true);
            }
            return _local_4;
        }

        function hasAttribute(xml:com.sulake.core.utils.xml.XML, attribute:String):Bool
        {
            return xml.attribute(attribute).length() > 0;
        }

        function parseAttribute(k:com.sulake.core.utils.xml.XML, _arg_2:String, _arg_3:Map, _arg_4:ASObject):ASObject
        {
            var _local_5= k.attribute(_arg_2);
            if (_local_5.length() == 0)
            {
                return _arg_4;
            }
            var _local_6= _local_5.toString();
            if (_arg_3 != null)
            {
                if (_local_6.charAt(0) == _Str_17504)
                {
                    _local_6 = _arg_3.getValue(_local_6.substring(1, _local_6.length));
                    if (_local_6 == null)
                    {
                        throw new ASError((('Shared variable not defined: "' + ASCompat.xmlListToString(k.attribute(_arg_2))) + '"!'));
                    }
                }
            }
            return _local_6;
        }

        function parseProperties(k:com.sulake.core.utils.xml.XML):Array<ASAny>
        {
            return (k != null) ? XMLPropertyArrayParser.parse(k.children()) : new Array<ASAny>();
        }

        public function windowToXMLString(k:IWindow):String
        {
            var _local_8:IIterator = null;
            var _local_10:IWindow = null;
            var _local_12:UInt = 0;
            var _local_14:PropertyStruct = null;
            var _local_15:BitmapFilter = null;
            var _local_16:String = null;
            var _local_17 = false;
            if (k.dynamicStyle.length < 3)
            {
                k.dynamicStyle = "";
            }
            if (k.dynamicStyle != "")
            {
                k.setParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT, false);
            }
            var _local_2= EMPTY;
            var _local_3:String = this._typeCodeToStringTable[k.type];
            var _local_4= k.param;
            var _local_5= k.style;
            var _local_6= k.limits;
            var _local_7= Std.downcast(k , WindowController);
            _local_2 = (_local_2 + ((((((((((((((((((((((((((((((((((("<" + _local_3) + ' x="') + Std.string(k.x)) + '"') + ' y="') + Std.string(k.y)) + '"') + ' width="') + Std.string(k.width)) + '"') + ' height="') + Std.string(k.height)) + '"') + ' params="') + Std.string(k.param)) + '"') + ' style="') + Std.string(k.style)) + '"') + ((k.dynamicStyle != EMPTY) ? ((' dynamic_style="' + k.dynamicStyle) + '"') : EMPTY)) + ((k.name != EMPTY) ? ((' name="' + ASCompat.escape(k.name)) + '"') : EMPTY)) + ((k.caption != EMPTY) ? ((' caption="' + ASCompat.escape(k.caption)) + '"') : EMPTY)) + ((k.id != 0) ? ((' id="' + Std.string(k.id)) + '"') : EMPTY)) + ((k.color != 0xFFFFFF) ? ((((' color="' + "0x") + ASCompat.toRadix(k.alpha, 16)) + ASCompat.toRadix(k.color, 16)) + '"') : EMPTY)) + ((k.blend != 1) ? ((' blend="' + Std.string(k.blend)) + '"') : EMPTY)) + ((k.visible != true) ? ((' visible="' + Std.string(k.visible)) + '"') : EMPTY)) + ((k.clipping != true) ? ((' clipping="' + Std.string(k.clipping)) + '"') : EMPTY)) + ((k.background != false) ? ((' background="' + Std.string(k.background)) + '"') : EMPTY)) + ((k.mouseThreshold != 10) ? ((' treshold="' + Std.string(k.mouseThreshold)) + '"') : EMPTY)) + ((k.tags.length > 0) ? ((' tags="' + ASCompat.escape(k.tags.toString())) + '"') : EMPTY)) + ((_local_6.minWidth > ASCompat.MIN_INT) ? ((' width_min="' + Std.string(_local_6.minWidth)) + '"') : EMPTY)) + ((_local_6.maxWidth < ASCompat.MAX_INT) ? ((' width_max="' + Std.string(_local_6.maxWidth)) + '"') : EMPTY)) + ((_local_6.minHeight > ASCompat.MIN_INT) ? ((' height_min="' + Std.string(_local_6.minHeight)) + '"') : EMPTY)) + ((_local_6.maxHeight < ASCompat.MAX_INT) ? ((' height_max="' + Std.string(_local_6.maxHeight)) + '"') : EMPTY)) + ">\r"));
            if (((k.filters != null) && (k.filters.length > 0)))
            {
                _local_2 = (_local_2 + "\t<filters>\r");
                final _iter_ = k.filters; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_15  = _tmp_;
                    _local_2 = (_local_2 + (("\t\t" + this.buildBitmapFilter(_local_15)) + "\r"));
                }
                _local_2 = (_local_2 + "\t</filters>\r");
            }
            var _local_9:UInt = _local_7.numChildren;
            var _local_11= EMPTY;
            if (Std.is(_local_7 , IIterable))
            {
                _local_8 = cast(_local_7, IIterable).iterator;
                _local_9 = _local_8.length;
                if (_local_9 > 0)
                {
                    _local_12 = 0;
                    while (_local_12 < _local_9)
                    {
                        _local_10 = ASCompat.dynamicAs(com.sulake.core.utils.ASProxy.get(_local_8, _local_12), IWindow);
                        if (_local_10.tags.indexOf(WindowParser._EXCLUDE) == -1)
                        {
                            _local_11 = (_local_11 + this.windowToXMLString(_local_10));
                        }
                        _local_12++;
                    }
                }
            }
            else
            {
                _local_9 = _local_7.numChildren;
                if (_local_9 > 0)
                {
                    _local_12 = 0;
                    while (_local_12 < _local_9)
                    {
                        _local_10 = _local_7.getChildAt(ASCompat.toInt(_local_12));
                        if (_local_10.tags.indexOf(WindowParser._EXCLUDE) == -1)
                        {
                            _local_11 = (_local_11 + this.windowToXMLString(_local_10));
                        }
                        _local_12++;
                    }
                }
            }
            if (_local_11.length > 0)
            {
                _local_2 = (_local_2 + (("\t<children>\r" + _local_11) + "\t</children>\r"));
            }
            var _local_13= k.properties;
            if (((!(_local_13 == null)) && (_local_13.length > 0)))
            {
                _local_16 = "\t<variables>\r";
                _local_17 = false;
                _local_12 = 0;
                while (_local_12 < (_local_13.length : UInt))
                {
                    _local_14 = ASCompat.dynamicAs(_local_13[ASCompat.toInt(_local_12)] , PropertyStruct);
                    if (_local_14.valid)
                    {
                        _local_16 = (_local_16 + (("\t\t" + _local_14.toXMLString()) + "\r"));
                        _local_17 = true;
                    }
                    _local_12++;
                }
                _local_16 = (_local_16 + "\t</variables>\r");
                if (_local_17)
                {
                    _local_2 = (_local_2 + _local_16);
                }
            }
            _local_2 = (_local_2 + (("</" + _local_3) + ">\r"));
            return _local_2;
        }

        function _Str_20744(k:com.sulake.core.utils.xml.XML):BitmapFilter
        {
            var _local_3:BitmapFilter = null;
            var _local_2= ASCompat.asString(k.localName() );
            switch (_local_2)
            {
                case "DropShadowFilter":
                    _local_3 = new DropShadowFilter(ASCompat.toNumber(this.parseAttribute(k, "distance", null, "0")), ASCompat.toNumber(this.parseAttribute(k, "angle", null, "45")), ASCompat.toUInt(this.parseAttribute(k, "color", null, "0")), ASCompat.toNumber(this.parseAttribute(k, "alpha", null, "1")), ASCompat.toNumber(this.parseAttribute(k, "blurX", null, "0")), ASCompat.toNumber(this.parseAttribute(k, "blurY", null, "0")), ASCompat.toNumber(this.parseAttribute(k, "strength", null, "1")), ASCompat.toInt(this.parseAttribute(k, "quality", null, "1")), (this.parseAttribute(k, "inner", null, "false") == "true"), (this.parseAttribute(k, "knockout", null, "false") == "true"), (this.parseAttribute(k, "hideObject", null, "false") == "true"));
                    
            }
            return _local_3;
        }

        function buildBitmapFilter(k:BitmapFilter):String
        {
            var _local_2:String = null;
            if (Std.is(k , DropShadowFilter))
            {
                _local_2 = "<DropShadowFilter";
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).distance != 0) ? ((' distance="' + Std.string(cast(k, DropShadowFilter).distance)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).angle != 45) ? ((' angle="' + Std.string(cast(k, DropShadowFilter).angle)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).color != 0) ? ((' color="' + Std.string(cast(k, DropShadowFilter).color)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).alpha != 1) ? ((' alpha="' + Std.string(cast(k, DropShadowFilter).alpha)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).blurX != 0) ? ((' blurX="' + Std.string(cast(k, DropShadowFilter).blurX)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).blurY != 0) ? ((' blurY="' + Std.string(cast(k, DropShadowFilter).blurY)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).strength != 1) ? ((' strength="' + Std.string(cast(k, DropShadowFilter).strength)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).quality != 1) ? ((' quality="' + Std.string(cast(k, DropShadowFilter).quality)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).inner != false) ? ((' inner="' + Std.string(cast(k, DropShadowFilter).inner)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).knockout != false) ? ((' knockout="' + Std.string(cast(k, DropShadowFilter).knockout)) + '"') : ""));
                _local_2 = (_local_2 + ((cast(k, DropShadowFilter).hideObject != false) ? ((' hideObject="' + Std.string(cast(k, DropShadowFilter).hideObject)) + '"') : ""));
                _local_2 = (_local_2 + " />");
            }
            return _local_2;
        }
    }

