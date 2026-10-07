package com.sulake.core.window.utils
;
    import com.sulake.core.utils.Map;
    import flash.events.IEventDispatcher;
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import flash.events.Event;
    import flash.text.StyleSheet;

     class TextStyleManager 
    {
        public static inline final REGULAR= "regular";
        public static inline final ITALIC= "italic";
        public static inline final BOLD= "bold";
        static var _styleSheetMap:Map;
        static var _styleSheetNames:Array<ASAny>;
        static var _eventDispatcher:IEventDispatcher;
        static inline final TAG_OPEN= "{";
        static inline final TAG_CLOSE= "}";
        static inline final CMT_OPEN= "/*";
        static inline final CMT_CLOSE= "*/";


        public static var events(get,never):IEventDispatcher;
public static function  get_events():IEventDispatcher
        {
            return _eventDispatcher;
        }

        static function init()
        {
            var textStyle:TextStyle = null;
            _styleSheetMap = new Map();
            _styleSheetNames = new Array<ASAny>();
            _eventDispatcher = new EventDispatcherWrapper();
            textStyle = new TextStyle();
            textStyle.name = REGULAR;
            textStyle.color = 0;
            textStyle.fontSize = "9";
            textStyle.fontFamily = "Courier";
            textStyle.fontStyle = "normal";
            textStyle.fontWeight = "normal";
            _styleSheetMap.setProperty(textStyle.name, textStyle);
            _styleSheetNames.push(textStyle.name);
            textStyle = new TextStyle();
            textStyle.name = ITALIC;
            textStyle.color = 0;
            textStyle.fontSize = "9";
            textStyle.fontFamily = "Courier";
            textStyle.fontStyle = "italic";
            textStyle.fontWeight = "normal";
            _styleSheetMap.setProperty(textStyle.name, textStyle);
            _styleSheetNames.push(textStyle.name);
            textStyle = new TextStyle();
            textStyle.name = BOLD;
            textStyle.color = 0;
            textStyle.fontSize = "9";
            textStyle.fontFamily = "Courier";
            textStyle.fontStyle = "normal";
            textStyle.fontWeight = "bold";
            _styleSheetMap.setProperty(textStyle.name, textStyle);
            _styleSheetNames.push(textStyle.name);
        }

        public static function getStyle(k:String):TextStyle
        {
            return _styleSheetMap.getValue(k);
        }

        public static function getStyleWithIndex(k:Int):TextStyle
        {
            return _styleSheetMap.getWithIndex(k);
        }

        public static function setStyle(k:String, _arg_2:TextStyle)
        {
            var _local_3:ASAny = (!_styleSheetMap.hasKey(k));
            _arg_2.name = k;
            _styleSheetMap.setProperty(k, _arg_2);
            if (_local_3)
            {
                _styleSheetNames.push(k);
                _eventDispatcher.dispatchEvent(new Event(Event.ADDED));
            }
            else
            {
                _eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
            }
        }

        public static function setStyles(k:Array<ASAny>, _arg_2:Bool=false)
        {
            var _local_4:TextStyle = null;
            var _local_5:Array<ASAny> = null;
            if (_arg_2)
            {
                _local_5 = [_styleSheetMap.getValue(REGULAR), _styleSheetMap.getValue(ITALIC), _styleSheetMap.getValue(BOLD)];
                _styleSheetMap.reset();
                _styleSheetMap.setProperty(REGULAR, _local_5[0]);
                _styleSheetMap.setProperty(ITALIC, _local_5[1]);
                _styleSheetMap.setProperty(BOLD, _local_5[2]);
            }
            var _local_3= ASCompat.toInt(_styleSheetMap.length);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_4  = _tmp_;
                _styleSheetMap.setProperty(_local_4.name, _local_4);
                if (_styleSheetNames.indexOf(_local_4.name) == -1)
                {
                    _styleSheetNames.push(_local_4.name);
                }
            }
            _eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
            if (_styleSheetMap.length != (_local_3 : UInt))
            {
                _eventDispatcher.dispatchEvent(new Event(Event.ADDED));
            }
        }

        public static function findMatchingTextStyle(k:String):TextStyle
        {
            var _local_3:TextStyle = null;
            var _local_2= ASCompat.dynamicAs(parseCSS(k)[0] , TextStyle);
            if (_local_2 != null)
            {
                _local_3 = _styleSheetMap.getValue(_local_2.name);
                if (((_local_3 != null) && _local_3.equals(_local_2)))
                {
                    return _local_3;
                }
            }
            return null;
        }

        public static function enumerateStyles():Array<ASAny>
        {
            var k= new Array<ASAny>();
            var _local_2= ASCompat.toInt(_styleSheetMap.length);
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                k.push(_styleSheetMap.getWithIndex(_local_3));
                _local_3++;
            }
            return k;
        }

        public static function enumerateStyleNames():Array<ASAny>
        {
            return _styleSheetMap.getKeys();
        }

        public static function getStyleNameArrayRef():Array<ASAny>
        {
            return _styleSheetNames;
        }

        public static function parseCSS(k:String):Array<ASAny>
        {
            var _local_5:ASObject = null;
            var _local_6:TextStyle = null;
            var _local_7:String = null;
            var _local_2= new StyleSheet();
            _local_2.parseCSS(k);
            var _local_3= parseStyleNamesFromCSS(k);
            var _local_4= new Array<ASAny>();
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_7  = _tmp_;
                _local_5 = _local_2.getStyle(_local_7);
                _local_6 = new TextStyle();
                _local_6.name = _local_7;
                _local_6.color = (_local_5.color ? ASCompat.toUInt(ASCompat.stringReplace(ASCompat.toString(_local_5.color), "#", "0x")) : null);
                _local_6.fontFamily = (_local_5.fontFamily ? _local_5.fontFamily : null);
                _local_6.fontSize = (_local_5.fontSize ? ASCompat.parseInt(ASCompat.toString(_local_5.fontSize)) : null);
                _local_6.fontStyle = (_local_5.fontStyle ? _local_5.fontStyle : null);
                _local_6.fontWeight = (_local_5.fontWeight ? _local_5.fontWeight : null);
                _local_6.kerning = (_local_5.kerning ? (_local_5.kerning == "true") : null);
                _local_6.leading = (_local_5.leading ? ASCompat.parseInt(ASCompat.toString(_local_5.leading)) : null);
                _local_6.letterSpacing = (_local_5.letterSpacing ? ASCompat.parseInt(Std.string(_local_5.letterSpacing)) : null);
                _local_6.textDecoration = (_local_5.textDecoration ? _local_5.textDecoration : null);
                _local_6.textIndent = (_local_5.textIndent ? ASCompat.parseInt(Std.string(_local_5.textIndent)) : null);
                _local_6.antiAliasType = (_local_5.antiAliasType ? _local_5.antiAliasType : null);
                _local_6.sharpness = (_local_5.sharpness ? ASCompat.parseInt(_local_5.sharpness) : null);
                _local_6.thickness = (_local_5.thickness ? ASCompat.parseInt(_local_5.thickness) : null);
                _local_6.etchingColor = (_local_5.etchingColor ? ASCompat.toUInt(ASCompat.stringReplace(ASCompat.toString(_local_5.etchingColor), "#", "0x")) : null);
                _local_6.etchingPosition = (_local_5.etchingPosition ? ASCompat.toString(_local_5.etchingPosition) : null);
                _local_4.push(_local_6);
            }
            return _local_4;
        }

        static function parseStyleNamesFromCSS(k:String):Array<ASAny>
        {
            var _local_5:String = null;
            var _local_2:Array<ASAny> = [];
            var _local_3= k;
            _local_3 = _local_3.split("\t").join("");
            _local_3 = _local_3.split("\n").join("");
            _local_3 = _local_3.split("\r").join("");
            var _local_4:Array<ASAny> = (cast _local_3.split(TAG_CLOSE));
            if (countSubStrings(k, TAG_OPEN) != countSubStrings(k, TAG_CLOSE))
            {
                throw new ASError((((('Mismatching amount of "' + TAG_OPEN) + '" versus "') + TAG_CLOSE) + '", please check the CSS!'));
            }
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_5  = _tmp_;
                while (true)
                {
                    if (_local_5.indexOf(CMT_OPEN) == 0)
                    {
                        _local_5 = _local_5.substring((_local_5.indexOf(CMT_CLOSE) + 2), _local_5.length);
                    }
                    else
                    {
                        break;
                    }
                }
                _local_5 = _local_5.substring(0, _local_5.indexOf(TAG_OPEN)).split(" ").join("");
                if (_local_5.length != 0)
                {
                    _local_2.push(_local_5);
                }
            }
            return _local_2;
        }

        static function countSubStrings(k:String, _arg_2:String):Int
        {
            var _local_3 = 0;
            var _local_4 = 0;
            while ((_local_4 = k.indexOf(_arg_2, _local_4)) != -1)
            {
                _local_4++;
                _local_3++;
            }
            return _local_3;
        }

        public static function toString():String
        {
            var _local_3:TextStyle = null;
            var k= enumerateStyles();
            var _local_2= "";
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_2 = (_local_2 + (_local_3.toString() + "\n\n"));
            }
            return _local_2;
        }

	public function new() {}

	static final ___init = {

        {
            init();
        }

	null;
	};
    }

