package adobe.serialization.json
;

     class JSONEncoder 
    {
        var jsonString:String;

        public function new(value:ASAny)
        {
            this.jsonString = this.convertToString(value);
        }

        public function getString():String
        {
            return this.jsonString;
        }

        function convertToString(value:ASAny):String
        {
            if (Std.is(value , String))
            {
                return this.escapeString(ASCompat.asString(value ));
            }
            if (Std.is(value , Float))
            {
                return Math.isFinite(ASCompat.asNumber(value )) ? Std.string(value) : "null";
            }
            if (Std.is(value , Bool))
            {
                return value ? "true" : "false";
            }
            if (Std.is(value , Array))
            {
                return this.arrayToString(ASCompat.dynamicAs(value , Array));
            }
            if (ASCompat.isVector(value , (_ : ASAny)))
            {
                return this.vectorToString(value);
            }
            if (((value != null) && (!(value == null))))
            {
                return this.objectToString(value);
            }
            return "null";
        }

        function escapeString(str:String):String
        {
            var ch:String = null;
            var hexCode:String = null;
            var zeroPad:String = null;
            var s= "";
            var len:Float = str.length;
            var i = 0;
            while (i < len)
            {
                ch = str.charAt(i);
                switch (ch)
                {
                    case '"':
                        s = (s + '\\"');
                        
                    case "\\":
                        s = (s + "\\\\");
                        
                    case "\x08":
                        s = (s + "\\b");
                        
                    case "\x0C":
                        s = (s + "\\f");
                        
                    case "\n":
                        s = (s + "\\n");
                        
                    case "\r":
                        s = (s + "\\r");
                        
                    case "\t":
                        s = (s + "\\t");
                        
                    default:
                        if (ch < " ")
                        {
                            hexCode = ASCompat.toRadix(ch.charCodeAt(0), 16);
                            zeroPad = ((hexCode.length == 2) ? "00" : "000");
                            s = (s + (("\\u" + zeroPad) + hexCode));
                        }
                        else
                        {
                            s = (s + ch);
                        }
                }
                i++;
            }
            return ('"' + s) + '"';
        }

        function arrayToString(a:Array<ASAny>):String
        {
            var s= "";
            var length= a.length;
            var i = 0;
            while (i < length)
            {
                if (s.length > 0)
                {
                    s = (s + ",");
                }
                s = (s + this.convertToString(a[i]));
                i++;
            }
            return ("[" + s) + "]";
        }

        function vectorToString(a:Vector<ASAny>):String
        {
            var s= "";
            var length= a.length;
            var i = 0;
            while (i < length)
            {
                if (s.length > 0)
                {
                    s = (s + ",");
                }
                s = (s + this.convertToString(a[i]));
                i++;
            }
            return ("[" + s) + "]";
        }

        function objectToString(o:ASObject):String
        {
var key:String  = null;            var value:ASObject = null;
            var key:String = null;
            var v:com.sulake.core.utils.xml.XML = null;
            var s= "";
            var classInfo= ASCompat.describeType(o);
            if (classInfo.attribute("name").toString() == "Object")
            {
                if (checkNullIteratee(o)) for (_tmp_ in o.___keys())
                {
key = _tmp_;
                    value = ASCompat.getDynamicProperty(o, key);
                    if (Reflect.isFunction(value ))
                    {
                    }
                    else
                    {
                        if (s.length > 0)
                        {
                            s = (s + ",");
                        }
                        s = (s + ((this.escapeString(key) + ":") + this.convertToString(value)));
                    }
                }
            }
            else
            {
                final _iter_ = classInfo.descendants("*").filterVariablesAndReadableAccessors(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
v  = _tmp_;
                    if (((v.child("metadata") != null) && (v.child("metadata").filterAttributeEquals("name", "Transient").length() > 0)))
                    {
                    }
                    else
                    {
                        if (s.length > 0)
                        {
                            s = (s + ",");
                        }
                        s = (s + ((this.escapeString(v.attribute("name").toString()) + ":") + this.convertToString(ASCompat.getDynamicProperty(o, v.attribute("name").toString()))));
                    }
                }
            }
            return ("{" + s) + "}";
        }
    }
//package adobe.serialization.json
