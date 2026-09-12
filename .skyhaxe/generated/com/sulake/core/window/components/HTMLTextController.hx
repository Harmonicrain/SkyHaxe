package com.sulake.core.window.components
;
    import com.sulake.core.window.theme.PropertyKeys;
    import flash.text.StyleSheet;
    import flash.text.TextFieldType;
    import com.sulake.core.window.WindowContext;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;
    import flash.net.URLRequest;
    import flash.external.ExternalInterface;
    import com.sulake.core.window._enum.LinkTarget;
    import flash.events.TextEvent;
    import com.sulake.core.window.events.WindowLinkEvent;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import flash.events.Event;
    import com.sulake.core.window.utils.PropertyStruct;

     class HTMLTextController extends TextFieldController implements IHTMLTextWindow 
    {
        static inline final HTML_STYLESHEET_KEY= "html_stylesheet";
        static var _Str_8402:String = PropertyKeys.HTML_LINK_TARGET_VALUE;

        var _Str_9241:String;
        var _Str_10277:String = null;
        var _Str_5143:StyleSheet = null;

        public function new(k:String, _arg_2:UInt, _arg_3:UInt, _arg_4:UInt, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:ASFunction, _arg_9:Array<ASAny>=null, _arg_10:Array<ASAny>=null, _arg_11:UInt=0)
        {
            this._Str_9241 = PropertyKeys.HTML_LINK_TARGET_VALUE;
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            this.immediateClickMode = true;
            _field.type = TextFieldType.DYNAMIC;
            _field.mouseEnabled = true;
            _field.selectable = false;
            _field.mouseWheelEnabled = true;
        }

        
        public static var _Str_16826(get,set):String;
public static function  set__Str_16826(k:String):String        {
            return _Str_8402 = k;
        }
public static function  get__Str_16826():String
        {
            return _Str_8402;
        }

        static function _Str_20267(k:HTMLTextController, _arg_2:String)
        {
            var _local_3:StyleSheet = null;
            if (k == null)
            {
                return;
            }
            if (k._Str_10277 == _arg_2)
            {
                return;
            }
            k._Str_10277 = _arg_2;
            k._Str_5143 = null;
            if (k._Str_10277 != null)
            {
                _local_3 = new StyleSheet();
                _local_3.parseCSS(k._Str_10277);
                k._Str_5143 = _local_3;
            }
        }

        static function _Str_8814(k:String):String
        {
            var _local_2:compat.RegExp = null;
            _local_2 = new compat.RegExp("<a[^>]+(http:\\/\\/[^\"']+)['\"][^>]*>(.*)<\\/a>", "gi");
            k = _local_2.replace(k, "<a href='event:$1'>$2</a>");
            _local_2 = new compat.RegExp("<a[^>]+(https:\\/\\/[^\"']+)['\"][^>]*>(.*)<\\/a>", "gi");
            k = _local_2.replace(k, "<a href='event:$1'>$2</a>");
            return k;
        }

        static function _Str_2178(url:String, target:String)
        {
            var userAgent:String = null;
            var request:URLRequest = null;
            var result:ASAny = /*undefined*/null;
            if (target == null)
            {
                target = _Str_8402;
            }
            if (ExternalInterface.available)
            {
                try
                {
                    userAgent = ASCompat.toString(ExternalInterface.call("function() { return navigator.userAgent; }")).toLowerCase();
                }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                 {
                    userAgent = "";
                }
 }                if (((((userAgent.indexOf("safari") > -1) || (userAgent.indexOf("chrome") > -1)) || (userAgent.indexOf("firefox") > -1)) || ((userAgent.indexOf("msie") > -1) && (ASCompat.toUInt(userAgent.substr((userAgent.indexOf("msie") + 5), 3)) >= 7))))
                {
                    try
                    {
                        result = ExternalInterface.call((((("function() {var win = window.open('" + url) + "', '") + target) + "'); if (win) { win.focus();} return true; }"));
                    }
catch (__as3Caught:Dynamic) { var e:ASError = ASError.caught(__as3Caught);                     {
                    }
 }                    if (result)
                    {
                        return;
                    }
                }
                request = new URLRequest(url);
                flash.Lib.getURL(request, target);
            }
        }


        
        public var linkTarget(get,set):String;
public function  set_linkTarget(k:String):String        {
            if (PropertyKeys.HTML_LINK_TARGET_RANGE.indexOf(k) > -1)
            {
                this._Str_9241 = k;
            }
return k;
        }
public function  get_linkTarget():String
        {
            return (this._Str_9241 == LinkTarget.DEFAULT) ? _Str_16826 : this._Str_9241;
        }

        
        public var _Str_21424(get,set):String;
