package com.sulake.core.window.graphics
;
    import com.sulake.core.utils.Map;
    import com.sulake.core.utils.XMLVariableParser;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.graphics.renderer.SkinLayout;
    import com.sulake.core.window.graphics.renderer.SkinLayoutEntity;
    import flash.geom.Rectangle;
    import com.sulake.core.window.graphics.renderer.BitmapSkinTemplate;
    import com.sulake.core.window.graphics.renderer.BitmapSkinTemplateEntity;
    import com.sulake.core.window.graphics.renderer.ISkinLayout;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.graphics.renderer.*;

     class BitmapSkinParser 
    {
        public static inline final _Str_3752= "default"; //"_Str_26452";
        public static inline final ACTIVE= "active";
        public static inline final FOCUSED= "focused";
        public static inline final HOVERING= "hovering";
        public static inline final SELECTED= "selected";
        public static inline final PRESSED= "pressed";
        public static inline final DISABLED= "disabled";
        public static inline final LOCKED= "locked";


        public static function _Str_24598(k:com.sulake.core.utils.xml.XML, _arg_2:com.sulake.core.utils.xml.XMLList, _arg_3:ISkinRenderer, _arg_4:String, _arg_5:IAssetLibrary)
        {
            var _local_12:com.sulake.core.utils.xml.XML = null;
            var _local_13:com.sulake.core.utils.xml.XMLList = null;
            var _local_14:com.sulake.core.utils.xml.XMLList = null;
            var _local_15:UInt = 0;
            var _local_16:UInt = 0;
            var _local_17:com.sulake.core.utils.xml.XML = null;
            var _local_18:com.sulake.core.utils.xml.XMLList = null;
            var _local_19:UInt = 0;
            var _local_20:UInt = 0;
            var _local_21:UInt = 0;
            var _local_22:com.sulake.core.utils.xml.XML = null;
            var _local_6= new Map();
            var _local_7= k.child("variables");
            if (_local_7.length() > 0)
            {
                _local_12 = _local_7.at(0);
                _local_13 = _local_12.child("variable");
                if (_local_13.length() != 0)
                {
                    XMLVariableParser.parseVariableList(_local_13, _local_6);
                }
            }
            var _local_8= new ASDictionary<ASAny,ASAny>();
            var _local_9= k.child("templates");
            if (_local_9.at(0) != null)
            {
                _Str_21258(_arg_3, _local_9.at(0), _local_8, _local_6, _arg_5);
            }
            var _local_10= new ASDictionary<ASAny,ASAny>();
            var _local_11= k.child("layouts");
            if (_local_11.at(0) != null)
            {
                if (_arg_4 == null)
                {
                    _Str_20069(_arg_3, _local_11.at(0), _local_10, _local_6);
                }
                else
                {
                    _local_14 = _local_11.at(0).child("layout");
                    _local_15 = _local_14.length();
                    _local_16 = 0;
                    while (_local_16 < _local_15)
                    {
                        _local_17 = _local_14.at(_local_16);
                        if (com.sulake.core.utils.xml.XML.equalsStringOperands(_local_17.attribute("name") , _arg_4))
                        {
                            _Str_14183(_arg_3, _local_17, _local_10, _local_6);
                            break;
                        }
                        _local_16++;
                    }
                }
            }
            if (_arg_2.length() == 0)
            {
                _arg_2 = k.child("states");
            }
            if (_arg_2.length() > 0)
            {
                if (_arg_4 == null)
                {
                    _Str_20407(_arg_3, _arg_2.at(0), _local_10, _local_6);
                }
                else
                {
                    _local_18 = _arg_2.at(0).child("state");
                    _local_19 = _local_18.length();
                    _local_20 = 0;
                    _local_21 = 0;
                    while (_local_21 < _local_19)
                    {
                        _local_22 = _local_18.at(_local_21);
                        if (com.sulake.core.utils.xml.XML.equalsStringOperands(_local_22.attribute("layout") , _arg_4))
                        {
                            _Str_14229(_arg_3, _local_22, _local_10, _local_6);
                            _local_20++;
                        }
                        _local_21++;
                    }
                }
            }
        }

        static function _Str_14183(k:ISkinRenderer, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:ASDictionary<ASAny,ASAny>, _arg_4:Map)
        {
            var _local_10:com.sulake.core.utils.xml.XML = null;
            var _local_11:com.sulake.core.utils.xml.XMLList = null;
            var _local_5= ASCompat.xmlListToString(_arg_2.attribute("name"));
            var _local_6:ASAny = com.sulake.core.utils.xml.XML.equalsStringOperands(_arg_2.attribute("transparent") , "true");
            var _local_7= ASCompat.xmlListToString(_arg_2.attribute("blendMode"));
            var _local_8= new SkinLayout(_local_5, _local_6, _local_7);
            var _local_9= _arg_2.child("entities");
            if (_local_9.length() > 0)
            {
                _local_10 = _local_9.at(0);
                _local_11 = _local_10.child("entity");
                if (_local_11.length() != 0)
                {
                    _Str_20380(k, _local_8, _local_11, _arg_4);
                }
            }
            _arg_3[_local_5] = _local_8;
            k._Str_20341(_local_8);
        }

        static function _Str_20069(k:ISkinRenderer, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:ASDictionary<ASAny,ASAny>, _arg_4:Map)
        {
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_5= _arg_2.child("layout");
            var _local_6:UInt = _local_5.length();
            var _local_7:UInt = 0;
            while (_local_7 < _local_6)
            {
                _local_8 = _local_5.at(_local_7);
                _Str_14183(k, _local_8, _arg_3, _arg_4);
                _local_7++;
            }
        }

        static function _Str_21102(k:com.sulake.core.utils.xml.XML, _arg_2:Map):SkinLayoutEntity
        {
            var _local_3:UInt = 0;
            var _local_4:String = null;
            var _local_5:SkinLayoutEntity = null;
            var _local_6:String = null;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:com.sulake.core.utils.xml.XMLList = null;
            _local_6 = ASCompat.xmlListToString(k.attribute("id"));
            _local_3 = ASCompat.toUInt((_local_6 == null) ? 0 : ASCompat.toUInt(_local_6));
            _local_6 = ASCompat.xmlListToString(k.attribute("name"));
            _local_4 = ((_local_6 == null) ? "" : _local_6);
            _local_5 = new SkinLayoutEntity(_local_3, _local_4);
            _local_6 = ASCompat.xmlListToString(k.attribute("colorize"));
            _local_5.colorize = ((_local_6 == "") ? true : (_local_6 == "true"));
            _local_6 = ASCompat.xmlListToString(k.attribute("colorizeMethod"));
            _local_5.colorizeMethod = ((_local_6 == "") ? SkinLayoutEntity.COLORIZE_METHOD_MULTIPLY : _local_6);
            _local_6 = ASCompat.xmlListToString(k.attribute("shade"));
            _local_5.shade = ((_local_6 == "") ? 0 : ASCompat.toNumber(_local_6));
            _local_6 = null;
            _local_8 = k.child("color");
            if (_local_8.length() > 0)
            {
                _local_7 = _local_8.at(0);
                _local_6 = _local_7.toString();
                if (_local_6 != null)
                {
                    if (_local_6.charAt(0) == "$")
                    {
                        _local_6 = _arg_2.getValue(_local_6.substring(1, _local_6.length));
                    }
                }
            }
            _local_5.color = ASCompat.toUInt((_local_6 == null) ? 0 : ASCompat.toUInt(_local_6));
            _local_6 = null;
            _local_8 = k.child("blend");
            if (_local_8.length() > 0)
            {
                _local_7 = _local_8.at(0);
                _local_6 = _local_7.toString();
                if (_local_6 != null)
                {
                    if (_local_6.charAt(0) == "$")
                    {
                        _local_6 = _arg_2.getValue(_local_6.substring(1, _local_6.length));
                    }
                }
            }
            _local_5.blend = ((_local_6 == null) ? 0xFFFFFFFF : ASCompat.toUInt(_local_6));
            _local_8 = k.child("scale");
            if (_local_8.length() > 0)
            {
                _local_7 = _local_8.at(0);
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("horizontal"));
                if (_local_6 != null)
                {
                    if (_local_6.charAt(0) == "$")
                    {
                        _local_6 = _arg_2.getValue(_local_6.substring(1, _local_6.length));
                    }
                }
                switch (_local_6.toLowerCase())
                {
                    case "fixed":
                        _local_5.scaleH = SkinLayoutEntity.SCALE_TYPE_FIXED;
                        
                    case "move":
                        _local_5.scaleH = SkinLayoutEntity.SCALE_TYPE_MOVE;
                        
                    case "strech":
                        _local_5.scaleH = SkinLayoutEntity.SCALE_TYPE_STRECH;
                        
                    case "tiled":
                        _local_5.scaleH = SkinLayoutEntity.SCALE_TYPE_TILED;
                        
                    case "center":
                        _local_5.scaleH = SkinLayoutEntity.SCALE_TYPE_CENTER;
                        
                }
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("vertical"));
                if (_local_6 != null)
                {
                    if (_local_6.charAt(0) == "$")
                    {
                        _local_6 = _arg_2.getValue(_local_6.substring(1, _local_6.length));
                    }
                }
                switch (_local_6.toLowerCase())
                {
                    case "fixed":
                        _local_5.scaleV = SkinLayoutEntity.SCALE_TYPE_FIXED;
                        
                    case "move":
                        _local_5.scaleV = SkinLayoutEntity.SCALE_TYPE_MOVE;
                        
                    case "strech":
                        _local_5.scaleV = SkinLayoutEntity.SCALE_TYPE_STRECH;
                        
                    case "tiled":
                        _local_5.scaleV = SkinLayoutEntity.SCALE_TYPE_TILED;
                        
                    case "center":
                        _local_5.scaleV = SkinLayoutEntity.SCALE_TYPE_CENTER;
                        
                }
            }
            _local_8 = k.child("region");
            if (_local_8.length() > 0)
            {
                _local_7 = _local_8.at(0);
                _local_8 = _local_7.child("Rectangle");
                _local_7 = _local_8.at(0);
                _local_5.region = new Rectangle();
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("x"));
                _local_5.region.x = ASCompat.toNumber(((_local_6.charAt(0) == "$") ? _arg_2.getValue(_local_6.substring(1, _local_6.length)): _local_6));
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("y"));
                _local_5.region.y = ASCompat.toNumber(((_local_6.charAt(0) == "$") ? _arg_2.getValue(_local_6.substring(1, _local_6.length)): _local_6));
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("width"));
                _local_5.region.width = ASCompat.toNumber(((_local_6.charAt(0) == "$") ? _arg_2.getValue(_local_6.substring(1, _local_6.length)): _local_6));
                _local_6 = ASCompat.xmlListToString(_local_7.attribute("height"));
                _local_5.region.height = ASCompat.toNumber(((_local_6.charAt(0) == "$") ? _arg_2.getValue(_local_6.substring(1, _local_6.length)): _local_6));
            }
            return _local_5;
        }

        static function _Str_20380(k:ISkinRenderer, _arg_2:SkinLayout, _arg_3:com.sulake.core.utils.xml.XMLList, _arg_4:Map)
        {
            var _local_5:SkinLayoutEntity = null;
            var _local_6:UInt = 0;
            var _local_7:UInt = _arg_3.length();
            _local_6 = 0;
            while (_local_6 < _local_7)
            {
                _local_5 = _Str_21102(_arg_3.at(_local_6), _arg_4);
                if (_local_5 != null)
                {
                    _arg_2.addChild(_local_5);
                }
                _local_6++;
            }
        }

        static function _Str_21258(k:ISkinRenderer, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:ASDictionary<ASAny,ASAny>, _arg_4:Map, _arg_5:IAssetLibrary)
        {
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_12:BitmapSkinTemplate = null;
            var _local_13:com.sulake.core.utils.xml.XMLList = null;
            var _local_14:com.sulake.core.utils.xml.XML = null;
            var _local_15:com.sulake.core.utils.xml.XMLList = null;
            var _local_6= _arg_2.child("template");
            var _local_7:UInt = _local_6.length();
            var _local_8:UInt = 0;
            while (_local_8 < _local_7)
            {
                _local_9 = _local_6.at(_local_8);
                _local_10 = ASCompat.xmlListToString(_local_9.attribute("name"));
                if (_local_10 != null)
                {
                    if (_local_10.charAt(0) == "$")
                    {
                        _local_10 = _arg_4.getValue(_local_10.substring(1, _local_10.length));
                    }
                }
                _local_11 = ASCompat.xmlListToString(_local_9.attribute("asset"));
                if (_local_11 != null)
                {
                    if (_local_11.charAt(0) == "$")
                    {
                        _local_11 = _arg_4.getValue(_local_11.substring(1, _local_11.length));
                    }
                }
                _local_12 = new BitmapSkinTemplate(_local_10, _arg_5.getAssetByName(_local_11));
                _local_13 = _local_9.child("entities");
                if (_local_13.length() > 0)
                {
                    _local_14 = _local_13.at(0);
                    _local_15 = _local_14.child("entity");
                    if (_local_15.length() != 0)
                    {
                        _Str_20083(k, _local_12, _local_15, _arg_4);
                    }
                }
                _arg_3[_local_10] = _local_12;
                k._Str_21576(_local_12);
                _local_8++;
            }
        }

        static function _Str_20083(k:ISkinRenderer, _arg_2:BitmapSkinTemplate, _arg_3:com.sulake.core.utils.xml.XMLList, _arg_4:Map)
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7:com.sulake.core.utils.xml.XML = null;
            var _local_8:com.sulake.core.utils.xml.XMLList = null;
            var _local_9:com.sulake.core.utils.xml.XML = null;
            var _local_10:String = null;
            var _local_11:String = null;
            var _local_12:String = null;
            var _local_13:UInt = 0;
            var _local_14:Rectangle = null;
            var _local_16 = 0;
            var _local_15= _arg_3.length();
            _local_16 = 0;
            while (_local_16 < _local_15)
            {
                _local_5 = _arg_3.at(_local_16);
                _local_10 = ASCompat.xmlListToString(_local_5.attribute("name"));
                _local_11 = ((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10);
                _local_10 = ASCompat.xmlListToString(_local_5.attribute("type"));
                _local_12 = ((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10);
                _local_10 = ASCompat.xmlListToString(_local_5.attribute("id"));
                _local_13 = ASCompat.toUInt(((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10));
                _local_6 = _local_5.child("region");
                if (_local_6.length() > 0)
                {
                    _local_7 = _local_6.at(0);
                    _local_6 = _local_7.child("Rectangle");
                    _local_7 = _local_6.at(0);
                    _local_14 = new Rectangle();
                    _local_10 = ASCompat.xmlListToString(_local_7.attribute("x"));
                    _local_14.x = ASCompat.toNumber(((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10));
                    _local_10 = ASCompat.xmlListToString(_local_7.attribute("y"));
                    _local_14.y = ASCompat.toNumber(((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10));
                    _local_10 = ASCompat.xmlListToString(_local_7.attribute("width"));
                    _local_14.width = ASCompat.toNumber(((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10));
                    _local_10 = ASCompat.xmlListToString(_local_7.attribute("height"));
                    _local_14.height = ASCompat.toNumber(((_local_10.charAt(0) == "$") ? _arg_4.getValue(_local_10.substring(1, _local_10.length)): _local_10));
                }
                _arg_2.addChild(new BitmapSkinTemplateEntity(_local_11, _local_12, _local_13, _local_14));
                _local_16++;
            }
        }

        static function _Str_14229(k:ISkinRenderer, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:ASDictionary<ASAny,ASAny>, _arg_4:Map)
        {
var _local_14:String  = null;            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12:com.sulake.core.utils.xml.XMLList = null;
            var _local_13:Map = null;
            var _local_14:String = null;
            var _local_15:ASObject = null;
            var _local_5= ASCompat.xmlListToString(_arg_2.attribute("name"));
            if (_local_5.charAt(0) == "$")
            {
                _local_5 = _arg_4.getValue(_local_5.substring(1, _local_5.length));
            }
            var _local_6= ASCompat.xmlListToString(_arg_2.attribute("layout"));
            if (_local_6.charAt(0) == "$")
            {
                _local_6 = _arg_4.getValue(_local_6.substring(1, _local_6.length));
            }
            var _local_7= ASCompat.xmlListToString(_arg_2.attribute("template"));
            if (_local_7.charAt(0) == "$")
            {
                _local_7 = _arg_4.getValue(_local_7.substring(1, _local_7.length));
            }
            var _local_8:ISkinLayout = _arg_3[_local_6];
            if (_local_8 == null)
            {
                throw new ASError((((("State " + _local_5) + " has invalid layout reference ") + _local_6) + "!"));
            }
            var _local_9= _arg_2.child("variables");
            if (_local_9.length() > 0)
            {
                _local_11 = _local_9.at(0);
                _local_12 = _local_11.child("variable");
                if (_local_12.length() != 0)
                {
                    _local_13 = new Map();
                    XMLVariableParser.parseVariableList(_local_12, _local_13);
                    if (checkNullIteratee(_local_13)) for (_tmp_ in _local_13.getKeys())
                    {
_local_14 = _tmp_;
                        _local_15 = _local_13.getValue(_local_14);
                        if (Std.is(_local_15 , String))
                        {
                            if (ASCompat.toString(_local_15).charAt(0) == "$")
                            {
                                _local_15 = _arg_4.getValue(_local_15.slice(1, _local_15.length));
                                _local_13.setProperty(_local_14, _local_15);
                            }
                        }
                    }
                }
            }
            var _local_10= WindowState.DEFAULT;
            switch (_local_5)
            {
                case BitmapSkinParser.ACTIVE:
                    _local_10 = WindowState.ACTIVE;
                    
                case BitmapSkinParser._Str_3752:
                    _local_10 = WindowState.DEFAULT;
                    
                case BitmapSkinParser.FOCUSED:
                    _local_10 = WindowState.FOCUSED;
                    
                case BitmapSkinParser.DISABLED:
                    _local_10 = WindowState.DISABLED;
                    
                case BitmapSkinParser.HOVERING:
                    _local_10 = WindowState.HOVERING;
                    
                case BitmapSkinParser.PRESSED:
                    _local_10 = WindowState.PRESSED;
                    
                case BitmapSkinParser.SELECTED:
                    _local_10 = WindowState.SELECTED;
                    
                case BitmapSkinParser.LOCKED:
                    _local_10 = WindowState.LOCKED;
                    
                default:
                    throw new ASError((('Unknown window state: "' + _local_5) + '"!'));
            }
            k._Str_21977(_local_10, _local_6);
            k._Str_19639(_local_10, _local_7);
        }

        static function _Str_20407(k:ISkinRenderer, _arg_2:com.sulake.core.utils.xml.XML, _arg_3:ASDictionary<ASAny,ASAny>, _arg_4:Map)
        {
            var _local_5= _arg_2.child("state");
            var _local_6:UInt = _local_5.length();
            var _local_7:UInt = 0;
            while (_local_7 < _local_6)
            {
                _Str_14229(k, _local_5.at(_local_7), _arg_3, _arg_4);
                _local_7++;
            }
        }

	public function new() {}
    }

