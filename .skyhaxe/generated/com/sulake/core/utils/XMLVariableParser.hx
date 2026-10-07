package com.sulake.core.utils
;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class XMLVariableParser 
    {
        public static inline final HEX= "hex";
        public static inline final INT= "int";
        public static inline final UINT= "uint";
        public static inline final NUMBER= "Number";
        public static inline final FLOAT= "float";
        public static inline final BOOLEAN= "Boolean";
        public static inline final BOOL= "bool";
        public static inline final STRING= "String";
        public static inline final POINT= "Point";
        public static inline final RECTANGLE= "Rectangle";
        public static inline final ARRAY= "Array";
        public static inline final MAP= "Map";
        static inline final KEY= "key";
        static inline final TYPE= "type";
        static inline final VALUE= "value";
        static inline final TRUE= "true";
        static inline final FALSE= "false";
        static inline final X= "x";
        static inline final Y= "y";
        static inline final WIDTH= "width";
        static inline final HEIGHT= "height";
        static inline final COMMA= ",";


        public static function parseVariableList(k:com.sulake.core.utils.xml.XMLList, _arg_2:Map, _arg_3:Array<ASAny>=null):UInt
        {
            var _local_5:UInt = 0;
            var _local_4:UInt = k.length();
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                XMLVariableParser.parseVariableToken(k.at(_local_5), _arg_2, _arg_3);
                _local_5++;
            }
            return _local_4;
        }

        static function parseVariableToken(k:com.sulake.core.utils.xml.XML, _arg_2:Map, _arg_3:Array<ASAny>=null)
        {
            var _local_4:String = null;
            var _local_6:String = null;
            var _local_7:com.sulake.core.utils.xml.XMLList = null;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_5= STRING;
            _local_7 = k.attribute(KEY);
            if (_local_7.length() > 0)
            {
                _local_4 = k.attribute(KEY).toString();
            }
            else
            {
                _local_4 = ASCompat.xmlToString(k.child(KEY).at(0));
            }
            _local_7 = k.attribute(TYPE);
            if (_local_7.length() > 0)
            {
                _local_5 = k.attribute(TYPE).toString();
            }
            _local_7 = k.attribute(VALUE);
            if (_local_7.length() > 0)
            {
                _local_6 = k.attribute(VALUE).toString();
            }
            if (_local_6 != null)
            {
                _arg_2.setProperty(_local_4, XMLVariableParser.castStringToType(_local_6, _local_5));
            }
            else
            {
                _local_8 = k.child(VALUE).at(0);
                if (_local_8 != null)
                {
                    _local_9 = _local_8.child(0).at(0);
                    _local_6 = ASCompat.xmlToString(_local_9.children().at(0));
                    _local_5 = _local_9.localName();
                    _arg_2.setProperty(_local_4, XMLVariableParser.parseValueType(_local_9, _local_5));
                }
                else
                {
                    if (((_local_5 == MAP) || (_local_5 == ARRAY)))
                    {
                        _arg_2.setProperty(_local_4, XMLVariableParser.parseValueType(k, _local_5));
                    }
                }
            }
            if (_arg_3 != null)
            {
                _arg_3.push(_local_5);
            }
        }

        public static function castStringToType(value:String, type:String):ASObject
        {
            switch (type)
            {
                case UINT:
                    return ASCompat.toUInt(value);
                case INT:
                    return ASCompat.toInt(value);
                case NUMBER:
                    return ASCompat.toNumber(value);
                case FLOAT:
                    return ASCompat.toNumber(value);
                case BOOLEAN:
                    return (value == TRUE) || (ASCompat.toInt(value) > 0);
                case BOOL:
                    return (value == TRUE) || (ASCompat.toInt(value) > 0);
                case HEX:
                    return ASCompat.toUInt(value);
                case ARRAY:
                    return value.split(COMMA);
                default:
                    return value;
            }
        }

        public static function parseValueType(xml:com.sulake.core.utils.xml.XML, type:String):ASObject
        {
var point:Point  = null, rect:Rectangle  = null, variableList:Map  = null, list:Array<ASAny>  = null, key:String  = null, map:Map  = null;            switch (type)
            {
                case STRING:
                    return xml.toString();
                case POINT:
point= new Point();
                    point.x = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(X)));
                    point.y = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(Y)));
                    return point;
                case RECTANGLE:
rect= new Rectangle();
                    rect.x = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(X)));
                    rect.y = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(Y)));
                    rect.width = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(WIDTH)));
                    rect.height = ASCompat.toNumber(ASCompat.xmlListToString(xml.attribute(HEIGHT)));
                    return rect;
                case ARRAY:
variableList= new Map();
                    parseVariableList(xml.children(), variableList);
list= new Array<ASAny>();
                    if (checkNullIteratee(variableList)) for (_tmp_ in variableList.getKeys())
                    {
key = _tmp_;
                        list.push(variableList.getValue(key));
                    }
                    return list;
                case MAP:
map= new Map();
                    XMLVariableParser.parseVariableList(xml.children(), map);
                    return map;
            }
            throw new ASError((('Unable to parse data type "' + type) + '", unknown type!'));
        }

	public function new() {}
    }