public function  get__Str_21424():String
        {
            return this._Str_10277;
        }
public function  set__Str_21424(k:String):String        {
            _Str_20267(this, k);
return k;
        }

        override public function  set_immediateClickMode(k:Bool):Bool        {
            if (((k == _immediateClickMode) || (_field == null)))
            {
                return k;
            }
            super.immediateClickMode = k;
            if (_immediateClickMode)
            {
                _field.addEventListener(TextEvent.LINK, (this.immediateClickHandler : ASAny));
            }
            else
            {
                _field.removeEventListener(TextEvent.LINK, (this.immediateClickHandler : ASAny));
            }
return k;
        }

        override public function  set_text(k:String):String        {
            if (k == null)
            {
                return k;
            }
            if (_localized)
            {
                context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                _localized = false;
            }
            _caption = k;
            if (((_caption.charAt(0) == "$") && (_caption.charAt(1) == "{")))
            {
                context.registerLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                _localized = true;
            }
            else
            {
                if (_field != null)
                {
                    _field.htmlText = _Str_8814(_caption);
                    refreshTextImage();
                }
            }
return k;
        }

        override public function  set_localization(k:String):String        {
            if (((!(k == null)) && (!(_field == null))))
            {
                _field.htmlText = limitStringLength(_Str_8814(k));
                refreshTextImage();
            }
return k;
        }

        override public function  set_htmlText(k:String):String        {
            if (k == null)
            {
                return k;
            }
            if (_localized)
            {
                context.removeLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                _localized = false;
            }
            _caption = k;
            if (((_caption.charAt(0) == "$") && (_caption.charAt(1) == "{")))
            {
                context.registerLocalizationListener(_caption.substring(2, _caption.indexOf("}")), this);
                _localized = true;
            }
            else
            {
                if (_field != null)
                {
                    _field.htmlText = _Str_8814(_caption);
                    _field.styleSheet = this._Str_5143;
                    refreshTextImage();
                }
            }
return k;
        }

        override function immediateClickHandler(k:Event)
        {
            var _local_2:WindowLinkEvent = null;
            var _local_3 = false;
            var _local_4:ILinkEventTracker = null;
            if (Std.is(k , TextEvent))
            {
                _local_2 = Std.downcast(WindowLinkEvent.allocate(cast(k, TextEvent).text, this, null) , WindowLinkEvent);
                if (_events != null)
                {
                    _events.dispatchEvent(_local_2);
                }
                _local_3 = false;
                final _iter_ = _context.linkEventTrackers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    if (_local_4.linkPattern.length > 0)
                    {
                        if (_local_2.link.substr(0, _local_4.linkPattern.length) == _local_4.linkPattern)
                        {
                            _local_4.linkReceived(_local_2.link);
                            _local_3 = true;
                        }
                    }
                    else
                    {
                        _local_4.linkReceived(_local_2.link);
                    }
                }
                if (!_local_2.isWindowOperationPrevented())
                {
                    if (procedure != null)
                    {
                        procedure(_local_2, this);
                    }
                }
                if ((((!_local_3) && (!_local_2.isWindowOperationPrevented())) && (!(this.linkTarget == LinkTarget.INTERNAL))))
                {
                    _Str_2178(cast(k, TextEvent).text, this.linkTarget);
                }
                k.stopImmediatePropagation();
                _local_2.recycle();
            }
            else
            {
                super.immediateClickHandler(k);
            }
        }

        override public function  get_properties():Array<ASAny>
        {
            var k= InteractiveController._Str_8987(this, super.properties);
            k.push(createProperty(PropertyKeys.EDITABLE, (_field.type == TextFieldType.INPUT)));
            k.push(createProperty(PropertyKeys.FOCUS_CAPTURER, _Str_9948));
            k.push(createProperty(PropertyKeys.SELECTABLE, _field.selectable));
            k.push(createProperty(PropertyKeys.DISPLAY_AS_PASSWORD, _field.displayAsPassword));
            k.push(createProperty(PropertyKeys.DISPLAY_RAW, _displayRaw));
            k.push(createProperty(PropertyKeys.LINK_TARGET, this._Str_9241));
            return k;
        }

        override public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_2:PropertyStruct = null;
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                switch (_local_2.key)
                {
                    case PropertyKeys.LINK_TARGET:
                        this._Str_9241 = ASCompat.asString(_local_2.value );
                        
                    case HTML_STYLESHEET_KEY:
                        this._Str_21424 = ASCompat.asString(_local_2.value );
                        
                }
            }
            return super.properties = k;
        }
    }

