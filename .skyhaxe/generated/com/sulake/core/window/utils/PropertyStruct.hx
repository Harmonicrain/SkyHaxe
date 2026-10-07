package com.sulake.core.window.utils
;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.sulake.core.utils.Map;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class PropertyStruct 
    {
        public static inline final HEX= "hex";
        public static inline final INT= "int";
        public static inline final UINT= "uint";
        public static inline final NUMBER= "Number";
        public static inline final BOOLEAN= "Boolean";
        public static inline final STRING= "String";
        public static inline final POINT= "Point";
        public static inline final RECTANGLE= "Rectangle";
        public static inline final ARRAY= "Array";
        public static inline final MAP= "Map";

        var _key:String;
        var _value:ASObject;
        var _type:String;
        var _valid:Bool = false;
        var _complex:Bool = false;
        var _range:Array<ASAny>;

        public function new(key:String, value:ASObject, type:String, valid:Bool=false, range:Array<ASAny>=null)
        {
            this._key = key;
            this._value = value;
            this._type = type;
            this._valid = valid;
            this._complex = ((((type == MAP) || (type == ARRAY)) || (type == POINT)) || (type == RECTANGLE));
            this._range = range;
        }

        public var key(get,never):String;
public function  get_key():String
        {
            return this._key;
        }

        public var value(get,never):ASObject;
public function  get_value():ASObject
        {
            return this._value;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var valid(get,never):Bool;
public function  get_valid():Bool
        {
            return this._valid;
        }

        public var range(get,never):Array<ASAny>;
public function  get_range():Array<ASAny>
        {
            return this._range;
        }

        public function withNameSpace(k:String):PropertyStruct
        {
            return new PropertyStruct(((k + ":") + this._key), this._value, this._type, this._valid, this._range);
        }

        public function withoutNameSpace():PropertyStruct
        {
            return new PropertyStruct(new compat.RegExp(".*:").replace(this._key, ""), this._value, this._type, this._valid, this._range);
        }

        public function withValue(k:ASObject):PropertyStruct
        {
            var _local_3:Array<ASAny> = null;
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_2= true;
            switch (this._type)
            {
                case UINT
                   | HEX:
                    _local_2 = (!(ASCompat.toUInt(this._value) == ASCompat.toUInt(k)));
                    
                case INT:
                    _local_2 = (!(ASCompat.toInt(this._value) == ASCompat.toInt(k)));
                    
                case NUMBER:
                    _local_2 = (!(ASCompat.toNumber(this._value) == ASCompat.toNumber(k)));
                    
                case BOOLEAN:
                    _local_2 = (!(ASCompat.toBool(this._value) == ASCompat.toBool(k)));
                    
                case STRING:
                    _local_2 = (!(ASCompat.toString(this._value) == ASCompat.toString(k)));
                    
                case ARRAY:
                    _local_3 = ASCompat.dynamicAs(this._value , Array);
                    _local_4 = ASCompat.dynamicAs(k , Array);
                    if ((((!(_local_3 == null)) && (!(_local_4 == null))) && (_local_3.length == _local_4.length)))
                    {
                        _local_2 = false;
                        _local_5 = 0;
                        while (_local_5 < _local_4.length)
                        {
                            if (_local_3[_local_5] != _local_4[_local_5])
                            {
                                _local_2 = true;
                                break;
                            }
                            _local_5++;
                        }
                    }
                    
            }
            if (_local_2)
            {
                return new PropertyStruct(this._key, k, this.type, true, this._range);
            }
            return this;
        }

        public function toString():String
        {
            switch (this._type)
            {
                case HEX:
                    return "0x" + ASCompat.toRadix(ASCompat.toUInt(this._value), 16);
                case BOOLEAN:
                    return (ASCompat.toBool(this._value) == true) ? "true" : "false";
                case POINT:
                    return ((("Point(" + Std.string(cast(this._value, Point).x)) + ", ") + Std.string(cast(this._value, Point).y)) + ")";
                case RECTANGLE:
                    return ((((((("Rectangle(" + Std.string(cast(this._value, Rectangle).x)) + ", ") + Std.string(cast(this._value, Rectangle).y)) + ", ") + Std.string(cast(this._value, Rectangle).width)) + ", ") + Std.string(cast(this._value, Rectangle).height)) + ")";
            }
            return ASCompat.toString(this.value);
        }

        public function toXMLString():String
        {
            var k:String = null;
            var _local_2 = 0;
            var _local_3:Map = null;
            var _local_4:Array<ASAny> = null;
            var _local_5:Point = null;
            var _local_6:Rectangle = null;
            switch (this._type)
            {
                case MAP:
                    _local_3 = ASCompat.dynamicAs(this._value , Map);
                    k = (((('<var key="' + this._key) + '">\r<value>\r<') + this._type) + ">\r");
                    _local_2 = 0;
                    while ((_local_2 : UInt) < _local_3.length)
                    {
                        k = (k + (((((('<var key="' + _local_3.getKey(_local_2)) + '" value="') + _local_3.getWithIndex(_local_2)) + '" type="') + getQualifiedClassName(_local_3.getWithIndex(_local_2))) + '" />\r'));
                        _local_2++;
                    }
                    k = (k + (("</" + this._type) + ">\r</value>\r</var>"));
                    
                case ARRAY:
                    _local_4 = ASCompat.dynamicAs(this._value , Array);
                    k = (((('<var key="' + this._key) + '">\r<value>\r<') + this._type) + ">\r");
                    _local_2 = 0;
                    while (_local_2 < _local_4.length)
                    {
                        k = (k + (((((('<var key="' + Std.string(_local_2)) + '" value="') + _local_4[_local_2]) + '" type="') + getQualifiedClassName(_local_4[_local_2])) + '" />\r'));
                        _local_2++;
                    }
                    k = (k + (("</" + this._type) + ">\r</value>\r</var>"));
                    
                case POINT:
                    _local_5 = ASCompat.dynamicAs(this._value , Point);
                    k = (((('<var key="' + this._key) + '">\r<value>\r<') + this._type) + ">\r");
                    k = (k + (((('<var key="x" value="' + Std.string(_local_5.x)) + '" type="') + INT) + '" />\r'));
                    k = (k + (((('<var key="y" value="' + Std.string(_local_5.y)) + '" type="') + INT) + '" />\r'));
                    k = (k + (("</" + this._type) + ">\r</value>\r</var>"));
                    
                case RECTANGLE:
                    _local_6 = ASCompat.dynamicAs(this._value , Rectangle);
                    k = (((('<var key="' + this._key) + '">\r<value>\r<') + this._type) + ">\r");
                    k = (k + (((('<var key="x" value="' + Std.string(_local_6.x)) + '" type="') + INT) + '" />\r'));
                    k = (k + (((('<var key="y" value="' + Std.string(_local_6.y)) + '" type="') + INT) + '" />\r'));
                    k = (k + (((('<var key="width" value="' + Std.string(_local_6.width)) + '" type="') + INT) + '" />\r'));
                    k = (k + (((('<var key="height" value="' + Std.string(_local_6.height)) + '" type="') + INT) + '" />\r'));
                    k = (k + (("</" + this._type) + ">\r</value>\r</var>"));
                    
                case HEX:
                    k = ((((((('<var key="' + this._key) + '" value="') + "0x") + ASCompat.toRadix(ASCompat.toUInt(this._value), 16)) + '" type="') + this._type) + '" />');
                    
                default:
                    k = (((((('<var key="' + this._key) + '" value="') + this._value) + '" type="') + this._type) + '" />');
            }
            return k;
        }
    }

